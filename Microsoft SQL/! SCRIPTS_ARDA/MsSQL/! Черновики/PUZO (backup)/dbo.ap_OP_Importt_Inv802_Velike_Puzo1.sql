USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_OP_Importt_Inv802_Velike_Puzo]    Script Date: 18.01.2021 0:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_OP_Importt_Inv802_Velike_Puzo]AS BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON


IF EXISTS (SELECT inv.ChID FROM t_Inv inv  
           JOIN r_Comps co ON inv.CompID=co.CompID  
           WHERE 1 = 1
            AND co.CodeID2=810
            AND DocDate>='2018-02-9'
            AND inv.ChID NOT IN (select ChID from at_SendXML where ChID=inv.ChID)
            GROUP BY inv.ChID)

BEGIN
 
 BEGIN TRAN
DECLARE @xml VARCHAR(MAX) = ''
 
DECLARE @ChId INT


 
  DECLARE Cur CURSOR FAST_FORWARD
  FOR SELECT inv.ChID FROM t_Inv inv  JOIN r_Comps co on inv.CompID=co.CompID  WHERE co.CodeID2=810 AND DocDate>='2018-02-9' and inv.ChID NOT IN (select ChID from at_SendXML where ChID=inv.ChID ) group by inv.ChID
     
     OPEN Cur 
   FETCH NEXT FROM Cur INTO @ChId
   
   WHILE @@FETCH_STATUS=0
     BEGIN 


