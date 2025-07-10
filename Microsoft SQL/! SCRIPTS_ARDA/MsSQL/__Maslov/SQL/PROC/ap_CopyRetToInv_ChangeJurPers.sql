ALTER PROC [dbo].[ap_CopyRetToInv_ChangeJurPers] @Docs VARCHAR(MAX), @OurID INT, @CompID INT, @CompAddID INT, @RetPrices BIT, @Out INT OUT
AS
BEGIN
/*Процедура для инструмента "Копирование: Возврат товара – Расходная накладная (Смена юр.лица)"*/

/*

BEGIN TRAN;
DECLARE @a INT
EXEC [dbo].[ap_CopyRetToInv_ChangeJurPers] @Docs = '129523', @OurID = 1, @CompID = 71715, @CompAddID = 1, @RetPrices = 0, @Out = @a OUT

SELECT * FROM t_Inv WHERE ChID = @a
SELECT * FROM t_InvD WHERE ChID = @a
ROLLBACK TRAN;

*/

/*
DECLARE @ChID INT
DECLARE @CurrID INT, @PriceCC_wt NUMERIC(21,9)

EXEC dbo.z_DocLookup N'CurrID', 11003, @ChID, @CurrID OUT
SELECT dbo.zf_GetRateMC(@CurrID)

SELECT PLID FROM r_Comps WITH(NOLOCK) WHERE CompID = 71715 OPTION(FAST 1)  
DECLARE @a INT = -1
SELECT @a = q.PLID--, q.Discount
FROM
(
	SELECT ardc.DiscCode, ardc.CompID, ardplm.DiscPLID, ardp.PLID, arpmdp.ProdID, arpmdp.Discount
	FROM at_r_DiscComps ardc WITH(NOLOCK)
	JOIN at_r_DiscPLMaps ardplm ON ardplm.DiscCode = ardc.DiscCode
	LEFT JOIN at_r_DiscPls ardp ON ardp.DiscPLID = ardplm.DiscPLID
	JOIN at_r_ProdMDP arpmdp ON arpmdp.DiscPLID = ardp.DiscPLID
	WHERE ardc.CompID = 71715 AND arpmdp.ProdID = 34624 AND '20200518' BETWEEN ardc.BDate AND CASE WHEN ardc.EDate != '' OR ardc.EDate IS NOT NULL THEN ardc.EDate ELSE '20790606' END
) q
SELECT @a
EXEC [dbo].[t_GetPriceCCPL] @ProdID = 34624, @RateMC = 28, @Discount = 0, @PLID = 25, @Result = @PriceCC_wt OUTPUT

SELECT @PriceCC_wt

*/

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] Maslov Oleg '2020-05-15 17:33:46.517' Предыдущая версия всего скрипта находится в файле "Копирование - ВТ - РН (Смена юр. лица)_15-05-2020_14-49.fr3". Перенес его в процедуру.
--[ADDED] Maslov Oleg '2020-05-15 17:34:36.578' Добавил возможность устанавливать акционные цены в РН, если они есть.
--[ADDED] Maslov Oleg '2020-05-15 17:36:53.295' Добавил возможность брать цены напрямую из возврата.
--[ADDED] Maslov Oleg '2020-05-18 11:50:50.982' По заявке от Танцюры. Теперь поля "Территория" и "Усл.оплаты" тоже копируются из возврата.
--[CHANGED] Maslov Oleg '2020-05-18 17:29:43.215' По заявке от Танцюры. Теперь акция подключается, если дата документа попадает в период установленный для предприятия.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET XACT_ABORT ON
SET NOCOUNT ON
/*
DECLARE @OurID INT = :OurID
DECLARE @Docs VARCHAR(MAX) = :Docs
DECLARE @CompID INT = :CompID    
DECLARE @CompAddID INT = :CompAddID
*/
DECLARE @Ch TABLE(ChID INT PRIMARY KEY)
INSERT @Ch SELECT ChID FROM t_Ret WHERE OurID = @OurID AND DocID IN (SELECT AValue FROM dbo.zf_FilterToTable(@Docs))
    
IF NOT EXISTS(SELECT * FROM @Ch)
BEGIN
  RAISERROR('Нет данных для начала копирования!', 18, 1)
  RETURN
END

--IF EXISTS(SELECT * FROM t_Ret WHERE ChID IN (SELECT * FROM @Ch) AND NOT (CodeID2 = 69 AND CodeID3 = 4 AND CompID != @CompID))
--BEGIN
--  RAISERROR('Документ не соответствует необходимым критериям для начала копирования (Признак 2 = 69, Признак 3 = 4, Предприятие не из документа-источника)!', 18, 1)
--  RETURN
--END

IF EXISTS(SELECT * FROM t_Ret WHERE ChID IN (SELECT * FROM @Ch) HAVING COUNT(DISTINCT(OurID)) != 1)
BEGIN
  RAISERROR('Указанные документы имеют разные значения параметра: Фирма.', 18, 1)
  RETURN
