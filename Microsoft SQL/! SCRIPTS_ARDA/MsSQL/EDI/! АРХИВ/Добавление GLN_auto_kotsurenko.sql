/* ��������: ������ ������ ��������� ����� GLN / �������� ����� GLN / ��������� ����� ����*/
USE Alef_Elit --S-PPC

/*1 ���� ����� �������� � ���� � EDI
����� ������������ ���������� � �������� ������
��������� ����� ���� � �����������

--/*���������� �������������*/EDI - ���������� ���������
SELECT * FROM [S-SQL-D4].Elit.dbo.[r_UniTypes] where  RefTypeID = 6680116
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and RefID = 9

INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680116,16508,'�����','1')
--��� ���� ��� ���� ��������� �� ������ ���� Notes �� 1
update [S-SQL-D4].Elit.dbo.r_uni set Notes = '1' where  RefTypeID = 6680116 and RefID = 16508

--/*���������� �������������*/EDI - ���������� ������������ ����� ����������� � ����� (�� EDI)
SELECT * FROM [S-SQL-D4].Elit.dbo.[r_UniTypes] where  RefTypeID = 6680117
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 and Notes = '9'

INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7079,'���-����� ��������  � ������������ ���������������� (���-�����) => ���� �����','16508')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7088,'����-����� �������� �������� �������� � ������������ ���������������� (���������) => ���� �����','16508')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7095,'�����-�������  �������� � ������������  ���������������� (�����-�������) => ���� �����','16508')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7114,'�����-������ �������� �������� � ����������� ���������������� (�����������) => ���� �����','16508')

--/*���������� �������������*/EDI - ���������� ����  ���������� �� �����
SELECT * FROM [S-SQL-D4].Elit.dbo.[r_UniTypes] where  RefTypeID = 80019
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 80019 and RefID in (7004)

INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7079,'���-����� ��������  � ������������ ���������������� (���-�����) => ���� �����','ORDERS,DESADV')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7088,'����-����� �������� �������� �������� � ������������ ���������������� (���������) => ���� �����','ORDERS,DESADV')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7095,'�����-�������  �������� � ������������  ���������������� (�����-�������) => ���� �����','ORDERS,DESADV')
INSERT [S-SQL-D4].Elit.dbo.r_uni (RefTypeID, RefID, RefName, Notes) Values (6680117,7114,'�����-������ �������� �������� � ����������� ���������������� (�����������) => ���� �����','ORDERS,DESADV')

