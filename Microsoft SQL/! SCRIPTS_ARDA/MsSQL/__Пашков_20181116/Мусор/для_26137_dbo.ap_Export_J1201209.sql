ALTER PROC [dbo].[ap_Export_J1201209] @ChID INT, @DocCode INT = 0
AS 

BEGIN
  SET NOCOUNT ON

--  DECLARE @ChID INT = (SELECT MAX(ChID) FRom t_Inv WHERE TaxDocID > 0  AND TSumCC_wt > 10000) 

  
    DECLARE @HeadTbl TABLE
  (
    [EDR_POK] VARCHAR(MAX),
    [FIRM_ADR] VARCHAR(MAX),
    [FIRM_EDRPOU] VARCHAR(MAX),
    [FIRM_INN] VARCHAR(MAX),
    [FIRM_NAME] VARCHAR(MAX),
    [N1] VARCHAR(MAX),
    [N17] VARCHAR(MAX),
    [N18] VARCHAR(MAX),
    [N10] VARCHAR(MAX),
	[INN] VARCHAR(MAX),
    [N12] VARCHAR(MAX),
    [N15] VARCHAR(MAX),
    [N16] VARCHAR(MAX),
    [N1_11] VARCHAR(MAX),
    [N1I] VARCHAR(MAX),
    [N2] VARCHAR(MAX),
    [N2_1] VARCHAR(MAX),
    [N2_11] VARCHAR(MAX),
    [N2_2] VARCHAR(MAX),
    [N2_3] VARCHAR(MAX),
    [N3] VARCHAR(MAX),
    [N4] VARCHAR(MAX),
	[Dept_Pok] VARCHAR(MAX),
    [N5] VARCHAR(MAX),
    [N6] VARCHAR(MAX),
    [N8] VARCHAR(MAX),
    [N81] VARCHAR(MAX),
    [N82] VARCHAR(MAX),
    [N9] VARCHAR(MAX),
    [PHON] VARCHAR(MAX),
    [A1_9] VARCHAR(MAX),
    [A2_9] VARCHAR(MAX),
	[A2_92] VARCHAR(MAX),
	[N26] VARCHAR(MAX)
	
  )

  DECLARE @DetTbl TABLE
  (
    [SID] SMALLINT,
	[TAB1_A01] VARCHAR(MAX),
    TAB1_A1 VARCHAR(MAX),
    TAB1_A2 VARCHAR(MAX),
    TAB1_A3 VARCHAR(MAX),
    TAB1_A31 VARCHAR(MAX),
	TAB1_A32 VARCHAR(MAX),
	TAB1_A33 VARCHAR(MAX),
    TAB1_A4 VARCHAR(MAX),
    TAB1_A41 VARCHAR(MAX),
    TAB1_A5 VARCHAR(MAX),
    TAB1_A6 VARCHAR(MAX),
    TAB1_A7 VARCHAR(MAX),
    TAB1_A8 VARCHAR(MAX),
	TAB1_A011 VARCHAR(MAX),
    TAB1_A013 VARCHAR(MAX),
    _A2_9 NUMERIC(21,2)
  )

  IF EXISTS(SELECT * FROM dbo.t_Ret WHERE ChID = @ChID AND TaxDocID = 0)
  BEGIN
    RAISERROR('Невозможно экспортировать документ "Возврат товара" с Рег. номером %u без присвоенного номера налоговой!', 18, 1, @ChID)  
    RETURN
  END

  IF EXISTS(SELECT * FROM dbo.t_Ret WHERE ChID = @ChID AND (SrcTaxDocID = 0 OR SrcTaxDocDate IS NULL))
  BEGIN
    RAISERROR('Невозможно экспортировать документ "Возврат товара" с Рег. номером %u без заполнения поля "Номер нал. источника" / "Дата нал. источника".', 18, 1, @ChID)  
    RETURN
  END

  IF EXISTS(SELECT * FROM dbo.t_Ret WHERE ChID = @ChID AND TaxDocDate < '20150101')  
  BEGIN
    RAISERROR('Невозможно экспортировать документ "Возврат товара" с Рег. номером %u формата J1201209 до 01.01.2015!', 18, 1, @ChID)  
    RETURN
  END
 
  --rss0 заявка 676
  IF EXISTS(Select  r.Chid,r.Prodid,r.PPID, ps.ProdName, pin.CstProdCode
From t_RetD r join r_Prods ps on r.ProdID = ps.ProdID join t_PInP pin on ps.ProdID = pin.ProdID
Where r.Chid = @ChID and r.PPID=pin.PPID and (pin.CstProdCode is Null or pin.CstProdCode = '') and ps.PGrID2 not in (SELECT RefID FROM dbo.r_Uni WITH(NOLOCK) WHERE RefTypeID = 6660223))
BEGIN
Declare @er nVarchar(Max)
set @er = (Select '№ '+ Cast(r.Prodid as nVarchar (Max))+' с партией '+ Cast(pin.PPID as nVarchar (Max))+',' as 'data()'
From t_RetD r join r_Prods ps on r.ProdID = ps.ProdID join t_PInP pin on ps.ProdID = pin.ProdID
Where r.Chid = @ChID and r.PPID=pin.PPID and (pin.CstProdCode is Null or pin.CstProdCode = '') for xml path (''))
    RAISERROR('Внимание!!!! Для товара  %s не заполнено поле «Код УКТВЭД»', 18, 1, @er)  
    RETURN
  END
-------

  IF @DocCode IN (0, 11003)
  /* Расходная накладная */
  BEGIN
     
      declare @ProdID int ,@Qty numeric (21,9),@PriceCC_nt numeric (21,9), @SrcTaxDocID varchar(50),@SrcTaxDocDate smalldatetime,  @iter int, @Compid int, @PPID int, @ChIDInv int,@SrcPosID int, @QtyInv int, @PriceCC_ntInv numeric (21,9), @TaxInv numeric (21,9),@CodeID2 int, @CodeID1 int, @CodeID3 int, @Tax numeric (21,9), @MaxSrcPosID int, @iter1 int,  @iter2 int,
    @SrcDocID int, @SrcDocDate smalldatetime,@SrcPosIDret int,@QtyInv1Ret numeric (21,9),@QtyInv1 numeric (21,9)


 SET @Iter=0
 SET @Iter1=0
 SET @iter2 =0
     
   IF EXISTS (Select CodeID2 FROM t_Ret where ChID=@ChID and CodeID2 not in (43,38))
      BEGIN
  
    /* Подготовка данных: Детали */
    
 DECLARE Cur Cursor for
   select    rtm.ChID, CompID,CodeID1, CodeID2 ,CodeID3, ProdID, PPID, Qty, PriceCC_nt, SrcTaxDocID,SrcTaxDocDate,tax  from  dbo.t_Ret rtm JOIN t_RetD rtD on rtm.ChID=rtD.ChID  where rtm.ChID=@Chid  group by 
  rtm.ChID, CompID, CodeID1, CodeID2 ,CodeID3, ProdID, PPID, Qty, PriceCC_nt, SrcTaxDocID,SrcTaxDocDate, Tax

 
   Open Cur
