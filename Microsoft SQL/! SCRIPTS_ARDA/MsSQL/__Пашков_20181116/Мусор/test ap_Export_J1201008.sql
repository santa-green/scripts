
--ALTER PROC [dbo].[ap_Export_J1201008] @ChID INT, @DocCode INT = 0, @IsConsolidated BIT = 0
--AS
DECLARE @ChID INT = 292, @DocCode INT = 11012, @IsConsolidated BIT = 0

BEGIN tran
  SET NOCOUNT ON
  --PRINT @ChID EXEC [dbo].[ap_Export_J1201008] @ChID = 58, @DocCode = 12022, @IsConsolidated = 0
  /*#-BeginDebug Chid
  DECLARE @ChID INT = (SELECT MAX(ChID) FRom t_Inv WHERE TaxDocID > 0  AND TSumCC_wt > 10000 AND CodeID2 = 58)
  DECLARE @IsConsolidated BIT = 0
  DECLARE @DocCode INT = 0
  #-EndDebug*/

  IF EXISTS(SELECT * FROM dbo.t_Inv WHERE ChID = @ChID AND TaxDocID = 0)
  BEGIN
    RAISERROR('Невозможно экспортировать документ без присвоенного номера налоговой!', 18, 1)
    RETURN
  END

  --rss0 заявка 676
  IF EXISTS(Select  r.Chid,r.Prodid,r.PPID, ps.ProdName, pin.FEAProdID
From t_InvD r join r_Prods ps on r.ProdID = ps.ProdID join t_PInP pin on ps.ProdID = pin.ProdID
Where r.Chid = @ChID and r.PPID=pin.PPID and (pin.FEAProdID is Null or pin.FEAProdID = '') and ps.PGrID2 not in (SELECT RefID FROM dbo.r_Uni WITH(NOLOCK) WHERE RefTypeID = 6660223)) 
BEGIN
Declare @er nVarchar(Max)
set @er = (Select '№ '+ Cast(r.Prodid as nVarchar (Max))+' с партией '+ Cast(pin.PPID as nVarchar (Max))+',' as 'data()'
From t_InvD r join r_Prods ps on r.ProdID = ps.ProdID join t_PInP pin on ps.ProdID = pin.ProdID
Where r.Chid = @ChID and r.PPID=pin.PPID and (pin.FEAProdID is Null or pin.FEAProdID = '') for xml path (''))
    RAISERROR('Внимание!!!! Для товара  %s не заполнено поле «Код УКТВЭД»', 18, 1, @er)  
    RETURN
  END
