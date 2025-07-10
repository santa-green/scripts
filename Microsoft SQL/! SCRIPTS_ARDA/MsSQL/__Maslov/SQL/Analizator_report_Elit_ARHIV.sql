
SELECT * FROM v_MapSG	WHERE RepID = 14 ORDER BY SourceID
SELECT * FROM v_MapSG	WHERE RepID = 1017 ORDER BY SourceID

--av_c_CompIn c_CompIn_1 WITH(NOLOCK)  LEFT JOIN at_r_CompOurTerms at_r_CompOurTerms_169 WITH(NOLOCK) ON (c_CompIn_1.CompID=at_r_CompOurTerms_169.CompID AND c_CompIn_1.OurID=at_r_CompOurTerms_169.OurID)  INNER JOIN r_Codes1 r_Codes1_100 WITH(NOLOCK) ON (c_CompIn_1.CodeID1=r_Codes1_100.CodeID1)  LEFT JOIN r_Codes3 r_Codes3_193 WITH(NOLOCK) ON (c_CompIn_1.CodeID3=r_Codes3_193.CodeID3)  INNER JOIN r_Comps r_Comps_30 WITH(NOLOCK) ON (c_CompIn_1.CompID=r_Comps_30.CompID)  INNER JOIN r_Ours r_Ours_20 WITH(NOLOCK) ON (c_CompIn_1.OurID=r_Ours_20.OurID)  INNER JOIN r_Stocks r_Stocks_40 WITH(NOLOCK) ON (c_CompIn_1.StockID=r_Stocks_40.StockID)  LEFT JOIN at_r_SRs at_r_SRs_181 WITH(NOLOCK) ON (at_r_CompOurTerms_169.SRID=at_r_SRs_181.SRID)  INNER JOIN r_Emps r_Emps_242 WITH(NOLOCK) ON (r_Codes3_193.EmpID=r_Emps_242.EmpID)  INNER JOIN r_Codes2 r_Codes2_60 WITH(NOLOCK) ON (r_Comps_30.CodeID2=r_Codes2_60.CodeID2)  INNER JOIN r_Codes3 r_Codes3_226 WITH(NOLOCK) ON (r_Comps_30.CodeID3=r_Codes3_226.CodeID3)  INNER JOIN r_Codes4 r_Codes4_80 WITH(NOLOCK) ON (r_Comps_30.CodeID4=r_Codes4_80.CodeID4)  INNER JOIN r_CompGrs1 r_CompGrs1_50 WITH(NOLOCK) ON (r_Comps_30.CompGrID1=r_CompGrs1_50.CompGrID1)  INNER JOIN r_CompGrs2 r_CompGrs2_154 WITH(NOLOCK) ON (r_Comps_30.CompGrID2=r_CompGrs2_154.CompGrID2)  INNER JOIN r_CompGrs5 r_CompGrs5_111 WITH(NOLOCK) ON (r_Comps_30.CompGrID5=r_CompGrs5_111.CompGrID5)  INNER JOIN r_Emps r_Emps_159 WITH(NOLOCK) ON (r_Comps_30.EmpID=r_Emps_159.EmpID)  LEFT JOIN r_Emps r_Emps_229 WITH(NOLOCK) ON (at_r_SRs_181.EmpID=r_Emps_229.EmpID)  LEFT JOIN r_Uni r_Uni_205 WITH(NOLOCK) ON (6660153=r_Uni_205.RefTypeID AND at_r_SRs_181.AffID=r_Uni_205.RefID)  %WHERE%%GROUPBY%
--av_t_Ret t_Ret_1 WITH(NOLOCK)  LEFT JOIN at_r_CompOurTerms at_r_CompOurTerms_500 WITH(NOLOCK) ON (at_r_CompOurTerms_500.CompID=t_Ret_1.CompID AND at_r_CompOurTerms_500.OurID=t_Ret_1.OurID)  JOIN r_Codes1 r_Codes1_28 WITH(NOLOCK) ON (r_Codes1_28.CodeID1=t_Ret_1.CodeID1)  JOIN r_Codes2 r_Codes2_29 WITH(NOLOCK) ON (r_Codes2_29.CodeID2=t_Ret_1.CodeID2)  JOIN r_Codes3 r_Codes3_30 WITH(NOLOCK) ON (r_Codes3_30.CodeID3=t_Ret_1.CodeID3)  JOIN r_Codes4 r_Codes4_383 WITH(NOLOCK) ON (r_Codes4_383.CodeID4=t_Ret_1.CodeID4)  JOIN r_Codes5 r_Codes5_395 WITH(NOLOCK) ON (r_Codes5_395.CodeID5=t_Ret_1.CodeID5)  JOIN r_Comps r_Comps_27 WITH(NOLOCK) ON (r_Comps_27.CompID=t_Ret_1.CompID)  LEFT JOIN r_CompsAdd r_CompsAdd_406 WITH(NOLOCK) ON (r_CompsAdd_406.CompID=t_Ret_1.CompID AND r_CompsAdd_406.CompAdd=t_Ret_1.Address)  JOIN r_Deps r_Deps_288 WITH(NOLOCK) ON (r_Deps_288.DepID=t_Ret_1.DepID)  JOIN r_Emps r_Emps_32 WITH(NOLOCK) ON (r_Emps_32.EmpID=t_Ret_1.EmpID)  JOIN r_Ours r_Ours_26 WITH(NOLOCK) ON (r_Ours_26.OurID=t_Ret_1.OurID)  JOIN r_Stocks r_Stocks_31 WITH(NOLOCK) ON (r_Stocks_31.StockID=t_Ret_1.StockID)  JOIN av_t_RetD t_RetD_2 WITH(NOLOCK) ON (t_RetD_2.ChID=t_Ret_1.ChID)  JOIN t_PInP t_PInP_130 WITH(NOLOCK) ON (t_PInP_130.PPID=t_RetD_2.PPID AND t_PInP_130.ProdID=t_RetD_2.ProdID)  JOIN r_Comps r_Comps_476 WITH(NOLOCK) ON (r_Comps_476.CompID=t_PInP_130.CompID)  JOIN r_Prods r_Prods_131 WITH(NOLOCK) ON (r_Prods_131.ProdID=t_PInP_130.ProdID)  JOIN at_r_ProdG4 at_r_ProdG4_255 WITH(NOLOCK) ON (at_r_ProdG4_255.PGrID4=r_Prods_131.PGrID4)  JOIN at_r_ProdG5 at_r_ProdG5_256 WITH(NOLOCK) ON (at_r_ProdG5_256.PGrID5=r_Prods_131.PGrID5)  JOIN r_Comps r_Comps_740 WITH(NOLOCK) ON (r_Comps_740.CompID=r_Prods_131.SupID)  JOIN r_ProdBG r_ProdBG_756 WITH(NOLOCK) ON (r_ProdBG_756.PBGrID=r_Prods_131.PBGrID)  JOIN r_ProdC r_ProdC_132 WITH(NOLOCK) ON (r_ProdC_132.PCatID=r_Prods_131.PCatID)  JOIN r_ProdG r_ProdG_219 WITH(NOLOCK) ON (r_ProdG_219.PGrID=r_Prods_131.PGrID)  JOIN r_ProdG1 r_ProdG1_220 WITH(NOLOCK) ON (r_ProdG1_220.PGrID1=r_Prods_131.PGrID1)  JOIN r_Uni r_Uni_524 WITH(NOLOCK) ON (r_Uni_524.RefTypeID=6660115 AND r_Uni_524.RefID=r_Prods_131.ImpID)  LEFT JOIN r_ProdEC r_ProdEC_536 WITH(NOLOCK) ON (r_ProdEC_536.ProdID=r_Prods_131.ProdID AND r_ProdEC_536.CompID=t_Ret_1.CompID)  JOIN r_Deps r_Deps_243 WITH(NOLOCK) ON (r_Deps_243.DepID=r_Stocks_31.DepID)  JOIN r_StockGs r_StockGs_464 WITH(NOLOCK) ON (r_StockGs_464.StockGID=r_Stocks_31.StockGID)  LEFT JOIN r_CompGrs2 r_CompGrs2_407 WITH(NOLOCK) ON (r_CompGrs2_407.CompGrID2=r_CompsAdd_406.CompGrID2)  JOIN r_Codes2 r_Codes2_178 WITH(NOLOCK) ON (r_Codes2_178.CodeID2=r_Comps_27.CodeID2)  JOIN r_Codes3 r_Codes3_700 WITH(NOLOCK) ON (r_Codes3_700.CodeID3=r_Comps_27.CodeID3)  JOIN r_Codes4 r_Codes4_180 WITH(NOLOCK) ON (r_Codes4_180.CodeID4=r_Comps_27.CodeID4)  JOIN r_CompGrs1 r_CompGrs1_213 WITH(NOLOCK) ON (r_CompGrs1_213.CompGrID1=r_Comps_27.CompGrID1)  JOIN r_CompGrs2 r_CompGrs2_488 WITH(NOLOCK) ON (r_CompGrs2_488.CompGrID2=r_Comps_27.CompGrID2)  JOIN r_CompGrs5 r_CompGrs5_279 WITH(NOLOCK) ON (r_CompGrs5_279.CompGrID5=r_Comps_27.CompGrID5)  JOIN r_Emps r_Emps_207 WITH(NOLOCK) ON (r_Emps_207.EmpID=r_Comps_27.EmpID)  JOIN r_Emps r_Emps_724 WITH(NOLOCK) ON (r_Emps_724.EmpID=r_Codes3_30.EmpID)  LEFT JOIN at_r_SRs at_r_SRs_512 WITH(NOLOCK) ON (at_r_SRs_512.SRID=at_r_CompOurTerms_500.SRID)  LEFT JOIN r_Uni r_Uni_676 WITH(NOLOCK) ON (r_Uni_676.RefTypeID=6660155 AND r_Uni_676.RefID=at_r_CompOurTerms_500.HaveCoffeeContr)  LEFT JOIN r_Uni r_Uni_688 WITH(NOLOCK) ON (r_Uni_688.RefTypeID=6660155 AND r_Uni_688.RefID=at_r_CompOurTerms_500.HaveMarketContr)  LEFT JOIN r_Emps r_Emps_712 WITH(NOLOCK) ON (r_Emps_712.EmpID=at_r_SRs_512.EmpID)  LEFT JOIN r_Uni r_Uni_548 WITH(NOLOCK) ON (r_Uni_548.RefTypeID=6660153 AND r_Uni_548.RefID=at_r_SRs_512.AffID)  %WHERE%%GROUPBY%
--av_t_Rec t_Rec_1 WITH(NOLOCK)  INNER JOIN r_Codes1 r_Codes1_42 WITH(NOLOCK) ON (t_Rec_1.CodeID1=r_Codes1_42.CodeID1)  INNER JOIN r_Codes2 r_Codes2_52 WITH(NOLOCK) ON (t_Rec_1.CodeID2=r_Codes2_52.CodeID2)  INNER JOIN r_Codes3 r_Codes3_62 WITH(NOLOCK) ON (t_Rec_1.CodeID3=r_Codes3_62.CodeID3)  INNER JOIN r_Codes4 r_Codes4_72 WITH(NOLOCK) ON (t_Rec_1.CodeID4=r_Codes4_72.CodeID4)  INNER JOIN r_Codes5 r_Codes5_82 WITH(NOLOCK) ON (t_Rec_1.CodeID5=r_Codes5_82.CodeID5)  INNER JOIN r_Deps r_Deps_264 WITH(NOLOCK) ON (t_Rec_1.DepID=r_Deps_264.DepID)  INNER JOIN r_Ours r_Ours_22 WITH(NOLOCK) ON (t_Rec_1.OurID=r_Ours_22.OurID)  INNER JOIN r_Stocks r_Stocks_199 WITH(NOLOCK) ON (t_Rec_1.StockID=r_Stocks_199.StockID)  INNER JOIN av_t_RecD t_RecD_145 WITH(NOLOCK) ON (t_Rec_1.ChID=t_RecD_145.ChID)  INNER JOIN r_Deps r_Deps_224 WITH(NOLOCK) ON (r_Stocks_199.DepID=r_Deps_224.DepID)  INNER JOIN t_PInP t_PInP_146 WITH(NOLOCK) ON (t_RecD_145.PPID=t_PInP_146.PPID AND t_RecD_145.ProdID=t_PInP_146.ProdID)  %WHERE%%GROUPBY%
--av_c_CompRec c_CompRec_9 WITH(NOLOCK)  INNER JOIN r_Codes1 r_Codes1_50 WITH(NOLOCK) ON (c_CompRec_9.CodeID1=r_Codes1_50.CodeID1)  INNER JOIN r_Codes2 r_Codes2_60 WITH(NOLOCK) ON (c_CompRec_9.CodeID2=r_Codes2_60.CodeID2)  INNER JOIN r_Codes3 r_Codes3_70 WITH(NOLOCK) ON (c_CompRec_9.CodeID3=r_Codes3_70.CodeID3)  INNER JOIN r_Codes4 r_Codes4_80 WITH(NOLOCK) ON (c_CompRec_9.CodeID4=r_Codes4_80.CodeID4)  INNER JOIN r_Codes5 r_Codes5_90 WITH(NOLOCK) ON (c_CompRec_9.CodeID5=r_Codes5_90.CodeID5)  INNER JOIN r_Deps r_Deps_344 WITH(NOLOCK) ON (c_CompRec_9.DepID=r_Deps_344.DepID)  INNER JOIN r_Ours r_Ours_30 WITH(NOLOCK) ON (c_CompRec_9.OurID=r_Ours_30.OurID)  INNER JOIN r_Stocks r_Stocks_198 WITH(NOLOCK) ON (c_CompRec_9.StockID=r_Stocks_198.StockID)  INNER JOIN r_Deps r_Deps_231 WITH(NOLOCK) ON (r_Stocks_198.DepID=r_Deps_231.DepID)  %WHERE%%GROUPBY%
--av_t_CRRet t_CRRet_204 WITH(NOLOCK)  INNER JOIN r_Codes1 r_Codes1_209 WITH(NOLOCK) ON (t_CRRet_204.CodeID1=r_Codes1_209.CodeID1)  INNER JOIN r_Codes2 r_Codes2_210 WITH(NOLOCK) ON (t_CRRet_204.CodeID2=r_Codes2_210.CodeID2)  INNER JOIN r_Codes3 r_Codes3_211 WITH(NOLOCK) ON (t_CRRet_204.CodeID3=r_Codes3_211.CodeID3)  INNER JOIN r_Codes4 r_Codes4_212 WITH(NOLOCK) ON (t_CRRet_204.CodeID4=r_Codes4_212.CodeID4)  INNER JOIN r_Codes5 r_Codes5_213 WITH(NOLOCK) ON (t_CRRet_204.CodeID5=r_Codes5_213.CodeID5)  INNER JOIN r_Ours r_Ours_208 WITH(NOLOCK) ON (t_CRRet_204.OurID=r_Ours_208.OurID)  INNER JOIN r_Stocks r_Stocks_214 WITH(NOLOCK) ON (t_CRRet_204.StockID=r_Stocks_214.StockID)  INNER JOIN av_t_CRRetD t_CRRetD_205 WITH(NOLOCK) ON (t_CRRet_204.ChID=t_CRRetD_205.ChID)  INNER JOIN r_Deps r_Deps_235 WITH(NOLOCK) ON (r_Stocks_214.DepID=r_Deps_235.DepID)  INNER JOIN t_PInP t_PInP_222 WITH(NOLOCK) ON (t_CRRetD_205.PPID=t_PInP_222.PPID AND t_CRRetD_205.ProdID=t_PInP_222.ProdID)  %WHERE%%GROUPBY%
--av_t_Sale t_Sale_206 WITH(NOLOCK)  INNER JOIN r_Codes1 r_Codes1_216 WITH(NOLOCK) ON (t_Sale_206.CodeID1=r_Codes1_216.CodeID1)  INNER JOIN r_Codes2 r_Codes2_217 WITH(NOLOCK) ON (t_Sale_206.CodeID2=r_Codes2_217.CodeID2)  INNER JOIN r_Codes3 r_Codes3_218 WITH(NOLOCK) ON (t_Sale_206.CodeID3=r_Codes3_218.CodeID3)  INNER JOIN r_Codes4 r_Codes4_219 WITH(NOLOCK) ON (t_Sale_206.CodeID4=r_Codes4_219.CodeID4)  INNER JOIN r_Codes5 r_Codes5_220 WITH(NOLOCK) ON (t_Sale_206.CodeID5=r_Codes5_220.CodeID5)  INNER JOIN r_Ours r_Ours_215 WITH(NOLOCK) ON (t_Sale_206.OurID=r_Ours_215.OurID)  INNER JOIN r_Stocks r_Stocks_221 WITH(NOLOCK) ON (t_Sale_206.StockID=r_Stocks_221.StockID)  INNER JOIN av_t_SaleD t_SaleD_207 WITH(NOLOCK) ON (t_Sale_206.ChID=t_SaleD_207.ChID)  INNER JOIN r_Deps r_Deps_236 WITH(NOLOCK) ON (r_Stocks_221.DepID=r_Deps_236.DepID)  INNER JOIN t_PInP t_PInP_223 WITH(NOLOCK) ON (t_SaleD_207.PPID=t_PInP_223.PPID AND t_SaleD_207.ProdID=t_PInP_223.ProdID)  %WHERE%%GROUPBY%
--av_t_Rec t_Rec_1%LOCKHINT%  INNER JOIN r_Ours r_Ours_22%LOCKHINT% ON (r_Ours_22.OurID = t_Rec_1.OurID)  INNER JOIN r_Codes1 r_Codes1_42%LOCKHINT% ON (r_Codes1_42.CodeID1 = t_Rec_1.CodeID1)  INNER JOIN r_Codes2 r_Codes2_52%LOCKHINT% ON (r_Codes2_52.CodeID2 = t_Rec_1.CodeID2)  INNER JOIN r_Codes3 r_Codes3_62%LOCKHINT% ON (r_Codes3_62.CodeID3 = t_Rec_1.CodeID3)  INNER JOIN r_Codes4 r_Codes4_72%LOCKHINT% ON (r_Codes4_72.CodeID4 = t_Rec_1.CodeID4)  INNER JOIN r_Codes5 r_Codes5_82%LOCKHINT% ON (r_Codes5_82.CodeID5 = t_Rec_1.CodeID5)  INNER JOIN av_t_RecD t_RecD_145%LOCKHINT% ON (t_Rec_1.ChID = t_RecD_145.ChID)  INNER JOIN r_Deps r_Deps_241%LOCKHINT% ON (r_Deps_241.DepID = t_Rec_1.DepID)  INNER JOIN t_PInP t_PInP_146%LOCKHINT% ON (t_PInP_146.PPID = t_RecD_145.PPID) AND (t_PInP_146.ProdID = t_RecD_145.ProdID)%WHERE%%GROUPBY%
--av_t_EOExp t_EOExp_9 WITH(NOLOCK)  INNER JOIN r_Codes1 r_Codes1_39 WITH(NOLOCK) ON (t_EOExp_9.CodeID1=r_Codes1_39.CodeID1)  INNER JOIN r_Codes2 r_Codes2_49 WITH(NOLOCK) ON (t_EOExp_9.CodeID2=r_Codes2_49.CodeID2)  INNER JOIN r_Codes3 r_Codes3_59 WITH(NOLOCK) ON (t_EOExp_9.CodeID3=r_Codes3_59.CodeID3)  INNER JOIN r_Codes4 r_Codes4_69 WITH(NOLOCK) ON (t_EOExp_9.CodeID4=r_Codes4_69.CodeID4)  INNER JOIN r_Codes5 r_Codes5_79 WITH(NOLOCK) ON (t_EOExp_9.CodeID5=r_Codes5_79.CodeID5)  INNER JOIN r_Comps r_Comps_29 WITH(NOLOCK) ON (t_EOExp_9.CompID=r_Comps_29.CompID)  INNER JOIN r_Emps r_Emps_99 WITH(NOLOCK) ON (t_EOExp_9.EmpID=r_Emps_99.EmpID)  INNER JOIN r_Ours r_Ours_19 WITH(NOLOCK) ON (t_EOExp_9.OurID=r_Ours_19.OurID)  INNER JOIN r_Stocks r_Stocks_89 WITH(NOLOCK) ON (t_EOExp_9.StockID=r_Stocks_89.StockID)  %WHERE%%GROUPBY%
--av_z_Contracts z_Contracts_156 WITH(NOLOCK)  INNER JOIN r_Codes1 r_Codes1_160 WITH(NOLOCK) ON (z_Contracts_156.CodeID1=r_Codes1_160.CodeID1)  INNER JOIN r_Codes2 r_Codes2_161 WITH(NOLOCK) ON (z_Contracts_156.CodeID2=r_Codes2_161.CodeID2)  INNER JOIN r_Codes3 r_Codes3_162 WITH(NOLOCK) ON (z_Contracts_156.CodeID3=r_Codes3_162.CodeID3)  INNER JOIN r_Codes4 r_Codes4_163 WITH(NOLOCK) ON (z_Contracts_156.CodeID4=r_Codes4_163.CodeID4)  INNER JOIN r_Codes5 r_Codes5_164 WITH(NOLOCK) ON (z_Contracts_156.CodeID5=r_Codes5_164.CodeID5)  INNER JOIN r_Comps r_Comps_159 WITH(NOLOCK) ON (z_Contracts_156.CompID=r_Comps_159.CompID)  INNER JOIN r_Emps r_Emps_165 WITH(NOLOCK) ON (z_Contracts_156.EmpID=r_Emps_165.EmpID)  INNER JOIN r_Ours r_Ours_158 WITH(NOLOCK) ON (z_Contracts_156.OurID=r_Ours_158.OurID)  INNER JOIN r_Uni r_Uni_166 WITH(NOLOCK) ON (80011=r_Uni_166.RefTypeID AND z_Contracts_156.Status=r_Uni_166.RefID)  INNER JOIN av_z_ContractsD z_ContractsD_157 WITH(NOLOCK) ON (z_Contracts_156.ChID=z_ContractsD_157.ChID)  %WHERE%%GROUPBY%
--av_t_Ret t_Ret_1 WITH(NOLOCK) LEFT JOIN at_r_CompOurTerms at_r_CompOurTerms_526 WITH(NOLOCK) ON (at_r_CompOurTerms_526.CompID=t_Ret_1.CompID AND at_r_CompOurTerms_526.OurID=t_Ret_1.OurID) JOIN at_r_Drivers at_r_Drivers_830 WITH(NOLOCK) ON (at_r_Drivers_830.DriverID=t_Ret_1.DriverID) JOIN r_Codes1 r_Codes1_28 WITH(NOLOCK) ON (r_Codes1_28.CodeID1=t_Ret_1.CodeID1) JOIN r_Codes2 r_Codes2_29 WITH(NOLOCK) ON (r_Codes2_29.CodeID2=t_Ret_1.CodeID2) JOIN r_Codes3 r_Codes3_761 WITH(NOLOCK) ON (r_Codes3_761.CodeID3=t_Ret_1.CodeID3) JOIN r_Codes4 r_Codes4_244 WITH(NOLOCK) ON (r_Codes4_244.CodeID4=t_Ret_1.CodeID4) JOIN r_Codes5 r_Codes5_256 WITH(NOLOCK) ON (r_Codes5_256.CodeID5=t_Ret_1.CodeID5) JOIN r_Comps r_Comps_27 WITH(NOLOCK) ON (r_Comps_27.CompID=t_Ret_1.CompID) LEFT JOIN r_CompsAdd r_CompsAdd_408 WITH(NOLOCK) ON (r_CompsAdd_408.CompID=t_Ret_1.CompID AND r_CompsAdd_408.CompAdd=t_Ret_1.Address) JOIN r_Currs r_Currs_466 WITH(NOLOCK) ON (r_Currs_466.CurrID=t_Ret_1.CurrID) JOIN r_Deps r_Deps_309 WITH(NOLOCK) ON (r_Deps_309.DepID=t_Ret_1.DepID) JOIN r_Emps r_Emps_792 WITH(NOLOCK) ON (r_Emps_792.EmpID=t_Ret_1.EmpID) JOIN r_Ours r_Ours_26 WITH(NOLOCK) ON (r_Ours_26.OurID=t_Ret_1.OurID) JOIN r_States r_States_491 WITH(NOLOCK) ON (r_States_491.StateCode=t_Ret_1.StateCode) JOIN r_Stocks r_Stocks_31 WITH(NOLOCK) ON (r_Stocks_31.StockID=t_Ret_1.StockID) JOIN av_t_RetD t_RetD_2 WITH(NOLOCK) ON (t_RetD_2.ChID=t_Ret_1.ChID) JOIN t_PInP t_PInP_130 WITH(NOLOCK) ON (t_PInP_130.PPID=t_RetD_2.PPID AND t_PInP_130.ProdID=t_RetD_2.ProdID) JOIN r_Comps r_Comps_502 WITH(NOLOCK) ON (r_Comps_502.CompID=t_PInP_130.CompID) JOIN r_Prods r_Prods_131 WITH(NOLOCK) ON (r_Prods_131.ProdID=t_PInP_130.ProdID) JOIN at_r_ProdG4 at_r_ProdG4_279 WITH(NOLOCK) ON (at_r_ProdG4_279.PGrID4=r_Prods_131.PGrID4) JOIN at_r_ProdG5 at_r_ProdG5_280 WITH(NOLOCK) ON (at_r_ProdG5_280.PGrID5=r_Prods_131.PGrID5) JOIN r_Comps r_Comps_796 WITH(NOLOCK) ON (r_Comps_796.CompID=r_Prods_131.SupID) JOIN r_ProdBG r_ProdBG_814 WITH(NOLOCK) ON (r_ProdBG_814.PBGrID=r_Prods_131.PBGrID) JOIN r_ProdC r_ProdC_132 WITH(NOLOCK) ON (r_ProdC_132.PCatID=r_Prods_131.PCatID) JOIN r_ProdG r_ProdG_219 WITH(NOLOCK) ON (r_ProdG_219.PGrID=r_Prods_131.PGrID) JOIN r_ProdG1 r_ProdG1_220 WITH(NOLOCK) ON (r_ProdG1_220.PGrID1=r_Prods_131.PGrID1) LEFT JOIN r_ProdMQ r_ProdMQ_709 WITH(NOLOCK) ON (r_ProdMQ_709.ProdID=r_Prods_131.ProdID AND r_ProdMQ_709.UM='ˇ˘.') JOIN r_Uni r_Uni_550 WITH(NOLOCK) ON (r_Uni_550.RefTypeID=6660115 AND r_Uni_550.RefID=r_Prods_131.ImpID) LEFT JOIN r_ProdEC r_ProdEC_574 WITH(NOLOCK) ON (r_ProdEC_574.ProdID=r_Prods_131.ProdID AND r_ProdEC_574.CompID=t_Ret_1.CompID) JOIN r_Deps r_Deps_267 WITH(NOLOCK) ON (r_Deps_267.DepID=r_Stocks_31.DepID) JOIN r_StockGs r_StockGs_478 WITH(NOLOCK) ON (r_StockGs_478.StockGID=r_Stocks_31.StockGID) LEFT JOIN r_CompGrs2 r_CompGrs2_409 WITH(NOLOCK) ON (r_CompGrs2_409.CompGrID2=r_CompsAdd_408.CompGrID2) JOIN r_Codes2 r_Codes2_178 WITH(NOLOCK) ON (r_Codes2_178.CodeID2=r_Comps_27.CodeID2) JOIN r_Codes3 r_Codes3_749 WITH(NOLOCK) ON (r_Codes3_749.CodeID3=r_Comps_27.CodeID3) JOIN r_Codes4 r_Codes4_180 WITH(NOLOCK) ON (r_Codes4_180.CodeID4=r_Comps_27.CodeID4) JOIN r_CompGrs1 r_CompGrs1_213 WITH(NOLOCK) ON (r_CompGrs1_213.CompGrID1=r_Comps_27.CompGrID1) JOIN r_CompGrs2 r_CompGrs2_514 WITH(NOLOCK) ON (r_CompGrs2_514.CompGrID2=r_Comps_27.CompGrID2) JOIN r_CompGrs5 r_CompGrs5_303 WITH(NOLOCK) ON (r_CompGrs5_303.CompGrID5=r_Comps_27.CompGrID5) JOIN r_Emps r_Emps_795 WITH(NOLOCK) ON (r_Emps_795.EmpID=r_Comps_27.EmpID) JOIN r_Emps r_Emps_789 WITH(NOLOCK) ON (r_Emps_789.EmpID=r_Codes3_761.EmpID) LEFT JOIN at_r_SRs at_r_SRs_538 WITH(NOLOCK) ON (at_r_SRs_538.SRID=at_r_CompOurTerms_526.SRID) LEFT JOIN r_Uni r_Uni_725 WITH(NOLOCK) ON (r_Uni_725.RefTypeID=6660155 AND r_Uni_725.RefID=at_r_CompOurTerms_526.HaveCoffeeContr) LEFT JOIN r_Uni r_Uni_737 WITH(NOLOCK) ON (r_Uni_737.RefTypeID=6660155 AND r_Uni_737.RefID=at_r_CompOurTerms_526.HaveMarketContr) LEFT JOIN r_Emps r_Emps_790 WITH(NOLOCK) ON (r_Emps_790.EmpID=at_r_SRs_538.EmpID) LEFT JOIN r_Uni r_Uni_586 WITH(NOLOCK) ON (r_Uni_586.RefTypeID=6660153 AND r_Uni_586.RefID=at_r_SRs_538.AffID) %WHERE%%GROUPBY%
--av_Elit_ARHIV_t_Ret t_Ret_1 WITH(NOLOCK)  LEFT JOIN at_r_CompOurTerms at_r_CompOurTerms_500 WITH(NOLOCK) ON (at_r_CompOurTerms_500.CompID=t_Ret_1.CompID AND at_r_CompOurTerms_500.OurID=t_Ret_1.OurID)  JOIN r_Codes1 r_Codes1_28 WITH(NOLOCK) ON (r_Codes1_28.CodeID1=t_Ret_1.CodeID1)  JOIN r_Codes2 r_Codes2_29 WITH(NOLOCK) ON (r_Codes2_29.CodeID2=t_Ret_1.CodeID2)  JOIN r_Codes3 r_Codes3_30 WITH(NOLOCK) ON (r_Codes3_30.CodeID3=t_Ret_1.CodeID3)  JOIN r_Codes4 r_Codes4_383 WITH(NOLOCK) ON (r_Codes4_383.CodeID4=t_Ret_1.CodeID4)  JOIN r_Codes5 r_Codes5_395 WITH(NOLOCK) ON (r_Codes5_395.CodeID5=t_Ret_1.CodeID5)  JOIN av_Elit_ARHIV_r_Comps r_Comps_27 WITH(NOLOCK) ON (r_Comps_27.CompID=t_Ret_1.CompID)  LEFT JOIN r_CompsAdd r_CompsAdd_406 WITH(NOLOCK) ON (r_CompsAdd_406.CompID=t_Ret_1.CompID AND r_CompsAdd_406.CompAdd=t_Ret_1.Address)  JOIN r_Deps r_Deps_288 WITH(NOLOCK) ON (r_Deps_288.DepID=t_Ret_1.DepID)  JOIN av_Elit_ARHIV_r_Emps r_Emps_32 WITH(NOLOCK) ON (r_Emps_32.EmpID=t_Ret_1.EmpID)  JOIN r_Ours r_Ours_26 WITH(NOLOCK) ON (r_Ours_26.OurID=t_Ret_1.OurID)  JOIN av_Elit_ARHIV_r_Stocks r_Stocks_31 WITH(NOLOCK) ON (r_Stocks_31.StockID=t_Ret_1.StockID)  JOIN av_Elit_ARHIV_t_RetD t_RetD_2 WITH(NOLOCK) ON (t_RetD_2.ChID=t_Ret_1.ChID)  JOIN av_Elit_ARHIV_t_PInP t_PInP_130 WITH(NOLOCK) ON (t_PInP_130.PPID=t_RetD_2.PPID AND t_PInP_130.ProdID=t_RetD_2.ProdID)  JOIN av_Elit_ARHIV_r_Comps r_Comps_476 WITH(NOLOCK) ON (r_Comps_476.CompID=t_PInP_130.CompID)  JOIN r_Prods r_Prods_131 WITH(NOLOCK) ON (r_Prods_131.ProdID=t_PInP_130.ProdID)  JOIN at_r_ProdG4 at_r_ProdG4_255 WITH(NOLOCK) ON (at_r_ProdG4_255.PGrID4=r_Prods_131.PGrID4)  JOIN at_r_ProdG5 at_r_ProdG5_256 WITH(NOLOCK) ON (at_r_ProdG5_256.PGrID5=r_Prods_131.PGrID5)  JOIN av_Elit_ARHIV_r_Comps r_Comps_740 WITH(NOLOCK) ON (r_Comps_740.CompID=r_Prods_131.SupID)  JOIN r_ProdBG r_ProdBG_756 WITH(NOLOCK) ON (r_ProdBG_756.PBGrID=r_Prods_131.PBGrID)  JOIN r_ProdC r_ProdC_132 WITH(NOLOCK) ON (r_ProdC_132.PCatID=r_Prods_131.PCatID)  JOIN r_ProdG r_ProdG_219 WITH(NOLOCK) ON (r_ProdG_219.PGrID=r_Prods_131.PGrID)  JOIN r_ProdG1 r_ProdG1_220 WITH(NOLOCK) ON (r_ProdG1_220.PGrID1=r_Prods_131.PGrID1)  JOIN r_Uni r_Uni_524 WITH(NOLOCK) ON (r_Uni_524.RefTypeID=6660115 AND r_Uni_524.RefID=r_Prods_131.ImpID)  LEFT JOIN r_ProdEC r_ProdEC_536 WITH(NOLOCK) ON (r_ProdEC_536.ProdID=r_Prods_131.ProdID AND r_ProdEC_536.CompID=t_Ret_1.CompID)  JOIN r_Deps r_Deps_243 WITH(NOLOCK) ON (r_Deps_243.DepID=r_Stocks_31.DepID)  JOIN r_StockGs r_StockGs_464 WITH(NOLOCK) ON (r_StockGs_464.StockGID=r_Stocks_31.StockGID)  LEFT JOIN r_CompGrs2 r_CompGrs2_407 WITH(NOLOCK) ON (r_CompGrs2_407.CompGrID2=r_CompsAdd_406.CompGrID2)  JOIN r_Codes2 r_Codes2_178 WITH(NOLOCK) ON (r_Codes2_178.CodeID2=r_Comps_27.CodeID2)  JOIN r_Codes3 r_Codes3_700 WITH(NOLOCK) ON (r_Codes3_700.CodeID3=r_Comps_27.CodeID3)  JOIN r_Codes4 r_Codes4_180 WITH(NOLOCK) ON (r_Codes4_180.CodeID4=r_Comps_27.CodeID4)  JOIN r_CompGrs1 r_CompGrs1_213 WITH(NOLOCK) ON (r_CompGrs1_213.CompGrID1=r_Comps_27.CompGrID1)  JOIN r_CompGrs2 r_CompGrs2_488 WITH(NOLOCK) ON (r_CompGrs2_488.CompGrID2=r_Comps_27.CompGrID2)  JOIN r_CompGrs5 r_CompGrs5_279 WITH(NOLOCK) ON (r_CompGrs5_279.CompGrID5=r_Comps_27.CompGrID5)  JOIN av_Elit_ARHIV_r_Emps r_Emps_207 WITH(NOLOCK) ON (r_Emps_207.EmpID=r_Comps_27.EmpID)  JOIN av_Elit_ARHIV_r_Emps r_Emps_724 WITH(NOLOCK) ON (r_Emps_724.EmpID=r_Codes3_30.EmpID)  LEFT JOIN at_r_SRs at_r_SRs_512 WITH(NOLOCK) ON (at_r_SRs_512.SRID=at_r_CompOurTerms_500.SRID)  LEFT JOIN r_Uni r_Uni_676 WITH(NOLOCK) ON (r_Uni_676.RefTypeID=6660155 AND r_Uni_676.RefID=at_r_CompOurTerms_500.HaveCoffeeContr)  LEFT JOIN r_Uni r_Uni_688 WITH(NOLOCK) ON (r_Uni_688.RefTypeID=6660155 AND r_Uni_688.RefID=at_r_CompOurTerms_500.HaveMarketContr)  LEFT JOIN av_Elit_ARHIV_r_Emps r_Emps_712 WITH(NOLOCK) ON (r_Emps_712.EmpID=at_r_SRs_512.EmpID)  LEFT JOIN r_Uni r_Uni_548 WITH(NOLOCK) ON (r_Uni_548.RefTypeID=6660153 AND r_Uni_548.RefID=at_r_SRs_512.AffID)  %WHERE%%GROUPBY%
--av_t_Rec t_Rec_1 WITH(NOLOCK) JOIN r_Codes1 r_Codes1_42 WITH(NOLOCK) ON (r_Codes1_42.CodeID1=t_Rec_1.CodeID1) JOIN r_Codes2 r_Codes2_52 WITH(NOLOCK) ON (r_Codes2_52.CodeID2=t_Rec_1.CodeID2) JOIN r_Codes3 r_Codes3_62 WITH(NOLOCK) ON (r_Codes3_62.CodeID3=t_Rec_1.CodeID3) JOIN r_Codes4 r_Codes4_72 WITH(NOLOCK) ON (r_Codes4_72.CodeID4=t_Rec_1.CodeID4) JOIN r_Codes5 r_Codes5_82 WITH(NOLOCK) ON (r_Codes5_82.CodeID5=t_Rec_1.CodeID5) JOIN r_Deps r_Deps_241 WITH(NOLOCK) ON (r_Deps_241.DepID=t_Rec_1.DepID) JOIN r_Ours r_Ours_22 WITH(NOLOCK) ON (r_Ours_22.OurID=t_Rec_1.OurID) JOIN av_t_RecD t_RecD_145 WITH(NOLOCK) ON (t_RecD_145.ChID=t_Rec_1.ChID) JOIN t_PInP t_PInP_146 WITH(NOLOCK) ON (t_PInP_146.PPID=t_RecD_145.PPID AND t_PInP_146.ProdID=t_RecD_145.ProdID) %WHERE%%GROUPBY%

