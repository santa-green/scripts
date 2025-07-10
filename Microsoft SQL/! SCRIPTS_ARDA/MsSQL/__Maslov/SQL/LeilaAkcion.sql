--INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=G:\Excels\LeiloAkcion23092019.xlsx;', 'SELECT * FROM [Лист1$]')
SELECT DISTINCT m.DiscCode 'Акция'
	  ,m.DiscName 'Имя акции'
	  ,m.BDate 'Начальная дата'
	  ,m.EDate 'Конечная  дата'
	  --,ardc.CompID 'Предприятие'
	  --,rc.CompName 'Имя предприятия'
	  ,arpmdp.ProdID 'Товар'
	  ,rp.ProdName 'Имя товара'
	  ,rp.PGrID1 'Группа 1'
	  ,REPLACE( CAST(arpmdp.Discount AS VARCHAR(50)),'.',',' ) 'Скидка, %'
	  ,REPLACE( CAST(prmp.PriceMC * (1.00 - arpmdp.Discount / 100.00)*27 AS VARCHAR(50)),'.',',' ) 'Цена со скидкой'
FROM [S-SQL-D4].[Elit].dbo.at_r_Discs m
JOIN [S-SQL-D4].[Elit].dbo.at_r_DiscComps ardc WITH(NOLOCK) ON ardc.DiscCode = m.DiscCode
JOIN [S-SQL-D4].[Elit].dbo.at_r_DiscPLMaps ardplm WITH(NOLOCK) ON ardplm.DiscCode = m.DiscCode
JOIN [S-SQL-D4].[Elit].dbo.at_r_DiscPls ardp WITH(NOLOCK) ON ardp.DiscPLID = m.DiscCode
JOIN [S-SQL-D4].[Elit].dbo.at_r_ProdMDP arpmdp WITH(NOLOCK) ON arpmdp.DiscPLID = ardplm.DiscPLID
--JOIN [S-SQL-D4].[Elit].dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = ardc.CompID
JOIN [S-SQL-D4].[Elit].dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = arpmdp.ProdID
JOIN [S-SQL-D4].[Elit].dbo.r_PLs rpl WITH(NOLOCK) ON (rpl.PLID=ardp.PLID)
JOIN [S-SQL-D4].[Elit].dbo.r_ProdMP prmp WITH(NOLOCK) ON (prmp.ProdID=rp.ProdID AND prmp.PLID=rpl.PLID)
WHERE m.StateCode = 181
      AND ardc.Active = 1
	  --AND m.DiscCode NOT IN (203,276,210,320,340,330,255,261)
	  AND m.DiscCode IN (210)
	  --AND m.DiscCode = 1670 AND ardc.CompID = 17758

/*
--ap_CalcReportForCamparyAll
SELECT * FROM z_Tables ORDER BY 3;
SELECT * FROM v_Reps WHERE RepID = 879

SELECT 'Справочник акций', at_r_Discs_1.DiscCode, at_r_Discs_1.DiscName, at_r_Discs_1.BDate, at_r_Discs_1.EDate, at_r_Discs_1.CompLFilter, at_r_Discs_1.StateCode, r_Comps_7.CompGrID1, r_Comps_7.CompGrID2, r_CompGrs2_11.CompGrName2 CompGrName2, r_Comps_7.CompGrID3, r_Comps_7.CompID, r_Comps_7.CompName, r_Prods_8.PGrID1, r_Prods_8.PGrID2, r_Prods_8.PGrID3, at_r_DiscComps_2.Active, 
r_Prods_8.ProdID, r_Prods_8.ProdName, r_PLs_5.PLID, r_PLs_5.PLName, at_r_DiscPls_4.DiscPLID, at_r_DiscPls_4.DiscPLName, 
at_r_ProdMDP_6.Discount, at_r_DiscPLMaps_3.PGrID1_B, at_r_DiscPLMaps_3.PGrID1_E, r_ProdMP_9.PriceMC, r_ProdMP_9.PriceMC * (1.00 - at_r_ProdMDP_6.Discount / 100.00) DiscPrice, dbo.afx_CorrectPriceForTax(r_ProdMP_9.PriceMC * (1.00 - at_r_ProdMDP_6.Discount / 100.00) * 30.00, 20.00) DiscPriceCC, r_ProdBG_10.PBGrID, r_ProdBG_10.PBGrName, 1.00 NIL
FROM at_r_Discs at_r_Discs_1 WITH(NOLOCK)
LEFT JOIN at_r_DiscComps at_r_DiscComps_2 WITH(NOLOCK) ON (at_r_DiscComps_2.DiscCode=at_r_Discs_1.DiscCode)
JOIN at_r_DiscPLMaps at_r_DiscPLMaps_3 WITH(NOLOCK) ON (at_r_DiscPLMaps_3.DiscCode=at_r_Discs_1.DiscCode)
JOIN at_r_DiscPls at_r_DiscPls_4 WITH(NOLOCK) ON (at_r_DiscPls_4.DiscPLID=at_r_DiscPLMaps_3.DiscPLID)
JOIN at_r_ProdMDP at_r_ProdMDP_6 WITH(NOLOCK) ON (at_r_ProdMDP_6.DiscPLID=at_r_DiscPls_4.DiscPLID)
JOIN r_PLs r_PLs_5 WITH(NOLOCK) ON (r_PLs_5.PLID=at_r_DiscPls_4.PLID)
JOIN r_Prods r_Prods_8 WITH(NOLOCK) ON (r_Prods_8.ProdID=at_r_ProdMDP_6.ProdID)
JOIN r_ProdBG r_ProdBG_10 WITH(NOLOCK) ON (r_ProdBG_10.PBGrID=r_Prods_8.PBGrID)
JOIN r_ProdMP r_ProdMP_9 WITH(NOLOCK) ON (r_ProdMP_9.ProdID=r_Prods_8.ProdID AND r_ProdMP_9.PLID=r_PLs_5.PLID)
LEFT JOIN r_Comps r_Comps_7 WITH(NOLOCK) ON (r_Comps_7.CompID=at_r_DiscComps_2.CompID)
JOIN r_CompGrs2 r_CompGrs2_11 WITH(NOLOCK) ON (r_CompGrs2_11.CompGrID2=r_Comps_7.CompGrID2)
  WHERE  (CAST('20200309' as smalldatetime) BETWEEN at_r_Discs_1.BDate AND at_r_Discs_1.EDate AND r_Prods_8.PGrID1 BETWEEN at_r_DiscPLMaps_3.PGrID1_B AND at_r_DiscPLMaps_3.PGrID1_E)

SELECT REPLACE('das.das','.',',')
*/