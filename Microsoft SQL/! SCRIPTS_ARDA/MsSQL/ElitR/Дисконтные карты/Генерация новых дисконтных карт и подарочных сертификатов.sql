--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*INFO*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*��������� ����� 13 ������� ������� ���� �� ��������� �� @BChID �� @EChID. ���� ����� ����������, ��� ������������.
� ���� Notes ����������� 5 ������� ��� (��������)(��������� 5 ���� �� 12 �������� ������ �����). 
� ���� InUse �������� 1 (����� ������ � �������������).*/
--r_DCTypes	���������� ���������� ����: ����
--r_DCards	���������� ���������� ����
--r_ProdMQ	���������� ������� - ���� ��������
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] Maslov Oleg '2021-01-14 09:40:26.893' ������� ���������� ����� (��� 1 ��� 2) �� ����� ���������, ��� ��� ��� ������ �������� ����� ����� ���������. ������ ���� UPDATE ��� ����� ����� ��������� ip_CreateDCards13.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*����������� ���������� ���� � ���������� ������������ (�������� ���������: 222 - ��; 223,224,225,226... - ���������� �����������)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE ElitR
GO

BEGIN TRAN 
BEGIN

    --�������� ���������� ������ ��� 4 ��������� (������ � ������, �� ���������, �������).
    DECLARE @qty smallint = 20 --���������� ����� ������������ �������� ������ ������������.
    DECLARE @CardType int = 6 --��� ����� �� "����������� ���������� ����: ����" r_DCTypes (1-���������� �����; 2-���������� ����������)
    /*
     3-������������ ���������� 200 
     4-������������ ���������� 400 
     5-������������ ���������� 600 
     6-������������ ���������� 800
	 35-������������ ���������� 1000
     36-������������ ���������� 3000
     37-������������ ���������� 5000 
     */
    DECLARE @Disc int = 0	--��������� ������� ������.
    DECLARE @BonusSum int = 0  --��������� ����� �������.

    DECLARE @BChID bigint = (select top 1 cast((left(DCardID,12)) as bigint) + 1 from r_DCards where DCTypeCode = @CardType and DCardID not like '25%' ORDER BY DCardID desc)	--��������� 12 ������� ����� �����.
    DECLARE @EChID bigint = @BChID + @qty - 1	--�������� 12 ������� ����� �����.
    
    select '�� ���� ����� ������ �� ��������� �����, ������������ � 25...' 'INFO!'
    select COUNT(*) '����� ����', (SELECT DCTypeName FROM r_DCTypes WHERE DCTypeCode = @CardType) '��� ����' from r_DCards where DCTypeCode = @CardType and DCardID not like '25%'
    select * from r_DCards where DCTypeCode = @CardType and DCardID not like '25%' ORDER BY DCardID desc

    EXEC ip_CreateDCards13 @BChID, @EChID, @CardType, @Disc, @BonusSum --��������� ���������� ���������� ���� ������� ������� � ������ ����������� � �������� ��������� �������� � ���������� ����������� ������ � ������ �������.

	--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    --��� ���������� ������������ ����� �������� ���������, ����� ��� ����� ����������� �� �����.
	if @CardType in (3, 4, 5, 6, 35, 36, 37) --�������� ���� ������������ �� ������������� ��� ��� ����� �����
	BEGIN
	    
		--[CHANGED] Maslov Oleg '2021-01-14 09:40:26.893' ������� ���������� ����� (��� 1 ��� 2) �� ����� ���������, ��� ��� ��� ������ �������� ����� ����� ���������. ������ ���� UPDATE ��� ����� ����� ��������� ip_CreateDCards13.
		--������� ����������� ��������� ��� �������
		update r_DCards 
		set InUse = 0
		where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9'
		  and DCardID not like '25%'
		
		select '��������� ��������� ��� ������������' 

	    INSERT r_ProdMQ (ProdID, UM, Qty, Weight, Notes, BarCode, ProdBarCode, PLID, TareWeight)
			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			and mq.BarCode  is null

			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			--and mq.BarCode  is null
	END;

    --����������� ������.
    select COUNT(*) '����� ����', (SELECT DCTypeName FROM r_DCTypes WHERE DCTypeCode = @CardType) '��� ����' from r_DCards where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9' and DCardID not like '25%'
    select @BChID 'Range: begin', @EChID 'Range: end', @Disc '��������� ������� ������', @BonusSum '��������� ����� �������', '' '���������� ���������� ����: ���� >>', DCTypeCode, DCTypeName, Notes from r_DCTypes WHERE DCTypeCode = @CardType
    select * from r_DCards where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9' and DCardID not like '25%'
    select COUNT(*) '����� ����', (SELECT DCTypeName FROM r_DCTypes WHERE DCTypeCode = @CardType) '��� ����' from r_DCards where DCTypeCode = @CardType and DCardID not like '25%'
    select * from r_DCards where DCTypeCode = @CardType and DCardID not like '25%' ORDER BY DCardID DESC

