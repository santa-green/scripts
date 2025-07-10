/* ��������: ������ ������ ��������� ����� GLN / �������� ����� GLN / ��������� ����� ����*/
--ZEC_KOD_ADD_OT - ��� ������ ��������
--EGS_GLN_NAME - �����
USE Alef_Elit --S-PPC

--����� ����� GLN �������
select TOP 100 
ZEO_ORDER_NUMBER '����� ������'
,m.ZEO_AUDIT_DATE '���� ������'
,m.ZEO_ORDER_DATE '���� ��������'
,m.ZEO_ZEC_ADD GLN
,(SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) compid
,(select top 1 compshort from [S-SQL-D4].Elit.dbo.r_Comps p2 where compid =(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) compshort
, (SELECT top 1 ZEC_KOD_ADD_OT FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = m.ZEO_ZEC_ADD) '��������!!!��� ����������� ������'
,(SELECT top 1 (SELECT isnull(CodeName3,'') + ' ' + (SELECT isnull(EMail,'')+' '+isnull(Mobile,'') + ' ' + isnull(EmpName,'')+' '+isnull(Mobile,'')+' '+isnull(MilProfes,'') FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = (SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) '*������ ��� GLN ������ � Alef_Elit.dbo.ALEF_EDI_GLN_SETI*'
,*
from dbo.ALEF_EDI_ORDERS_2 m
where --zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) AND 
NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
ZEO_ORDER_STATUS NOT IN (33,4,5)
AND EXISTS (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) 
and (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) not in (23501) --��������� �����������
and m.ZEO_AUDIT_DATE >  DATEADD(day ,-30,getdate()) -- ������ ������ �� ������ 30 ����
ORDER BY ZEO_ORDER_DATE DESC


/*
--����� ������
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7067 ORDER BY CompAddID DESC

--�������� �������������� ��������� �� �����������
SELECT (SELECT isnull(CodeName3,'') + ' ' + (SELECT isnull(EMail,'')+' '+isnull(Mobile,'') + ' ' + isnull(EmpName,'')+' '+isnull(MilProfes,'') FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = 7138

select * from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE compid = 7140

select * from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = '��10175892046' --����� ������ �� �����
select * from dbo.ALEF_EDI_ORDERS_2_POS where ZEP_ORDER_ID = 449633783
SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = '9864232280231'--(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
SELECT * FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '9864232280248'
*/



-------------------------------------------------------���������� ������ ������--------------------------------------------------------------
--------������� � 1----------
--��������� ����� ����� � ������� �1 dbo.ALEF_EDI_GLN_OT (KOD_BASE - ������� GLN, KOD_ADD - GLN ������ ��������, KOD_KLN_OT - ��� �����������, KOD_ADD_OT - ID ������ ��������, KOD_SKLAD_OT - ��� ������ ������, STATUS - default 1)

--SELECT * FROM dbo.ALEF_EDI_GLN_OT aego	WHERE aego.ZEC_KOD_ADD	= '9864232227441'

IF 1=1
BEGIN
BEGIN TRAN

DECLARE @ZEO_ORDER_NUMBER varchar(200) = '9231164' --����� ������ � EDI

SELECT * 
, (SELECT 'update ALEF_EDI_GLN_OT set ZEC_STATUS = 1 
WHERE ALEF_EDI_GLN_OT.ZEC_KOD_BASE = '''+s1.ZEC_KOD_BASE+''' and dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '''+s1.ZEC_KOD_ADD+''' and ALEF_EDI_GLN_OT.ZEC_KOD_ADD_OT = '+cast(s1.ZEC_KOD_ADD_OT as varchar(20) )
FROM ALEF_EDI_GLN_OT WHERE ALEF_EDI_GLN_OT.ZEC_KOD_BASE = s1.ZEC_KOD_BASE and dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = s1.ZEC_KOD_ADD and ALEF_EDI_GLN_OT.ZEC_KOD_ADD_OT = s1.ZEC_KOD_ADD_OT ) '��������! ����� ��� ������ ��� ��������.������� ������ �� 1 ��� ���������� GLN � Elit'
FROM (
SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_BASE
	,(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_ADD
	,(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ) ZEC_KOD_KLN_OT
	,(select top 1 CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE GLNCode = '' and CompID in 
		(
			(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
		) ORDER BY ChDate desc) ZEC_KOD_ADD_OT
	,case (select top 1 CompGrID2 from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) )) ORDER BY ChDate desc)
	 when 2030 then 220 --����� �������� ����
	 when 2031 then 4 --����� ����� �����
	 when 2034 then 23 --����� ����� ������
	 when 2035 then 27 --����� ����� �����
	 when 2036 then 11 --����� ����� �������
	 when 2048 then 85 --����� ����� ��������
/*14.12.2018 - ���� �������� 30 �����*/
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE GLNCode = '' and CompID in 
		(
			(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
		) ORDER BY ChDate desc) CompAdd
	) s1 

	
/*
--���� GLN ������ �����������, ������� ������ GLN � ��������� ����� ����� ����� INSERT (��. ��� ����)
SELECT * FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '9864232293248'
--DELETE ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '9864066969142'
*/

INSERT dbo.ALEF_EDI_GLN_OT
	SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_BASE
	,(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_ADD
	,(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ) ZEC_KOD_KLN_OT
	,(select top 1 CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE GLNCode = '' and CompID in 
		(
			(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
		) ORDER BY ChDate desc) ZEC_KOD_ADD_OT
	--���� ������ ����� �� ����������� ������ � �������������� ����� � ��������� ���������� ��� ������
	--, 17 ZEC_KOD_ADD_OT
	,case (select top 1 CompGrID2 from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) )) ORDER BY ChDate desc)
	 when 2030 then 220 --����� �������� ����
	 when 2031 then 4 --����� ����� �����
	 when 2034 then 23 --����� ����� ������
	 when 2035 then 27 --����� ����� �����
	 when 2036 then 11 --����� ����� �������
	 when 2048 then 85 --����� ����� ��������
/*14.12.2018 - ���� �������� 30 �����*/
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS

ROLLBACK TRAN
END 



------------------------------------------------------------------------------------------
--------������� � 2----------
--��������� ����� ����� � ������� �2 dbo.ALEF_EDI_GLN_SETI (EGS_GLN_SETI_ID - ID ����)
IF 1=1 
BEGIN
BEGIN TRAN

SELECT * FROM dbo.ALEF_EDI_GLN_SETI aegs where aegs.EGS_GLN_ID = '9864066969142'

DECLARE @ZEO_ORDER_NUMBER_2 varchar(200) = '9231164' --����� ������ � EDI

	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where GLNCode = '' and CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) )) ORDER BY ChDate desc) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2)) EGS_GLN_SETI_ID
	,null EGS_STATUS