FETCH NEXT FROM Cur INTO @ChID,@CompID, @CodeID1 ,@CodeID2,@CodeID3, @ProdID, @PPID, @Qty,@PriceCC_nt,@SrcTaxDocID,@SrcTaxDocDate,@Tax
WHILE @@FETCH_STATUS = 0
BEGIN
 
 SELECT @ChIDInv = ChID from elit.dbo.t_Inv  where CompID=@CompID and TaxDocID=@SrcTaxDocID and TaxDocDate = @SrcTaxDocDate

 SELECT @SrcPosID = SrcPosID from elit.dbo.t_InvD  where ChID=@ChIDInv and ProdID=@ProdID 
 
 SELECT @MaxSrcPosID = MAX(SrcPosID)+1+@iter1  from elit.dbo.t_InvD  where ChID=@ChIDInv 
 
 
  SELECT @QtyInv1 = Qty from elit.dbo.t_InvD  where ChID=@ChIDInv and ProdID=@ProdID 
  
  SELECT @QtyInv1Ret = ISNULL(SUM(Qty),0) from t_Ret a join t_RetD b on a.ChID=b.ChID where SrcTaxDocID=@SrcTaxDocID and ProdID=@ProdID  and SrcTaxDocDate=@SrcTaxDocDate  and b.ChID<>@chid
  
  SELECT @QtyInv =@QtyInv1-@QtyInv1Ret
  
  SELECT @PriceCC_ntInv = PriceCC_nt from elit.dbo.t_InvD  where ChID=@ChIDInv and ProdID=@ProdID
    
  SELECT @TaxInv = Tax from elit.dbo.t_InvD  where ChID=@ChIDInv and ProdID=@ProdID 
  
  
   INSERT @DetTbl 
SELECT CASE WHEN (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) <>0 THEN  @iter   ELSE  @iter2 END   [SID],
 Cast (@SrcPosID as varchar(max)) as [TAB1_A01],
 dbo.zf_DateToStr(@SrcTaxDocDate) [TAB1_A1],
  CASE WHEN @CodeID2 IN (19,69,56)  and  (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) <>0 THEN 'Зміна кількості'  WHEN @CodeID2 IN (19,69) and  (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) =0 THEN 'Повернення товару або авансових платежів'
        WHEN @CodeID2 IN (43,38) THEN 'Зміна ціни' 
        WHEN @CodeID2 IN (44,58,96) THEN 'Зміна кількості'
        ELSE ''
      END [TAB1_A2],
      (CASE WHEN  @CodeID1 = 63  and @CodeID2 IN (18,43, 44, 69,96) and @CodeID3 = 4   
		and @SrcTaxDocDate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799   THEN  rp.Article2
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), CASE WHEN @ProdID = 26137 and rtm.CompID = 7004 THEN 'Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 у коробці' ELSE rp.Notes END) END) AS [TAB1_A3], -- по заявке 7630 
		--ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes) END) AS [TAB1_A3], -- по заявке 7630 
      
	 Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'TAB1_A31',
	 Case When rp.ImpID = 1  THEN 1 end   AS 'TAB1_A32',
	 Case When rp.PGrID2 = 402 THEN pp.CstProdCode end AS 'TAB1_A33',

      rumq.RefName AS 'TAB1_A14',
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE - SUM(ISNULL(@QtyInv, 0))  END AS NUMERIC(21,6)) [TAB1_A5], 
      --CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty) END AS NUMERIC(21,6)) [TAB1_A5], 
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE @PriceCC_nt END AS NUMERIC(21,7)) [TAB1_A6],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN ISNULL(@PriceCC_ntInv, 0) -@PriceCC_nt ELSE NULL END AS NUMERIC(21,12)) [TAB1_A7],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN SUM(@Qty) ELSE NULL END AS NUMERIC(21,6)) [TAB1_A8],
	  20 as [TAB1_A011],
      CAST(-SUM(ISNULL(@QtyInv, 0)*ISNULL(@PriceCC_ntInv, 0))  AS NUMERIC(21,2)) [TAB1_A013],
      CAST(-SUM(ISNULL(@QtyInv, 0)*ISNULL(@TaxInv, 0)) AS NUMERIC(21,2)) [_A2_9]
       FROM t_Ret rtm
      JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = @ProdID
      JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = @ProdID AND pp.PPID = @PPID
      LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rtm.CompID AND ec.ProdID = rp.ProdID
      JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = rp.UM
       where rtm.ChID=@Chid
       group by  rp.Article2, rtm.CompID, ec.ExtProdName, rp.Notes, rp.PGrID2,pp.CstProdCode,rp.ImpID, rumq.RefName,rumq.RefID,rtm.CodeID2
       
  UNION
  
  
  SELECT CASE WHEN (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) <>0 THEN  @iter +1  ELSE  @iter2 END [SID],
 CASE WHEN @QtyInv1Ret<>  NULL THEN  Cast (@MaxSrcPosID  as varchar(max)) ELSE Cast (@MaxSrcPosID +1  as varchar(max)) END  as [TAB1_A01],
 dbo.zf_DateToStr(@SrcTaxDocDate) [TAB1_A1],
  CASE WHEN @CodeID2 IN (19,69,56) and (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) <>0  THEN 'Зміна кількості' WHEN @CodeID2 IN (19,69) and  (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty))=0 THEN 'Повернення товару або авансових платежів' 
        WHEN @CodeID2 IN (43,38) THEN 'Зміна ціни' 
        WHEN @CodeID2 IN (44,58,96) THEN 'Зміна кількості'
        ELSE ''
      END [TAB1_A2],
      (CASE WHEN  @CodeID1 = 63  and @CodeID2 IN (18,43, 44, 69,96) and @CodeID3 = 4   
		and @SrcTaxDocDate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799   THEN  rp.Article2
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes)END) AS [TAB1_A3], -- по заявке 7630 
      
	 Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'TAB1_A31',
	 Case When rp.ImpID = 1  THEN 1 end   AS 'TAB1_A32',
	 Case When rp.PGrID2 = 402 THEN pp.CstProdCode end AS 'TAB1_A33',

      rumq.RefName AS 'TAB1_A14',
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
      --CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE - SUM(ISNULL(@QtyInv, 0))  END AS NUMERIC(21,6)) [TAB1_A5], 
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty) END AS NUMERIC(21,6)) [TAB1_A5], 
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE @PriceCC_nt END AS NUMERIC(21,7)) [TAB1_A6],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN ISNULL(@PriceCC_ntInv, 0) -@PriceCC_nt ELSE NULL END AS NUMERIC(21,12)) [TAB1_A7],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN SUM(@Qty) ELSE NULL END AS NUMERIC(21,6)) [TAB1_A8],
	  20 as [TAB1_A011],
      CAST((SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) * @PriceCC_nt AS NUMERIC(21,2)) [TAB1_A013],
      CAST((SUM(ISNULL(@QtyInv, 0)*ISNULL(@TaxInv, 0)) - ( @Qty *@Tax ) ) AS NUMERIC(21,2)) [_A2_9]
       FROM t_Ret rtm
      JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = @ProdID
      JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = @ProdID AND pp.PPID = @PPID
      LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rtm.CompID AND ec.ProdID = rp.ProdID
      JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = rp.UM
       where rtm.ChID=@Chid  
       group by  rp.Article2, rtm.CompID, ec.ExtProdName, rp.Notes, rp.PGrID2,pp.CstProdCode,rp.ImpID, rumq.RefName,rumq.RefID,rtm.CodeID2
       HAVING (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) <>0

 -- select @iter2

 set  @MaxSrcPosID=@MaxSrcPosID+1
