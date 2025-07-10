--��������� ����� 13 ������� ������� ���� �� ��������� �� @BChID �� @EChID
--���� ����� ���������� ��� ������������
--� ���� Notes ����������� 5 ������� ��� (��������)(��������� 5 ����� �� 12 �������� ������ �����) 
--� ���� InUse �������� 1 (����� ������ � �������������)

select top 100 * from r_DCards where DCardID like '222%' ORDER BY DCardID desc
SELECT * FROM r_DCTypes

BEGIN TRAN

DECLARE 
 @BChID bigint = 222000043001,	/* ��������� 12 ������� ����� ����� */
 @EChID bigint = 222000043400,	/* �������� 12 ������� ����� ����� */
 @CardType int = 2, /* ��� ����� �� ����������� ����� ���������� ����(2 - �������������) */
 @Disc int = 0,	/* ��������� ������� ������ */
 @BonusSum int = 0  /* ��������� ����� ������� */
 
 EXEC ip_CreateDCards13 @BChID,@EChID,@CardType,@Disc,@BonusSum
 
 SELECT * FROM (
	 select cast(LEFT(DCardID,12) as bigint) DCardID_bigint ,* from r_DCards 
	 where isnumeric(DCardID ) = 1
 ) s1
 where DCardID_bigint between @BChID and @EChID

ROLLBACK TRAN


SELECT * FROM r_DCTypes ORDER BY 2
SELECT * FROM r_DCTypeG ORDER BY 2
SELECT * FROM r_DCards where DCTypeCode in (4)
ORDER BY DCTypeCode,3


--############################################################################################### 
--############################################################################################### 

--������������ �����������
BEGIN TRAN

DECLARE 
 @BChID bigint = 225000000291,	/* ��������� 12 ������� ����� ����� */
 @EChID bigint = 225000000326,	/* �������� 12 ������� ����� ����� */
 @CardType int = 5, /* ��� ����� �� ����������� ����� ���������� ����(2 - �������������) */
 @Disc int = 0,	/* ��������� ������� ������ */
 @BonusSum int = 0  /* ��������� ����� ������� */
 
 EXEC ip_CreateDCards13 @BChID,@EChID,@CardType,@Disc,@BonusSum
 
 --������� ����������� ��������� ��� �������
 update r_DCards 
 set InUse = 0
 where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9'

 select * from r_DCards where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9'
 
ROLLBACK TRAN


--������������ ����� ��������� ��� ������������
BEGIN TRAN
 
	DECLARE @s varchar(40) = '225000000%'
	DECLARE @n int
	--SELECT UM, cast(ISNULL(SUBSTRING(UM,5,5),0) as int) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) ORDER BY cast(ISNULL(SUBSTRING(UM,5,5),0) as int) desc
	SELECT @n = max(cast(ISNULL(SUBSTRING(UM,5,5),0) as int)) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) 

	SELECT @n 
	SELECT @n = 290  -- ��������� ������� ���������

	SELECT (SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s) ProdID, 
		'��_' + cast((ROW_NUMBER()OVER(ORDER BY DCardID) + @n ) as varchar) UM, 
		1 Qty, 0 Weight, Notes Notes, DCardID BarCode, DCardID ProdBarCode, 0 PLID
	FROM r_DCards where DCardID like @s and  DCardID not in (SELECT BarCode FROM r_ProdMQ where BarCode like @s)

	INSERT r_ProdMQ
	SELECT (SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s) ProdID, 
		'��_' + cast((ROW_NUMBER()OVER(ORDER BY DCardID) + @n ) as varchar) UM, 
		1 Qty, 0 Weight, Notes Notes, DCardID BarCode, DCardID ProdBarCode, 0 PLID
	FROM r_DCards where DCardID like @s and  DCardID not in (SELECT BarCode FROM r_ProdMQ where BarCode like @s)


	SELECT * FROM r_ProdMQ where BarCode like @s  ORDER BY BarCode

	--IF EXISTS (SELECT 1 FROM r_ProdMQ i WHERE 
	--NOT EXISTS (SELECT * FROM r_Uni WHERE RefTypeID = 80021 AND (i.UM = RefName OR i.UM LIKE RefName + '[_][0-9]' OR i.UM LIKE RefName + '[_][0-9][0-9]' OR i.UM LIKE RefName + '[_][0-9][0-9][0-9]')))

ROLLBACK TRAN
 