--/*���������� ����������� - ������� ��������*/ ��������� � ������������ �������� �������� GLN
select c.CompID, CompName, CompShort, Address, case when cv.VarName <> '' then cv.VarName 
else 'insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ('+cast(c.CompID as varchar)+',''BASE_GLN'','''')' end VarName 
, VarValue from [S-SQL-D4].Elit.dbo.r_Comps c 
left join [S-SQL-D4].Elit.dbo.r_CompValues cv on cv.CompID = c.CompID and cv.VarName = 'BASE_GLN'
WHERE c.compid in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 and Notes = '9')

SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln ORDER BY ImportDate desc

insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7088,'BASE_GLN','')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7095,'BASE_GLN','9864232185048')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7114,'BASE_GLN','')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (64030,'BASE_GLN','9863569647762')

���� ����� �������
*/

IF OBJECT_ID (N'tempdb..#N', N'U') IS NOT NULL DROP TABLE #N
CREATE TABLE #N (ORDER_NUMBER varchar(max))
INSERT #N (ORDER_NUMBER) VALUES (
--����� ������
'4512583234'
)
(SELECT ORDER_NUMBER FROM #N)


--��������� CompID � �������� ��� BASE_GLN
SELECT '��������� ������� � �������� ��� ��������� ���� GLNName � RefName ����� =>'
SELECT '������� GLN ������ ���� ������ ����!'
select distinct  m.ZEO_ORDER_NUMBER,m.ZEO_ORDER_DATE,m.ZEO_ZEC_BASE
,(SELECT TOP 1 GLNName FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) GLNName
,g.RefID,g.RefName,g.Notes
,(SELECT top 1 VarValue FROM [S-SQL-D4].Elit.dbo.r_CompValues p where p.CompID = g.RefID and p.VarName = 'BASE_GLN') 'GLN ��� ����'
,'insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ('+cast(g.RefID as varchar)+',''BASE_GLN'','''+cast(m.ZEO_ZEC_BASE as varchar)+''')' '������� ���������� ������ �� RefName � GLNName'
from dbo.ALEF_EDI_ORDERS_2 m
cross apply (SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
	and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
	and cast(notes as int) <> 0
	and Notes in (SELECT TOP 1 RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) 
) g 
where  
NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
ZEO_ORDER_STATUS NOT IN (33,4,5)
and (SELECT RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) in (
	SELECT distinct cast(notes as int) FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
	and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
	and cast(notes as int) <> 0
)
and m.ZEO_AUDIT_DATE >  DATEADD(day ,-10,getdate()) -- ������ ������ �� ������ 10 ����
--****************************************************
AND m.ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)
--****************************************************
ORDER BY ZEO_ZEC_BASE


/*
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where GLN in ('9864232331926')

SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues where VarName = 'BASE_GLN' and CompID = 7134
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (71522,'BASE_GLN','9864066927104')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7031,'BASE_GLN','9863577638028')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7136,'BASE_GLN','4829900024055')
insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values (7155,'BASE_GLN','9864232128281')
*/


--��������� ����� ����� ��� GLN ����� (ZEO_ZEC_ADD) � �������� GLNCode � r_CompsAdd
SELECT '��������� ������� � �������� ��� ��������� ���� Adress � CompAdd'
DECLARE @CompID_FindAdress int = (SELECT top 1 CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues p WITH (NOLOCK) where p.VarName = 'BASE_GLN' and p.VarValue = 
(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
) --����� �����������
	SELECT distinct m.ZEO_ORDER_NUMBER,m.ZEO_ORDER_DATE,m.ZEO_ZEC_ADD
	,(SELECT TOP 1 Adress FROM [S-SQL-D4].Elit.dbo.at_gln p1 WITH (NOLOCK) where p1.GLN = m.ZEO_ZEC_ADD) Adress
	,g.CompID, g.CompAdd, g.CompAddID,g.GLNCode,g.CompAddDesc
	,'UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '''+m.ZEO_ZEC_ADD+''' where compid = '+cast(@CompID_FindAdress as varchar)+' and CompAddID = '+cast(g.CompAddID as varchar) 'Script'
	,g.*
	--,'insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ('+cast(g.RefID as varchar)+',''BASE_GLN'','''+cast(m.ZEO_ZEC_BASE as varchar)+''')' '������� ���������� ������ �� RefName � GLNName'
	from dbo.ALEF_EDI_ORDERS_2 m  WITH (NOLOCK)
	CROSS APPLY (select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2  WITH (NOLOCK) where compid = @CompID_FindAdress) g 
	where  
	--NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WITH (NOLOCK) WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
	ZEO_ORDER_STATUS NOT IN (33,4,5)
	and (SELECT RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 WITH (NOLOCK) where p1.GLN = m.ZEO_ZEC_BASE) in (
		SELECT distinct cast(notes as int) FROM [S-SQL-D4].Elit.dbo.r_uni WITH (NOLOCK) where  RefTypeID = 6680117 
		and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni WITH (NOLOCK) where  RefTypeID = 6680116 and notes = '1')  
		and cast(notes as int) <> 0
	)
	and m.ZEO_AUDIT_DATE >  DATEADD(day ,-10,getdate()) -- ������ ������ �� ������ 10 ����
	--****************************************************
	AND m.ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)
	--****************************************************
	ORDER BY g.CompAddID



/*
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid in (7031) 
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232265764' where compid = 71521 and CompAddID = 5
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232265771' where compid = 7067 and CompAddID = 9
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864045714190' where compid = 7067 and CompAddID = 20
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864066911400' where compid = 7135 and CompAddID = 72
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232306924' where compid = 7067 and CompAddID = 21
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232322870' where compid = 7031 and CompAddID = 60
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232331926' where compid = 7031 and CompAddID = 61
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '4824025001011' where compid = 7026 and CompAddID = 1
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864232173168' where compid = 7155 and CompAddID = 1
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9864169615472' where compid = 7031 and CompAddID = 62
*/


BEGIN TRAN
-------------------------------------------------------���������� ������ ������--------------------------------------------------------------
--------������� � 1----------
--��������� ����� ����� � ������� �1 dbo.ALEF_EDI_GLN_OT (KOD_BASE - ������� GLN, KOD_ADD - GLN ������ ��������, KOD_KLN_OT - ��� �����������, KOD_ADD_OT - ID ������ ��������, KOD_SKLAD_OT - ��� ������ ������, STATUS - default 1)

IF 1=1
BEGIN
	--DECLARE @ZEO_ORDER_NUMBER varchar(200) = '4549765650' --����� ������ � EDI

	SELECT
	(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) ZEC_KOD_BASE
	,(select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) ZEC_KOD_ADD
	,(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) ZEC_KOD_KLN_OT
	,(select CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK) WHERE GLNCode = (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
	  and CompID = (SELECT top 1 CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues p where p.VarName = 'BASE_GLN' and p.VarValue = 
		(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))	)
	) ZEC_KOD_ADD_OT
	--���� ������ ����� �� ����������� ������ � �������������� ����� � ��������� ���������� ��� ������
	--, 17 ZEC_KOD_ADD_OT
	,case 
	(
	select CompGrID2  from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK)
	--/*test*/ select CompGrID2,*  from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK) where CompID = 71520
	where CompID in ((SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))))
	and GLNCode = (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
	)
	 when 2030 then 220 --����� �������� ����
	 when 2031 then 4 --����� ����� �����
	 when 2034 then 23 --����� ����� ������
	 when 2035 then 27 --����� ����� �����
	 when 2036 then 11 --����� ����� �������
	 when 2048 then 85 --����� ����� ��������
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS


INSERT dbo.ALEF_EDI_GLN_OT
	SELECT
	(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) ZEC_KOD_BASE
	,(select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) ZEC_KOD_ADD
	,(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) ZEC_KOD_KLN_OT
	,(select CompAddID from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK) WHERE GLNCode = (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
	  and CompID = (SELECT top 1 CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues p where p.VarName = 'BASE_GLN' and p.VarValue = 
		(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))	)
	) ZEC_KOD_ADD_OT
	--���� ������ ����� �� ����������� ������ � �������������� ����� � ��������� ���������� ��� ������
	--, 17 ZEC_KOD_ADD_OT
	,case 
	(
	select CompGrID2  from [S-SQL-D4].Elit.dbo.r_CompsAdd WITH (NOLOCK)
	where CompID in ((SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))))
	and GLNCode = (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))
	)
	 when 2030 then 220 --����� �������� ����
	 when 2031 then 4 --����� ����� �����
	 when 2034 then 23 --����� ����� ������
	 when 2035 then 27 --����� ����� �����
	 when 2036 then 11 --����� ����� �������
	 when 2048 then 85 --����� ����� ��������
	 else 0 end ZEC_KOD_SKLAD_OT
	,1 ZEC_STATUS


------------------------------------------------------------------------------------------
--------������� � 2----------
--��������� ����� ����� � ������� �2 dbo.ALEF_EDI_GLN_SETI (EGS_GLN_SETI_ID - ID ����)

SELECT * FROM (
  SELECT
	(select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) EGS_GLN_ID
	,(SELECT Adress FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) EGS_GLN_NAME --���� � ����������� ����������� ����� �������� �� ������� ������ �������� 
	,(SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
		(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
	) EGS_GLN_SETI_ID -- ���� � ����������� ����������� �� ������� ������������� ���� ��� �������� 2
	,null EGS_STATUS
	UNION ALL
  SELECT
	(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) EGS_GLN_ID
	,(SELECT GLNName FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) EGS_GLN_NAME --����� �������� �������� � ����� Edi-n.com
	,(SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
		(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
	) EGS_GLN_SETI_ID -- ���� � ����������� ����������� �� ������� ������������� ���� ��� �������� 2
	,null EGS_STATUS
) s1 
where EGS_GLN_ID not in (
SELECT EGS_GLN_ID FROM dbo.ALEF_EDI_GLN_SETI WITH (NOLOCK) where EGS_GLN_SETI_ID = (SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
		(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		)
)


INSERT dbo.ALEF_EDI_GLN_SETI
	SELECT * FROM (
	  SELECT
		(select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) EGS_GLN_ID
		,(SELECT Adress FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in (select top 1 ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) EGS_GLN_NAME --���� � ����������� ����������� ����� �������� �� ������� ������ �������� 
		,(SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
			(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		) EGS_GLN_SETI_ID -- ���� � ����������� ����������� �� ������� ������������� ���� ��� �������� 2
		,null EGS_STATUS
		UNION ALL
	  SELECT
		(select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)) EGS_GLN_ID
		,(SELECT GLNName FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N))) EGS_GLN_NAME --����� �������� �������� � ����� Edi-n.com
		,(SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
			(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
		) EGS_GLN_SETI_ID -- ���� � ����������� ����������� �� ������� ������������� ���� ��� �������� 2
		,null EGS_STATUS
	) s1 
	where EGS_GLN_ID not in (
	SELECT EGS_GLN_ID FROM dbo.ALEF_EDI_GLN_SETI WITH (NOLOCK) where EGS_GLN_SETI_ID = (SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 WITH (NOLOCK) where compid = 
			(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
			)
	)

END

ROLLBACK TRAN

/*
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_NAME like '%�����%' --EGS_GLN_ID = '9864060910836'
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_SETI_ID = 846 --621 �����
*/

----����� ����� GLN �������
select TOP 100 
ZEO_ORDER_NUMBER '����� ������'
,m.ZEO_AUDIT_DATE '���� ������'
,m.ZEO_ORDER_DATE '���� ��������'
,m.ZEO_ZEC_BASE BASEGLN
,m.ZEO_ZEC_ADD GLN
,(SELECT TOP 1 RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) RetailersID
,(SELECT TOP 1 RetailersName FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) RetailersName
,(SELECT TOP 1 GLNName FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) GLNName
,(SELECT TOP 1 Adress FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) Adress
--,(SELECT SUBSTRING((SELECT   ',' +cast(RefID as varchar)+ '='+ RefName as [text()]  FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
--	and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
--	and cast(notes as int) <> 0
--	and Notes in (SELECT TOP 1 RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE)
--	for XML PATH('')),2,65535)
--) comps
,(SELECT top 1 CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues where VarName = 'BASE_GLN' and VarValue = m.ZEO_ZEC_BASE) CompID
,(SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) compid
,(select top 1 compshort from [S-SQL-D4].Elit.dbo.r_Comps p2 where compid =(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) compshort
, (SELECT top 1 ZEC_KOD_ADD_OT FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = m.ZEO_ZEC_ADD) '��������!!!��� ����������� ������'
,(SELECT top 1 (SELECT isnull(CodeName3,'') + ' ' + (SELECT isnull(EMail,'')+' '+isnull(Mobile,'') + ' ' + isnull(EmpName,'')+' '+isnull(Mobile,'')+' '+isnull(MilProfes,'') FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = (SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) '*������ ��� GLN ������ � Alef_Elit.dbo.ALEF_EDI_GLN_SETI*'
,*
from dbo.ALEF_EDI_ORDERS_2 m
where  
NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
ZEO_ORDER_STATUS NOT IN (33,4,5)
and (SELECT RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) in (
	SELECT distinct cast(notes as int) FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
	and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
	and cast(notes as int) <> 0
)
and m.ZEO_AUDIT_DATE >  DATEADD(day ,-10,getdate()) -- ������ ������ �� ������ 10 ����
ORDER BY ZEO_ORDER_DATE DESC







-----------�������� ����� ��������--------------/*pvm0 '2019-05-27'*/

BEGIN TRAN
SELECT * FROM dbo.ALEF_EDI_ORDERS_2 m  WITH (NOLOCK) where m.ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031 
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031 and GLNCode = '9863576637923'
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031  and CompAddID = 11
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031  and CompAddID = 59

UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '' where compid = 7031 and CompAddID = 11
UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '9863576637923' where compid = 7031 and CompAddID = 59
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7031 and GLNCode = '9863576637923'

SELECT * FROM ALEF_EDI_GLN_OT WHERE  ZEC_KOD_KLN_OT = 7031 and ZEC_KOD_ADD = '9863576637923'
UPDATE ALEF_EDI_GLN_OT set ZEC_KOD_ADD_OT = 59  where ZEC_KOD_KLN_OT = 7031 and ZEC_KOD_ADD = '9863576637923'
SELECT * FROM ALEF_EDI_GLN_OT WHERE  ZEC_KOD_KLN_OT = 7031 and ZEC_KOD_ADD = '9863576637923'

--��������� ����
BEGIN
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_ID = '9863576637923'

UPDATE ALEF_EDI_GLN_SETI set EGS_GLN_NAME = 
(SELECT Adress FROM [S-SQL-D4].Elit.dbo.at_gln WITH (NOLOCK) where GLN in ('9863576637923'))  
where EGS_GLN_ID = '9863576637923'

SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_ID = '9863576637923'
END;


ROLLBACK TRAN



/*
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln ORDER BY ImportDate desc
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where GLN = '4829900024055'
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where GLN = '4829900023799'
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where RetailersID = 17154


--[ap_EDI_SendToEmail_New_GLN] ���������� � ����� gln

SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1' 
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 80019 and len(notes) > 4 
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 80019 and notes like '%ORDRSP%'

SELECT SUBSTRING((SELECT   ',' +cast(RefID as varchar)+ '='+ RefName as [text()]  FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
and cast(notes as int) <> 0
and Notes = '16508'
for XML PATH('')),2,65535)

--����� ������
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7079 ORDER BY CompAddID DESC
select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2 where compid = 7095 ORDER BY CompAddID DESC


 
--�������� �������������� ��������� �� �����������
SELECT (SELECT isnull(CodeName3,'') + ' ' + (SELECT isnull(EMail,'')+' '+isnull(Mobile,'') + ' ' + isnull(EmpName,'')+' '+isnull(MilProfes,'') FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) info
FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = 7079

SELECT CodeID2 FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = 7079


select * from [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE compid = 7140


select * from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER like '���%' ORDER BY ZEO_AUDIT_DATE desc--����� ������ �� �����

select * from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = '111207172000' --����� ������ �� �����
select * from dbo.ALEF_EDI_ORDERS_2_POS where ZEP_ORDER_ID = 461093936
SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT where ZEC_KOD_BASE = '4820128010004'--(select ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = @ZEO_ORDER_NUMBER)  )
SELECT * FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_ADD = '9864066940967'
SELECT * FROM ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_BASE = '9864066940967'
--delete ALEF_EDI_GLN_OT WHERE dbo.ALEF_EDI_GLN_OT.ZEC_KOD_BASE = ''
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_ID = '9863569647762'
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_ID = '9864066940967'
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_SETI_ID = 615

SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln ORDER BY ImportDate desc
SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln where GLN in ('9864066888078','9864232280095','9864066862047')
SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
and notes = (SELECT top 1 RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln where GLN in ('9864232185000','9864232280095'))

SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117  order by notes
SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues


select top 1 * from dbo.ALEF_EDI_ORDERS_2 with (NOLOCK) where  ZEO_ORDER_NUMBER = '���00083880' --����� ������ �� �����


*/



---------------------------------------------���������� ����� ����---------------------------------------------

/*
--��� ���������� ����� ���� ��������� ������ ������
  DECLARE @ZEO_ORDER_NUMBER varchar(200) = '111207172000' --����� ������ � EDI

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

  DECLARE @ZEO_ORDER_NUMBER_2 varchar(200) = '111207172000' --����� ������ � EDI

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






/*



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

SELECT * FROM  Alef_EDI_EMPS
SELECT * FROM  alef_edi_SETI_EMPS


	SELECT  distinct m.ZEO_ORDER_NUMBER,m.ZEO_ORDER_DATE,m.ZEO_ZEC_ADD,m.ZEO_ORDER_STATUS
	,(SELECT TOP 1 Adress FROM [S-SQL-D4].Elit.dbo.at_gln p1 WITH (NOLOCK) where p1.GLN = m.ZEO_ZEC_ADD) Adress
	,g.CompID, g.CompAdd, g.CompAddID,g.GLNCode,g.CompAddDesc
	,'UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = '''+m.ZEO_ZEC_ADD+''' where compid = '+cast(64030 as varchar)+' and CompAddID = '+cast(g.CompAddID as varchar) 'Script'
	,g.*
	--,'insert [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ('+cast(g.RefID as varchar)+',''BASE_GLN'','''+cast(m.ZEO_ZEC_BASE as varchar)+''')' '������� ���������� ������ �� RefName � GLNName'
	from dbo.ALEF_EDI_ORDERS_2 m  WITH (NOLOCK)
	CROSS APPLY (select  * from [S-SQL-D4].Elit.dbo.r_CompsAdd p2  WITH (NOLOCK) where compid = 64030 /*and CompAddID in (59,58)*/) g 
	where  
	--NOT EXISTS(SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WITH (NOLOCK) WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD ) AND 
	--ZEO_ORDER_STATUS NOT IN (33,4,5)
	--and 
    (SELECT RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 WITH (NOLOCK) where p1.GLN = m.ZEO_ZEC_BASE) in (
		SELECT distinct cast(notes as int) FROM [S-SQL-D4].Elit.dbo.r_uni WITH (NOLOCK) where  RefTypeID = 6680117 
		and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni WITH (NOLOCK) where  RefTypeID = 6680116 and notes = '1')  
		and cast(notes as int) <> 0
	)
	and m.ZEO_AUDIT_DATE >  DATEADD(day ,-10,getdate()) -- ������ ������ �� ������ 10 ����
	----****************************************************
	AND 
    m.ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)
	--****************************************************
	ORDER BY g.CompAddID
*/
/*
--������ �����
exec msdb.dbo.sp_start_job 'edi'
exec msdb.dbo.sp_help_job @execution_status = 1, @job_name = 'EDI'

SELECT * FROM sysjobs

select j.name, step_id, js.step_name, database_name 
from msdb.dbo.sysjobsteps js
join msdb.dbo.sysjobs j on j.job_id=js.job_id
where subsystem='TSQL'
order by j.name, step_id


EXECUTE sp_get_composite_job_info @job_id = 'D23DAD66-7598-4A03-A2BE-1CF79894D7DD'
EXECUTE sp_get_composite_job_info @job_id = 'E0C79A69-0C86-4F95-889E-2AB95F7D82AE'

SELECT current_execution_step,* FROM OPENROWSET('SQLNCLI', 'Server=localhost;Trusted_Connection=yes;', 'EXECUTE  msdb.dbo.sp_get_composite_job_info @job_id = ''D23DAD66-7598-4A03-A2BE-1CF79894D7DD''')