set @iter1=@iter1+1

set  @iter=@iter+2  
set @iter2=@iter2+1  

 -- select @iter2

FETCH NEXT FROM Cur INTO @ChID,@CompID, @CodeID1 ,@CodeID2,@CodeID3, @ProdID, @PPID, @Qty,@PriceCC_nt,@SrcTaxDocID,@SrcTaxDocDate,@Tax
END

CLOSE Cur
DEALLOCATE Cur
    END

----------------
     IF EXISTS (SELECT * FROM t_Ret WHERE ChID=@ChID AND CodeID2 in (43,38))
       BEGIN
     
     DECLARE Cur38 Cursor for
   select    rtm.ChID, CompID,CodeID1, CodeID2 ,CodeID3, ProdID, PPID, Qty, PriceCC_nt, SrcTaxDocID,SrcTaxDocDate,tax,SrcDocID,SrcDocDate,SrcPosID  from  dbo.t_Ret rtm JOIN t_RetD rtD on rtm.ChID=rtD.ChID  where rtm.ChID=@Chid  group by 
  rtm.ChID, CompID, CodeID1, CodeID2 ,CodeID3, ProdID, PPID, Qty, PriceCC_nt, SrcTaxDocID,SrcTaxDocDate, Tax,SrcDocID,SrcDocDate,SrcPosID

 
   Open Cur38
FETCH NEXT FROM Cur38 INTO @ChID,@CompID, @CodeID1 ,@CodeID2,@CodeID3, @ProdID, @PPID, @Qty,@PriceCC_nt,@SrcTaxDocID,@SrcTaxDocDate,@Tax,@SrcDocID,@SrcDocDate,@SrcPosIDret
WHILE @@FETCH_STATUS = 0
BEGIN
 
SELECT @ChIDInv = ChID from elit.dbo.t_Inv  where CompID=@CompID and SrcTaxDocID=@SrcTaxDocID and SrcTaxDocDate = @SrcTaxDocDate

 SELECT @SrcPosID = SrcPosID from elit.dbo.t_InvD  where ChID=@ChIDInv and ProdID=@ProdID and PPID=@PPID and Qty=@qty and SrcPosID=@SrcPosIDret
 
 SELECT @MaxSrcPosID = MAX(SrcPosID)+1+@iter1  from elit.dbo.t_InvD  where ChID=@ChIDInv 
 
 
  SELECT @QtyInv = Qty from elit.dbo.t_InvD  where ChID=@ChIDInv and ProdID=@ProdID and PPID=@PPID and Qty=@qty
  
  SELECT @PriceCC_ntInv = PriceCC_nt from elit.dbo.t_InvD  where ChID=@ChIDInv and ProdID=@ProdID and PPID=@PPID and Qty=@qty and SrcPosID=@SrcPosIDret
  
  SELECT @TaxInv = Tax from elit.dbo.t_InvD  where ChID=@ChIDInv and ProdID=@ProdID and PPID=@PPID and Qty=@qty and SrcPosID=@SrcPosIDret
  
  INSERT @DetTbl  
SELECT  @iter   [SID],
 Cast (@SrcPosID as varchar(max)) as [TAB1_A01],
 dbo.zf_DateToStr(@SrcTaxDocDate) [TAB1_A1],
  CASE WHEN @CodeID2 IN (19,69,56)  and  (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) <>0 THEN 'Зміна кількості'  WHEN @CodeID2 IN (19,69) and  (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) =0 THEN 'Повернення товару або авансових платежів'
        WHEN @CodeID2 IN (43,38) THEN 'Зміна ціни' 
        WHEN @CodeID2 IN (44,58,96) THEN 'Зміна кількості'
        ELSE ''
      END [TAB1_A2],
      (CASE WHEN  @CodeID1 = 63  and @CodeID2 IN (18,43, 44, 69,96) and @CodeID3 = 4   
		and @SrcTaxDocDate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799   THEN  rp.Article2
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), CASE WHEN @ProdID = 26137 and rtm.CompID = 7004 THEN 'Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 у коробці' ELSE rp.Notes END) END) AS [TAB1_A3], -- по заявке 7630 		
		--ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes)END) AS [TAB1_A3], -- по заявке 7630 
      
	 Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'TAB1_A31',
	 Case When rp.ImpID = 1  THEN 1 end   AS 'TAB1_A32',
	 Case When rp.PGrID2 = 402 THEN pp.CstProdCode end AS 'TAB1_A33',

      rumq.RefName AS 'TAB1_A14',
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN NULL ELSE - SUM(ISNULL(@QtyInv, 0))  END AS NUMERIC(21,6)) [TAB1_A5], 
      --CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty) END AS NUMERIC(21,6)) [TAB1_A5], 
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN NULL ELSE @PriceCC_nt END AS NUMERIC(21,7)) [TAB1_A6],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN ISNULL(-@PriceCC_nt, 0) ELSE NULL END AS NUMERIC(21,12)) [TAB1_A7],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN SUM(@Qty) ELSE NULL END AS NUMERIC(21,6)) [TAB1_A8],
	  20 as [TAB1_A011],
      CAST(-SUM(ISNULL(@Qty, 0)*ISNULL(@PriceCC_nt, 0))  AS NUMERIC(21,2)) [TAB1_A013],
      CAST(-SUM(ISNULL(@Qty, 0)*ISNULL(@Tax, 0)) AS NUMERIC(21,2)) [_A2_9]
       FROM t_Ret rtm
      JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = @ProdID
      JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = @ProdID AND pp.PPID = @PPID
      LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rtm.CompID AND ec.ProdID = rp.ProdID
      JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = rp.UM
       where rtm.ChID=@Chid
       group by  rp.Article2, rtm.CompID, ec.ExtProdName, rp.Notes, rp.PGrID2,pp.CstProdCode,rp.ImpID, rumq.RefName,rumq.RefID,rtm.CodeID2
       
  UNION
  
  
  SELECT   @iter +1    [SID],
 Cast (@MaxSrcPosID  as varchar(max)) as [TAB1_A01],
 dbo.zf_DateToStr(@SrcTaxDocDate) [TAB1_A1],
  CASE WHEN @CodeID2 IN (19,69,56) and (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) <>0  THEN 'Зміна кількості' WHEN @CodeID2 IN (19,69) and  (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty))=0 THEN 'Повернення товару або авансових платежів' 
        WHEN @CodeID2 IN (43,38) THEN 'Зміна ціни' 
        WHEN @CodeID2 IN (44,58,96) THEN 'Зміна кількості'
        ELSE ''
      END [TAB1_A2],
      (CASE WHEN  @CodeID1 = 63  and @CodeID2 IN (18,43, 44, 69,96) and @CodeID3 = 4   
		and @SrcTaxDocDate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799   THEN  rp.Article2
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes)END) AS [TAB1_A3], -- по заявке 7630 
      
	 Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'TAB1_A31',
	 Case When rp.ImpID = 1  THEN 1 end   AS 'TAB1_A32',
	 Case When rp.PGrID2 = 402 THEN pp.CstProdCode end AS 'TAB1_A33',

      rumq.RefName AS 'TAB1_A14',
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
      --CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN 0 ELSE - SUM(ISNULL(@QtyInv, 0))  END AS NUMERIC(21,6)) [TAB1_A5], 
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN NULL ELSE SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty) END AS NUMERIC(21,6)) [TAB1_A5], 
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN NULL ELSE @PriceCC_nt END AS NUMERIC(21,7)) [TAB1_A6],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN  @PriceCC_ntInv ELSE NULL END AS NUMERIC(21,4)) [TAB1_A7],
      CAST(CASE WHEN rtm.CodeID2 IN (43,38) THEN SUM(@Qty) ELSE NULL END AS NUMERIC(21,6)) [TAB1_A8],
	  20 as [TAB1_A011],
      CAST((SUM(ISNULL(@QtyInv, 0)) * @PriceCC_ntInv) AS NUMERIC(21,2)) [TAB1_A013],
      CAST((SUM(ISNULL(@QtyInv, 0)*ISNULL(@TaxInv, 0))  ) AS NUMERIC(21,2)) [_A2_9]
       FROM t_Ret rtm
      JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = @ProdID
      JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = @ProdID AND pp.PPID = @PPID
      LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rtm.CompID AND ec.ProdID = rp.ProdID
      JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = rp.UM
       where rtm.ChID=@Chid  
       group by  rp.Article2, rtm.CompID, ec.ExtProdName, rp.Notes, rp.PGrID2,pp.CstProdCode,rp.ImpID, rumq.RefName,rumq.RefID,rtm.CodeID2
     

 set  @MaxSrcPosID=@MaxSrcPosID+1
