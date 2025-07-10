EXEC [dbo].[ap_Export_J1201208_Medoc] @ChID = 5463, @DocCode = 0
5420
5501
5508
5463
SELECT * FROM ElitDistr.dbo.t_Ret  where TaxDocID = 530 and DocDate = '2018-06-01'
SELECT * FROM ElitDistr.dbo.t_RetD rdm where rdm.ChID=5242
SELECT * FROM ElitDistr.dbo.t_RetD_medoc rdm where rdm.ChID=5242
SELECT * FROM ElitDistr.dbo.t_RetD_medoc rdm where rdm.ProdID=32236

SELECT * FROM ElitDistr.dbo.t_RetD_medoc rdm where rdm.ChID=5242 and rdm.SrcPosID_medoc=4

5250	3	Вино Lozano. Кабальерос де ла Роса Тінто Семидульче , червоне 0,75*12
5256	3	Вино Lozano. Кабальерос де ла Роса Тінто Семидульче , червоне 0,75*12
5314	4	Вино Lozano. Кабальерос де ла Роса Тінто Семидульче , червоне 0,75*12
5323	5	Вино Lozano. Кабальерос де ла Роса Тінто Семідульче червоне 0,75*12
5332	6	Вино Lozano. Кабальерос де ла Роса Тінто Семідульче червоне 0,75*12
5336	4	Вино Lozano. Кабальерос де ла Роса Тінто Семідульче червоне 0,75*12
   select rtm.ChID, CompID,CodeID1, CodeID2 ,CodeID3, ProdID, PPID, Qty, PriceCC_nt, SrcTaxDocID,SrcTaxDocDate,tax,SrcDocID,SrcDocDate,SrcPosID  
   from  dbo.t_Ret rtm JOIN t_RetD rtD on rtm.ChID=rtD.ChID  where rtm.ChID=5314  group by 
    rtm.ChID, CompID, CodeID1, CodeID2 ,CodeID3, ProdID, PPID, Qty, PriceCC_nt, SrcTaxDocID,SrcTaxDocDate, Tax,SrcDocID,SrcDocDate,SrcPosID



SELECT * FROM (
SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price, TAB1_A8 Tax,  TAB1_A10 SumCC, 1 TypeDoc
FROM at_t_Medoc WHERE SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая 
UNION ALL
SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A011 Tax, TAB1_A013 SumCC,  2 TypeDoc
FROM at_t_Medoc_RET WHERE SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая 
) s1 
where ProdName = 'Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12'
and NNN = 6313


SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A011 Tax, TAB1_A013 SumCC,  2 TypeDoc,*
FROM at_t_Medoc_RET 
--WHERE 
--SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая 
--and 
--TAB1_A3 = 'Вино Oristan. Ористан Крианца 2013 красное 0,75*6'
--and 
--N2_11 = 237
--N2 =  '2018-05-01'
ORDER BY N2


DECLARE @SrcPosID int
 SELECT @SrcPosID = cast(Pos as int) from #Medoc_NN  where ProdID_Elit = 33736 

SELECT * FROM t_RetD

   select rtm.ChID, CompID,CodeID1, CodeID2 ,CodeID3, ProdID, PPID, Qty, PriceCC_nt, SrcTaxDocID,SrcTaxDocDate,tax,SrcDocID,SrcDocDate,SrcPosID  
   from  dbo.t_Ret rtm JOIN t_RetD rtD on rtm.ChID=rtD.ChID  where rtm.ChID=5181  group by 
    rtm.ChID, CompID, CodeID1, CodeID2 ,CodeID3, ProdID, PPID, Qty, PriceCC_nt, SrcTaxDocID,SrcTaxDocDate, Tax,SrcDocID,SrcDocDate,SrcPosID
    
    
    SELECT * FROM r_Prods ORDER BY Article2
    SELECT * FROM r_Prods where  Article2 like '%&M%'
 
    
    