declare @str varchar(max) = ''
WHILE @str <> '0 (unknown)'    		 
BEGIN
	set @str = (SELECT current_execution_step FROM OPENROWSET('SQLNCLI', 'Server=localhost;Trusted_Connection=yes;', 'EXECUTE  msdb.dbo.sp_get_composite_job_info @job_id = ''D23DAD66-7598-4A03-A2BE-1CF79894D7DD'''))
	RAISERROR ('��������� %s', 10,1,@str) WITH NOWAIT

	WAITFOR DELAY '00:00:05'
END 
*/

SELECT * FROM dbo.ALEF_EDI_GLN_OT aego where ZEC_KOD_BASE = '9863577638028' ORDER BY 4 --ZEC_KOD_ADD = ''
SELECT * FROM dbo.ALEF_EDI_GLN_OT aego where ZEC_KOD_KLN_OT in('7031') ORDER BY 4
SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompsAdd WHERE compid = 7031 ORDER BY ChDate
SELECT * FROM [s-sql-d4].[elit].dbo.r_compValues WHERE compid = 7031


SELECT * FROM [S-SQL-D4].Elit.dbo.at_gln WHERE retailersid = 16 and gln = '4824025200506'
SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_NAME like '%�����%'--WHERE EGS_GLN_SETI_ID = 252