END
ELSE IF EXISTS(SELECT * FROM t_Ret WHERE ChID IN (SELECT * FROM @Ch) HAVING COUNT(DISTINCT(StockID)) != 1)
BEGIN
  RAISERROR('Указанные документы имеют разные значения параметра: Склад.', 18, 1)
  RETURN
END
ELSE IF EXISTS(SELECT * FROM t_Ret WHERE ChID IN (SELECT * FROM @Ch) HAVING COUNT(DISTINCT(CodeID1)) != 1)
BEGIN
  RAISERROR('Указанные документы имеют разные значения параметра: Признак 1.', 18, 1)
  RETURN
END
ELSE IF EXISTS(SELECT * FROM t_Ret WHERE ChID IN (SELECT * FROM @Ch) HAVING COUNT(DISTINCT(DocDate)) != 1)
BEGIN
  RAISERROR('Указанные документы имеют разные значения параметра: Дата.', 18, 1)
  RETURN
END
ELSE IF EXISTS(SELECT * FROM t_Ret WHERE ChID IN (SELECT * FROM @Ch) HAVING COUNT(DISTINCT(CurrID)) != 1)
BEGIN
  RAISERROR('Указанные документы имеют разные значения параметра: Валюта.', 18, 1)
  RETURN
END
ELSE IF EXISTS(SELECT * FROM t_Ret a JOIN r_Comps b ON b.CompID = a.CompID WHERE a.ChID IN (SELECT * FROM @Ch) HAVING COUNT(DISTINCT(b.Code)) != 1)
BEGIN
  RAISERROR('Указанные документы имеют разные значения параметра: ОКПО.', 18, 1)
  RETURN
END

BEGIN TRAN

DECLARE @ChID INT
DECLARE @DocID INT
DECLARE @CurrID INT
DECLARE @PLID INT                                      
DECLARE @RateMC NUMERIC(21,9)
--[CHANGED] Maslov Oleg '2020-05-18 17:29:43.215' По заявке от Танцюры. Теперь акция подключается, если дата документа попадает в период установленный для предприятия.
DECLARE @RDocDate SMALLDATETIME = (SELECT TOP 1 DocDate FROM dbo.t_Ret WHERE ChID IN (SELECT ChID FROM @Ch))

EXEC dbo.z_DocLookup N'CurrID', 11003, @ChID, @CurrID OUT
    
SET @RateMC = dbo.zf_GetRateMC(@CurrID)

EXEC dbo.z_NewChID t_Inv, @ChID OUT
EXEC dbo.z_NewDocID 11012, t_Inv, @OurID, @DocID OUT

--[ADDED] Maslov Oleg '2020-05-18 11:50:50.982' По заявке от Танцюры. Теперь поля "Территория" и "Усл.оплаты" тоже копируются из возврата.
--INSERT dbo.t_Inv (ChID,DocID,IntDocID,DocDate,KursMC,OurID,StockID,CompID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,Notes,CurrID,Address,DelivID,KursCC,DriverID,CompAddID,SrcDocID,SrcDocDate)
INSERT dbo.t_Inv (ChID,DocID,IntDocID,DocDate,KursMC,OurID,StockID,CompID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,Notes,CurrID,Address,DelivID,KursCC,DriverID,CompAddID,SrcDocID,SrcDocDate,TerrID,PayConditionID)
SELECT TOP 1 @ChID ChID, @DocID DocID, @DocID IntDocID, DocDate, rcr.KursMC, OurID, StockID, @CompID CompID, CodeID1, 48 CodeID2, CodeID3, CodeID4, 0 CodeID5, Notes, m.CurrID, rca.CompAdd Address, m.DelivID, rcr.KursCC, m.DriverID, rca.CompAddID, m.DocID SrcDocID, m.DocDate SrcDocDate
			,m.TerrID,m.PayConditionID
FROM dbo.t_Ret m
JOIN dbo.r_Currs rcr ON rcr.CurrID = m.CurrID
JOIN dbo.r_CompsAdd rca ON rca.CompID = @CompID AND rca.CompAddID = @CompAddID
WHERE m.ChID IN (SELECT * FROM @Ch)
AND m.CodeID2  in (69,96)        
AND m.CodeID3 = 4
OPTION(FAST 1)

DECLARE @SrcPosID INT, @ProdID INT, @PPID INT, @UM VARCHAR(200), @Qty NUMERIC(21,9), @BarCode VARCHAR(30), @SecID INT, @PriceCC_wt NUMERIC(21,9), @Discount NUMERIC(21,9)