--select * from r_Comps where CodeID2=810

 

  DECLARE @HeadTbl TABLE
  (
    [FIRM_INN] VARCHAR(1024),
    [FIRM_EDRPOU] VARCHAR(1024),
    [N4] VARCHAR(1024),
	[DEPT_POK] VARCHAR(1024),
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

DELETE @HeadTbl

  DECLARE @DetTbl TABLE
  (
    [SID] SMALLINT,
	[TAB1_A8] VARCHAR(1024),
    [TAB1_A12] VARCHAR(1024),
    [TAB1_A20] VARCHAR(1024),
    [TAB1_A13] VARCHAR(1024),
    [TAB1_A14] VARCHAR(1024),
    [TAB1_A141] VARCHAR(1024),
    [TAB1_A15] VARCHAR(1024),
    [TAB1_A16] VARCHAR(1024),
    [TAB1_A10] VARCHAR(1024),
    [TAB1_A19] VARCHAR(1024),
    [TAB1_A131] VARCHAR(1024),
	[TAB1_A132] VARCHAR(1024),
	[TAB1_A133] VARCHAR(1024),
    [_A6_7] NUMERIC(21,2),
    [_A6_9] NUMERIC(21,2),
    [_A7_7] NUMERIC(21,2),
    [_A7_9] NUMERIC(21,2)
  )
DELETE @DetTbl
		
		
			INSERT @DetTbl
			SELECT 
			ROW_NUMBER() OVER(ORDER BY MAX(d.SrcPosID)) - 1 AS [SID],
			20 as [TAB1_A8],
			m.CompID 'TAB1_A20',
			dbo.zf_DateToStr(m.TaxDocDate) AS 'TAB1_A12',
		(CASE WHEN  m.CodeID1 = 63  and m.CodeID2 IN (18,43, 44, 69) and m.CodeID3 = 4   
		and m.taxdocdate >= '20161201'and p.Article2 like '%&M%' and m.CompID Not between 7000 and 7999 and  m.CompID Not between 10790 and 10799 and r.CodeID4 != 5002  THEN  p.Article2
		ELSE  p.Notes END) AS 'TAB1_A13', -- по заявке 7630 	
		/*LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), p.Notes))) AS 'TAB1_A13',*/
      rumq.RefName AS 'TAB1_A14',
      REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
			CAST(SUM(Qty) AS NUMERIC(21,6)) AS 'TAB1_A15',
			CASE m.CodeID2 WHEN 58 THEN CAST(d.PriceCC_wt AS NUMERIC(21,7)) ELSE CAST(d.PriceCC_nt AS NUMERIC(21,7)) END AS 'TAB1_A16',
			CASE WHEN m.CodeID2 != 58 THEN CAST(SUM(d.SumCC_nt) AS NUMERIC(21,2)) END AS 'TAB1_A10',
			CASE m.CodeID2 WHEN 58 THEN CAST(SUM(d.SumCC_wt) AS NUMERIC(21,2)) END AS 'TAB1_A19',
			
			Case When p.PGrID2 Between 0 and 401 or p.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end AS 'TAB1_A131',
			Case When p.ImpID = 1  THEN 1 end   AS 'TAB1_A132',
			Case When p.PGrID2 = 402 THEN pp.CstProdCode end AS 'TAB1_A133',

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
			Join r_Comps r WITH(NOLOCK) on m.CompID = r.CompID
------------------------------------------------------------------------
			WHERE m.ChID IN (@ChID)
------------------------------------------------------------------------
			GROUP BY Cast (d.SrcPosID as varchar(Max)), d.SrcPosID,m.CompID,d.ProdID, m.CodeID2, m.TaxDocDate, LTRIM(RTRIM(ISNULL(NULLIF(ec.ExtProdName,''), p.Notes))), pp.CstProdCode,
        rumq.RefName, rumq.RefID, d.PriceCC_nt, d.PriceCC_wt, pp.CstDocCode, pp.CstDocDate,	(case when  m.CodeID1 = 63  and m.CodeID2 IN (18,43, 44, 69) and m.CodeID3 = 4   
		and m.taxdocdate >= '20161201'and p.Article2 like '%&M%' and m.CompID Not between 7000 and 7999 and  m.CompID Not between 10790 and 10799 and r.CodeID4 != 5002  then  p.Article2
		ELSE p.Notes end),
		Case When p.PGrID2 Between 0 and 401 or p.PGrID2  Between 403 and 1000000 THEN pp.CstProdCode end, 
		Case When p.ImpID = 1  THEN 1 end,
		Case When p.PGrID2 = 402 THEN pp.CstProdCode end   
      
			INSERT @HeadTbl
			SELECT
			dbo.af_GetFiltered(ro.TaxCode) 'FIRM_INN',
			dbo.af_GetFiltered(ro.Code) 'FIRM_EDRPOU',
			dbo.af_GetFiltered(rc.TaxCode) 'N4',
			Case When c.CompClassID = 3 Then c.Job1 end as [DEPT_POK],
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
			JOIN dbo.at_r_OurMEDoc om WITH(NOLOCK) ON om.OurID = m.OurID AND m.TaxDocDate BETWEEN om.BDate AND om.EDate
			JOIN dbo.r_Emps re WITH(NOLOCK) ON re.EmpID = om.EmpID
			JOIN dbo.z_DocLinks z WITH(NOLOCK) ON z.ChildDocCode = 11012 AND z.ParentDocCode = 666028 AND z.ChildChID = m.ChID
			JOIN dbo.r_Comps c WITH(NOLOCK) ON m.CompID=c.CompID
			WHERE m.ChID =@ChID
			ORDER BY m.ChID

		
   
 

			INSERT @DetTbl
			SELECT 
			ROW_NUMBER() OVER(ORDER BY m.Subject) - 1 AS [SID],
			20 as [TAB1_A8],
			dbo.zf_DateToStr(m.DocDate) AS 'TAB1_A12',
			m.CompID AS 'TAB1_A20',
			LTRIM(RTRIM(m.Subject)) AS 'TAB1_A13',
			rumq.RefName AS 'TAB1_A14',
			REPLICATE(0, 4 - LEN(rumq.RefID)) + CAST(rumq.RefID AS VARCHAR) AS 'TAB1_A141',
			CAST(1 AS NUMERIC(21,6)) AS 'TAB1_A15',
			CAST(SUM(m.SumAC * m.KursCC)/1.2 AS NUMERIC(21,7)) AS 'TAB1_A16',
			CAST(SUM(m.SumAC * m.KursCC)/1.2 AS NUMERIC(21,2)) AS 'TAB1_A10',
			0 AS 'TAB1_A19',
			'' AS 'TAB1_A131', 
			'' AS 'TAB1_A132', 
			'' AS 'TAB1_A133', 
			ROUND(SUM(m.SumAC * m.KursCC)/6, 2) AS '_A6_7',
			0 AS '_A6_9',
			ROUND(SUM(m.SumAC * m.KursCC), 2) AS '_A7_7',
			0 AS '_A7_9'
			FROM dbo.av_c_PlanRec m WITH(NOLOCK)
			JOIN dbo.r_Uni rumq WITH(NOLOCK) ON rumq.RefTypeID = 80021 AND rumq.RefID = 2454
			WHERE m.AChID = @ChID
			GROUP BY m.DocDate, m.CompID, m.Subject, rumq.RefName, rumq.RefID

			
  
  DECLARE @STR VARCHAR(MAX) = (SELECT [OUT] =
  CAST((
  SELECT (SELECT 0 AS 'PERTYPE', 
      '01' + RIGHT([N11],8) AS 'PERDATE',
      'J1201009' AS 'CHARCODE',
      [N2_1] + '.' + CAST(@ChID AS VARCHAR(10)) 'DOCID'
      FROM @HeadTbl
    FOR XML PATH ('FIELDS'), TYPE
      ),
      (SELECT 
        (SELECT 0 '@TAB', 0 '@LINE', PName '@NAME', PVal 'VALUE'
        FROM @HeadTbl p
        UNPIVOT
          (PVal FOR PName IN
            (INN,FIRM_INN,FIRM_EDRPOU,N4,DEPT_POK,EDR_POK,FIRM_ADR,FIRM_NAME,FIRM_PHON,PHON,N13,N14,N10,N11,N2_1,N2_11,N3,N5,N6,N8,N81,N82,N9,A5_11,A5_7,A5_9,A6_11,A6_7,A7_11,A7_7,A7_9)
         ) AS unpvt
          FOR XML PATH ('ROW'), TYPE
        ),
        (SELECT 1 '@TAB', [SID] '@LINE', PName '@NAME', PVal 'VALUE'
        FROM @DetTbl p
        UNPIVOT
          (PVal FOR PName IN
            (TAB1_A8,TAB1_A12,TAB1_A20,TAB1_A13,TAB1_A14,TAB1_A141,TAB1_A15,TAB1_A16,TAB1_A10,TAB1_A19,TAB1_A131,TAB1_A132,TAB1_A133)
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

delete @tbl

WHILE LEN(@STR) > 0
BEGIN
	SET @LenSTR = CHARINDEX('</VALUE></ROW>', @STR) + len('</VALUE></ROW>') - 1;
	SET @PSTR = LEFT(@STR, @LenSTR)
	SET @STR = SUBSTRING(@STR, @LenSTR + 1, 16000000)

	INSERT @tbl (PStr)
	VALUES (@PSTR)
END


  SELECT * FROM @tbl ORDER BY ID




  
SET @xml  = ''
SELECT @xml
--SELECT @xml = @xml + case when @xml = '' then '' else ',' end + cast(PStr as nvarchar(max)) FROM @tbl ORDER BY ID
SELECT @xml = @xml +  PStr FROM @tbl ORDER BY ID
SELECT @xml

INSERT at_SendXML (ChID,DateCreate, xml)
select @ChId, GETDATE(),  @xml xml

--SELECT * FROM at_SendXML 

--DELETE FROM at_SendXML where chid in (200100854,200100697)


    
    FETCH NEXT FROM Cur INTO @ChID
   END 
   
   CLOSE Cur
   DEALLOCATE Cur
   
   IF @@TRANCOUNT>0 COMMIT

END



END

GO