BEGIN TRAN;

UPDATE v_MapSG SET SQLStr =  SQLStr
						  + ' UNION ALL SELECT t_Rec_1.OurID, r_Ours_22.OurName, t_Rec_1.CodeID1, r_Codes1_42.CodeName1, t_Rec_1.CodeID2, r_Codes1_42.Notes Notes1, r_Codes2_52.CodeName2, r_Codes2_52.Notes Notes2, t_Rec_1.CodeID3, r_Codes3_62.CodeName3, r_Codes3_62.Notes Notes3, t_Rec_1.CodeID4, r_Codes4_72.CodeName4, r_Codes4_72.Notes Notes4, t_Rec_1.CodeID5, r_Codes5_82.CodeName5, r_Codes5_82.Notes Notes5, t_Rec_1.DocDate, t_Rec_1.DepID, r_Deps_241.DepName, '' ' + SourceGrName + ''', SUM(0-(t_RecD_145.Qty * t_PInP_146.CostCC)) SumCC, SUM(0-(t_RecD_145.Qty * t_PInP_146.CostMC)) SumMC, SUM(0-((t_RecD_145.Qty * t_PInP_146.CostCC) / 9)) SumMC_K, SUM(0-(t_RecD_145.Qty * ((t_PInP_146.CostCC / 9) - t_PInP_146.CostMC))) SumCurrDif'
						  + ' FROM ElitR.dbo.'
						  + REPLACE(SQLStr,'JOIN ','JOIN ElitR.dbo.')
FROM v_MapSG	WHERE RepID = 1016 AND SourceID = 1

UPDATE v_MapSG SET SQLStr =  SQLStr
						  + ' UNION ALL SELECT t_Ret_2.OurID, r_Ours_23.OurName, t_Ret_2.CodeID1, r_Codes1_43.CodeName1, t_Ret_2.CodeID2, r_Codes1_43.Notes Notes1, r_Codes2_53.CodeName2, r_Codes2_53.Notes Notes2, t_Ret_2.CodeID3, r_Codes3_63.CodeName3, r_Codes3_63.Notes Notes3, t_Ret_2.CodeID4, r_Codes4_73.CodeName4, r_Codes4_73.Notes Notes4, t_Ret_2.CodeID5, r_Codes5_83.CodeName5, r_Codes5_83.Notes Notes5, t_Ret_2.DocDate, 0, r_Deps_246.DepName, '' ' + SourceGrName + ''', SUM(0-(t_RetD_141.Qty * t_PInP_142.CostCC)) SumCC, SUM(0-(t_RetD_141.Qty * t_PInP_142.CostMC)) SumMC, SUM(0-((t_RetD_141.Qty * t_PInP_142.CostCC) / 9)) SumMC_K, SUM(0-(t_RetD_141.Qty * ((t_PInP_142.CostCC / 9) - (t_PInP_142.CostMC)))) SumCurrDif'
						  + ' FROM ElitR.dbo.'
						  + REVERSE( SUBSTRING( REVERSE( REPLACE( REPLACE(SQLStr,'JOIN ','JOIN ElitR.dbo.'), '=t_Ret_2.DepID', '=0')),LEN('%GROUPBY%')+1, 1000000) )
						  + ' GROUP BY t_Ret_2.OurID, r_Ours_23.OurName, t_Ret_2.CodeID1, r_Codes1_43.CodeName1, t_Ret_2.CodeID2, r_Codes1_43.Notes, r_Codes2_53.CodeName2, r_Codes2_53.Notes, t_Ret_2.CodeID3, r_Codes3_63.CodeName3, r_Codes3_63.Notes, t_Ret_2.CodeID4, r_Codes4_73.CodeName4, r_Codes4_73.Notes, t_Ret_2.CodeID5, r_Codes5_83.CodeName5, r_Codes5_83.Notes, t_Ret_2.DocDate,r_Deps_246.DepName'
