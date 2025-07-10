/*	
EXECUTE AS LOGIN = 'pvm0' -- ��� ������� OPENROWSET('Microsoft.ACE.OLEDB.12.0'

	IF OBJECT_ID (N'tempdb..#uCat', N'U') IS NOT NULL DROP TABLE #uCat
	SELECT *
	 INTO #uCat
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\EDI\uCat_������.xls' , 'select * from [��������$]') as ex;

SELECT * FROM #uCat
	*/

SELECT  *,
s1.QuantityOfLayersPerPallet * s1.QuantityOfTradeItemsPerPalletLayer * s1.QuantityOfChild1 * s1.QuantityOfChild2 * s1.QuantityOfChild3 as qty_on_palet
, 'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v01-���������� � �����'',''' + cast(s1.QuantityOfChild1 * s1.QuantityOfChild2  as varchar) +''',''uCat'');'
, 'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v02-���������� ������ � ���� �� ������� 800�1200'',''' + cast(s1.QuantityOfTradeItemsPerPalletLayer  as varchar) +''',''uCat'');'
, 'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v03-���������� ����� �� ������� 800�1200'',''' + cast(s1.QuantityOfLayersPerPallet  as varchar) +''',''uCat'');'
, 'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v04-���������� �� �� ������� 800�1200'',''' + cast(s1.QuantityOfLayersPerPallet * s1.QuantityOfTradeItemsPerPalletLayer * s1.QuantityOfChild1 * s1.QuantityOfChild2 * s1.QuantityOfChild3  as varchar) +''',''uCat'');'
FROM (
	SELECT u.id id1, u2.id id2,u3.id id3
	,cast(u.QuantityOfChild as int) QuantityOfChild1
	,cast(case when u2.QuantityOfChild <> '' then u2.QuantityOfChild else 1 end as int)  QuantityOfChild2
	,cast(case when u3.QuantityOfChild <> '' then u3.QuantityOfChild else 1 end as int)  QuantityOfChild3
	,cast(u.QuantityOfLayersPerPallet as int) QuantityOfLayersPerPallet ,cast(u.QuantityOfTradeItemsPerPalletLayer as int) QuantityOfTradeItemsPerPalletLayer
	FROM #uCat u
	left JOIN (SELECT * FROM #uCat) u2 on u2.GTIN = u.ChildGTIN and u2.GTIN <> ''
	left JOIN (SELECT * FROM #uCat) u3 on u3.GTIN = u2.ChildGTIN and u3.GTIN <> ''
	where u.UnitDescriptor = 'CASE' 
	and (case when u3.id is null then u2.id else u3.id end) is not null 
	AND (u.QuantityOfLayersPerPallet <> '' OR u.QuantityOfTradeItemsPerPalletLayer <> '')
) s1
JOIN (SELECT distinct ProdID,pp.ProdBarCode FROM t_PInP pp  ) pp2 on pp2.ProdBarCode = (SELECT GTIN FROM #uCat u4 where u4.id = case when id3 is null then id2 else id3 end)
ORDER BY 3,2





IF OBJECT_ID (N'tempdb..#res', N'U') IS NOT NULL DROP TABLE #res
CREATE TABLE #res (barcode varchar(100), name varchar(250), qty_on_palet INT)

DECLARE @ID INT, @qty INT = 1

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT id FROM #uCat WHERE UnitDescriptor = 'CASE'


OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ID
WHILE @@FETCH_STATUS = 0		 
BEGIN

	IF (SELECT ChildGTIN FROM #uCat WHERE id = @ID) != ''
	BEGIN
	    SET @qty = @qty * ((SELECT CASE WHEN CAST(QuantityOfChild AS INT) = 0 THEN 1 ELSE CAST(QuantityOfChild AS INT) END FROM #uCat WHERE id = @ID)*(SELECT CASE WHEN CAST(QuantityOfLayersPerPallet AS INT) = 0 THEN 1 ELSE CAST(QuantityOfLayersPerPallet AS INT) END FROM #uCat WHERE id = @ID)*(SELECT CASE WHEN CAST(QuantityOfTradeItemsPerPalletLayer AS INT) = 0 THEN 1 ELSE CAST(QuantityOfTradeItemsPerPalletLayer AS INT) END FROM #uCat WHERE id = @ID))
		SET @ID = (SELECT m.id FROM #uCat m WHERE m.GTIN = (SELECT ChildGTIN FROM #uCat WHERE id = @ID))
	END;

	ELSE
	BEGIN
		INSERT #res
		VALUES ((SELECT GTIN FROM #uCat WHERE id = @ID), (SELECT DescriptionTextRu FROM #uCat WHERE id = @ID),@qty)
		SET @qty = 1
		FETCH NEXT FROM CURSOR1 INTO @ID
	END;
	
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

SELECT * 
,(SELECT top 1 pp.ProdID FROM t_PInP pp where pp.ProdBarCode = r.barcode ORDER BY PPID desc) ProdBarCode
FROM #res r

SELECT distinct pp.prodid, p.prodname ,r.* FROM #res r
join t_PInP pp on pp.ProdBarCode = r.barcode 
join r_prods p on p.prodid = pp.prodid 
ORDER BY 5

SELECT distinct 'union all select '''+ cast(r.barcode as varchar)+''',' + cast(p.prodid as varchar) +','''+ p.prodname +''','+ cast(r.qty_on_palet as varchar)+',800'  FROM #res r
join t_PInP pp on pp.ProdBarCode = r.barcode 
join r_prods p on p.prodid = pp.prodid 
where r.qty_on_palet > 100


SELECT * FROM #uCat where GTIN in ('3068320063003','3068320113265','3068320063010')
SELECT * FROM #uCat where UnitDescriptor = 'BASE_UNIT_OR_EACH'
SELECT * FROM #uCat where UnitDescriptor = 'PREPACK'

SELECT  GTIN,QuantityOfLayersPerPallet,QuantityOfTradeItemsPerPalletLayer,[BASE_UNIT_OR_EACH],[PREPACK],[CASE]
FROM #uCat
PIVOT (max(ChildGTIN) for UnitDescriptor  IN([BASE_UNIT_OR_EACH],[PREPACK],[CASE]) ) pvt
--where GTIN in ('3068320063003','3068320113265','3068320063010')
where not ([PREPACK] is null and  [CASE] is null)

--where UnitDescriptor = 'CASE'




SELECT * FROM #uCat where UnitDescriptor = 'BASE_UNIT_OR_EACH'

SELECT distinct u.GTIN, u.ChildGTIN,u2.GTIN, u2.ChildGTIN ,u3.GTIN, u3.ChildGTIN,u2.QuantityOfLayersPerPallet, u2.QuantityOfTradeItemsPerPalletLayer ,u3.QuantityOfLayersPerPallet, u3.QuantityOfTradeItemsPerPalletLayer
FROM #uCat u 
CROSS APPLY (SELECT GTIN, ChildGTIN,QuantityOfLayersPerPallet, QuantityOfTradeItemsPerPalletLayer  FROM #uCat u2 where u2.ChildGTIN = u.GTIN and GTIN <> '') u2
CROSS APPLY (SELECT GTIN, ChildGTIN,QuantityOfLayersPerPallet, QuantityOfTradeItemsPerPalletLayer  FROM #uCat u3 where u3.ChildGTIN = u2.GTIN and GTIN <> '') u3
where u.GTIN in ('3068320063003','3068320113265','3068320063010','4823069001520')
where u.UnitDescriptor = 'CASE'
--where u.UnitDescriptor = 'BASE_UNIT_OR_EACH'


SELECT u.id,DescriptionTextRu,u.GTIN, u.ChildGTIN,u.QuantityOfLayersPerPallet, u.QuantityOfTradeItemsPerPalletLayer,u.UnitDescriptor
FROM #uCat u 
where u.UnitDescriptor = 'CASE' and QuantityOfLayersPerPallet <> '' and QuantityOfTradeItemsPerPalletLayer <> ''

SELECT  u2.id,  u3.id,u2.GTIN, u2.ChildGTIN ,u3.GTIN, u3.ChildGTIN FROM #uCat u2,#uCat u3 where u2.ChildGTIN = u3.GTIN and u2.ChildGTIN <> ''  
--and u2.GTIN in ('3068320063003','3068320113265','3068320063010','4823069001520')
and u2.GTIN in ('4823069001520')

SELECT  u2.id,  u3.id,u2.GTIN, u2.ChildGTIN ,u3.GTIN, u3.ChildGTIN 
FROM #uCat u2 where u2.ChildGTIN = u3.GTIN  
and u2.GTIN in ('3068320063003','3068320113265','3068320063010','4823069001520')

3068320063010
3068320113265
3068320063003


SELECT u.id,GTIN,ChildGTIN,QuantityOfLayersPerPallet,QuantityOfTradeItemsPerPalletLayer, 
FROM #uCat u
where u.GTIN in ('3068320063003','3068320113265','3068320063010')

SELECT u.id,u.GTIN,u.ChildGTIN,u2.id, u2.GTIN, u2.ChildGTIN, u3.id, u3.GTIN, u3.ChildGTIN FROM #uCat u
CROSS APPLY (SELECT u2.id, u2.GTIN, u2.ChildGTIN FROM #uCat u2 where u2.GTIN = u.ChildGTIN and u2.GTIN <> '') u2
CROSS APPLY (SELECT u3.id, u3.GTIN, u3.ChildGTIN FROM #uCat u3 where u3.GTIN = u2.ChildGTIN and u3.GTIN <> '') u3
where u.id in (59726)


(SELECT id, GTIN, ChildGTIN FROM #uCat u2 where u2.GTIN = '3068320113265' and u2.GTIN <> '')
(SELECT id, GTIN, ChildGTIN FROM #uCat u2 where u2.GTIN = '3068320063003' and u2.GTIN <> '')
(SELECT id, GTIN, ChildGTIN FROM #uCat u2 where u2.GTIN = '' and u2.GTIN <> '')


SELECT (SELECT GTIN FROM #uCat u4 where u4.id = id_unit) BarCode_unit
, pp2.ProdID
, cast(u.QuantityOfLayersPerPallet as int) * cast(u.QuantityOfTradeItemsPerPalletLayer as int)
--, 'UNION SELECT '+cast(pp2.ProdID as varchar)+',''���������� �� �� ������� 800�1200'','+cast(u.QuantityOfLayersPerPallet*u.QuantityOfTradeItemsPerPalletLayer as varchar)+''''
,u.id,DescriptionTextRu,u.GTIN, u.ChildGTIN,u.UnitDescriptor ,u.QuantityOfLayersPerPallet,u.QuantityOfTradeItemsPerPalletLayer 
,s1.*
FROM #uCat u
JOIN (
	SELECT u.id id_case, case when u3.id is null then u2.id else u3.id end id_unit FROM #uCat u
	left JOIN (SELECT * FROM #uCat) u2 on u2.GTIN = u.ChildGTIN and u2.GTIN <> ''
	left JOIN (SELECT * FROM #uCat) u3 on u3.GTIN = u2.ChildGTIN and u3.GTIN <> ''
	where u.UnitDescriptor = 'CASE' and (case when u3.id is null then u2.id else u3.id end) is not null 
) s1 on s1.id_case = u.id
JOIN (SELECT distinct ProdID,pp.ProdBarCode FROM t_PInP pp  ) pp2 on pp2.ProdBarCode = (SELECT GTIN FROM #uCat u4 where u4.id = id_unit)
AND (u.QuantityOfLayersPerPallet <> '' OR u.QuantityOfTradeItemsPerPalletLayer <> '')


--IF 1=0
--BEGIN
--	--������� ���������� ��
--	IF OBJECT_ID (N'tempdb..#ProdsPalet', N'U') IS NOT NULL DROP TABLE #ProdsPalet
--	CREATE TABLE #ProdsPalet (Num INT IDENTITY(1,1) NOT NULL , BarCode varchar(250) null, ProdID INT null, ProdName varchar(250) null, QtyInPalet INT NULL, WidthPalet NUMERIC(21,9))
		
--	INSERT #ProdsPalet
--	--="union all select "&C4&",'"&�����(D4;"����-��-��")&"',"&H4&","&L4&""
--select           null,30766,'������ Trino ������ 0,5*21 14,8% Design 2013',504,800
--union all select null,30767,'������ Trino ������ 1*12 14,8% Design 2013',384,800
--union all select null,28246,'���� �������. ���������� ������ �����, ����������� 0,75*12',480,1000
--union all select null,28245,'���� �������. ���������� ������ �������, ����������� 0,75*12 ',480,1000
--union all select null,30497,'����� ���� ��������� 40% 0,5*12',768,1000
--union all select null,4165,'����� ���� ��������� 40% 0,7*12',840,1000
--union all select null,4167,'����� ���� ��������� 40% 1,0*12',480,1000
--union all select null,26135,'����� ���� ����� ��������� ����� 40% New Design Original 0,5*12',1140,1000
--union all select null,26136,'����� ���� ����� ��������� ����� 40% New Design Original 0,7*12',768,1000
--union all select null,26137,'����� ���� ����� ��������� ����� 40% New Design Original 0,7*12 � �������',768,1000
--union all select null,26133,'����� ���� ����� ��������� ����� 40% New Design Original 1,0*12',576,1000
--union all select null,26139,'����� ���� ����� ��������� ����� 40% New Design Original 1,0*12 � �������',576,1000
--union all select null,3127,'���� ����� ����������� 1,5*6',504,800
--union all select null,26168,'���� ����� ����������� 0,75*12 � ������ New',780,1000
--union all select null,26213,'���� ����� ����������� 0,33*20 � ������ New',1540,1000
--union all select null,30843,'���� ����� ����������� ����� 0,75*6 New Design',1080,1000
--union all select null,31878,'���� ����� ����������� 0,33*24 Prestige',3120,1000
--union all select null,31879,'���� ����� ����������� 0,5*24 Prestige',2016,1000
--union all select null,31880,'���� ����� ����������� 1,0*12 Prestige',1008,1000
--union all select null,32143,'����� ������ 40% 0,7*12',600,800
--union all select null,32142,'����� ������ 40% 0,5*15',825,800
--union all select null,32144,'����� ������ 40% 1,0*12',336,800
--union all select null,29873,'���� ������ 37,5% 0,7*6',396,800
--union all select null,33926,'���� �������� Decordi. ��������� ����� ������� 0,75*6',630,800
--union all select null,34111,'���� �������� Decordi. ��������� ������ ������� 0,75*6',630,800
--union all select null,34130,'���� Lozano. ���������� �� �� ���� ����� ����������, ������� 0,75*6',750,800

----uCat
--union all select '8410310607196',28956,'���� Vicente Gandia. ������� ������� ������ 2011 ����� 0,75*6',504,800
--union all select '8002235572057',23431,'���� Zonin. ��������� ����� ���������� 2006 ������� 0,75*12',630,800
--union all select '3395940520648',31960,'���� Aujoux. ��� ���� ����� ����� 0,75*12',600,800
--union all select '5390683100629',29119,'����� ����c 0,7*6',576,800
--union all select '4860053012636',32363,'������ ������� 3 ���� 40%  0,5*12',720,800
--union all select '3700631902472',34405,'��� �������� ������� 40% 0,7*6',576,800
--union all select '8002235020312',22814,'���� Zonin. ���� ������� "����� ����������" 2006 ����� 0,75*12',630,800
--union all select '3068320063003',31878,'���� ����� ����������� 0,33*24 Prestige',2160,800
--union all select '4006714004859',29876,'��� ���� ������� ������� ���� 35% 0,7*6',600,800
--union all select '8002350133874',34583,'���� Bergaglio Nicola. ���� ���� ������ �� ���� ����� 2017 ����� 0,75*12',480,800
--union all select '3357340306215',30627,'���� Pascal Bouchard. ����� 2012 ����� 0,75*12',480,800
--union all select '3395940520686',31958,'���� Aujoux. ��� ��� ������� ����� 0,75*12',600,800
--union all select '5010509414081',23355,'����� ���� ����� ��������� ����� 40% New Design 1,0*12 � �������',384,800
--union all select '4820073560739',26697,'������ ���� �� ��� VS 0,5*6 � �������',576,800
--union all select '8710625527203',4140,'����� �� ������ ����� ��� (��������) 40 % 0,7*6',570,800
--union all select '8002095200046',4755,'����� ������� �������� ������ 0,75*12 + �������� �����',576,800
--union all select '8002235572057',33962,'���� Zonin. ��������� 2016 ������� 0,75*6',630,800
--union all select '4860053012643',28573,'������ ������� 5 ��� 40% 0,5*12',720,800
--union all select '3068320103631',26213,'���� ����� ����������� 0,33*20 � ������ New',800,800
--union all select '8710625527203',34791,'����� �� ������ ����� ��� (��������) 40 % 0,7*6 Essentials ',570,800
--union all select '3014220909118',27499,'���� Guy Saget. ����� 2010 ����� 0,75*12',480,800
--union all select '5010509001229',34357,'����� ���� ����� ��������� ����� 40% New Design Original 0,7*12 � �������',576,800
--union all select '3068320103631',31874,'���� ����� ����������� 0,33*20 � ������ �����',800,800
--union all select '8002235011310',22812,'���� T.���olani. ����� �������� ������ ������ DOC 2006 ����� 0,75*6',504,800
--union all select '8002235662055',23172,'���� Zonin. ����� "����� ����������" 2006 ����� 0,75*12',630,800
--union all select '8002235662055',34316,'���� Zonin. ����� 2017 ����� 0,75*6',630,800
--union all select '4823069001216',31779,'���� �������� ������� ������� ����� 0,75*12',480,800
--union all select '7804414000655',24558,'���� Luis Felipe Edwards. ������� ������� 2009 ����� 0,75*12',480,800
--union all select '5010509415705',26135,'����� ���� ����� ��������� ����� 40% New Design Original 0,5*12',900,800
--union all select '3550142055460',2204,'������ ���� ������� VS�� ���� ��� ������� 40% ������ 0,5*12',576,800
--union all select '8410310606892',34003,'���� Vicente Gandia. ����� ������� 2015 ������� 0,75*6',504,800
--union all select '5010509003087',4167,'����� ���� ��������� 40% 1,0*12',480,800
--union all select '8002235216050',22695,'���� T. Ca* Vescovo. ������� ������ ������ 2006, ��������� ����� 0,75*6',630,800
--union all select '8410310606977',31938,'���� Vicente Gandia. ����� 2014 ����� 0,75*6',504,800
--union all select '3550142025463',4903,'������ ���� ������� VS ���� ��� ������� 40% ������ 0,5*12 � ������',576,800
--union all select '8002350133874',29114,'���� Bergaglio Nicola. ���� ���� ������ �� ���� ����� 2011 �����  0,75*12',480,800
--union all select '4820139240261',34076,'����� ������ �9 1,0*6',396,800
--union all select '8410310606977',27392,'���� Vicente Gandia. ����� 2010 ����� 0,75*6',504,800
--union all select '8002235395953',31007,'���� Zonin. ������� ���� ��������� 2012 ������� 0,75*6',630,800
--union all select '8410310606977',29086,'���� Vicente Gandia. ����� 2011 ����� 0,75*6',504,800
--union all select '8002235692052',27039,'���� Zonin. �������������  2010 ������� 0,75*6',600,800
--union all select '5014218794557',32192,'����� Douglas Laing. ��� ������ ����� 46,8% 0,7*6 � ���������� ��������',600,800
--union all select '8410310606977',32035,'���� Vicente Gandia. ����� 2015 ����� 0,75*6',504,800
--union all select '8002235572057',27037,'���� Zonin. ��������� 2010, ������� 0,75*6',630,800
--union all select '8002235022323',24915,'���� Zonin. ������ 2007 ������� 0,75*6',630,800
--union all select '4905846960050',32414,'���� ��� ������� 0,5*6',600,800
--union all select '5010509415439',4298,'����� ���� ����� ��������� ����� 40% New Design 0,2*24',1680,800
--union all select '5010509414081',4639,'����� ���� ����� ��������� ����� 40% New Design 1,0*12',384,800
--union all select '5010509414081',26139,'����� ���� ����� ��������� ����� 40% New Design Original 1,0*12 � �������� � ������',384,800
--union all select '4062400543125',34678,'������ ������ �������� 38% 0,7*6 + �������',576,800
--union all select '4820024226301',4668,'������ Trino ������ 1*12 14,8% (�������)',384,800
--union all select '8410310607196',34004,'���� Vicente Gandia. ������� ������� 2016 ����� 0,75*6',504,800
--union all select '8008820158354',33927,'���� �������� Decordi. ��������� ������ ����� 0,75*6',504,800
--union all select '8410310607110',33691,'���� Vicente Gandia. ������� ����������� 2016 ������� 0,75*6',504,800
--union all select '3550142027344',4353,'������ ���� ������� VS ���� ��� ������� 40% 0,7*6 � ������',384,800
--union all select '8427894007632',34111,'���� Lozano. ���������� �� �� ���� ����� ����������, ������� 0,75*6',480,800
--union all select '7804414001027',28368,'���� Luis Felipe Edwards. ����� ������� �������� ���� 2011 ������� 0,75*12',480,800
--union all select '7804414000655',23198,'���� Luis Felipe Edwards. ������� ������� 2007 ����� 0,75*12',480,800
--union all select '8002350133881',27045,'���� Bergaglio Nicola. ���� ���� ������ �� ���� 2010 �����  0,75*12',480,800
--union all select '5390683100636',34048,'����� ����� New Design 1,0*12',360,800
--union all select '3014220909101',30400,'���� Guy Saget. ��� �*���� 2012 ������� 0,75*12',480,800
--union all select '3014220909118',26860,'���� Guy Saget. ����� 2009  ����� 0,75*12',480,800
--union all select '5391524710656',32316,'����� ���� ���� ��������� �������� 40% 0,7*6',600,800
--union all select '7804414000655',23586,'���� Luis Felipe Edwards. ������� ������� 2008 ����� 0,75*12',480,800
--union all select '8002235692052',23289,'���� Zonin. ������������� "����� ����������" 2006 ������� 0,75*12',600,800
--union all select '8002235020312',25768,'���� Zonin. ���� �������  2009 ����� 0,75*6',630,800
--union all select '8002235662055',33023,'���� Zonin. ����� 2016 ����� 0,75*6',630,800
--union all select '4860053012650',28574,'������ ������� ���� 8 ��� 40% 0,5*12',720,800
--union all select '4062400311083',4717,'���� �������� 37,5% 1*6',360,800
--union all select '4860053012636',28572,'������ ������� 3 ���� 40% 0,5*12',720,800
--union all select '8002235020312',23357,'���� Zonin. ���� ������� "����� ����������" 2007 ����� 0,75*12',630,800
--union all select '8002235020312',32445,'���� Zonin. ���� ������� ����� ������� 2015 ����� 0,75*6',630,800
--union all select '8002235020312',34315,'���� Zonin. ���� ������� ����� ������� 2017 ����� 0,75*6',630,800
--union all select '3068320063003',33990,'���� ����� ����������� 0,33*24 Chiara Limited',2160,800
--union all select '7804350004540',30726,'���� Santa Carolina. ������ �������� 2013 ����� ����������� 0,75*12',480,800
--union all select '4062400115483',31974,'������ ������ ������� 38%  0,7*6 + �����',576,800
--union all select '8002235022811',30735,'���� Zonin. ������� ���� ��������� 2012 ����� 0,75*6',630,800
--union all select '8002235662055',23290,'���� Zonin. ����� "����� ����������" 2007 ����� 0,75*12',630,800
--union all select '5011166056508',34624,'���� ����� ����� ����� ��� ������� 43% 0,7*6',480,800
--union all select '3068320055008',31879,'���� ����� ����������� 0,5*24 Prestige',1296,800
--union all select '8002350133881',29113,'���� Bergaglio Nicola. ���� ���� ������ �� ���� 2011 �����  0,75*12',480,800
--union all select '8002235022323',25767,'���� Zonin. ������ 2008 ������� 0,75*6',630,800
--union all select '8002235022811',34317,'���� Zonin. ������� ���� ��������� 2017 ����� 0,75*6',630,800
--union all select '8002350133874',30406,'���� Bergaglio Nicola. ���� ���� ������ �� ���� ����� 2012 �����  0,75*12',480,800
--union all select '4823069000554',31809,'���� �������� ���� ���� �������� ������� ����������� 0,75*12',480,800
--union all select '4823069000561',31776,'���� �������� ���� ���� ������� ����� ����� 0,75*12',480,800
--union all select '8427894007045',23776,'���� Lozano. ������, ������� 0,75*12',480,800
--union all select '8002235216050',31277,'���� T.Cabolani. ���� ������� ������ ������ DOC 2013 ����� 0,75*6',630,800
--union all select '8028936007001',27487,'���� Villa Gritti. ����������� 2010 ������� 0,75*12',480,800
--union all select '4823069000547',31777,'���� �������� ���� ���� ������� ������� ����� 0,75*12',480,800
--union all select '5010509414081',4162,'����� ���� ����� ��������� ����� 40% 1,0*12',384,800
--union all select '8427894007038',24549,'���� Lozano. ������, ����� 0,75*12',480,800
--union all select '7804414000655',26673,'���� Luis Felipe Edwards. ������� ������� 2010 ����� 0,75*12',480,800
--union all select '8410310607110',32033,'���� Vicente Gandia. ������� ����������� 2014 ������� 0,75*6',504,800
--union all select '8002235692052',31280,'���� Zonin. ������������� 2012 ������� 0,75*6',600,800
--union all select '4006714004798',29879,'����� ��� ���� 3 ���� 40% 0,7*6',756,800
--union all select '6438052555553',34815,'����� ������ 40% 0,5*15 � ������ � ������',825,800
--union all select '8410310607110',31390,'���� Vicente Gandia. ������� ����������� 2013 ������� 0,75*6',504,800
--union all select '8410310607110',32602,'���� Vicente Gandia. ������� ����������� 2015 ������� 0,75*6',504,800
--union all select '3181250000402',4525,'��������� ��� ������� VSOP  0,5*12',720,800
--union all select '7804414001027',30917,'���� Luis Felipe Edwards. ����� ������� �������� ���� 2013 ������� 0,75*12',480,800
--union all select '8028936008336',30461,'���� Villa Gritti. ������ 2012 ������� 0,75*12',480,800
--union all select '8002235022323',26871,'���� Zonin. ������ 2010 ������� 0,75*6',630,800
--union all select '8410310607110',30702,'���� Vicente Gandia. ������� ����������� 2012 ������� 0,75*6',504,800
--union all select '8002235572057',30382,'���� Zonin. ��������� 2011 ������� 0,75*6',630,800
--union all select '8028936007001',31486,'���� Villa Gritti. ����������� 2013 ������� 0,75*12',480,800
--union all select '4062400115483',33718,'������ ������ ������� 38%� 0,7*6 + �������',576,800
--union all select '8002235020312',24257,'���� Zonin. ���� �������  2008 ����� 0,75*6',630,800
--union all select '8002235662055',24255,'���� Zonin. �����  2008 ����� 0,75*6',630,800
--union all select '8028936008336',31101,'���� Villa Gritti. ������ 2013 ������� 0,75*12',480,800
--union all select '8028936008336',31884,'���� Villa Gritti. ������ 2014 ������� 0,75*12',480,800
--union all select '627843480358',33539,'����� ��������� 40% 0,5*12',384,800
--union all select '3068320080000',31880,'���� ����� ����������� 1,0*12 Prestige',720,800
--union all select '8410310606977',33723,'���� Vicente Gandia. ����� 2016 ����� 0,75*6',504,800
--union all select '8002235216050',31799,'���� T.Cabolani. ���� ������� ������ ������ DOC 2014 ����� 0,75*6',630,800
--union all select '8002235216050',32344,'���� T.Cabolani. ���� ������� ������ ������ DOC 2015 ����� 0,75*6',630,800
--union all select '8002095200046',4737,'����� ������� �������� ������ �����  0,75 + ������� �������� ���� ����� 0,03   *12',576,800
--union all select '8028936008336',26201,'���� Villa Gritti. ������ 2009 ������� 0,75*12',480,800
--union all select '4820139240056',33534,'����� ��������� �������� 1,0*12',324,800
--union all select '7804350004540',29305,'���� Santa Carolina. ������ �������� 2012 �����, ����������� 0,75*12',480,800
--union all select '8002235692052',25208,'���� Zonin. �������������  2008 ������� 0,75*6',600,800
--union all select '8002235662055',25766,'���� Zonin. ����� 2008 ����� 0,75*6',630,800
--union all select '4062400311700',4622,'���� �������� �������� 47% 0,7*6 + ������ � �������',486,800
--union all select '5010509427067',4149,'����� ���� � ��� 12 ��� 40% 0,7*6 � ������',456,800
--union all select '8002235216050',34171,'���� T.Cabolani. ���� ������� ������ ������ 2017 ����� 0,75*6',630,800
--union all select '5010509415439',26134,'����� ���� ����� ��������� ����� 40% New Design Original 0,2*24',1680,800
--union all select '5010509414081',24571,'����� ���� ����� ��������� ����� 43% New Design 1,0*12',384,800
--union all select '8002235395953',25945,'���� Zonin. ������� ����� ������� 2009 ������� 0,75*6',630,800
--union all select '8713427000073',25944,'����� �� ������ ���� ������ (��������-����������) 14,5 % 0,7*6 New Design',750,800
--union all select '8002235216050',33295,'���� T.Cabolani. ���� ������� ������ ������ 2016 ����� 0,75*6',630,800
--union all select '8002235011310',30825,'���� T.Cabolani. �������� ������ ������ DOC 2012 ����� 0,75*6',504,800
--union all select '4867601703367',28241,'���� �������. �������� �������, ����� 0,75*12 (�� ���������� ������������)',480,800
--union all select '8002235692052',30732,'���� Zonin. �������������  2011 ������� 0,75*6',600,800
--union all select '8006315900136',29054,'���� �������� Trino ���� ����� 0,75*6',456,800
--union all select '8028936008336',31337,'���� Fattoria Scaligera. ������ 2013 ������� 0,75*12',480,800
--union all select '8002235020312',31804,'���� Zonin. ���� ������� ����� ������� 2014 ����� 0,75*6',630,800
--union all select '8002235662055',32346,'���� Zonin. ����� 2015 ����� 0,75*6',630,800
--union all select '4820024226516',30766,'������ Trino ������ 0,5*21 14,8% Design 2013',630,800
--union all select '8002235572057',22563,'���� Zonin. ��������� 2005 ������� 0,75*12',630,800
--union all select '8002235692052',34606,'���� Zonin. ������������� 2017 ������� 0,75*6',600,800
--union all select '4867601703398',28246,'���� �������. ���������� ������ �����, ����������� 0,75*12 (�� ���������� ������������)',480,800
--union all select '4820139240018',30689,'����� ��������� �������� 0,7*6',504,800
--union all select '4062400311601',20222,'���� �������� �������� 47% 1,0*6',360,800
--union all select '4006714004897',29872,'����� ������� ������� 38% 0,7*6',600,800
--union all select '4820024226301',30767,'������ Trino ������ 1*12 14,8% Design 2013',384,800
--union all select '4062400111218',30728,'���� �������� 37,5% 0,7*6 New Design',600,800
--union all select '7804350004533',27575,'���� Santa Carolina. ������ �������� 2011 �������, ����������� 0,75*12',480,800
--union all select '8410310606892',32037,'���� Vicente Gandia. ����� ������� 2013 ������� 0,75*6',504,800
--union all select '8002235395953',30383,'���� Zonin. ������� ���� ��������� 2011 ������� 0,75*6',630,800
--union all select '5010509414104',23135,'����� ���� ����� ��������� ����� 40% New Design 0,35*24',1152,800
--union all select '4062400111218',4621,'���� �������� 37,5% 0,7*6 + ������ � �������',600,800
--union all select '8710625524707',4141,'����� �� ������ ��� ��� (������ ����������) 20 % 0,7*6',480,800
--union all select '8002095736606',27052,'����� ������� �������� ���� 36% 0,7*6',528,800
--union all select '8002235011310',33953,'���� T.Cabolani. �������� ������ ������ DOC 2016 ����� 0,75*6',504,800
--union all select '4062400311601',24664,'���� �������� �������� 47% 1,0*6 New Design',360,800
--union all select '4905846114859',33848,'����� ��� ����� ������ ���� 17% 0,7*6',600,800
--union all select '3550142055460',4355,'������ ���� ������� VS�� ���� ��� ������� 40% ������ 0,5*12 � ������',576,800
--union all select '7804350004533',29304,'���� Santa Carolina. ������ �������� 2012 �������, ����������� 0,75*12',480,800
--union all select '8002235022811',31361,'���� Zonin. ������� ���� ��������� 2013 ����� 0,75*6',630,800
--union all select '5010509001229',4161,'����� ���� ����� ��������� ����� 40% 0,7*12 � �������',576,800
--union all select '6438052555775',32144,'����� ������ 40% 1,0*12',480,800
--union all select '5011166054795',34336,'���� ����� ����� ����� 43% 0,7*6',480,800
--union all select '8002350133881',30405,'���� Bergaglio Nicola. ���� ���� ������ �� ���� 2012 �����  0,75*12',480,800
--union all select '8002235022323',32443,'���� Zonin. ������ 2015 ������� 0,75*6',630,800
--union all select '3068320085005',3127,'���� ����� ����������� 1,5*6',504,800
--union all select '4820073560739',27592,'������ ������� ��� ���� �� ��� VS 0,5*6 � �������',576,800
--union all select '8002350133874',32713,'���� Bergaglio Nicola. ���� ���� ������ �� ���� ����� 2015 ����� 0,75*12',480,800
--union all select '8002235692052',32446,'���� Zonin. ������������� 2015 ������� 0,75*6',600,800
--union all select '8002235395953',33684,'���� Zonin. ������� ���� ��������� 2015 ������� 0,75*6',630,800
--union all select '4905846114811',33847,'����� ��� ����� ������ ���� 17% 0,7*6',600,800
--union all select '3014220909101',31110,'���� Guy Saget. ��� �*���� 2013 ������� 0,75*12',480,800
--union all select '5010509800648',30497,'����� ���� ��������� 40% 0,5*12',768,800
--union all select '8710625524707',24235,'����� �� ������ ��� ��� (������ ����������) 20 % 0,7*6 New Design',480,800
--union all select '7804414001027',30353,'���� Luis Felipe Edwards. ����� ������� �������� ���� 2012 ������� 0,75*12',480,800
--union all select '8002235216050',28979,'���� T.Cabolani. ���� ������� ������ ������ 2011 ����� 0,75*6',630,800
--union all select '8002235022323',22821,'���� Zonin. ������ "����� ����������" 2005 ������� 0,75*12',630,800
--union all select '4823069000547',34388,'���� �������� ���� ������� �������� ������� ������� ������� ����� 0,75*12',480,800
--union all select '4820139240056',30691,'����� ��������� �������� 1,0*6',324,800
--union all select '8002235572057',32699,'���� Zonin. ��������� 2015 ������� 0,75*6',630,800
--union all select '3068320080000',32256,'���� ����� ����������� 1,0*6 Prestige',720,800
--union all select '4062400111218',4718,'���� �������� 37,5% 0,7*6',600,800
--union all select '8006315900136',32021,'����� �������� (���� �������� Trino ���� ����� 1���.*0,75 + ������ Trino ������ 2���.*0,5)*3',456,800
--union all select '8710625500305',4144,'����� �� ������ ������� (������) 14,8 % 0,7*6',750,800
--union all select '8410310606892',31829,'���� Vicente Gandia. ����� ������� 2012 ������� 0,75*6',504,800
--union all select '8713427000073',4986,'����� �� ������ ���� ������ (��������-����������) 14,5 % 0,7*6 + �������',750,800
--union all select '8002350133874',33917,'���� Bergaglio Nicola. ���� ���� ������ �� ���� ����� 2016 ����� 0,75*12',480,800
--union all select '7804350004533',30987,'���� Santa Carolina. ������ �������� 2013 ������� ����������� 0,75*12',480,800
--union all select '3014220909118',30878,'���� Guy Saget. ����� 2012 ����� 0,75*12',480,800
--union all select '3068320055008',32880,'���� ����� ����������� 0,5*24 Lacroix',1296,800
--union all select '8002235662055',31923,'���� Zonin. ����� 2014 ����� 0,75*6',630,800
--union all select '3068320103389',34032,'���� ����� ����������� 0,75*12 � ������ �����',432,800
--union all select '4062400311700',24412,'���� �������� �������� 47% 0,7*6 New Design',486,800
--union all select '4867601703343',28244,'���� �������. ��������� �����, ����� 0,75*12 (�� ���������� ������������)',480,800
--union all select '8002235662055',26088,'���� Zonin. ����� 2009 ����� 0,75*6',630,800
--union all select '5010509003001',30990,'����� ���������� (����. ����� ��������� 0,7+ �������������� ������� Fashion F88 0,25)*12',720,800
--union all select '4062400543125',32615,'������ ������ �������� 38% 0,7*6 + �����',576,800
--union all select '8410310613432',31794,'���� Vicente Gandia. ������ ����� 0,75*6',600,800
--union all select '8002235022323',26089,'���� Zonin. ������ 2009 ������� 0,75*6',630,800
--union all select '6438052555553',32142,'����� ������ 40% 0,5*15',825,800
--union all select '8710625640704',4136,'����� �� ������ ������� ��� (�������� �����) 24 % 0,7*6',570,800
--union all select '7804414000655',27459,'���� Luis Felipe Edwards. ������� ������� 2011 ����� 0,75*12',480,800
--union all select '8002235692052',31922,'���� Zonin. ������������� 2014 ������� 0,75*6',600,800
--union all select '4867601703398',34487,'���� �������. ���������� ������ �����, ����������� 0,75*6 (�� ���������� ������������)',480,800
--union all select '8002235572057',23601,'���� Zonin. ��������� ����� ���������� 2007 ������� 0,75*12',630,800
--union all select '8002235216050',24914,'���� T.Cabolani. ���� ������� ������ ������ 2008 ����� 0,75*6',630,800
--union all select '8410310607196',31389,'���� Vicente Gandia. ������� ������� 2013 ����� 0,75*6',504,800
--union all select '4823069001209',34387,'���� �������� ������� ������� ������� ����� ����� 0,75*12',480,800
--union all select '5010509414081',26133,'����� ���� ����� ��������� ����� 40% New Design Original 1,0*12',384,800
--union all select '8028936007001',30717,'���� Villa Gritti. ����������� 2012 ������� 0,75*12',480,800
--union all select '4006714004781',29875,'��� ���� ������� ���� 38% 0,7*6',600,800
--union all select '8002235022811',32442,'���� Zonin. ������� ���� ��������� 2015 ����� 0,75*6',630,800
--union all select '8427894007656',23775,'���� Lozano. ���������� �� �� ���� ������ ����������, ����� 0,75*12',480,800
--union all select '4867601703381',34329,'���� �������. ���������� ������ �������, ����������� 0,75*6 (�� ���������� ������������)',480,800
--union all select '3357340306215',27725,'���� Pascal Bouchard. ����� 2010 ����� 0,75*12',480,800
--union all select '8002235022323',33296,'���� Zonin. ������ 2016 ������� 0,75*6',630,800
--union all select '8002235020312',30561,'���� Zonin. ���� ������� ����� ������� 2012 ����� 0,75*6',630,800
--union all select '3014220909101',26859,'���� Guy Saget. ��� �*���� 2010 ������� 0,75*12',480,800
--union all select '8002235572057',3366,'���� Zonin. ��������� K������� DOC 2002 ������� 0,75*6',630,800
--union all select '5010509003001',4165,'����� ���� ��������� 40% 0,7*12',720,800
--union all select '7804414001027',32576,'���� Luis Felipe Edwards. ����� ������� �������� ���� 2015 ������� 0,75*12',480,800
--union all select '4823069001520',31846,'���� T������ ���� ������ ���� ���������� ������ ������� ����������� 0,75*12',480,800
--union all select '4823069000554',34390,'���� �������� ���� ������� ������� ������� ����������� 0,75*12',480,800
--union all select '4867601703367',34616,'���� �������. �������� �������, ����� 0,75*6 (�� ���������� ������������)',480,800
--union all select '5011166057093',34335,'���� ����� ����� ���� ����� 43% 0,7*6',480,800
--union all select '5014218776256',31978,'����� Douglas Laing. ��� ��� ����� 46% 0,7*6 � ������ ',600,800
--union all select '8002235662055',28268,'���� Zonin. ����� 2011 ����� 0,75*6',630,800
--union all select '4823069000578',31808,'���� �������� ���� ���� ������� ����� ����������� 0,75*12',480,800
--union all select '3068320063003',2999,'���� ����� ����������� 0,33*24',2160,800
--union all select '3700631997720',34403,'��� �������� ����  40% 0,7*6',576,800
--union all select '8028936007001',26204,'���� Villa Gritti. ����������� 2009 ������� 0,75*12',480,800
--union all select '5010509001229',4829,'����� ���� ����� ��������� ����� 40% 0,7*1 � ������',576,800
--union all select '4006714004866',29877,'����� ���� ������� ������ 15% 0,7*6',600,800
--union all select '8002235020312',33300,'���� Zonin. ���� ������� ����� ������� 2016 ����� 0,75*6',630,800
--union all select '3068320055008',3101,'���� ����� ����������� 0,5*24',1296,800
--union all select '8002235011310',3552,'���� T.���olani. ����� �������� ������ ������ DOC 2003, �����  0,75*6',504,800
--union all select '5391524710663',32317,'����� ���� ���� ��������� �������� 10 ��� ������������� 40% 0,7*6',600,800
--union all select '7804350004540',31395,'���� Santa Carolina. ������ �������� 2014 ����� ����������� 0,75*12',480,800
--union all select '8410310606892',31393,'���� Vicente Gandia. ����� ������� 2010 ������� 0,75*6',504,800
--union all select '4603928000969',30900,'����� ������ ���� 0,5*12',576,800
--union all select '4860053012643',32364,'������ ������� 5 ��� 40%  0,5*12',720,800
--union all select '8410310607196',32549,'���� Vicente Gandia. ������� ������� 2015 ����� 0,75*6',504,800
--union all select '4006714004934',29878,'����� ��� ���� 6 ��� 40% 0,7*6',756,800
--union all select '4603928000983',31623,'����� ������ ���� 1,0*12',384,800
--union all select '8002235011310',21984,'���� T.���olani. ����� �������� ������ ������ DOC 2005 �����  0,75*6',504,800
--union all select '4867601703381',28245,'���� �������. ���������� ������ �������, ����������� 0,75*12 (�� ���������� ������������)',480,800
--union all select '627843480365',33541,'����� ��������� 40% 1,0*12',384,800
--union all select '4820139240070',30690,'����� ��������� �������� 0,7*6 � �������',324,800
--union all select '8410310615771',33778,'���� Vicente Gandia. ��� �������� ��� ������� 0,75*6',600,800
--union all select '8002350133874',31270,'���� Bergaglio Nicola. ���� ���� ������ �� ���� ����� 2013 �����  0,75*12',480,800
--union all select '4062400543002',3248,'������ ������ �������� 38% 1,0*6',384,800
--union all select '3357340306215',26347,'���� Pascal Bouchard. ����� 2009 ����� 12,5%  0,75*6',480,800
--union all select '4867601703374',34327,'���� �������. ������������ �������, ����������� 0,75*6 (�� ���������� ������������)',480,800
--union all select '3550142637970',31896,'������ ���� ������� VS�� ������� 40% ���� 0,7*6 � �������',450,800
--union all select '4062400115483',4696,'������ ������ ������� 38%  0,7*12',576,800
--union all select '8002235395953',31412,'���� Zonin. ������� ���� ��������� 2013 ������� 0,75*6',630,800
--union all select '8002350133881',32467,'���� Bergaglio Nicola. ���� ���� ������ �� ���� 2015 ����� 0,75*12',480,800
--union all select '8002235011310',32440,'���� T.Cabolani. �������� ������ ������ DOC 2015 ����� 0,75*6',504,800
--union all select '8410310606977',31391,'���� Vicente Gandia. ����� 2013 ����� 0,75*6',504,800
--union all select '4823069001209',31780,'���� �������� ������� ����� ����� 0,75*12',480,800
--union all select '8002235020312',26872,'���� Zonin. ���� ������� ����� ������� 2010 ����� 0,75*6',630,800
--union all select '8002235020312',28267,'���� Zonin. ���� ������� ����� ������� 2011 ����� 0,75*6',630,800
--union all select '8002235022811',31761,'���� Zonin. ������� ���� ��������� 2014 ����� 0,75*6',630,800
--union all select '8004499750011',34366,'����� Caffo. ������ ����� ���� ���� 35% 0,7*8',576,800
--union all select '8002350133874',31964,'���� Bergaglio Nicola. ���� ���� ������ �� ���� ����� 2014 ����� 0,75*12',480,800
--union all select '3357340306215',29184,'���� Pascal Bouchard. ����� 2011 ����� 0,75*12',480,800
--union all select '3068320103389',24023,'���� ����� ����������� 0,75*12 � ������',432,800
--union all select '8002350133881',33422,'���� Bergaglio Nicola. ���� ���� ������ �� ���� 2016 ����� 0,75*12',480,800
--union all select '3357340306215',25948,'���� Pascal Bouchard. ����� 2009 ����� 0,75*6',480,800
--union all select '8710521444703',4143,'����� �� ������ ������ ���� ���� 17 % 0,7*6',480,800
--union all select '3357340306215',31757,'���� Pascal Bouchard. ����� 2014 ����� 0,75*12',480,800
--union all select '6438052555560',32143,'����� ������ 40% 0,7*12',720,800
--union all select '3550142055460',34683,'������ ���� ������� VS�� ���� ��� ������� 40% ������ 0,5*12 � ������',576,800
--union all select '4062400543125',4697,'������ ������ �������� 38% 0,7*12',576,800
--union all select '4062400542074',4695,'������ ������ ������� 38%  1,0*12',384,800
--union all select '3068320085005',34726,'���� ����� ����������� 1,5*6 Magnum',504,800
--union all select '7804414000655',31927,'���� Luis Felipe Edwards. ������� 2015 ����� 0,75*12',480,800
--union all select '3357340306215',31366,'���� Pascal Bouchard. ����� 2013 ����� 0,75*12',480,800
--union all select '8002235692052',31760,'���� Zonin. ������������� 2013 ������� 0,75*6',600,800
--union all select '5010509414104',1204,'����� ���� ����� ��������� ����� 40% 0,35*24',1152,800
--union all select '4820139240025',30688,'����� ��������� �������� 0,5*12',720,800
--union all select '8410310613418',31795,'���� Vicente Gandia. ������ ������� 0,75*6',600,800
--union all select '4017871800031',32409,'���� ��� 0,75*6',600,800
--union all select '7804414000655',29056,'���� Luis Felipe Edwards. ������� 2012 ����� 0,75*12',480,800
--union all select '8002235011310',31359,'���� T.Cabolani. �������� ������ ������ DOC 2013 ����� 0,75*6',504,800
--union all select '8002235572057',31279,'���� Zonin. ��������� 2013 ������� 0,75*6',630,800
--union all select '8002235395953',31802,'���� Zonin. ������� ���� ��������� 2014 ������� 0,75*6',630,800
--union all select '8028936008336',29154,'���� Villa Gritti. ������ 2011 ������� 0,75*12',480,800
--union all select '5011166055709',32318,'����� ����� �������� 40% 0,7*6',600,800
--union all select '4006714004927',29881,'����� ������ ������ 30% 0,7*6',720,800
--union all select '3068320063003',31872,'���� ����� ����������� 0,33*24 �����',2160,800
--union all select '8002235216050',26866,'���� T.Cabolani. ���� ������� ������ ������ 2010 ����� 0,75*6',630,800
--union all select '5010509415705',23126,'����� ���� ����� ��������� ����� 40% New Design 0,5*12',900,800
--union all select '8410310606892',30701,'���� Vicente Gandia. ����� ������� 2009 ������� 0,75*6',504,800
--union all select '8002235572057',26091,'���� Zonin. ��������� 2009 ������� 0,75*6',630,800
--union all select '8008820158804',34130,'���� �������� Decordi. ��������� ������ ������� 0,75*6',504,800
--union all select '4823069001537',31845,'���� T������ ���� ������ ���� ���������� ������ ����� ����������� 0,75*12',480,800
--union all select '8002235662055',27038,'���� Zonin. ����� 2010 ����� 0,75*6',630,800
--union all select '4006714004941',29880,'����� ���� ������ ������� 40% 0,7*6',720,800
--union all select '4820024226301',26696,'������ Trino ������ 1*12 � ������� + ���������',384,800
--union all select '3068320080000',3124,'���� ����� ����������� 1,0*6 � �����',720,800
--union all select '7804414000655',33486,'���� Luis Felipe Edwards. ������� 2017 ����� 0,75*12',480,800
--union all select '4823069000561',34391,'���� �������� ���� ������� ������� ������� ����� ����� 0,75*12',480,800
--union all select '7804414000655',30916,'���� Luis Felipe Edwards. ������� 2013 ����� 0,75*12',480,800
--union all select '8002235216050',30559,'���� T.Cabolani. ���� ������� ������ ������ 2012 ����� 0,75*6',630,800
--union all select '3068320103389',26168,'���� ����� ����������� 0,75*12 � ������ New',432,800
--union all select '3068320085005',32531,'���� ����� ����������� 1,5*6 ����� ',504,800
--union all select '4820024226516',4669,'������ Trino ������ 0,5*21 14,8% (�������)',630,800
--union all select '7804350004540',27576,'���� Santa Carolina. ������ �������� 2011 �����, ����������� 11,5%  0,75*12',480,800
--union all select '4062400311700',21398,'���� �������� �������� 47% 0,7*6',486,800
--union all select '8410310606977',34217,'���� Vicente Gandia. ����� 2017 ����� 0,75*6',504,800
--union all select '8002235692052',33438,'���� Zonin. ������������� 2016 ������� 0,75*6',600,800
--union all select '4867601703343',34709,'���� �������. ��������� �����, ����� 0,75*6 (�� ���������� ������������)',480,800
--union all select '5011166052845',33545,'���� ����� ����� 43% 0,7*6',480,800
--union all select '8410310607196',32032,'���� Vicente Gandia. ������� ������� 2014 ����� 0,75*6',504,800
--union all select '4820148520569',30790,'���� ������� ������� 250 ��*12',924,800
--union all select '8427894007656',34112,'���� Lozano. ���������� �� �� ���� ������ ����������, ����� 0,75*6',480,800
--union all select '8410310607110',28955,'���� Vicente Gandia. ������� ����������� ������ 2011 ������� 0,75*6',504,800
--union all select '5014218794557',33640,'����� Douglas Laing. ��� ������ ����� 46,8% 0,7*6 � ������',600,800
--union all select '8002235022323',23432,'���� Zonin. ������ "����� ����������" 2007 ������� 0,75*12',630,800
--union all select '4820139240247',31844,'����� ������ �9 0,7*12',576,800
--union all select '3700631997713',34404,'��� �������� ����  40% 0,7*6',576,800
--union all select '8002235395953',34458,'���� Zonin. ������� ���� ��������� 2016 ������� 0,75*6',630,800
--union all select '8002350133874',27046,'���� Bergaglio Nicola. ���� ���� ������ �� ���� ����� 2010 �����  0,75*12',480,800
--union all select '8002235216050',23171,'���� T.Cabolani. ���� ������� ������ ������ 2007 ����� 0,75*6',630,800
--union all select '8002235022323',31360,'���� Zonin. ������ 2013 ������� 0,75*6',630,800
--union all select '3068320055008',31873,'���� ����� ����������� 0,5*24 �����',1296,800
--union all select '8002095200046',4702,'����� ������� �������� ������ 0,75*12',576,800
--union all select '8410310607196',30703,'���� Vicente Gandia. ������� ������� 2012 ����� 0,75*6',504,800
--union all select '8002235572057',25889,'���� Zonin. ��������� 2007 ������� 0,75*6',630,800
--union all select '8008820158330',33926,'���� �������� Decordi. ��������� ����� ������� 0,75*6',504,800
--union all select '8002235022323',30733,'���� Zonin. ������ 2012 ������� 0,75*6',630,800
--union all select '8410310606977',30395,'���� Vicente Gandia. ����� 2012 ����� 0,75*6',504,800
--union all select '8002235022323',28975,'���� Zonin. ������ 2011 ������� 0,75*6',630,800
--union all select '8710521444703',28253,'����� �� ������ ������ ���� ���� 17 % 0,7*6 New Design',480,800
--union all select '5390683100629',34047,'����� ����� New Design 0,7*6',576,800
--union all select '4062400543002',4698,'������ ������ �������� 38% 1,0*12',384,800
--union all select '4905846134093',1717,'���� ��� ��������� 0,75*6',600,800
--union all select '5010509414104',26138,'����� ���� ����� ��������� ����� 40% New Design Original 0,35*24',1152,800
--union all select '3014220909101',29730,'���� Guy Saget. ��� �*���� 2011 ������� 0,75*12',480,800
--union all select '3357340306215',27425,'���� Pascal Bouchard. ����� 2010 ����� 0,75*6',480,800
--union all select '8002235662055',31282,'���� Zonin. ����� 2013 ����� 0,75*6',630,800
--union all select '5010509003087',30991,'����� ���������� (����. ����� ��������� 1,0+ �������������� ������� Fashion F88 0,25)*12',480,800
--union all select '8002235395953',28264,'���� Zonin. ������� ����� ������� 2010 ������� 0,75*6',630,800
--union all select '3014220909118',26342,'���� Guy Saget. ����� 2008  ����� 0,75*12',480,800
--union all select '4823069000578',34389,'���� �������� ���� ������� ������� ������� ����� ����������� 0,75*12',480,800
--union all select '8002235020312',31281,'���� Zonin. ���� ������� ����� ������� 2013 ����� 0,75*6',630,800
--union all select '3550142027344',22234,'������ ���������� ����� ���� ������� VS ���� ��� ������� 40% 0,7*6 � ������ + VS�� ���� ��� ������� 0,05*12',384,800
--union all select '3014220909118',29732,'���� Guy Saget. ����� 2011 ����� 0,75*12',480,800
--union all select '8028936008336',28284,'���� Villa Gritti. ������ 2010 ������� 0,75*12',480,800
--union all select '8002235022323',31803,'���� Zonin. ������ 2014 ������� 0,75*6',630,800
--union all select '4603928000983',30902,'����� ������ ���� 1,0*6',384,800
--union all select '5390683100636',29120,'����� ����c 1,0*12',360,800
--union all select '3014220909101',25940,'���� Guy Saget. ��� �*���� 2009 ������� 0,75*12',480,800
--union all select '5014218792102',31996,'����� Douglas Laing. ��������� ����� 46% 0,7*6 � ������ ',600,800
--union all select '7804414000655',32574,'���� Luis Felipe Edwards. ������� 2016 ����� 0,75*12',480,800
--union all select '8713427000073',4145,'����� �� ������ ���� ������ (��������-����������) 14,5 % 0,7*6',750,800
--union all select '8410310606892',32914,'���� Vicente Gandia. ����� ������� 2014 ������� 0,75*6',504,800
--union all select '5011166057116',34337,'���� ����� ����� ������� 43% 0,7*6',480,800
--union all select '8427894007632',23774,'���� Lozano. ���������� �� �� ���� ����� ����������, ������� 0,75*12',480,800
--union all select '8002235692052',24254,'���� Zonin. �������������  2007 ������� 0,75*6',600,800
--union all select '5010509001229',23128,'����� ���� ����� ��������� ����� 40% New Design 0,7*12 � �������',576,800
--union all select '4820073560739',27595,'������ ������� ��� ���� �� ��� VS 0,5*6',576,800
--union all select '3014220909118',31597,'���� Guy Saget. ����� 2013 ����� 0,75*12',480,800
--union all select '8002235572057',31632,'���� Zonin. ��������� 2014 ������� 0,75*6',630,800
--union all select '8002235020312',26108,'���� Zonin. ���� ������� ����� ������� 2009 ����� 0,75*6',630,800
--union all select '3068320103631',24022,'���� ����� ����������� 0,33*20 � ������',800,800
--union all select '4860053012650',33850,'������ ������� ���� 8 ��� 40%  0,5*12',720,800
--union all select '8002235011310',27043,'���� T.Cabolani. �������� ������ ������ DOC 2010 ����� 0,75*6',504,800
--union all select '5010509001229',26137,'����� ���� ����� ��������� ����� 40% New Design Original 0,7*12 � �������� � ������',576,800
--union all select '3068320103631',30740,'����� ����������� ��������� �������� ���� ����� (4 ���.*0,33 � ������)*4',800,800
--union all select '8002235662055',30734,'���� Zonin. ����� 2012 ����� 0,75*6',630,800
--union all select '3395940520709',31957,'���� Aujoux. ��� ��� ������� ����������� 0,75*12',600,800
--union all select '5010509414081',4213,'����� ���� ����� ��������� ����� 40% 1,0*4 + 2 ������� � �������',384,800
--union all select '8002350133881',31963,'���� Bergaglio Nicola. ���� ���� ������ �� ���� 2014 ����� 0,75*12',480,800
--union all select '4823069001513',31847,'���� T������ ���� ������ ���� �������� ������� ����� 0,75*12',480,800
--union all select '8002235572057',34658,'���� Zonin. ��������� 2017 ������� 0,75*6',630,800
--union all select '4823069001216',34392,'���� �������� ������� �������� ������� ������� ������� ����� 0,75*12',480,800
--union all select '4006714004958',29874,'��� ���� ������� ���� 38% 0,7*6',600,800
--union all select '4062400542005',33601,'������ ������ ������� 38% 1,5*6',216,800
--union all select '8002350133881',31271,'���� Bergaglio Nicola. ���� ���� ������ �� ���� 2013 �����  0,75*12',480,800
--union all select '4820139240247',32020,'����� ������ �9 0,7*6',576,800
--union all select '3395940520662',31959,'���� Aujoux. ��� ���� ����� ����������� 0,75*12',600,800
--union all select '7804414000655',28938,'���� Luis Felipe Edwards. ������� 2011 ����� 0,75*12',480,800
--union all select '4867601703374',28240,'���� �������. ������������ �������, ����������� 0,75*12 (�� ���������� ������������)',480,800
--union all select '8002095200046',23090,'������� �������� ������ �����  0,75*2 + 2 ������� � ������� �����',576,800
--union all select '3550142025463',25216,'������ ���� ������� VS ���� ��� ������� 40% ������ 0,5*12',576,800
--union all select '8002235022811',33685,'���� Zonin. ������� ���� ��������� 2016 ����� 0,75*6',630,800

--	SELECT * FROM #ProdsPalet ORDER BY 3
	
--END



