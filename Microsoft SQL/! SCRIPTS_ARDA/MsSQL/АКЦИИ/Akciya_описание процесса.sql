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
exec Add_TRT_Insert_and_update7 12,70877,1, 0,'2018-02-04','2018-03-03'

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
SELECT * FROM dbo.ALEF_AKCIA aa WHERE  aa.AA_isACTIVE = 0 and aa.AA_NAME like '%2+1%'
SELECT * FROM dbo.ALEF_AKCIA aa WHERE   aa.AA_NAME like '%29874%' ORDER BY 2


DECLARE @ID int = 93--115
SELECT * FROM  dbo.ALEF_AKCIA WHERE AA_ID = @ID
SELECT * FROM  dbo.ALEF_AKCIA_OBJECTS WHERE AO_ID = @ID
SELECT * FROM  dbo.ALEF_AKCIA_SUBJECTS WHERE AS_ID = @ID
*/