FROM v_MapSG	WHERE RepID = 1016 AND SourceID = 2

UPDATE v_MapSG SET SQLStr =  SQLStr
						  + ' UNION ALL SELECT t_CRet_3.OurID, r_Ours_24.OurName, t_CRet_3.CodeID1, r_Codes1_44.CodeName1, t_CRet_3.CodeID2, r_Codes1_44.Notes Notes1, r_Codes2_54.CodeName2, r_Codes2_54.Notes Notes2, t_CRet_3.CodeID3, r_Codes3_64.CodeName3, r_Codes3_64.Notes Notes3, t_CRet_3.CodeID4, r_Codes4_74.CodeName4, r_Codes4_74.Notes Notes4, t_CRet_3.CodeID5, r_Codes5_84.CodeName5, r_Codes5_84.Notes Notes5, t_CRet_3.DocDate, 0, '''', '' ' + SourceGrName + ''', SUM(t_CRetD_143.Qty * t_PInP_144.CostCC) SumCC, SUM(t_CRetD_143.Qty * t_PInP_144.CostMC) SumMC, SUM((t_CRetD_143.Qty * t_PInP_144.CostCC) / 9) SumMC_K, SUM(t_CRetD_143.Qty * ((t_PInP_144.CostCC / 9) - t_PInP_144.CostMC)) SumCurrDif'
						  + ' FROM ElitR.dbo.'
						  + REPLACE(SQLStr,'JOIN ','JOIN ElitR.dbo.')