INSERT dbo.ALEF_EDI_GLN_SETI
	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where GLNCode = '' and CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) )) ORDER BY ChDate desc) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2)) EGS_GLN_SETI_ID
	,null EGS_STATUS

ROLLBACK TRAN
END


---------------------------------------------���������� ����� ����---------------------------------------------

/*
--��� ���������� ����� ���� ��������� ������ ������
  DECLARE @ZEO_ORDER_NUMBER varchar(200) = '555' --����� ������ � EDI

--INSERT dbo.ALEF_EDI_GLN_OT
	SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_BASE
	,(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER) ZEC_KOD_ADD
	,7089 ZEC_KOD_KLN_OT --���� � ����������� ����������� ��� ����������� 
	,3 ZEC_KOD_ADD_OT --���� � ����������� ����������� ��� ������ �������� �� ������� ������ �������� 
	,case (select top 1 CompGrID2 from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID = 
	7089)--���� � ����������� ����������� ��� ����������� 
	 when 2030 then 220 --����� �������� ����
	 when 2031 then 4 --����� ����� �����
	 when 2034 then 23 --����� ����� ������
	 when 2035 then 27 --����� ����� �����
	 when 2036 then 11 --����� ����� �������
	 when 2048 then 85 --����� ����� ��������
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS

  DECLARE @ZEO_ORDER_NUMBER_2 varchar(200) = '555' --����� ������ � EDI

--INSERT dbo.ALEF_EDI_GLN_SETI
  SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,'�����������; �. �����, ��. �������, 165' EGS_GLN_NAME --���� � ����������� ����������� ����� �������� �� ������� ������ �������� 
	,614 EGS_GLN_SETI_ID -- ���� � ����������� ����������� �� ������� ������������� ���� ��� �������� 2
	,null EGS_STATUS
	UNION ALL
  SELECT
	(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_2) EGS_GLN_ID
	,'��� �������� ������' EGS_GLN_NAME --����� �������� �������� � ����� Edi-n.com
	,614 EGS_GLN_SETI_ID -- ���� � ����������� ����������� �� ������� ������������� ���� ��� �������� 2
	,null EGS_STATUS
*/










--???????????????????
--���������� �������������� ������, ���� GLN ������ �����������.
--������� 2
IF 1=1 
BEGIN
BEGIN TRAN

SELECT * FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = '4824025200506'
/*
--������� ������ GLN
-- delete ALEF_EDI_GLN_SETI where EGS_GLN_ID = '4824025200506'
*/