-------


  DECLARE @Ch TABLE (ChID INT)
  IF @IsConsolidated = 0
    INSERT @Ch
    VALUES (@ChID)
  ELSE
    INSERT @Ch
    SELECT m.ChID
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID
    WHERE EXISTS(SELECT * FROM dbo.t_Inv m0 WITH(NOLOCK) JOIN dbo.r_Comps rc0 WITH(NOLOCK) ON rc0.CompID=m0.CompID WHERE m0.ChID = @ChID AND m0.TaxDocID = m.TaxDocID AND rc0.Value1 = rc.Value1 AND m0.OurID = m.OurID AND dbo.zf_GetMonthFirstDay(m0.DocDate) = dbo.zf_GetMonthFirstDay(m.DocDate))

  DECLARE @HeadTbl TABLE
  (
    [FIRM_INN] VARCHAR(1024),
    [FIRM_EDRPOU] VARCHAR(1024),
    [N4] VARCHAR(1024),
	[EDR_POK] VARCHAR(1024),
    [FIRM_ADR] VARCHAR(1024),
    [FIRM_NAME] VARCHAR(1024),
    [FIRM_PHON] VARCHAR(1024),
    [PHON] VARCHAR(1024),
    [N13] VARCHAR(1024),
    [N14] VARCHAR(1024),
    [N10] VARCHAR(1024),
	[INN] VARCHAR(1024),
    [N11] VARCHAR(1024),
    [N2_1] VARCHAR(1024),
    [N2_11] VARCHAR(1024),
    [N3] VARCHAR(1024),
    [N5] VARCHAR(1024),
    [N6] VARCHAR(1024),
    [N8] VARCHAR(1024),
    [N81] VARCHAR(1024),
    [N82] VARCHAR(1024),
    [N9] VARCHAR(1024),
    [A5_11] VARCHAR(1024),
    [A5_7] VARCHAR(1024),
    [A5_9] VARCHAR(1024),
    [A6_11] VARCHAR(1024),
    [A6_7] VARCHAR(1024),
    [A7_11] VARCHAR(1024),
    [A7_7] VARCHAR(1024),
    [A7_9] VARCHAR(1024)
  )

  DECLARE @DetTbl TABLE
  (
    [SID] SMALLINT,
	[TAB1_A8] VARCHAR(1024),
    [TAB1_A12] VARCHAR(1024),
    [TAB1_A13] VARCHAR(1024),
    [TAB1_A14] VARCHAR(1024),
    [TAB1_A141] VARCHAR(1024),
    [TAB1_A15] VARCHAR(1024),
    [TAB1_A16] VARCHAR(1024),
    [TAB1_A10] VARCHAR(1024),
    [TAB1_A19] VARCHAR(1024),
    [TAB1_A131] VARCHAR(1024),
    [_A6_7] NUMERIC(21,2),
    [_A6_9] NUMERIC(21,2),
    [_A7_7] NUMERIC(21,2),
    [_A7_9] NUMERIC(21,2)
  )

  IF @DocCode = 11012
  /* Расходная накладная */
  BEGIN
		IF EXISTS(SELECT * FROM dbo.t_Inv WHERE ChID IN (SELECT ChID FROM @Ch) AND TaxDocDate >= '20150101')
		BEGIN
			INSERT @DetTbl
			SELECT 
			ROW_NUMBER() OVER(ORDER BY MAX(d.SrcPosID)) - 1 AS [SID],
			20 as [TAB1_A8],
			dbo.zf_DateToStr(m.TaxDocDate) AS 'TAB1_A12',
			LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), p.Notes))) AS 'TAB1_A13',
      rumq.RefName AS 'TAB1_A14',
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
			CAST(SUM(Qty) AS NUMERIC(21,6)) AS 'TAB1_A15',
			CASE m.CodeID2 WHEN 58 THEN CAST(d.PriceCC_wt AS NUMERIC(21,7)) ELSE CAST(d.PriceCC_nt AS NUMERIC(21,7)) END AS 'TAB1_A16',
			CASE WHEN m.CodeID2 != 58 THEN CAST(SUM(d.SumCC_nt) AS NUMERIC(21,2)) END AS 'TAB1_A10',
			CASE m.CodeID2 WHEN 58 THEN CAST(SUM(d.SumCC_wt) AS NUMERIC(21,2)) END AS 'TAB1_A19',
			pp.FEAProdID AS 'TAB1_A131',
      CASE m.CodeID2 WHEN 58 THEN 0 ELSE ROUND(SUM(d.TaxSum), 2) END AS '_A6_7',
      0 AS '_A6_9',
      CASE m.CodeID2 WHEN 58 THEN 0 ELSE ROUND(SUM(d.SumCC_wt), 2) END AS '_A7_7',
      CASE m.CodeID2 WHEN 58 THEN ROUND(SUM(d.SumCC_wt), 2) ELSE 0 END AS '_A7_9'
			FROM dbo.t_Inv m WITH(NOLOCK)
			JOIN dbo.t_InvD d WITH(NOLOCK) ON d.ChID=m.ChID
			JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID
			JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID
			LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.CompID = m.CompID AND ec.ProdID = d.ProdID
			JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = p.UM
------------------------------------------------------------------------
			WHERE m.ChID IN (@ChID)