set @iter1=@iter1+1

set  @iter=@iter+2  
set @iter2=@iter2+1  

 -- select @iter2

FETCH NEXT FROM Cur38 INTO  @ChID,@CompID, @CodeID1 ,@CodeID2,@CodeID3, @ProdID, @PPID, @Qty,@PriceCC_nt,@SrcTaxDocID,@SrcTaxDocDate,@Tax,@SrcDocID,@SrcDocDate,@SrcPosIDret
END

CLOSE Cur38
DEALLOCATE Cur38
     
     
     
       END
   -----------------------------------------------------------------------
   

    /* Подготовка данных: Шапка */
    INSERT @HeadTbl
    SELECT
      dbo.af_GetFiltered(rc.Code) [EDR_POK],
      ro.[Address] + ', ' + ro.City + ', ' + ro.PostIndex [FIRM_ADR],
      dbo.af_GetFiltered(ro.Code) [FIRM_EDRPOU],
      dbo.af_GetFiltered(ro.TaxCode) [FIRM_INN],
      ro.Note2 [FIRM_NAME],
      m.TaxDocID [N1],
      CASE rc.TaxPayer WHEN 0 THEN '1' ELSE '' END [N13],
      CASE WHEN rc.TaxPayer = 0 AND rc.IsDutyFree = 0 THEN '02' WHEN rc.TaxPayer = 0 AND rc.IsDutyFree = 1 THEN '07' ELSE '' END [N14],
      LEFT(re.UAEmpFirstName, 1) + '.' + LEFT(re.UAEmpParName, 1) + '. ' + re.UAEmpLastName [N10],
	  re.TaxCode as [INN],
      dbo.zf_DateToStr(m.TaxDocDate) [N12],
      dbo.zf_DateToStr(m.TaxDocDate) [N15],
      CASE WHEN rc.TaxPayer = 1 /*AND m.SrcTaxDocDate >'20150101'*/ AND (SELECT SUM(_A2_9) FROM @DetTbl) < 0 THEN 1 END [N16],
      m.TaxDocID [N1_11],
      m.TaxDocID [N1I],
      dbo.zf_DateToStr(m.SrcTaxDocDate) [N2],
      LEFT(m.SrcTaxDocID,7) [N2_1],
      LEFT(m.SrcTaxDocID,7) [N2_11],
      dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'BDate') [N2_2],
      REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrID3'),'-','@'),'/','#')),'@','-'),'#','/') [N2_3],
      rc.TaxCompName [N3],
      dbo.af_GetFiltered(rc.TaxCode) [N4],

	  CASE WHEN co.CompClassID = 3 THEN co.Job1 END  as [Dept_Pok],

      rc.TaxAddress [N5],
      dbo.af_GetFiltered(rc.TaxPhone) [N6],
      dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrType') [N8],
      REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrID3'),'-','@'),'/','#')),'@','-'),'#','/') [N81],
      dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'BDate') [N82],
      'Оплата з поточного рахунка' [N9],
      dbo.af_GetFiltered(ro.Phone) [PHON],
      CAST((SELECT SUM(CAST(TAB1_A013 AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS [A1_9], 
      CAST((SELECT SUM(_A2_9) FROM @DetTbl) AS NUMERIC(21,2)) AS [A2_9],
	  CAST((SELECT SUM(_A2_9) FROM @DetTbl) AS NUMERIC(21,2)) AS [A2_92],
	  Case When rc.TaxCompName='Неплатник' THEN 1 END as [N26]
   FROM dbo.t_Ret m WITH(NOLOCK)
    JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
    OUTER APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) rc
    JOIN dbo.at_r_OurMEDoc om WITH(NOLOCK) ON om.OurID = m.OurID AND m.TaxDocDate BETWEEN om.BDate AND om.EDate
    JOIN dbo.r_Emps re WITH(NOLOCK) ON re.EmpID = om.EmpID
    JOIN dbo.z_DocLinks z WITH(NOLOCK) ON z.ChildDocCode = 11003 AND z.ParentDocCode = 666028 AND z.ChildChID = m.ChID
	JOIN dbo.r_Comps co WITH(NOLOCK) ON m.CompID=co.CompID
    WHERE m.ChID = @ChID
  END
  
  
  ELSE IF @DocCode = 666027
  BEGIN
  
   DECLARE  @SrcTaxDocID1 int, @CompID1 int, @CHID2 int, @Qty1 numeric (21,9), @qty2 numeric (21,9)
  
    IF EXISTS(SELECT CodeID2 FROM dbo.at_t_Prepay WHERE CodeID2 <>98 and ChID=@ChID)
       BEGIN
  
  /* Накладная на предоплату */
  
    /* Подготовка данных: Детали */
    INSERT @DetTbl
    SELECT
      ROW_NUMBER() OVER(ORDER BY MAX(rp.ProdID)) - 1 [SID],
	  1 as [TAB1_A01],
      dbo.zf_DateToStr(rtm.TaxDocDate) [TAB1_A1], 
      'Повернення товару або авансових платежів' [TAB1_A2],
	   (CASE WHEN  rtm.CodeID1 = 63  and rtm.CodeID2 IN (18,43, 44, 69,96) and rtm.CodeID3 = 4   
		and rtm.taxdocdate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799 and r.CodeID4 != 5002  THEN  rp.Article2
		WHEN @ProdID = 26137 and rtm.CompID = 7004 THEN 'Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 у коробці'
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes) END) AS 'TAB1_A3', -- по заявке 7630 
      /*LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes))) [TAB1_A3],*/

     Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'TAB1_A31',
	 Case When rp.ImpID = 1  THEN 1 end   AS 'TAB1_A32',
	 Case When rp.PGrID2 = 402 THEN pp.CstProdCode end AS 'TAB1_A33',

      rumq.RefName AS 'TAB1_A14',
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
      CAST(SUM(rtd.Qty) AS NUMERIC(21,6)) [TAB1_A5], 
      CAST(rtd.PriceCC_nt AS NUMERIC(21,12)) [TAB1_A6],
      NULL [TAB1_A7],
      NULL [TAB1_A8],
	  20 as [TAB1_A011],
      CAST(SUM(rtd.Qty*rtd.PriceCC_nt) AS NUMERIC(21,2)) [TAB1_A013],
      CAST(SUM(rtd.Qty*rtd.Tax) AS NUMERIC(21,2)) [_A2_9]
    FROM dbo.at_t_Prepay rtm
    JOIN (SELECT ChID, ProdID, PPID, PriceCC_nt, Tax, SUM(Qty) Qty FROM dbo.at_t_PrepayD WITH(NOLOCK) GROUP BY ChID, ProdID, PPID, PriceCC_nt, Tax) rtd ON rtd.ChID = rtm.ChID
    JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = rtd.ProdID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = rtd.ProdID AND pp.PPID = rtd.PPID
    LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rtm.CompID AND ec.ProdID = rp.ProdID
    JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = rp.UM
	Join r_Comps r WITH(NOLOCK) on rtm.CompID = r.CompID
    WHERE rtm.ChID = @ChID
    GROUP BY rtm.TaxDocDate, LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes))), pp.CstProdCode, 
      rumq.RefName, rumq.RefID, rtd.PriceCC_nt, pp.CstDocCode, pp.CstDocDate, 
      	   (CASE WHEN  rtm.CodeID1 = 63  and rtm.CodeID2 IN (18,43, 44, 69,96) and rtm.CodeID3 = 4   
		and rtm.taxdocdate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799 and r.CodeID4 != 5002  THEN  rp.Article2
		WHEN @ProdID = 26137 and rtm.CompID = 7004 THEN 'Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 у коробці'
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes) END),
		Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end, 
		Case When rp.ImpID = 1  THEN 1 end,
		Case When rp.PGrID2 = 402 THEN pp.CstProdCode end
       END
    
    IF EXISTS(SELECT CodeID2 FROM dbo.at_t_Prepay WHERE CodeID2 =98 and ChID=@ChID)
       BEGIN
    
   
 
 DECLARE  Prepay  CURSOR FOR
  SELECT CHID,SrcTaxDocID,CompID from at_t_Prepay where ChID=@CHID
  

  
  Open Prepay
