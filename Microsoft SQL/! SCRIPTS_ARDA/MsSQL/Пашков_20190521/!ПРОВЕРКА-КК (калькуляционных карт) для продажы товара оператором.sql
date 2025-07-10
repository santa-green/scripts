DECLARE    @Msg VARCHAR(MAX) = '', @STR VARCHAR(MAX), @PSTR VARCHAR(255) = ''
DECLARE 
@BDate SMALLDATETIME = '2018-05-01',
@EDate SMALLDATETIME = '2018-05-22', 
@Date SMALLDATETIME, 
@OurID INT = NULL, @StockID INT = NULL, @DocCode INT = NULL

IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable

CREATE TABLE #temptable (Date DATE NULL, ProdID INT NULL, OurID INT NULL, StockID INT NULL, SubStockID INT NULL, DepID INT NULL, ProdName VARCHAR(255), Msg VARCHAR(max))

SET NOCOUNT ON -- Запрещает вывод количества строк запроса (для ускорения)
 
SET @Date = @BDate

WHILE @Date <= @EDate
BEGIN--@Date <= @EDate
	DECLARE Cur_OurID_StockID CURSOR  FOR
		SELECT distinct u.number as OurID, s.number as StockID 
		FROM master.dbo.spt_values u, master.dbo.spt_values s 
		where u.number in (6,9,12) and s.number in (1001,1202,1252,1257,1260,1310,1314,1315)
		ORDER BY 1,2

	OPEN Cur_OurID_StockID
    FETCH NEXT FROM Cur_OurID_StockID INTO @OurID, @StockID
    WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF EXISTS(SELECT 1
			FROM t_Sale m WITH(NOLOCK)
			JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
			JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892,800895,800896)
			JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
			JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID AND mp.DepID <>0
			JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
			WHERE m.DocDate = @Date  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22 
			AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID)))
		BEGIN  
			SELECT 'Отчет за дату: ' + convert(CHAR(10), @Date, 112) + '  по фирме ' + cast(@OurID as CHAR(10)) + ' и складу ' + cast(@StockID as CHAR(10))
			
			--проверка товаров
			SELECT d.ProdID, m.OurID, rss.StockID, rss.SubStockID, rss.DepID, rp.ProdName  --, *
			FROM t_Sale m WITH(NOLOCK)
			JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
			JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892,800895,800896)
			JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
			JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID AND mp.DepID <>0
			JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
			WHERE m.DocDate = @Date  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22 
			AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID))	
			
			--проверка карт
			SET @Msg = ''
			SELECT @Msg = @Msg + ',' + CAST(ProdID AS VARCHAR(10))
			FROM (SELECT DISTINCT f.ProdID
				FROM t_Sale m WITH(NOLOCK)
				JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
				JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892)
				JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
				JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID
				JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
				CROSS APPLY [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID) f
				WHERE m.DocDate = @Date  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22) q
			SELECT @STR = SUBSTRING(@Msg,2,65535)
			SET @Msg = ''
			WHILE LEN(@STR) > 0
			BEGIN
				SET @PSTR = LEFT(@STR, 100)
				SET @STR = SUBSTRING(@STR,101,16000000)
				SET @Msg = @Msg + @PSTR + CHAR(13) + CHAR(10)
			END
			SELECT @Msg 'Для товаров не созданы калькуляционные карты!'

			--записть изменений цен по всем прайсам во временную таблицу #temptable 
			INSERT  #temptable  
				SELECT convert(CHAR(10), @Date, 112) as 'Дата', d.ProdID, m.OurID, rss.StockID, rss.SubStockID, rss.DepID, rp.ProdName, @Msg as 'товары без карт'  --, *
				FROM t_Sale m WITH(NOLOCK)
				JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
				JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892,800895,800896)
				JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
				JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID AND mp.DepID <>0
				JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
				WHERE m.DocDate = @Date  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22 
				AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID))	

		END
	
		FETCH NEXT FROM Cur_OurID_StockID INTO @OurID, @StockID
	END		

    CLOSE Cur_OurID_StockID
    DEALLOCATE Cur_OurID_StockID

	--увеличение даты на 1 день
	SELECT @Date = DATEADD(day,1,@Date) 
	
END--@Date <= @EDate

SELECT * FROM #temptable ORDER BY Date, OurID , StockID		



    

SELECT '##############################################################################'
SELECT 'проверка 2 для складов 1001,1257,1260'	

SET @Date = @BDate

WHILE @Date <= @EDate
BEGIN--@Date <= @EDate
	DECLARE Cur_OurID_StockID CURSOR  FOR
		SELECT distinct u.number as OurID, s.number as StockID 
		FROM master.dbo.spt_values u, master.dbo.spt_values s 
		where u.number in (6,12) and s.number in (1001,1257,1260)
		ORDER BY 1,2

	OPEN Cur_OurID_StockID
    FETCH NEXT FROM Cur_OurID_StockID INTO @OurID, @StockID
    WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF EXISTS(SELECT 1
			FROM t_Sale m WITH(NOLOCK)
			JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
			JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892,800895,800896) AND rp.pgrid1 = 208 /* допил только готовые блюда */
			JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
			JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID --AND mp.DepID <>0
			JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
			WHERE m.DocDate = @Date  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22 
			AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID)))
		BEGIN  
			SELECT 'Отчет за дату: ' + convert(CHAR(10), @Date, 112) + '  по фирме ' + cast(@OurID as CHAR(10)) + ' и складу ' + cast(@StockID as CHAR(10))
			
			--проверка товаров
			SELECT d.ProdID, m.OurID, rss.StockID, rss.SubStockID, rss.DepID, rp.ProdName  --, *
			FROM t_Sale m WITH(NOLOCK)
			JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
			JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892,800895,800896) AND rp.pgrid1 = 208 /* допил только готовые блюда */
			JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
			JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID --AND mp.DepID <>0
			JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
			WHERE m.DocDate = @Date  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22 
			AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID))	
			
			--проверка карт
			SET @Msg = ''
			SELECT @Msg = @Msg + ',' + CAST(ProdID AS VARCHAR(10))
			FROM (SELECT DISTINCT f.ProdID
				FROM t_Sale m WITH(NOLOCK)
				JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
				JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892) AND rp.pgrid1 = 208 /* допил только готовые блюда */
				JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
				JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID
				JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
				CROSS APPLY [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID) f
				WHERE m.DocDate = @Date  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22) q
			SELECT @STR = SUBSTRING(@Msg,2,65535)
			SET @Msg = ''
			WHILE LEN(@STR) > 0
			BEGIN
				SET @PSTR = LEFT(@STR, 100)
				SET @STR = SUBSTRING(@STR,101,16000000)
				SET @Msg = @Msg + @PSTR + CHAR(13) + CHAR(10)
			END
			SELECT @Msg 'Для товаров не созданы калькуляционные карты!'
		END
	
		FETCH NEXT FROM Cur_OurID_StockID INTO @OurID, @StockID
	END		

    CLOSE Cur_OurID_StockID
    DEALLOCATE Cur_OurID_StockID

	--увеличение даты на 1 день
	SELECT @Date = DATEADD(day,1,@Date) 
	
END--@Date <= @EDate