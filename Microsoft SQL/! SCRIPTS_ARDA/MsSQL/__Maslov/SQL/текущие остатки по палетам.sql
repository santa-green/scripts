--������� ������� �� �������
SELECT OurID, StockID, SecID, ProdID, PPID, Qty, AccQty 
, (SELECT ProdName FROM r_Prods p where p.ProdID = r.ProdID) ProdName
, (SELECT top 1 mq.BarCode FROM r_ProdMQ mq where mq.ProdID = r.ProdID ) BarCode
, (SELECT p.WeightGr FROM r_Prods p where p.ProdID = r.ProdID) WeightGr
, (SELECT top 1 pp.ProdBarCode FROM t_PInP pp where pp.ProdID = r.ProdID and pp.ProdBarCode <> '' ORDER BY PPID desc) ProdBarCode
, CEILING  (isnull(Qty/(SELECT top 1 QtyInPalet FROM #ProdsPalet pal where pal.ProdID = r.ProdID),1)) palet
,Qty/CEILING  (isnull(Qty/(SELECT top 1 QtyInPalet FROM #ProdsPalet pal where pal.ProdID = r.ProdID),1))*(SELECT p.WeightGr FROM r_Prods p where p.ProdID = r.ProdID) '�����_��_������'
FROM t_rem r
where stockid in (220,218) and qty <> 0 

--and r.ProdID in (2424)
and r.ProdID in (31878,29873,33926,34130,31879,32142,34111,3127,32142,30497,26213,     30766,30767,28246,28245,30497,4165,4167,26135,26136,26137,26133,26139,3127,26168,26213,30843,31878,31879,31880,32143,32142,32144)
--ORDER BY �����_��_������ desc
ORDER BY 6 desc



IF 1=0
BEGIN
	--������� ���������� ��
	IF OBJECT_ID (N'tempdb..#ProdsPalet', N'U') IS NOT NULL DROP TABLE #ProdsPalet
	CREATE TABLE #ProdsPalet (Num INT IDENTITY(1,1) NOT NULL ,ProdID INT null, TaxDocDate varchar(250) null, QtyInPalet INT NULL, WidthPalet NUMERIC(21,9))
		
	INSERT #ProdsPalet
	--="union all select "&C4&",'"&�����(D4;"����-��-��")&"',"&H4&","&L4&""
select           30766,'������ Trino ������ 0,5*21 14,8% Design 2013',504,800
union all select 30767,'������ Trino ������ 1*12 14,8% Design 2013',384,800
union all select 28246,'���� �������. ���������� ������ �����, ����������� 0,75*12',480,1000
union all select 28245,'���� �������. ���������� ������ �������, ����������� 0,75*12 ',480,1000
union all select 30497,'����� ���� ��������� 40% 0,5*12',768,1000
union all select 4165,'����� ���� ��������� 40% 0,7*12',840,1000
union all select 4167,'����� ���� ��������� 40% 1,0*12',480,1000
union all select 26135,'����� ���� ����� ��������� ����� 40% New Design Original 0,5*12',1140,1000
union all select 26136,'����� ���� ����� ��������� ����� 40% New Design Original 0,7*12',768,1000
union all select 26137,'����� ���� ����� ��������� ����� 40% New Design Original 0,7*12 � �������',768,1000
union all select 26133,'����� ���� ����� ��������� ����� 40% New Design Original 1,0*12',576,1000
union all select 26139,'����� ���� ����� ��������� ����� 40% New Design Original 1,0*12 � �������',576,1000
union all select 3127,'���� ����� ����������� 1,5*6',504,800
union all select 26168,'���� ����� ����������� 0,75*12 � ������ New',780,1000
union all select 26213,'���� ����� ����������� 0,33*20 � ������ New',1540,1000
union all select 30843,'���� ����� ����������� ����� 0,75*6 New Design',1080,1000
union all select 31878,'���� ����� ����������� 0,33*24 Prestige',3120,1000
union all select 31879,'���� ����� ����������� 0,5*24 Prestige',2016,1000
union all select 31880,'���� ����� ����������� 1,0*12 Prestige',1008,1000
union all select 32143,'����� ������ 40% 0,7*12',600,800
union all select 32142,'����� ������ 40% 0,5*15',825,800
union all select 32144,'����� ������ 40% 1,0*12',336,800
union all select 29873,'���� ������ 37,5% 0,7*6',396,800
union all select 33926,'���� �������� Decordi. ��������� ����� ������� 0,75*6',630,800
union all select 34111,'���� �������� Decordi. ��������� ������ ������� 0,75*6',630,800
union all select 34130,'���� Lozano. ���������� �� �� ���� ����� ����������, ������� 0,75*6',750,800

	SELECT * FROM #ProdsPalet
	
END


SELECT OurID, StockID, SecID, ProdID, PPID, Qty, AccQty 
, (SELECT ProdName FROM r_Prods p where p.ProdID = r.ProdID) ProdName
, (SELECT p.WeightGr FROM r_Prods p where p.ProdID = r.ProdID) WeightGr
, (SELECT top 1 mq.BarCode FROM r_ProdMQ mq where mq.ProdID = r.ProdID ) BarCode
, (SELECT top 1 pp.ProdBarCode FROM t_PInP pp where pp.ProdID = r.ProdID and pp.ProdBarCode <> '' ORDER BY PPID desc) ProdBarCode
FROM t_rem r
where stockid in (220,218) and qty <> 0 ORDER BY 6 desc



SELECT p.* FROM r_Prods p where p.ProdID = 31878


	EXECUTE AS LOGIN = 'pvm0' -- ��� ������� OPENROWSET('Microsoft.ACE.OLEDB.12.0'
	--GO
	--REVERT

	--��������� ���������� �� �������
	IF OBJECT_ID (N'tempdb..#uCat', N'U') IS NOT NULL DROP TABLE #uCat
	SELECT *
	 INTO #uCat
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\EDI\uCat_������.xls' , 'select * from [��������$]') as ex;
	
	SELECT UnitDescriptor, id, GTIN, ChildGTIN, DescriptionTextRu, QuantityOfChild, QuantityOfLayersPerPallet, QuantityOfTradeItemsPerPalletLayer FROM #uCat
	where UnitDescriptor = 'CASE'

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
	    SET @qty = @qty * (SELECT ISNULL(CAST(QuantityOfChild AS INT),1)*ISNULL(CAST(QuantityOfLayersPerPallet AS INT),1)*ISNULL(CAST(QuantityOfTradeItemsPerPalletLayer AS INT),1) FROM #uCat WHERE id = @ID)
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
SELECT * FROM #res WHERE barcode = 3068320063003