FROM v_MapSG	WHERE RepID = 1016 AND SourceID = 3

UPDATE v_MapSG SET SQLStr =  SQLStr
						  + ' UNION ALL SELECT t_Inv_4.OurID, r_Ours_25.OurName, t_Inv_4.CodeID1, r_Codes1_45.CodeName1, t_Inv_4.CodeID2, r_Codes1_45.Notes Notes1, r_Codes2_55.CodeName2, r_Codes2_55.Notes Notes2, t_Inv_4.CodeID3, r_Codes3_65.CodeName3, r_Codes3_65.Notes Notes3, t_Inv_4.CodeID4, r_Codes4_75.CodeName4, r_Codes4_75.Notes Notes4, t_Inv_4.CodeID5, r_Codes5_85.CodeName5, r_Codes5_85.Notes Notes5, t_Inv_4.DocDate, 0, r_Deps_274.DepName, '' ' + SourceGrName + ''', SUM(t_InvD_147.Qty * t_PInP_148.CostCC) SumCC, SUM(t_InvD_147.Qty * t_PInP_148.CostMC) SumMC, SUM((t_InvD_147.Qty * t_PInP_148.CostCC) / 9) SumMC_K, SUM(t_InvD_147.Qty * ((t_PInP_148.CostCC / 9) - t_PInP_148.CostMC)) SumCurrDif'
						  + ' FROM ElitR.dbo.'
						  + REVERSE( SUBSTRING( REVERSE( REPLACE( REPLACE(SQLStr,'JOIN ','JOIN ElitR.dbo.'), '=t_Inv_4.DepID', '=0')),LEN('%GROUPBY%')+1, 1000000) )
						  + ' GROUP BY t_Inv_4.OurID, r_Ours_25.OurName, t_Inv_4.CodeID1, r_Codes1_45.CodeName1, t_Inv_4.CodeID2, r_Codes1_45.Notes, r_Codes2_55.CodeName2, r_Codes2_55.Notes, t_Inv_4.CodeID3, r_Codes3_65.CodeName3, r_Codes3_65.Notes, t_Inv_4.CodeID4, r_Codes4_75.CodeName4, r_Codes4_75.Notes, t_Inv_4.CodeID5, r_Codes5_85.CodeName5, r_Codes5_85.Notes, t_Inv_4.DocDate,r_Deps_274.DepName'
FROM v_MapSG	WHERE RepID = 1016 AND SourceID = 4

UPDATE v_MapSG SET SQLStr =  SQLStr
						  + ' UNION ALL SELECT t_Exp_5.OurID, r_Ours_26.OurName, t_Exp_5.CodeID1, r_Codes1_46.CodeName1, t_Exp_5.CodeID2, r_Codes1_46.Notes Notes1, r_Codes2_56.CodeName2, r_Codes2_56.Notes Notes2, t_Exp_5.CodeID3, r_Codes3_66.CodeName3, r_Codes3_66.Notes Notes3, t_Exp_5.CodeID4, r_Codes4_76.CodeName4, r_Codes4_76.Notes Notes4, t_Exp_5.CodeID5, r_Codes5_86.CodeName5, r_Codes5_86.Notes Notes5, t_Exp_5.DocDate, t_Exp_5.DepID, r_Deps_299.DepName, '' ' + SourceGrName + ''', SUM(t_ExpD_149.Qty * t_PInP_150.CostCC) SumCC, SUM(t_ExpD_149.Qty * t_PInP_150.CostMC) SumMC, SUM((t_ExpD_149.Qty * t_PInP_150.CostCC) / 9) SumMC_K, SUM(t_ExpD_149.Qty * ((t_PInP_150.CostCC / 9) - t_PInP_150.CostMC)) SumCurrDif'
						  + ' FROM ElitR.dbo.'
						  + REPLACE(SQLStr,'JOIN ','JOIN ElitR.dbo.')