END;
ROLLBACK TRAN 


 

 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 /*�����*/
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*��������� ���������� ���� (222 - �������� �������� ��� ��)*/
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*USE ElitR
GO

select top 1000 * from r_DCards where DCardID like '222%' ORDER BY DCardID desc

BEGIN TRAN disc_cards
BEGIN
    DECLARE 
     @BChID bigint = 222000043401,	--��������� 12 ������� ����� �����.
     @EChID bigint = 222000044400,	--�������� 12 ������� ����� �����.
     @CardType int = 2, --��� ����� �� "����������� ���������� ����: ����" r_DCTypes (2 - �������������).
     @Disc int = 0,	--��������� ������� ������.
     @BonusSum int = 0  --��������� ����� �������.
 
     EXEC ip_CreateDCards13 @BChID,@EChID,@CardType,@Disc,@BonusSum
 
     SELECT * FROM (
	     select cast(LEFT(DCardID,12) as bigint) DCardID_bigint ,* from r_DCards 
	     where isnumeric(DCardID ) = 1
     ) s1
     where DCardID_bigint between @BChID and @EChID
END;
ROLLBACK TRAN disc_cards

SELECT * FROM r_DCTypes ORDER BY 2
SELECT * FROM r_DCTypeG ORDER BY 2
SELECT * FROM r_DCards where DCTypeCode in (4)
ORDER BY DCTypeCode,3
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*��������� ����� ���������� ��� ������������*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*USE ElitR
GO

BEGIN TRAN cert_barcodes
BEGIN 
	DECLARE @s varchar(40) = '224000000%'
	(SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)
	SELECT cast(ISNULL(SUBSTRING(UM,4,5),0) as int) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) 
	DECLARE @n int
	--SELECT UM, cast(ISNULL(SUBSTRING(UM,5,5),0) as int) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) ORDER BY cast(ISNULL(SUBSTRING(UM,5,5),0) as int) desc
	SELECT @n = max(cast(ISNULL(SUBSTRING(UM,4,5),0) as int)) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) 

	SELECT @n 
	SELECT @n = 290  -- ��������� ������� ���������

	SELECT (SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s) ProdID, 
		'��_' + cast((ROW_NUMBER()OVER(ORDER BY DCardID) + @n ) as varchar) UM, 
		1 Qty, 0 Weight, Notes Notes, DCardID BarCode, DCardID ProdBarCode, 0 PLID, 0 TareWeight
	FROM r_DCards where DCardID like @s and  DCardID not in (SELECT BarCode FROM r_ProdMQ where BarCode like @s)

	INSERT r_ProdMQ (ProdID, UM, Qty, Weight, Notes, BarCode, ProdBarCode, PLID, TareWeight)
	SELECT (SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s) ProdID, 
		'��_' + cast((ROW_NUMBER()OVER(ORDER BY DCardID) + @n ) as varchar) UM, 
		1 Qty, 0 Weight, Notes Notes, DCardID BarCode, DCardID ProdBarCode, 0 PLID, 0 TareWeight
	FROM r_DCards where DCardID like @s and  DCardID not in (SELECT BarCode FROM r_ProdMQ where BarCode like @s)


	SELECT * FROM r_ProdMQ where BarCode like @s  ORDER BY BarCode

	--IF EXISTS (SELECT 1 FROM r_ProdMQ i WHERE 
	--NOT EXISTS (SELECT * FROM r_Uni WHERE RefTypeID = 80021 AND (i.UM = RefName OR i.UM LIKE RefName + '[_][0-9]' OR i.UM LIKE RefName + '[_][0-9][0-9]' OR i.UM LIKE RefName + '[_][0-9][0-9][0-9]')))
END;
ROLLBACK TRAN cert_barcodes
*/

/*
--������ ����� ���������� ����������


BEGIN TRAN


    DECLARE @CardType int = 6 --��� ����� �� "����������� ���������� ����: ����" r_DCTypes


			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			and mq.BarCode  is null

	if @CardType in (3,4,5,6,35,36,37)
	BEGIN
	    select '��������� ��������� ��� ������������' 

	    INSERT r_ProdMQ (ProdID, UM, Qty, Weight, Notes, BarCode, ProdBarCode, PLID, TareWeight)
			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			and mq.BarCode  is null

			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			--and mq.BarCode  is null
	END

ROLLBACK TRAN


*/

