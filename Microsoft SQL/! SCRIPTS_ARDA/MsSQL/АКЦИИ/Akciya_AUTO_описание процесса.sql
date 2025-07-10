--�����
--��� ������������ ����� ����������� ������� � ���� \\S-elit-dp\f\! SCRIPTS\����� ���������\�����\�����_������ 2019.xlxs

select top 1 * from ALEF_AKCIA --�������� � �������� �����
/*	AA_ID - ����� �����, ����� �� ����� 250
	AA_NAME - �������� ����� ������� ������������ �� ����� ��������� �������
	AA_DATE_FROM - ���� ������ �����
	AA_DATE_TO - ���� ��������� �����
	AA_NOTE - �������� �����, ������������ � �������� ����������, ������� � � �
	AA_isACTIVE - ������ / ���������
	AA_isPAYTYPE - �������� 0, ��� MIX ����� 1
	AA_isSTOCKCHECK - �������� 1
	AA_OVERALL - �������� 0, ��� MIX ����� 1
	AA_MDCheck - �������� 0
	AA_APCheck - �������� 0
	AA_MAXQTY - �������� 0
	AA_C1 - ������ ��������: 2032 - ������, 50 - ����������
	AA_C2 - 2150
	AA_C3 - ������� 3: 5 - ������, 1 - ����������
	AA_C4 - ������� 4 - � ����������� �� ���� ������
	AA_C5 - ������� 5 - � ����������� �� ���� ������
*/

select top 1 * from ALEF_AKCIA_OBJECTS --����� ����������� � �����
/*
	AO_ID - ����� �����
	AO_CODE - ����� ����������� � �����
	AO_QTY - ����������� ������
	AO_isASSORT - 0 - ��� ������ ������������ ��� �����, ����� 1
	AO_isAltStock - ������ 0, ��
	AO_Tag - ���������� ����� ������ � �����, ��� MIX ��� 1
	AO_Order -  - ������ 0, ��
*/


select top 1 * from ALEF_AKCIA_SUBJECTS --����� �� ������� ���������� �����
/*
	AS_ID - ����� �����
	AS_CODES - ���
	AS_INCLUDE - ������ 1, ��
	AS_TYPE - ������ 0, ��
	AS_DATE_FROM - ��������� ���� ����������� ��� � �����, ������ ������������� �������
	AS_DATE_TO - �������� ���� ����������� ����� � �����
*/
--�������� �����
--1. ���� ���������� ����� ���, �� ������� �����. ����� ������������ ������������ ��� ������. 

insert dbo.ALEF_AKCIA
	select 17, '������ �������, 6+1 (32364)', '2019-05-19', '2019-06-22', '������� �������, 6+1 (32364)�', 1, AA_isPAYTYPE, AA_isSTOCKCHECK, AA_OVERALL, AA_MDCheck, AA_APCheck, AA_MAXQTY, AA_C1, AA_C2, AA_C3, AA_C4, AA_C5
	from dbo.ALEF_AKCIA
	where AA_ID = 42
--����� ��������� ��1, ��3, ��4, ��5 (AA_C1, AA_C3, AA_C4, AA_C5)

--2. ��������� �������� ����� �����
	--2.1 ��� ������� �����. 3 ������ ��������: 1 - ��� ������� 6 �� 31574, 1 �� ���� � �������; � �.�.
	insert dbo.ALEF_AKCIA_OBJECTS
		select 87,31574,1,0,0,1,0 union
		select 87,31574,6,1,0,1,0 union
		select 87,32618,1,0,0,2,0 union
		select 87,32618,6,1,0,2,0 union
		select 87,33296,1,0,0,3,0 union
		select 87,33296,6,1,0,3,0

	--2.2 ��� MIX �����.
	/* ������ 1 ����� ��������: ��� ������� ������ ���������� �� 34404, 34403, 34405
	 � � ����� ����������� (������� ��� �� � ����� ���� 6 �������) � ������� ���� 1 �� 34405
	 */
	insert dbo.ALEF_AKCIA_OBJECTS
		select 128,34404,6,1,0,1,0 union
		select 128,34403,6,1,0,1,0 union
		select 128,34405,6,1,0,1,0 union
		select 128,34405,1,0,0,1,0

--3. ����������� ��� � ������������ ������
exec Add_TRT_Insert_and_update7 145,58854,1, 0,'2019-06-06','2019-06-21'

-- ������
-- ���������� ���������� � ������������ ������
update dbo.ALEF_AKCIA
	set
	AA_NAME = '����� �����, 6+1',
	AA_DATE_FROM = '2019-05-19',
	AA_DATE_TO = '2019-06-22',
	AA_NOTE = '������ �����, 6+1�',
	AA_isACTIVE = 1
	--AA_isPAYTYPE = 0,
	--AA_OVERALL = 0
	--AA_C1 = 50,
	--AA_C3 = 1
	--AA_C4 = 2011,
	--AA_C5 = 2061
	where AA_ID in (187)

-- ������� ������������ �����: ��� �������, ���� ���������
BEGIN TRAN
	DECLARE @Akcia varchar(10) = 187
		--delete from ALEF_AKCIA where AA_ID =  @Akcia
		delete from ALEF_AKCIA_SUBJECTS where AS_ID =  @Akcia
		delete from ALEF_AKCIA_OBJECTS where AO_ID =  @Akcia
ROLLBACK TRAN