FROM v_MapSG	WHERE RepID = 1016 AND SourceID = 5

UPDATE v_MapSG SET SQLStr =  SQLStr
						  + ' UNION ALL SELECT t_Epp_6.OurID, r_Ours_27.OurName, t_Epp_6.CodeID1, r_Codes1_47.CodeName1, t_Epp_6.CodeID2, r_Codes1_47.Notes Notes1, r_Codes2_57.CodeName2, r_Codes2_57.Notes Notes2, t_Epp_6.CodeID3, r_Codes3_67.CodeName3, r_Codes3_67.Notes Notes3, t_Epp_6.CodeID4, r_Codes4_77.CodeName4, r_Codes4_77.Notes Notes4, t_Epp_6.CodeID5, r_Codes5_87.CodeName5, r_Codes5_87.Notes Notes5, t_Epp_6.DocDate, t_Epp_6.DepID, r_Deps_302.DepName, '' ' + SourceGrName + ''', SUM(t_EppD_151.Qty * t_PInP_152.CostCC) SumCC, SUM(t_EppD_151.Qty * t_PInP_152.CostMC) SumMC, SUM((t_EppD_151.Qty * t_PInP_152.CostCC) / 9) SumMC_K, SUM(t_EppD_151.Qty * ((t_PInP_152.CostCC / 9) - t_PInP_152.CostMC)) SumCurrDif'
						  + ' FROM ElitR.dbo.'
						  + REPLACE(SQLStr,'JOIN ','JOIN ElitR.dbo.')
FROM v_MapSG	WHERE RepID = 1016 AND SourceID = 6

UPDATE v_MapSG SET SQLStr =  SQLStr
						  + ' UNION ALL SELECT t_Est_7.OurID, r_Ours_29.OurName, r_Codes1_183.CodeID1, r_Codes1_183.CodeName1, r_Codes2_184.CodeID2, r_Codes1_183.Notes Notes1, r_Codes2_184.CodeName2, r_Codes2_184.Notes Notes2, t_Est_7.CodeID3, r_Codes3_69.CodeName3, r_Codes3_69.Notes Notes3, r_Codes4_193.CodeID4, r_Codes4_193.CodeName4, r_Codes4_193.Notes Notes4, r_Codes5_185.CodeID5, r_Codes5_185.CodeName5, r_Codes5_185.Notes Notes5, t_Est_7.DocDate, r_Deps_213.DepID, r_Deps_213.DepName, '' ' + SourceGrName + ''', SUM(0-(t_EstD_153.Qty * t_PInP_154.CostCC)) SumCC, SUM(0-(t_EstD_153.Qty * t_PInP_154.CostMC)) SumMC, SUM(0-((t_EstD_153.Qty * t_PInP_154.CostCC) / 9)) SumMC_K, SUM(0-(t_EstD_153.Qty * ((t_PInP_154.CostCC / 9) - t_PInP_154.CostMC))) SumCurrDif'
						  + ' FROM ElitR.dbo.'
						  + REPLACE( REPLACE( REPLACE(SQLStr,'JOIN ','JOIN ElitR.dbo.') ,'=r_ProdG1_182.CodeID5','=0') , '=r_ProdC_180.CodeID1','=0')
