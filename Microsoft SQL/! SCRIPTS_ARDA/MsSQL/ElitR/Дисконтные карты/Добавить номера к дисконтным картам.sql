USE ElitR;

--скрипт для записи мобильных телефонов в информацию к дисконтной карте, если такая карта есть
--и номер телефона к ней не привязан

/*
IF OBJECT_ID (N'tempdb..#DCards', N'U') IS NOT NULL DROP TABLE #DCards -- выгрузка данных из Excel
SELECT CAST(CAST(ex.card AS BIGINT) as VARCHAR) card, CAST(CAST(ex.tel AS BIGINT) as VARCHAR) tel 
 INTO #DCards	
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\test\DisCards.xlsx' , 'select * from [Лист1$]') as ex
*/

IF OBJECT_ID (N'tempdb..#DCards', N'U') IS NOT NULL DROP TABLE #DCards -- выгрузка данных из Excel

CREATE TABLE #DCards (ID INT IDENTITY(1,1) NOT NULL, card varchar(50) NULL, tel varchar(50) NULL)
		
INSERT #DCards

--EXCEL: ="union all select "&"'"&A2&"', "&"'"&B2&"'"
		
		  select '2220000150927', '380955170063'
union all select '2220000400411', '380662095056'
union all select '2220000397346', '380675637136'
union all select '2220000228008', '380675611348'
union all select '2220000400275', '380995152775'
union all select '2220000171816', '380674887707'
union all select '2220000156455', '380665193195'
union all select '2220000175333', '380671180962'
union all select '2220000008464', '380679733635'
union all select '2220000190947', '380672643814'
union all select '2220000400305', '380952520924'
union all select '2220000396110', '380503401273'
union all select '2500000013638', '380676328223'
union all select '2220000400374', '380675680110'
union all select '2220000192545', '380636348570'
union all select '2220000194167', '380966045742'
union all select '2220000069731', '380986095289'
union all select '2220000396110', '380503401273'
union all select '2220000052733', '380504516904'


SELECT '' AS 'Список карт для обновления № телефонов:', * FROM #DCards
SELECT DISTINCT CARD AS 'Уникальных карт:' FROM #DCards
--SELECT	* FROM	dbo.r_DCards rd	WHERE	rd.DCardID	IN ('2220000004022', '2220000397445')

-- Если находит карты - их нет в БД (если пусто - все карты уже есть в БД).
SELECT  '' AS 'Если находит карты - их нет в БД (если пусто - все карты есть в БД).', * FROM #DCards 
WHERE (CAST(CAST(card AS BIGINT) as VARCHAR)) NOT IN (SELECT DCardID FROM r_DCards)

-- Если у карт из списка Excel уже есть номера телефона. Пусто - номеров нет.
SELECT  '' AS 'Если у карт из списка Excel уже есть номера телефона. Пусто - номеров нет.',* FROM r_DCards RD
WHERE DCardID in (SELECT CAST(CAST(card AS BIGINT) as VARCHAR) FROM #DCards)
AND (PhoneMob <> '') 
AND PhoneMob <> (SELECT CAST(CAST(TEL AS BIGINT) as VARCHAR) FROM #DCards D WHERE D.card = RD.DCardID)
--AND PhoneMob NOT IN (SELECT CAST(CAST(tel AS BIGINT) as VARCHAR) FROM #DCards)

--SELECT	* FROM dbo.z_Tables zt	WHERE	zt.TableName	= 'r_DCards'
--SELECT	* FROM	dbo.r_DCards rd	
--r_DCards = Справочник дисконтных карт

BEGIN TRAN;
	UPDATE r_DCards
	SET PhoneMob = CAST(CAST(trdc.tel AS BIGINT) as VARCHAR)
	FROM r_DCards rdc
	JOIN #DCards trdc WITH(NOLOCK) ON rdc.DCardID = trdc.card--CAST(CAST(trdc.card AS BIGINT) as VARCHAR)
	--WHERE rdc.PhoneMob IS NULL

	SELECT * FROM r_DCards
	WHERE DCardID in (SELECT card FROM #DCards)
	--AND PhoneMob IS NULL
ROLLBACK TRAN;