SELECT CASE WHEN (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) <>0 THEN  @iter   ELSE  @iter2 END   [SID],
 Cast (@SrcPosID as varchar(max)) as [TAB1_A01],
 dbo.zf_DateToStr(@SrcTaxDocDate) [TAB1_A1],
  CASE WHEN @CodeID2 IN (19,69,56)  and  (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) <>0 THEN 'Зміна кількості'  WHEN @CodeID2 IN (19) and  (SUM(ISNULL(@QtyInv, 0)) - SUM(@Qty)) =0 THEN 'Повернення товару або авансових платежів'
        WHEN @CodeID2 IN (43,38) THEN 'Зміна ціни' 
        WHEN @CodeID2 IN (44,58) THEN 'Зміна кількості'
        ELSE ''
      END [TAB1_A2],
      (CASE WHEN  @CodeID1 = 63  and @CodeID2 IN (18,43, 44, 69) and @CodeID3 = 4   
		and @SrcTaxDocDate >= '20161201'and rp.Article2 like '%&M%' and rtm.CompID Not between 7000 and 7999 and  rtm.CompID Not between 10790 and 10799   THEN  rp.Article2
		ELSE ISNULL(NULLIF(ec.ExtProdName,''), rp.Notes)END) AS [TAB1_A3], -- по заявке 7630 
      
	 Case When rp.PGrID2 Between 0 and 401 or rp.PGrID2  Between 403 and 1000000 THEN pp.FEAProdID end AS 'TAB1_A31',
	 Case When rp.ImpID = 1  THEN 1 end   AS 'TAB1_A32',
	 Case When rp.PGrID2 = 402 THEN pp.FEAProdID end AS 'TAB1_A33',

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
       group by  rp.Article2, rtm.CompID, ec.ExtProdName, rp.Notes, rp.PGrID2,pp.FEAProdID,rp.ImpID, rumq.RefName,rumq.RefID,rtm.CodeID2    
       

DECLARE @ChID int = 4909
	--Временная таблица по НН
	IF OBJECT_ID (N'tempdb..#Medoc_NN', N'U') IS NOT NULL DROP TABLE #Medoc_NN

 	DECLARE @NNN INT = (SELECT SrcTaxDocID FROM dbo.t_Ret WHERE ChID = @ChID)
 	DECLARE @DNN SMALLDATETIME = (SELECT SrcTaxDocDate FROM dbo.t_Ret WHERE ChID = @ChID)
--DECLARE @NNN INT = (SELECT SrcTaxDocID FROM dbo.t_Ret WHERE ChID = 5043)--@ChID 4940
--DECLARE @DNN SMALLDATETIME = (SELECT SrcTaxDocDate FROM dbo.t_Ret WHERE ChID = 5043)--@ChID
SELECT * FROM dbo.t_Ret WHERE ChID = @ChID
SELECT * FROM dbo.t_RetD WHERE ChID = @ChID

	SELECT * 
	 INTO #Medoc_NN	
	FROM (
		SELECT  DNN,NNN,(SELECT top 1 p1.ProdID FROM Elit.dbo.r_Prods p1 where p1.Notes = un.ProdName) ProdID_Elit, ProdName,UM,Pos , 
			SUM(Qty) TQty , MAX(Price) Price, MAX(Tax) Tax, MAX(TypeDoc) TypeDoc
		FROM (
				SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price, TAB1_A8 Tax,  TAB1_A10 SumCC, 1 TypeDoc
				FROM at_t_Medoc WHERE SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая 
			UNION ALL
				SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A011 Tax, TAB1_A013 SumCC,  2 TypeDoc
				FROM at_t_Medoc_RET WHERE SEND_DPA_DATE IS NOT NULL --дата отправки в налоговую не пустая 
			) un 
		GROUP BY DNN,NNN, ProdName,UM,Pos 
		HAVING SUM(Qty) > 0 
			AND 10797 = (SELECT top 1 CompID FROM Elit.dbo.t_Inv i WHERE i.TaxDocDate = DNN and i.TaxDocID = NNN)--только РН которые по предприятию 10797
			AND NNN = @NNN AND DNN = @DNN
		--ORDER BY cast(Pos as int)
		) s1

		
SELECT * FROM #Medoc_NN	 where ProdID_Elit = 23774       


DECLARE @s varchar(250) = 'Текіла Сієрра Голд 38%  3*1'
SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price, TAB1_A8 Tax,  TAB1_A10 SumCC, 1 TypeDoc
FROM at_t_Medoc where TAB1_A13 = @s


SELECT * FROM at_t_Medoc where TAB1_A13 = @s
SELECT * FROM at_t_Medoc_RET where TAB1_A3 = @s