(SELECT CompID FROM [S-SQL-D4].Elit.dbo.r_CompValues WITH (NOLOCK) where VarName = 'BASE_GLN' and VarValue = (select top 1 ZEO_ZEC_BASE from dbo.ALEF_EDI_ORDERS_2 WITH (NOLOCK) where ZEO_ORDER_NUMBER = (SELECT ORDER_NUMBER FROM #N)))
SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues WHERE varvalue = '4824025000007' --AND compid = 7026
--DELETE [S-SQL-D4].Elit.dbo.r_CompValues WHERE varvalue = '9863577638028' AND compid = 7134


-----------------------------------------------------------------------------���������� ������� ������� ��� ������������ ������-----------------------------------------------------------------
SELECT '�������...'
BEGIN TRAN
BEGIN

    DECLARE @base_GLN varchar(13) = '9864232280231' --������� GLN
    DECLARE @compID int = (SELECT DISTINCT ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = @base_GLN)
    DECLARE @new_GLN varchar(100) = '9864232340140' --����� GLN (��� ������ ������������ ��������)
    DECLARE @new_Address varchar(250) = '�����������; �.�����, �����. �����������, ���. 257' --����� ����� ����� (��� ������ ������������ �������� - ������� � ��������� "������ ��������" � ����������� �����������)


    IF OBJECT_ID (N'tempdb..#add_GLN', N'U') IS NOT NULL DROP TABLE #add_GLN
    CREATE TABLE #add_GLN (
    base_GLN varchar(13),
    comp_ID int,
    new_GLN varchar(13),
    new_Address varchar(250)
    )
    SELECT * FROM #add_GLN
    INSERT INTO #add_GLN (base_GLN, comp_ID, new_GLN, new_Address) VALUES (
    @base_GLN, 
    (SELECT DISTINCT ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = @base_GLN),
    @new_GLN,
    @new_Address   
    )
    SELECT * FROM #add_GLN

--������� �1
BEGIN    
    SELECT '������� �1'
    SELECT * FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)
    INSERT INTO ALEF_EDI_GLN_OT (ZEC_KOD_BASE, ZEC_KOD_ADD, ZEC_KOD_KLN_OT, ZEC_KOD_ADD_OT, ZEC_KOD_SKLAD_OT, ZEC_STATUS) 
    VALUES (
    (SELECT base_GLN FROM #add_GLN), 
    (SELECT new_GLN FROM #add_GLN), 
    (select DISTINCT ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)),
    (select MAX(ZEC_KOD_ADD_OT) + 1 FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)),
    (select DISTINCT ZEC_KOD_SKLAD_OT FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)),
    (select DISTINCT ZEC_STATUS FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN))
    )
    SELECT * FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN)