FROM v_MapSG	WHERE RepID = 1016 AND SourceID = 7
--=r_ProdG1_182.CodeID5
--=r_ProdC_180.CodeID1
/*
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'JOIN r_Stocks','JOIN av_Elit_ARHIV_r_Stocks')	WHERE RepID IN (996,997,998,999,1005,1007,1008,1009,1010,1011,1012,1013,1014,1015,1017,1018,1019)
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'JOIN r_Prods','JOIN av_Elit_ARHIV_r_Prods')		WHERE RepID IN (996,997,998,999,1005,1007,1008,1009,1010,1011,1012,1013,1014,1015,1017,1018,1019)
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'JOIN t_PInP','JOIN av_Elit_ARHIV_t_PInP')		WHERE RepID IN (996,997,998,999,1005,1007,1008,1009,1010,1011,1012,1013,1014,1015,1017,1018,1019)
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'JOIN r_Emps','JOIN av_Elit_ARHIV_r_Emps')		WHERE RepID IN (996,997,998,999,1005,1007,1008,1009,1010,1011,1012,1013,1014,1015,1017,1018,1019)
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'JOIN r_Comps','JOIN av_Elit_ARHIV_r_Comps')		WHERE RepID IN (996,997,998,999,1005,1007,1008,1009,1010,1011,1012,1013,1014,1015,1017,1018,1019)
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_Elit_ARHIV_r_CompsAdd','r_CompsAdd')			WHERE RepID IN (996,997,998,999,1005,1007,1008,1009,1010,1011,1012,1013,1014,1015,1017,1018,1019)

UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_RetD','av_Elit_ARHIV_t_RetD')			WHERE RepID = 1019 AND SourceID = 1
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Ret','av_Elit_ARHIV_t_Ret')			WHERE RepID = 1019 AND SourceID = 1
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_CRetD','av_Elit_ARHIV_t_CRetD')		WHERE RepID = 1019 AND SourceID = 2
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_CRet','av_Elit_ARHIV_t_CRet')			WHERE RepID = 1019 AND SourceID = 2
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_RecD','av_Elit_ARHIV_t_RecD')			WHERE RepID = 1019 AND SourceID = 3
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Rec','av_Elit_ARHIV_t_Rec')			WHERE RepID = 1019 AND SourceID = 3
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_InvD','av_Elit_ARHIV_t_InvD')			WHERE RepID = 1019 AND SourceID = 4
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Inv','av_Elit_ARHIV_t_Inv')			WHERE RepID = 1019 AND SourceID = 4
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_ExpD','av_Elit_ARHIV_t_ExpD')			WHERE RepID = 1019 AND SourceID = 5
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Exp','av_Elit_ARHIV_t_Exp')			WHERE RepID = 1019 AND SourceID = 5
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_EppD','av_Elit_ARHIV_t_EppD')			WHERE RepID = 1019 AND SourceID = 6
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Epp','av_Elit_ARHIV_t_Epp')			WHERE RepID = 1019 AND SourceID = 6
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_ExcD','av_Elit_ARHIV_t_ExcD')			WHERE RepID = 1019 AND SourceID = 7
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Exc','av_Elit_ARHIV_t_Exc')			WHERE RepID = 1019 AND SourceID = 7
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_ExcD','av_Elit_ARHIV_t_ExcD')			WHERE RepID = 1019 AND SourceID = 8
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Exc','av_Elit_ARHIV_t_Exc')			WHERE RepID = 1019 AND SourceID = 8
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_VenA','av_Elit_ARHIV_t_VenA')			WHERE RepID = 1019 AND SourceID = 9
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_VenD','av_Elit_ARHIV_t_VenD')			WHERE RepID = 1019 AND SourceID = 9
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Ven','av_Elit_ARHIV_t_Ven')			WHERE RepID = 1019 AND SourceID = 9
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_VenA','av_Elit_ARHIV_t_VenA')			WHERE RepID = 1019 AND SourceID = 10
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_VenD','av_Elit_ARHIV_t_VenD')			WHERE RepID = 1019 AND SourceID = 10
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Ven','av_Elit_ARHIV_t_Ven')			WHERE RepID = 1019 AND SourceID = 10
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_EstD','av_Elit_ARHIV_t_EstD')			WHERE RepID = 1019 AND SourceID = 11
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Est','av_Elit_ARHIV_t_Est')			WHERE RepID = 1019 AND SourceID = 11
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_EstD','av_Elit_ARHIV_t_EstD')			WHERE RepID = 1019 AND SourceID = 13
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Est','av_Elit_ARHIV_t_Est')			WHERE RepID = 1019 AND SourceID = 13
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRecA','av_Elit_ARHIV_t_SRecA')		WHERE RepID = 1019 AND SourceID = 14
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRecD','av_Elit_ARHIV_t_SRecD')		WHERE RepID = 1019 AND SourceID = 14
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRec','av_Elit_ARHIV_t_SRec')			WHERE RepID = 1019 AND SourceID = 14
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRecA','av_Elit_ARHIV_t_SRecA')		WHERE RepID = 1019 AND SourceID = 15
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRecD','av_Elit_ARHIV_t_SRecD')		WHERE RepID = 1019 AND SourceID = 15
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRec','av_Elit_ARHIV_t_SRec')			WHERE RepID = 1019 AND SourceID = 15
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExpA','av_Elit_ARHIV_t_SExpA')		WHERE RepID = 1019 AND SourceID = 16
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExpD','av_Elit_ARHIV_t_SExpD')		WHERE RepID = 1019 AND SourceID = 16
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExp','av_Elit_ARHIV_t_SExp')			WHERE RepID = 1019 AND SourceID = 16
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExpA','av_Elit_ARHIV_t_SExpA')		WHERE RepID = 1019 AND SourceID = 17
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExpD','av_Elit_ARHIV_t_SExpD')		WHERE RepID = 1019 AND SourceID = 17
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExp','av_Elit_ARHIV_t_SExp')			WHERE RepID = 1019 AND SourceID = 17


UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_RecD','av_ElitR_t_RecD')		WHERE RepID = 1016 AND SourceID = 1
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Rec','av_ElitR_t_Rec')			WHERE RepID = 1016 AND SourceID = 1
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_RetD','av_ElitR_t_RetD')		WHERE RepID = 1016 AND SourceID = 2
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Ret','av_ElitR_t_Ret')			WHERE RepID = 1016 AND SourceID = 2
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_CRetD','av_ElitR_t_CRetD')		WHERE RepID = 1016 AND SourceID = 3
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_CRet','av_ElitR_t_CRet')		WHERE RepID = 1016 AND SourceID = 3
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_InvD','av_ElitR_t_InvD')		WHERE RepID = 1016 AND SourceID = 4
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Inv','av_ElitR_t_Inv')			WHERE RepID = 1016 AND SourceID = 4
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_ExpD','av_ElitR_t_ExpD')		WHERE RepID = 1016 AND SourceID = 5
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Exp','av_ElitR_t_Exp')			WHERE RepID = 1016 AND SourceID = 5
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_EppD','av_ElitR_t_EppD')		WHERE RepID = 1016 AND SourceID = 6
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Epp','av_ElitR_t_Epp')			WHERE RepID = 1016 AND SourceID = 6
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_EstD','av_ElitR_t_EstD')		WHERE RepID = 1016 AND SourceID = 7
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Est','av_ElitR_t_Est')			WHERE RepID = 1016 AND SourceID = 7
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_c_CompRec','av_ElitR_c_CompRec')	WHERE RepID = 1016 AND SourceID = 8
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_c_CompExp','av_ElitR_c_CompExp')	WHERE RepID = 1016 AND SourceID = 9
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_MonRec','av_ElitR_t_MonRec')	WHERE RepID = 1016 AND SourceID = 10
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_EstD','av_ElitR_t_EstD')		WHERE RepID = 1016 AND SourceID = 11
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Est','av_ElitR_t_Est')			WHERE RepID = 1016 AND SourceID = 11
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_CRRetD','av_ElitR_t_CRRetD')	WHERE RepID = 1016 AND SourceID = 12
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_CRRet','av_ElitR_t_CRRet')		WHERE RepID = 1016 AND SourceID = 12
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SaleD','av_ElitR_t_SaleD')		WHERE RepID = 1016 AND SourceID = 13
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Sale','av_ElitR_t_Sale')		WHERE RepID = 1016 AND SourceID = 13

UPDATE v_MapSG SET LFilter = '', EFilter = '' WHERE RepID = 1016

UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_c_CompIn ' + SUBSTRING(SQLStr,CHARINDEX('c_CompIn_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 1
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_c_CompRec ' + SUBSTRING(SQLStr,CHARINDEX('c_CompRec_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 2
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_c_CompExp ' + SUBSTRING(SQLStr,CHARINDEX('c_CompExp_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 3
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_t_Ret ' + SUBSTRING(SQLStr,CHARINDEX('t_Ret_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 4
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_t_CRet ' + SUBSTRING(SQLStr,CHARINDEX('t_CRet_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 5
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_t_MonRec ' + SUBSTRING(SQLStr,CHARINDEX('t_MonRec_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 6
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_t_Rec ' + SUBSTRING(SQLStr,CHARINDEX('t_Rec_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 7
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_t_Inv ' + SUBSTRING(SQLStr,CHARINDEX('t_Inv_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 8
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_t_Exp ' + SUBSTRING(SQLStr,CHARINDEX('t_Exp_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 9
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_t_Epp ' + SUBSTRING(SQLStr,CHARINDEX('t_Epp_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 10
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_c_CompCor ' + SUBSTRING(SQLStr,CHARINDEX('c_CompCor_' + CAST(121 AS VARCHAR(3)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 11
UPDATE v_MapSG SET SQLStr = 'av_Elit_ARHIV_c_PlanRec ' + SUBSTRING(SQLStr,CHARINDEX('c_PlanRec_' + CAST(122 AS VARCHAR(3)),SQLStr),LEN(SQLStr)) WHERE RepID = 1006 AND SourceID = 12

SELECT 'av_Elit_ARHIV_c_CompIn ' + SUBSTRING(SQLStr,CHARINDEX('c_CompIn_' + CAST(SourceID AS VARCHAR(2)),SQLStr),LEN(SQLStr))
FROM v_MapSG WHERE RepID = 1009 AND SourceID = 1

UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_c_CompIn','Elit_ARHIV.dbo.av_c_CompIn')	WHERE RepID = 1012 AND SourceID = 1
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_c_CompRec','av_Elit_ARHIV_c_CompRec')	WHERE RepID = 1012 AND SourceID = 2
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_c_CompExp','av_Elit_ARHIV_c_CompExp')	WHERE RepID = 1012 AND SourceID = 3
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Ret','av_Elit_ARHIV_t_Ret')			WHERE RepID = 1012 AND SourceID = 4
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_CRet','av_Elit_ARHIV_t_CRet')			WHERE RepID = 1012 AND SourceID = 5
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_MonRec','av_Elit_ARHIV_t_MonRec')		WHERE RepID = 1012 AND SourceID = 6
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Rec','av_Elit_ARHIV_t_Rec')			WHERE RepID = 1012 AND SourceID = 7
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Inv','av_Elit_ARHIV_t_Inv')			WHERE RepID = 1012 AND SourceID = 8
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Exp','av_Elit_ARHIV_t_Exp')			WHERE RepID = 1012 AND SourceID = 9
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Epp','av_Elit_ARHIV_t_Epp')			WHERE RepID = 1012 AND SourceID = 10
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_c_CompCor','av_Elit_ARHIV_c_CompCor')	WHERE RepID = 1012 AND SourceID = 11
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_c_PlanRec','av_Elit_ARHIV_c_PlanRec')	WHERE RepID = 1012 AND SourceID = 12


UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_RetD','av_Elit_ARHIV_t_RetD')		WHERE RepID = 1007 AND SourceID = 1
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Ret','av_Elit_ARHIV_t_Ret')		WHERE RepID = 1007 AND SourceID = 1
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_CRetD','av_Elit_ARHIV_t_CRetD')	WHERE RepID = 1007 AND SourceID = 2
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_CRet','av_Elit_ARHIV_t_CRet')		WHERE RepID = 1007 AND SourceID = 2
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_RecD','av_Elit_ARHIV_t_RecD')		WHERE RepID = 1007 AND SourceID = 3
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Rec','av_Elit_ARHIV_t_Rec')		WHERE RepID = 1007 AND SourceID = 3
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_InvD','av_Elit_ARHIV_t_InvD')		WHERE RepID = 1007 AND SourceID = 4
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Inv','av_Elit_ARHIV_t_Inv')		WHERE RepID = 1007 AND SourceID = 4
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_ExpD','av_Elit_ARHIV_t_ExpD')		WHERE RepID = 1007 AND SourceID = 5
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Exp','av_Elit_ARHIV_t_Exp')		WHERE RepID = 1007 AND SourceID = 5
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_EppD','av_Elit_ARHIV_t_EppD')		WHERE RepID = 1007 AND SourceID = 6
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Epp','av_Elit_ARHIV_t_Epp')		WHERE RepID = 1007 AND SourceID = 6
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_ExcD','av_Elit_ARHIV_t_ExcD')		WHERE RepID = 1007 AND SourceID = 7
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Exc','av_Elit_ARHIV_t_Exc')		WHERE RepID = 1007 AND SourceID = 7
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_ExcD','av_Elit_ARHIV_t_ExcD')		WHERE RepID = 1007 AND SourceID = 8
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Exc','av_Elit_ARHIV_t_Exc')		WHERE RepID = 1007 AND SourceID = 8
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_VenA','av_Elit_ARHIV_t_VenA')		WHERE RepID = 1007 AND SourceID = 9
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_VenD','av_Elit_ARHIV_t_VenD')		WHERE RepID = 1007 AND SourceID = 9
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Ven','av_Elit_ARHIV_t_Ven')		WHERE RepID = 1007 AND SourceID = 9
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_VenA','av_Elit_ARHIV_t_VenA')		WHERE RepID = 1007 AND SourceID = 10
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_VenD','av_Elit_ARHIV_t_VenD')		WHERE RepID = 1007 AND SourceID = 10
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Ven','av_Elit_ARHIV_t_Ven')		WHERE RepID = 1007 AND SourceID = 10
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_EstD','av_Elit_ARHIV_t_EstD')		WHERE RepID = 1007 AND SourceID = 11
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Est','av_Elit_ARHIV_t_Est')		WHERE RepID = 1007 AND SourceID = 11
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_EstD','av_Elit_ARHIV_t_EstD')		WHERE RepID = 1007 AND SourceID = 13
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_Est','av_Elit_ARHIV_t_Est')		WHERE RepID = 1007 AND SourceID = 13
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRecA','av_Elit_ARHIV_t_SRecA')	WHERE RepID = 1007 AND SourceID = 14
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRecD','av_Elit_ARHIV_t_SRecD')	WHERE RepID = 1007 AND SourceID = 14
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRec','av_Elit_ARHIV_t_SRec')		WHERE RepID = 1007 AND SourceID = 14
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExpA','av_Elit_ARHIV_t_SExpA')	WHERE RepID = 1007 AND SourceID = 15
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExpD','av_Elit_ARHIV_t_SExpD')	WHERE RepID = 1007 AND SourceID = 15
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExp','av_Elit_ARHIV_t_SExp')		WHERE RepID = 1007 AND SourceID = 15
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRecA','av_Elit_ARHIV_t_SRecA')	WHERE RepID = 1007 AND SourceID = 16
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRecD','av_Elit_ARHIV_t_SRecD')	WHERE RepID = 1007 AND SourceID = 16
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SRec','av_Elit_ARHIV_t_SRec')		WHERE RepID = 1007 AND SourceID = 16
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExpA','av_Elit_ARHIV_t_SExpA')	WHERE RepID = 1007 AND SourceID = 17
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExpD','av_Elit_ARHIV_t_SExpD')	WHERE RepID = 1007 AND SourceID = 17
UPDATE v_MapSG SET SQLStr = REPLACE(SQLStr,'av_t_SExp','av_Elit_ARHIV_t_SExp')		WHERE RepID = 1007 AND SourceID = 17
*/
ROLLBACK TRAN;