FETCH NEXT FROM Prepay INTO @CHID,@SrcTaxDocID1,@CompID1
WHILE @@FETCH_STATUS = 0
BEGIN

  SELECT @CHID2=CHID FROM at_t_Prepay where TaxDocID=@SrcTaxDocID1 and CompID=@CompID1
  SELECT @Qty1=Qty FROM at_t_PrepayD WHERE ChID=@CHID
  SELECT @Qty2=Qty FROM at_t_PrepayD WHERE ChID=@CHID2


 INSERT @DetTbl
SELECT
      ROW_NUMBER() OVER(ORDER BY MAX(rp.ProdID)) - 1 [SID],
	  1 as [TAB1_A01],
      dbo.zf_DateToStr(rtm.TaxDocDate) [TAB1_A1], 
      'Зміна кількості' [TAB1_A2],
	   (CASE WHEN  rtm.CodeID1 = 63  and rtm.CodeID2 IN (18,43, 44, 69,96) and rtm.CodeID3 = 4   
		and rtm.taxdocdate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799 and r.CodeID4 != 5002  THEN  rp.Article2
		WHEN @ProdID = 26137 and rtm.CompID = 7004 THEN 'Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 у коробці'
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes) END) AS [TAB1_A3], -- по заявке 7630 
      /*LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes))) [TAB1_A3],*/

     Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'TAB1_A31',
	 Case When rp.ImpID = 1  THEN 1 end   AS 'TAB1_A32',
	 Case When rp.PGrID2 = 402 THEN pp.CstProdCode end AS 'TAB1_A33',

      rumq.RefName AS 'TAB1_A14',
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
      CAST( -SUM(rtd.Qty) AS NUMERIC(21,6)) [TAB1_A5], 
      CAST(rtd.PriceCC_nt AS NUMERIC(21,12)) [TAB1_A6],
      NULL [TAB1_A7],
      NULL [TAB1_A8],
	  20 as [TAB1_A011],
      CAST(-SUM(rtd.Qty*rtd.PriceCC_nt) AS NUMERIC(21,2)) [TAB1_A013],
      CAST(-SUM(rtd.Qty*rtd.Tax) AS NUMERIC(21,2)) [_A2_9]
    FROM dbo.at_t_Prepay rtm
    JOIN (SELECT ChID, ProdID, PPID, PriceCC_nt, Tax, SUM(Qty) Qty FROM dbo.at_t_PrepayD WITH(NOLOCK) GROUP BY ChID, ProdID, PPID, PriceCC_nt, Tax) rtd ON rtd.ChID = rtm.ChID
    JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = rtd.ProdID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = rtd.ProdID AND pp.PPID = rtd.PPID
    LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rtm.CompID AND ec.ProdID = rp.ProdID
    JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = rp.UM
	Join r_Comps r WITH(NOLOCK) on rtm.CompID = r.CompID
    WHERE rtm.ChID = @CHID2
    GROUP BY rtm.TaxDocDate, LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes))), pp.CstProdCode, 
      rumq.RefName, rumq.RefID, rtd.PriceCC_nt, pp.CstDocCode, pp.CstDocDate,
       	(CASE WHEN  rtm.CodeID1 = 63  and rtm.CodeID2 IN (18,43, 44, 69,96) and rtm.CodeID3 = 4   
		and rtm.taxdocdate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799 and r.CodeID4 != 5002  THEN  rp.Article2
		WHEN @ProdID = 26137 and rtm.CompID = 7004 THEN 'Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 у коробці'
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes) END),
		Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end, 
		Case When rp.ImpID = 1  THEN 1 end,
		Case When rp.PGrID2 = 402 THEN pp.CstProdCode end
		
		
		UNION ALL
		
		
		SELECT
      ROW_NUMBER() OVER(ORDER BY MAX(rp.ProdID))  [SID],
	  2 as [TAB1_A01],
      dbo.zf_DateToStr(rtm.TaxDocDate) [TAB1_A1], 
      'Зміна кількості' [TAB1_A2],
	   	   (CASE WHEN  rtm.CodeID1 = 63  and rtm.CodeID2 IN (18,43, 44, 69,96) and rtm.CodeID3 = 4   
		and rtm.taxdocdate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799 and r.CodeID4 != 5002  THEN  rp.Article2
		WHEN @ProdID = 26137 and rtm.CompID = 7004 THEN 'Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 у коробці'
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes) END) AS [TAB1_A3], -- по заявке 7630 
      /*LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes))) [TAB1_A3],*/

     Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'TAB1_A31',
	 Case When rp.ImpID = 1  THEN 1 end   AS 'TAB1_A32',
	 Case When rp.PGrID2 = 402 THEN pp.CstProdCode end AS 'TAB1_A33',

      rumq.RefName AS 'TAB1_A14',
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
      CAST(SUM(@Qty1)+SUM(@qty2) AS NUMERIC(21,6)) [TAB1_A5], 
      CAST(rtd.PriceCC_nt AS NUMERIC(21,12)) [TAB1_A6],
      NULL [TAB1_A7],
      NULL [TAB1_A8],
	  20 as [TAB1_A011],
      CAST((SUM(@Qty1+@qty2)*rtd.PriceCC_nt) AS NUMERIC(21,2)) [TAB1_A013],
      CAST((SUM(@Qty1+@qty2)*rtd.Tax) AS NUMERIC(21,2)) [_A2_9]
    FROM dbo.at_t_Prepay rtm
    JOIN (SELECT ChID, ProdID, PPID, PriceCC_nt, Tax, SUM(Qty) Qty FROM dbo.at_t_PrepayD WITH(NOLOCK) GROUP BY ChID, ProdID, PPID, PriceCC_nt, Tax) rtd ON rtd.ChID = rtm.ChID
    JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = rtd.ProdID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = rtd.ProdID AND pp.PPID = rtd.PPID
    LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rtm.CompID AND ec.ProdID = rp.ProdID
    JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = rp.UM
	Join r_Comps r WITH(NOLOCK) on rtm.CompID = r.CompID
    WHERE rtm.ChID = @ChID
    GROUP BY rtm.TaxDocDate, LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes))), pp.CstProdCode, 
      rumq.RefName, rumq.RefID, rtd.PriceCC_nt, pp.CstDocCode, pp.CstDocDate,	   
      (CASE WHEN  rtm.CodeID1 = 63  and rtm.CodeID2 IN (18,43, 44, 69,96) and rtm.CodeID3 = 4   
		and rtm.taxdocdate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799 and r.CodeID4 != 5002  THEN  rp.Article2
		WHEN @ProdID = 26137 and rtm.CompID = 7004 THEN 'Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 у коробці'
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes) END),
		Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end, 
		Case When rp.ImpID = 1  THEN 1 end,
		Case When rp.PGrID2 = 402 THEN pp.CstProdCode end,rtd.Tax
		
		
		
		FETCH NEXT FROM Prepay INTO @CHID,@SrcTaxDocID1,@CompID1