END;

--������� �2
BEGIN    
    SELECT '������� �2'
    SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_SETI_ID = (SELECT egs_gln_seti_id FROM ALEF_EDI_GLN_SETI WHERE egs_gln_id = (SELECT base_GLN FROM #add_GLN))
    INSERT INTO ALEF_EDI_GLN_SETI (EGS_GLN_ID, EGS_GLN_NAME, EGS_GLN_SETI_ID, EGS_STATUS)
    VALUES (
    (SELECT new_GLN FROM #add_GLN),
    (SELECT new_Address FROM #add_GLN),
    (SELECT egs_gln_seti_id FROM ALEF_EDI_GLN_SETI WHERE egs_gln_id = (SELECT base_GLN FROM #add_GLN)),
    NULL
    )
    SELECT * FROM ALEF_EDI_GLN_SETI WHERE EGS_GLN_SETI_ID = (SELECT egs_gln_seti_id FROM ALEF_EDI_GLN_SETI WHERE egs_gln_id = (SELECT base_GLN FROM #add_GLN))
END;
END;
ROLLBACK TRAN

--������� �3 (�������� �� linked server ������ ��������� � ���������� - ���� ������ ��������� �������)
BEGIN   
    SELECT '������� �3'
    SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues where VarName = 'BASE_GLN' and CompID = (SELECT comp_ID FROM #add_GLN)
    INSERT [S-SQL-D4].Elit.dbo.r_CompValues (CompID, VarName, VarValue) Values ((SELECT comp_ID FROM #add_GLN),'BASE_GLN',(SELECT base_GLN FROM #add_GLN))
    SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompValues where VarName = 'BASE_GLN' and CompID = (SELECT comp_ID FROM #add_GLN)
END;

--������� �4 (�������� �� linked server ������ ��������� � ���������� - ���� ������ ��������� �������)
BEGIN   
    SELECT '������� �4'
    SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompsAdd where compid = (SELECT comp_ID FROM #add_GLN) and CompAddID = (select MAX(ZEC_KOD_ADD_OT) FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN))
    UPDATE [S-SQL-D4].Elit.dbo.r_CompsAdd set GLNCode = (SELECT new_GLN FROM #add_GLN) where compid = (SELECT comp_ID FROM #add_GLN) and CompAddID = (select MAX(ZEC_KOD_ADD_OT) FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN))
    SELECT * FROM [S-SQL-D4].Elit.dbo.r_CompsAdd where compid = (SELECT comp_ID FROM #add_GLN) and CompAddID = (select MAX(ZEC_KOD_ADD_OT) FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = (SELECT base_GLN FROM #add_GLN))
END;

SELECT '��������.'