DECLARE DetailData CURSOR FAST_FORWARD LOCAL
FOR
  --[ADDED] Maslov Oleg '2020-05-15 17:36:53.295' Добавил возможность брать цены напрямую из возврата.
  SELECT ROW_NUMBER() OVER(ORDER BY MAX(ChID), MAX(SrcPosID)) SrcPosID, ProdID, PPID, UM, SUM(Qty), BarCode, SecID, PriceCC_wt
  FROM dbo.t_RetD
  WHERE ChID IN (SELECT * FROM @Ch)
  GROUP BY ProdID, PPID, UM, BarCode, SecID, PriceCC_wt
  ORDER BY 1

OPEN DetailData
FETCH NEXT FROM DetailData INTO @SrcPosID, @ProdID, @PPID, @UM, @Qty, @BarCode, @SecID, @PriceCC_wt

WHILE (@@FETCH_STATUS = 0)
BEGIN      
  
  --[ADDED] Maslov Oleg '2020-05-15 17:34:36.578' Добавил возможность устанавливать акционные цены в РН, если они есть.
  IF @RetPrices = 0
  BEGIN 
  
	  --Если товар участвует в активной акции, которая привязана к предприятию, то достаем значение скидки.
	  IF EXISTS(SELECT TOP 1 1
				FROM at_r_DiscComps ardc WITH(NOLOCK)
				JOIN at_r_DiscPLMaps ardplm ON ardplm.DiscCode = ardc.DiscCode
				LEFT JOIN at_r_DiscPls ardp ON ardp.DiscPLID = ardplm.DiscPLID
				JOIN at_r_ProdMDP arpmdp ON arpmdp.DiscPLID = ardp.DiscPLID
				WHERE ardc.CompID = @CompID AND arpmdp.ProdID = @ProdID AND @RDocDate BETWEEN ardc.BDate AND CASE WHEN ardc.EDate != '' OR ardc.EDate IS NOT NULL THEN ardc.EDate ELSE '20790606' END)
		--Получаем значение скидки для цены указанного в акции прайс-листа.
		SELECT @PLID = q.PLID, @Discount = q.Discount
		FROM
		( 
			SELECT DISTINCT TOP 1 ardp.PLID, arpmdp.Discount
			FROM at_r_DiscComps ardc WITH(NOLOCK)
			JOIN at_r_DiscPLMaps ardplm ON ardplm.DiscCode = ardc.DiscCode
			LEFT JOIN at_r_DiscPls ardp ON ardp.DiscPLID = ardplm.DiscPLID
			JOIN at_r_ProdMDP arpmdp ON arpmdp.DiscPLID = ardp.DiscPLID
			WHERE ardc.CompID = @CompID AND arpmdp.ProdID = @ProdID AND @RDocDate BETWEEN ardc.BDate AND CASE WHEN ardc.EDate != '' OR ardc.EDate IS NOT NULL THEN ardc.EDate ELSE '20790606' END
		) AS q
	  ELSE
		SELECT @PLID = PLID, @Discount = 0 FROM r_Comps WITH(NOLOCK) WHERE CompID = @CompID OPTION(FAST 1)                                                                                                                                              

	  EXEC [dbo].[t_GetPriceCCPL] @ProdID = @ProdID, @RateMC = @RateMC, @Discount = @Discount, @PLID = @PLID, @Result = @PriceCC_wt OUTPUT        
  
  END;

  SET @PriceCC_wt = ROUND(dbo.zf_CorrectPriceForTaxProd(@PriceCC_wt, @ProdID, dbo.zf_GetDate(GETDATE())), 8)  
    
  INSERT dbo.t_InvD (ChID,SrcPosID,ProdID,PPID,UM,Qty,
    PriceCC_nt,SumCC_nt,
    Tax,TaxSum,PriceCC_wt,SumCC_wt,BarCode,SecID)
  SELECT @ChID ChID,@SrcPosID,@ProdID,@PPID,@UM,@Qty,
    dbo.zf_GetProdPrice_nt(@PriceCC_wt, @ProdID, dbo.zf_GetDate(GETDATE())) PriceCC_nt, dbo.zf_GetProdPrice_nt(@PriceCC_wt, @ProdID, dbo.zf_GetDate(GETDATE())) * @Qty SumCC_nt,
    dbo.zf_GetProdPrice_wtTax(@PriceCC_wt, @ProdID, dbo.zf_GetDate(GETDATE())) Tax, dbo.zf_GetProdPrice_wtTax(@PriceCC_wt, @ProdID, dbo.zf_GetDate(GETDATE())) * @Qty TaxSum,
    @PriceCC_wt PriceCC_wt, @PriceCC_wt * @Qty SumCC_wt, @BarCode, @SecID

  FETCH NEXT FROM DetailData INTO @SrcPosID, @ProdID, @PPID, @UM, @Qty, @BarCode, @SecID, @PriceCC_wt
END
CLOSE DetailData
DEALLOCATE DetailData                                   

IF @@TRANCOUNT > 0
  COMMIT

SET @Out = @ChID

END;