END

CLOSE Prepay
DEALLOCATE Prepay
    
       END
    /* Подготовка данных: Шапка */
    INSERT @HeadTbl
    SELECT
      dbo.af_GetFiltered(rc.Code) [EDR_POK],
      ro.[Address] + ', ' + ro.City + ', ' + ro.PostIndex [FIRM_ADR],
      dbo.af_GetFiltered(ro.Code) [FIRM_EDRPOU],
      dbo.af_GetFiltered(ro.TaxCode) [FIRM_INN],
      ro.Note2 [FIRM_NAME],
      m.TaxDocID [N1],
      CASE rc.TaxPayer WHEN 0 THEN '1' ELSE '' END [N17],
      CASE WHEN rc.TaxPayer = 0 AND rc.IsDutyFree = 0 THEN '02' WHEN rc.TaxPayer = 0 AND rc.IsDutyFree = 1 THEN '07' ELSE '' END [N18],
      LEFT(re.UAEmpFirstName, 1) + '.' + LEFT(re.UAEmpParName, 1) + '. ' + re.UAEmpLastName [N10],
	  re.TaxCode as [INN],
      dbo.zf_DateToStr(m.TaxDocDate) [N12],
      dbo.zf_DateToStr(m.TaxDocDate) [N15],
      CASE WHEN rc.TaxPayer = 1 /*AND m.SrcTaxDocDate >'20150101'*/  AND (SELECT SUM(_A2_9) FROM @DetTbl) < 0 THEN 1 END [N16],
      m.TaxDocID [N1_11],
      m.TaxDocID [N1I],
      dbo.zf_DateToStr(m.SrcTaxDocDate) [N2],
      LEFT(m.SrcTaxDocID,7) [N2_1],
      LEFT(m.SrcTaxDocID,7) [N2_11],
      dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'BDate') [N2_2],
      REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrID3'),'-','@'),'/','#')),'@','-'),'#','/') [N2_3],
      rc.TaxCompName [N3],
      dbo.af_GetFiltered(rc.TaxCode) [N4],

	  CASE WHEN co.CompClassID = 3 THEN co.Job1 END  as [Dept_Pok],

      rc.TaxAddress [N5],
      dbo.af_GetFiltered(rc.TaxPhone) [N6],
      dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrType') [N8],
      REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrID3'),'-','@'),'/','#')),'@','-'),'#','/') [N81],
      dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'BDate') [N82],
      'Оплата з поточного рахунка' [N9],
      dbo.af_GetFiltered(ro.Phone) [PHON],
      CAST((SELECT SUM(CAST(TAB1_A013 AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS [A1_9], 
      CAST((SELECT SUM(_A2_9) FROM @DetTbl) AS NUMERIC(21,2)) AS [A2_9],
	  CAST((SELECT SUM(_A2_9) FROM @DetTbl) AS NUMERIC(21,2)) AS [A2_92],
	  Case When rc.TaxCompName='Неплатник' THEN 1 END as [N26]
    FROM dbo.at_t_Prepay m WITH(NOLOCK)
    JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
    OUTER APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) rc
    JOIN dbo.at_r_OurMEDoc om WITH(NOLOCK) ON om.OurID = m.OurID AND m.TaxDocDate BETWEEN om.BDate AND om.EDate
    JOIN dbo.r_Emps re WITH(NOLOCK) ON re.EmpID = om.EmpID
    JOIN dbo.z_DocLinks z WITH(NOLOCK) ON z.ChildDocCode = 666027 AND z.ParentDocCode = 666028 AND z.ChildChID = m.ChID
	JOIN dbo.r_Comps co WITH(NOLOCK) ON m.CompID=co.CompID
    WHERE m.ChID = @ChID
  END


  IF NOT EXISTS(SELECT * FROM @HeadTbl) OR (NOT EXISTS(SELECT * FROM @DetTbl) AND EXISTS(SELECT * FROM dbo.t_RetD WITH(NOLOCK) WHERE CHID = @ChID AND Qty > 0))
  BEGIN
    DECLARE @DocName VARCHAR(250) = CASE @DocCode WHEN 666027 THEN 'Накладная на предоплату' ELSE 'Возврат товара' END
    RAISERROR('Отстутствуют данные документа "%s" с Рег. номером = %u для экспорта документа "Корректировочная накладная"! Проверьте заполнение основных справочников.', 18, 1, @DocName ,@ChID)  
    RETURN
  END

  DECLARE @STR VARCHAR(MAX) = (SELECT [OUT] =
  CAST((
  SELECT (SELECT 0 AS 'PERTYPE', 
      '01' + RIGHT([N15],8) AS 'PERDATE',
      'J1201209' AS 'CHARCODE',
      [N1_11] + '.' + CAST(@ChID AS VARCHAR(10)) 'DOCID'
      FROM @HeadTbl
    FOR XML PATH ('FIELDS'), TYPE
      ),
      (SELECT 
        (SELECT 0 '@TAB', 0 '@LINE', PName '@NAME', PVal 'VALUE'
        FROM @HeadTbl p
        UNPIVOT
          (PVal FOR PName IN
            (INN,EDR_POK,FIRM_ADR,FIRM_EDRPOU,FIRM_INN,FIRM_NAME,N1,N17,N18,N10,N12,N15,N16,N1_11,N1I,N2,N2_1,N2_11,N2_2,N2_3,N3,N4,Dept_Pok,N5,N6,N8,N81,N82,N9,PHON,A1_9,A2_9,A2_92,N26)
         ) AS unpvt
          FOR XML PATH ('ROW'), TYPE
        ),
        (SELECT 1 '@TAB', [SID] '@LINE', PName '@NAME', PVal 'VALUE'
        FROM @DetTbl p
        UNPIVOT
          (PVal FOR PName IN
            (TAB1_A011,TAB1_A01,TAB1_A1,TAB1_A2,TAB1_A3,TAB1_A31,TAB1_A32,TAB1_A33,TAB1_A4,TAB1_A41,TAB1_A5,TAB1_A6,TAB1_A7,TAB1_A8,TAB1_A013)
       ) AS unpvt
          FOR XML PATH ('ROW'), TYPE
      ) FOR XML PATH('DOCUMENT'), TYPE)
  FOR XML PATH ('CARD')
  ) AS VARCHAR(MAX)))
  
  DECLARE @TmpStr VARCHAR(MAX) = ''
  DECLARE @TStr TABLE(ID INT IDENTITY(1,1), OUT1 VARCHAR(MAX))
  DECLARE @ICHID INT
  DECLARE @IState INT
            
  /* Если корректируется документ старого периода, экспортируем и его */
  --IF EXISTS(SELECT * FROM dbo.t_Ret WHERE SrcTaxDocDate <'20120101' AND ChID = @ChID) AND @DocCode = 0
  IF @DocCode IN (0, 11003)
  BEGIN
    SELECT @ICHID = MIN(m.ChID)
    FROM dbo.t_Ret i WITH(NOLOCK)
    JOIN dbo.t_Inv m WITH(NOLOCK) ON m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate AND m.OurID = i.OurID
      AND m.CompID = i.CompID
    WHERE i.ChID = @ChID AND m.TaxDocDate >= '20120101'

    IF @ICHID IS NULL    
      SELECT @ICHID = MIN(m.ChID)
      FROM dbo.t_Ret i
      JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = i.CompID
      JOIN dbo.r_Comps rc0 WITH(NOLOCK) ON rc0.Code=rc.Code AND rc0.Code!='0'
      JOIN dbo.t_Inv m WITH(NOLOCK) ON m.OurID = i.OurID AND m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate
      AND m.CompID = rc0.CompID
      WHERE i.ChID = @ChID AND m.TaxDocDate >= '20120101'
      
/* pvm0 2018-07-11 отключил обращение в таблицу "s-sql-back".NewData2009.dbo.t_Inv 

    IF @ICHID IS NULL
      SELECT @ICHID = MIN(m.ChID)
      FROM dbo.t_Ret i WITH(NOLOCK)
      JOIN "s-sql-back".NewData2009.dbo.t_Inv m WITH(NOLOCK) ON m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate AND m.OurID = i.OurID
       AND m.CompID = i.CompID
      WHERE i.ChID = @ChID AND m.TaxDocDate BETWEEN '20090101' AND '20101231'

    IF @ICHID IS NULL    
      SELECT @ICHID = MIN(m.ChID)
      FROM dbo.t_Ret i
      JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = i.CompID
      JOIN dbo.r_Comps rc0 WITH(NOLOCK) ON rc0.Code=rc.Code AND rc0.Code!='0'
      JOIN "s-sql-back".NewData2009.dbo.t_Inv m WITH(NOLOCK) ON m.OurID = i.OurID AND m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate
      AND m.CompID = rc0.CompID
      WHERE i.ChID = @ChID AND m.TaxDocDate BETWEEN '20090101' AND '20101231'

      
    IF @ICHID IS NULL
      SELECT @ICHID = MIN(m.ChID)
      FROM dbo.t_Ret i WITH(NOLOCK)
      JOIN "s-sql-back".Elit2011.dbo.t_Inv m WITH(NOLOCK) ON m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate AND m.OurID = i.OurID
      AND m.CompID = i.CompID
      WHERE i.ChID = @ChID AND m.TaxDocDate BETWEEN '20110101' AND '20111231'
      
    IF @ICHID IS NULL    
      SELECT @ICHID = MIN(m.ChID)
      FROM dbo.t_Ret i
      JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = i.CompID
      JOIN dbo.r_Comps rc0 WITH(NOLOCK) ON rc0.Code=rc.Code AND rc0.Code!='0'
      JOIN "s-sql-back".Elit2011.dbo.t_Inv m WITH(NOLOCK) ON m.OurID = i.OurID AND m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate
      AND m.CompID = rc0.CompID
      WHERE i.ChID = @ChID AND m.TaxDocDate BETWEEN '20110101' AND '20111231'      
*/  
	  IF @ICHID IS NULL
      SELECT @ICHID = MIN(m.ChID)
      FROM dbo.t_Ret i WITH(NOLOCK)
      JOIN "s-sql-back".Elit2014.dbo.t_Inv m WITH(NOLOCK) ON m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate AND m.OurID = i.OurID
      AND m.CompID = i.CompID
      WHERE i.ChID = @ChID AND m.TaxDocDate BETWEEN '20120101' AND '20141231'
      
    IF @ICHID IS NULL    
      SELECT @ICHID = MIN(m.ChID)
      FROM dbo.t_Ret i
      JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = i.CompID
      JOIN dbo.r_Comps rc0 WITH(NOLOCK) ON rc0.Code=rc.Code AND rc0.Code!='0'
      JOIN "s-sql-back".Elit2014.dbo.t_Inv m WITH(NOLOCK) ON m.OurID = i.OurID AND m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate
      AND m.CompID = rc0.CompID
      WHERE i.ChID = @ChID AND m.TaxDocDate BETWEEN '20120101' AND '20141231'

    IF @ICHID IS NULL
    BEGIN
      RAISERROR('Невозможно экспортировать документ %u, нет документа - РН с указнным номером источника для возврата!', 18, 1, @ChID)  
      RETURN
    END
    
    IF EXISTS(SELECT *
              FROM dbo.t_Ret m WITH(NOLOCK)
              WHERE ChID = @ChID
                AND (SrcTaxDocDate <'20120101' OR EXISTS(SELECT * FROM [dbo].[af_GetCompReqs](m.CompID, m.SrcTaxDocDate) rc WHERE TaxPayer = 0))
                AND NOT EXISTS(SELECT * FROM dbo.t_Ret i WITH(NOLOCK) WHERE i.SrcTaxDocID = m.SrcTaxDocID AND i.SrcTaxDocDate = m.SrcTaxDocDate AND i.OurID = m.OurID AND i.StateCode = 192))
      INSERT @TStr (OUT1)
      EXEC [dbo].[ap_Export_J1201007] @ICHID, 11012
  END 
  ELSE IF @DocCode = 666027
  BEGIN
	  IF NOT EXISTS(SELECT * FROM dbo.at_t_Prepay a JOIN dbo.b_TExp bte ON bte.OurID = a.OurID AND bte.IntDocID = a.SrcTaxDocID AND bte.DocDate = a.SrcTaxDocDate WHERE bte.ChID = @ChID AND bte.StateCode IN (192))
		BEGIN
			SELECT @ICHID = MIN(b.ChID)
			FROM dbo.at_t_Prepay a WITH(NOLOCK)
			JOIN dbo.at_t_Prepay b WITH(NOLOCK) ON b.TaxDocID = a.SrcTaxDocID AND b.TaxDocDate = a.SrcTaxDocDate AND b.OurID = a.OurID AND b.StockID = a.StockID AND b.CompID = a.CompID
			WHERE a.ChID = @ChID
    
			IF @ICHID IS NULL
				SELECT @ICHID = MIN(m.ChID)
				FROM dbo.at_t_Prepay i WITH(NOLOCK)
				JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = i.CompID
				JOIN dbo.r_Comps rc0 WITH(NOLOCK) ON rc0.Code=rc.Code AND rc0.Code!='0'
				JOIN dbo.at_t_Prepay m WITH(NOLOCK) ON m.OurID = i.OurID AND m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate
					AND m.CompID = rc0.CompID
				WHERE i.ChID = @ChID
			
			IF @ICHID IS NULL
				SELECT @ICHID = MIN(b.ChID)
				FROM dbo.at_t_Prepay a WITH(NOLOCK)
				JOIN "s-sql-back".Elit2014.dbo.at_t_Prepay b WITH(NOLOCK) ON b.TaxDocID = a.SrcTaxDocID AND b.TaxDocDate = a.SrcTaxDocDate AND b.OurID = a.OurID AND b.StockID = a.StockID AND b.CompID = a.CompID
				WHERE a.ChID = @ChID
					AND b.TaxDocDate >= '20120101'
    
			IF @ICHID IS NULL
				SELECT @ICHID = MIN(m.ChID)
				FROM dbo.at_t_Prepay i WITH(NOLOCK)
				JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = i.CompID
				JOIN dbo.r_Comps rc0 WITH(NOLOCK) ON rc0.Code=rc.Code AND rc0.Code!='0'
				JOIN "s-sql-back".Elit2014.dbo.at_t_Prepay m WITH(NOLOCK) ON m.OurID = i.OurID AND m.TaxDocID = i.SrcTaxDocID AND m.TaxDocDate = i.SrcTaxDocDate
					AND m.CompID = rc0.CompID
				WHERE i.ChID = @ChID
				AND m.TaxDocDate >= '20120101'
    
			IF @ICHID IS NULL
			BEGIN
				RAISERROR('Невозможно экспортировать документ %u, нет документа - ПН с указнным номером источника для предоплаты!', 18, 1, @ChID)  
				RETURN
			END
			ELSE				
				INSERT @TStr (OUT1)
				EXEC [dbo].[ap_Export_J1201007] @ICHID, 666027

			 /*IF EXISTS(SELECT *
								 FROM dbo.at_t_Prepay m WITH(NOLOCK)
								 WHERE ChID = @ChID 
									 AND (SrcTaxDocDate <'20120101' OR EXISTS(SELECT * FROM [dbo].[af_GetCompReqs](m.CompID, m.SrcTaxDocDate) rc WHERE TaxPayer = 0))
											 AND NOT EXISTS(SELECT * FROM dbo.at_t_Prepay i WITH(NOLOCK) WHERE i.SrcTaxDocID = m.SrcTaxDocID AND i.SrcTaxDocDate = m.SrcTaxDocDate AND i.OurID = m.OurID AND i.StateCode = 192))*/
		END
  END 
  
  SELECT @TmpStr = @TmpStr + ISNULL(OUT1, '') FROM @TStr
  SET @STR += CHAR(13) + CHAR(10) + @TmpStr
  
  DECLARE @tbl TABLE
  (
      ID INT IDENTITY(1,1),
      PStr VARCHAR(MAX)
  )
  DECLARE @PSTR VARCHAR(MAX) = ''
   DECLARE @LenSTR int=0

    WHILE LEN(@STR) > 0
BEGIN
	SET @LenSTR = CHARINDEX('</VALUE></ROW>', @STR) + len('</VALUE></ROW>') - 1;
	SET @PSTR = LEFT(@STR, @LenSTR)
	SET @STR = SUBSTRING(@STR, @LenSTR + 1, 16000000)

	INSERT @tbl (PStr)
	VALUES (@PSTR)
END
  
  SELECT PStr FROM @tbl ORDER BY ID


END;


GO