DECLARE @ZEO_ORDER_NUMBER_3 varchar(200) = '2018019037' --����� ������ � EDI
--select * from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) ))
DECLARE @CompAddID int = 43 --�������� �����

	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where  CompAddID = @CompAddID and CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) ))) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3)) EGS_GLN_SETI_ID
	,null EGS_STATUS

INSERT dbo.ALEF_EDI_GLN_SETI
	SELECT
	(select ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) EGS_GLN_ID
	,(select top 1 CompAdd from [S-SQL-D4].Elit.dbo.r_CompsAdd where  CompAddID = @CompAddID and CompID in ((SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3) ))) EGS_GLN_NAME
	,(SELECT top 1 EGS_GLN_SETI_ID FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = (select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER_3)) EGS_GLN_SETI_ID
	,null EGS_STATUS

ROLLBACK TRAN
END

/* 
����� ��������� � ���������� ����:
�������� GLN � ���� Elit (��������� ���� GLN_Update �� s_ppc) ������� 
��� ����� ������� EXEC msdb.dbo.sp_start_job N'GLN_Update'
�� ����� ���������� ������������ ������ � ��������� ���� EXEC msdb.dbo.sp_start_job N'EDI'
*/


/*
�����-----------------------------------------------------------
--������ ���������� ������ ������ � �������
--insert dbo.ALEF_EDI_GLN_OT
--select '9864066918782','9864232143314',65867,16,220,1;
--� ���� ALEF_Elit
--��� '9864066918782' - ������� ��� (BASE)
--'9864232143314' - ��� ������ �������� (ADD)
--65867 - ��� ���� (������ 2015 / ������)

9864066888160	��������; �.�����, ������������ �-�, ���.� '���������, ���.39
delete ALEF_EDI_GLN_SETI where EGS_GLN_ID = '9864066888160'

9864066888078

SELECT * FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = '9864066888078'
SELECT * FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = '9864066876396'
SELECT * FROM ALEF_EDI_GLN_OT where ZEC_KOD_ADD = '9864232293668'

SELECT * FROM ALEF_EDI_GLN_SETI where EGS_GLN_ID = '9864040514146'
SELECT * FROM ALEF_EDI_GLN_OT where ZEC_KOD_KLN_OT = '7136'--4829900025656
EGS_GLN_ID	EGS_GLN_NAME	EGS_GLN_SETI_ID	EGS_STATUS
9864046014190	��; 67663, ������� ���., ����������� �-�, ��������� �/�, ���������� ���-�����, 462 ��+100 �	751	NULL

/*
SELECT * FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = '4829900024116'
select * from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ( 7136) ORDER BY ChDate desc
*/
--16 - ����� ��������, ���������� �� ���� elit � ���-�, ��� CompADDID
select * from [S-SQL-D4].Elit.dbo.r_CompsAdd where CompID in ( 7136,7138)

--220 - ��� ����� ��������
--1 - ��������� (������)

--��������� ��� ���� ���������� ������ � ������ �������
--� ���� ALEF_Elit
---insert dbo.ALEF_EDI_GLN_SETI
---select '9864232143314','�. ���, ���. �����-��������, ���. 10 �',998,null

--����� �� elit
--998 - ������� ���.���� - ������

-- �������� ����� � EDI ��� ��������, �� base Elit
-- exec ap_KPK_SetProdsExtProdID @CompID = 64030, @ProdID = 31519, @ExtProdID = '888-20852'

select 
 (SELECT top 1 EGS_GLN_NAME FROM ALEF_EDI_GLN_SETI p1 where p1.EGS_GLN_ID = m.ZEO_ZEC_BASE)
, (SELECT top 1 EGS_GLN_NAME FROM ALEF_EDI_GLN_SETI p1 where p1.EGS_GLN_ID = m.ZEO_ZEC_ADD)
,* from dbo.ALEF_EDI_ORDERS_2 m where ZEO_ORDER_STATUS = 31 
and  (SELECT top 1 EGS_GLN_NAME FROM ALEF_EDI_GLN_SETI p1 where p1.EGS_GLN_ID = m.ZEO_ZEC_BASE) is not null
ORDER BY m.ZEO_ORDER_DATE desc
 
��� �������	�������� �������
0	����� �����
1	���������� � ��
3	���������� ���������
4	���������������
5	����� ����� � ��
31	����� �����, ��� ������������
32	���� �������� ������ �������
33	����������� ������� ��� ������
34	�� ���������� ����� ����
35	�� ����������� �������� �������
36	��� ���� ��� ������
37	��� �������� ��� �������
38	������ �����
39	��� ���� ���������
null	����������� ������

*/

