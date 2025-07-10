-->>> Приход - Приход товара:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Rec_1.OurID, r_Ours_91.OurName, t_Rec_1.StockID, r_Stocks_97.StockName StockName, r_Stocks_97.StockGID, r_StockGs_245.StockGName, t_Rec_1.CodeID1, r_Codes1_92.CodeName1, t_Rec_1.CodeID2, r_Codes2_93.CodeName2, t_Rec_1.CodeID3, r_Codes3_94.CodeName3, t_Rec_1.CodeID4, r_Codes4_95.CodeName4, t_Rec_1.CodeID5, r_Codes5_96.CodeName5, r_Prods_192.Country, r_Prods_192.PBGrID, r_ProdBG_198.PBGrName, r_Prods_192.PCatID, r_ProdC_193.PCatName, r_Prods_192.PGrID, r_ProdG_194.PGrName, r_Prods_192.PGrID1, r_ProdG1_195.PGrName1, r_Prods_192.PGrID2, r_ProdG2_196.PGrName2, r_Prods_192.PGrID3, r_ProdG3_197.PGrName3, r_Prods_192.PGrAID, r_ProdA_232.PGrAName, t_RecD_2.ProdID, r_Prods_192.ProdName, r_Prods_192.Notes, r_Prods_192.Article1, r_Prods_192.Article2, r_Prods_192.Article3, r_Prods_192.PGrID4, r_Prods_192.PGrID5, at_r_ProdG4_309.PGrName4, at_r_ProdG5_310.PGrName5, t_PInP_191.ProdBarCode ProdBarCode, '              Приход', SUM(t_RecD_2.Qty) SumQty, SUM(t_RecD_2.Qty * t_PInP_191.CostMC) CostSum
FROM av_t_Rec t_Rec_1 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_92 WITH(NOLOCK) ON (t_Rec_1.CodeID1=r_Codes1_92.CodeID1)
INNER JOIN r_Codes2 r_Codes2_93 WITH(NOLOCK) ON (t_Rec_1.CodeID2=r_Codes2_93.CodeID2)
INNER JOIN r_Codes3 r_Codes3_94 WITH(NOLOCK) ON (t_Rec_1.CodeID3=r_Codes3_94.CodeID3)
INNER JOIN r_Codes4 r_Codes4_95 WITH(NOLOCK) ON (t_Rec_1.CodeID4=r_Codes4_95.CodeID4)
INNER JOIN r_Codes5 r_Codes5_96 WITH(NOLOCK) ON (t_Rec_1.CodeID5=r_Codes5_96.CodeID5)
INNER JOIN r_Ours r_Ours_91 WITH(NOLOCK) ON (t_Rec_1.OurID=r_Ours_91.OurID)
INNER JOIN r_Stocks r_Stocks_97 WITH(NOLOCK) ON (t_Rec_1.StockID=r_Stocks_97.StockID)
INNER JOIN av_t_RecD t_RecD_2 WITH(NOLOCK) ON (t_Rec_1.ChID=t_RecD_2.ChID)
INNER JOIN r_StockGs r_StockGs_245 WITH(NOLOCK) ON (r_Stocks_97.StockGID=r_StockGs_245.StockGID)
INNER JOIN t_PInP t_PInP_191 WITH(NOLOCK) ON (t_RecD_2.PPID=t_PInP_191.PPID AND t_RecD_2.ProdID=t_PInP_191.ProdID)
INNER JOIN r_Prods r_Prods_192 WITH(NOLOCK) ON (t_PInP_191.ProdID=r_Prods_192.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_309 WITH(NOLOCK) ON (r_Prods_192.PGrID4=at_r_ProdG4_309.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_310 WITH(NOLOCK) ON (r_Prods_192.PGrID5=at_r_ProdG5_310.PGrID5)
INNER JOIN r_ProdA r_ProdA_232 WITH(NOLOCK) ON (r_Prods_192.PGrAID=r_ProdA_232.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_198 WITH(NOLOCK) ON (r_Prods_192.PBGrID=r_ProdBG_198.PBGrID)
INNER JOIN r_ProdC r_ProdC_193 WITH(NOLOCK) ON (r_Prods_192.PCatID=r_ProdC_193.PCatID)
INNER JOIN r_ProdG r_ProdG_194 WITH(NOLOCK) ON (r_Prods_192.PGrID=r_ProdG_194.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_195 WITH(NOLOCK) ON (r_Prods_192.PGrID1=r_ProdG1_195.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_196 WITH(NOLOCK) ON (r_Prods_192.PGrID2=r_ProdG2_196.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_197 WITH(NOLOCK) ON (r_Prods_192.PGrID3=r_ProdG3_197.PGrID3)
  WHERE 
  ((r_Prods_192.PGrID1 = 27) OR (r_Prods_192.PGrID1 = 28) OR (r_Prods_192.PGrID1 = 29) OR (r_Prods_192.PGrID1 = 63)) AND ((r_Prods_192.PCatID BETWEEN 1 AND 100)) AND ((t_Rec_1.StockID = 4) OR (t_Rec_1.StockID = 304)) AND (t_Rec_1.DocDate BETWEEN '20190501' AND '20190618')
  GROUP BY t_Rec_1.OurID, r_Ours_91.OurName, t_Rec_1.StockID, r_Stocks_97.StockName, r_Stocks_97.StockGID, r_StockGs_245.StockGName, t_Rec_1.CodeID1, r_Codes1_92.CodeName1, t_Rec_1.CodeID2, r_Codes2_93.CodeName2, t_Rec_1.CodeID3, r_Codes3_94.CodeName3, t_Rec_1.CodeID4, r_Codes4_95.CodeName4, t_Rec_1.CodeID5, r_Codes5_96.CodeName5, r_Prods_192.Country, r_Prods_192.PBGrID, r_ProdBG_198.PBGrName, r_Prods_192.PCatID, r_ProdC_193.PCatName, r_Prods_192.PGrID, r_ProdG_194.PGrName, r_Prods_192.PGrID1, r_ProdG1_195.PGrName1, r_Prods_192.PGrID2, r_ProdG2_196.PGrName2, r_Prods_192.PGrID3, r_ProdG3_197.PGrName3, r_Prods_192.PGrAID, r_ProdA_232.PGrAName, t_RecD_2.ProdID, r_Prods_192.ProdName, r_Prods_192.Notes, r_Prods_192.Article1, r_Prods_192.Article2, r_Prods_192.Article3, r_Prods_192.PGrID4, r_Prods_192.PGrID5, at_r_ProdG4_309.PGrName4, at_r_ProdG5_310.PGrName5, t_PInP_191.ProdBarCode,r_Prods_192.ProdID
  ORDER BY r_Prods_192.ProdID


-->>> Возврат от получателя - Возврат товара от получателя:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Ret_3.OurID, r_Ours_28.OurName, t_Ret_3.StockID, r_Stocks_34.StockName StockName, r_Stocks_34.StockGID, r_StockGs_236.StockGName, t_Ret_3.CodeID1, r_Codes1_29.CodeName1, t_Ret_3.CodeID2, r_Codes2_30.CodeName2, t_Ret_3.CodeID3, r_Codes3_31.CodeName3, t_Ret_3.CodeID4, r_Codes4_32.CodeName4, t_Ret_3.CodeID5, r_Codes5_33.CodeName5, r_Prods_120.Country, r_Prods_120.PBGrID, r_ProdBG_126.PBGrName, r_Prods_120.PCatID, r_ProdC_121.PCatName, r_Prods_120.PGrID, r_ProdG_122.PGrName, r_Prods_120.PGrID1, r_ProdG1_123.PGrName1, r_Prods_120.PGrID2, r_ProdG2_124.PGrName2, r_Prods_120.PGrID3, r_ProdG3_125.PGrName3, r_Prods_120.PGrAID, r_ProdA_223.PGrAName, t_RetD_4.ProdID, r_Prods_120.ProdName, r_Prods_120.Notes, r_Prods_120.Article1, r_Prods_120.Article2, r_Prods_120.Article3, r_Prods_120.PGrID4, r_Prods_120.PGrID5, at_r_ProdG4_289.PGrName4, at_r_ProdG5_290.PGrName5, t_PInP_119.ProdBarCode ProdBarCode, '             Возврат от получателя', SUM(t_RetD_4.Qty) SumQty, SUM(t_RetD_4.Qty * t_PInP_119.CostMC) CostSum FROM av_t_Ret t_Ret_3 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_29 WITH(NOLOCK) ON (t_Ret_3.CodeID1=r_Codes1_29.CodeID1)
INNER JOIN r_Codes2 r_Codes2_30 WITH(NOLOCK) ON (t_Ret_3.CodeID2=r_Codes2_30.CodeID2)
INNER JOIN r_Codes3 r_Codes3_31 WITH(NOLOCK) ON (t_Ret_3.CodeID3=r_Codes3_31.CodeID3)
INNER JOIN r_Codes4 r_Codes4_32 WITH(NOLOCK) ON (t_Ret_3.CodeID4=r_Codes4_32.CodeID4)
INNER JOIN r_Codes5 r_Codes5_33 WITH(NOLOCK) ON (t_Ret_3.CodeID5=r_Codes5_33.CodeID5)
INNER JOIN r_Ours r_Ours_28 WITH(NOLOCK) ON (t_Ret_3.OurID=r_Ours_28.OurID)
INNER JOIN r_Stocks r_Stocks_34 WITH(NOLOCK) ON (t_Ret_3.StockID=r_Stocks_34.StockID)
INNER JOIN av_t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID)
INNER JOIN r_StockGs r_StockGs_236 WITH(NOLOCK) ON (r_Stocks_34.StockGID=r_StockGs_236.StockGID)
INNER JOIN t_PInP t_PInP_119 WITH(NOLOCK) ON (t_RetD_4.PPID=t_PInP_119.PPID AND t_RetD_4.ProdID=t_PInP_119.ProdID)
INNER JOIN r_Prods r_Prods_120 WITH(NOLOCK) ON (t_PInP_119.ProdID=r_Prods_120.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_289 WITH(NOLOCK) ON (r_Prods_120.PGrID4=at_r_ProdG4_289.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_290 WITH(NOLOCK) ON (r_Prods_120.PGrID5=at_r_ProdG5_290.PGrID5)
INNER JOIN r_ProdA r_ProdA_223 WITH(NOLOCK) ON (r_Prods_120.PGrAID=r_ProdA_223.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_126 WITH(NOLOCK) ON (r_Prods_120.PBGrID=r_ProdBG_126.PBGrID)
INNER JOIN r_ProdC r_ProdC_121 WITH(NOLOCK) ON (r_Prods_120.PCatID=r_ProdC_121.PCatID)
INNER JOIN r_ProdG r_ProdG_122 WITH(NOLOCK) ON (r_Prods_120.PGrID=r_ProdG_122.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_123 WITH(NOLOCK) ON (r_Prods_120.PGrID1=r_ProdG1_123.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_124 WITH(NOLOCK) ON (r_Prods_120.PGrID2=r_ProdG2_124.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_125 WITH(NOLOCK) ON (r_Prods_120.PGrID3=r_ProdG3_125.PGrID3)
  WHERE  ((r_Prods_120.PGrID1 = 27) OR (r_Prods_120.PGrID1 = 28) OR (r_Prods_120.PGrID1 = 29) OR (r_Prods_120.PGrID1 = 63)) AND ((r_Prods_120.PCatID BETWEEN 1 AND 100)) AND ((t_Ret_3.StockID = 4) OR (t_Ret_3.StockID = 304)) AND (t_Ret_3.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Ret_3.OurID, r_Ours_28.OurName, t_Ret_3.StockID, r_Stocks_34.StockName, r_Stocks_34.StockGID, r_StockGs_236.StockGName, t_Ret_3.CodeID1, r_Codes1_29.CodeName1, t_Ret_3.CodeID2, r_Codes2_30.CodeName2, t_Ret_3.CodeID3, r_Codes3_31.CodeName3, t_Ret_3.CodeID4, r_Codes4_32.CodeName4, t_Ret_3.CodeID5, r_Codes5_33.CodeName5, r_Prods_120.Country, r_Prods_120.PBGrID, r_ProdBG_126.PBGrName, r_Prods_120.PCatID, r_ProdC_121.PCatName, r_Prods_120.PGrID, r_ProdG_122.PGrName, r_Prods_120.PGrID1, r_ProdG1_123.PGrName1, r_Prods_120.PGrID2, r_ProdG2_124.PGrName2, r_Prods_120.PGrID3, r_ProdG3_125.PGrName3, r_Prods_120.PGrAID, r_ProdA_223.PGrAName, t_RetD_4.ProdID, r_Prods_120.ProdName, r_Prods_120.Notes, r_Prods_120.Article1, r_Prods_120.Article2, r_Prods_120.Article3, r_Prods_120.PGrID4, r_Prods_120.PGrID5, at_r_ProdG4_289.PGrName4, at_r_ProdG5_290.PGrName5, t_PInP_119.ProdBarCode


-->>> Возврат по чеку - Возврат товара по чеку:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_CRRet_249.OurID, r_Ours_265.OurName, t_CRRet_249.StockID, r_Stocks_271.StockName StockName, r_Stocks_271.StockGID, r_StockGs_272.StockGName, t_CRRet_249.CodeID1, r_Codes1_266.CodeName1, t_CRRet_249.CodeID2, r_Codes2_267.CodeName2, t_CRRet_249.CodeID3, r_Codes3_268.CodeName3, t_CRRet_249.CodeID4, r_Codes4_269.CodeName4, t_CRRet_249.CodeID5, r_Codes5_270.CodeName5, r_Prods_257.Country, r_Prods_257.PBGrID, r_ProdBG_264.PBGrName, r_Prods_257.PCatID, r_ProdC_258.PCatName, r_Prods_257.PGrID, r_ProdG_259.PGrName, r_Prods_257.PGrID1, r_ProdG1_260.PGrName1, r_Prods_257.PGrID2, r_ProdG2_261.PGrName2, r_Prods_257.PGrID3, r_ProdG3_262.PGrName3, r_Prods_257.PGrAID, r_ProdA_263.PGrAName, r_Prods_257.ProdID, r_Prods_257.ProdName, r_Prods_257.Notes, r_Prods_257.Article1, r_Prods_257.Article2, r_Prods_257.Article3, r_Prods_257.PGrID4, r_Prods_257.PGrID5, at_r_ProdG4_291.PGrName4, at_r_ProdG5_292.PGrName5, t_PInP_255.ProdBarCode ProdBarCode, '            Возврат по чеку', SUM(t_CRRetD_250.Qty) SumQty, SUM(t_CRRetD_250.Qty * t_PInP_255.CostMC) CostSum FROM av_t_CRRet t_CRRet_249 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_266 WITH(NOLOCK) ON (t_CRRet_249.CodeID1=r_Codes1_266.CodeID1)
INNER JOIN r_Codes2 r_Codes2_267 WITH(NOLOCK) ON (t_CRRet_249.CodeID2=r_Codes2_267.CodeID2)
INNER JOIN r_Codes3 r_Codes3_268 WITH(NOLOCK) ON (t_CRRet_249.CodeID3=r_Codes3_268.CodeID3)
INNER JOIN r_Codes4 r_Codes4_269 WITH(NOLOCK) ON (t_CRRet_249.CodeID4=r_Codes4_269.CodeID4)
INNER JOIN r_Codes5 r_Codes5_270 WITH(NOLOCK) ON (t_CRRet_249.CodeID5=r_Codes5_270.CodeID5)
INNER JOIN r_Ours r_Ours_265 WITH(NOLOCK) ON (t_CRRet_249.OurID=r_Ours_265.OurID)
INNER JOIN r_Stocks r_Stocks_271 WITH(NOLOCK) ON (t_CRRet_249.StockID=r_Stocks_271.StockID)
INNER JOIN av_t_CRRetD t_CRRetD_250 WITH(NOLOCK) ON (t_CRRet_249.ChID=t_CRRetD_250.ChID)
INNER JOIN r_StockGs r_StockGs_272 WITH(NOLOCK) ON (r_Stocks_271.StockGID=r_StockGs_272.StockGID)
INNER JOIN t_PInP t_PInP_255 WITH(NOLOCK) ON (t_CRRetD_250.PPID=t_PInP_255.PPID AND t_CRRetD_250.ProdID=t_PInP_255.ProdID)
INNER JOIN r_Prods r_Prods_257 WITH(NOLOCK) ON (t_PInP_255.ProdID=r_Prods_257.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_291 WITH(NOLOCK) ON (r_Prods_257.PGrID4=at_r_ProdG4_291.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_292 WITH(NOLOCK) ON (r_Prods_257.PGrID5=at_r_ProdG5_292.PGrID5)
INNER JOIN r_ProdA r_ProdA_263 WITH(NOLOCK) ON (r_Prods_257.PGrAID=r_ProdA_263.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_264 WITH(NOLOCK) ON (r_Prods_257.PBGrID=r_ProdBG_264.PBGrID)
INNER JOIN r_ProdC r_ProdC_258 WITH(NOLOCK) ON (r_Prods_257.PCatID=r_ProdC_258.PCatID)
INNER JOIN r_ProdG r_ProdG_259 WITH(NOLOCK) ON (r_Prods_257.PGrID=r_ProdG_259.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_260 WITH(NOLOCK) ON (r_Prods_257.PGrID1=r_ProdG1_260.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_261 WITH(NOLOCK) ON (r_Prods_257.PGrID2=r_ProdG2_261.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_262 WITH(NOLOCK) ON (r_Prods_257.PGrID3=r_ProdG3_262.PGrID3)
  WHERE  ((r_Prods_257.PGrID1 = 27) OR (r_Prods_257.PGrID1 = 28) OR (r_Prods_257.PGrID1 = 29) OR (r_Prods_257.PGrID1 = 63)) AND ((r_Prods_257.PCatID BETWEEN 1 AND 100)) AND ((t_CRRet_249.StockID = 4) OR (t_CRRet_249.StockID = 304)) AND (t_CRRet_249.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_CRRet_249.OurID, r_Ours_265.OurName, t_CRRet_249.StockID, r_Stocks_271.StockName, r_Stocks_271.StockGID, r_StockGs_272.StockGName, t_CRRet_249.CodeID1, r_Codes1_266.CodeName1, t_CRRet_249.CodeID2, r_Codes2_267.CodeName2, t_CRRet_249.CodeID3, r_Codes3_268.CodeName3, t_CRRet_249.CodeID4, r_Codes4_269.CodeName4, t_CRRet_249.CodeID5, r_Codes5_270.CodeName5, r_Prods_257.Country, r_Prods_257.PBGrID, r_ProdBG_264.PBGrName, r_Prods_257.PCatID, r_ProdC_258.PCatName, r_Prods_257.PGrID, r_ProdG_259.PGrName, r_Prods_257.PGrID1, r_ProdG1_260.PGrName1, r_Prods_257.PGrID2, r_ProdG2_261.PGrName2, r_Prods_257.PGrID3, r_ProdG3_262.PGrName3, r_Prods_257.PGrAID, r_ProdA_263.PGrAName, r_Prods_257.ProdID, r_Prods_257.ProdName, r_Prods_257.Notes, r_Prods_257.Article1, r_Prods_257.Article2, r_Prods_257.Article3, r_Prods_257.PGrID4, r_Prods_257.PGrID5, at_r_ProdG4_291.PGrName4, at_r_ProdG5_292.PGrName5, t_PInP_255.ProdBarCode


-->>> Инвентаризация - Инвентаризация товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Ven_17.OurID, r_Ours_49.OurName, t_Ven_17.StockID, r_Stocks_55.StockName StockName, r_Stocks_55.StockGID, r_StockGs_239.StockGName, t_Ven_17.CodeID1, r_Codes1_50.CodeName1, t_Ven_17.CodeID2, r_Codes2_51.CodeName2, t_Ven_17.CodeID3, r_Codes3_52.CodeName3, t_Ven_17.CodeID4, r_Codes4_53.CodeName4, t_Ven_17.CodeID5, r_Codes5_54.CodeName5, r_Prods_144.Country, r_Prods_144.PBGrID, r_ProdBG_150.PBGrName, r_Prods_144.PCatID, r_ProdC_145.PCatName, r_Prods_144.PGrID, r_ProdG_146.PGrName, r_Prods_144.PGrID1, r_ProdG1_147.PGrName1, r_Prods_144.PGrID2, r_ProdG2_148.PGrName2, r_Prods_144.PGrID3, r_ProdG3_149.PGrName3, r_Prods_144.PGrAID, r_ProdA_226.PGrAName, t_VenA_18.ProdID, r_Prods_144.ProdName, r_Prods_144.Notes, r_Prods_144.Article1, r_Prods_144.Article2, r_Prods_144.Article3, r_Prods_144.PGrID4, r_Prods_144.PGrID5, at_r_ProdG4_297.PGrName4, at_r_ProdG5_298.PGrName5, t_PInP_143.ProdBarCode ProdBarCode, '           Инвентаризация', SUM(t_VenD_19.NewQty) SumQty, SUM(t_VenD_19.NewQty * t_PInP_143.CostMC) CostSum FROM av_t_Ven t_Ven_17 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_50 WITH(NOLOCK) ON (t_Ven_17.CodeID1=r_Codes1_50.CodeID1)
INNER JOIN r_Codes2 r_Codes2_51 WITH(NOLOCK) ON (t_Ven_17.CodeID2=r_Codes2_51.CodeID2)
INNER JOIN r_Codes3 r_Codes3_52 WITH(NOLOCK) ON (t_Ven_17.CodeID3=r_Codes3_52.CodeID3)
INNER JOIN r_Codes4 r_Codes4_53 WITH(NOLOCK) ON (t_Ven_17.CodeID4=r_Codes4_53.CodeID4)
INNER JOIN r_Codes5 r_Codes5_54 WITH(NOLOCK) ON (t_Ven_17.CodeID5=r_Codes5_54.CodeID5)
INNER JOIN r_Ours r_Ours_49 WITH(NOLOCK) ON (t_Ven_17.OurID=r_Ours_49.OurID)
INNER JOIN r_Stocks r_Stocks_55 WITH(NOLOCK) ON (t_Ven_17.StockID=r_Stocks_55.StockID)
INNER JOIN av_t_VenA t_VenA_18 WITH(NOLOCK) ON (t_Ven_17.ChID=t_VenA_18.ChID)
INNER JOIN r_StockGs r_StockGs_239 WITH(NOLOCK) ON (r_Stocks_55.StockGID=r_StockGs_239.StockGID)
INNER JOIN av_t_VenD t_VenD_19 WITH(NOLOCK) ON (t_VenA_18.ChID=t_VenD_19.ChID AND t_VenA_18.ProdID=t_VenD_19.DetProdID)
INNER JOIN t_PInP t_PInP_143 WITH(NOLOCK) ON (t_VenD_19.PPID=t_PInP_143.PPID AND t_VenD_19.DetProdID=t_PInP_143.ProdID)
INNER JOIN r_Prods r_Prods_144 WITH(NOLOCK) ON (t_PInP_143.ProdID=r_Prods_144.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_297 WITH(NOLOCK) ON (r_Prods_144.PGrID4=at_r_ProdG4_297.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_298 WITH(NOLOCK) ON (r_Prods_144.PGrID5=at_r_ProdG5_298.PGrID5)
INNER JOIN r_ProdA r_ProdA_226 WITH(NOLOCK) ON (r_Prods_144.PGrAID=r_ProdA_226.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_150 WITH(NOLOCK) ON (r_Prods_144.PBGrID=r_ProdBG_150.PBGrID)
INNER JOIN r_ProdC r_ProdC_145 WITH(NOLOCK) ON (r_Prods_144.PCatID=r_ProdC_145.PCatID)
INNER JOIN r_ProdG r_ProdG_146 WITH(NOLOCK) ON (r_Prods_144.PGrID=r_ProdG_146.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_147 WITH(NOLOCK) ON (r_Prods_144.PGrID1=r_ProdG1_147.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_148 WITH(NOLOCK) ON (r_Prods_144.PGrID2=r_ProdG2_148.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_149 WITH(NOLOCK) ON (r_Prods_144.PGrID3=r_ProdG3_149.PGrID3)
  WHERE  ((r_Prods_144.PGrID1 = 27) OR (r_Prods_144.PGrID1 = 28) OR (r_Prods_144.PGrID1 = 29) OR (r_Prods_144.PGrID1 = 63)) AND ((r_Prods_144.PCatID BETWEEN 1 AND 100)) AND ((t_Ven_17.StockID = 4) OR (t_Ven_17.StockID = 304)) AND (t_Ven_17.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Ven_17.OurID, r_Ours_49.OurName, t_Ven_17.StockID, r_Stocks_55.StockName, r_Stocks_55.StockGID, r_StockGs_239.StockGName, t_Ven_17.CodeID1, r_Codes1_50.CodeName1, t_Ven_17.CodeID2, r_Codes2_51.CodeName2, t_Ven_17.CodeID3, r_Codes3_52.CodeName3, t_Ven_17.CodeID4, r_Codes4_53.CodeName4, t_Ven_17.CodeID5, r_Codes5_54.CodeName5, r_Prods_144.Country, r_Prods_144.PBGrID, r_ProdBG_150.PBGrName, r_Prods_144.PCatID, r_ProdC_145.PCatName, r_Prods_144.PGrID, r_ProdG_146.PGrName, r_Prods_144.PGrID1, r_ProdG1_147.PGrName1, r_Prods_144.PGrID2, r_ProdG2_148.PGrName2, r_Prods_144.PGrID3, r_ProdG3_149.PGrName3, r_Prods_144.PGrAID, r_ProdA_226.PGrAName, t_VenA_18.ProdID, r_Prods_144.ProdName, r_Prods_144.Notes, r_Prods_144.Article1, r_Prods_144.Article2, r_Prods_144.Article3, r_Prods_144.PGrID4, r_Prods_144.PGrID5, at_r_ProdG4_297.PGrName4, at_r_ProdG5_298.PGrName5, t_PInP_143.ProdBarCode


-->>> Инвентаризация - Инвентаризация товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Ven_20.OurID, r_Ours_56.OurName, t_Ven_20.StockID, r_Stocks_62.StockName StockName, r_Stocks_62.StockGID, r_StockGs_240.StockGName, t_Ven_20.CodeID1, r_Codes1_57.CodeName1, t_Ven_20.CodeID2, r_Codes2_58.CodeName2, t_Ven_20.CodeID3, r_Codes3_59.CodeName3, t_Ven_20.CodeID4, r_Codes4_60.CodeName4, t_Ven_20.CodeID5, r_Codes5_61.CodeName5, r_Prods_152.Country, r_Prods_152.PBGrID, r_ProdBG_158.PBGrName, r_Prods_152.PCatID, r_ProdC_153.PCatName, r_Prods_152.PGrID, r_ProdG_154.PGrName, r_Prods_152.PGrID1, r_ProdG1_155.PGrName1, r_Prods_152.PGrID2, r_ProdG2_156.PGrName2, r_Prods_152.PGrID3, r_ProdG3_157.PGrName3, r_Prods_152.PGrAID, r_ProdA_227.PGrAName, t_VenA_21.ProdID, r_Prods_152.ProdName, r_Prods_152.Notes, r_Prods_152.Article1, r_Prods_152.Article2, r_Prods_152.Article3, r_Prods_152.PGrID4, r_Prods_152.PGrID5, at_r_ProdG4_299.PGrName4, at_r_ProdG5_300.PGrName5, t_PInP_151.ProdBarCode ProdBarCode, '           Инвентаризация', SUM(0-(t_VenD_22.Qty)) SumQty, SUM(0-(t_VenD_22.Qty * t_PInP_151.CostMC)) CostSum FROM av_t_Ven t_Ven_20 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_57 WITH(NOLOCK) ON (t_Ven_20.CodeID1=r_Codes1_57.CodeID1)
INNER JOIN r_Codes2 r_Codes2_58 WITH(NOLOCK) ON (t_Ven_20.CodeID2=r_Codes2_58.CodeID2)
INNER JOIN r_Codes3 r_Codes3_59 WITH(NOLOCK) ON (t_Ven_20.CodeID3=r_Codes3_59.CodeID3)
INNER JOIN r_Codes4 r_Codes4_60 WITH(NOLOCK) ON (t_Ven_20.CodeID4=r_Codes4_60.CodeID4)
INNER JOIN r_Codes5 r_Codes5_61 WITH(NOLOCK) ON (t_Ven_20.CodeID5=r_Codes5_61.CodeID5)
INNER JOIN r_Ours r_Ours_56 WITH(NOLOCK) ON (t_Ven_20.OurID=r_Ours_56.OurID)
INNER JOIN r_Stocks r_Stocks_62 WITH(NOLOCK) ON (t_Ven_20.StockID=r_Stocks_62.StockID)
INNER JOIN av_t_VenA t_VenA_21 WITH(NOLOCK) ON (t_Ven_20.ChID=t_VenA_21.ChID)
INNER JOIN r_StockGs r_StockGs_240 WITH(NOLOCK) ON (r_Stocks_62.StockGID=r_StockGs_240.StockGID)
INNER JOIN av_t_VenD t_VenD_22 WITH(NOLOCK) ON (t_VenA_21.ChID=t_VenD_22.ChID AND t_VenA_21.ProdID=t_VenD_22.DetProdID)
INNER JOIN t_PInP t_PInP_151 WITH(NOLOCK) ON (t_VenD_22.PPID=t_PInP_151.PPID AND t_VenD_22.DetProdID=t_PInP_151.ProdID)
INNER JOIN r_Prods r_Prods_152 WITH(NOLOCK) ON (t_PInP_151.ProdID=r_Prods_152.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_299 WITH(NOLOCK) ON (r_Prods_152.PGrID4=at_r_ProdG4_299.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_300 WITH(NOLOCK) ON (r_Prods_152.PGrID5=at_r_ProdG5_300.PGrID5)
INNER JOIN r_ProdA r_ProdA_227 WITH(NOLOCK) ON (r_Prods_152.PGrAID=r_ProdA_227.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_158 WITH(NOLOCK) ON (r_Prods_152.PBGrID=r_ProdBG_158.PBGrID)
INNER JOIN r_ProdC r_ProdC_153 WITH(NOLOCK) ON (r_Prods_152.PCatID=r_ProdC_153.PCatID)
INNER JOIN r_ProdG r_ProdG_154 WITH(NOLOCK) ON (r_Prods_152.PGrID=r_ProdG_154.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_155 WITH(NOLOCK) ON (r_Prods_152.PGrID1=r_ProdG1_155.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_156 WITH(NOLOCK) ON (r_Prods_152.PGrID2=r_ProdG2_156.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_157 WITH(NOLOCK) ON (r_Prods_152.PGrID3=r_ProdG3_157.PGrID3)
  WHERE  ((r_Prods_152.PGrID1 = 27) OR (r_Prods_152.PGrID1 = 28) OR (r_Prods_152.PGrID1 = 29) OR (r_Prods_152.PGrID1 = 63)) AND ((r_Prods_152.PCatID BETWEEN 1 AND 100)) AND ((t_Ven_20.StockID = 4) OR (t_Ven_20.StockID = 304)) AND (t_Ven_20.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Ven_20.OurID, r_Ours_56.OurName, t_Ven_20.StockID, r_Stocks_62.StockName, r_Stocks_62.StockGID, r_StockGs_240.StockGName, t_Ven_20.CodeID1, r_Codes1_57.CodeName1, t_Ven_20.CodeID2, r_Codes2_58.CodeName2, t_Ven_20.CodeID3, r_Codes3_59.CodeName3, t_Ven_20.CodeID4, r_Codes4_60.CodeName4, t_Ven_20.CodeID5, r_Codes5_61.CodeName5, r_Prods_152.Country, r_Prods_152.PBGrID, r_ProdBG_158.PBGrName, r_Prods_152.PCatID, r_ProdC_153.PCatName, r_Prods_152.PGrID, r_ProdG_154.PGrName, r_Prods_152.PGrID1, r_ProdG1_155.PGrName1, r_Prods_152.PGrID2, r_ProdG2_156.PGrName2, r_Prods_152.PGrID3, r_ProdG3_157.PGrName3, r_Prods_152.PGrAID, r_ProdA_227.PGrAName, t_VenA_21.ProdID, r_Prods_152.ProdName, r_Prods_152.Notes, r_Prods_152.Article1, r_Prods_152.Article2, r_Prods_152.Article3, r_Prods_152.PGrID4, r_Prods_152.PGrID5, at_r_ProdG4_299.PGrName4, at_r_ProdG5_300.PGrName5, t_PInP_151.ProdBarCode


-->>> Перемещение (на склад) - Перемещение товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Exc_13.OurID, r_Ours_63.OurName, t_Exc_13.NewStockID, r_Stocks_69.StockName StockName, r_Stocks_69.StockGID, r_StockGs_241.StockGName, t_Exc_13.CodeID1, r_Codes1_64.CodeName1, t_Exc_13.CodeID2, r_Codes2_65.CodeName2, t_Exc_13.CodeID3, r_Codes3_66.CodeName3, t_Exc_13.CodeID4, r_Codes4_67.CodeName4, t_Exc_13.CodeID5, r_Codes5_68.CodeName5, r_Prods_160.Country, r_Prods_160.PBGrID, r_ProdBG_166.PBGrName, r_Prods_160.PCatID, r_ProdC_161.PCatName, r_Prods_160.PGrID, r_ProdG_162.PGrName, r_Prods_160.PGrID1, r_ProdG1_163.PGrName1, r_Prods_160.PGrID2, r_ProdG2_164.PGrName2, r_Prods_160.PGrID3, r_ProdG3_165.PGrName3, r_Prods_160.PGrAID, r_ProdA_228.PGrAName, t_ExcD_14.ProdID, r_Prods_160.ProdName, r_Prods_160.Notes, r_Prods_160.Article1, r_Prods_160.Article2, r_Prods_160.Article3, r_Prods_160.PGrID4, r_Prods_160.PGrID5, at_r_ProdG4_301.PGrName4, at_r_ProdG5_302.PGrName5, t_PInP_159.ProdBarCode ProdBarCode, '          Перемещение (на склад)', SUM(t_ExcD_14.Qty) SumQty, SUM(t_ExcD_14.Qty * t_PInP_159.CostMC) CostSum FROM av_t_Exc t_Exc_13 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_64 WITH(NOLOCK) ON (t_Exc_13.CodeID1=r_Codes1_64.CodeID1)
INNER JOIN r_Codes2 r_Codes2_65 WITH(NOLOCK) ON (t_Exc_13.CodeID2=r_Codes2_65.CodeID2)
INNER JOIN r_Codes3 r_Codes3_66 WITH(NOLOCK) ON (t_Exc_13.CodeID3=r_Codes3_66.CodeID3)
INNER JOIN r_Codes4 r_Codes4_67 WITH(NOLOCK) ON (t_Exc_13.CodeID4=r_Codes4_67.CodeID4)
INNER JOIN r_Codes5 r_Codes5_68 WITH(NOLOCK) ON (t_Exc_13.CodeID5=r_Codes5_68.CodeID5)
INNER JOIN r_Ours r_Ours_63 WITH(NOLOCK) ON (t_Exc_13.OurID=r_Ours_63.OurID)
INNER JOIN r_Stocks r_Stocks_69 WITH(NOLOCK) ON (t_Exc_13.NewStockID=r_Stocks_69.StockID)
INNER JOIN av_t_ExcD t_ExcD_14 WITH(NOLOCK) ON (t_Exc_13.ChID=t_ExcD_14.ChID)
INNER JOIN r_StockGs r_StockGs_241 WITH(NOLOCK) ON (r_Stocks_69.StockGID=r_StockGs_241.StockGID)
INNER JOIN t_PInP t_PInP_159 WITH(NOLOCK) ON (t_ExcD_14.PPID=t_PInP_159.PPID AND t_ExcD_14.ProdID=t_PInP_159.ProdID)
INNER JOIN r_Prods r_Prods_160 WITH(NOLOCK) ON (t_PInP_159.ProdID=r_Prods_160.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_301 WITH(NOLOCK) ON (r_Prods_160.PGrID4=at_r_ProdG4_301.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_302 WITH(NOLOCK) ON (r_Prods_160.PGrID5=at_r_ProdG5_302.PGrID5)
INNER JOIN r_ProdA r_ProdA_228 WITH(NOLOCK) ON (r_Prods_160.PGrAID=r_ProdA_228.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_166 WITH(NOLOCK) ON (r_Prods_160.PBGrID=r_ProdBG_166.PBGrID)
INNER JOIN r_ProdC r_ProdC_161 WITH(NOLOCK) ON (r_Prods_160.PCatID=r_ProdC_161.PCatID)
INNER JOIN r_ProdG r_ProdG_162 WITH(NOLOCK) ON (r_Prods_160.PGrID=r_ProdG_162.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_163 WITH(NOLOCK) ON (r_Prods_160.PGrID1=r_ProdG1_163.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_164 WITH(NOLOCK) ON (r_Prods_160.PGrID2=r_ProdG2_164.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_165 WITH(NOLOCK) ON (r_Prods_160.PGrID3=r_ProdG3_165.PGrID3)
  WHERE  ((r_Prods_160.PGrID1 = 27) OR (r_Prods_160.PGrID1 = 28) OR (r_Prods_160.PGrID1 = 29) OR (r_Prods_160.PGrID1 = 63)) AND ((r_Prods_160.PCatID BETWEEN 1 AND 100)) AND ((t_Exc_13.NewStockID = 4) OR (t_Exc_13.NewStockID = 304)) AND (t_Exc_13.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Exc_13.OurID, r_Ours_63.OurName, t_Exc_13.NewStockID, r_Stocks_69.StockName, r_Stocks_69.StockGID, r_StockGs_241.StockGName, t_Exc_13.CodeID1, r_Codes1_64.CodeName1, t_Exc_13.CodeID2, r_Codes2_65.CodeName2, t_Exc_13.CodeID3, r_Codes3_66.CodeName3, t_Exc_13.CodeID4, r_Codes4_67.CodeName4, t_Exc_13.CodeID5, r_Codes5_68.CodeName5, r_Prods_160.Country, r_Prods_160.PBGrID, r_ProdBG_166.PBGrName, r_Prods_160.PCatID, r_ProdC_161.PCatName, r_Prods_160.PGrID, r_ProdG_162.PGrName, r_Prods_160.PGrID1, r_ProdG1_163.PGrName1, r_Prods_160.PGrID2, r_ProdG2_164.PGrName2, r_Prods_160.PGrID3, r_ProdG3_165.PGrName3, r_Prods_160.PGrAID, r_ProdA_228.PGrAName, t_ExcD_14.ProdID, r_Prods_160.ProdName, r_Prods_160.Notes, r_Prods_160.Article1, r_Prods_160.Article2, r_Prods_160.Article3, r_Prods_160.PGrID4, r_Prods_160.PGrID5, at_r_ProdG4_301.PGrName4, at_r_ProdG5_302.PGrName5, t_PInP_159.ProdBarCode


-->>> Переоценка ЦП - Переоценка цен прихода (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Est_23.OurID, r_Ours_77.OurName, t_Est_23.StockID, r_Stocks_83.StockName StockName, r_Stocks_83.StockGID, r_StockGs_243.StockGName, t_Est_23.CodeID1, r_Codes1_78.CodeName1, t_Est_23.CodeID2, r_Codes2_79.CodeName2, t_Est_23.CodeID3, r_Codes3_80.CodeName3, t_Est_23.CodeID4, r_Codes4_81.CodeName4, t_Est_23.CodeID5, r_Codes5_82.CodeName5, r_Prods_176.Country, r_Prods_176.PBGrID, r_ProdBG_182.PBGrName, r_Prods_176.PCatID, r_ProdC_177.PCatName, r_Prods_176.PGrID, r_ProdG_178.PGrName, r_Prods_176.PGrID1, r_ProdG1_179.PGrName1, r_Prods_176.PGrID2, r_ProdG2_180.PGrName2, r_Prods_176.PGrID3, r_ProdG3_181.PGrName3, r_Prods_176.PGrAID, r_ProdA_230.PGrAName, t_EstD_24.ProdID, r_Prods_176.ProdName, r_Prods_176.Notes, r_Prods_176.Article1, r_Prods_176.Article2, r_Prods_176.Article3, r_Prods_176.PGrID4, r_Prods_176.PGrID5, at_r_ProdG4_305.PGrName4, at_r_ProdG5_306.PGrName5, t_PInP_175.ProdBarCode ProdBarCode, '         Переоценка ЦП', SUM(t_EstD_24.Qty) SumQty, SUM(t_EstD_24.Qty * t_PInP_175.CostMC) CostSum FROM av_t_Est t_Est_23 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_78 WITH(NOLOCK) ON (t_Est_23.CodeID1=r_Codes1_78.CodeID1)
INNER JOIN r_Codes2 r_Codes2_79 WITH(NOLOCK) ON (t_Est_23.CodeID2=r_Codes2_79.CodeID2)
INNER JOIN r_Codes3 r_Codes3_80 WITH(NOLOCK) ON (t_Est_23.CodeID3=r_Codes3_80.CodeID3)
INNER JOIN r_Codes4 r_Codes4_81 WITH(NOLOCK) ON (t_Est_23.CodeID4=r_Codes4_81.CodeID4)
INNER JOIN r_Codes5 r_Codes5_82 WITH(NOLOCK) ON (t_Est_23.CodeID5=r_Codes5_82.CodeID5)
INNER JOIN r_Ours r_Ours_77 WITH(NOLOCK) ON (t_Est_23.OurID=r_Ours_77.OurID)
INNER JOIN r_Stocks r_Stocks_83 WITH(NOLOCK) ON (t_Est_23.StockID=r_Stocks_83.StockID)
INNER JOIN av_t_EstD t_EstD_24 WITH(NOLOCK) ON (t_Est_23.ChID=t_EstD_24.ChID)
INNER JOIN r_StockGs r_StockGs_243 WITH(NOLOCK) ON (r_Stocks_83.StockGID=r_StockGs_243.StockGID)
INNER JOIN t_PInP t_PInP_175 WITH(NOLOCK) ON (t_EstD_24.NewPPID=t_PInP_175.PPID AND t_EstD_24.ProdID=t_PInP_175.ProdID)
INNER JOIN r_Prods r_Prods_176 WITH(NOLOCK) ON (t_PInP_175.ProdID=r_Prods_176.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_305 WITH(NOLOCK) ON (r_Prods_176.PGrID4=at_r_ProdG4_305.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_306 WITH(NOLOCK) ON (r_Prods_176.PGrID5=at_r_ProdG5_306.PGrID5)
INNER JOIN r_ProdA r_ProdA_230 WITH(NOLOCK) ON (r_Prods_176.PGrAID=r_ProdA_230.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_182 WITH(NOLOCK) ON (r_Prods_176.PBGrID=r_ProdBG_182.PBGrID)
INNER JOIN r_ProdC r_ProdC_177 WITH(NOLOCK) ON (r_Prods_176.PCatID=r_ProdC_177.PCatID)
INNER JOIN r_ProdG r_ProdG_178 WITH(NOLOCK) ON (r_Prods_176.PGrID=r_ProdG_178.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_179 WITH(NOLOCK) ON (r_Prods_176.PGrID1=r_ProdG1_179.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_180 WITH(NOLOCK) ON (r_Prods_176.PGrID2=r_ProdG2_180.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_181 WITH(NOLOCK) ON (r_Prods_176.PGrID3=r_ProdG3_181.PGrID3)
  WHERE  ((r_Prods_176.PGrID1 = 27) OR (r_Prods_176.PGrID1 = 28) OR (r_Prods_176.PGrID1 = 29) OR (r_Prods_176.PGrID1 = 63)) AND ((r_Prods_176.PCatID BETWEEN 1 AND 100)) AND ((t_Est_23.StockID = 4) OR (t_Est_23.StockID = 304)) AND (t_Est_23.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Est_23.OurID, r_Ours_77.OurName, t_Est_23.StockID, r_Stocks_83.StockName, r_Stocks_83.StockGID, r_StockGs_243.StockGName, t_Est_23.CodeID1, r_Codes1_78.CodeName1, t_Est_23.CodeID2, r_Codes2_79.CodeName2, t_Est_23.CodeID3, r_Codes3_80.CodeName3, t_Est_23.CodeID4, r_Codes4_81.CodeName4, t_Est_23.CodeID5, r_Codes5_82.CodeName5, r_Prods_176.Country, r_Prods_176.PBGrID, r_ProdBG_182.PBGrName, r_Prods_176.PCatID, r_ProdC_177.PCatName, r_Prods_176.PGrID, r_ProdG_178.PGrName, r_Prods_176.PGrID1, r_ProdG1_179.PGrName1, r_Prods_176.PGrID2, r_ProdG2_180.PGrName2, r_Prods_176.PGrID3, r_ProdG3_181.PGrName3, r_Prods_176.PGrAID, r_ProdA_230.PGrAName, t_EstD_24.ProdID, r_Prods_176.ProdName, r_Prods_176.Notes, r_Prods_176.Article1, r_Prods_176.Article2, r_Prods_176.Article3, r_Prods_176.PGrID4, r_Prods_176.PGrID5, at_r_ProdG4_305.PGrName4, at_r_ProdG5_306.PGrName5, t_PInP_175.ProdBarCode


-->>> Переоценка ЦП - Переоценка цен прихода (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Est_25.OurID, r_Ours_84.OurName, t_Est_25.StockID, r_Stocks_90.StockName StockName, r_Stocks_90.StockGID, r_StockGs_244.StockGName, t_Est_25.CodeID1, r_Codes1_85.CodeName1, t_Est_25.CodeID2, r_Codes2_86.CodeName2, t_Est_25.CodeID3, r_Codes3_87.CodeName3, t_Est_25.CodeID4, r_Codes4_88.CodeName4, t_Est_25.CodeID5, r_Codes5_89.CodeName5, r_Prods_184.Country, r_Prods_184.PBGrID, r_ProdBG_190.PBGrName, r_Prods_184.PCatID, r_ProdC_185.PCatName, r_Prods_184.PGrID, r_ProdG_186.PGrName, r_Prods_184.PGrID1, r_ProdG1_187.PGrName1, r_Prods_184.PGrID2, r_ProdG2_188.PGrName2, r_Prods_184.PGrID3, r_ProdG3_189.PGrName3, r_Prods_184.PGrAID, r_ProdA_231.PGrAName, t_EstD_26.ProdID, r_Prods_184.ProdName, r_Prods_184.Notes, r_Prods_184.Article1, r_Prods_184.Article2, r_Prods_184.Article3, r_Prods_184.PGrID4, r_Prods_184.PGrID5, at_r_ProdG4_307.PGrName4, at_r_ProdG5_308.PGrName5, t_PInP_183.ProdBarCode ProdBarCode, '         Переоценка ЦП', SUM(0-(t_EstD_26.Qty)) SumQty, SUM(0-(t_EstD_26.Qty * t_PInP_183.CostMC)) CostSum FROM av_t_Est t_Est_25 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_85 WITH(NOLOCK) ON (t_Est_25.CodeID1=r_Codes1_85.CodeID1)
INNER JOIN r_Codes2 r_Codes2_86 WITH(NOLOCK) ON (t_Est_25.CodeID2=r_Codes2_86.CodeID2)
INNER JOIN r_Codes3 r_Codes3_87 WITH(NOLOCK) ON (t_Est_25.CodeID3=r_Codes3_87.CodeID3)
INNER JOIN r_Codes4 r_Codes4_88 WITH(NOLOCK) ON (t_Est_25.CodeID4=r_Codes4_88.CodeID4)
INNER JOIN r_Codes5 r_Codes5_89 WITH(NOLOCK) ON (t_Est_25.CodeID5=r_Codes5_89.CodeID5)
INNER JOIN r_Ours r_Ours_84 WITH(NOLOCK) ON (t_Est_25.OurID=r_Ours_84.OurID)
INNER JOIN r_Stocks r_Stocks_90 WITH(NOLOCK) ON (t_Est_25.StockID=r_Stocks_90.StockID)
INNER JOIN av_t_EstD t_EstD_26 WITH(NOLOCK) ON (t_Est_25.ChID=t_EstD_26.ChID)
INNER JOIN r_StockGs r_StockGs_244 WITH(NOLOCK) ON (r_Stocks_90.StockGID=r_StockGs_244.StockGID)
INNER JOIN t_PInP t_PInP_183 WITH(NOLOCK) ON (t_EstD_26.PPID=t_PInP_183.PPID AND t_EstD_26.ProdID=t_PInP_183.ProdID)
INNER JOIN r_Prods r_Prods_184 WITH(NOLOCK) ON (t_PInP_183.ProdID=r_Prods_184.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_307 WITH(NOLOCK) ON (r_Prods_184.PGrID4=at_r_ProdG4_307.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_308 WITH(NOLOCK) ON (r_Prods_184.PGrID5=at_r_ProdG5_308.PGrID5)
INNER JOIN r_ProdA r_ProdA_231 WITH(NOLOCK) ON (r_Prods_184.PGrAID=r_ProdA_231.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_190 WITH(NOLOCK) ON (r_Prods_184.PBGrID=r_ProdBG_190.PBGrID)
INNER JOIN r_ProdC r_ProdC_185 WITH(NOLOCK) ON (r_Prods_184.PCatID=r_ProdC_185.PCatID)
INNER JOIN r_ProdG r_ProdG_186 WITH(NOLOCK) ON (r_Prods_184.PGrID=r_ProdG_186.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_187 WITH(NOLOCK) ON (r_Prods_184.PGrID1=r_ProdG1_187.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_188 WITH(NOLOCK) ON (r_Prods_184.PGrID2=r_ProdG2_188.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_189 WITH(NOLOCK) ON (r_Prods_184.PGrID3=r_ProdG3_189.PGrID3)
  WHERE  ((r_Prods_184.PGrID1 = 27) OR (r_Prods_184.PGrID1 = 28) OR (r_Prods_184.PGrID1 = 29) OR (r_Prods_184.PGrID1 = 63)) AND ((r_Prods_184.PCatID BETWEEN 1 AND 100)) AND ((t_Est_25.StockID = 4) OR (t_Est_25.StockID = 304)) AND (t_Est_25.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Est_25.OurID, r_Ours_84.OurName, t_Est_25.StockID, r_Stocks_90.StockName, r_Stocks_90.StockGID, r_StockGs_244.StockGName, t_Est_25.CodeID1, r_Codes1_85.CodeName1, t_Est_25.CodeID2, r_Codes2_86.CodeName2, t_Est_25.CodeID3, r_Codes3_87.CodeName3, t_Est_25.CodeID4, r_Codes4_88.CodeName4, t_Est_25.CodeID5, r_Codes5_89.CodeName5, r_Prods_184.Country, r_Prods_184.PBGrID, r_ProdBG_190.PBGrName, r_Prods_184.PCatID, r_ProdC_185.PCatName, r_Prods_184.PGrID, r_ProdG_186.PGrName, r_Prods_184.PGrID1, r_ProdG1_187.PGrName1, r_Prods_184.PGrID2, r_ProdG2_188.PGrName2, r_Prods_184.PGrID3, r_ProdG3_189.PGrName3, r_Prods_184.PGrAID, r_ProdA_231.PGrAName, t_EstD_26.ProdID, r_Prods_184.ProdName, r_Prods_184.Notes, r_Prods_184.Article1, r_Prods_184.Article2, r_Prods_184.Article3, r_Prods_184.PGrID4, r_Prods_184.PGrID5, at_r_ProdG4_307.PGrName4, at_r_ProdG5_308.PGrName5, t_PInP_183.ProdBarCode


-->>> Возврат поставщику - Возврат товара поставщику:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_CRet_5.OurID, r_Ours_35.OurName, t_CRet_5.StockID, r_Stocks_41.StockName StockName, r_Stocks_41.StockGID, r_StockGs_237.StockGName, t_CRet_5.CodeID1, r_Codes1_36.CodeName1, t_CRet_5.CodeID2, r_Codes2_37.CodeName2, t_CRet_5.CodeID3, r_Codes3_38.CodeName3, t_CRet_5.CodeID4, r_Codes4_39.CodeName4, t_CRet_5.CodeID5, r_Codes5_40.CodeName5, r_Prods_128.Country, r_Prods_128.PBGrID, r_ProdBG_134.PBGrName, r_Prods_128.PCatID, r_ProdC_129.PCatName, r_Prods_128.PGrID, r_ProdG_130.PGrName, r_Prods_128.PGrID1, r_ProdG1_131.PGrName1, r_Prods_128.PGrID2, r_ProdG2_132.PGrName2, r_Prods_128.PGrID3, r_ProdG3_133.PGrName3, r_Prods_128.PGrAID, r_ProdA_224.PGrAName, t_CRetD_6.ProdID, r_Prods_128.ProdName, r_Prods_128.Notes, r_Prods_128.Article1, r_Prods_128.Article2, r_Prods_128.Article3, r_Prods_128.PGrID4, r_Prods_128.PGrID5, at_r_ProdG4_293.PGrName4, at_r_ProdG5_294.PGrName5, t_PInP_127.ProdBarCode ProdBarCode, '        Возврат поставщику', SUM(t_CRetD_6.Qty) SumQty, SUM(t_CRetD_6.Qty * t_PInP_127.CostMC) CostSum FROM av_t_CRet t_CRet_5 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_36 WITH(NOLOCK) ON (t_CRet_5.CodeID1=r_Codes1_36.CodeID1)
INNER JOIN r_Codes2 r_Codes2_37 WITH(NOLOCK) ON (t_CRet_5.CodeID2=r_Codes2_37.CodeID2)
INNER JOIN r_Codes3 r_Codes3_38 WITH(NOLOCK) ON (t_CRet_5.CodeID3=r_Codes3_38.CodeID3)
INNER JOIN r_Codes4 r_Codes4_39 WITH(NOLOCK) ON (t_CRet_5.CodeID4=r_Codes4_39.CodeID4)
INNER JOIN r_Codes5 r_Codes5_40 WITH(NOLOCK) ON (t_CRet_5.CodeID5=r_Codes5_40.CodeID5)
INNER JOIN r_Ours r_Ours_35 WITH(NOLOCK) ON (t_CRet_5.OurID=r_Ours_35.OurID)
INNER JOIN r_Stocks r_Stocks_41 WITH(NOLOCK) ON (t_CRet_5.StockID=r_Stocks_41.StockID)
INNER JOIN av_t_CRetD t_CRetD_6 WITH(NOLOCK) ON (t_CRet_5.ChID=t_CRetD_6.ChID)
INNER JOIN r_StockGs r_StockGs_237 WITH(NOLOCK) ON (r_Stocks_41.StockGID=r_StockGs_237.StockGID)
INNER JOIN t_PInP t_PInP_127 WITH(NOLOCK) ON (t_CRetD_6.PPID=t_PInP_127.PPID AND t_CRetD_6.ProdID=t_PInP_127.ProdID)
INNER JOIN r_Prods r_Prods_128 WITH(NOLOCK) ON (t_PInP_127.ProdID=r_Prods_128.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_293 WITH(NOLOCK) ON (r_Prods_128.PGrID4=at_r_ProdG4_293.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_294 WITH(NOLOCK) ON (r_Prods_128.PGrID5=at_r_ProdG5_294.PGrID5)
INNER JOIN r_ProdA r_ProdA_224 WITH(NOLOCK) ON (r_Prods_128.PGrAID=r_ProdA_224.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_134 WITH(NOLOCK) ON (r_Prods_128.PBGrID=r_ProdBG_134.PBGrID)
INNER JOIN r_ProdC r_ProdC_129 WITH(NOLOCK) ON (r_Prods_128.PCatID=r_ProdC_129.PCatID)
INNER JOIN r_ProdG r_ProdG_130 WITH(NOLOCK) ON (r_Prods_128.PGrID=r_ProdG_130.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_131 WITH(NOLOCK) ON (r_Prods_128.PGrID1=r_ProdG1_131.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_132 WITH(NOLOCK) ON (r_Prods_128.PGrID2=r_ProdG2_132.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_133 WITH(NOLOCK) ON (r_Prods_128.PGrID3=r_ProdG3_133.PGrID3)
  WHERE  ((r_Prods_128.PGrID1 = 27) OR (r_Prods_128.PGrID1 = 28) OR (r_Prods_128.PGrID1 = 29) OR (r_Prods_128.PGrID1 = 63)) AND ((r_Prods_128.PCatID BETWEEN 1 AND 100)) AND ((t_CRet_5.StockID = 4) OR (t_CRet_5.StockID = 304)) AND (t_CRet_5.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_CRet_5.OurID, r_Ours_35.OurName, t_CRet_5.StockID, r_Stocks_41.StockName, r_Stocks_41.StockGID, r_StockGs_237.StockGName, t_CRet_5.CodeID1, r_Codes1_36.CodeName1, t_CRet_5.CodeID2, r_Codes2_37.CodeName2, t_CRet_5.CodeID3, r_Codes3_38.CodeName3, t_CRet_5.CodeID4, r_Codes4_39.CodeName4, t_CRet_5.CodeID5, r_Codes5_40.CodeName5, r_Prods_128.Country, r_Prods_128.PBGrID, r_ProdBG_134.PBGrName, r_Prods_128.PCatID, r_ProdC_129.PCatName, r_Prods_128.PGrID, r_ProdG_130.PGrName, r_Prods_128.PGrID1, r_ProdG1_131.PGrName1, r_Prods_128.PGrID2, r_ProdG2_132.PGrName2, r_Prods_128.PGrID3, r_ProdG3_133.PGrName3, r_Prods_128.PGrAID, r_ProdA_224.PGrAName, t_CRetD_6.ProdID, r_Prods_128.ProdName, r_Prods_128.Notes, r_Prods_128.Article1, r_Prods_128.Article2, r_Prods_128.Article3, r_Prods_128.PGrID4, r_Prods_128.PGrID5, at_r_ProdG4_293.PGrName4, at_r_ProdG5_294.PGrName5, t_PInP_127.ProdBarCode


-->>> Накладные - Расходная накладная:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Inv_7.OurID, r_Ours_98.OurName, t_Inv_7.StockID, r_Stocks_104.StockName StockName, r_Stocks_104.StockGID, r_StockGs_246.StockGName, t_Inv_7.CodeID1, r_Codes1_99.CodeName1, t_Inv_7.CodeID2, r_Codes2_100.CodeName2, t_Inv_7.CodeID3, r_Codes3_101.CodeName3, t_Inv_7.CodeID4, r_Codes4_102.CodeName4, t_Inv_7.CodeID5, r_Codes5_103.CodeName5, r_Prods_200.Country, r_Prods_200.PBGrID, r_ProdBG_206.PBGrName, r_Prods_200.PCatID, r_ProdC_201.PCatName, r_Prods_200.PGrID, r_ProdG_202.PGrName, r_Prods_200.PGrID1, r_ProdG1_203.PGrName1, r_Prods_200.PGrID2, r_ProdG2_204.PGrName2, r_Prods_200.PGrID3, r_ProdG3_205.PGrName3, r_Prods_200.PGrAID, r_ProdA_233.PGrAName, t_InvD_8.ProdID, r_Prods_200.ProdName, r_Prods_200.Notes, r_Prods_200.Article1, r_Prods_200.Article2, r_Prods_200.Article3, r_Prods_200.PGrID4, r_Prods_200.PGrID5, at_r_ProdG4_313.PGrName4, at_r_ProdG5_314.PGrName5, t_PInP_199.ProdBarCode ProdBarCode, '       Накладные', SUM(t_InvD_8.Qty) SumQty, SUM(t_InvD_8.Qty * t_PInP_199.CostMC) CostSum FROM av_t_Inv t_Inv_7 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_99 WITH(NOLOCK) ON (t_Inv_7.CodeID1=r_Codes1_99.CodeID1)
INNER JOIN r_Codes2 r_Codes2_100 WITH(NOLOCK) ON (t_Inv_7.CodeID2=r_Codes2_100.CodeID2)
INNER JOIN r_Codes3 r_Codes3_101 WITH(NOLOCK) ON (t_Inv_7.CodeID3=r_Codes3_101.CodeID3)
INNER JOIN r_Codes4 r_Codes4_102 WITH(NOLOCK) ON (t_Inv_7.CodeID4=r_Codes4_102.CodeID4)
INNER JOIN r_Codes5 r_Codes5_103 WITH(NOLOCK) ON (t_Inv_7.CodeID5=r_Codes5_103.CodeID5)
INNER JOIN r_Ours r_Ours_98 WITH(NOLOCK) ON (t_Inv_7.OurID=r_Ours_98.OurID)
INNER JOIN r_Stocks r_Stocks_104 WITH(NOLOCK) ON (t_Inv_7.StockID=r_Stocks_104.StockID)
INNER JOIN av_t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID)
INNER JOIN r_StockGs r_StockGs_246 WITH(NOLOCK) ON (r_Stocks_104.StockGID=r_StockGs_246.StockGID)
INNER JOIN t_PInP t_PInP_199 WITH(NOLOCK) ON (t_InvD_8.PPID=t_PInP_199.PPID AND t_InvD_8.ProdID=t_PInP_199.ProdID)
INNER JOIN r_Prods r_Prods_200 WITH(NOLOCK) ON (t_PInP_199.ProdID=r_Prods_200.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_313 WITH(NOLOCK) ON (r_Prods_200.PGrID4=at_r_ProdG4_313.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_314 WITH(NOLOCK) ON (r_Prods_200.PGrID5=at_r_ProdG5_314.PGrID5)
INNER JOIN r_ProdA r_ProdA_233 WITH(NOLOCK) ON (r_Prods_200.PGrAID=r_ProdA_233.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_206 WITH(NOLOCK) ON (r_Prods_200.PBGrID=r_ProdBG_206.PBGrID)
INNER JOIN r_ProdC r_ProdC_201 WITH(NOLOCK) ON (r_Prods_200.PCatID=r_ProdC_201.PCatID)
INNER JOIN r_ProdG r_ProdG_202 WITH(NOLOCK) ON (r_Prods_200.PGrID=r_ProdG_202.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_203 WITH(NOLOCK) ON (r_Prods_200.PGrID1=r_ProdG1_203.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_204 WITH(NOLOCK) ON (r_Prods_200.PGrID2=r_ProdG2_204.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_205 WITH(NOLOCK) ON (r_Prods_200.PGrID3=r_ProdG3_205.PGrID3)
  WHERE  ((r_Prods_200.PGrID1 = 27) OR (r_Prods_200.PGrID1 = 28) OR (r_Prods_200.PGrID1 = 29) OR (r_Prods_200.PGrID1 = 63)) AND ((r_Prods_200.PCatID BETWEEN 1 AND 100)) AND ((t_Inv_7.StockID = 4) OR (t_Inv_7.StockID = 304)) AND (t_Inv_7.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Inv_7.OurID, r_Ours_98.OurName, t_Inv_7.StockID, r_Stocks_104.StockName, r_Stocks_104.StockGID, r_StockGs_246.StockGName, t_Inv_7.CodeID1, r_Codes1_99.CodeName1, t_Inv_7.CodeID2, r_Codes2_100.CodeName2, t_Inv_7.CodeID3, r_Codes3_101.CodeName3, t_Inv_7.CodeID4, r_Codes4_102.CodeName4, t_Inv_7.CodeID5, r_Codes5_103.CodeName5, r_Prods_200.Country, r_Prods_200.PBGrID, r_ProdBG_206.PBGrName, r_Prods_200.PCatID, r_ProdC_201.PCatName, r_Prods_200.PGrID, r_ProdG_202.PGrName, r_Prods_200.PGrID1, r_ProdG1_203.PGrName1, r_Prods_200.PGrID2, r_ProdG2_204.PGrName2, r_Prods_200.PGrID3, r_ProdG3_205.PGrName3, r_Prods_200.PGrAID, r_ProdA_233.PGrAName, t_InvD_8.ProdID, r_Prods_200.ProdName, r_Prods_200.Notes, r_Prods_200.Article1, r_Prods_200.Article2, r_Prods_200.Article3, r_Prods_200.PGrID4, r_Prods_200.PGrID5, at_r_ProdG4_313.PGrName4, at_r_ProdG5_314.PGrName5, t_PInP_199.ProdBarCode


-->>> Продажа товара - Продажа товара оператором:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Sale_251.OurID, r_Ours_287.OurName, t_Sale_251.StockID, r_Stocks_286.StockName StockName, r_Stocks_286.StockGID, r_StockGs_288.StockGName, t_Sale_251.CodeID1, r_Codes1_281.CodeName1, t_Sale_251.CodeID2, r_Codes2_282.CodeName2, t_Sale_251.CodeID3, r_Codes3_283.CodeName3, t_Sale_251.CodeID4, r_Codes4_284.CodeName4, t_Sale_251.CodeID5, r_Codes5_285.CodeName5, r_Prods_273.Country, r_Prods_273.PBGrID, r_ProdBG_280.PBGrName, r_Prods_273.PCatID, r_ProdC_274.PCatName, r_Prods_273.PGrID, r_ProdG_275.PGrName, r_Prods_273.PGrID1, r_ProdG1_276.PGrName1, r_Prods_273.PGrID2, r_ProdG2_277.PGrName2, r_Prods_273.PGrID3, r_ProdG3_278.PGrName3, r_Prods_273.PGrAID, r_ProdA_279.PGrAName, r_Prods_273.ProdID, r_Prods_273.ProdName, r_Prods_273.Notes, r_Prods_273.Article1, r_Prods_273.Article2, r_Prods_273.Article3, r_Prods_273.PGrID4, r_Prods_273.PGrID5, at_r_ProdG4_311.PGrName4, at_r_ProdG5_312.PGrName5, t_PInP_256.ProdBarCode ProdBarCode, '      Продажа товара', SUM(t_SaleD_252.Qty) SumQty, SUM(t_SaleD_252.Qty * t_PInP_256.CostMC) CostSum FROM av_t_Sale t_Sale_251 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_281 WITH(NOLOCK) ON (t_Sale_251.CodeID1=r_Codes1_281.CodeID1)
INNER JOIN r_Codes2 r_Codes2_282 WITH(NOLOCK) ON (t_Sale_251.CodeID2=r_Codes2_282.CodeID2)
INNER JOIN r_Codes3 r_Codes3_283 WITH(NOLOCK) ON (t_Sale_251.CodeID3=r_Codes3_283.CodeID3)
INNER JOIN r_Codes4 r_Codes4_284 WITH(NOLOCK) ON (t_Sale_251.CodeID4=r_Codes4_284.CodeID4)
INNER JOIN r_Codes5 r_Codes5_285 WITH(NOLOCK) ON (t_Sale_251.CodeID5=r_Codes5_285.CodeID5)
INNER JOIN r_Ours r_Ours_287 WITH(NOLOCK) ON (t_Sale_251.OurID=r_Ours_287.OurID)
INNER JOIN r_Stocks r_Stocks_286 WITH(NOLOCK) ON (t_Sale_251.StockID=r_Stocks_286.StockID)
INNER JOIN av_t_SaleD t_SaleD_252 WITH(NOLOCK) ON (t_Sale_251.ChID=t_SaleD_252.ChID)
INNER JOIN r_StockGs r_StockGs_288 WITH(NOLOCK) ON (r_Stocks_286.StockGID=r_StockGs_288.StockGID)
INNER JOIN t_PInP t_PInP_256 WITH(NOLOCK) ON (t_SaleD_252.PPID=t_PInP_256.PPID AND t_SaleD_252.ProdID=t_PInP_256.ProdID)
INNER JOIN r_Prods r_Prods_273 WITH(NOLOCK) ON (t_PInP_256.ProdID=r_Prods_273.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_311 WITH(NOLOCK) ON (r_Prods_273.PGrID4=at_r_ProdG4_311.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_312 WITH(NOLOCK) ON (r_Prods_273.PGrID5=at_r_ProdG5_312.PGrID5)
INNER JOIN r_ProdA r_ProdA_279 WITH(NOLOCK) ON (r_Prods_273.PGrAID=r_ProdA_279.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_280 WITH(NOLOCK) ON (r_Prods_273.PBGrID=r_ProdBG_280.PBGrID)
INNER JOIN r_ProdC r_ProdC_274 WITH(NOLOCK) ON (r_Prods_273.PCatID=r_ProdC_274.PCatID)
INNER JOIN r_ProdG r_ProdG_275 WITH(NOLOCK) ON (r_Prods_273.PGrID=r_ProdG_275.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_276 WITH(NOLOCK) ON (r_Prods_273.PGrID1=r_ProdG1_276.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_277 WITH(NOLOCK) ON (r_Prods_273.PGrID2=r_ProdG2_277.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_278 WITH(NOLOCK) ON (r_Prods_273.PGrID3=r_ProdG3_278.PGrID3)
  WHERE  ((r_Prods_273.PGrID1 = 27) OR (r_Prods_273.PGrID1 = 28) OR (r_Prods_273.PGrID1 = 29) OR (r_Prods_273.PGrID1 = 63)) AND ((r_Prods_273.PCatID BETWEEN 1 AND 100)) AND ((t_Sale_251.StockID = 4) OR (t_Sale_251.StockID = 304)) AND (t_Sale_251.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Sale_251.OurID, r_Ours_287.OurName, t_Sale_251.StockID, r_Stocks_286.StockName, r_Stocks_286.StockGID, r_StockGs_288.StockGName, t_Sale_251.CodeID1, r_Codes1_281.CodeName1, t_Sale_251.CodeID2, r_Codes2_282.CodeName2, t_Sale_251.CodeID3, r_Codes3_283.CodeName3, t_Sale_251.CodeID4, r_Codes4_284.CodeName4, t_Sale_251.CodeID5, r_Codes5_285.CodeName5, r_Prods_273.Country, r_Prods_273.PBGrID, r_ProdBG_280.PBGrName, r_Prods_273.PCatID, r_ProdC_274.PCatName, r_Prods_273.PGrID, r_ProdG_275.PGrName, r_Prods_273.PGrID1, r_ProdG1_276.PGrName1, r_Prods_273.PGrID2, r_ProdG2_277.PGrName2, r_Prods_273.PGrID3, r_ProdG3_278.PGrName3, r_Prods_273.PGrAID, r_ProdA_279.PGrAName, r_Prods_273.ProdID, r_Prods_273.ProdName, r_Prods_273.Notes, r_Prods_273.Article1, r_Prods_273.Article2, r_Prods_273.Article3, r_Prods_273.PGrID4, r_Prods_273.PGrID5, at_r_ProdG4_311.PGrName4, at_r_ProdG5_312.PGrName5, t_PInP_256.ProdBarCode


-->>> ВР - Расходный документ:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Exp_9.OurID, r_Ours_105.OurName, t_Exp_9.StockID, r_Stocks_111.StockName StockName, r_Stocks_111.StockGID, r_StockGs_247.StockGName, t_Exp_9.CodeID1, r_Codes1_106.CodeName1, t_Exp_9.CodeID2, r_Codes2_107.CodeName2, t_Exp_9.CodeID3, r_Codes3_108.CodeName3, t_Exp_9.CodeID4, r_Codes4_109.CodeName4, t_Exp_9.CodeID5, r_Codes5_110.CodeName5, r_Prods_208.Country, r_Prods_208.PBGrID, r_ProdBG_214.PBGrName, r_Prods_208.PCatID, r_ProdC_209.PCatName, r_Prods_208.PGrID, r_ProdG_210.PGrName, r_Prods_208.PGrID1, r_ProdG1_211.PGrName1, r_Prods_208.PGrID2, r_ProdG2_212.PGrName2, r_Prods_208.PGrID3, r_ProdG3_213.PGrName3, r_Prods_208.PGrAID, r_ProdA_234.PGrAName, t_ExpD_10.ProdID, r_Prods_208.ProdName, r_Prods_208.Notes, r_Prods_208.Article1, r_Prods_208.Article2, r_Prods_208.Article3, r_Prods_208.PGrID4, r_Prods_208.PGrID5, at_r_ProdG4_315.PGrName4, at_r_ProdG5_316.PGrName5, t_PInP_207.ProdBarCode ProdBarCode, '     ВР', SUM(t_ExpD_10.Qty) SumQty, SUM(t_ExpD_10.Qty * t_PInP_207.CostMC) CostSum FROM av_t_Exp t_Exp_9 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_106 WITH(NOLOCK) ON (t_Exp_9.CodeID1=r_Codes1_106.CodeID1)
INNER JOIN r_Codes2 r_Codes2_107 WITH(NOLOCK) ON (t_Exp_9.CodeID2=r_Codes2_107.CodeID2)
INNER JOIN r_Codes3 r_Codes3_108 WITH(NOLOCK) ON (t_Exp_9.CodeID3=r_Codes3_108.CodeID3)
INNER JOIN r_Codes4 r_Codes4_109 WITH(NOLOCK) ON (t_Exp_9.CodeID4=r_Codes4_109.CodeID4)
INNER JOIN r_Codes5 r_Codes5_110 WITH(NOLOCK) ON (t_Exp_9.CodeID5=r_Codes5_110.CodeID5)
INNER JOIN r_Ours r_Ours_105 WITH(NOLOCK) ON (t_Exp_9.OurID=r_Ours_105.OurID)
INNER JOIN r_Stocks r_Stocks_111 WITH(NOLOCK) ON (t_Exp_9.StockID=r_Stocks_111.StockID)
INNER JOIN av_t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID)
INNER JOIN r_StockGs r_StockGs_247 WITH(NOLOCK) ON (r_Stocks_111.StockGID=r_StockGs_247.StockGID)
INNER JOIN t_PInP t_PInP_207 WITH(NOLOCK) ON (t_ExpD_10.PPID=t_PInP_207.PPID AND t_ExpD_10.ProdID=t_PInP_207.ProdID)
INNER JOIN r_Prods r_Prods_208 WITH(NOLOCK) ON (t_PInP_207.ProdID=r_Prods_208.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_315 WITH(NOLOCK) ON (r_Prods_208.PGrID4=at_r_ProdG4_315.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_316 WITH(NOLOCK) ON (r_Prods_208.PGrID5=at_r_ProdG5_316.PGrID5)
INNER JOIN r_ProdA r_ProdA_234 WITH(NOLOCK) ON (r_Prods_208.PGrAID=r_ProdA_234.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_214 WITH(NOLOCK) ON (r_Prods_208.PBGrID=r_ProdBG_214.PBGrID)
INNER JOIN r_ProdC r_ProdC_209 WITH(NOLOCK) ON (r_Prods_208.PCatID=r_ProdC_209.PCatID)
INNER JOIN r_ProdG r_ProdG_210 WITH(NOLOCK) ON (r_Prods_208.PGrID=r_ProdG_210.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_211 WITH(NOLOCK) ON (r_Prods_208.PGrID1=r_ProdG1_211.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_212 WITH(NOLOCK) ON (r_Prods_208.PGrID2=r_ProdG2_212.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_213 WITH(NOLOCK) ON (r_Prods_208.PGrID3=r_ProdG3_213.PGrID3)
  WHERE  ((r_Prods_208.PGrID1 = 27) OR (r_Prods_208.PGrID1 = 28) OR (r_Prods_208.PGrID1 = 29) OR (r_Prods_208.PGrID1 = 63)) AND ((r_Prods_208.PCatID BETWEEN 1 AND 100)) AND ((t_Exp_9.StockID = 4) OR (t_Exp_9.StockID = 304)) AND (t_Exp_9.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Exp_9.OurID, r_Ours_105.OurName, t_Exp_9.StockID, r_Stocks_111.StockName, r_Stocks_111.StockGID, r_StockGs_247.StockGName, t_Exp_9.CodeID1, r_Codes1_106.CodeName1, t_Exp_9.CodeID2, r_Codes2_107.CodeName2, t_Exp_9.CodeID3, r_Codes3_108.CodeName3, t_Exp_9.CodeID4, r_Codes4_109.CodeName4, t_Exp_9.CodeID5, r_Codes5_110.CodeName5, r_Prods_208.Country, r_Prods_208.PBGrID, r_ProdBG_214.PBGrName, r_Prods_208.PCatID, r_ProdC_209.PCatName, r_Prods_208.PGrID, r_ProdG_210.PGrName, r_Prods_208.PGrID1, r_ProdG1_211.PGrName1, r_Prods_208.PGrID2, r_ProdG2_212.PGrName2, r_Prods_208.PGrID3, r_ProdG3_213.PGrName3, r_Prods_208.PGrAID, r_ProdA_234.PGrAName, t_ExpD_10.ProdID, r_Prods_208.ProdName, r_Prods_208.Notes, r_Prods_208.Article1, r_Prods_208.Article2, r_Prods_208.Article3, r_Prods_208.PGrID4, r_Prods_208.PGrID5, at_r_ProdG4_315.PGrName4, at_r_ProdG5_316.PGrName5, t_PInP_207.ProdBarCode


-->>> ВР в ЦП - Расходный документ в ценах прихода:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Epp_11.OurID, r_Ours_112.OurName, t_Epp_11.StockID, r_Stocks_118.StockName StockName, r_Stocks_118.StockGID, r_StockGs_248.StockGName, t_Epp_11.CodeID1, r_Codes1_113.CodeName1, t_Epp_11.CodeID2, r_Codes2_114.CodeName2, t_Epp_11.CodeID3, r_Codes3_115.CodeName3, t_Epp_11.CodeID4, r_Codes4_116.CodeName4, t_Epp_11.CodeID5, r_Codes5_117.CodeName5, r_Prods_216.Country, r_Prods_216.PBGrID, r_ProdBG_222.PBGrName, r_Prods_216.PCatID, r_ProdC_217.PCatName, r_Prods_216.PGrID, r_ProdG_218.PGrName, r_Prods_216.PGrID1, r_ProdG1_219.PGrName1, r_Prods_216.PGrID2, r_ProdG2_220.PGrName2, r_Prods_216.PGrID3, r_ProdG3_221.PGrName3, r_Prods_216.PGrAID, r_ProdA_235.PGrAName, t_EppD_12.ProdID, r_Prods_216.ProdName, r_Prods_216.Notes, r_Prods_216.Article1, r_Prods_216.Article2, r_Prods_216.Article3, r_Prods_216.PGrID4, r_Prods_216.PGrID5, at_r_ProdG4_317.PGrName4, at_r_ProdG5_318.PGrName5, t_PInP_215.ProdBarCode ProdBarCode, '    ВР в ЦП', SUM(t_EppD_12.Qty) SumQty, SUM(t_EppD_12.Qty * t_PInP_215.CostMC) CostSum FROM av_t_Epp t_Epp_11 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_113 WITH(NOLOCK) ON (t_Epp_11.CodeID1=r_Codes1_113.CodeID1)
INNER JOIN r_Codes2 r_Codes2_114 WITH(NOLOCK) ON (t_Epp_11.CodeID2=r_Codes2_114.CodeID2)
INNER JOIN r_Codes3 r_Codes3_115 WITH(NOLOCK) ON (t_Epp_11.CodeID3=r_Codes3_115.CodeID3)
INNER JOIN r_Codes4 r_Codes4_116 WITH(NOLOCK) ON (t_Epp_11.CodeID4=r_Codes4_116.CodeID4)
INNER JOIN r_Codes5 r_Codes5_117 WITH(NOLOCK) ON (t_Epp_11.CodeID5=r_Codes5_117.CodeID5)
INNER JOIN r_Ours r_Ours_112 WITH(NOLOCK) ON (t_Epp_11.OurID=r_Ours_112.OurID)
INNER JOIN r_Stocks r_Stocks_118 WITH(NOLOCK) ON (t_Epp_11.StockID=r_Stocks_118.StockID)
INNER JOIN av_t_EppD t_EppD_12 WITH(NOLOCK) ON (t_Epp_11.ChID=t_EppD_12.ChID)
INNER JOIN r_StockGs r_StockGs_248 WITH(NOLOCK) ON (r_Stocks_118.StockGID=r_StockGs_248.StockGID)
INNER JOIN t_PInP t_PInP_215 WITH(NOLOCK) ON (t_EppD_12.PPID=t_PInP_215.PPID AND t_EppD_12.ProdID=t_PInP_215.ProdID)
INNER JOIN r_Prods r_Prods_216 WITH(NOLOCK) ON (t_PInP_215.ProdID=r_Prods_216.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_317 WITH(NOLOCK) ON (r_Prods_216.PGrID4=at_r_ProdG4_317.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_318 WITH(NOLOCK) ON (r_Prods_216.PGrID5=at_r_ProdG5_318.PGrID5)
INNER JOIN r_ProdA r_ProdA_235 WITH(NOLOCK) ON (r_Prods_216.PGrAID=r_ProdA_235.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_222 WITH(NOLOCK) ON (r_Prods_216.PBGrID=r_ProdBG_222.PBGrID)
INNER JOIN r_ProdC r_ProdC_217 WITH(NOLOCK) ON (r_Prods_216.PCatID=r_ProdC_217.PCatID)
INNER JOIN r_ProdG r_ProdG_218 WITH(NOLOCK) ON (r_Prods_216.PGrID=r_ProdG_218.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_219 WITH(NOLOCK) ON (r_Prods_216.PGrID1=r_ProdG1_219.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_220 WITH(NOLOCK) ON (r_Prods_216.PGrID2=r_ProdG2_220.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_221 WITH(NOLOCK) ON (r_Prods_216.PGrID3=r_ProdG3_221.PGrID3)
  WHERE  ((r_Prods_216.PGrID1 = 27) OR (r_Prods_216.PGrID1 = 28) OR (r_Prods_216.PGrID1 = 29) OR (r_Prods_216.PGrID1 = 63)) AND ((r_Prods_216.PCatID BETWEEN 1 AND 100)) AND ((t_Epp_11.StockID = 4) OR (t_Epp_11.StockID = 304)) AND (t_Epp_11.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Epp_11.OurID, r_Ours_112.OurName, t_Epp_11.StockID, r_Stocks_118.StockName, r_Stocks_118.StockGID, r_StockGs_248.StockGName, t_Epp_11.CodeID1, r_Codes1_113.CodeName1, t_Epp_11.CodeID2, r_Codes2_114.CodeName2, t_Epp_11.CodeID3, r_Codes3_115.CodeName3, t_Epp_11.CodeID4, r_Codes4_116.CodeName4, t_Epp_11.CodeID5, r_Codes5_117.CodeName5, r_Prods_216.Country, r_Prods_216.PBGrID, r_ProdBG_222.PBGrName, r_Prods_216.PCatID, r_ProdC_217.PCatName, r_Prods_216.PGrID, r_ProdG_218.PGrName, r_Prods_216.PGrID1, r_ProdG1_219.PGrName1, r_Prods_216.PGrID2, r_ProdG2_220.PGrName2, r_Prods_216.PGrID3, r_ProdG3_221.PGrName3, r_Prods_216.PGrAID, r_ProdA_235.PGrAName, t_EppD_12.ProdID, r_Prods_216.ProdName, r_Prods_216.Notes, r_Prods_216.Article1, r_Prods_216.Article2, r_Prods_216.Article3, r_Prods_216.PGrID4, r_Prods_216.PGrID5, at_r_ProdG4_317.PGrName4, at_r_ProdG5_318.PGrName5, t_PInP_215.ProdBarCode


-->>> Перемещение (со склада) - Перемещение товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_Exc_15.OurID, r_Ours_70.OurName, t_Exc_15.StockID, r_Stocks_76.StockName StockName, r_Stocks_76.StockGID, r_StockGs_242.StockGName, t_Exc_15.CodeID1, r_Codes1_71.CodeName1, t_Exc_15.CodeID2, r_Codes2_72.CodeName2, t_Exc_15.CodeID3, r_Codes3_73.CodeName3, t_Exc_15.CodeID4, r_Codes4_74.CodeName4, t_Exc_15.CodeID5, r_Codes5_75.CodeName5, r_Prods_168.Country, r_Prods_168.PBGrID, r_ProdBG_174.PBGrName, r_Prods_168.PCatID, r_ProdC_169.PCatName, r_Prods_168.PGrID, r_ProdG_170.PGrName, r_Prods_168.PGrID1, r_ProdG1_171.PGrName1, r_Prods_168.PGrID2, r_ProdG2_172.PGrName2, r_Prods_168.PGrID3, r_ProdG3_173.PGrName3, r_Prods_168.PGrAID, r_ProdA_229.PGrAName, t_ExcD_16.ProdID, r_Prods_168.ProdName, r_Prods_168.Notes, r_Prods_168.Article1, r_Prods_168.Article2, r_Prods_168.Article3, r_Prods_168.PGrID4, r_Prods_168.PGrID5, at_r_ProdG4_303.PGrName4, at_r_ProdG5_304.PGrName5, t_PInP_167.ProdBarCode ProdBarCode, '   Перемещение (со склада)', SUM(t_ExcD_16.Qty) SumQty, SUM(t_ExcD_16.Qty * t_PInP_167.CostMC) CostSum FROM av_t_Exc t_Exc_15 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_71 WITH(NOLOCK) ON (t_Exc_15.CodeID1=r_Codes1_71.CodeID1)
INNER JOIN r_Codes2 r_Codes2_72 WITH(NOLOCK) ON (t_Exc_15.CodeID2=r_Codes2_72.CodeID2)
INNER JOIN r_Codes3 r_Codes3_73 WITH(NOLOCK) ON (t_Exc_15.CodeID3=r_Codes3_73.CodeID3)
INNER JOIN r_Codes4 r_Codes4_74 WITH(NOLOCK) ON (t_Exc_15.CodeID4=r_Codes4_74.CodeID4)
INNER JOIN r_Codes5 r_Codes5_75 WITH(NOLOCK) ON (t_Exc_15.CodeID5=r_Codes5_75.CodeID5)
INNER JOIN r_Ours r_Ours_70 WITH(NOLOCK) ON (t_Exc_15.OurID=r_Ours_70.OurID)
INNER JOIN r_Stocks r_Stocks_76 WITH(NOLOCK) ON (t_Exc_15.StockID=r_Stocks_76.StockID)
INNER JOIN av_t_ExcD t_ExcD_16 WITH(NOLOCK) ON (t_Exc_15.ChID=t_ExcD_16.ChID)
INNER JOIN r_StockGs r_StockGs_242 WITH(NOLOCK) ON (r_Stocks_76.StockGID=r_StockGs_242.StockGID)
INNER JOIN t_PInP t_PInP_167 WITH(NOLOCK) ON (t_ExcD_16.PPID=t_PInP_167.PPID AND t_ExcD_16.ProdID=t_PInP_167.ProdID)
INNER JOIN r_Prods r_Prods_168 WITH(NOLOCK) ON (t_PInP_167.ProdID=r_Prods_168.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_303 WITH(NOLOCK) ON (r_Prods_168.PGrID4=at_r_ProdG4_303.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_304 WITH(NOLOCK) ON (r_Prods_168.PGrID5=at_r_ProdG5_304.PGrID5)
INNER JOIN r_ProdA r_ProdA_229 WITH(NOLOCK) ON (r_Prods_168.PGrAID=r_ProdA_229.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_174 WITH(NOLOCK) ON (r_Prods_168.PBGrID=r_ProdBG_174.PBGrID)
INNER JOIN r_ProdC r_ProdC_169 WITH(NOLOCK) ON (r_Prods_168.PCatID=r_ProdC_169.PCatID)
INNER JOIN r_ProdG r_ProdG_170 WITH(NOLOCK) ON (r_Prods_168.PGrID=r_ProdG_170.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_171 WITH(NOLOCK) ON (r_Prods_168.PGrID1=r_ProdG1_171.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_172 WITH(NOLOCK) ON (r_Prods_168.PGrID2=r_ProdG2_172.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_173 WITH(NOLOCK) ON (r_Prods_168.PGrID3=r_ProdG3_173.PGrID3)
  WHERE  ((r_Prods_168.PGrID1 = 27) OR (r_Prods_168.PGrID1 = 28) OR (r_Prods_168.PGrID1 = 29) OR (r_Prods_168.PGrID1 = 63)) AND ((r_Prods_168.PCatID BETWEEN 1 AND 100)) AND ((t_Exc_15.StockID = 4) OR (t_Exc_15.StockID = 304)) AND (t_Exc_15.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_Exc_15.OurID, r_Ours_70.OurName, t_Exc_15.StockID, r_Stocks_76.StockName, r_Stocks_76.StockGID, r_StockGs_242.StockGName, t_Exc_15.CodeID1, r_Codes1_71.CodeName1, t_Exc_15.CodeID2, r_Codes2_72.CodeName2, t_Exc_15.CodeID3, r_Codes3_73.CodeName3, t_Exc_15.CodeID4, r_Codes4_74.CodeName4, t_Exc_15.CodeID5, r_Codes5_75.CodeName5, r_Prods_168.Country, r_Prods_168.PBGrID, r_ProdBG_174.PBGrName, r_Prods_168.PCatID, r_ProdC_169.PCatName, r_Prods_168.PGrID, r_ProdG_170.PGrName, r_Prods_168.PGrID1, r_ProdG1_171.PGrName1, r_Prods_168.PGrID2, r_ProdG2_172.PGrName2, r_Prods_168.PGrID3, r_ProdG3_173.PGrName3, r_Prods_168.PGrAID, r_ProdA_229.PGrAName, t_ExcD_16.ProdID, r_Prods_168.ProdName, r_Prods_168.Notes, r_Prods_168.Article1, r_Prods_168.Article2, r_Prods_168.Article3, r_Prods_168.PGrID4, r_Prods_168.PGrID5, at_r_ProdG4_303.PGrName4, at_r_ProdG5_304.PGrName5, t_PInP_167.ProdBarCode


-->>> Комплектация товара - Комплектация товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_SRec_319.OurID, r_Ours_324.OurName, t_SRec_319.StockID, r_Stocks_330.StockName StockName, r_Stocks_330.StockGID, r_StockGs_331.StockGName, t_SRec_319.CodeID1, r_Codes1_325.CodeName1, t_SRec_319.CodeID2, r_Codes2_326.CodeName2, t_SRec_319.CodeID3, r_Codes3_327.CodeName3, t_SRec_319.CodeID4, r_Codes4_328.CodeName4, t_SRec_319.CodeID5, r_Codes5_329.CodeName5, r_Prods_333.Country, r_Prods_333.PBGrID, r_ProdBG_336.PBGrName, r_Prods_333.PCatID, r_ProdC_337.PCatName, r_Prods_333.PGrID, r_ProdG_334.PGrName, r_Prods_333.PGrID1, r_ProdG1_338.PGrName1, r_Prods_333.PGrID2, r_ProdG2_339.PGrName2, r_Prods_333.PGrID3, r_ProdG3_340.PGrName3, r_Prods_333.PGrAID, r_ProdA_335.PGrAName, t_SRecA_323.ProdID, r_Prods_333.ProdName, r_Prods_333.Notes, r_Prods_333.Article1, r_Prods_333.Article2, r_Prods_333.Article3, r_Prods_333.PGrID4, r_Prods_333.PGrID5, at_r_ProdG4_341.PGrName4, at_r_ProdG5_342.PGrName5, t_PInP_332.ProdBarCode ProdBarCode, '  Комплектация товара', SUM(t_SRecA_323.Qty) SumQty, SUM(t_SRecA_323.Qty * t_PInP_332.CostMC) CostSum FROM av_t_SRec t_SRec_319 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_325 WITH(NOLOCK) ON (t_SRec_319.CodeID1=r_Codes1_325.CodeID1)
INNER JOIN r_Codes2 r_Codes2_326 WITH(NOLOCK) ON (t_SRec_319.CodeID2=r_Codes2_326.CodeID2)
INNER JOIN r_Codes3 r_Codes3_327 WITH(NOLOCK) ON (t_SRec_319.CodeID3=r_Codes3_327.CodeID3)
INNER JOIN r_Codes4 r_Codes4_328 WITH(NOLOCK) ON (t_SRec_319.CodeID4=r_Codes4_328.CodeID4)
INNER JOIN r_Codes5 r_Codes5_329 WITH(NOLOCK) ON (t_SRec_319.CodeID5=r_Codes5_329.CodeID5)
INNER JOIN r_Ours r_Ours_324 WITH(NOLOCK) ON (t_SRec_319.OurID=r_Ours_324.OurID)
INNER JOIN r_Stocks r_Stocks_330 WITH(NOLOCK) ON (t_SRec_319.StockID=r_Stocks_330.StockID)
INNER JOIN av_t_SRecA t_SRecA_323 WITH(NOLOCK) ON (t_SRec_319.ChID=t_SRecA_323.ChID)
INNER JOIN r_StockGs r_StockGs_331 WITH(NOLOCK) ON (r_Stocks_330.StockGID=r_StockGs_331.StockGID)
INNER JOIN t_PInP t_PInP_332 WITH(NOLOCK) ON (t_SRecA_323.PPID=t_PInP_332.PPID AND t_SRecA_323.ProdID=t_PInP_332.ProdID)
INNER JOIN r_Prods r_Prods_333 WITH(NOLOCK) ON (t_PInP_332.ProdID=r_Prods_333.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_341 WITH(NOLOCK) ON (r_Prods_333.PGrID4=at_r_ProdG4_341.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_342 WITH(NOLOCK) ON (r_Prods_333.PGrID5=at_r_ProdG5_342.PGrID5)
INNER JOIN r_ProdA r_ProdA_335 WITH(NOLOCK) ON (r_Prods_333.PGrAID=r_ProdA_335.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_336 WITH(NOLOCK) ON (r_Prods_333.PBGrID=r_ProdBG_336.PBGrID)
INNER JOIN r_ProdC r_ProdC_337 WITH(NOLOCK) ON (r_Prods_333.PCatID=r_ProdC_337.PCatID)
INNER JOIN r_ProdG r_ProdG_334 WITH(NOLOCK) ON (r_Prods_333.PGrID=r_ProdG_334.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_338 WITH(NOLOCK) ON (r_Prods_333.PGrID1=r_ProdG1_338.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_339 WITH(NOLOCK) ON (r_Prods_333.PGrID2=r_ProdG2_339.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_340 WITH(NOLOCK) ON (r_Prods_333.PGrID3=r_ProdG3_340.PGrID3)
  WHERE  ((r_Prods_333.PGrID1 = 27) OR (r_Prods_333.PGrID1 = 28) OR (r_Prods_333.PGrID1 = 29) OR (r_Prods_333.PGrID1 = 63)) AND ((r_Prods_333.PCatID BETWEEN 1 AND 100)) AND ((t_SRec_319.StockID = 4) OR (t_SRec_319.StockID = 304)) AND (t_SRec_319.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_SRec_319.OurID, r_Ours_324.OurName, t_SRec_319.StockID, r_Stocks_330.StockName, r_Stocks_330.StockGID, r_StockGs_331.StockGName, t_SRec_319.CodeID1, r_Codes1_325.CodeName1, t_SRec_319.CodeID2, r_Codes2_326.CodeName2, t_SRec_319.CodeID3, r_Codes3_327.CodeName3, t_SRec_319.CodeID4, r_Codes4_328.CodeName4, t_SRec_319.CodeID5, r_Codes5_329.CodeName5, r_Prods_333.Country, r_Prods_333.PBGrID, r_ProdBG_336.PBGrName, r_Prods_333.PCatID, r_ProdC_337.PCatName, r_Prods_333.PGrID, r_ProdG_334.PGrName, r_Prods_333.PGrID1, r_ProdG1_338.PGrName1, r_Prods_333.PGrID2, r_ProdG2_339.PGrName2, r_Prods_333.PGrID3, r_ProdG3_340.PGrName3, r_Prods_333.PGrAID, r_ProdA_335.PGrAName, t_SRecA_323.ProdID, r_Prods_333.ProdName, r_Prods_333.Notes, r_Prods_333.Article1, r_Prods_333.Article2, r_Prods_333.Article3, r_Prods_333.PGrID4, r_Prods_333.PGrID5, at_r_ProdG4_341.PGrName4, at_r_ProdG5_342.PGrName5, t_PInP_332.ProdBarCode


-->>> Комплектация товара - Комплектация товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_SRec_320.OurID, r_Ours_344.OurName, t_SRec_320.StockID, r_Stocks_350.StockName StockName, r_Stocks_350.StockGID, r_StockGs_351.StockGName, t_SRec_320.CodeID1, r_Codes1_345.CodeName1, t_SRec_320.CodeID2, r_Codes2_346.CodeName2, t_SRec_320.CodeID3, r_Codes3_347.CodeName3, t_SRec_320.CodeID4, r_Codes4_348.CodeName4, t_SRec_320.CodeID5, r_Codes5_349.CodeName5, r_Prods_354.Country, r_Prods_354.PBGrID, r_ProdBG_357.PBGrName, r_Prods_354.PCatID, r_ProdC_358.PCatName, r_Prods_354.PGrID, r_ProdG_355.PGrName, r_Prods_354.PGrID1, r_ProdG1_359.PGrName1, r_Prods_354.PGrID2, r_ProdG2_360.PGrName2, r_Prods_354.PGrID3, r_ProdG3_361.PGrName3, r_Prods_354.PGrAID, r_ProdA_356.PGrAName, t_SRecD_352.SubProdID, r_Prods_354.ProdName, r_Prods_354.Notes, r_Prods_354.Article1, r_Prods_354.Article2, r_Prods_354.Article3, r_Prods_354.PGrID4, r_Prods_354.PGrID5, at_r_ProdG4_362.PGrName4, at_r_ProdG5_363.PGrName5, t_PInP_353.ProdBarCode ProdBarCode, '  Комплектация товара', SUM(0-(t_SRecD_352.SubQty)) SumQty, SUM(0-(t_SRecD_352.SubQty * t_PInP_353.CostMC)) CostSum FROM av_t_SRec t_SRec_320 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_345 WITH(NOLOCK) ON (t_SRec_320.CodeID1=r_Codes1_345.CodeID1)
INNER JOIN r_Codes2 r_Codes2_346 WITH(NOLOCK) ON (t_SRec_320.CodeID2=r_Codes2_346.CodeID2)
INNER JOIN r_Codes3 r_Codes3_347 WITH(NOLOCK) ON (t_SRec_320.CodeID3=r_Codes3_347.CodeID3)
INNER JOIN r_Codes4 r_Codes4_348 WITH(NOLOCK) ON (t_SRec_320.CodeID4=r_Codes4_348.CodeID4)
INNER JOIN r_Codes5 r_Codes5_349 WITH(NOLOCK) ON (t_SRec_320.CodeID5=r_Codes5_349.CodeID5)
INNER JOIN r_Ours r_Ours_344 WITH(NOLOCK) ON (t_SRec_320.OurID=r_Ours_344.OurID)
INNER JOIN r_Stocks r_Stocks_350 WITH(NOLOCK) ON (t_SRec_320.StockID=r_Stocks_350.StockID)
INNER JOIN av_t_SRecA t_SRecA_343 WITH(NOLOCK) ON (t_SRec_320.ChID=t_SRecA_343.ChID)
INNER JOIN r_StockGs r_StockGs_351 WITH(NOLOCK) ON (r_Stocks_350.StockGID=r_StockGs_351.StockGID)
INNER JOIN av_t_SRecD t_SRecD_352 WITH(NOLOCK) ON (t_SRecA_343.AChID=t_SRecD_352.AChID)
INNER JOIN t_PInP t_PInP_353 WITH(NOLOCK) ON (t_SRecD_352.SubPPID=t_PInP_353.PPID AND t_SRecD_352.SubProdID=t_PInP_353.ProdID)
INNER JOIN r_Prods r_Prods_354 WITH(NOLOCK) ON (t_PInP_353.ProdID=r_Prods_354.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_362 WITH(NOLOCK) ON (r_Prods_354.PGrID4=at_r_ProdG4_362.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_363 WITH(NOLOCK) ON (r_Prods_354.PGrID5=at_r_ProdG5_363.PGrID5)
INNER JOIN r_ProdA r_ProdA_356 WITH(NOLOCK) ON (r_Prods_354.PGrAID=r_ProdA_356.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_357 WITH(NOLOCK) ON (r_Prods_354.PBGrID=r_ProdBG_357.PBGrID)
INNER JOIN r_ProdC r_ProdC_358 WITH(NOLOCK) ON (r_Prods_354.PCatID=r_ProdC_358.PCatID)
INNER JOIN r_ProdG r_ProdG_355 WITH(NOLOCK) ON (r_Prods_354.PGrID=r_ProdG_355.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_359 WITH(NOLOCK) ON (r_Prods_354.PGrID1=r_ProdG1_359.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_360 WITH(NOLOCK) ON (r_Prods_354.PGrID2=r_ProdG2_360.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_361 WITH(NOLOCK) ON (r_Prods_354.PGrID3=r_ProdG3_361.PGrID3)
  WHERE  ((r_Prods_354.PGrID1 = 27) OR (r_Prods_354.PGrID1 = 28) OR (r_Prods_354.PGrID1 = 29) OR (r_Prods_354.PGrID1 = 63)) AND ((r_Prods_354.PCatID BETWEEN 1 AND 100)) AND ((t_SRec_320.StockID = 4) OR (t_SRec_320.StockID = 304)) AND (t_SRec_320.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_SRec_320.OurID, r_Ours_344.OurName, t_SRec_320.StockID, r_Stocks_350.StockName, r_Stocks_350.StockGID, r_StockGs_351.StockGName, t_SRec_320.CodeID1, r_Codes1_345.CodeName1, t_SRec_320.CodeID2, r_Codes2_346.CodeName2, t_SRec_320.CodeID3, r_Codes3_347.CodeName3, t_SRec_320.CodeID4, r_Codes4_348.CodeName4, t_SRec_320.CodeID5, r_Codes5_349.CodeName5, r_Prods_354.Country, r_Prods_354.PBGrID, r_ProdBG_357.PBGrName, r_Prods_354.PCatID, r_ProdC_358.PCatName, r_Prods_354.PGrID, r_ProdG_355.PGrName, r_Prods_354.PGrID1, r_ProdG1_359.PGrName1, r_Prods_354.PGrID2, r_ProdG2_360.PGrName2, r_Prods_354.PGrID3, r_ProdG3_361.PGrName3, r_Prods_354.PGrAID, r_ProdA_356.PGrAName, t_SRecD_352.SubProdID, r_Prods_354.ProdName, r_Prods_354.Notes, r_Prods_354.Article1, r_Prods_354.Article2, r_Prods_354.Article3, r_Prods_354.PGrID4, r_Prods_354.PGrID5, at_r_ProdG4_362.PGrName4, at_r_ProdG5_363.PGrName5, t_PInP_353.ProdBarCode


-->>> Разукомплектация товара - Разукомплектация товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_SExp_321.OurID, r_Ours_365.OurName, t_SExp_321.StockID, r_Stocks_371.StockName StockName, r_Stocks_371.StockGID, r_StockGs_372.StockGName, t_SExp_321.CodeID1, r_Codes1_366.CodeName1, t_SExp_321.CodeID2, r_Codes2_367.CodeName2, t_SExp_321.CodeID3, r_Codes3_368.CodeName3, t_SExp_321.CodeID4, r_Codes4_369.CodeName4, t_SExp_321.CodeID5, r_Codes5_370.CodeName5, r_Prods_375.Country, r_Prods_375.PBGrID, r_ProdBG_378.PBGrName, r_Prods_375.PCatID, r_ProdC_379.PCatName, r_Prods_375.PGrID, r_ProdG_376.PGrName, r_Prods_375.PGrID1, r_ProdG1_380.PGrName1, r_Prods_375.PGrID2, r_ProdG2_381.PGrName2, r_Prods_375.PGrID3, r_ProdG3_382.PGrName3, r_Prods_375.PGrAID, r_ProdA_377.PGrAName, t_SExpD_373.SubProdID, r_Prods_375.ProdName, r_Prods_375.Notes, r_Prods_375.Article1, r_Prods_375.Article2, r_Prods_375.Article3, r_Prods_375.PGrID4, r_Prods_375.PGrID5, at_r_ProdG4_383.PGrName4, at_r_ProdG5_384.PGrName5, t_PInP_374.ProdBarCode ProdBarCode, ' Разукомплектация товара', SUM(t_SExpD_373.SubQty) SumQty, SUM(t_SExpD_373.SubQty * t_PInP_374.CostMC) CostSum FROM av_t_SExp t_SExp_321 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_366 WITH(NOLOCK) ON (t_SExp_321.CodeID1=r_Codes1_366.CodeID1)
INNER JOIN r_Codes2 r_Codes2_367 WITH(NOLOCK) ON (t_SExp_321.CodeID2=r_Codes2_367.CodeID2)
INNER JOIN r_Codes3 r_Codes3_368 WITH(NOLOCK) ON (t_SExp_321.CodeID3=r_Codes3_368.CodeID3)
INNER JOIN r_Codes4 r_Codes4_369 WITH(NOLOCK) ON (t_SExp_321.CodeID4=r_Codes4_369.CodeID4)
INNER JOIN r_Codes5 r_Codes5_370 WITH(NOLOCK) ON (t_SExp_321.CodeID5=r_Codes5_370.CodeID5)
INNER JOIN r_Ours r_Ours_365 WITH(NOLOCK) ON (t_SExp_321.OurID=r_Ours_365.OurID)
INNER JOIN r_Stocks r_Stocks_371 WITH(NOLOCK) ON (t_SExp_321.StockID=r_Stocks_371.StockID)
INNER JOIN av_t_SExpA t_SExpA_364 WITH(NOLOCK) ON (t_SExp_321.ChID=t_SExpA_364.ChID)
INNER JOIN r_StockGs r_StockGs_372 WITH(NOLOCK) ON (r_Stocks_371.StockGID=r_StockGs_372.StockGID)
INNER JOIN av_t_SExpD t_SExpD_373 WITH(NOLOCK) ON (t_SExpA_364.AChID=t_SExpD_373.AChID)
INNER JOIN t_PInP t_PInP_374 WITH(NOLOCK) ON (t_SExpD_373.SubPPID=t_PInP_374.PPID AND t_SExpD_373.SubProdID=t_PInP_374.ProdID)
INNER JOIN r_Prods r_Prods_375 WITH(NOLOCK) ON (t_PInP_374.ProdID=r_Prods_375.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_383 WITH(NOLOCK) ON (r_Prods_375.PGrID4=at_r_ProdG4_383.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_384 WITH(NOLOCK) ON (r_Prods_375.PGrID5=at_r_ProdG5_384.PGrID5)
INNER JOIN r_ProdA r_ProdA_377 WITH(NOLOCK) ON (r_Prods_375.PGrAID=r_ProdA_377.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_378 WITH(NOLOCK) ON (r_Prods_375.PBGrID=r_ProdBG_378.PBGrID)
INNER JOIN r_ProdC r_ProdC_379 WITH(NOLOCK) ON (r_Prods_375.PCatID=r_ProdC_379.PCatID)
INNER JOIN r_ProdG r_ProdG_376 WITH(NOLOCK) ON (r_Prods_375.PGrID=r_ProdG_376.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_380 WITH(NOLOCK) ON (r_Prods_375.PGrID1=r_ProdG1_380.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_381 WITH(NOLOCK) ON (r_Prods_375.PGrID2=r_ProdG2_381.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_382 WITH(NOLOCK) ON (r_Prods_375.PGrID3=r_ProdG3_382.PGrID3)
  WHERE  ((r_Prods_375.PGrID1 = 27) OR (r_Prods_375.PGrID1 = 28) OR (r_Prods_375.PGrID1 = 29) OR (r_Prods_375.PGrID1 = 63)) AND ((r_Prods_375.PCatID BETWEEN 1 AND 100)) AND ((t_SExp_321.StockID = 4) OR (t_SExp_321.StockID = 304)) AND (t_SExp_321.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_SExp_321.OurID, r_Ours_365.OurName, t_SExp_321.StockID, r_Stocks_371.StockName, r_Stocks_371.StockGID, r_StockGs_372.StockGName, t_SExp_321.CodeID1, r_Codes1_366.CodeName1, t_SExp_321.CodeID2, r_Codes2_367.CodeName2, t_SExp_321.CodeID3, r_Codes3_368.CodeName3, t_SExp_321.CodeID4, r_Codes4_369.CodeName4, t_SExp_321.CodeID5, r_Codes5_370.CodeName5, r_Prods_375.Country, r_Prods_375.PBGrID, r_ProdBG_378.PBGrName, r_Prods_375.PCatID, r_ProdC_379.PCatName, r_Prods_375.PGrID, r_ProdG_376.PGrName, r_Prods_375.PGrID1, r_ProdG1_380.PGrName1, r_Prods_375.PGrID2, r_ProdG2_381.PGrName2, r_Prods_375.PGrID3, r_ProdG3_382.PGrName3, r_Prods_375.PGrAID, r_ProdA_377.PGrAName, t_SExpD_373.SubProdID, r_Prods_375.ProdName, r_Prods_375.Notes, r_Prods_375.Article1, r_Prods_375.Article2, r_Prods_375.Article3, r_Prods_375.PGrID4, r_Prods_375.PGrID5, at_r_ProdG4_383.PGrName4, at_r_ProdG5_384.PGrName5, t_PInP_374.ProdBarCode


-->>> Разукомплектация товара - Разукомплектация товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum])
SELECT t_SExp_322.OurID, r_Ours_386.OurName, t_SExp_322.StockID, r_Stocks_392.StockName StockName, r_Stocks_392.StockGID, r_StockGs_393.StockGName, t_SExp_322.CodeID1, r_Codes1_387.CodeName1, t_SExp_322.CodeID2, r_Codes2_388.CodeName2, t_SExp_322.CodeID3, r_Codes3_389.CodeName3, t_SExp_322.CodeID4, r_Codes4_390.CodeName4, t_SExp_322.CodeID5, r_Codes5_391.CodeName5, r_Prods_395.Country, r_Prods_395.PBGrID, r_ProdBG_398.PBGrName, r_Prods_395.PCatID, r_ProdC_399.PCatName, r_Prods_395.PGrID, r_ProdG_396.PGrName, r_Prods_395.PGrID1, r_ProdG1_400.PGrName1, r_Prods_395.PGrID2, r_ProdG2_401.PGrName2, r_Prods_395.PGrID3, r_ProdG3_402.PGrName3, r_Prods_395.PGrAID, r_ProdA_397.PGrAName, t_SExpA_385.ProdID, r_Prods_395.ProdName, r_Prods_395.Notes, r_Prods_395.Article1, r_Prods_395.Article2, r_Prods_395.Article3, r_Prods_395.PGrID4, r_Prods_395.PGrID5, at_r_ProdG4_403.PGrName4, at_r_ProdG5_404.PGrName5, t_PInP_394.ProdBarCode ProdBarCode, ' Разукомплектация товара', SUM(0-(t_SExpA_385.Qty)) SumQty, SUM(0-(t_SExpA_385.Qty * t_PInP_394.CostMC)) CostSum FROM av_t_SExp t_SExp_322 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_387 WITH(NOLOCK) ON (t_SExp_322.CodeID1=r_Codes1_387.CodeID1)
INNER JOIN r_Codes2 r_Codes2_388 WITH(NOLOCK) ON (t_SExp_322.CodeID2=r_Codes2_388.CodeID2)
INNER JOIN r_Codes3 r_Codes3_389 WITH(NOLOCK) ON (t_SExp_322.CodeID3=r_Codes3_389.CodeID3)
INNER JOIN r_Codes4 r_Codes4_390 WITH(NOLOCK) ON (t_SExp_322.CodeID4=r_Codes4_390.CodeID4)
INNER JOIN r_Codes5 r_Codes5_391 WITH(NOLOCK) ON (t_SExp_322.CodeID5=r_Codes5_391.CodeID5)
INNER JOIN r_Ours r_Ours_386 WITH(NOLOCK) ON (t_SExp_322.OurID=r_Ours_386.OurID)
INNER JOIN r_Stocks r_Stocks_392 WITH(NOLOCK) ON (t_SExp_322.StockID=r_Stocks_392.StockID)
INNER JOIN av_t_SExpA t_SExpA_385 WITH(NOLOCK) ON (t_SExp_322.ChID=t_SExpA_385.ChID)
INNER JOIN r_StockGs r_StockGs_393 WITH(NOLOCK) ON (r_Stocks_392.StockGID=r_StockGs_393.StockGID)
INNER JOIN t_PInP t_PInP_394 WITH(NOLOCK) ON (t_SExpA_385.PPID=t_PInP_394.PPID AND t_SExpA_385.ProdID=t_PInP_394.ProdID)
INNER JOIN r_Prods r_Prods_395 WITH(NOLOCK) ON (t_PInP_394.ProdID=r_Prods_395.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_403 WITH(NOLOCK) ON (r_Prods_395.PGrID4=at_r_ProdG4_403.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_404 WITH(NOLOCK) ON (r_Prods_395.PGrID5=at_r_ProdG5_404.PGrID5)
INNER JOIN r_ProdA r_ProdA_397 WITH(NOLOCK) ON (r_Prods_395.PGrAID=r_ProdA_397.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_398 WITH(NOLOCK) ON (r_Prods_395.PBGrID=r_ProdBG_398.PBGrID)
INNER JOIN r_ProdC r_ProdC_399 WITH(NOLOCK) ON (r_Prods_395.PCatID=r_ProdC_399.PCatID)
INNER JOIN r_ProdG r_ProdG_396 WITH(NOLOCK) ON (r_Prods_395.PGrID=r_ProdG_396.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_400 WITH(NOLOCK) ON (r_Prods_395.PGrID1=r_ProdG1_400.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_401 WITH(NOLOCK) ON (r_Prods_395.PGrID2=r_ProdG2_401.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_402 WITH(NOLOCK) ON (r_Prods_395.PGrID3=r_ProdG3_402.PGrID3)
  WHERE  ((r_Prods_395.PGrID1 = 27) OR (r_Prods_395.PGrID1 = 28) OR (r_Prods_395.PGrID1 = 29) OR (r_Prods_395.PGrID1 = 63)) AND ((r_Prods_395.PCatID BETWEEN 1 AND 100)) AND ((t_SExp_322.StockID = 4) OR (t_SExp_322.StockID = 304)) AND (t_SExp_322.DocDate BETWEEN '20190501' AND '20190618') GROUP BY t_SExp_322.OurID, r_Ours_386.OurName, t_SExp_322.StockID, r_Stocks_392.StockName, r_Stocks_392.StockGID, r_StockGs_393.StockGName, t_SExp_322.CodeID1, r_Codes1_387.CodeName1, t_SExp_322.CodeID2, r_Codes2_388.CodeName2, t_SExp_322.CodeID3, r_Codes3_389.CodeName3, t_SExp_322.CodeID4, r_Codes4_390.CodeName4, t_SExp_322.CodeID5, r_Codes5_391.CodeName5, r_Prods_395.Country, r_Prods_395.PBGrID, r_ProdBG_398.PBGrName, r_Prods_395.PCatID, r_ProdC_399.PCatName, r_Prods_395.PGrID, r_ProdG_396.PGrName, r_Prods_395.PGrID1, r_ProdG1_400.PGrName1, r_Prods_395.PGrID2, r_ProdG2_401.PGrName2, r_Prods_395.PGrID3, r_ProdG3_402.PGrName3, r_Prods_395.PGrAID, r_ProdA_397.PGrAName, t_SExpA_385.ProdID, r_Prods_395.ProdName, r_Prods_395.Notes, r_Prods_395.Article1, r_Prods_395.Article2, r_Prods_395.Article3, r_Prods_395.PGrID4, r_Prods_395.PGrID5, at_r_ProdG4_403.PGrName4, at_r_ProdG5_404.PGrName5, t_PInP_394.ProdBarCode



/*
IF OBJECT_ID (N'tempdb..#result',N'U') IS NOT NULL DROP TABLE #result
CREATE TABLE #result
( PGrName1 VACHAR(500)
 ,AltCode INT --CodePostavshika
 ,ProdID INT
 ,ProdName VARCHAR(1000)
 ,Weight INT
 ,QtyInBox INT
 ,AtBeginQty INT
 ,InvQty INT
 ,ExpQty INT
 ,EppQty INT 
 ,RetQty INT
 ,AtEndQty INT
 ,Sales INT
 ,Shortage INT
)


SELECT rpg1.PGrName1, 0 'CodePostavshika', rp.ProdID, rp.ProdName, rp.Weight, prmq.Qty, SUM(d.Qty) 'Qty'
FROM t_Rec m
JOIN t_RecD d WITH(NOLOCK) ON d.ChID = m.ChID
JOIN t_PInP tp WITH(NOLOCK) ON d.PPID = tp.PPID AND d.ProdID = tp.ProdID
JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = tp.ProdID
JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = rp.PGrID1
JOIN r_ProdMQ prmq WITH(NOLOCK) ON prmq.ProdID = rp.ProdID AND prmq.UM = 'ящ.'
WHERE rp.PGrID1 IN (27,28,29,63)
	  AND rp.PCatID BETWEEN 1 AND 100
	  AND m.StockID IN (4,304)
      AND m.DocDate BETWEEN '20190501' AND '20190618'
GROUP BY rpg1.PGrName1, rp.ProdID, rp.ProdName, rp.Weight, prmq.Qty

--Накладные
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Inv m WITH(NOLOCK)
JOIN t_InvD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (27, 28, 29, 63)
        AND rp.PCatID BETWEEN 1 AND 100
		AND m.StockID IN (4, 304)
		AND m.DocDate BETWEEN '20190501' AND '20190618'
GROUP BY rp.ProdID

--ВР
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Exp m WITH(NOLOCK)
JOIN t_ExpD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (27, 28, 29, 63)
        AND rp.PCatID BETWEEN 1 AND 100
		AND m.StockID IN (4, 304)
		AND m.DocDate BETWEEN '20190501' AND '20190618'
GROUP BY rp.ProdID

--ВР в ЦП
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Epp m WITH(NOLOCK)
JOIN t_EppD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (27, 28, 29, 63)
        AND rp.PCatID BETWEEN 1 AND 100
		AND m.StockID IN (4, 304)
		AND m.DocDate BETWEEN '20190501' AND '20190618'
GROUP BY rp.ProdID

--Возврат от получателя
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Ret m WITH(NOLOCK)
JOIN t_RetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (27, 28, 29, 63)
        AND rp.PCatID BETWEEN 1 AND 100
		AND m.StockID IN (4, 304)
		AND m.DocDate BETWEEN '20190501' AND '20190618'
GROUP BY rp.ProdID

--На начало.
SELECT q.ProdID, SUM(q.SumQty) Qty
FROM
(
-->>> На начало - Приход товара:
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Rec m WITH(NOLOCK)
JOIN t_RecD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Возврат товара от получателя:
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Ret m WITH(NOLOCK)
JOIN t_RetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Возврат товара поставщику:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_CRet m WITH(NOLOCK)
JOIN t_CRetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Расходная накладная:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Inv m WITH(NOLOCK)
JOIN t_InvD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Расходный документ:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Exp m WITH(NOLOCK)
JOIN r_Ours r_Ours_105 WITH(NOLOCK) ON (m.OurID=r_Ours_105.OurID)
JOIN t_ExpD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Расходный документ в ценах прихода:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Epp m WITH(NOLOCK)
JOIN t_EppD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Перемещение товара (Приход):
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Exc m WITH(NOLOCK)
JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.NewStockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Перемещение товара (Расход):
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Exc m WITH(NOLOCK)
INNER JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
INNER JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
INNER JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Инвентаризация товара (Приход):
SELECT rp.ProdID, SUM(d.NewQty) SumQty
FROM t_Ven m WITH(NOLOCK)
JOIN t_VenA tva WITH(NOLOCK) ON (m.ChID=tva.ChID)
JOIN t_VenD d WITH(NOLOCK) ON (tva.ChID=d.ChID AND tva.ProdID=d.DetProdID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.DetProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Инвентаризация товара (Расход):
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Ven m WITH(NOLOCK)
JOIN t_VenA tva WITH(NOLOCK) ON (m.ChID=tva.ChID)
JOIN t_VenD d WITH(NOLOCK) ON (tva.ChID=d.ChID AND tva.ProdID=d.DetProdID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.DetProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Переоценка цен прихода (Приход):
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Est m WITH(NOLOCK)
JOIN t_EstD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.NewPPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Переоценка цен прихода (Расход):
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Est m WITH(NOLOCK)
JOIN t_EstD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Входящие остатки товара:
SELECT rp.ProdID, SUM(m.Qty) SumQty
FROM t_zInP m WITH(NOLOCK)
JOIN t_PInP tp WITH(NOLOCK) ON (m.PPID=tp.PPID AND m.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Возврат товара по чеку:
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_CRRet m WITH(NOLOCK)
JOIN t_CRRetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Продажа товара оператором:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Sale m WITH(NOLOCK)
JOIN t_SaleD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Комплектация товара (Приход):
SELECT rp.ProdID, SUM(tsra.Qty) SumQty
FROM t_SRec m WITH(NOLOCK)
JOIN t_SRecA tsra WITH(NOLOCK) ON (m.ChID=tsra.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (tsra.PPID=tp.PPID AND tsra.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На начало - Комплектация товара (Расход):
SELECT rp.ProdID, SUM(0-(d.SubQty)) SumQty
FROM t_SRec m WITH(NOLOCK)
JOIN t_SRecA tsra WITH(NOLOCK) ON (m.ChID=tsra.ChID)
JOIN t_SRecD d WITH(NOLOCK) ON (tsra.AChID=d.AChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.SubPPID=tp.PPID AND d.SubProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL

-->>> На начало - Разукомплектация товара (Приход):
SELECT rp.ProdID, SUM(d.SubQty) SumQty
FROM t_SExp m WITH(NOLOCK)
JOIN t_SExpA tsea WITH(NOLOCK) ON (m.ChID=tsea.ChID)
JOIN t_SExpD d WITH(NOLOCK) ON (tsea.AChID=d.AChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.SubPPID=tp.PPID AND d.SubProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL

-->>> На начало - Разукомплектация товара (Расход):
SELECT rp.ProdID, SUM(0-(tsea.Qty)) SumQty
FROM t_SExp m WITH(NOLOCK)
JOIN t_SExpA tsea WITH(NOLOCK) ON (m.ChID=tsea.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (tsea.PPID=tp.PPID AND tsea.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
   WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate < '20190501')
GROUP BY rp.ProdID
) q
GROUP BY q.ProdID
ORDER BY q.ProdID

--На конец
SELECT q.ProdID, SUM(q.SumQty) Qty
FROM
(
-->>> На конец - Приход товара:
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Rec m WITH(NOLOCK)
JOIN t_RecD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Возврат товара от получателя:
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Ret m WITH(NOLOCK)
JOIN t_RetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Возврат товара поставщику:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_CRet m WITH(NOLOCK)
JOIN t_CRetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Расходная накладная:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Inv m WITH(NOLOCK)
JOIN t_InvD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Расходный документ:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Exp m WITH(NOLOCK)
JOIN t_ExpD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Расходный документ в ценах прихода:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Epp m WITH(NOLOCK)
JOIN t_EppD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


--!!!>>> На конец - Перемещение товара (Приход):
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Exc m WITH(NOLOCK)
JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.NewStockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Перемещение товара (Расход):
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Exc m WITH(NOLOCK)
JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Инвентаризация товара (Приход):
SELECT rp.ProdID, SUM(d.NewQty) SumQty
FROM t_Ven m WITH(NOLOCK)
JOIN t_VenA tva WITH(NOLOCK) ON (m.ChID=tva.ChID)
JOIN t_VenD d WITH(NOLOCK) ON (tva.ChID=d.ChID AND tva.ProdID=d.DetProdID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.DetProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Инвентаризация товара (Расход):
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Ven m WITH(NOLOCK)
JOIN t_VenA tva WITH(NOLOCK) ON (m.ChID=tva.ChID)
JOIN t_VenD d WITH(NOLOCK) ON (tva.ChID=d.ChID AND tva.ProdID=d.DetProdID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.DetProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Переоценка цен прихода (Приход):
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_Est m WITH(NOLOCK)
JOIN t_EstD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.NewPPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Переоценка цен прихода (Расход):
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Est m WITH(NOLOCK)
JOIN t_EstD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Входящие остатки товара:
SELECT rp.ProdID, SUM(m.Qty) SumQty
FROM t_zInP m WITH(NOLOCK)
JOIN t_PInP tp WITH(NOLOCK) ON (m.PPID=tp.PPID AND m.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Возврат товара по чеку:
SELECT rp.ProdID, SUM(d.Qty) SumQty
FROM t_CRRet m WITH(NOLOCK)
JOIN t_CRRetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Продажа товара оператором:
SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
FROM t_Sale m WITH(NOLOCK)
JOIN t_SaleD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Комплектация товара (Приход):
SELECT rp.ProdID, SUM(tsra.Qty) SumQty
FROM t_SRec m WITH(NOLOCK)
JOIN t_SRecA tsra WITH(NOLOCK) ON (m.ChID=tsra.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (tsra.PPID=tp.PPID AND tsra.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Комплектация товара (Расход):
SELECT rp.ProdID, SUM(0-(d.SubQty)) SumQty
FROM t_SRec m WITH(NOLOCK)
JOIN t_SRecA tsra WITH(NOLOCK) ON (m.ChID=tsra.ChID)
JOIN t_SRecD d WITH(NOLOCK) ON (tsra.AChID=d.AChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.SubPPID=tp.PPID AND d.SubProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL


-->>> На конец - Разукомплектация товара (Приход):
SELECT rp.ProdID, SUM(d.SubQty) SumQty
FROM t_SExp m WITH(NOLOCK)
JOIN t_SExpA tsea WITH(NOLOCK) ON (m.ChID=tsea.ChID)
JOIN t_SExpD d WITH(NOLOCK) ON (tsea.AChID=d.AChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.SubPPID=tp.PPID AND d.SubProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
--ORDER BY rp.ProdID
UNION ALL

-->>> На конец - Разукомплектация товара (Расход):
SELECT rp.ProdID, SUM(0-(tsea.Qty)) SumQty
FROM t_SExp m WITH(NOLOCK)
JOIN t_SExpA tsea WITH(NOLOCK) ON (m.ChID=tsea.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (tsea.PPID=tp.PPID AND tsea.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
    WHERE  rp.PGrID1 IN (27, 28, 29, 63)
		 AND rp.PCatID BETWEEN 1 AND 100
		 AND m.StockID IN (4, 304)
		 AND (m.DocDate <= '20190618')
GROUP BY rp.ProdID
) q
GROUP BY q.ProdID
ORDER BY q.ProdID










-->>> На начало - Приход товара:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Rec_1.OurID, r_Ours_91.OurName, t_Rec_1.StockID, r_Stocks_97.StockName StockName, r_Stocks_97.StockGID, r_StockGs_245.StockGName, t_Rec_1.CodeID1, r_Codes1_92.CodeName1, t_Rec_1.CodeID2, r_Codes2_93.CodeName2, t_Rec_1.CodeID3, r_Codes3_94.CodeName3, t_Rec_1.CodeID4, r_Codes4_95.CodeName4, t_Rec_1.CodeID5, r_Codes5_96.CodeName5, r_Prods_192.Country, r_Prods_192.PBGrID, r_ProdBG_198.PBGrName, r_Prods_192.PCatID, r_ProdC_193.PCatName, r_Prods_192.PGrID, r_ProdG_194.PGrName, r_Prods_192.PGrID1, r_ProdG1_195.PGrName1, r_Prods_192.PGrID2, r_ProdG2_196.PGrName2, r_Prods_192.PGrID3, r_ProdG3_197.PGrName3, r_Prods_192.PGrAID, r_ProdA_232.PGrAName, t_RecD_2.ProdID, r_Prods_192.ProdName, r_Prods_192.Notes, r_Prods_192.Article1, r_Prods_192.Article2, r_Prods_192.Article3, r_Prods_192.PGrID4, r_Prods_192.PGrID5, at_r_ProdG4_309.PGrName4, at_r_ProdG5_310.PGrName5, t_PInP_191.ProdBarCode ProdBarCode, '               На начало', SUM(t_RecD_2.Qty) SumQty, SUM(t_RecD_2.Qty * t_PInP_191.CostMC) CostSum FROM av_t_Rec t_Rec_1 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_92 WITH(NOLOCK) ON (t_Rec_1.CodeID1=r_Codes1_92.CodeID1)
INNER JOIN r_Codes2 r_Codes2_93 WITH(NOLOCK) ON (t_Rec_1.CodeID2=r_Codes2_93.CodeID2)
INNER JOIN r_Codes3 r_Codes3_94 WITH(NOLOCK) ON (t_Rec_1.CodeID3=r_Codes3_94.CodeID3)
INNER JOIN r_Codes4 r_Codes4_95 WITH(NOLOCK) ON (t_Rec_1.CodeID4=r_Codes4_95.CodeID4)
INNER JOIN r_Codes5 r_Codes5_96 WITH(NOLOCK) ON (t_Rec_1.CodeID5=r_Codes5_96.CodeID5)
INNER JOIN r_Ours r_Ours_91 WITH(NOLOCK) ON (t_Rec_1.OurID=r_Ours_91.OurID)
INNER JOIN r_Stocks r_Stocks_97 WITH(NOLOCK) ON (t_Rec_1.StockID=r_Stocks_97.StockID)
INNER JOIN av_t_RecD t_RecD_2 WITH(NOLOCK) ON (t_Rec_1.ChID=t_RecD_2.ChID)
INNER JOIN r_StockGs r_StockGs_245 WITH(NOLOCK) ON (r_Stocks_97.StockGID=r_StockGs_245.StockGID)
INNER JOIN t_PInP t_PInP_191 WITH(NOLOCK) ON (t_RecD_2.PPID=t_PInP_191.PPID AND t_RecD_2.ProdID=t_PInP_191.ProdID)
INNER JOIN r_Prods r_Prods_192 WITH(NOLOCK) ON (t_PInP_191.ProdID=r_Prods_192.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_309 WITH(NOLOCK) ON (r_Prods_192.PGrID4=at_r_ProdG4_309.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_310 WITH(NOLOCK) ON (r_Prods_192.PGrID5=at_r_ProdG5_310.PGrID5)
INNER JOIN r_ProdA r_ProdA_232 WITH(NOLOCK) ON (r_Prods_192.PGrAID=r_ProdA_232.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_198 WITH(NOLOCK) ON (r_Prods_192.PBGrID=r_ProdBG_198.PBGrID)
INNER JOIN r_ProdC r_ProdC_193 WITH(NOLOCK) ON (r_Prods_192.PCatID=r_ProdC_193.PCatID)
INNER JOIN r_ProdG r_ProdG_194 WITH(NOLOCK) ON (r_Prods_192.PGrID=r_ProdG_194.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_195 WITH(NOLOCK) ON (r_Prods_192.PGrID1=r_ProdG1_195.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_196 WITH(NOLOCK) ON (r_Prods_192.PGrID2=r_ProdG2_196.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_197 WITH(NOLOCK) ON (r_Prods_192.PGrID3=r_ProdG3_197.PGrID3)
  WHERE  ((r_Prods_192.PGrID1 = 27) OR (r_Prods_192.PGrID1 = 28) OR (r_Prods_192.PGrID1 = 29) OR (r_Prods_192.PGrID1 = 63)) AND ((r_Prods_192.PCatID BETWEEN 1 AND 100)) AND ((t_Rec_1.StockID = 4) OR (t_Rec_1.StockID = 304)) AND
  (t_Rec_1.DocDate < '20190501') GROUP BY t_Rec_1.OurID, r_Ours_91.OurName, t_Rec_1.StockID, r_Stocks_97.StockName, r_Stocks_97.StockGID, r_StockGs_245.StockGName, t_Rec_1.CodeID1, r_Codes1_92.CodeName1, t_Rec_1.CodeID2, r_Codes2_93.CodeName2, t_Rec_1.CodeID3, r_Codes3_94.CodeName3, t_Rec_1.CodeID4, r_Codes4_95.CodeName4, t_Rec_1.CodeID5, r_Codes5_96.CodeName5, r_Prods_192.Country, r_Prods_192.PBGrID, r_ProdBG_198.PBGrName, r_Prods_192.PCatID, r_ProdC_193.PCatName, r_Prods_192.PGrID, r_ProdG_194.PGrName, r_Prods_192.PGrID1, r_ProdG1_195.PGrName1, r_Prods_192.PGrID2, r_ProdG2_196.PGrName2, r_Prods_192.PGrID3, r_ProdG3_197.PGrName3, r_Prods_192.PGrAID, r_ProdA_232.PGrAName, t_RecD_2.ProdID, r_Prods_192.ProdName, r_Prods_192.Notes, r_Prods_192.Article1, r_Prods_192.Article2, r_Prods_192.Article3, r_Prods_192.PGrID4, r_Prods_192.PGrID5, at_r_ProdG4_309.PGrName4, at_r_ProdG5_310.PGrName5, t_PInP_191.ProdBarCode


-->>> На начало - Возврат товара от получателя:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Ret_3.OurID, r_Ours_28.OurName, t_Ret_3.StockID, r_Stocks_34.StockName StockName, r_Stocks_34.StockGID, r_StockGs_236.StockGName, t_Ret_3.CodeID1, r_Codes1_29.CodeName1, t_Ret_3.CodeID2, r_Codes2_30.CodeName2, t_Ret_3.CodeID3, r_Codes3_31.CodeName3, t_Ret_3.CodeID4, r_Codes4_32.CodeName4, t_Ret_3.CodeID5, r_Codes5_33.CodeName5, r_Prods_120.Country, r_Prods_120.PBGrID, r_ProdBG_126.PBGrName, r_Prods_120.PCatID, r_ProdC_121.PCatName, r_Prods_120.PGrID, r_ProdG_122.PGrName, r_Prods_120.PGrID1, r_ProdG1_123.PGrName1, r_Prods_120.PGrID2, r_ProdG2_124.PGrName2, r_Prods_120.PGrID3, r_ProdG3_125.PGrName3, r_Prods_120.PGrAID, r_ProdA_223.PGrAName, t_RetD_4.ProdID, r_Prods_120.ProdName, r_Prods_120.Notes, r_Prods_120.Article1, r_Prods_120.Article2, r_Prods_120.Article3, r_Prods_120.PGrID4, r_Prods_120.PGrID5, at_r_ProdG4_289.PGrName4, at_r_ProdG5_290.PGrName5, t_PInP_119.ProdBarCode ProdBarCode, '               На начало', SUM(t_RetD_4.Qty) SumQty, SUM(t_RetD_4.Qty * t_PInP_119.CostMC) CostSum FROM av_t_Ret t_Ret_3 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_29 WITH(NOLOCK) ON (t_Ret_3.CodeID1=r_Codes1_29.CodeID1)
INNER JOIN r_Codes2 r_Codes2_30 WITH(NOLOCK) ON (t_Ret_3.CodeID2=r_Codes2_30.CodeID2)
INNER JOIN r_Codes3 r_Codes3_31 WITH(NOLOCK) ON (t_Ret_3.CodeID3=r_Codes3_31.CodeID3)
INNER JOIN r_Codes4 r_Codes4_32 WITH(NOLOCK) ON (t_Ret_3.CodeID4=r_Codes4_32.CodeID4)
INNER JOIN r_Codes5 r_Codes5_33 WITH(NOLOCK) ON (t_Ret_3.CodeID5=r_Codes5_33.CodeID5)
INNER JOIN r_Ours r_Ours_28 WITH(NOLOCK) ON (t_Ret_3.OurID=r_Ours_28.OurID)
INNER JOIN r_Stocks r_Stocks_34 WITH(NOLOCK) ON (t_Ret_3.StockID=r_Stocks_34.StockID)
INNER JOIN av_t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID)
INNER JOIN r_StockGs r_StockGs_236 WITH(NOLOCK) ON (r_Stocks_34.StockGID=r_StockGs_236.StockGID)
INNER JOIN t_PInP t_PInP_119 WITH(NOLOCK) ON (t_RetD_4.PPID=t_PInP_119.PPID AND t_RetD_4.ProdID=t_PInP_119.ProdID)
INNER JOIN r_Prods r_Prods_120 WITH(NOLOCK) ON (t_PInP_119.ProdID=r_Prods_120.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_289 WITH(NOLOCK) ON (r_Prods_120.PGrID4=at_r_ProdG4_289.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_290 WITH(NOLOCK) ON (r_Prods_120.PGrID5=at_r_ProdG5_290.PGrID5)
INNER JOIN r_ProdA r_ProdA_223 WITH(NOLOCK) ON (r_Prods_120.PGrAID=r_ProdA_223.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_126 WITH(NOLOCK) ON (r_Prods_120.PBGrID=r_ProdBG_126.PBGrID)
INNER JOIN r_ProdC r_ProdC_121 WITH(NOLOCK) ON (r_Prods_120.PCatID=r_ProdC_121.PCatID)
INNER JOIN r_ProdG r_ProdG_122 WITH(NOLOCK) ON (r_Prods_120.PGrID=r_ProdG_122.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_123 WITH(NOLOCK) ON (r_Prods_120.PGrID1=r_ProdG1_123.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_124 WITH(NOLOCK) ON (r_Prods_120.PGrID2=r_ProdG2_124.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_125 WITH(NOLOCK) ON (r_Prods_120.PGrID3=r_ProdG3_125.PGrID3)
  WHERE  ((r_Prods_120.PGrID1 = 27) OR (r_Prods_120.PGrID1 = 28) OR (r_Prods_120.PGrID1 = 29) OR (r_Prods_120.PGrID1 = 63)) AND ((r_Prods_120.PCatID BETWEEN 1 AND 100)) AND ((t_Ret_3.StockID = 4) OR (t_Ret_3.StockID = 304))
  AND (t_Ret_3.DocDate < '20190501') GROUP BY t_Ret_3.OurID, r_Ours_28.OurName, t_Ret_3.StockID, r_Stocks_34.StockName, r_Stocks_34.StockGID, r_StockGs_236.StockGName, t_Ret_3.CodeID1, r_Codes1_29.CodeName1, t_Ret_3.CodeID2, r_Codes2_30.CodeName2, t_Ret_3.CodeID3, r_Codes3_31.CodeName3, t_Ret_3.CodeID4, r_Codes4_32.CodeName4, t_Ret_3.CodeID5, r_Codes5_33.CodeName5, r_Prods_120.Country, r_Prods_120.PBGrID, r_ProdBG_126.PBGrName, r_Prods_120.PCatID, r_ProdC_121.PCatName, r_Prods_120.PGrID, r_ProdG_122.PGrName, r_Prods_120.PGrID1, r_ProdG1_123.PGrName1, r_Prods_120.PGrID2, r_ProdG2_124.PGrName2, r_Prods_120.PGrID3, r_ProdG3_125.PGrName3, r_Prods_120.PGrAID, r_ProdA_223.PGrAName, t_RetD_4.ProdID, r_Prods_120.ProdName, r_Prods_120.Notes, r_Prods_120.Article1, r_Prods_120.Article2, r_Prods_120.Article3, r_Prods_120.PGrID4, r_Prods_120.PGrID5, at_r_ProdG4_289.PGrName4, at_r_ProdG5_290.PGrName5, t_PInP_119.ProdBarCode


-->>> На начало - Возврат товара поставщику:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_CRet_5.OurID, r_Ours_35.OurName, t_CRet_5.StockID, r_Stocks_41.StockName StockName, r_Stocks_41.StockGID, r_StockGs_237.StockGName, t_CRet_5.CodeID1, r_Codes1_36.CodeName1, t_CRet_5.CodeID2, r_Codes2_37.CodeName2, t_CRet_5.CodeID3, r_Codes3_38.CodeName3, t_CRet_5.CodeID4, r_Codes4_39.CodeName4, t_CRet_5.CodeID5, r_Codes5_40.CodeName5, r_Prods_128.Country, r_Prods_128.PBGrID, r_ProdBG_134.PBGrName, r_Prods_128.PCatID, r_ProdC_129.PCatName, r_Prods_128.PGrID, r_ProdG_130.PGrName, r_Prods_128.PGrID1, r_ProdG1_131.PGrName1, r_Prods_128.PGrID2, r_ProdG2_132.PGrName2, r_Prods_128.PGrID3, r_ProdG3_133.PGrName3, r_Prods_128.PGrAID, r_ProdA_224.PGrAName, t_CRetD_6.ProdID, r_Prods_128.ProdName, r_Prods_128.Notes, r_Prods_128.Article1, r_Prods_128.Article2, r_Prods_128.Article3, r_Prods_128.PGrID4, r_Prods_128.PGrID5, at_r_ProdG4_293.PGrName4, at_r_ProdG5_294.PGrName5, t_PInP_127.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_CRetD_6.Qty)) SumQty, SUM(0-(t_CRetD_6.Qty * t_PInP_127.CostMC)) CostSum FROM av_t_CRet t_CRet_5 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_36 WITH(NOLOCK) ON (t_CRet_5.CodeID1=r_Codes1_36.CodeID1)
INNER JOIN r_Codes2 r_Codes2_37 WITH(NOLOCK) ON (t_CRet_5.CodeID2=r_Codes2_37.CodeID2)
INNER JOIN r_Codes3 r_Codes3_38 WITH(NOLOCK) ON (t_CRet_5.CodeID3=r_Codes3_38.CodeID3)
INNER JOIN r_Codes4 r_Codes4_39 WITH(NOLOCK) ON (t_CRet_5.CodeID4=r_Codes4_39.CodeID4)
INNER JOIN r_Codes5 r_Codes5_40 WITH(NOLOCK) ON (t_CRet_5.CodeID5=r_Codes5_40.CodeID5)
INNER JOIN r_Ours r_Ours_35 WITH(NOLOCK) ON (t_CRet_5.OurID=r_Ours_35.OurID)
INNER JOIN r_Stocks r_Stocks_41 WITH(NOLOCK) ON (t_CRet_5.StockID=r_Stocks_41.StockID)
INNER JOIN av_t_CRetD t_CRetD_6 WITH(NOLOCK) ON (t_CRet_5.ChID=t_CRetD_6.ChID)
INNER JOIN r_StockGs r_StockGs_237 WITH(NOLOCK) ON (r_Stocks_41.StockGID=r_StockGs_237.StockGID)
INNER JOIN t_PInP t_PInP_127 WITH(NOLOCK) ON (t_CRetD_6.PPID=t_PInP_127.PPID AND t_CRetD_6.ProdID=t_PInP_127.ProdID)
INNER JOIN r_Prods r_Prods_128 WITH(NOLOCK) ON (t_PInP_127.ProdID=r_Prods_128.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_293 WITH(NOLOCK) ON (r_Prods_128.PGrID4=at_r_ProdG4_293.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_294 WITH(NOLOCK) ON (r_Prods_128.PGrID5=at_r_ProdG5_294.PGrID5)
INNER JOIN r_ProdA r_ProdA_224 WITH(NOLOCK) ON (r_Prods_128.PGrAID=r_ProdA_224.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_134 WITH(NOLOCK) ON (r_Prods_128.PBGrID=r_ProdBG_134.PBGrID)
INNER JOIN r_ProdC r_ProdC_129 WITH(NOLOCK) ON (r_Prods_128.PCatID=r_ProdC_129.PCatID)
INNER JOIN r_ProdG r_ProdG_130 WITH(NOLOCK) ON (r_Prods_128.PGrID=r_ProdG_130.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_131 WITH(NOLOCK) ON (r_Prods_128.PGrID1=r_ProdG1_131.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_132 WITH(NOLOCK) ON (r_Prods_128.PGrID2=r_ProdG2_132.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_133 WITH(NOLOCK) ON (r_Prods_128.PGrID3=r_ProdG3_133.PGrID3)
  WHERE  ((r_Prods_128.PGrID1 = 27) OR (r_Prods_128.PGrID1 = 28) OR (r_Prods_128.PGrID1 = 29) OR (r_Prods_128.PGrID1 = 63)) AND ((r_Prods_128.PCatID BETWEEN 1 AND 100)) AND ((t_CRet_5.StockID = 4) OR (t_CRet_5.StockID = 304))
  AND (t_CRet_5.DocDate < '20190501') GROUP BY t_CRet_5.OurID, r_Ours_35.OurName, t_CRet_5.StockID, r_Stocks_41.StockName, r_Stocks_41.StockGID, r_StockGs_237.StockGName, t_CRet_5.CodeID1, r_Codes1_36.CodeName1, t_CRet_5.CodeID2, r_Codes2_37.CodeName2, t_CRet_5.CodeID3, r_Codes3_38.CodeName3, t_CRet_5.CodeID4, r_Codes4_39.CodeName4, t_CRet_5.CodeID5, r_Codes5_40.CodeName5, r_Prods_128.Country, r_Prods_128.PBGrID, r_ProdBG_134.PBGrName, r_Prods_128.PCatID, r_ProdC_129.PCatName, r_Prods_128.PGrID, r_ProdG_130.PGrName, r_Prods_128.PGrID1, r_ProdG1_131.PGrName1, r_Prods_128.PGrID2, r_ProdG2_132.PGrName2, r_Prods_128.PGrID3, r_ProdG3_133.PGrName3, r_Prods_128.PGrAID, r_ProdA_224.PGrAName, t_CRetD_6.ProdID, r_Prods_128.ProdName, r_Prods_128.Notes, r_Prods_128.Article1, r_Prods_128.Article2, r_Prods_128.Article3, r_Prods_128.PGrID4, r_Prods_128.PGrID5, at_r_ProdG4_293.PGrName4, at_r_ProdG5_294.PGrName5, t_PInP_127.ProdBarCode


-->>> На начало - Расходная накладная:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Inv_7.OurID, r_Ours_98.OurName, t_Inv_7.StockID, r_Stocks_104.StockName StockName, r_Stocks_104.StockGID, r_StockGs_246.StockGName, t_Inv_7.CodeID1, r_Codes1_99.CodeName1, t_Inv_7.CodeID2, r_Codes2_100.CodeName2, t_Inv_7.CodeID3, r_Codes3_101.CodeName3, t_Inv_7.CodeID4, r_Codes4_102.CodeName4, t_Inv_7.CodeID5, r_Codes5_103.CodeName5, r_Prods_200.Country, r_Prods_200.PBGrID, r_ProdBG_206.PBGrName, r_Prods_200.PCatID, r_ProdC_201.PCatName, r_Prods_200.PGrID, r_ProdG_202.PGrName, r_Prods_200.PGrID1, r_ProdG1_203.PGrName1, r_Prods_200.PGrID2, r_ProdG2_204.PGrName2, r_Prods_200.PGrID3, r_ProdG3_205.PGrName3, r_Prods_200.PGrAID, r_ProdA_233.PGrAName, t_InvD_8.ProdID, r_Prods_200.ProdName, r_Prods_200.Notes, r_Prods_200.Article1, r_Prods_200.Article2, r_Prods_200.Article3, r_Prods_200.PGrID4, r_Prods_200.PGrID5, at_r_ProdG4_313.PGrName4, at_r_ProdG5_314.PGrName5, t_PInP_199.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_InvD_8.Qty)) SumQty, SUM(0-(t_InvD_8.Qty * t_PInP_199.CostMC)) CostSum FROM av_t_Inv t_Inv_7 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_99 WITH(NOLOCK) ON (t_Inv_7.CodeID1=r_Codes1_99.CodeID1)
INNER JOIN r_Codes2 r_Codes2_100 WITH(NOLOCK) ON (t_Inv_7.CodeID2=r_Codes2_100.CodeID2)
INNER JOIN r_Codes3 r_Codes3_101 WITH(NOLOCK) ON (t_Inv_7.CodeID3=r_Codes3_101.CodeID3)
INNER JOIN r_Codes4 r_Codes4_102 WITH(NOLOCK) ON (t_Inv_7.CodeID4=r_Codes4_102.CodeID4)
INNER JOIN r_Codes5 r_Codes5_103 WITH(NOLOCK) ON (t_Inv_7.CodeID5=r_Codes5_103.CodeID5)
INNER JOIN r_Ours r_Ours_98 WITH(NOLOCK) ON (t_Inv_7.OurID=r_Ours_98.OurID)
INNER JOIN r_Stocks r_Stocks_104 WITH(NOLOCK) ON (t_Inv_7.StockID=r_Stocks_104.StockID)
INNER JOIN av_t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID)
INNER JOIN r_StockGs r_StockGs_246 WITH(NOLOCK) ON (r_Stocks_104.StockGID=r_StockGs_246.StockGID)
INNER JOIN t_PInP t_PInP_199 WITH(NOLOCK) ON (t_InvD_8.PPID=t_PInP_199.PPID AND t_InvD_8.ProdID=t_PInP_199.ProdID)
INNER JOIN r_Prods r_Prods_200 WITH(NOLOCK) ON (t_PInP_199.ProdID=r_Prods_200.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_313 WITH(NOLOCK) ON (r_Prods_200.PGrID4=at_r_ProdG4_313.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_314 WITH(NOLOCK) ON (r_Prods_200.PGrID5=at_r_ProdG5_314.PGrID5)
INNER JOIN r_ProdA r_ProdA_233 WITH(NOLOCK) ON (r_Prods_200.PGrAID=r_ProdA_233.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_206 WITH(NOLOCK) ON (r_Prods_200.PBGrID=r_ProdBG_206.PBGrID)
INNER JOIN r_ProdC r_ProdC_201 WITH(NOLOCK) ON (r_Prods_200.PCatID=r_ProdC_201.PCatID)
INNER JOIN r_ProdG r_ProdG_202 WITH(NOLOCK) ON (r_Prods_200.PGrID=r_ProdG_202.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_203 WITH(NOLOCK) ON (r_Prods_200.PGrID1=r_ProdG1_203.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_204 WITH(NOLOCK) ON (r_Prods_200.PGrID2=r_ProdG2_204.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_205 WITH(NOLOCK) ON (r_Prods_200.PGrID3=r_ProdG3_205.PGrID3)
  WHERE  ((r_Prods_200.PGrID1 = 27) OR (r_Prods_200.PGrID1 = 28) OR (r_Prods_200.PGrID1 = 29) OR (r_Prods_200.PGrID1 = 63)) AND ((r_Prods_200.PCatID BETWEEN 1 AND 100)) AND ((t_Inv_7.StockID = 4) OR (t_Inv_7.StockID = 304))
  AND (t_Inv_7.DocDate < '20190501') GROUP BY t_Inv_7.OurID, r_Ours_98.OurName, t_Inv_7.StockID, r_Stocks_104.StockName, r_Stocks_104.StockGID, r_StockGs_246.StockGName, t_Inv_7.CodeID1, r_Codes1_99.CodeName1, t_Inv_7.CodeID2, r_Codes2_100.CodeName2, t_Inv_7.CodeID3, r_Codes3_101.CodeName3, t_Inv_7.CodeID4, r_Codes4_102.CodeName4, t_Inv_7.CodeID5, r_Codes5_103.CodeName5, r_Prods_200.Country, r_Prods_200.PBGrID, r_ProdBG_206.PBGrName, r_Prods_200.PCatID, r_ProdC_201.PCatName, r_Prods_200.PGrID, r_ProdG_202.PGrName, r_Prods_200.PGrID1, r_ProdG1_203.PGrName1, r_Prods_200.PGrID2, r_ProdG2_204.PGrName2, r_Prods_200.PGrID3, r_ProdG3_205.PGrName3, r_Prods_200.PGrAID, r_ProdA_233.PGrAName, t_InvD_8.ProdID, r_Prods_200.ProdName, r_Prods_200.Notes, r_Prods_200.Article1, r_Prods_200.Article2, r_Prods_200.Article3, r_Prods_200.PGrID4, r_Prods_200.PGrID5, at_r_ProdG4_313.PGrName4, at_r_ProdG5_314.PGrName5, t_PInP_199.ProdBarCode


-->>> На начало - Расходный документ:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Exp_9.OurID, r_Ours_105.OurName, t_Exp_9.StockID, r_Stocks_111.StockName StockName, r_Stocks_111.StockGID, r_StockGs_247.StockGName, t_Exp_9.CodeID1, r_Codes1_106.CodeName1, t_Exp_9.CodeID2, r_Codes2_107.CodeName2, t_Exp_9.CodeID3, r_Codes3_108.CodeName3, t_Exp_9.CodeID4, r_Codes4_109.CodeName4, t_Exp_9.CodeID5, r_Codes5_110.CodeName5, r_Prods_208.Country, r_Prods_208.PBGrID, r_ProdBG_214.PBGrName, r_Prods_208.PCatID, r_ProdC_209.PCatName, r_Prods_208.PGrID, r_ProdG_210.PGrName, r_Prods_208.PGrID1, r_ProdG1_211.PGrName1, r_Prods_208.PGrID2, r_ProdG2_212.PGrName2, r_Prods_208.PGrID3, r_ProdG3_213.PGrName3, r_Prods_208.PGrAID, r_ProdA_234.PGrAName, t_ExpD_10.ProdID, r_Prods_208.ProdName, r_Prods_208.Notes, r_Prods_208.Article1, r_Prods_208.Article2, r_Prods_208.Article3, r_Prods_208.PGrID4, r_Prods_208.PGrID5, at_r_ProdG4_315.PGrName4, at_r_ProdG5_316.PGrName5, t_PInP_207.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_ExpD_10.Qty)) SumQty, SUM(0-(t_ExpD_10.Qty * t_PInP_207.CostMC)) CostSum FROM av_t_Exp t_Exp_9 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_106 WITH(NOLOCK) ON (t_Exp_9.CodeID1=r_Codes1_106.CodeID1)
INNER JOIN r_Codes2 r_Codes2_107 WITH(NOLOCK) ON (t_Exp_9.CodeID2=r_Codes2_107.CodeID2)
INNER JOIN r_Codes3 r_Codes3_108 WITH(NOLOCK) ON (t_Exp_9.CodeID3=r_Codes3_108.CodeID3)
INNER JOIN r_Codes4 r_Codes4_109 WITH(NOLOCK) ON (t_Exp_9.CodeID4=r_Codes4_109.CodeID4)
INNER JOIN r_Codes5 r_Codes5_110 WITH(NOLOCK) ON (t_Exp_9.CodeID5=r_Codes5_110.CodeID5)
INNER JOIN r_Ours r_Ours_105 WITH(NOLOCK) ON (t_Exp_9.OurID=r_Ours_105.OurID)
INNER JOIN r_Stocks r_Stocks_111 WITH(NOLOCK) ON (t_Exp_9.StockID=r_Stocks_111.StockID)
INNER JOIN av_t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID)
INNER JOIN r_StockGs r_StockGs_247 WITH(NOLOCK) ON (r_Stocks_111.StockGID=r_StockGs_247.StockGID)
INNER JOIN t_PInP t_PInP_207 WITH(NOLOCK) ON (t_ExpD_10.PPID=t_PInP_207.PPID AND t_ExpD_10.ProdID=t_PInP_207.ProdID)
INNER JOIN r_Prods r_Prods_208 WITH(NOLOCK) ON (t_PInP_207.ProdID=r_Prods_208.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_315 WITH(NOLOCK) ON (r_Prods_208.PGrID4=at_r_ProdG4_315.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_316 WITH(NOLOCK) ON (r_Prods_208.PGrID5=at_r_ProdG5_316.PGrID5)
INNER JOIN r_ProdA r_ProdA_234 WITH(NOLOCK) ON (r_Prods_208.PGrAID=r_ProdA_234.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_214 WITH(NOLOCK) ON (r_Prods_208.PBGrID=r_ProdBG_214.PBGrID)
INNER JOIN r_ProdC r_ProdC_209 WITH(NOLOCK) ON (r_Prods_208.PCatID=r_ProdC_209.PCatID)
INNER JOIN r_ProdG r_ProdG_210 WITH(NOLOCK) ON (r_Prods_208.PGrID=r_ProdG_210.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_211 WITH(NOLOCK) ON (r_Prods_208.PGrID1=r_ProdG1_211.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_212 WITH(NOLOCK) ON (r_Prods_208.PGrID2=r_ProdG2_212.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_213 WITH(NOLOCK) ON (r_Prods_208.PGrID3=r_ProdG3_213.PGrID3)
  WHERE  ((r_Prods_208.PGrID1 = 27) OR (r_Prods_208.PGrID1 = 28) OR (r_Prods_208.PGrID1 = 29) OR (r_Prods_208.PGrID1 = 63)) AND ((r_Prods_208.PCatID BETWEEN 1 AND 100)) AND ((t_Exp_9.StockID = 4) OR (t_Exp_9.StockID = 304))
  AND (t_Exp_9.DocDate < '20190501') GROUP BY t_Exp_9.OurID, r_Ours_105.OurName, t_Exp_9.StockID, r_Stocks_111.StockName, r_Stocks_111.StockGID, r_StockGs_247.StockGName, t_Exp_9.CodeID1, r_Codes1_106.CodeName1, t_Exp_9.CodeID2, r_Codes2_107.CodeName2, t_Exp_9.CodeID3, r_Codes3_108.CodeName3, t_Exp_9.CodeID4, r_Codes4_109.CodeName4, t_Exp_9.CodeID5, r_Codes5_110.CodeName5, r_Prods_208.Country, r_Prods_208.PBGrID, r_ProdBG_214.PBGrName, r_Prods_208.PCatID, r_ProdC_209.PCatName, r_Prods_208.PGrID, r_ProdG_210.PGrName, r_Prods_208.PGrID1, r_ProdG1_211.PGrName1, r_Prods_208.PGrID2, r_ProdG2_212.PGrName2, r_Prods_208.PGrID3, r_ProdG3_213.PGrName3, r_Prods_208.PGrAID, r_ProdA_234.PGrAName, t_ExpD_10.ProdID, r_Prods_208.ProdName, r_Prods_208.Notes, r_Prods_208.Article1, r_Prods_208.Article2, r_Prods_208.Article3, r_Prods_208.PGrID4, r_Prods_208.PGrID5, at_r_ProdG4_315.PGrName4, at_r_ProdG5_316.PGrName5, t_PInP_207.ProdBarCode


-->>> На начало - Расходный документ в ценах прихода:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Epp_11.OurID, r_Ours_112.OurName, t_Epp_11.StockID, r_Stocks_118.StockName StockName, r_Stocks_118.StockGID, r_StockGs_248.StockGName, t_Epp_11.CodeID1, r_Codes1_113.CodeName1, t_Epp_11.CodeID2, r_Codes2_114.CodeName2, t_Epp_11.CodeID3, r_Codes3_115.CodeName3, t_Epp_11.CodeID4, r_Codes4_116.CodeName4, t_Epp_11.CodeID5, r_Codes5_117.CodeName5, r_Prods_216.Country, r_Prods_216.PBGrID, r_ProdBG_222.PBGrName, r_Prods_216.PCatID, r_ProdC_217.PCatName, r_Prods_216.PGrID, r_ProdG_218.PGrName, r_Prods_216.PGrID1, r_ProdG1_219.PGrName1, r_Prods_216.PGrID2, r_ProdG2_220.PGrName2, r_Prods_216.PGrID3, r_ProdG3_221.PGrName3, r_Prods_216.PGrAID, r_ProdA_235.PGrAName, t_EppD_12.ProdID, r_Prods_216.ProdName, r_Prods_216.Notes, r_Prods_216.Article1, r_Prods_216.Article2, r_Prods_216.Article3, r_Prods_216.PGrID4, r_Prods_216.PGrID5, at_r_ProdG4_317.PGrName4, at_r_ProdG5_318.PGrName5, t_PInP_215.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_EppD_12.Qty)) SumQty, SUM(0-(t_EppD_12.Qty * t_PInP_215.CostMC)) CostSum FROM av_t_Epp t_Epp_11 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_113 WITH(NOLOCK) ON (t_Epp_11.CodeID1=r_Codes1_113.CodeID1)
INNER JOIN r_Codes2 r_Codes2_114 WITH(NOLOCK) ON (t_Epp_11.CodeID2=r_Codes2_114.CodeID2)
INNER JOIN r_Codes3 r_Codes3_115 WITH(NOLOCK) ON (t_Epp_11.CodeID3=r_Codes3_115.CodeID3)
INNER JOIN r_Codes4 r_Codes4_116 WITH(NOLOCK) ON (t_Epp_11.CodeID4=r_Codes4_116.CodeID4)
INNER JOIN r_Codes5 r_Codes5_117 WITH(NOLOCK) ON (t_Epp_11.CodeID5=r_Codes5_117.CodeID5)
INNER JOIN r_Ours r_Ours_112 WITH(NOLOCK) ON (t_Epp_11.OurID=r_Ours_112.OurID)
INNER JOIN r_Stocks r_Stocks_118 WITH(NOLOCK) ON (t_Epp_11.StockID=r_Stocks_118.StockID)
INNER JOIN av_t_EppD t_EppD_12 WITH(NOLOCK) ON (t_Epp_11.ChID=t_EppD_12.ChID)
INNER JOIN r_StockGs r_StockGs_248 WITH(NOLOCK) ON (r_Stocks_118.StockGID=r_StockGs_248.StockGID)
INNER JOIN t_PInP t_PInP_215 WITH(NOLOCK) ON (t_EppD_12.PPID=t_PInP_215.PPID AND t_EppD_12.ProdID=t_PInP_215.ProdID)
INNER JOIN r_Prods r_Prods_216 WITH(NOLOCK) ON (t_PInP_215.ProdID=r_Prods_216.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_317 WITH(NOLOCK) ON (r_Prods_216.PGrID4=at_r_ProdG4_317.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_318 WITH(NOLOCK) ON (r_Prods_216.PGrID5=at_r_ProdG5_318.PGrID5)
INNER JOIN r_ProdA r_ProdA_235 WITH(NOLOCK) ON (r_Prods_216.PGrAID=r_ProdA_235.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_222 WITH(NOLOCK) ON (r_Prods_216.PBGrID=r_ProdBG_222.PBGrID)
INNER JOIN r_ProdC r_ProdC_217 WITH(NOLOCK) ON (r_Prods_216.PCatID=r_ProdC_217.PCatID)
INNER JOIN r_ProdG r_ProdG_218 WITH(NOLOCK) ON (r_Prods_216.PGrID=r_ProdG_218.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_219 WITH(NOLOCK) ON (r_Prods_216.PGrID1=r_ProdG1_219.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_220 WITH(NOLOCK) ON (r_Prods_216.PGrID2=r_ProdG2_220.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_221 WITH(NOLOCK) ON (r_Prods_216.PGrID3=r_ProdG3_221.PGrID3)
  WHERE  ((r_Prods_216.PGrID1 = 27) OR (r_Prods_216.PGrID1 = 28) OR (r_Prods_216.PGrID1 = 29) OR (r_Prods_216.PGrID1 = 63)) AND ((r_Prods_216.PCatID BETWEEN 1 AND 100)) AND ((t_Epp_11.StockID = 4) OR (t_Epp_11.StockID = 304)
  AND (t_Epp_11.DocDate < '20190501') GROUP BY t_Epp_11.OurID, r_Ours_112.OurName, t_Epp_11.StockID, r_Stocks_118.StockName, r_Stocks_118.StockGID, r_StockGs_248.StockGName, t_Epp_11.CodeID1, r_Codes1_113.CodeName1, t_Epp_11.CodeID2, r_Codes2_114.CodeName2, t_Epp_11.CodeID3, r_Codes3_115.CodeName3, t_Epp_11.CodeID4, r_Codes4_116.CodeName4, t_Epp_11.CodeID5, r_Codes5_117.CodeName5, r_Prods_216.Country, r_Prods_216.PBGrID, r_ProdBG_222.PBGrName, r_Prods_216.PCatID, r_ProdC_217.PCatName, r_Prods_216.PGrID, r_ProdG_218.PGrName, r_Prods_216.PGrID1, r_ProdG1_219.PGrName1, r_Prods_216.PGrID2, r_ProdG2_220.PGrName2, r_Prods_216.PGrID3, r_ProdG3_221.PGrName3, r_Prods_216.PGrAID, r_ProdA_235.PGrAName, t_EppD_12.ProdID, r_Prods_216.ProdName, r_Prods_216.Notes, r_Prods_216.Article1, r_Prods_216.Article2, r_Prods_216.Article3, r_Prods_216.PGrID4, r_Prods_216.PGrID5, at_r_ProdG4_317.PGrName4, at_r_ProdG5_318.PGrName5, t_PInP_215.ProdBarCode


-->>> На начало - Перемещение товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Exc_13.OurID, r_Ours_63.OurName, t_Exc_13.NewStockID, r_Stocks_69.StockName StockName, r_Stocks_69.StockGID, r_StockGs_241.StockGName, t_Exc_13.CodeID1, r_Codes1_64.CodeName1, t_Exc_13.CodeID2, r_Codes2_65.CodeName2, t_Exc_13.CodeID3, r_Codes3_66.CodeName3, t_Exc_13.CodeID4, r_Codes4_67.CodeName4, t_Exc_13.CodeID5, r_Codes5_68.CodeName5, r_Prods_160.Country, r_Prods_160.PBGrID, r_ProdBG_166.PBGrName, r_Prods_160.PCatID, r_ProdC_161.PCatName, r_Prods_160.PGrID, r_ProdG_162.PGrName, r_Prods_160.PGrID1, r_ProdG1_163.PGrName1, r_Prods_160.PGrID2, r_ProdG2_164.PGrName2, r_Prods_160.PGrID3, r_ProdG3_165.PGrName3, r_Prods_160.PGrAID, r_ProdA_228.PGrAName, t_ExcD_14.ProdID, r_Prods_160.ProdName, r_Prods_160.Notes, r_Prods_160.Article1, r_Prods_160.Article2, r_Prods_160.Article3, r_Prods_160.PGrID4, r_Prods_160.PGrID5, at_r_ProdG4_301.PGrName4, at_r_ProdG5_302.PGrName5, t_PInP_159.ProdBarCode ProdBarCode, '               На начало', SUM(t_ExcD_14.Qty) SumQty, SUM(t_ExcD_14.Qty * t_PInP_159.CostMC) CostSum FROM av_t_Exc t_Exc_13 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_64 WITH(NOLOCK) ON (t_Exc_13.CodeID1=r_Codes1_64.CodeID1)
INNER JOIN r_Codes2 r_Codes2_65 WITH(NOLOCK) ON (t_Exc_13.CodeID2=r_Codes2_65.CodeID2)
INNER JOIN r_Codes3 r_Codes3_66 WITH(NOLOCK) ON (t_Exc_13.CodeID3=r_Codes3_66.CodeID3)
INNER JOIN r_Codes4 r_Codes4_67 WITH(NOLOCK) ON (t_Exc_13.CodeID4=r_Codes4_67.CodeID4)
INNER JOIN r_Codes5 r_Codes5_68 WITH(NOLOCK) ON (t_Exc_13.CodeID5=r_Codes5_68.CodeID5)
INNER JOIN r_Ours r_Ours_63 WITH(NOLOCK) ON (t_Exc_13.OurID=r_Ours_63.OurID)
INNER JOIN r_Stocks r_Stocks_69 WITH(NOLOCK) ON (t_Exc_13.NewStockID=r_Stocks_69.StockID)
INNER JOIN av_t_ExcD t_ExcD_14 WITH(NOLOCK) ON (t_Exc_13.ChID=t_ExcD_14.ChID)
INNER JOIN r_StockGs r_StockGs_241 WITH(NOLOCK) ON (r_Stocks_69.StockGID=r_StockGs_241.StockGID)
INNER JOIN t_PInP t_PInP_159 WITH(NOLOCK) ON (t_ExcD_14.PPID=t_PInP_159.PPID AND t_ExcD_14.ProdID=t_PInP_159.ProdID)
INNER JOIN r_Prods r_Prods_160 WITH(NOLOCK) ON (t_PInP_159.ProdID=r_Prods_160.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_301 WITH(NOLOCK) ON (r_Prods_160.PGrID4=at_r_ProdG4_301.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_302 WITH(NOLOCK) ON (r_Prods_160.PGrID5=at_r_ProdG5_302.PGrID5)
INNER JOIN r_ProdA r_ProdA_228 WITH(NOLOCK) ON (r_Prods_160.PGrAID=r_ProdA_228.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_166 WITH(NOLOCK) ON (r_Prods_160.PBGrID=r_ProdBG_166.PBGrID)
INNER JOIN r_ProdC r_ProdC_161 WITH(NOLOCK) ON (r_Prods_160.PCatID=r_ProdC_161.PCatID)
INNER JOIN r_ProdG r_ProdG_162 WITH(NOLOCK) ON (r_Prods_160.PGrID=r_ProdG_162.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_163 WITH(NOLOCK) ON (r_Prods_160.PGrID1=r_ProdG1_163.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_164 WITH(NOLOCK) ON (r_Prods_160.PGrID2=r_ProdG2_164.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_165 WITH(NOLOCK) ON (r_Prods_160.PGrID3=r_ProdG3_165.PGrID3)
  WHERE  ((r_Prods_160.PGrID1 = 27) OR (r_Prods_160.PGrID1 = 28) OR (r_Prods_160.PGrID1 = 29) OR (r_Prods_160.PGrID1 = 63)) AND ((r_Prods_160.PCatID BETWEEN 1 AND 100)) AND ((t_Exc_13.NewStockID = 4) OR (t_Exc_13.NewStockID = 304))
  AND (t_Exc_13.DocDate < '20190501') GROUP BY t_Exc_13.OurID, r_Ours_63.OurName, t_Exc_13.NewStockID, r_Stocks_69.StockName, r_Stocks_69.StockGID, r_StockGs_241.StockGName, t_Exc_13.CodeID1, r_Codes1_64.CodeName1, t_Exc_13.CodeID2, r_Codes2_65.CodeName2, t_Exc_13.CodeID3, r_Codes3_66.CodeName3, t_Exc_13.CodeID4, r_Codes4_67.CodeName4, t_Exc_13.CodeID5, r_Codes5_68.CodeName5, r_Prods_160.Country, r_Prods_160.PBGrID, r_ProdBG_166.PBGrName, r_Prods_160.PCatID, r_ProdC_161.PCatName, r_Prods_160.PGrID, r_ProdG_162.PGrName, r_Prods_160.PGrID1, r_ProdG1_163.PGrName1, r_Prods_160.PGrID2, r_ProdG2_164.PGrName2, r_Prods_160.PGrID3, r_ProdG3_165.PGrName3, r_Prods_160.PGrAID, r_ProdA_228.PGrAName, t_ExcD_14.ProdID, r_Prods_160.ProdName, r_Prods_160.Notes, r_Prods_160.Article1, r_Prods_160.Article2, r_Prods_160.Article3, r_Prods_160.PGrID4, r_Prods_160.PGrID5, at_r_ProdG4_301.PGrName4, at_r_ProdG5_302.PGrName5, t_PInP_159.ProdBarCode


-->>> На начало - Перемещение товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Exc_15.OurID, r_Ours_70.OurName, t_Exc_15.StockID, r_Stocks_76.StockName StockName, r_Stocks_76.StockGID, r_StockGs_242.StockGName, t_Exc_15.CodeID1, r_Codes1_71.CodeName1, t_Exc_15.CodeID2, r_Codes2_72.CodeName2, t_Exc_15.CodeID3, r_Codes3_73.CodeName3, t_Exc_15.CodeID4, r_Codes4_74.CodeName4, t_Exc_15.CodeID5, r_Codes5_75.CodeName5, r_Prods_168.Country, r_Prods_168.PBGrID, r_ProdBG_174.PBGrName, r_Prods_168.PCatID, r_ProdC_169.PCatName, r_Prods_168.PGrID, r_ProdG_170.PGrName, r_Prods_168.PGrID1, r_ProdG1_171.PGrName1, r_Prods_168.PGrID2, r_ProdG2_172.PGrName2, r_Prods_168.PGrID3, r_ProdG3_173.PGrName3, r_Prods_168.PGrAID, r_ProdA_229.PGrAName, t_ExcD_16.ProdID, r_Prods_168.ProdName, r_Prods_168.Notes, r_Prods_168.Article1, r_Prods_168.Article2, r_Prods_168.Article3, r_Prods_168.PGrID4, r_Prods_168.PGrID5, at_r_ProdG4_303.PGrName4, at_r_ProdG5_304.PGrName5, t_PInP_167.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_ExcD_16.Qty)) SumQty, SUM(0-(t_ExcD_16.Qty * t_PInP_167.CostMC)) CostSum FROM av_t_Exc t_Exc_15 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_71 WITH(NOLOCK) ON (t_Exc_15.CodeID1=r_Codes1_71.CodeID1)
INNER JOIN r_Codes2 r_Codes2_72 WITH(NOLOCK) ON (t_Exc_15.CodeID2=r_Codes2_72.CodeID2)
INNER JOIN r_Codes3 r_Codes3_73 WITH(NOLOCK) ON (t_Exc_15.CodeID3=r_Codes3_73.CodeID3)
INNER JOIN r_Codes4 r_Codes4_74 WITH(NOLOCK) ON (t_Exc_15.CodeID4=r_Codes4_74.CodeID4)
INNER JOIN r_Codes5 r_Codes5_75 WITH(NOLOCK) ON (t_Exc_15.CodeID5=r_Codes5_75.CodeID5)
INNER JOIN r_Ours r_Ours_70 WITH(NOLOCK) ON (t_Exc_15.OurID=r_Ours_70.OurID)
INNER JOIN r_Stocks r_Stocks_76 WITH(NOLOCK) ON (t_Exc_15.StockID=r_Stocks_76.StockID)
INNER JOIN av_t_ExcD t_ExcD_16 WITH(NOLOCK) ON (t_Exc_15.ChID=t_ExcD_16.ChID)
INNER JOIN r_StockGs r_StockGs_242 WITH(NOLOCK) ON (r_Stocks_76.StockGID=r_StockGs_242.StockGID)
INNER JOIN t_PInP t_PInP_167 WITH(NOLOCK) ON (t_ExcD_16.PPID=t_PInP_167.PPID AND t_ExcD_16.ProdID=t_PInP_167.ProdID)
INNER JOIN r_Prods r_Prods_168 WITH(NOLOCK) ON (t_PInP_167.ProdID=r_Prods_168.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_303 WITH(NOLOCK) ON (r_Prods_168.PGrID4=at_r_ProdG4_303.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_304 WITH(NOLOCK) ON (r_Prods_168.PGrID5=at_r_ProdG5_304.PGrID5)
INNER JOIN r_ProdA r_ProdA_229 WITH(NOLOCK) ON (r_Prods_168.PGrAID=r_ProdA_229.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_174 WITH(NOLOCK) ON (r_Prods_168.PBGrID=r_ProdBG_174.PBGrID)
INNER JOIN r_ProdC r_ProdC_169 WITH(NOLOCK) ON (r_Prods_168.PCatID=r_ProdC_169.PCatID)
INNER JOIN r_ProdG r_ProdG_170 WITH(NOLOCK) ON (r_Prods_168.PGrID=r_ProdG_170.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_171 WITH(NOLOCK) ON (r_Prods_168.PGrID1=r_ProdG1_171.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_172 WITH(NOLOCK) ON (r_Prods_168.PGrID2=r_ProdG2_172.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_173 WITH(NOLOCK) ON (r_Prods_168.PGrID3=r_ProdG3_173.PGrID3)
  WHERE  ((r_Prods_168.PGrID1 = 27) OR (r_Prods_168.PGrID1 = 28) OR (r_Prods_168.PGrID1 = 29) OR (r_Prods_168.PGrID1 = 63)) AND ((r_Prods_168.PCatID BETWEEN 1 AND 100)) AND ((t_Exc_15.StockID = 4) OR (t_Exc_15.StockID = 304))
  AND (t_Exc_15.DocDate < '20190501') GROUP BY t_Exc_15.OurID, r_Ours_70.OurName, t_Exc_15.StockID, r_Stocks_76.StockName, r_Stocks_76.StockGID, r_StockGs_242.StockGName, t_Exc_15.CodeID1, r_Codes1_71.CodeName1, t_Exc_15.CodeID2, r_Codes2_72.CodeName2, t_Exc_15.CodeID3, r_Codes3_73.CodeName3, t_Exc_15.CodeID4, r_Codes4_74.CodeName4, t_Exc_15.CodeID5, r_Codes5_75.CodeName5, r_Prods_168.Country, r_Prods_168.PBGrID, r_ProdBG_174.PBGrName, r_Prods_168.PCatID, r_ProdC_169.PCatName, r_Prods_168.PGrID, r_ProdG_170.PGrName, r_Prods_168.PGrID1, r_ProdG1_171.PGrName1, r_Prods_168.PGrID2, r_ProdG2_172.PGrName2, r_Prods_168.PGrID3, r_ProdG3_173.PGrName3, r_Prods_168.PGrAID, r_ProdA_229.PGrAName, t_ExcD_16.ProdID, r_Prods_168.ProdName, r_Prods_168.Notes, r_Prods_168.Article1, r_Prods_168.Article2, r_Prods_168.Article3, r_Prods_168.PGrID4, r_Prods_168.PGrID5, at_r_ProdG4_303.PGrName4, at_r_ProdG5_304.PGrName5, t_PInP_167.ProdBarCode


-->>> На начало - Инвентаризация товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Ven_17.OurID, r_Ours_49.OurName, t_Ven_17.StockID, r_Stocks_55.StockName StockName, r_Stocks_55.StockGID, r_StockGs_239.StockGName, t_Ven_17.CodeID1, r_Codes1_50.CodeName1, t_Ven_17.CodeID2, r_Codes2_51.CodeName2, t_Ven_17.CodeID3, r_Codes3_52.CodeName3, t_Ven_17.CodeID4, r_Codes4_53.CodeName4, t_Ven_17.CodeID5, r_Codes5_54.CodeName5, r_Prods_144.Country, r_Prods_144.PBGrID, r_ProdBG_150.PBGrName, r_Prods_144.PCatID, r_ProdC_145.PCatName, r_Prods_144.PGrID, r_ProdG_146.PGrName, r_Prods_144.PGrID1, r_ProdG1_147.PGrName1, r_Prods_144.PGrID2, r_ProdG2_148.PGrName2, r_Prods_144.PGrID3, r_ProdG3_149.PGrName3, r_Prods_144.PGrAID, r_ProdA_226.PGrAName, t_VenA_18.ProdID, r_Prods_144.ProdName, r_Prods_144.Notes, r_Prods_144.Article1, r_Prods_144.Article2, r_Prods_144.Article3, r_Prods_144.PGrID4, r_Prods_144.PGrID5, at_r_ProdG4_297.PGrName4, at_r_ProdG5_298.PGrName5, t_PInP_143.ProdBarCode ProdBarCode, '               На начало', SUM(t_VenD_19.NewQty) SumQty, SUM(t_VenD_19.NewQty * t_PInP_143.CostMC) CostSum FROM av_t_Ven t_Ven_17 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_50 WITH(NOLOCK) ON (t_Ven_17.CodeID1=r_Codes1_50.CodeID1)
INNER JOIN r_Codes2 r_Codes2_51 WITH(NOLOCK) ON (t_Ven_17.CodeID2=r_Codes2_51.CodeID2)
INNER JOIN r_Codes3 r_Codes3_52 WITH(NOLOCK) ON (t_Ven_17.CodeID3=r_Codes3_52.CodeID3)
INNER JOIN r_Codes4 r_Codes4_53 WITH(NOLOCK) ON (t_Ven_17.CodeID4=r_Codes4_53.CodeID4)
INNER JOIN r_Codes5 r_Codes5_54 WITH(NOLOCK) ON (t_Ven_17.CodeID5=r_Codes5_54.CodeID5)
INNER JOIN r_Ours r_Ours_49 WITH(NOLOCK) ON (t_Ven_17.OurID=r_Ours_49.OurID)
INNER JOIN r_Stocks r_Stocks_55 WITH(NOLOCK) ON (t_Ven_17.StockID=r_Stocks_55.StockID)
INNER JOIN av_t_VenA t_VenA_18 WITH(NOLOCK) ON (t_Ven_17.ChID=t_VenA_18.ChID)
INNER JOIN r_StockGs r_StockGs_239 WITH(NOLOCK) ON (r_Stocks_55.StockGID=r_StockGs_239.StockGID)
INNER JOIN av_t_VenD t_VenD_19 WITH(NOLOCK) ON (t_VenA_18.ChID=t_VenD_19.ChID AND t_VenA_18.ProdID=t_VenD_19.DetProdID)
INNER JOIN t_PInP t_PInP_143 WITH(NOLOCK) ON (t_VenD_19.PPID=t_PInP_143.PPID AND t_VenD_19.DetProdID=t_PInP_143.ProdID)
INNER JOIN r_Prods r_Prods_144 WITH(NOLOCK) ON (t_PInP_143.ProdID=r_Prods_144.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_297 WITH(NOLOCK) ON (r_Prods_144.PGrID4=at_r_ProdG4_297.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_298 WITH(NOLOCK) ON (r_Prods_144.PGrID5=at_r_ProdG5_298.PGrID5)
INNER JOIN r_ProdA r_ProdA_226 WITH(NOLOCK) ON (r_Prods_144.PGrAID=r_ProdA_226.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_150 WITH(NOLOCK) ON (r_Prods_144.PBGrID=r_ProdBG_150.PBGrID)
INNER JOIN r_ProdC r_ProdC_145 WITH(NOLOCK) ON (r_Prods_144.PCatID=r_ProdC_145.PCatID)
INNER JOIN r_ProdG r_ProdG_146 WITH(NOLOCK) ON (r_Prods_144.PGrID=r_ProdG_146.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_147 WITH(NOLOCK) ON (r_Prods_144.PGrID1=r_ProdG1_147.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_148 WITH(NOLOCK) ON (r_Prods_144.PGrID2=r_ProdG2_148.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_149 WITH(NOLOCK) ON (r_Prods_144.PGrID3=r_ProdG3_149.PGrID3)
  WHERE  ((r_Prods_144.PGrID1 = 27) OR (r_Prods_144.PGrID1 = 28) OR (r_Prods_144.PGrID1 = 29) OR (r_Prods_144.PGrID1 = 63)) AND ((r_Prods_144.PCatID BETWEEN 1 AND 100)) AND ((t_Ven_17.StockID = 4) OR (t_Ven_17.StockID = 304))
  AND (t_Ven_17.DocDate < '20190501') GROUP BY t_Ven_17.OurID, r_Ours_49.OurName, t_Ven_17.StockID, r_Stocks_55.StockName, r_Stocks_55.StockGID, r_StockGs_239.StockGName, t_Ven_17.CodeID1, r_Codes1_50.CodeName1, t_Ven_17.CodeID2, r_Codes2_51.CodeName2, t_Ven_17.CodeID3, r_Codes3_52.CodeName3, t_Ven_17.CodeID4, r_Codes4_53.CodeName4, t_Ven_17.CodeID5, r_Codes5_54.CodeName5, r_Prods_144.Country, r_Prods_144.PBGrID, r_ProdBG_150.PBGrName, r_Prods_144.PCatID, r_ProdC_145.PCatName, r_Prods_144.PGrID, r_ProdG_146.PGrName, r_Prods_144.PGrID1, r_ProdG1_147.PGrName1, r_Prods_144.PGrID2, r_ProdG2_148.PGrName2, r_Prods_144.PGrID3, r_ProdG3_149.PGrName3, r_Prods_144.PGrAID, r_ProdA_226.PGrAName, t_VenA_18.ProdID, r_Prods_144.ProdName, r_Prods_144.Notes, r_Prods_144.Article1, r_Prods_144.Article2, r_Prods_144.Article3, r_Prods_144.PGrID4, r_Prods_144.PGrID5, at_r_ProdG4_297.PGrName4, at_r_ProdG5_298.PGrName5, t_PInP_143.ProdBarCode


-->>> На начало - Инвентаризация товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Ven_20.OurID, r_Ours_56.OurName, t_Ven_20.StockID, r_Stocks_62.StockName StockName, r_Stocks_62.StockGID, r_StockGs_240.StockGName, t_Ven_20.CodeID1, r_Codes1_57.CodeName1, t_Ven_20.CodeID2, r_Codes2_58.CodeName2, t_Ven_20.CodeID3, r_Codes3_59.CodeName3, t_Ven_20.CodeID4, r_Codes4_60.CodeName4, t_Ven_20.CodeID5, r_Codes5_61.CodeName5, r_Prods_152.Country, r_Prods_152.PBGrID, r_ProdBG_158.PBGrName, r_Prods_152.PCatID, r_ProdC_153.PCatName, r_Prods_152.PGrID, r_ProdG_154.PGrName, r_Prods_152.PGrID1, r_ProdG1_155.PGrName1, r_Prods_152.PGrID2, r_ProdG2_156.PGrName2, r_Prods_152.PGrID3, r_ProdG3_157.PGrName3, r_Prods_152.PGrAID, r_ProdA_227.PGrAName, t_VenA_21.ProdID, r_Prods_152.ProdName, r_Prods_152.Notes, r_Prods_152.Article1, r_Prods_152.Article2, r_Prods_152.Article3, r_Prods_152.PGrID4, r_Prods_152.PGrID5, at_r_ProdG4_299.PGrName4, at_r_ProdG5_300.PGrName5, t_PInP_151.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_VenD_22.Qty)) SumQty, SUM(0-(t_VenD_22.Qty * t_PInP_151.CostMC)) CostSum FROM av_t_Ven t_Ven_20 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_57 WITH(NOLOCK) ON (t_Ven_20.CodeID1=r_Codes1_57.CodeID1)
INNER JOIN r_Codes2 r_Codes2_58 WITH(NOLOCK) ON (t_Ven_20.CodeID2=r_Codes2_58.CodeID2)
INNER JOIN r_Codes3 r_Codes3_59 WITH(NOLOCK) ON (t_Ven_20.CodeID3=r_Codes3_59.CodeID3)
INNER JOIN r_Codes4 r_Codes4_60 WITH(NOLOCK) ON (t_Ven_20.CodeID4=r_Codes4_60.CodeID4)
INNER JOIN r_Codes5 r_Codes5_61 WITH(NOLOCK) ON (t_Ven_20.CodeID5=r_Codes5_61.CodeID5)
INNER JOIN r_Ours r_Ours_56 WITH(NOLOCK) ON (t_Ven_20.OurID=r_Ours_56.OurID)
INNER JOIN r_Stocks r_Stocks_62 WITH(NOLOCK) ON (t_Ven_20.StockID=r_Stocks_62.StockID)
INNER JOIN av_t_VenA t_VenA_21 WITH(NOLOCK) ON (t_Ven_20.ChID=t_VenA_21.ChID)
INNER JOIN r_StockGs r_StockGs_240 WITH(NOLOCK) ON (r_Stocks_62.StockGID=r_StockGs_240.StockGID)
INNER JOIN av_t_VenD t_VenD_22 WITH(NOLOCK) ON (t_VenA_21.ChID=t_VenD_22.ChID AND t_VenA_21.ProdID=t_VenD_22.DetProdID)
INNER JOIN t_PInP t_PInP_151 WITH(NOLOCK) ON (t_VenD_22.PPID=t_PInP_151.PPID AND t_VenD_22.DetProdID=t_PInP_151.ProdID)
INNER JOIN r_Prods r_Prods_152 WITH(NOLOCK) ON (t_PInP_151.ProdID=r_Prods_152.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_299 WITH(NOLOCK) ON (r_Prods_152.PGrID4=at_r_ProdG4_299.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_300 WITH(NOLOCK) ON (r_Prods_152.PGrID5=at_r_ProdG5_300.PGrID5)
INNER JOIN r_ProdA r_ProdA_227 WITH(NOLOCK) ON (r_Prods_152.PGrAID=r_ProdA_227.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_158 WITH(NOLOCK) ON (r_Prods_152.PBGrID=r_ProdBG_158.PBGrID)
INNER JOIN r_ProdC r_ProdC_153 WITH(NOLOCK) ON (r_Prods_152.PCatID=r_ProdC_153.PCatID)
INNER JOIN r_ProdG r_ProdG_154 WITH(NOLOCK) ON (r_Prods_152.PGrID=r_ProdG_154.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_155 WITH(NOLOCK) ON (r_Prods_152.PGrID1=r_ProdG1_155.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_156 WITH(NOLOCK) ON (r_Prods_152.PGrID2=r_ProdG2_156.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_157 WITH(NOLOCK) ON (r_Prods_152.PGrID3=r_ProdG3_157.PGrID3)
  WHERE  ((r_Prods_152.PGrID1 = 27) OR (r_Prods_152.PGrID1 = 28) OR (r_Prods_152.PGrID1 = 29) OR (r_Prods_152.PGrID1 = 63)) AND ((r_Prods_152.PCatID BETWEEN 1 AND 100)) AND ((t_Ven_20.StockID = 4) OR (t_Ven_20.StockID = 304))
  AND (t_Ven_20.DocDate < '20190501') GROUP BY t_Ven_20.OurID, r_Ours_56.OurName, t_Ven_20.StockID, r_Stocks_62.StockName, r_Stocks_62.StockGID, r_StockGs_240.StockGName, t_Ven_20.CodeID1, r_Codes1_57.CodeName1, t_Ven_20.CodeID2, r_Codes2_58.CodeName2, t_Ven_20.CodeID3, r_Codes3_59.CodeName3, t_Ven_20.CodeID4, r_Codes4_60.CodeName4, t_Ven_20.CodeID5, r_Codes5_61.CodeName5, r_Prods_152.Country, r_Prods_152.PBGrID, r_ProdBG_158.PBGrName, r_Prods_152.PCatID, r_ProdC_153.PCatName, r_Prods_152.PGrID, r_ProdG_154.PGrName, r_Prods_152.PGrID1, r_ProdG1_155.PGrName1, r_Prods_152.PGrID2, r_ProdG2_156.PGrName2, r_Prods_152.PGrID3, r_ProdG3_157.PGrName3, r_Prods_152.PGrAID, r_ProdA_227.PGrAName, t_VenA_21.ProdID, r_Prods_152.ProdName, r_Prods_152.Notes, r_Prods_152.Article1, r_Prods_152.Article2, r_Prods_152.Article3, r_Prods_152.PGrID4, r_Prods_152.PGrID5, at_r_ProdG4_299.PGrName4, at_r_ProdG5_300.PGrName5, t_PInP_151.ProdBarCode


-->>> На начало - Переоценка цен прихода (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Est_23.OurID, r_Ours_77.OurName, t_Est_23.StockID, r_Stocks_83.StockName StockName, r_Stocks_83.StockGID, r_StockGs_243.StockGName, t_Est_23.CodeID1, r_Codes1_78.CodeName1, t_Est_23.CodeID2, r_Codes2_79.CodeName2, t_Est_23.CodeID3, r_Codes3_80.CodeName3, t_Est_23.CodeID4, r_Codes4_81.CodeName4, t_Est_23.CodeID5, r_Codes5_82.CodeName5, r_Prods_176.Country, r_Prods_176.PBGrID, r_ProdBG_182.PBGrName, r_Prods_176.PCatID, r_ProdC_177.PCatName, r_Prods_176.PGrID, r_ProdG_178.PGrName, r_Prods_176.PGrID1, r_ProdG1_179.PGrName1, r_Prods_176.PGrID2, r_ProdG2_180.PGrName2, r_Prods_176.PGrID3, r_ProdG3_181.PGrName3, r_Prods_176.PGrAID, r_ProdA_230.PGrAName, t_EstD_24.ProdID, r_Prods_176.ProdName, r_Prods_176.Notes, r_Prods_176.Article1, r_Prods_176.Article2, r_Prods_176.Article3, r_Prods_176.PGrID4, r_Prods_176.PGrID5, at_r_ProdG4_305.PGrName4, at_r_ProdG5_306.PGrName5, t_PInP_175.ProdBarCode ProdBarCode, '               На начало', SUM(t_EstD_24.Qty) SumQty, SUM(t_EstD_24.Qty * t_PInP_175.CostMC) CostSum FROM av_t_Est t_Est_23 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_78 WITH(NOLOCK) ON (t_Est_23.CodeID1=r_Codes1_78.CodeID1)
INNER JOIN r_Codes2 r_Codes2_79 WITH(NOLOCK) ON (t_Est_23.CodeID2=r_Codes2_79.CodeID2)
INNER JOIN r_Codes3 r_Codes3_80 WITH(NOLOCK) ON (t_Est_23.CodeID3=r_Codes3_80.CodeID3)
INNER JOIN r_Codes4 r_Codes4_81 WITH(NOLOCK) ON (t_Est_23.CodeID4=r_Codes4_81.CodeID4)
INNER JOIN r_Codes5 r_Codes5_82 WITH(NOLOCK) ON (t_Est_23.CodeID5=r_Codes5_82.CodeID5)
INNER JOIN r_Ours r_Ours_77 WITH(NOLOCK) ON (t_Est_23.OurID=r_Ours_77.OurID)
INNER JOIN r_Stocks r_Stocks_83 WITH(NOLOCK) ON (t_Est_23.StockID=r_Stocks_83.StockID)
INNER JOIN av_t_EstD t_EstD_24 WITH(NOLOCK) ON (t_Est_23.ChID=t_EstD_24.ChID)
INNER JOIN r_StockGs r_StockGs_243 WITH(NOLOCK) ON (r_Stocks_83.StockGID=r_StockGs_243.StockGID)
INNER JOIN t_PInP t_PInP_175 WITH(NOLOCK) ON (t_EstD_24.NewPPID=t_PInP_175.PPID AND t_EstD_24.ProdID=t_PInP_175.ProdID)
INNER JOIN r_Prods r_Prods_176 WITH(NOLOCK) ON (t_PInP_175.ProdID=r_Prods_176.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_305 WITH(NOLOCK) ON (r_Prods_176.PGrID4=at_r_ProdG4_305.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_306 WITH(NOLOCK) ON (r_Prods_176.PGrID5=at_r_ProdG5_306.PGrID5)
INNER JOIN r_ProdA r_ProdA_230 WITH(NOLOCK) ON (r_Prods_176.PGrAID=r_ProdA_230.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_182 WITH(NOLOCK) ON (r_Prods_176.PBGrID=r_ProdBG_182.PBGrID)
INNER JOIN r_ProdC r_ProdC_177 WITH(NOLOCK) ON (r_Prods_176.PCatID=r_ProdC_177.PCatID)
INNER JOIN r_ProdG r_ProdG_178 WITH(NOLOCK) ON (r_Prods_176.PGrID=r_ProdG_178.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_179 WITH(NOLOCK) ON (r_Prods_176.PGrID1=r_ProdG1_179.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_180 WITH(NOLOCK) ON (r_Prods_176.PGrID2=r_ProdG2_180.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_181 WITH(NOLOCK) ON (r_Prods_176.PGrID3=r_ProdG3_181.PGrID3)
  WHERE  ((r_Prods_176.PGrID1 = 27) OR (r_Prods_176.PGrID1 = 28) OR (r_Prods_176.PGrID1 = 29) OR (r_Prods_176.PGrID1 = 63)) AND ((r_Prods_176.PCatID BETWEEN 1 AND 100)) AND ((t_Est_23.StockID = 4) OR (t_Est_23.StockID = 304))
  AND (t_Est_23.DocDate < '20190501') GROUP BY t_Est_23.OurID, r_Ours_77.OurName, t_Est_23.StockID, r_Stocks_83.StockName, r_Stocks_83.StockGID, r_StockGs_243.StockGName, t_Est_23.CodeID1, r_Codes1_78.CodeName1, t_Est_23.CodeID2, r_Codes2_79.CodeName2, t_Est_23.CodeID3, r_Codes3_80.CodeName3, t_Est_23.CodeID4, r_Codes4_81.CodeName4, t_Est_23.CodeID5, r_Codes5_82.CodeName5, r_Prods_176.Country, r_Prods_176.PBGrID, r_ProdBG_182.PBGrName, r_Prods_176.PCatID, r_ProdC_177.PCatName, r_Prods_176.PGrID, r_ProdG_178.PGrName, r_Prods_176.PGrID1, r_ProdG1_179.PGrName1, r_Prods_176.PGrID2, r_ProdG2_180.PGrName2, r_Prods_176.PGrID3, r_ProdG3_181.PGrName3, r_Prods_176.PGrAID, r_ProdA_230.PGrAName, t_EstD_24.ProdID, r_Prods_176.ProdName, r_Prods_176.Notes, r_Prods_176.Article1, r_Prods_176.Article2, r_Prods_176.Article3, r_Prods_176.PGrID4, r_Prods_176.PGrID5, at_r_ProdG4_305.PGrName4, at_r_ProdG5_306.PGrName5, t_PInP_175.ProdBarCode


-->>> На начало - Переоценка цен прихода (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Est_25.OurID, r_Ours_84.OurName, t_Est_25.StockID, r_Stocks_90.StockName StockName, r_Stocks_90.StockGID, r_StockGs_244.StockGName, t_Est_25.CodeID1, r_Codes1_85.CodeName1, t_Est_25.CodeID2, r_Codes2_86.CodeName2, t_Est_25.CodeID3, r_Codes3_87.CodeName3, t_Est_25.CodeID4, r_Codes4_88.CodeName4, t_Est_25.CodeID5, r_Codes5_89.CodeName5, r_Prods_184.Country, r_Prods_184.PBGrID, r_ProdBG_190.PBGrName, r_Prods_184.PCatID, r_ProdC_185.PCatName, r_Prods_184.PGrID, r_ProdG_186.PGrName, r_Prods_184.PGrID1, r_ProdG1_187.PGrName1, r_Prods_184.PGrID2, r_ProdG2_188.PGrName2, r_Prods_184.PGrID3, r_ProdG3_189.PGrName3, r_Prods_184.PGrAID, r_ProdA_231.PGrAName, t_EstD_26.ProdID, r_Prods_184.ProdName, r_Prods_184.Notes, r_Prods_184.Article1, r_Prods_184.Article2, r_Prods_184.Article3, r_Prods_184.PGrID4, r_Prods_184.PGrID5, at_r_ProdG4_307.PGrName4, at_r_ProdG5_308.PGrName5, t_PInP_183.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_EstD_26.Qty)) SumQty, SUM(0-(t_EstD_26.Qty * t_PInP_183.CostMC)) CostSum FROM av_t_Est t_Est_25 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_85 WITH(NOLOCK) ON (t_Est_25.CodeID1=r_Codes1_85.CodeID1)
INNER JOIN r_Codes2 r_Codes2_86 WITH(NOLOCK) ON (t_Est_25.CodeID2=r_Codes2_86.CodeID2)
INNER JOIN r_Codes3 r_Codes3_87 WITH(NOLOCK) ON (t_Est_25.CodeID3=r_Codes3_87.CodeID3)
INNER JOIN r_Codes4 r_Codes4_88 WITH(NOLOCK) ON (t_Est_25.CodeID4=r_Codes4_88.CodeID4)
INNER JOIN r_Codes5 r_Codes5_89 WITH(NOLOCK) ON (t_Est_25.CodeID5=r_Codes5_89.CodeID5)
INNER JOIN r_Ours r_Ours_84 WITH(NOLOCK) ON (t_Est_25.OurID=r_Ours_84.OurID)
INNER JOIN r_Stocks r_Stocks_90 WITH(NOLOCK) ON (t_Est_25.StockID=r_Stocks_90.StockID)
INNER JOIN av_t_EstD t_EstD_26 WITH(NOLOCK) ON (t_Est_25.ChID=t_EstD_26.ChID)
INNER JOIN r_StockGs r_StockGs_244 WITH(NOLOCK) ON (r_Stocks_90.StockGID=r_StockGs_244.StockGID)
INNER JOIN t_PInP t_PInP_183 WITH(NOLOCK) ON (t_EstD_26.PPID=t_PInP_183.PPID AND t_EstD_26.ProdID=t_PInP_183.ProdID)
INNER JOIN r_Prods r_Prods_184 WITH(NOLOCK) ON (t_PInP_183.ProdID=r_Prods_184.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_307 WITH(NOLOCK) ON (r_Prods_184.PGrID4=at_r_ProdG4_307.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_308 WITH(NOLOCK) ON (r_Prods_184.PGrID5=at_r_ProdG5_308.PGrID5)
INNER JOIN r_ProdA r_ProdA_231 WITH(NOLOCK) ON (r_Prods_184.PGrAID=r_ProdA_231.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_190 WITH(NOLOCK) ON (r_Prods_184.PBGrID=r_ProdBG_190.PBGrID)
INNER JOIN r_ProdC r_ProdC_185 WITH(NOLOCK) ON (r_Prods_184.PCatID=r_ProdC_185.PCatID)
INNER JOIN r_ProdG r_ProdG_186 WITH(NOLOCK) ON (r_Prods_184.PGrID=r_ProdG_186.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_187 WITH(NOLOCK) ON (r_Prods_184.PGrID1=r_ProdG1_187.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_188 WITH(NOLOCK) ON (r_Prods_184.PGrID2=r_ProdG2_188.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_189 WITH(NOLOCK) ON (r_Prods_184.PGrID3=r_ProdG3_189.PGrID3)
  WHERE  ((r_Prods_184.PGrID1 = 27) OR (r_Prods_184.PGrID1 = 28) OR (r_Prods_184.PGrID1 = 29) OR (r_Prods_184.PGrID1 = 63)) AND ((r_Prods_184.PCatID BETWEEN 1 AND 100)) AND ((t_Est_25.StockID = 4) OR (t_Est_25.StockID = 304))
  AND (t_Est_25.DocDate < '20190501') GROUP BY t_Est_25.OurID, r_Ours_84.OurName, t_Est_25.StockID, r_Stocks_90.StockName, r_Stocks_90.StockGID, r_StockGs_244.StockGName, t_Est_25.CodeID1, r_Codes1_85.CodeName1, t_Est_25.CodeID2, r_Codes2_86.CodeName2, t_Est_25.CodeID3, r_Codes3_87.CodeName3, t_Est_25.CodeID4, r_Codes4_88.CodeName4, t_Est_25.CodeID5, r_Codes5_89.CodeName5, r_Prods_184.Country, r_Prods_184.PBGrID, r_ProdBG_190.PBGrName, r_Prods_184.PCatID, r_ProdC_185.PCatName, r_Prods_184.PGrID, r_ProdG_186.PGrName, r_Prods_184.PGrID1, r_ProdG1_187.PGrName1, r_Prods_184.PGrID2, r_ProdG2_188.PGrName2, r_Prods_184.PGrID3, r_ProdG3_189.PGrName3, r_Prods_184.PGrAID, r_ProdA_231.PGrAName, t_EstD_26.ProdID, r_Prods_184.ProdName, r_Prods_184.Notes, r_Prods_184.Article1, r_Prods_184.Article2, r_Prods_184.Article3, r_Prods_184.PGrID4, r_Prods_184.PGrID5, at_r_ProdG4_307.PGrName4, at_r_ProdG5_308.PGrName5, t_PInP_183.ProdBarCode


-->>> На начало - Входящие остатки товара:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_zInP_27.OurID, r_Ours_42.OurName, t_zInP_27.StockID, r_Stocks_48.StockName StockName, r_Stocks_48.StockGID, r_StockGs_238.StockGName, t_zInP_27.CodeID1, r_Codes1_43.CodeName1, t_zInP_27.CodeID2, r_Codes2_44.CodeName2, t_zInP_27.CodeID3, r_Codes3_45.CodeName3, t_zInP_27.CodeID4, r_Codes4_46.CodeName4, t_zInP_27.CodeID5, r_Codes5_47.CodeName5, r_Prods_136.Country, r_Prods_136.PBGrID, r_ProdBG_142.PBGrName, r_Prods_136.PCatID, r_ProdC_137.PCatName, r_Prods_136.PGrID, r_ProdG_138.PGrName, r_Prods_136.PGrID1, r_ProdG1_139.PGrName1, r_Prods_136.PGrID2, r_ProdG2_140.PGrName2, r_Prods_136.PGrID3, r_ProdG3_141.PGrName3, r_Prods_136.PGrAID, r_ProdA_225.PGrAName, t_zInP_27.ProdID, r_Prods_136.ProdName, r_Prods_136.Notes, r_Prods_136.Article1, r_Prods_136.Article2, r_Prods_136.Article3, r_Prods_136.PGrID4, r_Prods_136.PGrID5, at_r_ProdG4_295.PGrName4, at_r_ProdG5_296.PGrName5, t_PInP_135.ProdBarCode ProdBarCode, '               На начало', SUM(t_zInP_27.Qty) SumQty, SUM(t_zInP_27.Qty * t_PInP_135.CostMC) CostSum FROM av_t_zInP t_zInP_27 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_43 WITH(NOLOCK) ON (t_zInP_27.CodeID1=r_Codes1_43.CodeID1)
INNER JOIN r_Codes2 r_Codes2_44 WITH(NOLOCK) ON (t_zInP_27.CodeID2=r_Codes2_44.CodeID2)
INNER JOIN r_Codes3 r_Codes3_45 WITH(NOLOCK) ON (t_zInP_27.CodeID3=r_Codes3_45.CodeID3)
INNER JOIN r_Codes4 r_Codes4_46 WITH(NOLOCK) ON (t_zInP_27.CodeID4=r_Codes4_46.CodeID4)
INNER JOIN r_Codes5 r_Codes5_47 WITH(NOLOCK) ON (t_zInP_27.CodeID5=r_Codes5_47.CodeID5)
INNER JOIN r_Ours r_Ours_42 WITH(NOLOCK) ON (t_zInP_27.OurID=r_Ours_42.OurID)
INNER JOIN r_Stocks r_Stocks_48 WITH(NOLOCK) ON (t_zInP_27.StockID=r_Stocks_48.StockID)
INNER JOIN t_PInP t_PInP_135 WITH(NOLOCK) ON (t_zInP_27.PPID=t_PInP_135.PPID AND t_zInP_27.ProdID=t_PInP_135.ProdID)
INNER JOIN r_StockGs r_StockGs_238 WITH(NOLOCK) ON (r_Stocks_48.StockGID=r_StockGs_238.StockGID)
INNER JOIN r_Prods r_Prods_136 WITH(NOLOCK) ON (t_PInP_135.ProdID=r_Prods_136.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_295 WITH(NOLOCK) ON (r_Prods_136.PGrID4=at_r_ProdG4_295.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_296 WITH(NOLOCK) ON (r_Prods_136.PGrID5=at_r_ProdG5_296.PGrID5)
INNER JOIN r_ProdA r_ProdA_225 WITH(NOLOCK) ON (r_Prods_136.PGrAID=r_ProdA_225.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_142 WITH(NOLOCK) ON (r_Prods_136.PBGrID=r_ProdBG_142.PBGrID)
INNER JOIN r_ProdC r_ProdC_137 WITH(NOLOCK) ON (r_Prods_136.PCatID=r_ProdC_137.PCatID)
INNER JOIN r_ProdG r_ProdG_138 WITH(NOLOCK) ON (r_Prods_136.PGrID=r_ProdG_138.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_139 WITH(NOLOCK) ON (r_Prods_136.PGrID1=r_ProdG1_139.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_140 WITH(NOLOCK) ON (r_Prods_136.PGrID2=r_ProdG2_140.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_141 WITH(NOLOCK) ON (r_Prods_136.PGrID3=r_ProdG3_141.PGrID3)
  WHERE  ((r_Prods_136.PGrID1 = 27) OR (r_Prods_136.PGrID1 = 28) OR (r_Prods_136.PGrID1 = 29) OR (r_Prods_136.PGrID1 = 63)) AND ((r_Prods_136.PCatID BETWEEN 1 AND 100)) AND ((t_zInP_27.StockID = 4) OR (t_zInP_27.StockID = 304))
  GROUP BY t_zInP_27.OurID, r_Ours_42.OurName, t_zInP_27.StockID, r_Stocks_48.StockName, r_Stocks_48.StockGID, r_StockGs_238.StockGName, t_zInP_27.CodeID1, r_Codes1_43.CodeName1, t_zInP_27.CodeID2, r_Codes2_44.CodeName2, t_zInP_27.CodeID3, r_Codes3_45.CodeName3, t_zInP_27.CodeID4, r_Codes4_46.CodeName4, t_zInP_27.CodeID5, r_Codes5_47.CodeName5, r_Prods_136.Country, r_Prods_136.PBGrID, r_ProdBG_142.PBGrName, r_Prods_136.PCatID, r_ProdC_137.PCatName, r_Prods_136.PGrID, r_ProdG_138.PGrName, r_Prods_136.PGrID1, r_ProdG1_139.PGrName1, r_Prods_136.PGrID2, r_ProdG2_140.PGrName2, r_Prods_136.PGrID3, r_ProdG3_141.PGrName3, r_Prods_136.PGrAID, r_ProdA_225.PGrAName, t_zInP_27.ProdID, r_Prods_136.ProdName, r_Prods_136.Notes, r_Prods_136.Article1, r_Prods_136.Article2, r_Prods_136.Article3, r_Prods_136.PGrID4, r_Prods_136.PGrID5, at_r_ProdG4_295.PGrName4, at_r_ProdG5_296.PGrName5, t_PInP_135.ProdBarCode


-->>> На начало - Возврат товара по чеку:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_CRRet_249.OurID, r_Ours_265.OurName, t_CRRet_249.StockID, r_Stocks_271.StockName StockName, r_Stocks_271.StockGID, r_StockGs_272.StockGName, t_CRRet_249.CodeID1, r_Codes1_266.CodeName1, t_CRRet_249.CodeID2, r_Codes2_267.CodeName2, t_CRRet_249.CodeID3, r_Codes3_268.CodeName3, t_CRRet_249.CodeID4, r_Codes4_269.CodeName4, t_CRRet_249.CodeID5, r_Codes5_270.CodeName5, r_Prods_257.Country, r_Prods_257.PBGrID, r_ProdBG_264.PBGrName, r_Prods_257.PCatID, r_ProdC_258.PCatName, r_Prods_257.PGrID, r_ProdG_259.PGrName, r_Prods_257.PGrID1, r_ProdG1_260.PGrName1, r_Prods_257.PGrID2, r_ProdG2_261.PGrName2, r_Prods_257.PGrID3, r_ProdG3_262.PGrName3, r_Prods_257.PGrAID, r_ProdA_263.PGrAName, r_Prods_257.ProdID, r_Prods_257.ProdName, r_Prods_257.Notes, r_Prods_257.Article1, r_Prods_257.Article2, r_Prods_257.Article3, r_Prods_257.PGrID4, r_Prods_257.PGrID5, at_r_ProdG4_291.PGrName4, at_r_ProdG5_292.PGrName5, t_PInP_255.ProdBarCode ProdBarCode, '               На начало', SUM(t_CRRetD_250.Qty) SumQty, SUM(t_CRRetD_250.Qty * t_PInP_255.CostMC) CostSum FROM av_t_CRRet t_CRRet_249 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_266 WITH(NOLOCK) ON (t_CRRet_249.CodeID1=r_Codes1_266.CodeID1)
INNER JOIN r_Codes2 r_Codes2_267 WITH(NOLOCK) ON (t_CRRet_249.CodeID2=r_Codes2_267.CodeID2)
INNER JOIN r_Codes3 r_Codes3_268 WITH(NOLOCK) ON (t_CRRet_249.CodeID3=r_Codes3_268.CodeID3)
INNER JOIN r_Codes4 r_Codes4_269 WITH(NOLOCK) ON (t_CRRet_249.CodeID4=r_Codes4_269.CodeID4)
INNER JOIN r_Codes5 r_Codes5_270 WITH(NOLOCK) ON (t_CRRet_249.CodeID5=r_Codes5_270.CodeID5)
INNER JOIN r_Ours r_Ours_265 WITH(NOLOCK) ON (t_CRRet_249.OurID=r_Ours_265.OurID)
INNER JOIN r_Stocks r_Stocks_271 WITH(NOLOCK) ON (t_CRRet_249.StockID=r_Stocks_271.StockID)
INNER JOIN av_t_CRRetD t_CRRetD_250 WITH(NOLOCK) ON (t_CRRet_249.ChID=t_CRRetD_250.ChID)
INNER JOIN r_StockGs r_StockGs_272 WITH(NOLOCK) ON (r_Stocks_271.StockGID=r_StockGs_272.StockGID)
INNER JOIN t_PInP t_PInP_255 WITH(NOLOCK) ON (t_CRRetD_250.PPID=t_PInP_255.PPID AND t_CRRetD_250.ProdID=t_PInP_255.ProdID)
INNER JOIN r_Prods r_Prods_257 WITH(NOLOCK) ON (t_PInP_255.ProdID=r_Prods_257.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_291 WITH(NOLOCK) ON (r_Prods_257.PGrID4=at_r_ProdG4_291.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_292 WITH(NOLOCK) ON (r_Prods_257.PGrID5=at_r_ProdG5_292.PGrID5)
INNER JOIN r_ProdA r_ProdA_263 WITH(NOLOCK) ON (r_Prods_257.PGrAID=r_ProdA_263.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_264 WITH(NOLOCK) ON (r_Prods_257.PBGrID=r_ProdBG_264.PBGrID)
INNER JOIN r_ProdC r_ProdC_258 WITH(NOLOCK) ON (r_Prods_257.PCatID=r_ProdC_258.PCatID)
INNER JOIN r_ProdG r_ProdG_259 WITH(NOLOCK) ON (r_Prods_257.PGrID=r_ProdG_259.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_260 WITH(NOLOCK) ON (r_Prods_257.PGrID1=r_ProdG1_260.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_261 WITH(NOLOCK) ON (r_Prods_257.PGrID2=r_ProdG2_261.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_262 WITH(NOLOCK) ON (r_Prods_257.PGrID3=r_ProdG3_262.PGrID3)
  WHERE  ((r_Prods_257.PGrID1 = 27) OR (r_Prods_257.PGrID1 = 28) OR (r_Prods_257.PGrID1 = 29) OR (r_Prods_257.PGrID1 = 63)) AND ((r_Prods_257.PCatID BETWEEN 1 AND 100)) AND ((t_CRRet_249.StockID = 4) OR (t_CRRet_249.StockID = 304)) AND (t_CRRet_249.DocDate < '20190501') GROUP BY t_CRRet_249.OurID, r_Ours_265.OurName, t_CRRet_249.StockID, r_Stocks_271.StockName, r_Stocks_271.StockGID, r_StockGs_272.StockGName, t_CRRet_249.CodeID1, r_Codes1_266.CodeName1, t_CRRet_249.CodeID2, r_Codes2_267.CodeName2, t_CRRet_249.CodeID3, r_Codes3_268.CodeName3, t_CRRet_249.CodeID4, r_Codes4_269.CodeName4, t_CRRet_249.CodeID5, r_Codes5_270.CodeName5, r_Prods_257.Country, r_Prods_257.PBGrID, r_ProdBG_264.PBGrName, r_Prods_257.PCatID, r_ProdC_258.PCatName, r_Prods_257.PGrID, r_ProdG_259.PGrName, r_Prods_257.PGrID1, r_ProdG1_260.PGrName1, r_Prods_257.PGrID2, r_ProdG2_261.PGrName2, r_Prods_257.PGrID3, r_ProdG3_262.PGrName3, r_Prods_257.PGrAID, r_ProdA_263.PGrAName, r_Prods_257.ProdID, r_Prods_257.ProdName, r_Prods_257.Notes, r_Prods_257.Article1, r_Prods_257.Article2, r_Prods_257.Article3, r_Prods_257.PGrID4, r_Prods_257.PGrID5, at_r_ProdG4_291.PGrName4, at_r_ProdG5_292.PGrName5, t_PInP_255.ProdBarCode


-->>> На начало - Продажа товара оператором:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Sale_251.OurID, r_Ours_287.OurName, t_Sale_251.StockID, r_Stocks_286.StockName StockName, r_Stocks_286.StockGID, r_StockGs_288.StockGName, t_Sale_251.CodeID1, r_Codes1_281.CodeName1, t_Sale_251.CodeID2, r_Codes2_282.CodeName2, t_Sale_251.CodeID3, r_Codes3_283.CodeName3, t_Sale_251.CodeID4, r_Codes4_284.CodeName4, t_Sale_251.CodeID5, r_Codes5_285.CodeName5, r_Prods_273.Country, r_Prods_273.PBGrID, r_ProdBG_280.PBGrName, r_Prods_273.PCatID, r_ProdC_274.PCatName, r_Prods_273.PGrID, r_ProdG_275.PGrName, r_Prods_273.PGrID1, r_ProdG1_276.PGrName1, r_Prods_273.PGrID2, r_ProdG2_277.PGrName2, r_Prods_273.PGrID3, r_ProdG3_278.PGrName3, r_Prods_273.PGrAID, r_ProdA_279.PGrAName, r_Prods_273.ProdID, r_Prods_273.ProdName, r_Prods_273.Notes, r_Prods_273.Article1, r_Prods_273.Article2, r_Prods_273.Article3, r_Prods_273.PGrID4, r_Prods_273.PGrID5, at_r_ProdG4_311.PGrName4, at_r_ProdG5_312.PGrName5, t_PInP_256.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_SaleD_252.Qty)) SumQty, SUM(0-(t_SaleD_252.Qty * t_PInP_256.CostMC)) CostSum FROM av_t_Sale t_Sale_251 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_281 WITH(NOLOCK) ON (t_Sale_251.CodeID1=r_Codes1_281.CodeID1)
INNER JOIN r_Codes2 r_Codes2_282 WITH(NOLOCK) ON (t_Sale_251.CodeID2=r_Codes2_282.CodeID2)
INNER JOIN r_Codes3 r_Codes3_283 WITH(NOLOCK) ON (t_Sale_251.CodeID3=r_Codes3_283.CodeID3)
INNER JOIN r_Codes4 r_Codes4_284 WITH(NOLOCK) ON (t_Sale_251.CodeID4=r_Codes4_284.CodeID4)
INNER JOIN r_Codes5 r_Codes5_285 WITH(NOLOCK) ON (t_Sale_251.CodeID5=r_Codes5_285.CodeID5)
INNER JOIN r_Ours r_Ours_287 WITH(NOLOCK) ON (t_Sale_251.OurID=r_Ours_287.OurID)
INNER JOIN r_Stocks r_Stocks_286 WITH(NOLOCK) ON (t_Sale_251.StockID=r_Stocks_286.StockID)
INNER JOIN av_t_SaleD t_SaleD_252 WITH(NOLOCK) ON (t_Sale_251.ChID=t_SaleD_252.ChID)
INNER JOIN r_StockGs r_StockGs_288 WITH(NOLOCK) ON (r_Stocks_286.StockGID=r_StockGs_288.StockGID)
INNER JOIN t_PInP t_PInP_256 WITH(NOLOCK) ON (t_SaleD_252.PPID=t_PInP_256.PPID AND t_SaleD_252.ProdID=t_PInP_256.ProdID)
INNER JOIN r_Prods r_Prods_273 WITH(NOLOCK) ON (t_PInP_256.ProdID=r_Prods_273.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_311 WITH(NOLOCK) ON (r_Prods_273.PGrID4=at_r_ProdG4_311.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_312 WITH(NOLOCK) ON (r_Prods_273.PGrID5=at_r_ProdG5_312.PGrID5)
INNER JOIN r_ProdA r_ProdA_279 WITH(NOLOCK) ON (r_Prods_273.PGrAID=r_ProdA_279.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_280 WITH(NOLOCK) ON (r_Prods_273.PBGrID=r_ProdBG_280.PBGrID)
INNER JOIN r_ProdC r_ProdC_274 WITH(NOLOCK) ON (r_Prods_273.PCatID=r_ProdC_274.PCatID)
INNER JOIN r_ProdG r_ProdG_275 WITH(NOLOCK) ON (r_Prods_273.PGrID=r_ProdG_275.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_276 WITH(NOLOCK) ON (r_Prods_273.PGrID1=r_ProdG1_276.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_277 WITH(NOLOCK) ON (r_Prods_273.PGrID2=r_ProdG2_277.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_278 WITH(NOLOCK) ON (r_Prods_273.PGrID3=r_ProdG3_278.PGrID3)
  WHERE  ((r_Prods_273.PGrID1 = 27) OR (r_Prods_273.PGrID1 = 28) OR (r_Prods_273.PGrID1 = 29) OR (r_Prods_273.PGrID1 = 63)) AND ((r_Prods_273.PCatID BETWEEN 1 AND 100)) AND ((t_Sale_251.StockID = 4) OR (t_Sale_251.StockID = 304)) AND (t_Sale_251.DocDate < '20190501') GROUP BY t_Sale_251.OurID, r_Ours_287.OurName, t_Sale_251.StockID, r_Stocks_286.StockName, r_Stocks_286.StockGID, r_StockGs_288.StockGName, t_Sale_251.CodeID1, r_Codes1_281.CodeName1, t_Sale_251.CodeID2, r_Codes2_282.CodeName2, t_Sale_251.CodeID3, r_Codes3_283.CodeName3, t_Sale_251.CodeID4, r_Codes4_284.CodeName4, t_Sale_251.CodeID5, r_Codes5_285.CodeName5, r_Prods_273.Country, r_Prods_273.PBGrID, r_ProdBG_280.PBGrName, r_Prods_273.PCatID, r_ProdC_274.PCatName, r_Prods_273.PGrID, r_ProdG_275.PGrName, r_Prods_273.PGrID1, r_ProdG1_276.PGrName1, r_Prods_273.PGrID2, r_ProdG2_277.PGrName2, r_Prods_273.PGrID3, r_ProdG3_278.PGrName3, r_Prods_273.PGrAID, r_ProdA_279.PGrAName, r_Prods_273.ProdID, r_Prods_273.ProdName, r_Prods_273.Notes, r_Prods_273.Article1, r_Prods_273.Article2, r_Prods_273.Article3, r_Prods_273.PGrID4, r_Prods_273.PGrID5, at_r_ProdG4_311.PGrName4, at_r_ProdG5_312.PGrName5, t_PInP_256.ProdBarCode


-->>> На начало - Комплектация товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_SRec_319.OurID, r_Ours_324.OurName, t_SRec_319.StockID, r_Stocks_330.StockName StockName, r_Stocks_330.StockGID, r_StockGs_331.StockGName, t_SRec_319.CodeID1, r_Codes1_325.CodeName1, t_SRec_319.CodeID2, r_Codes2_326.CodeName2, t_SRec_319.CodeID3, r_Codes3_327.CodeName3, t_SRec_319.CodeID4, r_Codes4_328.CodeName4, t_SRec_319.CodeID5, r_Codes5_329.CodeName5, r_Prods_333.Country, r_Prods_333.PBGrID, r_ProdBG_336.PBGrName, r_Prods_333.PCatID, r_ProdC_337.PCatName, r_Prods_333.PGrID, r_ProdG_334.PGrName, r_Prods_333.PGrID1, r_ProdG1_338.PGrName1, r_Prods_333.PGrID2, r_ProdG2_339.PGrName2, r_Prods_333.PGrID3, r_ProdG3_340.PGrName3, r_Prods_333.PGrAID, r_ProdA_335.PGrAName, t_SRecA_323.ProdID, r_Prods_333.ProdName, r_Prods_333.Notes, r_Prods_333.Article1, r_Prods_333.Article2, r_Prods_333.Article3, r_Prods_333.PGrID4, r_Prods_333.PGrID5, at_r_ProdG4_341.PGrName4, at_r_ProdG5_342.PGrName5, t_PInP_332.ProdBarCode ProdBarCode, '               На начало', SUM(t_SRecA_323.Qty) SumQty, SUM(t_SRecA_323.Qty * t_PInP_332.CostMC) CostSum FROM av_t_SRec t_SRec_319 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_325 WITH(NOLOCK) ON (t_SRec_319.CodeID1=r_Codes1_325.CodeID1)
INNER JOIN r_Codes2 r_Codes2_326 WITH(NOLOCK) ON (t_SRec_319.CodeID2=r_Codes2_326.CodeID2)
INNER JOIN r_Codes3 r_Codes3_327 WITH(NOLOCK) ON (t_SRec_319.CodeID3=r_Codes3_327.CodeID3)
INNER JOIN r_Codes4 r_Codes4_328 WITH(NOLOCK) ON (t_SRec_319.CodeID4=r_Codes4_328.CodeID4)
INNER JOIN r_Codes5 r_Codes5_329 WITH(NOLOCK) ON (t_SRec_319.CodeID5=r_Codes5_329.CodeID5)
INNER JOIN r_Ours r_Ours_324 WITH(NOLOCK) ON (t_SRec_319.OurID=r_Ours_324.OurID)
INNER JOIN r_Stocks r_Stocks_330 WITH(NOLOCK) ON (t_SRec_319.StockID=r_Stocks_330.StockID)
INNER JOIN av_t_SRecA t_SRecA_323 WITH(NOLOCK) ON (t_SRec_319.ChID=t_SRecA_323.ChID)
INNER JOIN r_StockGs r_StockGs_331 WITH(NOLOCK) ON (r_Stocks_330.StockGID=r_StockGs_331.StockGID)
INNER JOIN t_PInP t_PInP_332 WITH(NOLOCK) ON (t_SRecA_323.PPID=t_PInP_332.PPID AND t_SRecA_323.ProdID=t_PInP_332.ProdID)
INNER JOIN r_Prods r_Prods_333 WITH(NOLOCK) ON (t_PInP_332.ProdID=r_Prods_333.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_341 WITH(NOLOCK) ON (r_Prods_333.PGrID4=at_r_ProdG4_341.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_342 WITH(NOLOCK) ON (r_Prods_333.PGrID5=at_r_ProdG5_342.PGrID5)
INNER JOIN r_ProdA r_ProdA_335 WITH(NOLOCK) ON (r_Prods_333.PGrAID=r_ProdA_335.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_336 WITH(NOLOCK) ON (r_Prods_333.PBGrID=r_ProdBG_336.PBGrID)
INNER JOIN r_ProdC r_ProdC_337 WITH(NOLOCK) ON (r_Prods_333.PCatID=r_ProdC_337.PCatID)
INNER JOIN r_ProdG r_ProdG_334 WITH(NOLOCK) ON (r_Prods_333.PGrID=r_ProdG_334.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_338 WITH(NOLOCK) ON (r_Prods_333.PGrID1=r_ProdG1_338.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_339 WITH(NOLOCK) ON (r_Prods_333.PGrID2=r_ProdG2_339.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_340 WITH(NOLOCK) ON (r_Prods_333.PGrID3=r_ProdG3_340.PGrID3)
  WHERE  ((r_Prods_333.PGrID1 = 27) OR (r_Prods_333.PGrID1 = 28) OR (r_Prods_333.PGrID1 = 29) OR (r_Prods_333.PGrID1 = 63)) AND ((r_Prods_333.PCatID BETWEEN 1 AND 100)) AND ((t_SRec_319.StockID = 4) OR (t_SRec_319.StockID = 304)) AND (t_SRec_319.DocDate < '20190501') GROUP BY t_SRec_319.OurID, r_Ours_324.OurName, t_SRec_319.StockID, r_Stocks_330.StockName, r_Stocks_330.StockGID, r_StockGs_331.StockGName, t_SRec_319.CodeID1, r_Codes1_325.CodeName1, t_SRec_319.CodeID2, r_Codes2_326.CodeName2, t_SRec_319.CodeID3, r_Codes3_327.CodeName3, t_SRec_319.CodeID4, r_Codes4_328.CodeName4, t_SRec_319.CodeID5, r_Codes5_329.CodeName5, r_Prods_333.Country, r_Prods_333.PBGrID, r_ProdBG_336.PBGrName, r_Prods_333.PCatID, r_ProdC_337.PCatName, r_Prods_333.PGrID, r_ProdG_334.PGrName, r_Prods_333.PGrID1, r_ProdG1_338.PGrName1, r_Prods_333.PGrID2, r_ProdG2_339.PGrName2, r_Prods_333.PGrID3, r_ProdG3_340.PGrName3, r_Prods_333.PGrAID, r_ProdA_335.PGrAName, t_SRecA_323.ProdID, r_Prods_333.ProdName, r_Prods_333.Notes, r_Prods_333.Article1, r_Prods_333.Article2, r_Prods_333.Article3, r_Prods_333.PGrID4, r_Prods_333.PGrID5, at_r_ProdG4_341.PGrName4, at_r_ProdG5_342.PGrName5, t_PInP_332.ProdBarCode


-->>> На начало - Комплектация товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_SRec_320.OurID, r_Ours_344.OurName, t_SRec_320.StockID, r_Stocks_350.StockName StockName, r_Stocks_350.StockGID, r_StockGs_351.StockGName, t_SRec_320.CodeID1, r_Codes1_345.CodeName1, t_SRec_320.CodeID2, r_Codes2_346.CodeName2, t_SRec_320.CodeID3, r_Codes3_347.CodeName3, t_SRec_320.CodeID4, r_Codes4_348.CodeName4, t_SRec_320.CodeID5, r_Codes5_349.CodeName5, r_Prods_354.Country, r_Prods_354.PBGrID, r_ProdBG_357.PBGrName, r_Prods_354.PCatID, r_ProdC_358.PCatName, r_Prods_354.PGrID, r_ProdG_355.PGrName, r_Prods_354.PGrID1, r_ProdG1_359.PGrName1, r_Prods_354.PGrID2, r_ProdG2_360.PGrName2, r_Prods_354.PGrID3, r_ProdG3_361.PGrName3, r_Prods_354.PGrAID, r_ProdA_356.PGrAName, t_SRecD_352.SubProdID, r_Prods_354.ProdName, r_Prods_354.Notes, r_Prods_354.Article1, r_Prods_354.Article2, r_Prods_354.Article3, r_Prods_354.PGrID4, r_Prods_354.PGrID5, at_r_ProdG4_362.PGrName4, at_r_ProdG5_363.PGrName5, t_PInP_353.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_SRecD_352.SubQty)) SumQty, SUM(0-(t_SRecD_352.SubQty * t_PInP_353.CostMC)) CostSum FROM av_t_SRec t_SRec_320 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_345 WITH(NOLOCK) ON (t_SRec_320.CodeID1=r_Codes1_345.CodeID1)
INNER JOIN r_Codes2 r_Codes2_346 WITH(NOLOCK) ON (t_SRec_320.CodeID2=r_Codes2_346.CodeID2)
INNER JOIN r_Codes3 r_Codes3_347 WITH(NOLOCK) ON (t_SRec_320.CodeID3=r_Codes3_347.CodeID3)
INNER JOIN r_Codes4 r_Codes4_348 WITH(NOLOCK) ON (t_SRec_320.CodeID4=r_Codes4_348.CodeID4)
INNER JOIN r_Codes5 r_Codes5_349 WITH(NOLOCK) ON (t_SRec_320.CodeID5=r_Codes5_349.CodeID5)
INNER JOIN r_Ours r_Ours_344 WITH(NOLOCK) ON (t_SRec_320.OurID=r_Ours_344.OurID)
INNER JOIN r_Stocks r_Stocks_350 WITH(NOLOCK) ON (t_SRec_320.StockID=r_Stocks_350.StockID)
INNER JOIN av_t_SRecA t_SRecA_343 WITH(NOLOCK) ON (t_SRec_320.ChID=t_SRecA_343.ChID)
INNER JOIN r_StockGs r_StockGs_351 WITH(NOLOCK) ON (r_Stocks_350.StockGID=r_StockGs_351.StockGID)
INNER JOIN av_t_SRecD t_SRecD_352 WITH(NOLOCK) ON (t_SRecA_343.AChID=t_SRecD_352.AChID)
INNER JOIN t_PInP t_PInP_353 WITH(NOLOCK) ON (t_SRecD_352.SubPPID=t_PInP_353.PPID AND t_SRecD_352.SubProdID=t_PInP_353.ProdID)
INNER JOIN r_Prods r_Prods_354 WITH(NOLOCK) ON (t_PInP_353.ProdID=r_Prods_354.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_362 WITH(NOLOCK) ON (r_Prods_354.PGrID4=at_r_ProdG4_362.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_363 WITH(NOLOCK) ON (r_Prods_354.PGrID5=at_r_ProdG5_363.PGrID5)
INNER JOIN r_ProdA r_ProdA_356 WITH(NOLOCK) ON (r_Prods_354.PGrAID=r_ProdA_356.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_357 WITH(NOLOCK) ON (r_Prods_354.PBGrID=r_ProdBG_357.PBGrID)
INNER JOIN r_ProdC r_ProdC_358 WITH(NOLOCK) ON (r_Prods_354.PCatID=r_ProdC_358.PCatID)
INNER JOIN r_ProdG r_ProdG_355 WITH(NOLOCK) ON (r_Prods_354.PGrID=r_ProdG_355.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_359 WITH(NOLOCK) ON (r_Prods_354.PGrID1=r_ProdG1_359.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_360 WITH(NOLOCK) ON (r_Prods_354.PGrID2=r_ProdG2_360.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_361 WITH(NOLOCK) ON (r_Prods_354.PGrID3=r_ProdG3_361.PGrID3)
  WHERE  ((r_Prods_354.PGrID1 = 27) OR (r_Prods_354.PGrID1 = 28) OR (r_Prods_354.PGrID1 = 29) OR (r_Prods_354.PGrID1 = 63)) AND ((r_Prods_354.PCatID BETWEEN 1 AND 100)) AND ((t_SRec_320.StockID = 4) OR (t_SRec_320.StockID = 304)) AND (t_SRec_320.DocDate < '20190501') GROUP BY t_SRec_320.OurID, r_Ours_344.OurName, t_SRec_320.StockID, r_Stocks_350.StockName, r_Stocks_350.StockGID, r_StockGs_351.StockGName, t_SRec_320.CodeID1, r_Codes1_345.CodeName1, t_SRec_320.CodeID2, r_Codes2_346.CodeName2, t_SRec_320.CodeID3, r_Codes3_347.CodeName3, t_SRec_320.CodeID4, r_Codes4_348.CodeName4, t_SRec_320.CodeID5, r_Codes5_349.CodeName5, r_Prods_354.Country, r_Prods_354.PBGrID, r_ProdBG_357.PBGrName, r_Prods_354.PCatID, r_ProdC_358.PCatName, r_Prods_354.PGrID, r_ProdG_355.PGrName, r_Prods_354.PGrID1, r_ProdG1_359.PGrName1, r_Prods_354.PGrID2, r_ProdG2_360.PGrName2, r_Prods_354.PGrID3, r_ProdG3_361.PGrName3, r_Prods_354.PGrAID, r_ProdA_356.PGrAName, t_SRecD_352.SubProdID, r_Prods_354.ProdName, r_Prods_354.Notes, r_Prods_354.Article1, r_Prods_354.Article2, r_Prods_354.Article3, r_Prods_354.PGrID4, r_Prods_354.PGrID5, at_r_ProdG4_362.PGrName4, at_r_ProdG5_363.PGrName5, t_PInP_353.ProdBarCode


-->>> На начало - Разукомплектация товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_SExp_321.OurID, r_Ours_365.OurName, t_SExp_321.StockID, r_Stocks_371.StockName StockName, r_Stocks_371.StockGID, r_StockGs_372.StockGName, t_SExp_321.CodeID1, r_Codes1_366.CodeName1, t_SExp_321.CodeID2, r_Codes2_367.CodeName2, t_SExp_321.CodeID3, r_Codes3_368.CodeName3, t_SExp_321.CodeID4, r_Codes4_369.CodeName4, t_SExp_321.CodeID5, r_Codes5_370.CodeName5, r_Prods_375.Country, r_Prods_375.PBGrID, r_ProdBG_378.PBGrName, r_Prods_375.PCatID, r_ProdC_379.PCatName, r_Prods_375.PGrID, r_ProdG_376.PGrName, r_Prods_375.PGrID1, r_ProdG1_380.PGrName1, r_Prods_375.PGrID2, r_ProdG2_381.PGrName2, r_Prods_375.PGrID3, r_ProdG3_382.PGrName3, r_Prods_375.PGrAID, r_ProdA_377.PGrAName, t_SExpD_373.SubProdID, r_Prods_375.ProdName, r_Prods_375.Notes, r_Prods_375.Article1, r_Prods_375.Article2, r_Prods_375.Article3, r_Prods_375.PGrID4, r_Prods_375.PGrID5, at_r_ProdG4_383.PGrName4, at_r_ProdG5_384.PGrName5, t_PInP_374.ProdBarCode ProdBarCode, '               На начало', SUM(t_SExpD_373.SubQty) SumQty, SUM(t_SExpD_373.SubQty * t_PInP_374.CostMC) CostSum FROM av_t_SExp t_SExp_321 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_366 WITH(NOLOCK) ON (t_SExp_321.CodeID1=r_Codes1_366.CodeID1)
INNER JOIN r_Codes2 r_Codes2_367 WITH(NOLOCK) ON (t_SExp_321.CodeID2=r_Codes2_367.CodeID2)
INNER JOIN r_Codes3 r_Codes3_368 WITH(NOLOCK) ON (t_SExp_321.CodeID3=r_Codes3_368.CodeID3)
INNER JOIN r_Codes4 r_Codes4_369 WITH(NOLOCK) ON (t_SExp_321.CodeID4=r_Codes4_369.CodeID4)
INNER JOIN r_Codes5 r_Codes5_370 WITH(NOLOCK) ON (t_SExp_321.CodeID5=r_Codes5_370.CodeID5)
INNER JOIN r_Ours r_Ours_365 WITH(NOLOCK) ON (t_SExp_321.OurID=r_Ours_365.OurID)
INNER JOIN r_Stocks r_Stocks_371 WITH(NOLOCK) ON (t_SExp_321.StockID=r_Stocks_371.StockID)
INNER JOIN av_t_SExpA t_SExpA_364 WITH(NOLOCK) ON (t_SExp_321.ChID=t_SExpA_364.ChID)
INNER JOIN r_StockGs r_StockGs_372 WITH(NOLOCK) ON (r_Stocks_371.StockGID=r_StockGs_372.StockGID)
INNER JOIN av_t_SExpD t_SExpD_373 WITH(NOLOCK) ON (t_SExpA_364.AChID=t_SExpD_373.AChID)
INNER JOIN t_PInP t_PInP_374 WITH(NOLOCK) ON (t_SExpD_373.SubPPID=t_PInP_374.PPID AND t_SExpD_373.SubProdID=t_PInP_374.ProdID)
INNER JOIN r_Prods r_Prods_375 WITH(NOLOCK) ON (t_PInP_374.ProdID=r_Prods_375.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_383 WITH(NOLOCK) ON (r_Prods_375.PGrID4=at_r_ProdG4_383.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_384 WITH(NOLOCK) ON (r_Prods_375.PGrID5=at_r_ProdG5_384.PGrID5)
INNER JOIN r_ProdA r_ProdA_377 WITH(NOLOCK) ON (r_Prods_375.PGrAID=r_ProdA_377.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_378 WITH(NOLOCK) ON (r_Prods_375.PBGrID=r_ProdBG_378.PBGrID)
INNER JOIN r_ProdC r_ProdC_379 WITH(NOLOCK) ON (r_Prods_375.PCatID=r_ProdC_379.PCatID)
INNER JOIN r_ProdG r_ProdG_376 WITH(NOLOCK) ON (r_Prods_375.PGrID=r_ProdG_376.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_380 WITH(NOLOCK) ON (r_Prods_375.PGrID1=r_ProdG1_380.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_381 WITH(NOLOCK) ON (r_Prods_375.PGrID2=r_ProdG2_381.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_382 WITH(NOLOCK) ON (r_Prods_375.PGrID3=r_ProdG3_382.PGrID3)
  WHERE  ((r_Prods_375.PGrID1 = 27) OR (r_Prods_375.PGrID1 = 28) OR (r_Prods_375.PGrID1 = 29) OR (r_Prods_375.PGrID1 = 63)) AND ((r_Prods_375.PCatID BETWEEN 1 AND 100)) AND ((t_SExp_321.StockID = 4) OR (t_SExp_321.StockID = 304)) AND (t_SExp_321.DocDate < '20190501') GROUP BY t_SExp_321.OurID, r_Ours_365.OurName, t_SExp_321.StockID, r_Stocks_371.StockName, r_Stocks_371.StockGID, r_StockGs_372.StockGName, t_SExp_321.CodeID1, r_Codes1_366.CodeName1, t_SExp_321.CodeID2, r_Codes2_367.CodeName2, t_SExp_321.CodeID3, r_Codes3_368.CodeName3, t_SExp_321.CodeID4, r_Codes4_369.CodeName4, t_SExp_321.CodeID5, r_Codes5_370.CodeName5, r_Prods_375.Country, r_Prods_375.PBGrID, r_ProdBG_378.PBGrName, r_Prods_375.PCatID, r_ProdC_379.PCatName, r_Prods_375.PGrID, r_ProdG_376.PGrName, r_Prods_375.PGrID1, r_ProdG1_380.PGrName1, r_Prods_375.PGrID2, r_ProdG2_381.PGrName2, r_Prods_375.PGrID3, r_ProdG3_382.PGrName3, r_Prods_375.PGrAID, r_ProdA_377.PGrAName, t_SExpD_373.SubProdID, r_Prods_375.ProdName, r_Prods_375.Notes, r_Prods_375.Article1, r_Prods_375.Article2, r_Prods_375.Article3, r_Prods_375.PGrID4, r_Prods_375.PGrID5, at_r_ProdG4_383.PGrName4, at_r_ProdG5_384.PGrName5, t_PInP_374.ProdBarCode


-->>> На начало - Разукомплектация товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_SExp_322.OurID, r_Ours_386.OurName, t_SExp_322.StockID, r_Stocks_392.StockName StockName, r_Stocks_392.StockGID, r_StockGs_393.StockGName, t_SExp_322.CodeID1, r_Codes1_387.CodeName1, t_SExp_322.CodeID2, r_Codes2_388.CodeName2, t_SExp_322.CodeID3, r_Codes3_389.CodeName3, t_SExp_322.CodeID4, r_Codes4_390.CodeName4, t_SExp_322.CodeID5, r_Codes5_391.CodeName5, r_Prods_395.Country, r_Prods_395.PBGrID, r_ProdBG_398.PBGrName, r_Prods_395.PCatID, r_ProdC_399.PCatName, r_Prods_395.PGrID, r_ProdG_396.PGrName, r_Prods_395.PGrID1, r_ProdG1_400.PGrName1, r_Prods_395.PGrID2, r_ProdG2_401.PGrName2, r_Prods_395.PGrID3, r_ProdG3_402.PGrName3, r_Prods_395.PGrAID, r_ProdA_397.PGrAName, t_SExpA_385.ProdID, r_Prods_395.ProdName, r_Prods_395.Notes, r_Prods_395.Article1, r_Prods_395.Article2, r_Prods_395.Article3, r_Prods_395.PGrID4, r_Prods_395.PGrID5, at_r_ProdG4_403.PGrName4, at_r_ProdG5_404.PGrName5, t_PInP_394.ProdBarCode ProdBarCode, '               На начало', SUM(0-(t_SExpA_385.Qty)) SumQty, SUM(0-(t_SExpA_385.Qty * t_PInP_394.CostMC)) CostSum FROM av_t_SExp t_SExp_322 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_387 WITH(NOLOCK) ON (t_SExp_322.CodeID1=r_Codes1_387.CodeID1)
INNER JOIN r_Codes2 r_Codes2_388 WITH(NOLOCK) ON (t_SExp_322.CodeID2=r_Codes2_388.CodeID2)
INNER JOIN r_Codes3 r_Codes3_389 WITH(NOLOCK) ON (t_SExp_322.CodeID3=r_Codes3_389.CodeID3)
INNER JOIN r_Codes4 r_Codes4_390 WITH(NOLOCK) ON (t_SExp_322.CodeID4=r_Codes4_390.CodeID4)
INNER JOIN r_Codes5 r_Codes5_391 WITH(NOLOCK) ON (t_SExp_322.CodeID5=r_Codes5_391.CodeID5)
INNER JOIN r_Ours r_Ours_386 WITH(NOLOCK) ON (t_SExp_322.OurID=r_Ours_386.OurID)
INNER JOIN r_Stocks r_Stocks_392 WITH(NOLOCK) ON (t_SExp_322.StockID=r_Stocks_392.StockID)
INNER JOIN av_t_SExpA t_SExpA_385 WITH(NOLOCK) ON (t_SExp_322.ChID=t_SExpA_385.ChID)
INNER JOIN r_StockGs r_StockGs_393 WITH(NOLOCK) ON (r_Stocks_392.StockGID=r_StockGs_393.StockGID)
INNER JOIN t_PInP t_PInP_394 WITH(NOLOCK) ON (t_SExpA_385.PPID=t_PInP_394.PPID AND t_SExpA_385.ProdID=t_PInP_394.ProdID)
INNER JOIN r_Prods r_Prods_395 WITH(NOLOCK) ON (t_PInP_394.ProdID=r_Prods_395.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_403 WITH(NOLOCK) ON (r_Prods_395.PGrID4=at_r_ProdG4_403.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_404 WITH(NOLOCK) ON (r_Prods_395.PGrID5=at_r_ProdG5_404.PGrID5)
INNER JOIN r_ProdA r_ProdA_397 WITH(NOLOCK) ON (r_Prods_395.PGrAID=r_ProdA_397.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_398 WITH(NOLOCK) ON (r_Prods_395.PBGrID=r_ProdBG_398.PBGrID)
INNER JOIN r_ProdC r_ProdC_399 WITH(NOLOCK) ON (r_Prods_395.PCatID=r_ProdC_399.PCatID)
INNER JOIN r_ProdG r_ProdG_396 WITH(NOLOCK) ON (r_Prods_395.PGrID=r_ProdG_396.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_400 WITH(NOLOCK) ON (r_Prods_395.PGrID1=r_ProdG1_400.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_401 WITH(NOLOCK) ON (r_Prods_395.PGrID2=r_ProdG2_401.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_402 WITH(NOLOCK) ON (r_Prods_395.PGrID3=r_ProdG3_402.PGrID3)
  WHERE  ((r_Prods_395.PGrID1 = 27) OR (r_Prods_395.PGrID1 = 28) OR (r_Prods_395.PGrID1 = 29) OR (r_Prods_395.PGrID1 = 63)) AND ((r_Prods_395.PCatID BETWEEN 1 AND 100)) AND ((t_SExp_322.StockID = 4) OR (t_SExp_322.StockID = 304))
  AND (t_SExp_322.DocDate < '20190501') GROUP BY t_SExp_322.OurID, r_Ours_386.OurName, t_SExp_322.StockID, r_Stocks_392.StockName, r_Stocks_392.StockGID, r_StockGs_393.StockGName, t_SExp_322.CodeID1, r_Codes1_387.CodeName1, t_SExp_322.CodeID2, r_Codes2_388.CodeName2, t_SExp_322.CodeID3, r_Codes3_389.CodeName3, t_SExp_322.CodeID4, r_Codes4_390.CodeName4, t_SExp_322.CodeID5, r_Codes5_391.CodeName5, r_Prods_395.Country, r_Prods_395.PBGrID, r_ProdBG_398.PBGrName, r_Prods_395.PCatID, r_ProdC_399.PCatName, r_Prods_395.PGrID, r_ProdG_396.PGrName, r_Prods_395.PGrID1, r_ProdG1_400.PGrName1, r_Prods_395.PGrID2, r_ProdG2_401.PGrName2, r_Prods_395.PGrID3, r_ProdG3_402.PGrName3, r_Prods_395.PGrAID, r_ProdA_397.PGrAName, t_SExpA_385.ProdID, r_Prods_395.ProdName, r_Prods_395.Notes, r_Prods_395.Article1, r_Prods_395.Article2, r_Prods_395.Article3, r_Prods_395.PGrID4, r_Prods_395.PGrID5, at_r_ProdG4_403.PGrName4, at_r_ProdG5_404.PGrName5, t_PInP_394.ProdBarCode

















-->>> На конец - Приход товара:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Rec_1.OurID, r_Ours_91.OurName, t_Rec_1.StockID, r_Stocks_97.StockName StockName, r_Stocks_97.StockGID, r_StockGs_245.StockGName, t_Rec_1.CodeID1, r_Codes1_92.CodeName1, t_Rec_1.CodeID2, r_Codes2_93.CodeName2, t_Rec_1.CodeID3, r_Codes3_94.CodeName3, t_Rec_1.CodeID4, r_Codes4_95.CodeName4, t_Rec_1.CodeID5, r_Codes5_96.CodeName5, r_Prods_192.Country, r_Prods_192.PBGrID, r_ProdBG_198.PBGrName, r_Prods_192.PCatID, r_ProdC_193.PCatName, r_Prods_192.PGrID, r_ProdG_194.PGrName, r_Prods_192.PGrID1, r_ProdG1_195.PGrName1, r_Prods_192.PGrID2, r_ProdG2_196.PGrName2, r_Prods_192.PGrID3, r_ProdG3_197.PGrName3, r_Prods_192.PGrAID, r_ProdA_232.PGrAName, t_RecD_2.ProdID, r_Prods_192.ProdName, r_Prods_192.Notes, r_Prods_192.Article1, r_Prods_192.Article2, r_Prods_192.Article3, r_Prods_192.PGrID4, r_Prods_192.PGrID5, at_r_ProdG4_309.PGrName4, at_r_ProdG5_310.PGrName5, t_PInP_191.ProdBarCode ProdBarCode, 'На конец', SUM(t_RecD_2.Qty) SumQty, SUM(t_RecD_2.Qty * t_PInP_191.CostMC) CostSum FROM av_t_Rec t_Rec_1 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_92 WITH(NOLOCK) ON (t_Rec_1.CodeID1=r_Codes1_92.CodeID1)
INNER JOIN r_Codes2 r_Codes2_93 WITH(NOLOCK) ON (t_Rec_1.CodeID2=r_Codes2_93.CodeID2)
INNER JOIN r_Codes3 r_Codes3_94 WITH(NOLOCK) ON (t_Rec_1.CodeID3=r_Codes3_94.CodeID3)
INNER JOIN r_Codes4 r_Codes4_95 WITH(NOLOCK) ON (t_Rec_1.CodeID4=r_Codes4_95.CodeID4)
INNER JOIN r_Codes5 r_Codes5_96 WITH(NOLOCK) ON (t_Rec_1.CodeID5=r_Codes5_96.CodeID5)
INNER JOIN r_Ours r_Ours_91 WITH(NOLOCK) ON (t_Rec_1.OurID=r_Ours_91.OurID)
INNER JOIN r_Stocks r_Stocks_97 WITH(NOLOCK) ON (t_Rec_1.StockID=r_Stocks_97.StockID)
INNER JOIN av_t_RecD t_RecD_2 WITH(NOLOCK) ON (t_Rec_1.ChID=t_RecD_2.ChID)
INNER JOIN r_StockGs r_StockGs_245 WITH(NOLOCK) ON (r_Stocks_97.StockGID=r_StockGs_245.StockGID)
INNER JOIN t_PInP t_PInP_191 WITH(NOLOCK) ON (t_RecD_2.PPID=t_PInP_191.PPID AND t_RecD_2.ProdID=t_PInP_191.ProdID)
INNER JOIN r_Prods r_Prods_192 WITH(NOLOCK) ON (t_PInP_191.ProdID=r_Prods_192.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_309 WITH(NOLOCK) ON (r_Prods_192.PGrID4=at_r_ProdG4_309.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_310 WITH(NOLOCK) ON (r_Prods_192.PGrID5=at_r_ProdG5_310.PGrID5)
INNER JOIN r_ProdA r_ProdA_232 WITH(NOLOCK) ON (r_Prods_192.PGrAID=r_ProdA_232.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_198 WITH(NOLOCK) ON (r_Prods_192.PBGrID=r_ProdBG_198.PBGrID)
INNER JOIN r_ProdC r_ProdC_193 WITH(NOLOCK) ON (r_Prods_192.PCatID=r_ProdC_193.PCatID)
INNER JOIN r_ProdG r_ProdG_194 WITH(NOLOCK) ON (r_Prods_192.PGrID=r_ProdG_194.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_195 WITH(NOLOCK) ON (r_Prods_192.PGrID1=r_ProdG1_195.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_196 WITH(NOLOCK) ON (r_Prods_192.PGrID2=r_ProdG2_196.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_197 WITH(NOLOCK) ON (r_Prods_192.PGrID3=r_ProdG3_197.PGrID3)
  WHERE  ((r_Prods_192.PGrID1 = 27) OR (r_Prods_192.PGrID1 = 28) OR (r_Prods_192.PGrID1 = 29) OR (r_Prods_192.PGrID1 = 63)) AND ((r_Prods_192.PCatID BETWEEN 1 AND 100)) AND ((t_Rec_1.StockID = 4) OR (t_Rec_1.StockID = 304)) AND (t_Rec_1.DocDate <= '20190618') GROUP BY t_Rec_1.OurID, r_Ours_91.OurName, t_Rec_1.StockID, r_Stocks_97.StockName, r_Stocks_97.StockGID, r_StockGs_245.StockGName, t_Rec_1.CodeID1, r_Codes1_92.CodeName1, t_Rec_1.CodeID2, r_Codes2_93.CodeName2, t_Rec_1.CodeID3, r_Codes3_94.CodeName3, t_Rec_1.CodeID4, r_Codes4_95.CodeName4, t_Rec_1.CodeID5, r_Codes5_96.CodeName5, r_Prods_192.Country, r_Prods_192.PBGrID, r_ProdBG_198.PBGrName, r_Prods_192.PCatID, r_ProdC_193.PCatName, r_Prods_192.PGrID, r_ProdG_194.PGrName, r_Prods_192.PGrID1, r_ProdG1_195.PGrName1, r_Prods_192.PGrID2, r_ProdG2_196.PGrName2, r_Prods_192.PGrID3, r_ProdG3_197.PGrName3, r_Prods_192.PGrAID, r_ProdA_232.PGrAName, t_RecD_2.ProdID, r_Prods_192.ProdName, r_Prods_192.Notes, r_Prods_192.Article1, r_Prods_192.Article2, r_Prods_192.Article3, r_Prods_192.PGrID4, r_Prods_192.PGrID5, at_r_ProdG4_309.PGrName4, at_r_ProdG5_310.PGrName5, t_PInP_191.ProdBarCode


-->>> На конец - Возврат товара от получателя:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Ret_3.OurID, r_Ours_28.OurName, t_Ret_3.StockID, r_Stocks_34.StockName StockName, r_Stocks_34.StockGID, r_StockGs_236.StockGName, t_Ret_3.CodeID1, r_Codes1_29.CodeName1, t_Ret_3.CodeID2, r_Codes2_30.CodeName2, t_Ret_3.CodeID3, r_Codes3_31.CodeName3, t_Ret_3.CodeID4, r_Codes4_32.CodeName4, t_Ret_3.CodeID5, r_Codes5_33.CodeName5, r_Prods_120.Country, r_Prods_120.PBGrID, r_ProdBG_126.PBGrName, r_Prods_120.PCatID, r_ProdC_121.PCatName, r_Prods_120.PGrID, r_ProdG_122.PGrName, r_Prods_120.PGrID1, r_ProdG1_123.PGrName1, r_Prods_120.PGrID2, r_ProdG2_124.PGrName2, r_Prods_120.PGrID3, r_ProdG3_125.PGrName3, r_Prods_120.PGrAID, r_ProdA_223.PGrAName, t_RetD_4.ProdID, r_Prods_120.ProdName, r_Prods_120.Notes, r_Prods_120.Article1, r_Prods_120.Article2, r_Prods_120.Article3, r_Prods_120.PGrID4, r_Prods_120.PGrID5, at_r_ProdG4_289.PGrName4, at_r_ProdG5_290.PGrName5, t_PInP_119.ProdBarCode ProdBarCode, 'На конец', SUM(t_RetD_4.Qty) SumQty, SUM(t_RetD_4.Qty * t_PInP_119.CostMC) CostSum FROM av_t_Ret t_Ret_3 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_29 WITH(NOLOCK) ON (t_Ret_3.CodeID1=r_Codes1_29.CodeID1)
INNER JOIN r_Codes2 r_Codes2_30 WITH(NOLOCK) ON (t_Ret_3.CodeID2=r_Codes2_30.CodeID2)
INNER JOIN r_Codes3 r_Codes3_31 WITH(NOLOCK) ON (t_Ret_3.CodeID3=r_Codes3_31.CodeID3)
INNER JOIN r_Codes4 r_Codes4_32 WITH(NOLOCK) ON (t_Ret_3.CodeID4=r_Codes4_32.CodeID4)
INNER JOIN r_Codes5 r_Codes5_33 WITH(NOLOCK) ON (t_Ret_3.CodeID5=r_Codes5_33.CodeID5)
INNER JOIN r_Ours r_Ours_28 WITH(NOLOCK) ON (t_Ret_3.OurID=r_Ours_28.OurID)
INNER JOIN r_Stocks r_Stocks_34 WITH(NOLOCK) ON (t_Ret_3.StockID=r_Stocks_34.StockID)
INNER JOIN av_t_RetD t_RetD_4 WITH(NOLOCK) ON (t_Ret_3.ChID=t_RetD_4.ChID)
INNER JOIN r_StockGs r_StockGs_236 WITH(NOLOCK) ON (r_Stocks_34.StockGID=r_StockGs_236.StockGID)
INNER JOIN t_PInP t_PInP_119 WITH(NOLOCK) ON (t_RetD_4.PPID=t_PInP_119.PPID AND t_RetD_4.ProdID=t_PInP_119.ProdID)
INNER JOIN r_Prods r_Prods_120 WITH(NOLOCK) ON (t_PInP_119.ProdID=r_Prods_120.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_289 WITH(NOLOCK) ON (r_Prods_120.PGrID4=at_r_ProdG4_289.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_290 WITH(NOLOCK) ON (r_Prods_120.PGrID5=at_r_ProdG5_290.PGrID5)
INNER JOIN r_ProdA r_ProdA_223 WITH(NOLOCK) ON (r_Prods_120.PGrAID=r_ProdA_223.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_126 WITH(NOLOCK) ON (r_Prods_120.PBGrID=r_ProdBG_126.PBGrID)
INNER JOIN r_ProdC r_ProdC_121 WITH(NOLOCK) ON (r_Prods_120.PCatID=r_ProdC_121.PCatID)
INNER JOIN r_ProdG r_ProdG_122 WITH(NOLOCK) ON (r_Prods_120.PGrID=r_ProdG_122.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_123 WITH(NOLOCK) ON (r_Prods_120.PGrID1=r_ProdG1_123.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_124 WITH(NOLOCK) ON (r_Prods_120.PGrID2=r_ProdG2_124.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_125 WITH(NOLOCK) ON (r_Prods_120.PGrID3=r_ProdG3_125.PGrID3)
  WHERE  ((r_Prods_120.PGrID1 = 27) OR (r_Prods_120.PGrID1 = 28) OR (r_Prods_120.PGrID1 = 29) OR (r_Prods_120.PGrID1 = 63)) AND ((r_Prods_120.PCatID BETWEEN 1 AND 100)) AND ((t_Ret_3.StockID = 4) OR (t_Ret_3.StockID = 304)) AND (t_Ret_3.DocDate <= '20190618') GROUP BY t_Ret_3.OurID, r_Ours_28.OurName, t_Ret_3.StockID, r_Stocks_34.StockName, r_Stocks_34.StockGID, r_StockGs_236.StockGName, t_Ret_3.CodeID1, r_Codes1_29.CodeName1, t_Ret_3.CodeID2, r_Codes2_30.CodeName2, t_Ret_3.CodeID3, r_Codes3_31.CodeName3, t_Ret_3.CodeID4, r_Codes4_32.CodeName4, t_Ret_3.CodeID5, r_Codes5_33.CodeName5, r_Prods_120.Country, r_Prods_120.PBGrID, r_ProdBG_126.PBGrName, r_Prods_120.PCatID, r_ProdC_121.PCatName, r_Prods_120.PGrID, r_ProdG_122.PGrName, r_Prods_120.PGrID1, r_ProdG1_123.PGrName1, r_Prods_120.PGrID2, r_ProdG2_124.PGrName2, r_Prods_120.PGrID3, r_ProdG3_125.PGrName3, r_Prods_120.PGrAID, r_ProdA_223.PGrAName, t_RetD_4.ProdID, r_Prods_120.ProdName, r_Prods_120.Notes, r_Prods_120.Article1, r_Prods_120.Article2, r_Prods_120.Article3, r_Prods_120.PGrID4, r_Prods_120.PGrID5, at_r_ProdG4_289.PGrName4, at_r_ProdG5_290.PGrName5, t_PInP_119.ProdBarCode


-->>> На конец - Возврат товара поставщику:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_CRet_5.OurID, r_Ours_35.OurName, t_CRet_5.StockID, r_Stocks_41.StockName StockName, r_Stocks_41.StockGID, r_StockGs_237.StockGName, t_CRet_5.CodeID1, r_Codes1_36.CodeName1, t_CRet_5.CodeID2, r_Codes2_37.CodeName2, t_CRet_5.CodeID3, r_Codes3_38.CodeName3, t_CRet_5.CodeID4, r_Codes4_39.CodeName4, t_CRet_5.CodeID5, r_Codes5_40.CodeName5, r_Prods_128.Country, r_Prods_128.PBGrID, r_ProdBG_134.PBGrName, r_Prods_128.PCatID, r_ProdC_129.PCatName, r_Prods_128.PGrID, r_ProdG_130.PGrName, r_Prods_128.PGrID1, r_ProdG1_131.PGrName1, r_Prods_128.PGrID2, r_ProdG2_132.PGrName2, r_Prods_128.PGrID3, r_ProdG3_133.PGrName3, r_Prods_128.PGrAID, r_ProdA_224.PGrAName, t_CRetD_6.ProdID, r_Prods_128.ProdName, r_Prods_128.Notes, r_Prods_128.Article1, r_Prods_128.Article2, r_Prods_128.Article3, r_Prods_128.PGrID4, r_Prods_128.PGrID5, at_r_ProdG4_293.PGrName4, at_r_ProdG5_294.PGrName5, t_PInP_127.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_CRetD_6.Qty)) SumQty, SUM(0-(t_CRetD_6.Qty * t_PInP_127.CostMC)) CostSum FROM av_t_CRet t_CRet_5 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_36 WITH(NOLOCK) ON (t_CRet_5.CodeID1=r_Codes1_36.CodeID1)
INNER JOIN r_Codes2 r_Codes2_37 WITH(NOLOCK) ON (t_CRet_5.CodeID2=r_Codes2_37.CodeID2)
INNER JOIN r_Codes3 r_Codes3_38 WITH(NOLOCK) ON (t_CRet_5.CodeID3=r_Codes3_38.CodeID3)
INNER JOIN r_Codes4 r_Codes4_39 WITH(NOLOCK) ON (t_CRet_5.CodeID4=r_Codes4_39.CodeID4)
INNER JOIN r_Codes5 r_Codes5_40 WITH(NOLOCK) ON (t_CRet_5.CodeID5=r_Codes5_40.CodeID5)
INNER JOIN r_Ours r_Ours_35 WITH(NOLOCK) ON (t_CRet_5.OurID=r_Ours_35.OurID)
INNER JOIN r_Stocks r_Stocks_41 WITH(NOLOCK) ON (t_CRet_5.StockID=r_Stocks_41.StockID)
INNER JOIN av_t_CRetD t_CRetD_6 WITH(NOLOCK) ON (t_CRet_5.ChID=t_CRetD_6.ChID)
INNER JOIN r_StockGs r_StockGs_237 WITH(NOLOCK) ON (r_Stocks_41.StockGID=r_StockGs_237.StockGID)
INNER JOIN t_PInP t_PInP_127 WITH(NOLOCK) ON (t_CRetD_6.PPID=t_PInP_127.PPID AND t_CRetD_6.ProdID=t_PInP_127.ProdID)
INNER JOIN r_Prods r_Prods_128 WITH(NOLOCK) ON (t_PInP_127.ProdID=r_Prods_128.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_293 WITH(NOLOCK) ON (r_Prods_128.PGrID4=at_r_ProdG4_293.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_294 WITH(NOLOCK) ON (r_Prods_128.PGrID5=at_r_ProdG5_294.PGrID5)
INNER JOIN r_ProdA r_ProdA_224 WITH(NOLOCK) ON (r_Prods_128.PGrAID=r_ProdA_224.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_134 WITH(NOLOCK) ON (r_Prods_128.PBGrID=r_ProdBG_134.PBGrID)
INNER JOIN r_ProdC r_ProdC_129 WITH(NOLOCK) ON (r_Prods_128.PCatID=r_ProdC_129.PCatID)
INNER JOIN r_ProdG r_ProdG_130 WITH(NOLOCK) ON (r_Prods_128.PGrID=r_ProdG_130.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_131 WITH(NOLOCK) ON (r_Prods_128.PGrID1=r_ProdG1_131.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_132 WITH(NOLOCK) ON (r_Prods_128.PGrID2=r_ProdG2_132.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_133 WITH(NOLOCK) ON (r_Prods_128.PGrID3=r_ProdG3_133.PGrID3)
  WHERE  ((r_Prods_128.PGrID1 = 27) OR (r_Prods_128.PGrID1 = 28) OR (r_Prods_128.PGrID1 = 29) OR (r_Prods_128.PGrID1 = 63)) AND ((r_Prods_128.PCatID BETWEEN 1 AND 100)) AND ((t_CRet_5.StockID = 4) OR (t_CRet_5.StockID = 304)) AND (t_CRet_5.DocDate <= '20190618') GROUP BY t_CRet_5.OurID, r_Ours_35.OurName, t_CRet_5.StockID, r_Stocks_41.StockName, r_Stocks_41.StockGID, r_StockGs_237.StockGName, t_CRet_5.CodeID1, r_Codes1_36.CodeName1, t_CRet_5.CodeID2, r_Codes2_37.CodeName2, t_CRet_5.CodeID3, r_Codes3_38.CodeName3, t_CRet_5.CodeID4, r_Codes4_39.CodeName4, t_CRet_5.CodeID5, r_Codes5_40.CodeName5, r_Prods_128.Country, r_Prods_128.PBGrID, r_ProdBG_134.PBGrName, r_Prods_128.PCatID, r_ProdC_129.PCatName, r_Prods_128.PGrID, r_ProdG_130.PGrName, r_Prods_128.PGrID1, r_ProdG1_131.PGrName1, r_Prods_128.PGrID2, r_ProdG2_132.PGrName2, r_Prods_128.PGrID3, r_ProdG3_133.PGrName3, r_Prods_128.PGrAID, r_ProdA_224.PGrAName, t_CRetD_6.ProdID, r_Prods_128.ProdName, r_Prods_128.Notes, r_Prods_128.Article1, r_Prods_128.Article2, r_Prods_128.Article3, r_Prods_128.PGrID4, r_Prods_128.PGrID5, at_r_ProdG4_293.PGrName4, at_r_ProdG5_294.PGrName5, t_PInP_127.ProdBarCode


-->>> На конец - Расходная накладная:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Inv_7.OurID, r_Ours_98.OurName, t_Inv_7.StockID, r_Stocks_104.StockName StockName, r_Stocks_104.StockGID, r_StockGs_246.StockGName, t_Inv_7.CodeID1, r_Codes1_99.CodeName1, t_Inv_7.CodeID2, r_Codes2_100.CodeName2, t_Inv_7.CodeID3, r_Codes3_101.CodeName3, t_Inv_7.CodeID4, r_Codes4_102.CodeName4, t_Inv_7.CodeID5, r_Codes5_103.CodeName5, r_Prods_200.Country, r_Prods_200.PBGrID, r_ProdBG_206.PBGrName, r_Prods_200.PCatID, r_ProdC_201.PCatName, r_Prods_200.PGrID, r_ProdG_202.PGrName, r_Prods_200.PGrID1, r_ProdG1_203.PGrName1, r_Prods_200.PGrID2, r_ProdG2_204.PGrName2, r_Prods_200.PGrID3, r_ProdG3_205.PGrName3, r_Prods_200.PGrAID, r_ProdA_233.PGrAName, t_InvD_8.ProdID, r_Prods_200.ProdName, r_Prods_200.Notes, r_Prods_200.Article1, r_Prods_200.Article2, r_Prods_200.Article3, r_Prods_200.PGrID4, r_Prods_200.PGrID5, at_r_ProdG4_313.PGrName4, at_r_ProdG5_314.PGrName5, t_PInP_199.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_InvD_8.Qty)) SumQty, SUM(0-(t_InvD_8.Qty * t_PInP_199.CostMC)) CostSum FROM av_t_Inv t_Inv_7 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_99 WITH(NOLOCK) ON (t_Inv_7.CodeID1=r_Codes1_99.CodeID1)
INNER JOIN r_Codes2 r_Codes2_100 WITH(NOLOCK) ON (t_Inv_7.CodeID2=r_Codes2_100.CodeID2)
INNER JOIN r_Codes3 r_Codes3_101 WITH(NOLOCK) ON (t_Inv_7.CodeID3=r_Codes3_101.CodeID3)
INNER JOIN r_Codes4 r_Codes4_102 WITH(NOLOCK) ON (t_Inv_7.CodeID4=r_Codes4_102.CodeID4)
INNER JOIN r_Codes5 r_Codes5_103 WITH(NOLOCK) ON (t_Inv_7.CodeID5=r_Codes5_103.CodeID5)
INNER JOIN r_Ours r_Ours_98 WITH(NOLOCK) ON (t_Inv_7.OurID=r_Ours_98.OurID)
INNER JOIN r_Stocks r_Stocks_104 WITH(NOLOCK) ON (t_Inv_7.StockID=r_Stocks_104.StockID)
INNER JOIN av_t_InvD t_InvD_8 WITH(NOLOCK) ON (t_Inv_7.ChID=t_InvD_8.ChID)
INNER JOIN r_StockGs r_StockGs_246 WITH(NOLOCK) ON (r_Stocks_104.StockGID=r_StockGs_246.StockGID)
INNER JOIN t_PInP t_PInP_199 WITH(NOLOCK) ON (t_InvD_8.PPID=t_PInP_199.PPID AND t_InvD_8.ProdID=t_PInP_199.ProdID)
INNER JOIN r_Prods r_Prods_200 WITH(NOLOCK) ON (t_PInP_199.ProdID=r_Prods_200.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_313 WITH(NOLOCK) ON (r_Prods_200.PGrID4=at_r_ProdG4_313.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_314 WITH(NOLOCK) ON (r_Prods_200.PGrID5=at_r_ProdG5_314.PGrID5)
INNER JOIN r_ProdA r_ProdA_233 WITH(NOLOCK) ON (r_Prods_200.PGrAID=r_ProdA_233.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_206 WITH(NOLOCK) ON (r_Prods_200.PBGrID=r_ProdBG_206.PBGrID)
INNER JOIN r_ProdC r_ProdC_201 WITH(NOLOCK) ON (r_Prods_200.PCatID=r_ProdC_201.PCatID)
INNER JOIN r_ProdG r_ProdG_202 WITH(NOLOCK) ON (r_Prods_200.PGrID=r_ProdG_202.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_203 WITH(NOLOCK) ON (r_Prods_200.PGrID1=r_ProdG1_203.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_204 WITH(NOLOCK) ON (r_Prods_200.PGrID2=r_ProdG2_204.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_205 WITH(NOLOCK) ON (r_Prods_200.PGrID3=r_ProdG3_205.PGrID3)
  WHERE  ((r_Prods_200.PGrID1 = 27) OR (r_Prods_200.PGrID1 = 28) OR (r_Prods_200.PGrID1 = 29) OR (r_Prods_200.PGrID1 = 63)) AND ((r_Prods_200.PCatID BETWEEN 1 AND 100)) AND ((t_Inv_7.StockID = 4) OR (t_Inv_7.StockID = 304)) AND (t_Inv_7.DocDate <= '20190618') GROUP BY t_Inv_7.OurID, r_Ours_98.OurName, t_Inv_7.StockID, r_Stocks_104.StockName, r_Stocks_104.StockGID, r_StockGs_246.StockGName, t_Inv_7.CodeID1, r_Codes1_99.CodeName1, t_Inv_7.CodeID2, r_Codes2_100.CodeName2, t_Inv_7.CodeID3, r_Codes3_101.CodeName3, t_Inv_7.CodeID4, r_Codes4_102.CodeName4, t_Inv_7.CodeID5, r_Codes5_103.CodeName5, r_Prods_200.Country, r_Prods_200.PBGrID, r_ProdBG_206.PBGrName, r_Prods_200.PCatID, r_ProdC_201.PCatName, r_Prods_200.PGrID, r_ProdG_202.PGrName, r_Prods_200.PGrID1, r_ProdG1_203.PGrName1, r_Prods_200.PGrID2, r_ProdG2_204.PGrName2, r_Prods_200.PGrID3, r_ProdG3_205.PGrName3, r_Prods_200.PGrAID, r_ProdA_233.PGrAName, t_InvD_8.ProdID, r_Prods_200.ProdName, r_Prods_200.Notes, r_Prods_200.Article1, r_Prods_200.Article2, r_Prods_200.Article3, r_Prods_200.PGrID4, r_Prods_200.PGrID5, at_r_ProdG4_313.PGrName4, at_r_ProdG5_314.PGrName5, t_PInP_199.ProdBarCode


-->>> На конец - Расходный документ:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Exp_9.OurID, r_Ours_105.OurName, t_Exp_9.StockID, r_Stocks_111.StockName StockName, r_Stocks_111.StockGID, r_StockGs_247.StockGName, t_Exp_9.CodeID1, r_Codes1_106.CodeName1, t_Exp_9.CodeID2, r_Codes2_107.CodeName2, t_Exp_9.CodeID3, r_Codes3_108.CodeName3, t_Exp_9.CodeID4, r_Codes4_109.CodeName4, t_Exp_9.CodeID5, r_Codes5_110.CodeName5, r_Prods_208.Country, r_Prods_208.PBGrID, r_ProdBG_214.PBGrName, r_Prods_208.PCatID, r_ProdC_209.PCatName, r_Prods_208.PGrID, r_ProdG_210.PGrName, r_Prods_208.PGrID1, r_ProdG1_211.PGrName1, r_Prods_208.PGrID2, r_ProdG2_212.PGrName2, r_Prods_208.PGrID3, r_ProdG3_213.PGrName3, r_Prods_208.PGrAID, r_ProdA_234.PGrAName, t_ExpD_10.ProdID, r_Prods_208.ProdName, r_Prods_208.Notes, r_Prods_208.Article1, r_Prods_208.Article2, r_Prods_208.Article3, r_Prods_208.PGrID4, r_Prods_208.PGrID5, at_r_ProdG4_315.PGrName4, at_r_ProdG5_316.PGrName5, t_PInP_207.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_ExpD_10.Qty)) SumQty, SUM(0-(t_ExpD_10.Qty * t_PInP_207.CostMC)) CostSum FROM av_t_Exp t_Exp_9 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_106 WITH(NOLOCK) ON (t_Exp_9.CodeID1=r_Codes1_106.CodeID1)
INNER JOIN r_Codes2 r_Codes2_107 WITH(NOLOCK) ON (t_Exp_9.CodeID2=r_Codes2_107.CodeID2)
INNER JOIN r_Codes3 r_Codes3_108 WITH(NOLOCK) ON (t_Exp_9.CodeID3=r_Codes3_108.CodeID3)
INNER JOIN r_Codes4 r_Codes4_109 WITH(NOLOCK) ON (t_Exp_9.CodeID4=r_Codes4_109.CodeID4)
INNER JOIN r_Codes5 r_Codes5_110 WITH(NOLOCK) ON (t_Exp_9.CodeID5=r_Codes5_110.CodeID5)
INNER JOIN r_Ours r_Ours_105 WITH(NOLOCK) ON (t_Exp_9.OurID=r_Ours_105.OurID)
INNER JOIN r_Stocks r_Stocks_111 WITH(NOLOCK) ON (t_Exp_9.StockID=r_Stocks_111.StockID)
INNER JOIN av_t_ExpD t_ExpD_10 WITH(NOLOCK) ON (t_Exp_9.ChID=t_ExpD_10.ChID)
INNER JOIN r_StockGs r_StockGs_247 WITH(NOLOCK) ON (r_Stocks_111.StockGID=r_StockGs_247.StockGID)
INNER JOIN t_PInP t_PInP_207 WITH(NOLOCK) ON (t_ExpD_10.PPID=t_PInP_207.PPID AND t_ExpD_10.ProdID=t_PInP_207.ProdID)
INNER JOIN r_Prods r_Prods_208 WITH(NOLOCK) ON (t_PInP_207.ProdID=r_Prods_208.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_315 WITH(NOLOCK) ON (r_Prods_208.PGrID4=at_r_ProdG4_315.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_316 WITH(NOLOCK) ON (r_Prods_208.PGrID5=at_r_ProdG5_316.PGrID5)
INNER JOIN r_ProdA r_ProdA_234 WITH(NOLOCK) ON (r_Prods_208.PGrAID=r_ProdA_234.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_214 WITH(NOLOCK) ON (r_Prods_208.PBGrID=r_ProdBG_214.PBGrID)
INNER JOIN r_ProdC r_ProdC_209 WITH(NOLOCK) ON (r_Prods_208.PCatID=r_ProdC_209.PCatID)
INNER JOIN r_ProdG r_ProdG_210 WITH(NOLOCK) ON (r_Prods_208.PGrID=r_ProdG_210.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_211 WITH(NOLOCK) ON (r_Prods_208.PGrID1=r_ProdG1_211.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_212 WITH(NOLOCK) ON (r_Prods_208.PGrID2=r_ProdG2_212.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_213 WITH(NOLOCK) ON (r_Prods_208.PGrID3=r_ProdG3_213.PGrID3)
  WHERE  ((r_Prods_208.PGrID1 = 27) OR (r_Prods_208.PGrID1 = 28) OR (r_Prods_208.PGrID1 = 29) OR (r_Prods_208.PGrID1 = 63)) AND ((r_Prods_208.PCatID BETWEEN 1 AND 100)) AND ((t_Exp_9.StockID = 4) OR (t_Exp_9.StockID = 304)) AND (t_Exp_9.DocDate <= '20190618') GROUP BY t_Exp_9.OurID, r_Ours_105.OurName, t_Exp_9.StockID, r_Stocks_111.StockName, r_Stocks_111.StockGID, r_StockGs_247.StockGName, t_Exp_9.CodeID1, r_Codes1_106.CodeName1, t_Exp_9.CodeID2, r_Codes2_107.CodeName2, t_Exp_9.CodeID3, r_Codes3_108.CodeName3, t_Exp_9.CodeID4, r_Codes4_109.CodeName4, t_Exp_9.CodeID5, r_Codes5_110.CodeName5, r_Prods_208.Country, r_Prods_208.PBGrID, r_ProdBG_214.PBGrName, r_Prods_208.PCatID, r_ProdC_209.PCatName, r_Prods_208.PGrID, r_ProdG_210.PGrName, r_Prods_208.PGrID1, r_ProdG1_211.PGrName1, r_Prods_208.PGrID2, r_ProdG2_212.PGrName2, r_Prods_208.PGrID3, r_ProdG3_213.PGrName3, r_Prods_208.PGrAID, r_ProdA_234.PGrAName, t_ExpD_10.ProdID, r_Prods_208.ProdName, r_Prods_208.Notes, r_Prods_208.Article1, r_Prods_208.Article2, r_Prods_208.Article3, r_Prods_208.PGrID4, r_Prods_208.PGrID5, at_r_ProdG4_315.PGrName4, at_r_ProdG5_316.PGrName5, t_PInP_207.ProdBarCode


-->>> На конец - Расходный документ в ценах прихода:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Epp_11.OurID, r_Ours_112.OurName, t_Epp_11.StockID, r_Stocks_118.StockName StockName, r_Stocks_118.StockGID, r_StockGs_248.StockGName, t_Epp_11.CodeID1, r_Codes1_113.CodeName1, t_Epp_11.CodeID2, r_Codes2_114.CodeName2, t_Epp_11.CodeID3, r_Codes3_115.CodeName3, t_Epp_11.CodeID4, r_Codes4_116.CodeName4, t_Epp_11.CodeID5, r_Codes5_117.CodeName5, r_Prods_216.Country, r_Prods_216.PBGrID, r_ProdBG_222.PBGrName, r_Prods_216.PCatID, r_ProdC_217.PCatName, r_Prods_216.PGrID, r_ProdG_218.PGrName, r_Prods_216.PGrID1, r_ProdG1_219.PGrName1, r_Prods_216.PGrID2, r_ProdG2_220.PGrName2, r_Prods_216.PGrID3, r_ProdG3_221.PGrName3, r_Prods_216.PGrAID, r_ProdA_235.PGrAName, t_EppD_12.ProdID, r_Prods_216.ProdName, r_Prods_216.Notes, r_Prods_216.Article1, r_Prods_216.Article2, r_Prods_216.Article3, r_Prods_216.PGrID4, r_Prods_216.PGrID5, at_r_ProdG4_317.PGrName4, at_r_ProdG5_318.PGrName5, t_PInP_215.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_EppD_12.Qty)) SumQty, SUM(0-(t_EppD_12.Qty * t_PInP_215.CostMC)) CostSum FROM av_t_Epp t_Epp_11 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_113 WITH(NOLOCK) ON (t_Epp_11.CodeID1=r_Codes1_113.CodeID1)
INNER JOIN r_Codes2 r_Codes2_114 WITH(NOLOCK) ON (t_Epp_11.CodeID2=r_Codes2_114.CodeID2)
INNER JOIN r_Codes3 r_Codes3_115 WITH(NOLOCK) ON (t_Epp_11.CodeID3=r_Codes3_115.CodeID3)
INNER JOIN r_Codes4 r_Codes4_116 WITH(NOLOCK) ON (t_Epp_11.CodeID4=r_Codes4_116.CodeID4)
INNER JOIN r_Codes5 r_Codes5_117 WITH(NOLOCK) ON (t_Epp_11.CodeID5=r_Codes5_117.CodeID5)
INNER JOIN r_Ours r_Ours_112 WITH(NOLOCK) ON (t_Epp_11.OurID=r_Ours_112.OurID)
INNER JOIN r_Stocks r_Stocks_118 WITH(NOLOCK) ON (t_Epp_11.StockID=r_Stocks_118.StockID)
INNER JOIN av_t_EppD t_EppD_12 WITH(NOLOCK) ON (t_Epp_11.ChID=t_EppD_12.ChID)
INNER JOIN r_StockGs r_StockGs_248 WITH(NOLOCK) ON (r_Stocks_118.StockGID=r_StockGs_248.StockGID)
INNER JOIN t_PInP t_PInP_215 WITH(NOLOCK) ON (t_EppD_12.PPID=t_PInP_215.PPID AND t_EppD_12.ProdID=t_PInP_215.ProdID)
INNER JOIN r_Prods r_Prods_216 WITH(NOLOCK) ON (t_PInP_215.ProdID=r_Prods_216.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_317 WITH(NOLOCK) ON (r_Prods_216.PGrID4=at_r_ProdG4_317.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_318 WITH(NOLOCK) ON (r_Prods_216.PGrID5=at_r_ProdG5_318.PGrID5)
INNER JOIN r_ProdA r_ProdA_235 WITH(NOLOCK) ON (r_Prods_216.PGrAID=r_ProdA_235.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_222 WITH(NOLOCK) ON (r_Prods_216.PBGrID=r_ProdBG_222.PBGrID)
INNER JOIN r_ProdC r_ProdC_217 WITH(NOLOCK) ON (r_Prods_216.PCatID=r_ProdC_217.PCatID)
INNER JOIN r_ProdG r_ProdG_218 WITH(NOLOCK) ON (r_Prods_216.PGrID=r_ProdG_218.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_219 WITH(NOLOCK) ON (r_Prods_216.PGrID1=r_ProdG1_219.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_220 WITH(NOLOCK) ON (r_Prods_216.PGrID2=r_ProdG2_220.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_221 WITH(NOLOCK) ON (r_Prods_216.PGrID3=r_ProdG3_221.PGrID3)
  WHERE  ((r_Prods_216.PGrID1 = 27) OR (r_Prods_216.PGrID1 = 28) OR (r_Prods_216.PGrID1 = 29) OR (r_Prods_216.PGrID1 = 63)) AND ((r_Prods_216.PCatID BETWEEN 1 AND 100)) AND ((t_Epp_11.StockID = 4) OR (t_Epp_11.StockID = 304)) AND (t_Epp_11.DocDate <= '20190618') GROUP BY t_Epp_11.OurID, r_Ours_112.OurName, t_Epp_11.StockID, r_Stocks_118.StockName, r_Stocks_118.StockGID, r_StockGs_248.StockGName, t_Epp_11.CodeID1, r_Codes1_113.CodeName1, t_Epp_11.CodeID2, r_Codes2_114.CodeName2, t_Epp_11.CodeID3, r_Codes3_115.CodeName3, t_Epp_11.CodeID4, r_Codes4_116.CodeName4, t_Epp_11.CodeID5, r_Codes5_117.CodeName5, r_Prods_216.Country, r_Prods_216.PBGrID, r_ProdBG_222.PBGrName, r_Prods_216.PCatID, r_ProdC_217.PCatName, r_Prods_216.PGrID, r_ProdG_218.PGrName, r_Prods_216.PGrID1, r_ProdG1_219.PGrName1, r_Prods_216.PGrID2, r_ProdG2_220.PGrName2, r_Prods_216.PGrID3, r_ProdG3_221.PGrName3, r_Prods_216.PGrAID, r_ProdA_235.PGrAName, t_EppD_12.ProdID, r_Prods_216.ProdName, r_Prods_216.Notes, r_Prods_216.Article1, r_Prods_216.Article2, r_Prods_216.Article3, r_Prods_216.PGrID4, r_Prods_216.PGrID5, at_r_ProdG4_317.PGrName4, at_r_ProdG5_318.PGrName5, t_PInP_215.ProdBarCode


-->>> На конец - Перемещение товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Exc_13.OurID, r_Ours_63.OurName, t_Exc_13.NewStockID, r_Stocks_69.StockName StockName, r_Stocks_69.StockGID, r_StockGs_241.StockGName, t_Exc_13.CodeID1, r_Codes1_64.CodeName1, t_Exc_13.CodeID2, r_Codes2_65.CodeName2, t_Exc_13.CodeID3, r_Codes3_66.CodeName3, t_Exc_13.CodeID4, r_Codes4_67.CodeName4, t_Exc_13.CodeID5, r_Codes5_68.CodeName5, r_Prods_160.Country, r_Prods_160.PBGrID, r_ProdBG_166.PBGrName, r_Prods_160.PCatID, r_ProdC_161.PCatName, r_Prods_160.PGrID, r_ProdG_162.PGrName, r_Prods_160.PGrID1, r_ProdG1_163.PGrName1, r_Prods_160.PGrID2, r_ProdG2_164.PGrName2, r_Prods_160.PGrID3, r_ProdG3_165.PGrName3, r_Prods_160.PGrAID, r_ProdA_228.PGrAName, t_ExcD_14.ProdID, r_Prods_160.ProdName, r_Prods_160.Notes, r_Prods_160.Article1, r_Prods_160.Article2, r_Prods_160.Article3, r_Prods_160.PGrID4, r_Prods_160.PGrID5, at_r_ProdG4_301.PGrName4, at_r_ProdG5_302.PGrName5, t_PInP_159.ProdBarCode ProdBarCode, 'На конец', SUM(t_ExcD_14.Qty) SumQty, SUM(t_ExcD_14.Qty * t_PInP_159.CostMC) CostSum FROM av_t_Exc t_Exc_13 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_64 WITH(NOLOCK) ON (t_Exc_13.CodeID1=r_Codes1_64.CodeID1)
INNER JOIN r_Codes2 r_Codes2_65 WITH(NOLOCK) ON (t_Exc_13.CodeID2=r_Codes2_65.CodeID2)
INNER JOIN r_Codes3 r_Codes3_66 WITH(NOLOCK) ON (t_Exc_13.CodeID3=r_Codes3_66.CodeID3)
INNER JOIN r_Codes4 r_Codes4_67 WITH(NOLOCK) ON (t_Exc_13.CodeID4=r_Codes4_67.CodeID4)
INNER JOIN r_Codes5 r_Codes5_68 WITH(NOLOCK) ON (t_Exc_13.CodeID5=r_Codes5_68.CodeID5)
INNER JOIN r_Ours r_Ours_63 WITH(NOLOCK) ON (t_Exc_13.OurID=r_Ours_63.OurID)
INNER JOIN r_Stocks r_Stocks_69 WITH(NOLOCK) ON (t_Exc_13.NewStockID=r_Stocks_69.StockID)
INNER JOIN av_t_ExcD t_ExcD_14 WITH(NOLOCK) ON (t_Exc_13.ChID=t_ExcD_14.ChID)
INNER JOIN r_StockGs r_StockGs_241 WITH(NOLOCK) ON (r_Stocks_69.StockGID=r_StockGs_241.StockGID)
INNER JOIN t_PInP t_PInP_159 WITH(NOLOCK) ON (t_ExcD_14.PPID=t_PInP_159.PPID AND t_ExcD_14.ProdID=t_PInP_159.ProdID)
INNER JOIN r_Prods r_Prods_160 WITH(NOLOCK) ON (t_PInP_159.ProdID=r_Prods_160.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_301 WITH(NOLOCK) ON (r_Prods_160.PGrID4=at_r_ProdG4_301.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_302 WITH(NOLOCK) ON (r_Prods_160.PGrID5=at_r_ProdG5_302.PGrID5)
INNER JOIN r_ProdA r_ProdA_228 WITH(NOLOCK) ON (r_Prods_160.PGrAID=r_ProdA_228.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_166 WITH(NOLOCK) ON (r_Prods_160.PBGrID=r_ProdBG_166.PBGrID)
INNER JOIN r_ProdC r_ProdC_161 WITH(NOLOCK) ON (r_Prods_160.PCatID=r_ProdC_161.PCatID)
INNER JOIN r_ProdG r_ProdG_162 WITH(NOLOCK) ON (r_Prods_160.PGrID=r_ProdG_162.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_163 WITH(NOLOCK) ON (r_Prods_160.PGrID1=r_ProdG1_163.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_164 WITH(NOLOCK) ON (r_Prods_160.PGrID2=r_ProdG2_164.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_165 WITH(NOLOCK) ON (r_Prods_160.PGrID3=r_ProdG3_165.PGrID3)
  WHERE  ((r_Prods_160.PGrID1 = 27) OR (r_Prods_160.PGrID1 = 28) OR (r_Prods_160.PGrID1 = 29) OR (r_Prods_160.PGrID1 = 63)) AND ((r_Prods_160.PCatID BETWEEN 1 AND 100)) AND ((t_Exc_13.NewStockID = 4) OR (t_Exc_13.NewStockID = 304)) AND (t_Exc_13.DocDate <= '20190618') GROUP BY t_Exc_13.OurID, r_Ours_63.OurName, t_Exc_13.NewStockID, r_Stocks_69.StockName, r_Stocks_69.StockGID, r_StockGs_241.StockGName, t_Exc_13.CodeID1, r_Codes1_64.CodeName1, t_Exc_13.CodeID2, r_Codes2_65.CodeName2, t_Exc_13.CodeID3, r_Codes3_66.CodeName3, t_Exc_13.CodeID4, r_Codes4_67.CodeName4, t_Exc_13.CodeID5, r_Codes5_68.CodeName5, r_Prods_160.Country, r_Prods_160.PBGrID, r_ProdBG_166.PBGrName, r_Prods_160.PCatID, r_ProdC_161.PCatName, r_Prods_160.PGrID, r_ProdG_162.PGrName, r_Prods_160.PGrID1, r_ProdG1_163.PGrName1, r_Prods_160.PGrID2, r_ProdG2_164.PGrName2, r_Prods_160.PGrID3, r_ProdG3_165.PGrName3, r_Prods_160.PGrAID, r_ProdA_228.PGrAName, t_ExcD_14.ProdID, r_Prods_160.ProdName, r_Prods_160.Notes, r_Prods_160.Article1, r_Prods_160.Article2, r_Prods_160.Article3, r_Prods_160.PGrID4, r_Prods_160.PGrID5, at_r_ProdG4_301.PGrName4, at_r_ProdG5_302.PGrName5, t_PInP_159.ProdBarCode


-->>> На конец - Перемещение товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Exc_15.OurID, r_Ours_70.OurName, t_Exc_15.StockID, r_Stocks_76.StockName StockName, r_Stocks_76.StockGID, r_StockGs_242.StockGName, t_Exc_15.CodeID1, r_Codes1_71.CodeName1, t_Exc_15.CodeID2, r_Codes2_72.CodeName2, t_Exc_15.CodeID3, r_Codes3_73.CodeName3, t_Exc_15.CodeID4, r_Codes4_74.CodeName4, t_Exc_15.CodeID5, r_Codes5_75.CodeName5, r_Prods_168.Country, r_Prods_168.PBGrID, r_ProdBG_174.PBGrName, r_Prods_168.PCatID, r_ProdC_169.PCatName, r_Prods_168.PGrID, r_ProdG_170.PGrName, r_Prods_168.PGrID1, r_ProdG1_171.PGrName1, r_Prods_168.PGrID2, r_ProdG2_172.PGrName2, r_Prods_168.PGrID3, r_ProdG3_173.PGrName3, r_Prods_168.PGrAID, r_ProdA_229.PGrAName, t_ExcD_16.ProdID, r_Prods_168.ProdName, r_Prods_168.Notes, r_Prods_168.Article1, r_Prods_168.Article2, r_Prods_168.Article3, r_Prods_168.PGrID4, r_Prods_168.PGrID5, at_r_ProdG4_303.PGrName4, at_r_ProdG5_304.PGrName5, t_PInP_167.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_ExcD_16.Qty)) SumQty, SUM(0-(t_ExcD_16.Qty * t_PInP_167.CostMC)) CostSum FROM av_t_Exc t_Exc_15 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_71 WITH(NOLOCK) ON (t_Exc_15.CodeID1=r_Codes1_71.CodeID1)
INNER JOIN r_Codes2 r_Codes2_72 WITH(NOLOCK) ON (t_Exc_15.CodeID2=r_Codes2_72.CodeID2)
INNER JOIN r_Codes3 r_Codes3_73 WITH(NOLOCK) ON (t_Exc_15.CodeID3=r_Codes3_73.CodeID3)
INNER JOIN r_Codes4 r_Codes4_74 WITH(NOLOCK) ON (t_Exc_15.CodeID4=r_Codes4_74.CodeID4)
INNER JOIN r_Codes5 r_Codes5_75 WITH(NOLOCK) ON (t_Exc_15.CodeID5=r_Codes5_75.CodeID5)
INNER JOIN r_Ours r_Ours_70 WITH(NOLOCK) ON (t_Exc_15.OurID=r_Ours_70.OurID)
INNER JOIN r_Stocks r_Stocks_76 WITH(NOLOCK) ON (t_Exc_15.StockID=r_Stocks_76.StockID)
INNER JOIN av_t_ExcD t_ExcD_16 WITH(NOLOCK) ON (t_Exc_15.ChID=t_ExcD_16.ChID)
INNER JOIN r_StockGs r_StockGs_242 WITH(NOLOCK) ON (r_Stocks_76.StockGID=r_StockGs_242.StockGID)
INNER JOIN t_PInP t_PInP_167 WITH(NOLOCK) ON (t_ExcD_16.PPID=t_PInP_167.PPID AND t_ExcD_16.ProdID=t_PInP_167.ProdID)
INNER JOIN r_Prods r_Prods_168 WITH(NOLOCK) ON (t_PInP_167.ProdID=r_Prods_168.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_303 WITH(NOLOCK) ON (r_Prods_168.PGrID4=at_r_ProdG4_303.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_304 WITH(NOLOCK) ON (r_Prods_168.PGrID5=at_r_ProdG5_304.PGrID5)
INNER JOIN r_ProdA r_ProdA_229 WITH(NOLOCK) ON (r_Prods_168.PGrAID=r_ProdA_229.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_174 WITH(NOLOCK) ON (r_Prods_168.PBGrID=r_ProdBG_174.PBGrID)
INNER JOIN r_ProdC r_ProdC_169 WITH(NOLOCK) ON (r_Prods_168.PCatID=r_ProdC_169.PCatID)
INNER JOIN r_ProdG r_ProdG_170 WITH(NOLOCK) ON (r_Prods_168.PGrID=r_ProdG_170.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_171 WITH(NOLOCK) ON (r_Prods_168.PGrID1=r_ProdG1_171.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_172 WITH(NOLOCK) ON (r_Prods_168.PGrID2=r_ProdG2_172.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_173 WITH(NOLOCK) ON (r_Prods_168.PGrID3=r_ProdG3_173.PGrID3)
  WHERE  ((r_Prods_168.PGrID1 = 27) OR (r_Prods_168.PGrID1 = 28) OR (r_Prods_168.PGrID1 = 29) OR (r_Prods_168.PGrID1 = 63)) AND ((r_Prods_168.PCatID BETWEEN 1 AND 100)) AND ((t_Exc_15.StockID = 4) OR (t_Exc_15.StockID = 304)) AND (t_Exc_15.DocDate <= '20190618') GROUP BY t_Exc_15.OurID, r_Ours_70.OurName, t_Exc_15.StockID, r_Stocks_76.StockName, r_Stocks_76.StockGID, r_StockGs_242.StockGName, t_Exc_15.CodeID1, r_Codes1_71.CodeName1, t_Exc_15.CodeID2, r_Codes2_72.CodeName2, t_Exc_15.CodeID3, r_Codes3_73.CodeName3, t_Exc_15.CodeID4, r_Codes4_74.CodeName4, t_Exc_15.CodeID5, r_Codes5_75.CodeName5, r_Prods_168.Country, r_Prods_168.PBGrID, r_ProdBG_174.PBGrName, r_Prods_168.PCatID, r_ProdC_169.PCatName, r_Prods_168.PGrID, r_ProdG_170.PGrName, r_Prods_168.PGrID1, r_ProdG1_171.PGrName1, r_Prods_168.PGrID2, r_ProdG2_172.PGrName2, r_Prods_168.PGrID3, r_ProdG3_173.PGrName3, r_Prods_168.PGrAID, r_ProdA_229.PGrAName, t_ExcD_16.ProdID, r_Prods_168.ProdName, r_Prods_168.Notes, r_Prods_168.Article1, r_Prods_168.Article2, r_Prods_168.Article3, r_Prods_168.PGrID4, r_Prods_168.PGrID5, at_r_ProdG4_303.PGrName4, at_r_ProdG5_304.PGrName5, t_PInP_167.ProdBarCode


-->>> На конец - Инвентаризация товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Ven_17.OurID, r_Ours_49.OurName, t_Ven_17.StockID, r_Stocks_55.StockName StockName, r_Stocks_55.StockGID, r_StockGs_239.StockGName, t_Ven_17.CodeID1, r_Codes1_50.CodeName1, t_Ven_17.CodeID2, r_Codes2_51.CodeName2, t_Ven_17.CodeID3, r_Codes3_52.CodeName3, t_Ven_17.CodeID4, r_Codes4_53.CodeName4, t_Ven_17.CodeID5, r_Codes5_54.CodeName5, r_Prods_144.Country, r_Prods_144.PBGrID, r_ProdBG_150.PBGrName, r_Prods_144.PCatID, r_ProdC_145.PCatName, r_Prods_144.PGrID, r_ProdG_146.PGrName, r_Prods_144.PGrID1, r_ProdG1_147.PGrName1, r_Prods_144.PGrID2, r_ProdG2_148.PGrName2, r_Prods_144.PGrID3, r_ProdG3_149.PGrName3, r_Prods_144.PGrAID, r_ProdA_226.PGrAName, t_VenA_18.ProdID, r_Prods_144.ProdName, r_Prods_144.Notes, r_Prods_144.Article1, r_Prods_144.Article2, r_Prods_144.Article3, r_Prods_144.PGrID4, r_Prods_144.PGrID5, at_r_ProdG4_297.PGrName4, at_r_ProdG5_298.PGrName5, t_PInP_143.ProdBarCode ProdBarCode, 'На конец', SUM(t_VenD_19.NewQty) SumQty, SUM(t_VenD_19.NewQty * t_PInP_143.CostMC) CostSum FROM av_t_Ven t_Ven_17 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_50 WITH(NOLOCK) ON (t_Ven_17.CodeID1=r_Codes1_50.CodeID1)
INNER JOIN r_Codes2 r_Codes2_51 WITH(NOLOCK) ON (t_Ven_17.CodeID2=r_Codes2_51.CodeID2)
INNER JOIN r_Codes3 r_Codes3_52 WITH(NOLOCK) ON (t_Ven_17.CodeID3=r_Codes3_52.CodeID3)
INNER JOIN r_Codes4 r_Codes4_53 WITH(NOLOCK) ON (t_Ven_17.CodeID4=r_Codes4_53.CodeID4)
INNER JOIN r_Codes5 r_Codes5_54 WITH(NOLOCK) ON (t_Ven_17.CodeID5=r_Codes5_54.CodeID5)
INNER JOIN r_Ours r_Ours_49 WITH(NOLOCK) ON (t_Ven_17.OurID=r_Ours_49.OurID)
INNER JOIN r_Stocks r_Stocks_55 WITH(NOLOCK) ON (t_Ven_17.StockID=r_Stocks_55.StockID)
INNER JOIN av_t_VenA t_VenA_18 WITH(NOLOCK) ON (t_Ven_17.ChID=t_VenA_18.ChID)
INNER JOIN r_StockGs r_StockGs_239 WITH(NOLOCK) ON (r_Stocks_55.StockGID=r_StockGs_239.StockGID)
INNER JOIN av_t_VenD t_VenD_19 WITH(NOLOCK) ON (t_VenA_18.ChID=t_VenD_19.ChID AND t_VenA_18.ProdID=t_VenD_19.DetProdID)
INNER JOIN t_PInP t_PInP_143 WITH(NOLOCK) ON (t_VenD_19.PPID=t_PInP_143.PPID AND t_VenD_19.DetProdID=t_PInP_143.ProdID)
INNER JOIN r_Prods r_Prods_144 WITH(NOLOCK) ON (t_PInP_143.ProdID=r_Prods_144.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_297 WITH(NOLOCK) ON (r_Prods_144.PGrID4=at_r_ProdG4_297.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_298 WITH(NOLOCK) ON (r_Prods_144.PGrID5=at_r_ProdG5_298.PGrID5)
INNER JOIN r_ProdA r_ProdA_226 WITH(NOLOCK) ON (r_Prods_144.PGrAID=r_ProdA_226.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_150 WITH(NOLOCK) ON (r_Prods_144.PBGrID=r_ProdBG_150.PBGrID)
INNER JOIN r_ProdC r_ProdC_145 WITH(NOLOCK) ON (r_Prods_144.PCatID=r_ProdC_145.PCatID)
INNER JOIN r_ProdG r_ProdG_146 WITH(NOLOCK) ON (r_Prods_144.PGrID=r_ProdG_146.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_147 WITH(NOLOCK) ON (r_Prods_144.PGrID1=r_ProdG1_147.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_148 WITH(NOLOCK) ON (r_Prods_144.PGrID2=r_ProdG2_148.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_149 WITH(NOLOCK) ON (r_Prods_144.PGrID3=r_ProdG3_149.PGrID3)
  WHERE  ((r_Prods_144.PGrID1 = 27) OR (r_Prods_144.PGrID1 = 28) OR (r_Prods_144.PGrID1 = 29) OR (r_Prods_144.PGrID1 = 63)) AND ((r_Prods_144.PCatID BETWEEN 1 AND 100)) AND ((t_Ven_17.StockID = 4) OR (t_Ven_17.StockID = 304)) AND (t_Ven_17.DocDate <= '20190618') GROUP BY t_Ven_17.OurID, r_Ours_49.OurName, t_Ven_17.StockID, r_Stocks_55.StockName, r_Stocks_55.StockGID, r_StockGs_239.StockGName, t_Ven_17.CodeID1, r_Codes1_50.CodeName1, t_Ven_17.CodeID2, r_Codes2_51.CodeName2, t_Ven_17.CodeID3, r_Codes3_52.CodeName3, t_Ven_17.CodeID4, r_Codes4_53.CodeName4, t_Ven_17.CodeID5, r_Codes5_54.CodeName5, r_Prods_144.Country, r_Prods_144.PBGrID, r_ProdBG_150.PBGrName, r_Prods_144.PCatID, r_ProdC_145.PCatName, r_Prods_144.PGrID, r_ProdG_146.PGrName, r_Prods_144.PGrID1, r_ProdG1_147.PGrName1, r_Prods_144.PGrID2, r_ProdG2_148.PGrName2, r_Prods_144.PGrID3, r_ProdG3_149.PGrName3, r_Prods_144.PGrAID, r_ProdA_226.PGrAName, t_VenA_18.ProdID, r_Prods_144.ProdName, r_Prods_144.Notes, r_Prods_144.Article1, r_Prods_144.Article2, r_Prods_144.Article3, r_Prods_144.PGrID4, r_Prods_144.PGrID5, at_r_ProdG4_297.PGrName4, at_r_ProdG5_298.PGrName5, t_PInP_143.ProdBarCode


-->>> На конец - Инвентаризация товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Ven_20.OurID, r_Ours_56.OurName, t_Ven_20.StockID, r_Stocks_62.StockName StockName, r_Stocks_62.StockGID, r_StockGs_240.StockGName, t_Ven_20.CodeID1, r_Codes1_57.CodeName1, t_Ven_20.CodeID2, r_Codes2_58.CodeName2, t_Ven_20.CodeID3, r_Codes3_59.CodeName3, t_Ven_20.CodeID4, r_Codes4_60.CodeName4, t_Ven_20.CodeID5, r_Codes5_61.CodeName5, r_Prods_152.Country, r_Prods_152.PBGrID, r_ProdBG_158.PBGrName, r_Prods_152.PCatID, r_ProdC_153.PCatName, r_Prods_152.PGrID, r_ProdG_154.PGrName, r_Prods_152.PGrID1, r_ProdG1_155.PGrName1, r_Prods_152.PGrID2, r_ProdG2_156.PGrName2, r_Prods_152.PGrID3, r_ProdG3_157.PGrName3, r_Prods_152.PGrAID, r_ProdA_227.PGrAName, t_VenA_21.ProdID, r_Prods_152.ProdName, r_Prods_152.Notes, r_Prods_152.Article1, r_Prods_152.Article2, r_Prods_152.Article3, r_Prods_152.PGrID4, r_Prods_152.PGrID5, at_r_ProdG4_299.PGrName4, at_r_ProdG5_300.PGrName5, t_PInP_151.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_VenD_22.Qty)) SumQty, SUM(0-(t_VenD_22.Qty * t_PInP_151.CostMC)) CostSum FROM av_t_Ven t_Ven_20 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_57 WITH(NOLOCK) ON (t_Ven_20.CodeID1=r_Codes1_57.CodeID1)
INNER JOIN r_Codes2 r_Codes2_58 WITH(NOLOCK) ON (t_Ven_20.CodeID2=r_Codes2_58.CodeID2)
INNER JOIN r_Codes3 r_Codes3_59 WITH(NOLOCK) ON (t_Ven_20.CodeID3=r_Codes3_59.CodeID3)
INNER JOIN r_Codes4 r_Codes4_60 WITH(NOLOCK) ON (t_Ven_20.CodeID4=r_Codes4_60.CodeID4)
INNER JOIN r_Codes5 r_Codes5_61 WITH(NOLOCK) ON (t_Ven_20.CodeID5=r_Codes5_61.CodeID5)
INNER JOIN r_Ours r_Ours_56 WITH(NOLOCK) ON (t_Ven_20.OurID=r_Ours_56.OurID)
INNER JOIN r_Stocks r_Stocks_62 WITH(NOLOCK) ON (t_Ven_20.StockID=r_Stocks_62.StockID)
INNER JOIN av_t_VenA t_VenA_21 WITH(NOLOCK) ON (t_Ven_20.ChID=t_VenA_21.ChID)
INNER JOIN r_StockGs r_StockGs_240 WITH(NOLOCK) ON (r_Stocks_62.StockGID=r_StockGs_240.StockGID)
INNER JOIN av_t_VenD t_VenD_22 WITH(NOLOCK) ON (t_VenA_21.ChID=t_VenD_22.ChID AND t_VenA_21.ProdID=t_VenD_22.DetProdID)
INNER JOIN t_PInP t_PInP_151 WITH(NOLOCK) ON (t_VenD_22.PPID=t_PInP_151.PPID AND t_VenD_22.DetProdID=t_PInP_151.ProdID)
INNER JOIN r_Prods r_Prods_152 WITH(NOLOCK) ON (t_PInP_151.ProdID=r_Prods_152.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_299 WITH(NOLOCK) ON (r_Prods_152.PGrID4=at_r_ProdG4_299.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_300 WITH(NOLOCK) ON (r_Prods_152.PGrID5=at_r_ProdG5_300.PGrID5)
INNER JOIN r_ProdA r_ProdA_227 WITH(NOLOCK) ON (r_Prods_152.PGrAID=r_ProdA_227.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_158 WITH(NOLOCK) ON (r_Prods_152.PBGrID=r_ProdBG_158.PBGrID)
INNER JOIN r_ProdC r_ProdC_153 WITH(NOLOCK) ON (r_Prods_152.PCatID=r_ProdC_153.PCatID)
INNER JOIN r_ProdG r_ProdG_154 WITH(NOLOCK) ON (r_Prods_152.PGrID=r_ProdG_154.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_155 WITH(NOLOCK) ON (r_Prods_152.PGrID1=r_ProdG1_155.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_156 WITH(NOLOCK) ON (r_Prods_152.PGrID2=r_ProdG2_156.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_157 WITH(NOLOCK) ON (r_Prods_152.PGrID3=r_ProdG3_157.PGrID3)
  WHERE  ((r_Prods_152.PGrID1 = 27) OR (r_Prods_152.PGrID1 = 28) OR (r_Prods_152.PGrID1 = 29) OR (r_Prods_152.PGrID1 = 63)) AND ((r_Prods_152.PCatID BETWEEN 1 AND 100)) AND ((t_Ven_20.StockID = 4) OR (t_Ven_20.StockID = 304)) AND (t_Ven_20.DocDate <= '20190618') GROUP BY t_Ven_20.OurID, r_Ours_56.OurName, t_Ven_20.StockID, r_Stocks_62.StockName, r_Stocks_62.StockGID, r_StockGs_240.StockGName, t_Ven_20.CodeID1, r_Codes1_57.CodeName1, t_Ven_20.CodeID2, r_Codes2_58.CodeName2, t_Ven_20.CodeID3, r_Codes3_59.CodeName3, t_Ven_20.CodeID4, r_Codes4_60.CodeName4, t_Ven_20.CodeID5, r_Codes5_61.CodeName5, r_Prods_152.Country, r_Prods_152.PBGrID, r_ProdBG_158.PBGrName, r_Prods_152.PCatID, r_ProdC_153.PCatName, r_Prods_152.PGrID, r_ProdG_154.PGrName, r_Prods_152.PGrID1, r_ProdG1_155.PGrName1, r_Prods_152.PGrID2, r_ProdG2_156.PGrName2, r_Prods_152.PGrID3, r_ProdG3_157.PGrName3, r_Prods_152.PGrAID, r_ProdA_227.PGrAName, t_VenA_21.ProdID, r_Prods_152.ProdName, r_Prods_152.Notes, r_Prods_152.Article1, r_Prods_152.Article2, r_Prods_152.Article3, r_Prods_152.PGrID4, r_Prods_152.PGrID5, at_r_ProdG4_299.PGrName4, at_r_ProdG5_300.PGrName5, t_PInP_151.ProdBarCode


-->>> На конец - Переоценка цен прихода (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Est_23.OurID, r_Ours_77.OurName, t_Est_23.StockID, r_Stocks_83.StockName StockName, r_Stocks_83.StockGID, r_StockGs_243.StockGName, t_Est_23.CodeID1, r_Codes1_78.CodeName1, t_Est_23.CodeID2, r_Codes2_79.CodeName2, t_Est_23.CodeID3, r_Codes3_80.CodeName3, t_Est_23.CodeID4, r_Codes4_81.CodeName4, t_Est_23.CodeID5, r_Codes5_82.CodeName5, r_Prods_176.Country, r_Prods_176.PBGrID, r_ProdBG_182.PBGrName, r_Prods_176.PCatID, r_ProdC_177.PCatName, r_Prods_176.PGrID, r_ProdG_178.PGrName, r_Prods_176.PGrID1, r_ProdG1_179.PGrName1, r_Prods_176.PGrID2, r_ProdG2_180.PGrName2, r_Prods_176.PGrID3, r_ProdG3_181.PGrName3, r_Prods_176.PGrAID, r_ProdA_230.PGrAName, t_EstD_24.ProdID, r_Prods_176.ProdName, r_Prods_176.Notes, r_Prods_176.Article1, r_Prods_176.Article2, r_Prods_176.Article3, r_Prods_176.PGrID4, r_Prods_176.PGrID5, at_r_ProdG4_305.PGrName4, at_r_ProdG5_306.PGrName5, t_PInP_175.ProdBarCode ProdBarCode, 'На конец', SUM(t_EstD_24.Qty) SumQty, SUM(t_EstD_24.Qty * t_PInP_175.CostMC) CostSum FROM av_t_Est t_Est_23 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_78 WITH(NOLOCK) ON (t_Est_23.CodeID1=r_Codes1_78.CodeID1)
INNER JOIN r_Codes2 r_Codes2_79 WITH(NOLOCK) ON (t_Est_23.CodeID2=r_Codes2_79.CodeID2)
INNER JOIN r_Codes3 r_Codes3_80 WITH(NOLOCK) ON (t_Est_23.CodeID3=r_Codes3_80.CodeID3)
INNER JOIN r_Codes4 r_Codes4_81 WITH(NOLOCK) ON (t_Est_23.CodeID4=r_Codes4_81.CodeID4)
INNER JOIN r_Codes5 r_Codes5_82 WITH(NOLOCK) ON (t_Est_23.CodeID5=r_Codes5_82.CodeID5)
INNER JOIN r_Ours r_Ours_77 WITH(NOLOCK) ON (t_Est_23.OurID=r_Ours_77.OurID)
INNER JOIN r_Stocks r_Stocks_83 WITH(NOLOCK) ON (t_Est_23.StockID=r_Stocks_83.StockID)
INNER JOIN av_t_EstD t_EstD_24 WITH(NOLOCK) ON (t_Est_23.ChID=t_EstD_24.ChID)
INNER JOIN r_StockGs r_StockGs_243 WITH(NOLOCK) ON (r_Stocks_83.StockGID=r_StockGs_243.StockGID)
INNER JOIN t_PInP t_PInP_175 WITH(NOLOCK) ON (t_EstD_24.NewPPID=t_PInP_175.PPID AND t_EstD_24.ProdID=t_PInP_175.ProdID)
INNER JOIN r_Prods r_Prods_176 WITH(NOLOCK) ON (t_PInP_175.ProdID=r_Prods_176.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_305 WITH(NOLOCK) ON (r_Prods_176.PGrID4=at_r_ProdG4_305.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_306 WITH(NOLOCK) ON (r_Prods_176.PGrID5=at_r_ProdG5_306.PGrID5)
INNER JOIN r_ProdA r_ProdA_230 WITH(NOLOCK) ON (r_Prods_176.PGrAID=r_ProdA_230.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_182 WITH(NOLOCK) ON (r_Prods_176.PBGrID=r_ProdBG_182.PBGrID)
INNER JOIN r_ProdC r_ProdC_177 WITH(NOLOCK) ON (r_Prods_176.PCatID=r_ProdC_177.PCatID)
INNER JOIN r_ProdG r_ProdG_178 WITH(NOLOCK) ON (r_Prods_176.PGrID=r_ProdG_178.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_179 WITH(NOLOCK) ON (r_Prods_176.PGrID1=r_ProdG1_179.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_180 WITH(NOLOCK) ON (r_Prods_176.PGrID2=r_ProdG2_180.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_181 WITH(NOLOCK) ON (r_Prods_176.PGrID3=r_ProdG3_181.PGrID3)
  WHERE  ((r_Prods_176.PGrID1 = 27) OR (r_Prods_176.PGrID1 = 28) OR (r_Prods_176.PGrID1 = 29) OR (r_Prods_176.PGrID1 = 63)) AND ((r_Prods_176.PCatID BETWEEN 1 AND 100)) AND ((t_Est_23.StockID = 4) OR (t_Est_23.StockID = 304)) AND (t_Est_23.DocDate <= '20190618') GROUP BY t_Est_23.OurID, r_Ours_77.OurName, t_Est_23.StockID, r_Stocks_83.StockName, r_Stocks_83.StockGID, r_StockGs_243.StockGName, t_Est_23.CodeID1, r_Codes1_78.CodeName1, t_Est_23.CodeID2, r_Codes2_79.CodeName2, t_Est_23.CodeID3, r_Codes3_80.CodeName3, t_Est_23.CodeID4, r_Codes4_81.CodeName4, t_Est_23.CodeID5, r_Codes5_82.CodeName5, r_Prods_176.Country, r_Prods_176.PBGrID, r_ProdBG_182.PBGrName, r_Prods_176.PCatID, r_ProdC_177.PCatName, r_Prods_176.PGrID, r_ProdG_178.PGrName, r_Prods_176.PGrID1, r_ProdG1_179.PGrName1, r_Prods_176.PGrID2, r_ProdG2_180.PGrName2, r_Prods_176.PGrID3, r_ProdG3_181.PGrName3, r_Prods_176.PGrAID, r_ProdA_230.PGrAName, t_EstD_24.ProdID, r_Prods_176.ProdName, r_Prods_176.Notes, r_Prods_176.Article1, r_Prods_176.Article2, r_Prods_176.Article3, r_Prods_176.PGrID4, r_Prods_176.PGrID5, at_r_ProdG4_305.PGrName4, at_r_ProdG5_306.PGrName5, t_PInP_175.ProdBarCode


-->>> На конец - Переоценка цен прихода (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Est_25.OurID, r_Ours_84.OurName, t_Est_25.StockID, r_Stocks_90.StockName StockName, r_Stocks_90.StockGID, r_StockGs_244.StockGName, t_Est_25.CodeID1, r_Codes1_85.CodeName1, t_Est_25.CodeID2, r_Codes2_86.CodeName2, t_Est_25.CodeID3, r_Codes3_87.CodeName3, t_Est_25.CodeID4, r_Codes4_88.CodeName4, t_Est_25.CodeID5, r_Codes5_89.CodeName5, r_Prods_184.Country, r_Prods_184.PBGrID, r_ProdBG_190.PBGrName, r_Prods_184.PCatID, r_ProdC_185.PCatName, r_Prods_184.PGrID, r_ProdG_186.PGrName, r_Prods_184.PGrID1, r_ProdG1_187.PGrName1, r_Prods_184.PGrID2, r_ProdG2_188.PGrName2, r_Prods_184.PGrID3, r_ProdG3_189.PGrName3, r_Prods_184.PGrAID, r_ProdA_231.PGrAName, t_EstD_26.ProdID, r_Prods_184.ProdName, r_Prods_184.Notes, r_Prods_184.Article1, r_Prods_184.Article2, r_Prods_184.Article3, r_Prods_184.PGrID4, r_Prods_184.PGrID5, at_r_ProdG4_307.PGrName4, at_r_ProdG5_308.PGrName5, t_PInP_183.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_EstD_26.Qty)) SumQty, SUM(0-(t_EstD_26.Qty * t_PInP_183.CostMC)) CostSum FROM av_t_Est t_Est_25 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_85 WITH(NOLOCK) ON (t_Est_25.CodeID1=r_Codes1_85.CodeID1)
INNER JOIN r_Codes2 r_Codes2_86 WITH(NOLOCK) ON (t_Est_25.CodeID2=r_Codes2_86.CodeID2)
INNER JOIN r_Codes3 r_Codes3_87 WITH(NOLOCK) ON (t_Est_25.CodeID3=r_Codes3_87.CodeID3)
INNER JOIN r_Codes4 r_Codes4_88 WITH(NOLOCK) ON (t_Est_25.CodeID4=r_Codes4_88.CodeID4)
INNER JOIN r_Codes5 r_Codes5_89 WITH(NOLOCK) ON (t_Est_25.CodeID5=r_Codes5_89.CodeID5)
INNER JOIN r_Ours r_Ours_84 WITH(NOLOCK) ON (t_Est_25.OurID=r_Ours_84.OurID)
INNER JOIN r_Stocks r_Stocks_90 WITH(NOLOCK) ON (t_Est_25.StockID=r_Stocks_90.StockID)
INNER JOIN av_t_EstD t_EstD_26 WITH(NOLOCK) ON (t_Est_25.ChID=t_EstD_26.ChID)
INNER JOIN r_StockGs r_StockGs_244 WITH(NOLOCK) ON (r_Stocks_90.StockGID=r_StockGs_244.StockGID)
INNER JOIN t_PInP t_PInP_183 WITH(NOLOCK) ON (t_EstD_26.PPID=t_PInP_183.PPID AND t_EstD_26.ProdID=t_PInP_183.ProdID)
INNER JOIN r_Prods r_Prods_184 WITH(NOLOCK) ON (t_PInP_183.ProdID=r_Prods_184.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_307 WITH(NOLOCK) ON (r_Prods_184.PGrID4=at_r_ProdG4_307.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_308 WITH(NOLOCK) ON (r_Prods_184.PGrID5=at_r_ProdG5_308.PGrID5)
INNER JOIN r_ProdA r_ProdA_231 WITH(NOLOCK) ON (r_Prods_184.PGrAID=r_ProdA_231.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_190 WITH(NOLOCK) ON (r_Prods_184.PBGrID=r_ProdBG_190.PBGrID)
INNER JOIN r_ProdC r_ProdC_185 WITH(NOLOCK) ON (r_Prods_184.PCatID=r_ProdC_185.PCatID)
INNER JOIN r_ProdG r_ProdG_186 WITH(NOLOCK) ON (r_Prods_184.PGrID=r_ProdG_186.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_187 WITH(NOLOCK) ON (r_Prods_184.PGrID1=r_ProdG1_187.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_188 WITH(NOLOCK) ON (r_Prods_184.PGrID2=r_ProdG2_188.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_189 WITH(NOLOCK) ON (r_Prods_184.PGrID3=r_ProdG3_189.PGrID3)
  WHERE  ((r_Prods_184.PGrID1 = 27) OR (r_Prods_184.PGrID1 = 28) OR (r_Prods_184.PGrID1 = 29) OR (r_Prods_184.PGrID1 = 63)) AND ((r_Prods_184.PCatID BETWEEN 1 AND 100)) AND ((t_Est_25.StockID = 4) OR (t_Est_25.StockID = 304)) AND (t_Est_25.DocDate <= '20190618') GROUP BY t_Est_25.OurID, r_Ours_84.OurName, t_Est_25.StockID, r_Stocks_90.StockName, r_Stocks_90.StockGID, r_StockGs_244.StockGName, t_Est_25.CodeID1, r_Codes1_85.CodeName1, t_Est_25.CodeID2, r_Codes2_86.CodeName2, t_Est_25.CodeID3, r_Codes3_87.CodeName3, t_Est_25.CodeID4, r_Codes4_88.CodeName4, t_Est_25.CodeID5, r_Codes5_89.CodeName5, r_Prods_184.Country, r_Prods_184.PBGrID, r_ProdBG_190.PBGrName, r_Prods_184.PCatID, r_ProdC_185.PCatName, r_Prods_184.PGrID, r_ProdG_186.PGrName, r_Prods_184.PGrID1, r_ProdG1_187.PGrName1, r_Prods_184.PGrID2, r_ProdG2_188.PGrName2, r_Prods_184.PGrID3, r_ProdG3_189.PGrName3, r_Prods_184.PGrAID, r_ProdA_231.PGrAName, t_EstD_26.ProdID, r_Prods_184.ProdName, r_Prods_184.Notes, r_Prods_184.Article1, r_Prods_184.Article2, r_Prods_184.Article3, r_Prods_184.PGrID4, r_Prods_184.PGrID5, at_r_ProdG4_307.PGrName4, at_r_ProdG5_308.PGrName5, t_PInP_183.ProdBarCode


-->>> На конец - Входящие остатки товара:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_zInP_27.OurID, r_Ours_42.OurName, t_zInP_27.StockID, r_Stocks_48.StockName StockName, r_Stocks_48.StockGID, r_StockGs_238.StockGName, t_zInP_27.CodeID1, r_Codes1_43.CodeName1, t_zInP_27.CodeID2, r_Codes2_44.CodeName2, t_zInP_27.CodeID3, r_Codes3_45.CodeName3, t_zInP_27.CodeID4, r_Codes4_46.CodeName4, t_zInP_27.CodeID5, r_Codes5_47.CodeName5, r_Prods_136.Country, r_Prods_136.PBGrID, r_ProdBG_142.PBGrName, r_Prods_136.PCatID, r_ProdC_137.PCatName, r_Prods_136.PGrID, r_ProdG_138.PGrName, r_Prods_136.PGrID1, r_ProdG1_139.PGrName1, r_Prods_136.PGrID2, r_ProdG2_140.PGrName2, r_Prods_136.PGrID3, r_ProdG3_141.PGrName3, r_Prods_136.PGrAID, r_ProdA_225.PGrAName, t_zInP_27.ProdID, r_Prods_136.ProdName, r_Prods_136.Notes, r_Prods_136.Article1, r_Prods_136.Article2, r_Prods_136.Article3, r_Prods_136.PGrID4, r_Prods_136.PGrID5, at_r_ProdG4_295.PGrName4, at_r_ProdG5_296.PGrName5, t_PInP_135.ProdBarCode ProdBarCode, 'На конец', SUM(t_zInP_27.Qty) SumQty, SUM(t_zInP_27.Qty * t_PInP_135.CostMC) CostSum FROM av_t_zInP t_zInP_27 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_43 WITH(NOLOCK) ON (t_zInP_27.CodeID1=r_Codes1_43.CodeID1)
INNER JOIN r_Codes2 r_Codes2_44 WITH(NOLOCK) ON (t_zInP_27.CodeID2=r_Codes2_44.CodeID2)
INNER JOIN r_Codes3 r_Codes3_45 WITH(NOLOCK) ON (t_zInP_27.CodeID3=r_Codes3_45.CodeID3)
INNER JOIN r_Codes4 r_Codes4_46 WITH(NOLOCK) ON (t_zInP_27.CodeID4=r_Codes4_46.CodeID4)
INNER JOIN r_Codes5 r_Codes5_47 WITH(NOLOCK) ON (t_zInP_27.CodeID5=r_Codes5_47.CodeID5)
INNER JOIN r_Ours r_Ours_42 WITH(NOLOCK) ON (t_zInP_27.OurID=r_Ours_42.OurID)
INNER JOIN r_Stocks r_Stocks_48 WITH(NOLOCK) ON (t_zInP_27.StockID=r_Stocks_48.StockID)
INNER JOIN t_PInP t_PInP_135 WITH(NOLOCK) ON (t_zInP_27.PPID=t_PInP_135.PPID AND t_zInP_27.ProdID=t_PInP_135.ProdID)
INNER JOIN r_StockGs r_StockGs_238 WITH(NOLOCK) ON (r_Stocks_48.StockGID=r_StockGs_238.StockGID)
INNER JOIN r_Prods r_Prods_136 WITH(NOLOCK) ON (t_PInP_135.ProdID=r_Prods_136.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_295 WITH(NOLOCK) ON (r_Prods_136.PGrID4=at_r_ProdG4_295.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_296 WITH(NOLOCK) ON (r_Prods_136.PGrID5=at_r_ProdG5_296.PGrID5)
INNER JOIN r_ProdA r_ProdA_225 WITH(NOLOCK) ON (r_Prods_136.PGrAID=r_ProdA_225.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_142 WITH(NOLOCK) ON (r_Prods_136.PBGrID=r_ProdBG_142.PBGrID)
INNER JOIN r_ProdC r_ProdC_137 WITH(NOLOCK) ON (r_Prods_136.PCatID=r_ProdC_137.PCatID)
INNER JOIN r_ProdG r_ProdG_138 WITH(NOLOCK) ON (r_Prods_136.PGrID=r_ProdG_138.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_139 WITH(NOLOCK) ON (r_Prods_136.PGrID1=r_ProdG1_139.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_140 WITH(NOLOCK) ON (r_Prods_136.PGrID2=r_ProdG2_140.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_141 WITH(NOLOCK) ON (r_Prods_136.PGrID3=r_ProdG3_141.PGrID3)
  WHERE  ((r_Prods_136.PGrID1 = 27) OR (r_Prods_136.PGrID1 = 28) OR (r_Prods_136.PGrID1 = 29) OR (r_Prods_136.PGrID1 = 63)) AND ((r_Prods_136.PCatID BETWEEN 1 AND 100)) AND ((t_zInP_27.StockID = 4) OR (t_zInP_27.StockID = 304)) GROUP BY t_zInP_27.OurID, r_Ours_42.OurName, t_zInP_27.StockID, r_Stocks_48.StockName, r_Stocks_48.StockGID, r_StockGs_238.StockGName, t_zInP_27.CodeID1, r_Codes1_43.CodeName1, t_zInP_27.CodeID2, r_Codes2_44.CodeName2, t_zInP_27.CodeID3, r_Codes3_45.CodeName3, t_zInP_27.CodeID4, r_Codes4_46.CodeName4, t_zInP_27.CodeID5, r_Codes5_47.CodeName5, r_Prods_136.Country, r_Prods_136.PBGrID, r_ProdBG_142.PBGrName, r_Prods_136.PCatID, r_ProdC_137.PCatName, r_Prods_136.PGrID, r_ProdG_138.PGrName, r_Prods_136.PGrID1, r_ProdG1_139.PGrName1, r_Prods_136.PGrID2, r_ProdG2_140.PGrName2, r_Prods_136.PGrID3, r_ProdG3_141.PGrName3, r_Prods_136.PGrAID, r_ProdA_225.PGrAName, t_zInP_27.ProdID, r_Prods_136.ProdName, r_Prods_136.Notes, r_Prods_136.Article1, r_Prods_136.Article2, r_Prods_136.Article3, r_Prods_136.PGrID4, r_Prods_136.PGrID5, at_r_ProdG4_295.PGrName4, at_r_ProdG5_296.PGrName5, t_PInP_135.ProdBarCode


-->>> На конец - Возврат товара по чеку:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_CRRet_249.OurID, r_Ours_265.OurName, t_CRRet_249.StockID, r_Stocks_271.StockName StockName, r_Stocks_271.StockGID, r_StockGs_272.StockGName, t_CRRet_249.CodeID1, r_Codes1_266.CodeName1, t_CRRet_249.CodeID2, r_Codes2_267.CodeName2, t_CRRet_249.CodeID3, r_Codes3_268.CodeName3, t_CRRet_249.CodeID4, r_Codes4_269.CodeName4, t_CRRet_249.CodeID5, r_Codes5_270.CodeName5, r_Prods_257.Country, r_Prods_257.PBGrID, r_ProdBG_264.PBGrName, r_Prods_257.PCatID, r_ProdC_258.PCatName, r_Prods_257.PGrID, r_ProdG_259.PGrName, r_Prods_257.PGrID1, r_ProdG1_260.PGrName1, r_Prods_257.PGrID2, r_ProdG2_261.PGrName2, r_Prods_257.PGrID3, r_ProdG3_262.PGrName3, r_Prods_257.PGrAID, r_ProdA_263.PGrAName, r_Prods_257.ProdID, r_Prods_257.ProdName, r_Prods_257.Notes, r_Prods_257.Article1, r_Prods_257.Article2, r_Prods_257.Article3, r_Prods_257.PGrID4, r_Prods_257.PGrID5, at_r_ProdG4_291.PGrName4, at_r_ProdG5_292.PGrName5, t_PInP_255.ProdBarCode ProdBarCode, 'На конец', SUM(t_CRRetD_250.Qty) SumQty, SUM(t_CRRetD_250.Qty * t_PInP_255.CostMC) CostSum FROM av_t_CRRet t_CRRet_249 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_266 WITH(NOLOCK) ON (t_CRRet_249.CodeID1=r_Codes1_266.CodeID1)
INNER JOIN r_Codes2 r_Codes2_267 WITH(NOLOCK) ON (t_CRRet_249.CodeID2=r_Codes2_267.CodeID2)
INNER JOIN r_Codes3 r_Codes3_268 WITH(NOLOCK) ON (t_CRRet_249.CodeID3=r_Codes3_268.CodeID3)
INNER JOIN r_Codes4 r_Codes4_269 WITH(NOLOCK) ON (t_CRRet_249.CodeID4=r_Codes4_269.CodeID4)
INNER JOIN r_Codes5 r_Codes5_270 WITH(NOLOCK) ON (t_CRRet_249.CodeID5=r_Codes5_270.CodeID5)
INNER JOIN r_Ours r_Ours_265 WITH(NOLOCK) ON (t_CRRet_249.OurID=r_Ours_265.OurID)
INNER JOIN r_Stocks r_Stocks_271 WITH(NOLOCK) ON (t_CRRet_249.StockID=r_Stocks_271.StockID)
INNER JOIN av_t_CRRetD t_CRRetD_250 WITH(NOLOCK) ON (t_CRRet_249.ChID=t_CRRetD_250.ChID)
INNER JOIN r_StockGs r_StockGs_272 WITH(NOLOCK) ON (r_Stocks_271.StockGID=r_StockGs_272.StockGID)
INNER JOIN t_PInP t_PInP_255 WITH(NOLOCK) ON (t_CRRetD_250.PPID=t_PInP_255.PPID AND t_CRRetD_250.ProdID=t_PInP_255.ProdID)
INNER JOIN r_Prods r_Prods_257 WITH(NOLOCK) ON (t_PInP_255.ProdID=r_Prods_257.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_291 WITH(NOLOCK) ON (r_Prods_257.PGrID4=at_r_ProdG4_291.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_292 WITH(NOLOCK) ON (r_Prods_257.PGrID5=at_r_ProdG5_292.PGrID5)
INNER JOIN r_ProdA r_ProdA_263 WITH(NOLOCK) ON (r_Prods_257.PGrAID=r_ProdA_263.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_264 WITH(NOLOCK) ON (r_Prods_257.PBGrID=r_ProdBG_264.PBGrID)
INNER JOIN r_ProdC r_ProdC_258 WITH(NOLOCK) ON (r_Prods_257.PCatID=r_ProdC_258.PCatID)
INNER JOIN r_ProdG r_ProdG_259 WITH(NOLOCK) ON (r_Prods_257.PGrID=r_ProdG_259.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_260 WITH(NOLOCK) ON (r_Prods_257.PGrID1=r_ProdG1_260.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_261 WITH(NOLOCK) ON (r_Prods_257.PGrID2=r_ProdG2_261.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_262 WITH(NOLOCK) ON (r_Prods_257.PGrID3=r_ProdG3_262.PGrID3)
  WHERE  ((r_Prods_257.PGrID1 = 27) OR (r_Prods_257.PGrID1 = 28) OR (r_Prods_257.PGrID1 = 29) OR (r_Prods_257.PGrID1 = 63)) AND ((r_Prods_257.PCatID BETWEEN 1 AND 100)) AND ((t_CRRet_249.StockID = 4) OR (t_CRRet_249.StockID = 304)) AND (t_CRRet_249.DocDate <= '20190618') GROUP BY t_CRRet_249.OurID, r_Ours_265.OurName, t_CRRet_249.StockID, r_Stocks_271.StockName, r_Stocks_271.StockGID, r_StockGs_272.StockGName, t_CRRet_249.CodeID1, r_Codes1_266.CodeName1, t_CRRet_249.CodeID2, r_Codes2_267.CodeName2, t_CRRet_249.CodeID3, r_Codes3_268.CodeName3, t_CRRet_249.CodeID4, r_Codes4_269.CodeName4, t_CRRet_249.CodeID5, r_Codes5_270.CodeName5, r_Prods_257.Country, r_Prods_257.PBGrID, r_ProdBG_264.PBGrName, r_Prods_257.PCatID, r_ProdC_258.PCatName, r_Prods_257.PGrID, r_ProdG_259.PGrName, r_Prods_257.PGrID1, r_ProdG1_260.PGrName1, r_Prods_257.PGrID2, r_ProdG2_261.PGrName2, r_Prods_257.PGrID3, r_ProdG3_262.PGrName3, r_Prods_257.PGrAID, r_ProdA_263.PGrAName, r_Prods_257.ProdID, r_Prods_257.ProdName, r_Prods_257.Notes, r_Prods_257.Article1, r_Prods_257.Article2, r_Prods_257.Article3, r_Prods_257.PGrID4, r_Prods_257.PGrID5, at_r_ProdG4_291.PGrName4, at_r_ProdG5_292.PGrName5, t_PInP_255.ProdBarCode


-->>> На конец - Продажа товара оператором:
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_Sale_251.OurID, r_Ours_287.OurName, t_Sale_251.StockID, r_Stocks_286.StockName StockName, r_Stocks_286.StockGID, r_StockGs_288.StockGName, t_Sale_251.CodeID1, r_Codes1_281.CodeName1, t_Sale_251.CodeID2, r_Codes2_282.CodeName2, t_Sale_251.CodeID3, r_Codes3_283.CodeName3, t_Sale_251.CodeID4, r_Codes4_284.CodeName4, t_Sale_251.CodeID5, r_Codes5_285.CodeName5, r_Prods_273.Country, r_Prods_273.PBGrID, r_ProdBG_280.PBGrName, r_Prods_273.PCatID, r_ProdC_274.PCatName, r_Prods_273.PGrID, r_ProdG_275.PGrName, r_Prods_273.PGrID1, r_ProdG1_276.PGrName1, r_Prods_273.PGrID2, r_ProdG2_277.PGrName2, r_Prods_273.PGrID3, r_ProdG3_278.PGrName3, r_Prods_273.PGrAID, r_ProdA_279.PGrAName, r_Prods_273.ProdID, r_Prods_273.ProdName, r_Prods_273.Notes, r_Prods_273.Article1, r_Prods_273.Article2, r_Prods_273.Article3, r_Prods_273.PGrID4, r_Prods_273.PGrID5, at_r_ProdG4_311.PGrName4, at_r_ProdG5_312.PGrName5, t_PInP_256.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_SaleD_252.Qty)) SumQty, SUM(0-(t_SaleD_252.Qty * t_PInP_256.CostMC)) CostSum FROM av_t_Sale t_Sale_251 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_281 WITH(NOLOCK) ON (t_Sale_251.CodeID1=r_Codes1_281.CodeID1)
INNER JOIN r_Codes2 r_Codes2_282 WITH(NOLOCK) ON (t_Sale_251.CodeID2=r_Codes2_282.CodeID2)
INNER JOIN r_Codes3 r_Codes3_283 WITH(NOLOCK) ON (t_Sale_251.CodeID3=r_Codes3_283.CodeID3)
INNER JOIN r_Codes4 r_Codes4_284 WITH(NOLOCK) ON (t_Sale_251.CodeID4=r_Codes4_284.CodeID4)
INNER JOIN r_Codes5 r_Codes5_285 WITH(NOLOCK) ON (t_Sale_251.CodeID5=r_Codes5_285.CodeID5)
INNER JOIN r_Ours r_Ours_287 WITH(NOLOCK) ON (t_Sale_251.OurID=r_Ours_287.OurID)
INNER JOIN r_Stocks r_Stocks_286 WITH(NOLOCK) ON (t_Sale_251.StockID=r_Stocks_286.StockID)
INNER JOIN av_t_SaleD t_SaleD_252 WITH(NOLOCK) ON (t_Sale_251.ChID=t_SaleD_252.ChID)
INNER JOIN r_StockGs r_StockGs_288 WITH(NOLOCK) ON (r_Stocks_286.StockGID=r_StockGs_288.StockGID)
INNER JOIN t_PInP t_PInP_256 WITH(NOLOCK) ON (t_SaleD_252.PPID=t_PInP_256.PPID AND t_SaleD_252.ProdID=t_PInP_256.ProdID)
INNER JOIN r_Prods r_Prods_273 WITH(NOLOCK) ON (t_PInP_256.ProdID=r_Prods_273.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_311 WITH(NOLOCK) ON (r_Prods_273.PGrID4=at_r_ProdG4_311.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_312 WITH(NOLOCK) ON (r_Prods_273.PGrID5=at_r_ProdG5_312.PGrID5)
INNER JOIN r_ProdA r_ProdA_279 WITH(NOLOCK) ON (r_Prods_273.PGrAID=r_ProdA_279.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_280 WITH(NOLOCK) ON (r_Prods_273.PBGrID=r_ProdBG_280.PBGrID)
INNER JOIN r_ProdC r_ProdC_274 WITH(NOLOCK) ON (r_Prods_273.PCatID=r_ProdC_274.PCatID)
INNER JOIN r_ProdG r_ProdG_275 WITH(NOLOCK) ON (r_Prods_273.PGrID=r_ProdG_275.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_276 WITH(NOLOCK) ON (r_Prods_273.PGrID1=r_ProdG1_276.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_277 WITH(NOLOCK) ON (r_Prods_273.PGrID2=r_ProdG2_277.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_278 WITH(NOLOCK) ON (r_Prods_273.PGrID3=r_ProdG3_278.PGrID3)
  WHERE  ((r_Prods_273.PGrID1 = 27) OR (r_Prods_273.PGrID1 = 28) OR (r_Prods_273.PGrID1 = 29) OR (r_Prods_273.PGrID1 = 63)) AND ((r_Prods_273.PCatID BETWEEN 1 AND 100)) AND ((t_Sale_251.StockID = 4) OR (t_Sale_251.StockID = 304)) AND (t_Sale_251.DocDate <= '20190618') GROUP BY t_Sale_251.OurID, r_Ours_287.OurName, t_Sale_251.StockID, r_Stocks_286.StockName, r_Stocks_286.StockGID, r_StockGs_288.StockGName, t_Sale_251.CodeID1, r_Codes1_281.CodeName1, t_Sale_251.CodeID2, r_Codes2_282.CodeName2, t_Sale_251.CodeID3, r_Codes3_283.CodeName3, t_Sale_251.CodeID4, r_Codes4_284.CodeName4, t_Sale_251.CodeID5, r_Codes5_285.CodeName5, r_Prods_273.Country, r_Prods_273.PBGrID, r_ProdBG_280.PBGrName, r_Prods_273.PCatID, r_ProdC_274.PCatName, r_Prods_273.PGrID, r_ProdG_275.PGrName, r_Prods_273.PGrID1, r_ProdG1_276.PGrName1, r_Prods_273.PGrID2, r_ProdG2_277.PGrName2, r_Prods_273.PGrID3, r_ProdG3_278.PGrName3, r_Prods_273.PGrAID, r_ProdA_279.PGrAName, r_Prods_273.ProdID, r_Prods_273.ProdName, r_Prods_273.Notes, r_Prods_273.Article1, r_Prods_273.Article2, r_Prods_273.Article3, r_Prods_273.PGrID4, r_Prods_273.PGrID5, at_r_ProdG4_311.PGrName4, at_r_ProdG5_312.PGrName5, t_PInP_256.ProdBarCode


-->>> На конец - Комплектация товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_SRec_319.OurID, r_Ours_324.OurName, t_SRec_319.StockID, r_Stocks_330.StockName StockName, r_Stocks_330.StockGID, r_StockGs_331.StockGName, t_SRec_319.CodeID1, r_Codes1_325.CodeName1, t_SRec_319.CodeID2, r_Codes2_326.CodeName2, t_SRec_319.CodeID3, r_Codes3_327.CodeName3, t_SRec_319.CodeID4, r_Codes4_328.CodeName4, t_SRec_319.CodeID5, r_Codes5_329.CodeName5, r_Prods_333.Country, r_Prods_333.PBGrID, r_ProdBG_336.PBGrName, r_Prods_333.PCatID, r_ProdC_337.PCatName, r_Prods_333.PGrID, r_ProdG_334.PGrName, r_Prods_333.PGrID1, r_ProdG1_338.PGrName1, r_Prods_333.PGrID2, r_ProdG2_339.PGrName2, r_Prods_333.PGrID3, r_ProdG3_340.PGrName3, r_Prods_333.PGrAID, r_ProdA_335.PGrAName, t_SRecA_323.ProdID, r_Prods_333.ProdName, r_Prods_333.Notes, r_Prods_333.Article1, r_Prods_333.Article2, r_Prods_333.Article3, r_Prods_333.PGrID4, r_Prods_333.PGrID5, at_r_ProdG4_341.PGrName4, at_r_ProdG5_342.PGrName5, t_PInP_332.ProdBarCode ProdBarCode, 'На конец', SUM(t_SRecA_323.Qty) SumQty, SUM(t_SRecA_323.Qty * t_PInP_332.CostMC) CostSum FROM av_t_SRec t_SRec_319 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_325 WITH(NOLOCK) ON (t_SRec_319.CodeID1=r_Codes1_325.CodeID1)
INNER JOIN r_Codes2 r_Codes2_326 WITH(NOLOCK) ON (t_SRec_319.CodeID2=r_Codes2_326.CodeID2)
INNER JOIN r_Codes3 r_Codes3_327 WITH(NOLOCK) ON (t_SRec_319.CodeID3=r_Codes3_327.CodeID3)
INNER JOIN r_Codes4 r_Codes4_328 WITH(NOLOCK) ON (t_SRec_319.CodeID4=r_Codes4_328.CodeID4)
INNER JOIN r_Codes5 r_Codes5_329 WITH(NOLOCK) ON (t_SRec_319.CodeID5=r_Codes5_329.CodeID5)
INNER JOIN r_Ours r_Ours_324 WITH(NOLOCK) ON (t_SRec_319.OurID=r_Ours_324.OurID)
INNER JOIN r_Stocks r_Stocks_330 WITH(NOLOCK) ON (t_SRec_319.StockID=r_Stocks_330.StockID)
INNER JOIN av_t_SRecA t_SRecA_323 WITH(NOLOCK) ON (t_SRec_319.ChID=t_SRecA_323.ChID)
INNER JOIN r_StockGs r_StockGs_331 WITH(NOLOCK) ON (r_Stocks_330.StockGID=r_StockGs_331.StockGID)
INNER JOIN t_PInP t_PInP_332 WITH(NOLOCK) ON (t_SRecA_323.PPID=t_PInP_332.PPID AND t_SRecA_323.ProdID=t_PInP_332.ProdID)
INNER JOIN r_Prods r_Prods_333 WITH(NOLOCK) ON (t_PInP_332.ProdID=r_Prods_333.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_341 WITH(NOLOCK) ON (r_Prods_333.PGrID4=at_r_ProdG4_341.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_342 WITH(NOLOCK) ON (r_Prods_333.PGrID5=at_r_ProdG5_342.PGrID5)
INNER JOIN r_ProdA r_ProdA_335 WITH(NOLOCK) ON (r_Prods_333.PGrAID=r_ProdA_335.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_336 WITH(NOLOCK) ON (r_Prods_333.PBGrID=r_ProdBG_336.PBGrID)
INNER JOIN r_ProdC r_ProdC_337 WITH(NOLOCK) ON (r_Prods_333.PCatID=r_ProdC_337.PCatID)
INNER JOIN r_ProdG r_ProdG_334 WITH(NOLOCK) ON (r_Prods_333.PGrID=r_ProdG_334.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_338 WITH(NOLOCK) ON (r_Prods_333.PGrID1=r_ProdG1_338.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_339 WITH(NOLOCK) ON (r_Prods_333.PGrID2=r_ProdG2_339.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_340 WITH(NOLOCK) ON (r_Prods_333.PGrID3=r_ProdG3_340.PGrID3)
  WHERE  ((r_Prods_333.PGrID1 = 27) OR (r_Prods_333.PGrID1 = 28) OR (r_Prods_333.PGrID1 = 29) OR (r_Prods_333.PGrID1 = 63)) AND ((r_Prods_333.PCatID BETWEEN 1 AND 100)) AND ((t_SRec_319.StockID = 4) OR (t_SRec_319.StockID = 304)) AND (t_SRec_319.DocDate <= '20190618') GROUP BY t_SRec_319.OurID, r_Ours_324.OurName, t_SRec_319.StockID, r_Stocks_330.StockName, r_Stocks_330.StockGID, r_StockGs_331.StockGName, t_SRec_319.CodeID1, r_Codes1_325.CodeName1, t_SRec_319.CodeID2, r_Codes2_326.CodeName2, t_SRec_319.CodeID3, r_Codes3_327.CodeName3, t_SRec_319.CodeID4, r_Codes4_328.CodeName4, t_SRec_319.CodeID5, r_Codes5_329.CodeName5, r_Prods_333.Country, r_Prods_333.PBGrID, r_ProdBG_336.PBGrName, r_Prods_333.PCatID, r_ProdC_337.PCatName, r_Prods_333.PGrID, r_ProdG_334.PGrName, r_Prods_333.PGrID1, r_ProdG1_338.PGrName1, r_Prods_333.PGrID2, r_ProdG2_339.PGrName2, r_Prods_333.PGrID3, r_ProdG3_340.PGrName3, r_Prods_333.PGrAID, r_ProdA_335.PGrAName, t_SRecA_323.ProdID, r_Prods_333.ProdName, r_Prods_333.Notes, r_Prods_333.Article1, r_Prods_333.Article2, r_Prods_333.Article3, r_Prods_333.PGrID4, r_Prods_333.PGrID5, at_r_ProdG4_341.PGrName4, at_r_ProdG5_342.PGrName5, t_PInP_332.ProdBarCode


-->>> На конец - Комплектация товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_SRec_320.OurID, r_Ours_344.OurName, t_SRec_320.StockID, r_Stocks_350.StockName StockName, r_Stocks_350.StockGID, r_StockGs_351.StockGName, t_SRec_320.CodeID1, r_Codes1_345.CodeName1, t_SRec_320.CodeID2, r_Codes2_346.CodeName2, t_SRec_320.CodeID3, r_Codes3_347.CodeName3, t_SRec_320.CodeID4, r_Codes4_348.CodeName4, t_SRec_320.CodeID5, r_Codes5_349.CodeName5, r_Prods_354.Country, r_Prods_354.PBGrID, r_ProdBG_357.PBGrName, r_Prods_354.PCatID, r_ProdC_358.PCatName, r_Prods_354.PGrID, r_ProdG_355.PGrName, r_Prods_354.PGrID1, r_ProdG1_359.PGrName1, r_Prods_354.PGrID2, r_ProdG2_360.PGrName2, r_Prods_354.PGrID3, r_ProdG3_361.PGrName3, r_Prods_354.PGrAID, r_ProdA_356.PGrAName, t_SRecD_352.SubProdID, r_Prods_354.ProdName, r_Prods_354.Notes, r_Prods_354.Article1, r_Prods_354.Article2, r_Prods_354.Article3, r_Prods_354.PGrID4, r_Prods_354.PGrID5, at_r_ProdG4_362.PGrName4, at_r_ProdG5_363.PGrName5, t_PInP_353.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_SRecD_352.SubQty)) SumQty, SUM(0-(t_SRecD_352.SubQty * t_PInP_353.CostMC)) CostSum FROM av_t_SRec t_SRec_320 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_345 WITH(NOLOCK) ON (t_SRec_320.CodeID1=r_Codes1_345.CodeID1)
INNER JOIN r_Codes2 r_Codes2_346 WITH(NOLOCK) ON (t_SRec_320.CodeID2=r_Codes2_346.CodeID2)
INNER JOIN r_Codes3 r_Codes3_347 WITH(NOLOCK) ON (t_SRec_320.CodeID3=r_Codes3_347.CodeID3)
INNER JOIN r_Codes4 r_Codes4_348 WITH(NOLOCK) ON (t_SRec_320.CodeID4=r_Codes4_348.CodeID4)
INNER JOIN r_Codes5 r_Codes5_349 WITH(NOLOCK) ON (t_SRec_320.CodeID5=r_Codes5_349.CodeID5)
INNER JOIN r_Ours r_Ours_344 WITH(NOLOCK) ON (t_SRec_320.OurID=r_Ours_344.OurID)
INNER JOIN r_Stocks r_Stocks_350 WITH(NOLOCK) ON (t_SRec_320.StockID=r_Stocks_350.StockID)
INNER JOIN av_t_SRecA t_SRecA_343 WITH(NOLOCK) ON (t_SRec_320.ChID=t_SRecA_343.ChID)
INNER JOIN r_StockGs r_StockGs_351 WITH(NOLOCK) ON (r_Stocks_350.StockGID=r_StockGs_351.StockGID)
INNER JOIN av_t_SRecD t_SRecD_352 WITH(NOLOCK) ON (t_SRecA_343.AChID=t_SRecD_352.AChID)
INNER JOIN t_PInP t_PInP_353 WITH(NOLOCK) ON (t_SRecD_352.SubPPID=t_PInP_353.PPID AND t_SRecD_352.SubProdID=t_PInP_353.ProdID)
INNER JOIN r_Prods r_Prods_354 WITH(NOLOCK) ON (t_PInP_353.ProdID=r_Prods_354.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_362 WITH(NOLOCK) ON (r_Prods_354.PGrID4=at_r_ProdG4_362.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_363 WITH(NOLOCK) ON (r_Prods_354.PGrID5=at_r_ProdG5_363.PGrID5)
INNER JOIN r_ProdA r_ProdA_356 WITH(NOLOCK) ON (r_Prods_354.PGrAID=r_ProdA_356.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_357 WITH(NOLOCK) ON (r_Prods_354.PBGrID=r_ProdBG_357.PBGrID)
INNER JOIN r_ProdC r_ProdC_358 WITH(NOLOCK) ON (r_Prods_354.PCatID=r_ProdC_358.PCatID)
INNER JOIN r_ProdG r_ProdG_355 WITH(NOLOCK) ON (r_Prods_354.PGrID=r_ProdG_355.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_359 WITH(NOLOCK) ON (r_Prods_354.PGrID1=r_ProdG1_359.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_360 WITH(NOLOCK) ON (r_Prods_354.PGrID2=r_ProdG2_360.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_361 WITH(NOLOCK) ON (r_Prods_354.PGrID3=r_ProdG3_361.PGrID3)
  WHERE  ((r_Prods_354.PGrID1 = 27) OR (r_Prods_354.PGrID1 = 28) OR (r_Prods_354.PGrID1 = 29) OR (r_Prods_354.PGrID1 = 63)) AND ((r_Prods_354.PCatID BETWEEN 1 AND 100)) AND ((t_SRec_320.StockID = 4) OR (t_SRec_320.StockID = 304)) AND (t_SRec_320.DocDate <= '20190618') GROUP BY t_SRec_320.OurID, r_Ours_344.OurName, t_SRec_320.StockID, r_Stocks_350.StockName, r_Stocks_350.StockGID, r_StockGs_351.StockGName, t_SRec_320.CodeID1, r_Codes1_345.CodeName1, t_SRec_320.CodeID2, r_Codes2_346.CodeName2, t_SRec_320.CodeID3, r_Codes3_347.CodeName3, t_SRec_320.CodeID4, r_Codes4_348.CodeName4, t_SRec_320.CodeID5, r_Codes5_349.CodeName5, r_Prods_354.Country, r_Prods_354.PBGrID, r_ProdBG_357.PBGrName, r_Prods_354.PCatID, r_ProdC_358.PCatName, r_Prods_354.PGrID, r_ProdG_355.PGrName, r_Prods_354.PGrID1, r_ProdG1_359.PGrName1, r_Prods_354.PGrID2, r_ProdG2_360.PGrName2, r_Prods_354.PGrID3, r_ProdG3_361.PGrName3, r_Prods_354.PGrAID, r_ProdA_356.PGrAName, t_SRecD_352.SubProdID, r_Prods_354.ProdName, r_Prods_354.Notes, r_Prods_354.Article1, r_Prods_354.Article2, r_Prods_354.Article3, r_Prods_354.PGrID4, r_Prods_354.PGrID5, at_r_ProdG4_362.PGrName4, at_r_ProdG5_363.PGrName5, t_PInP_353.ProdBarCode


-->>> На конец - Разукомплектация товара (Приход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_SExp_321.OurID, r_Ours_365.OurName, t_SExp_321.StockID, r_Stocks_371.StockName StockName, r_Stocks_371.StockGID, r_StockGs_372.StockGName, t_SExp_321.CodeID1, r_Codes1_366.CodeName1, t_SExp_321.CodeID2, r_Codes2_367.CodeName2, t_SExp_321.CodeID3, r_Codes3_368.CodeName3, t_SExp_321.CodeID4, r_Codes4_369.CodeName4, t_SExp_321.CodeID5, r_Codes5_370.CodeName5, r_Prods_375.Country, r_Prods_375.PBGrID, r_ProdBG_378.PBGrName, r_Prods_375.PCatID, r_ProdC_379.PCatName, r_Prods_375.PGrID, r_ProdG_376.PGrName, r_Prods_375.PGrID1, r_ProdG1_380.PGrName1, r_Prods_375.PGrID2, r_ProdG2_381.PGrName2, r_Prods_375.PGrID3, r_ProdG3_382.PGrName3, r_Prods_375.PGrAID, r_ProdA_377.PGrAName, t_SExpD_373.SubProdID, r_Prods_375.ProdName, r_Prods_375.Notes, r_Prods_375.Article1, r_Prods_375.Article2, r_Prods_375.Article3, r_Prods_375.PGrID4, r_Prods_375.PGrID5, at_r_ProdG4_383.PGrName4, at_r_ProdG5_384.PGrName5, t_PInP_374.ProdBarCode ProdBarCode, 'На конец', SUM(t_SExpD_373.SubQty) SumQty, SUM(t_SExpD_373.SubQty * t_PInP_374.CostMC) CostSum FROM av_t_SExp t_SExp_321 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_366 WITH(NOLOCK) ON (t_SExp_321.CodeID1=r_Codes1_366.CodeID1)
INNER JOIN r_Codes2 r_Codes2_367 WITH(NOLOCK) ON (t_SExp_321.CodeID2=r_Codes2_367.CodeID2)
INNER JOIN r_Codes3 r_Codes3_368 WITH(NOLOCK) ON (t_SExp_321.CodeID3=r_Codes3_368.CodeID3)
INNER JOIN r_Codes4 r_Codes4_369 WITH(NOLOCK) ON (t_SExp_321.CodeID4=r_Codes4_369.CodeID4)
INNER JOIN r_Codes5 r_Codes5_370 WITH(NOLOCK) ON (t_SExp_321.CodeID5=r_Codes5_370.CodeID5)
INNER JOIN r_Ours r_Ours_365 WITH(NOLOCK) ON (t_SExp_321.OurID=r_Ours_365.OurID)
INNER JOIN r_Stocks r_Stocks_371 WITH(NOLOCK) ON (t_SExp_321.StockID=r_Stocks_371.StockID)
INNER JOIN av_t_SExpA t_SExpA_364 WITH(NOLOCK) ON (t_SExp_321.ChID=t_SExpA_364.ChID)
INNER JOIN r_StockGs r_StockGs_372 WITH(NOLOCK) ON (r_Stocks_371.StockGID=r_StockGs_372.StockGID)
INNER JOIN av_t_SExpD t_SExpD_373 WITH(NOLOCK) ON (t_SExpA_364.AChID=t_SExpD_373.AChID)
INNER JOIN t_PInP t_PInP_374 WITH(NOLOCK) ON (t_SExpD_373.SubPPID=t_PInP_374.PPID AND t_SExpD_373.SubProdID=t_PInP_374.ProdID)
INNER JOIN r_Prods r_Prods_375 WITH(NOLOCK) ON (t_PInP_374.ProdID=r_Prods_375.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_383 WITH(NOLOCK) ON (r_Prods_375.PGrID4=at_r_ProdG4_383.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_384 WITH(NOLOCK) ON (r_Prods_375.PGrID5=at_r_ProdG5_384.PGrID5)
INNER JOIN r_ProdA r_ProdA_377 WITH(NOLOCK) ON (r_Prods_375.PGrAID=r_ProdA_377.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_378 WITH(NOLOCK) ON (r_Prods_375.PBGrID=r_ProdBG_378.PBGrID)
INNER JOIN r_ProdC r_ProdC_379 WITH(NOLOCK) ON (r_Prods_375.PCatID=r_ProdC_379.PCatID)
INNER JOIN r_ProdG r_ProdG_376 WITH(NOLOCK) ON (r_Prods_375.PGrID=r_ProdG_376.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_380 WITH(NOLOCK) ON (r_Prods_375.PGrID1=r_ProdG1_380.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_381 WITH(NOLOCK) ON (r_Prods_375.PGrID2=r_ProdG2_381.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_382 WITH(NOLOCK) ON (r_Prods_375.PGrID3=r_ProdG3_382.PGrID3)
  WHERE  ((r_Prods_375.PGrID1 = 27) OR (r_Prods_375.PGrID1 = 28) OR (r_Prods_375.PGrID1 = 29) OR (r_Prods_375.PGrID1 = 63)) AND ((r_Prods_375.PCatID BETWEEN 1 AND 100)) AND ((t_SExp_321.StockID = 4) OR (t_SExp_321.StockID = 304)) AND (t_SExp_321.DocDate <= '20190618') GROUP BY t_SExp_321.OurID, r_Ours_365.OurName, t_SExp_321.StockID, r_Stocks_371.StockName, r_Stocks_371.StockGID, r_StockGs_372.StockGName, t_SExp_321.CodeID1, r_Codes1_366.CodeName1, t_SExp_321.CodeID2, r_Codes2_367.CodeName2, t_SExp_321.CodeID3, r_Codes3_368.CodeName3, t_SExp_321.CodeID4, r_Codes4_369.CodeName4, t_SExp_321.CodeID5, r_Codes5_370.CodeName5, r_Prods_375.Country, r_Prods_375.PBGrID, r_ProdBG_378.PBGrName, r_Prods_375.PCatID, r_ProdC_379.PCatName, r_Prods_375.PGrID, r_ProdG_376.PGrName, r_Prods_375.PGrID1, r_ProdG1_380.PGrName1, r_Prods_375.PGrID2, r_ProdG2_381.PGrName2, r_Prods_375.PGrID3, r_ProdG3_382.PGrName3, r_Prods_375.PGrAID, r_ProdA_377.PGrAName, t_SExpD_373.SubProdID, r_Prods_375.ProdName, r_Prods_375.Notes, r_Prods_375.Article1, r_Prods_375.Article2, r_Prods_375.Article3, r_Prods_375.PGrID4, r_Prods_375.PGrID5, at_r_ProdG4_383.PGrName4, at_r_ProdG5_384.PGrName5, t_PInP_374.ProdBarCode


-->>> На конец - Разукомплектация товара (Расход):
--INSERT INTO [AzTempDB].[CONST\maslov].[v_014_00448_1_CONST\maslov] ([OurID], [OurName], [StockID], [StockName], [StockGID], [StockGName], [CodeID1], [CodeName1], [CodeID2], [CodeName2], [CodeID3], [CodeName3], [CodeID4], [CodeName4], [CodeID5], [CodeName5], [Country], [PBGrID], [PBGrName], [PCatID], [PCatName], [PGrID], [PGrName], [PGrID1], [PGrName1], [PGrID2], [PGrName2], [PGrID3], [PGrName3], [PGrAID], [PGrAName], [ProdID], [ProdName], [Notes], [Article1], [Article2], [Article3], [PGrID4], [PGrID5], [PGrName4], [PGrName5], [ProdBarCode], [GMSSourceGroup], [SumQty], [CostSum]) SELECT t_SExp_322.OurID, r_Ours_386.OurName, t_SExp_322.StockID, r_Stocks_392.StockName StockName, r_Stocks_392.StockGID, r_StockGs_393.StockGName, t_SExp_322.CodeID1, r_Codes1_387.CodeName1, t_SExp_322.CodeID2, r_Codes2_388.CodeName2, t_SExp_322.CodeID3, r_Codes3_389.CodeName3, t_SExp_322.CodeID4, r_Codes4_390.CodeName4, t_SExp_322.CodeID5, r_Codes5_391.CodeName5, r_Prods_395.Country, r_Prods_395.PBGrID, r_ProdBG_398.PBGrName, r_Prods_395.PCatID, r_ProdC_399.PCatName, r_Prods_395.PGrID, r_ProdG_396.PGrName, r_Prods_395.PGrID1, r_ProdG1_400.PGrName1, r_Prods_395.PGrID2, r_ProdG2_401.PGrName2, r_Prods_395.PGrID3, r_ProdG3_402.PGrName3, r_Prods_395.PGrAID, r_ProdA_397.PGrAName, t_SExpA_385.ProdID, r_Prods_395.ProdName, r_Prods_395.Notes, r_Prods_395.Article1, r_Prods_395.Article2, r_Prods_395.Article3, r_Prods_395.PGrID4, r_Prods_395.PGrID5, at_r_ProdG4_403.PGrName4, at_r_ProdG5_404.PGrName5, t_PInP_394.ProdBarCode ProdBarCode, 'На конец', SUM(0-(t_SExpA_385.Qty)) SumQty, SUM(0-(t_SExpA_385.Qty * t_PInP_394.CostMC)) CostSum FROM av_t_SExp t_SExp_322 WITH(NOLOCK)
INNER JOIN r_Codes1 r_Codes1_387 WITH(NOLOCK) ON (t_SExp_322.CodeID1=r_Codes1_387.CodeID1)
INNER JOIN r_Codes2 r_Codes2_388 WITH(NOLOCK) ON (t_SExp_322.CodeID2=r_Codes2_388.CodeID2)
INNER JOIN r_Codes3 r_Codes3_389 WITH(NOLOCK) ON (t_SExp_322.CodeID3=r_Codes3_389.CodeID3)
INNER JOIN r_Codes4 r_Codes4_390 WITH(NOLOCK) ON (t_SExp_322.CodeID4=r_Codes4_390.CodeID4)
INNER JOIN r_Codes5 r_Codes5_391 WITH(NOLOCK) ON (t_SExp_322.CodeID5=r_Codes5_391.CodeID5)
INNER JOIN r_Ours r_Ours_386 WITH(NOLOCK) ON (t_SExp_322.OurID=r_Ours_386.OurID)
INNER JOIN r_Stocks r_Stocks_392 WITH(NOLOCK) ON (t_SExp_322.StockID=r_Stocks_392.StockID)
INNER JOIN av_t_SExpA t_SExpA_385 WITH(NOLOCK) ON (t_SExp_322.ChID=t_SExpA_385.ChID)
INNER JOIN r_StockGs r_StockGs_393 WITH(NOLOCK) ON (r_Stocks_392.StockGID=r_StockGs_393.StockGID)
INNER JOIN t_PInP t_PInP_394 WITH(NOLOCK) ON (t_SExpA_385.PPID=t_PInP_394.PPID AND t_SExpA_385.ProdID=t_PInP_394.ProdID)
INNER JOIN r_Prods r_Prods_395 WITH(NOLOCK) ON (t_PInP_394.ProdID=r_Prods_395.ProdID)
INNER JOIN at_r_ProdG4 at_r_ProdG4_403 WITH(NOLOCK) ON (r_Prods_395.PGrID4=at_r_ProdG4_403.PGrID4)
INNER JOIN at_r_ProdG5 at_r_ProdG5_404 WITH(NOLOCK) ON (r_Prods_395.PGrID5=at_r_ProdG5_404.PGrID5)
INNER JOIN r_ProdA r_ProdA_397 WITH(NOLOCK) ON (r_Prods_395.PGrAID=r_ProdA_397.PGrAID)
INNER JOIN r_ProdBG r_ProdBG_398 WITH(NOLOCK) ON (r_Prods_395.PBGrID=r_ProdBG_398.PBGrID)
INNER JOIN r_ProdC r_ProdC_399 WITH(NOLOCK) ON (r_Prods_395.PCatID=r_ProdC_399.PCatID)
INNER JOIN r_ProdG r_ProdG_396 WITH(NOLOCK) ON (r_Prods_395.PGrID=r_ProdG_396.PGrID)
INNER JOIN r_ProdG1 r_ProdG1_400 WITH(NOLOCK) ON (r_Prods_395.PGrID1=r_ProdG1_400.PGrID1)
INNER JOIN r_ProdG2 r_ProdG2_401 WITH(NOLOCK) ON (r_Prods_395.PGrID2=r_ProdG2_401.PGrID2)
INNER JOIN r_ProdG3 r_ProdG3_402 WITH(NOLOCK) ON (r_Prods_395.PGrID3=r_ProdG3_402.PGrID3)
  WHERE  ((r_Prods_395.PGrID1 = 27) OR (r_Prods_395.PGrID1 = 28) OR (r_Prods_395.PGrID1 = 29) OR (r_Prods_395.PGrID1 = 63)) AND ((r_Prods_395.PCatID BETWEEN 1 AND 100)) AND ((t_SExp_322.StockID = 4) OR (t_SExp_322.StockID = 304)) AND (t_SExp_322.DocDate <= '20190618') GROUP BY t_SExp_322.OurID, r_Ours_386.OurName, t_SExp_322.StockID, r_Stocks_392.StockName, r_Stocks_392.StockGID, r_StockGs_393.StockGName, t_SExp_322.CodeID1, r_Codes1_387.CodeName1, t_SExp_322.CodeID2, r_Codes2_388.CodeName2, t_SExp_322.CodeID3, r_Codes3_389.CodeName3, t_SExp_322.CodeID4, r_Codes4_390.CodeName4, t_SExp_322.CodeID5, r_Codes5_391.CodeName5, r_Prods_395.Country, r_Prods_395.PBGrID, r_ProdBG_398.PBGrName, r_Prods_395.PCatID, r_ProdC_399.PCatName, r_Prods_395.PGrID, r_ProdG_396.PGrName, r_Prods_395.PGrID1, r_ProdG1_400.PGrName1, r_Prods_395.PGrID2, r_ProdG2_401.PGrName2, r_Prods_395.PGrID3, r_ProdG3_402.PGrName3, r_Prods_395.PGrAID, r_ProdA_397.PGrAName, t_SExpA_385.ProdID, r_Prods_395.ProdName, r_Prods_395.Notes, r_Prods_395.Article1, r_Prods_395.Article2, r_Prods_395.Article3, r_Prods_395.PGrID4, r_Prods_395.PGrID5, at_r_ProdG4_403.PGrName4, at_r_ProdG5_404.PGrName5, t_PInP_394.ProdBarCode
*/