SELECT COUNT(*) FROM z_AzRoleReps WHERE RepID = 33
SELECT COUNT(*) FROM z_AzRoleReps WHERE RepID = 1019
--SELECT * FROM z_AzRoleReps WHERE RepID = 317
--SELECT * FROM z_AzRoleReps WHERE RepID = 1006

/*
SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (950,996)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (576,997)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (317,998)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (322,999)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (880,1005)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (954,1007)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (756,1008)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (754,1009)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (110,1010)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (807,1011)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (804,1012)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (443,1013)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (444,1014)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (449,1015)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (845,1018)

SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (33,1019)
*/
SELECT vr.RepID, vr.RepName, vrg.RepGrName
FROM v_Reps vr
JOIN v_RepGrs vrg WITH(NOLOCK) ON vrg.RepGrID = vr.RepGrID
WHERE RepID IN (449,1016) -- ›“Œ“ Œ“◊≈“ —¬ŒƒÕ€… — ElitR

/*
a_tRet_CheckFieldValues_IU
a_tRet_AutoLinkCont_IU
Œ·ÓÓÚ ÔÓ ÚÓ‚‡‡Ï (·Ûı„‡ÎÚÂËˇ) +Elit_ARHIV
*/

IF 1 = 0
BEGIN

DECLARE @a INT, @b INT
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT DISTINCT AzRoleCode, 1018 FROM z_AzRoleReps WHERE RepID = 845													 
UNION ALL
SELECT DISTINCT AzRoleCode, 1019 FROM z_AzRoleReps WHERE RepID = 33
--UNION ALL
--SELECT DISTINCT AzRoleCode, 1012 FROM z_AzRoleReps WHERE RepID = 804

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @a, @b
WHILE @@FETCH_STATUS = 0	 
BEGIN
		
	INSERT INTO z_AzRoleReps(AzRoleCode,RepID)
	SELECT @a, @b
	--DELETE z_AzRoleReps WHERE RepID = 996 AND AzRoleCode = @a

	EXEC a_UpdateAzPerms @UserMode = 1, @Code = @a
	
	WAITFOR DELAY '00:05:00';

	FETCH NEXT FROM CURSOR1 INTO @a, @b
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

END;