------------------------------------------------------------------------
			GROUP BY Cast (d.SrcPosID as varchar(Max)), d.SrcPosID,d.ProdID, m.CodeID2, m.TaxDocDate, LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), p.Notes))), pp.FEAProdID,
        rumq.RefName, rumq.RefID, d.PriceCC_nt, d.PriceCC_wt, pp.CustDocNum, pp.CustDocDate
      
			INSERT @HeadTbl
			SELECT
			dbo.af_GetFiltered(ro.TaxCode) 'FIRM_INN',
			dbo.af_GetFiltered(ro.Code) 'FIRM_EDRPOU',
			dbo.af_GetFiltered(rc.TaxCode) 'N4',
			dbo.af_GetFiltered(rc.Code) 'EDR_POK',
			ro.[Address] + ', ' + ro.City + ', ' + ro.PostIndex AS 'FIRM_ADR',
			ro.Note2 'FIRM_NAME',
			dbo.af_GetFiltered(ro.Phone) 'FIRM_PHON',
			dbo.af_GetFiltered(ro.Phone) 'PHON',
			CASE rc.TaxPayer WHEN 0 THEN '1' ELSE '' END AS 'N13',
			CASE rc.TaxPayer WHEN 0 THEN '02' ELSE '' END AS 'N14',
			LEFT(re.UAEmpFirstName, 1) + '.' + LEFT(re.UAEmpParName, 1) + '. ' + re.UAEmpLastName AS 'N10',
			re.TaxCode as [INN],
			dbo.zf_DateToStr(m.TaxDocDate) AS 'N11',
			LEFT(m.TaxDocID,7) AS 'N2_1', LEFT(m.TaxDocID,7) AS 'N2_11',
			rc.TaxCompName AS 'N3',
			rc.TaxAddress AS 'N5',
			dbo.af_GetFiltered(rc.Phone1) 'N6',
			dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrType') AS 'N8',
			REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrID3'),'-','@'),'/','#')),'@','-'),'#','/') AS 'N81',
			dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'BDate') AS 'N82',
			'Оплата з поточного рахунка' AS 'N9',
      CAST((SELECT SUM(CAST(ISNULL(TAB1_A10, 0) AS NUMERIC(21,2))) + SUM(CAST(ISNULL(TAB1_A19, 0) AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A5_11',
      CAST((SELECT SUM(CAST(TAB1_A10 AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A5_7',
      CAST((SELECT SUM(CAST(TAB1_A19 AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A5_9',
      CAST((SELECT SUM(_A6_7) + SUM(_A6_9) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A6_11',
      CAST((SELECT SUM(_A6_7) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A6_7',
      CAST((SELECT SUM(_A7_7) + SUM(_A7_9) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A7_11',
      CAST((SELECT SUM(_A7_7) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A7_7',
      CAST((SELECT SUM(_A7_9) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A7_9'
			FROM dbo.t_Inv m WITH(NOLOCK)
			JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
			OUTER APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) rc
			Left JOIN dbo.at_r_OurMEDoc om WITH(NOLOCK) ON om.OurID = m.OurID AND m.TaxDocDate BETWEEN om.BDate AND om.EDate
			JOIN dbo.r_Emps re WITH(NOLOCK) ON re.EmpID = om.EmpID
			JOIN dbo.z_DocLinks z WITH(NOLOCK) ON z.ChildDocCode = 11012 AND z.ParentDocCode = 666028 AND z.ChildChID = m.ChID
			JOIN dbo.r_Comps c WITH(NOLOCK) ON m.CompID=c.CompID
			WHERE m.ChID IN (SELECT ChID FROM @Ch)
			ORDER BY m.ChID
		END
		ELSE GOTO OldProc
  END
  ELSE IF @DocCode = 666027
  /* Накладная на предоплату */
  BEGIN    
    --IF EXISTS(SELECT * FROM dbo.at_t_Prepay WHERE ChID = @ChID AND TaxDocDate >= '20150101')
		--BEGIN
			INSERT @DetTbl
			SELECT 
			ROW_NUMBER() OVER(ORDER BY MAX(SrcPosID)) - 1 AS [SID],
			20 as [TAB1_A8],
			dbo.zf_DateToStr(m.TaxDocDate) AS 'TAB1_A12',
			LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), p.Notes))) AS 'TAB1_A13',
			rumq.RefName AS 'TAB1_A14',
			REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
			CAST(SUM(Qty) AS NUMERIC(21,6)) AS 'TAB1_A15',
			CAST(d.PriceCC_nt AS NUMERIC(21,7)) AS 'TAB1_A16',
			CAST(SUM(d.SumCC_nt) AS NUMERIC(21,2)) AS 'TAB1_A10',
			NULL AS 'TAB1_A19',
			pp.FEAProdID AS 'TAB1_A131', 
			ROUND(SUM(d.TaxSum), 2) AS '_A6_7',
			0 AS '_A6_9',
			ROUND(SUM(d.SumCC_wt), 2) AS '_A7_7',
			0 AS '_A7_9'
			FROM dbo.at_t_Prepay m WITH(NOLOCK)
			JOIN dbo.at_t_PrepayD d WITH(NOLOCK) ON d.ChID=m.ChID
			JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID
			JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefName = p.UM
			JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID
			LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.CompID = m.CompID AND ec.ProdID = d.ProdID
			WHERE m.ChID = @ChID
			GROUP BY Cast(d.SrcPosID as varchar(Max)),d.ProdID, m.CodeID2, m.TaxDocDate, LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), p.Notes))), pp.FEAProdID, 
					rumq.RefName, rumq.RefID, d.PriceCC_nt, d.PriceCC_wt, pp.CustDocNum, pp.CustDocDate
      
			INSERT @HeadTbl
			SELECT
			dbo.af_GetFiltered(ro.TaxCode) 'FIRM_INN',
			dbo.af_GetFiltered(ro.Code) 'FIRM_EDRPOU',
			dbo.af_GetFiltered(rc.TaxCode) 'N4',
			
			dbo.af_GetFiltered(rc.Code) 'EDR_POK',
			ro.[Address] + ', ' + ro.City + ', ' + ro.PostIndex AS 'FIRM_ADR',
			ro.Note2 'FIRM_NAME',
			dbo.af_GetFiltered(ro.Phone) 'FIRM_PHON',
			dbo.af_GetFiltered(ro.Phone) 'PHON',
			CASE rc.TaxPayer WHEN 0 THEN '1' ELSE '' END AS 'N13',
			CASE rc.TaxPayer WHEN 0 THEN '02' ELSE '' END AS 'N14',
			LEFT(re.UAEmpFirstName, 1) + '.' + LEFT(re.UAEmpParName, 1) + '. ' + re.UAEmpLastName AS 'N10',
			re.TaxCode as [INN],
			dbo.zf_DateToStr(m.TaxDocDate) AS 'N11',
			LEFT(m.TaxDocID,7) AS 'N2_1', LEFT(m.TaxDocID,7) AS 'N2_11',
			rc.TaxCompName AS 'N3',
			rc.TaxAddress AS 'N5',
			dbo.af_GetFiltered(rc.TaxPhone) 'N6',
			dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrType') AS 'N8',
			REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrID3'),'-','@'),'/','#')),'@','-'),'#','/') AS 'N81',
			dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'BDate') AS 'N82',
			'Оплата з поточного рахунка' AS 'N9',
			CAST((SELECT SUM(CAST(ISNULL(TAB1_A10, 0) AS NUMERIC(21,2))) + SUM(CAST(ISNULL(TAB1_A19, 0) AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A5_11',
			CAST((SELECT SUM(CAST(TAB1_A10 AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A5_7',
			CAST((SELECT SUM(CAST(TAB1_A19 AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A5_9',
			CAST((SELECT SUM(_A6_7) + SUM(_A6_9) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A6_11',
			CAST((SELECT SUM(_A6_7) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A6_7',
			CAST((SELECT SUM(_A7_7) + SUM(_A7_9) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A7_11',
			CAST((SELECT SUM(_A7_7) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A7_7',
			CAST((SELECT SUM(_A7_9) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A7_9'
			FROM dbo.at_t_Prepay m WITH(NOLOCK)
			JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
			OUTER APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) rc
			JOIN dbo.at_r_OurMEDoc om WITH(NOLOCK) ON om.OurID = m.OurID AND m.TaxDocDate BETWEEN om.BDate AND om.EDate
			JOIN dbo.r_Emps re WITH(NOLOCK) ON re.EmpID = om.EmpID
			JOIN dbo.z_DocLinks z WITH(NOLOCK) ON z.ChildDocCode = 666027 AND z.ParentDocCode = 666028 AND z.ChildChID = m.ChID
			JOIN dbo.r_Comps c WITH(NOLOCK) ON m.CompID=c.CompID
			WHERE m.ChID = @ChID
			--END	ELSE GOTO OldProc
			IF (NOT EXISTS(SELECT * FROM @HeadTbl) OR NOT EXISTS(SELECT * FROM @DetTbl)) AND
			   EXISTS(SELECT * FROM "s-sql-back".Elit2014.dbo.at_t_Prepay WHERE ChID=@ChID)
			  GOTO OldProc
  END
  ELSE IF @DocCode = 12022
  BEGIN
	  IF EXISTS(SELECT * FROM dbo.av_c_PlanRec WHERE AChID = @ChID AND DocDate >= '20150101')
		BEGIN
			INSERT @DetTbl
			SELECT 
			ROW_NUMBER() OVER(ORDER BY m.Subject) - 1 AS [SID],
			20 as [TAB1_A8],
			dbo.zf_DateToStr(m.DocDate) AS 'TAB1_A12',
			LTRIM(RTRIM(m.Subject)) AS 'TAB1_A13',
			rumq.RefName AS 'TAB1_A14',
			REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
			CAST(1 AS NUMERIC(21,6)) AS 'TAB1_A15',
			CAST(SUM(m.SumAC * m.KursCC)/1.2 AS NUMERIC(21,7)) AS 'TAB1_A16',
			CAST(SUM(m.SumAC * m.KursCC)/1.2 AS NUMERIC(21,2)) AS 'TAB1_A10',
			0 AS 'TAB1_A19',
			'' AS 'TAB1_A131', 
			ROUND(SUM(m.SumAC * m.KursCC)/6, 2) AS '_A6_7',
			0 AS '_A6_9',
			ROUND(SUM(m.SumAC * m.KursCC), 2) AS '_A7_7',
			0 AS '_A7_9'
			FROM dbo.av_c_PlanRec m WITH(NOLOCK)
			JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefID = 2454
			WHERE m.AChID = @ChID
			GROUP BY m.DocDate, m.Subject, rumq.RefName, rumq.RefID

			INSERT @HeadTbl
			SELECT TOP 1
			dbo.af_GetFiltered(ro.TaxCode) 'FIRM_INN',
			dbo.af_GetFiltered(ro.Code) 'FIRM_EDRPOU',
			dbo.af_GetFiltered(rc.TaxCode) 'N4',
			dbo.af_GetFiltered(rc.Code) 'EDR_POK',
			ro.[Address] + ', ' + ro.City + ', ' + ro.PostIndex AS 'FIRM_ADR',
			ro.Note2 'FIRM_NAME',
			dbo.af_GetFiltered(ro.Phone) 'FIRM_PHON',
			dbo.af_GetFiltered(ro.Phone) 'PHON',
			CASE rc.TaxPayer WHEN 0 THEN '1' ELSE '' END AS 'N13',
			CASE rc.TaxPayer WHEN 0 THEN '02' ELSE '' END AS 'N14',
			LEFT(re.UAEmpFirstName, 1) + '.' + LEFT(re.UAEmpParName, 1) + '. ' + re.UAEmpLastName AS 'N10',
			re.TaxCode as [INN],
			dbo.zf_DateToStr(m.DocDate) AS 'N11',
			LEFT(m.DocID,7) AS 'N2_1', LEFT(m.DocID,7) AS 'N2_11',
			rc.TaxCompName AS 'N3',
			rc.TaxAddress AS 'N5',
			dbo.af_GetFiltered(rc.TaxPhone) 'N6',
			ru.RefName AS 'N8',
			REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(zc.ContrID,'-','@'),'/','#')),'@','-'),'#','/') AS 'N81',
			dbo.zf_DateToStr(zc.BDate) AS 'N82',
			'оплата з поточного рахунка' AS 'N9',
			CAST((SELECT SUM(CAST(ISNULL(TAB1_A10, 0) AS NUMERIC(21,2))) + SUM(CAST(ISNULL(TAB1_A19, 0) AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A5_11',
			CAST((SELECT SUM(CAST(TAB1_A10 AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A5_7',
			CAST((SELECT SUM(CAST(TAB1_A19 AS NUMERIC(21,2))) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A5_9',
			CAST((SELECT SUM(_A6_7) + SUM(_A6_9) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A6_11',
			CAST((SELECT SUM(_A6_7) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A6_7',
			CAST((SELECT SUM(_A7_7) + SUM(_A7_9) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A7_11',
			CAST((SELECT SUM(_A7_7) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A7_7',
			CAST((SELECT SUM(_A7_9) FROM @DetTbl) AS NUMERIC(21,2)) AS 'A7_9'
			FROM dbo.av_c_PlanRec m WITH(NOLOCK)
			JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID - 20
			OUTER APPLY [dbo].[af_GetCompReqs](m.CompID, m.DocDate) rc
			JOIN dbo.at_r_OurMEDoc om WITH(NOLOCK) ON om.OurID = ro.OurID AND m.DocDate BETWEEN om.BDate AND om.EDate
			JOIN dbo.r_Emps re WITH(NOLOCK) ON re.EmpID = om.EmpID
			JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.CompID=m.CompID AND zc.OurID=ro.OurID /*AND zc.Status IN (1,2)*/ AND zc.ContrTypeID=3 AND dbo.zf_GetMonthLastDay(m.DocDate) >= zc.BDate --BETWEEN zc.BDate AND zc.EDate
			JOIN dbo.r_Uni ru WITH(NOLOCK) ON ru.RefTypeID = 6660120 AND ru.RefID = zc.OffTypeID
			JOIN dbo.r_Comps c WITH(NOLOCK) ON m.CompID=c.CompID
			WHERE m.AChID = @ChID
			ORDER BY CASE WHEN zc.Status = 0 THEN 100 ELSE zc.Status END
		END	ELSE GOTO OldProc
  END

  SELECT * FROM @HeadTbl SELECT * FROM @DetTbl

/* для отладки
IF OBJECT_ID (N'tempdb..#DetTbl', N'U') IS NOT NULL DROP TABLE #DetTbl
IF OBJECT_ID (N'tempdb..#Ch', N'U') IS NOT NULL DROP TABLE #Ch
SELECT * into  #DetTbl   FROM @DetTbl
SELECT * FROM #DetTbl

SELECT * into  #Ch   FROM @Ch
SELECT * FROM #Ch


			SELECT *
			--dbo.af_GetFiltered(ro.TaxCode) 'FIRM_INN',
			--dbo.af_GetFiltered(ro.Code) 'FIRM_EDRPOU',
			--dbo.af_GetFiltered(rc.TaxCode) 'N4',
			--dbo.af_GetFiltered(rc.Code) 'EDR_POK',
			--ro.[Address] + ', ' + ro.City + ', ' + ro.PostIndex AS 'FIRM_ADR',
			--ro.Note2 'FIRM_NAME',
			--dbo.af_GetFiltered(ro.Phone) 'FIRM_PHON',
			--dbo.af_GetFiltered(ro.Phone) 'PHON',
			--CASE rc.TaxPayer WHEN 0 THEN '1' ELSE '' END AS 'N13',
			--CASE rc.TaxPayer WHEN 0 THEN '02' ELSE '' END AS 'N14',
			--LEFT(re.UAEmpFirstName, 1) + '.' + LEFT(re.UAEmpParName, 1) + '. ' + re.UAEmpLastName AS 'N10',
			--re.TaxCode as [INN],
			--dbo.zf_DateToStr(m.TaxDocDate) AS 'N11',
			--LEFT(m.TaxDocID,7) AS 'N2_1', LEFT(m.TaxDocID,7) AS 'N2_11',
			--rc.TaxCompName AS 'N3',
			--rc.TaxAddress AS 'N5',
			--dbo.af_GetFiltered(rc.Phone1) 'N6',
			--dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrType') AS 'N8',
			--REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'ContrID3'),'-','@'),'/','#')),'@','-'),'#','/') AS 'N81',
			--dbo.af_GetContrData(z.ParentChID, z.ParentDocCode,'BDate') AS 'N82',
			--'Оплата з поточного рахунка' AS 'N9',
   --   CAST((SELECT SUM(CAST(ISNULL(TAB1_A10, 0) AS NUMERIC(21,2))) + SUM(CAST(ISNULL(TAB1_A19, 0) AS NUMERIC(21,2))) FROM #DetTbl) AS NUMERIC(21,2)) AS 'A5_11',
   --   CAST((SELECT SUM(CAST(TAB1_A10 AS NUMERIC(21,2))) FROM #DetTbl) AS NUMERIC(21,2)) AS 'A5_7',
   --   CAST((SELECT SUM(CAST(TAB1_A19 AS NUMERIC(21,2))) FROM #DetTbl) AS NUMERIC(21,2)) AS 'A5_9',
   --   CAST((SELECT SUM(_A6_7) + SUM(_A6_9) FROM #DetTbl) AS NUMERIC(21,2)) AS 'A6_11',
   --   CAST((SELECT SUM(_A6_7) FROM #DetTbl) AS NUMERIC(21,2)) AS 'A6_7',
   --   CAST((SELECT SUM(_A7_7) + SUM(_A7_9) FROM #DetTbl) AS NUMERIC(21,2)) AS 'A7_11',
   --   CAST((SELECT SUM(_A7_7) FROM #DetTbl) AS NUMERIC(21,2)) AS 'A7_7',
   --   CAST((SELECT SUM(_A7_9) FROM #DetTbl) AS NUMERIC(21,2)) AS 'A7_9'
			FROM dbo.t_Inv m WITH(NOLOCK)
			JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
			OUTER APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) rc
			Left JOIN dbo.at_r_OurMEDoc om WITH(NOLOCK) ON om.OurID = m.OurID AND m.TaxDocDate BETWEEN om.BDate AND om.EDate
			JOIN dbo.r_Emps re WITH(NOLOCK) ON re.EmpID = om.EmpID
			JOIN dbo.z_DocLinks z WITH(NOLOCK) ON z.ChildDocCode = 11012 AND z.ParentDocCode = 666028 AND z.ChildChID = m.ChID
			JOIN dbo.r_Comps c WITH(NOLOCK) ON m.CompID=c.CompID
			WHERE m.ChID IN (SELECT ChID FROM #Ch)
			ORDER BY m.ChID

--SELECT * FROM z_docs where DocCode = 666028
*/

  IF NOT EXISTS(SELECT * FROM @HeadTbl) OR NOT EXISTS(SELECT * FROM @DetTbl)
  BEGIN
    DECLARE @DocName VARCHAR(250) = CASE @DocCode WHEN 666027 THEN '"Накладная на предоплату"' WHEN 12022 THEN '"Планирование: Доходы"' ELSE '"Расходная накладная"' END
		IF @DocCode = 12022 SELECT TOP 1 @ChID = CompID FROM av_c_PlanRec WHERE AChID = @ChID
    RAISERROR('Отсутствуют данные для экспорта %s J1201008 по %u! Проверьте заполнение основных справочников.', 18, 1, @DocName ,@ChID)
    RETURN
  END
  
  DECLARE @STR VARCHAR(MAX) = (SELECT [OUT] =
  CAST((
  SELECT (SELECT 0 AS 'PERTYPE', 
      '01' + RIGHT([N11],8) AS 'PERDATE',
      'J1201008' AS 'CHARCODE',
      [N2_1] + '.' + CAST(@ChID AS VARCHAR(10)) 'DOCID'
      FROM @HeadTbl
    FOR XML PATH ('FIELDS'), TYPE
      ),
      (SELECT 
        (SELECT 0 '@TAB', 0 '@LINE', PName '@NAME', PVal 'VALUE'
        FROM @HeadTbl p
        UNPIVOT
          (PVal FOR PName IN
            (INN,FIRM_INN,FIRM_EDRPOU,N4,EDR_POK,FIRM_ADR,FIRM_NAME,FIRM_PHON,PHON,N13,N14,N10,N11,N2_1,N2_11,N3,N5,N6,N8,N81,N82,N9,A5_11,A5_7,A5_9,A6_11,A6_7,A7_11,A7_7,A7_9)
         ) AS unpvt
          FOR XML PATH ('ROW'), TYPE
        ),
        (SELECT 1 '@TAB', [SID] '@LINE', PName '@NAME', PVal 'VALUE'
        FROM @DetTbl p
        UNPIVOT
          (PVal FOR PName IN
            (TAB1_A8,TAB1_A12,TAB1_A13,TAB1_A14,TAB1_A141,TAB1_A15,TAB1_A16,TAB1_A10,TAB1_A19,TAB1_A131)
          ) AS unpvt
          FOR XML PATH ('ROW'), TYPE
      ) FOR XML PATH('DOCUMENT'), TYPE)
  FOR XML PATH ('CARD')
  ) AS VARCHAR(MAX)))

  DECLARE @tbl TABLE
  (
      ID INT IDENTITY(1,1),
 PStr VARCHAR(MAX)
  )
  DECLARE @PSTR VARCHAR(MAX) = ''
  DECLARE @LenSTR int=0

 /* WHILE LEN(@STR) > 0
  BEGIN
    SET @PSTR = LEFT(@STR, 32768)
    SET @STR = SUBSTRING(@STR,32769,16000000)
    INSERT @tbl (PStr)
    VALUES (@PSTR)
  END*/

  WHILE LEN(@STR) > 0
BEGIN
	SET @LenSTR = CHARINDEX('</VALUE></ROW>', @STR) + len('</VALUE></ROW>') - 1;
	SET @PSTR = LEFT(@STR, @LenSTR)
	SET @STR = SUBSTRING(@STR, @LenSTR + 1, 16000000)

	INSERT @tbl (PStr)
	VALUES (@PSTR)
END


  SELECT PStr FROM @tbl ORDER BY ID
	RETURN
	OldProc:
	--  DECLARE @SQL NVARCHAR(255) = 'EXEC [Elit2014].[dbo].[ap_Export_J1201008] @ChID = ' + CAST(@ChID AS VARCHAR) + ', @DocCode = ' + CAST(@ChID AS VARCHAR) + ', @IsConsolidated = ' + CAST(@ChID AS VARCHAR) + 
		EXEC [s-sql-back].[Elit2014].[dbo].[ap_Export_J1201007] @ChID, @DocCode, @IsConsolidated
		
		
rollback tran;

GO