-- ����� �� ������� �����, ������� ����� ���������� � �����
SELECT * FROM dbo.ALEF_AKCIA aa WHERE aa.AA_isACTIVE = 0 ORDER BY aa.AA_DATE_TO


/*
--����� �� ������ ��������
SELECT * FROM  dbo.ALEF_AKCIA_OBJECTS, ALEF_AKCIA WHERE AO_ID = AA_ID and AO_isASSORT = 0 and AO_CODE = 24664




SELECT * FROM  dbo.ALEF_AKCIA_OBJECTS, ALEF_AKCIA WHERE AO_ID = AA_ID and AO_isASSORT = 0 
and AO_CODE in (23776,24549,28957,28958,31794,31795,33445,33565,33876,34111,34112,34126,34127,34128,34223,34809)

--����� �� ������ �������
SELECT * FROM  dbo.ALEF_AKCIA_OBJECTS, ALEF_AKCIA WHERE AO_ID = AA_ID and AO_isASSORT = 1 and AO_CODE = 29874, 29875, 29876




--����� �� ���
SELECT * FROM  dbo.ALEF_AKCIA_SUBJECTS, ALEF_AKCIA WHERE AS_ID = AA_ID and AS_CODES = 66583

--����� �� �������� �����
SELECT * FROM dbo.ALEF_AKCIA aa WHERE   aa.AA_NAME like '%���%' ORDER BY 2

--����� ����� �����
SELECT max(AA_ID) + 1 '����� ����� �����' FROM dbo.ALEF_AKCIA



SELECT * FROM dbo.ALEF_AKCIA aa WHERE  aa.AA_isACTIVE = 1 and aa.AA_NAME like '%2+1%' ORDER BY 2
SELECT * FROM dbo.ALEF_AKCIA aa WHERE  aa.AA_isACTIVE = 0 and aa.AA_NAME like '%2+1%' ORDER BY 2
SELECT * FROM dbo.ALEF_AKCIA aa WHERE   aa.AA_NAME like '%33539%' ORDER BY 2
SELECT * FROM dbo.ALEF_AKCIA aa WHERE   aa.AA_NAME like '%29874%' ORDER BY 2
SELECT * FROM dbo.ALEF_AKCIA aa WHERE   aa.AA_NAME like '%mix%' ORDER BY 2

SELECT * FROM  dbo.ALEF_AKCIA_OBJECTS WHERE AO_CODE = 29874
SELECT * FROM  dbo.ALEF_AKCIA_OBJECTS ORDER BY AO_ID,AO_Tag,AO_isASSORT,AO_CODE

SELECT * FROM  dbo.ALEF_AKCIA_OBJECTS 
where AO_ID in (SELECT AO_ID FROM dbo.ALEF_AKCIA_OBJECTS where AO_isASSORT = 0 group by AO_ID having count(AO_isASSORT) > 1)
ORDER BY AO_ID,AO_Tag,AO_isASSORT,AO_CODE

SELECT AO_ID ,count(AO_isASSORT) count_AO_isASSORT FROM  dbo.ALEF_AKCIA_OBJECTS where AO_isASSORT = 0 group by AO_ID having count(AO_isASSORT) > 1


DECLARE @ID int = 31 --53,153,128,59,177,180,174,181,178,27
SELECT * FROM  dbo.ALEF_AKCIA WHERE AA_ID = @ID
SELECT * FROM  dbo.ALEF_AKCIA_OBJECTS WHERE AO_ID = @ID ORDER BY AO_isASSORT,AO_CODE
SELECT * FROM  dbo.ALEF_AKCIA_SUBJECTS WHERE AS_ID = @ID ORDER BY AS_CODES

*/

/*
--������� 4
SELECT ISNULL((SELECT top 1 CAST(Notes AS INT) FROM [S-SQL-D4].[Elit].dbo.r_Uni WHERE RefTypeID = 80023 AND ISNUMERIC(Notes) = 1 AND RefID = (SELECT top 1 PGrID1 FROM [S-SQL-D4].[Elit].dbo.r_Prods where ProdID = 
--����� ��� �����
4695
) ), 0)

SELECT CodeID5,* FROM [S-SQL-D4].[Elit].dbo.r_ProdG1 where PGrID1 = 4
SELECT * FROM [S-SQL-D4].[Elit].dbo.r_Prods where PGrID1 = 4
and ProdID in (SELECT AO_CODE FROM  dbo.ALEF_AKCIA_OBJECTS, ALEF_AKCIA WHERE AO_ID = AA_ID and AO_isASSORT = 0)



*/

SELECT p.ProdID, p.PGrID1
,ISNULL((SELECT top 1 CAST(Notes AS INT) FROM [S-SQL-D4].[Elit].dbo.r_Uni WHERE RefTypeID = 80023 AND ISNUMERIC(Notes) = 1 AND RefID = (SELECT top 1 PGrID1 FROM [S-SQL-D4].[Elit].dbo.r_Prods p2 where p2.ProdID = p.ProdID) ), 0) '�������_4'
, (SELECT top 1 CodeID5 FROM [S-SQL-D4].[Elit].dbo.r_ProdG1 pg1 where pg1.PGrID1 = p.PGrID1) '�������_5' 
FROM [S-SQL-D4].[Elit].dbo.r_Prods p where p.ProdID in (
33536
)
ORDER BY 1

SELECT
  PGrName1, PGrID1
FROM
  r_ProdG1 WITH (NOLOCK) 
ORDER BY PGrName1