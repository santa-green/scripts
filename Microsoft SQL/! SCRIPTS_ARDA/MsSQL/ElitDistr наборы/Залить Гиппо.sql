	USE ElitDistr
	EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'
	--GO
	--REVERT

IF 11=11
BEGIN  
	IF OBJECT_ID (N'tempdb..#TempRet', N'U') IS NOT NULL DROP TABLE #TempRet
	CREATE TABLE #TempRet ( N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdIDMA_RealPrice NUMERIC(21,9), ChID INT, DocID INT, TaxDocID INT, TaxDocDate SMALLDATETIME, ProdID INT, PPID INT, QtyInv NUMERIC(21,9), vozv_Elit NUMERIC(21,9), vozv_ElitDistr NUMERIC(21,9), QtyRet NUMERIC(21,9), rem NUMERIC(21,9), abs_razn NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, SrcPosID_Inv INT, Pos_Medoc INT, sumQtyInv INT)
	
	IF OBJECT_ID (N'tempdb..#TempRetFinal', N'U') IS NOT NULL DROP TABLE #TempRetFinal
	CREATE TABLE #TempRetFinal ( N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdIDMA_RealPrice NUMERIC(21,9), ChID INT, DocID INT, TaxDocID INT, TaxDocDate SMALLDATETIME, ProdID INT, PPID INT, QtyInv NUMERIC(21,9), vozv_Elit NUMERIC(21,9), vozv_ElitDistr NUMERIC(21,9), QtyRet NUMERIC(21,9), rem NUMERIC(21,9), abs_razn NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, SrcPosID_Inv INT, Pos_Medoc INT, sumQtyInv INT)

	IF OBJECT_ID (N'tempdb..#TempFindProdElit', N'U') IS NOT NULL DROP TABLE #TempFindProdElit
	CREATE TABLE #TempFindProdElit (N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdID_Elit INT, DNN SMALLDATETIME, NNN INT, ProdName VARCHAR(250), UM VARCHAR(50), Pos INT, TQty NUMERIC(21,9), Price NUMERIC(21,9), SumCC NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, rating INT )

	IF OBJECT_ID (N'tempdb..#TempFindProdElitAll', N'U') IS NOT NULL DROP TABLE #TempFindProdElitAll
	CREATE TABLE #TempFindProdElitAll (N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdID_Elit INT, DNN SMALLDATETIME, NNN INT, ProdName VARCHAR(250), UM VARCHAR(50), Pos INT, TQty NUMERIC(21,9), Price NUMERIC(21,9), SumCC NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, rating INT )

	IF OBJECT_ID (N'tempdb..#TempFindProdElitAll_tmp', N'U') IS NOT NULL DROP TABLE #TempFindProdElitAll_tmp
	CREATE TABLE #TempFindProdElitAll_tmp (N INT, ProdIDMA INT, ProdIDMA_Qty NUMERIC(21,9), ProdID_Elit INT, DNN SMALLDATETIME, NNN INT, ProdName VARCHAR(250), UM VARCHAR(50), Pos INT, TQty NUMERIC(21,9), Price NUMERIC(21,9), SumCC NUMERIC(21,9), QtyRealRet NUMERIC(21,9), CodeID2 INT, rating INT )

	
	IF OBJECT_ID (N'tempdb..#at_t_Medoc_v2', N'U') IS NOT NULL DROP TABLE #at_t_Medoc_v2
	SELECT   A110, A111, A17, A18, A19, A2_10, A2_11, A2_4, A2_5, A2_6, A2_7, A2_8, A2_9, A3_11, A4_10, A4_101, A4_11, A4_111, A4_4, A4_41, A4_5, A4_51, A4_6, A4_61, A4_7, A4_71, A4_8, A4_81, A4_9, A4_91, A5_10, A5_11, A5_7, A5_71, A5_8, A5_9, A6_10, A6_11, A6_7, A6_71, A6_8, A6_9, A7_10, A7_11, A7_7, A7_71, A7_8, A7_9, CHECKCONTR, CHECKRVS, DEPT_POK, DPA_REG_TIME, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, N1, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N2, N20, N21, N22, N23, N24, N25, N26, N2_1, N2_11, N2_12, N2_13, N2_1I, N3, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, SN, STYPE, UKTPRESENCE, VER, Z1_5, Z1_6, Z2_5, Z2_6, Z3_5, Z4_5, Z5_5, Z5_6, Z6_5, Z6_6, Z7_5, Z7_6, ZT
	 INTO #at_t_Medoc_v2
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Реестр_v2_gipo\Реестр_gipo_ПН_v2_J1201010_TAB1.xlsx' , 'select * from [Лист1$]') as ex
	GROUP BY A110, A111, A17, A18, A19, A2_10, A2_11, A2_4, A2_5, A2_6, A2_7, A2_8, A2_9, A3_11, A4_10, A4_101, A4_11, A4_111, A4_4, A4_41, A4_5, A4_51, A4_6, A4_61, A4_7, A4_71, A4_8, A4_81, A4_9, A4_91, A5_10, A5_11, A5_7, A5_71, A5_8, A5_9, A6_10, A6_11, A6_7, A6_71, A6_8, A6_9, A7_10, A7_11, A7_7, A7_71, A7_8, A7_9, CHECKCONTR, CHECKRVS, DEPT_POK, DPA_REG_TIME, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, N1, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N2, N20, N21, N22, N23, N24, N25, N26, N2_1, N2_11, N2_12, N2_13, N2_1I, N3, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, SN, STYPE, UKTPRESENCE, VER, Z1_5, Z1_6, Z2_5, Z2_6, Z3_5, Z4_5, Z5_5, Z5_6, Z6_5, Z6_6, Z7_5, Z7_6, ZT
	INSERT ElitDistr.dbo.at_t_Medoc_v2_Gippo
		SELECT * FROM #at_t_Medoc_v2 WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_v2_Gippo)
	SELECT * FROM ElitDistr.dbo.at_t_Medoc_v2_Gippo --where NNN = 7583

	--загружаем справочник с медка реестр налоговых накладных v2:TAB1
	--IF OBJECT_ID (N'ElitDistr.dbo.at_t_Medoc_TAB1_v2', N'U') IS NOT NULL DROP TABLE ElitDistr.dbo.at_t_Medoc_TAB1_v2
	--SELECT * into ElitDistr.dbo.at_t_Medoc_TAB1_v2 FROM #at_t_Medoc_TAB1_v2 
	IF OBJECT_ID (N'tempdb..#at_t_Medoc_TAB1_v2', N'U') IS NOT NULL DROP TABLE #at_t_Medoc_TAB1_v2
	SELECT SEND_DPA_RN,SEND_DPA_DATE,N2_11 NNN, N11 DNN, TAB1_51, TAB1_A1, TAB1_A10, TAB1_A11, TAB1_A110, TAB1_A111, TAB1_A12, TAB1_A13, TAB1_A131, TAB1_A132, TAB1_A133, TAB1_A14, TAB1_A141, TAB1_A15, TAB1_A16, TAB1_A17, TAB1_A171, TAB1_A18, TAB1_A19, TAB1_A8, TAB1_A9, TAB1_RATE
	 INTO #at_t_Medoc_TAB1_v2
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Реестр_v2_gipo\Реестр_gipo_ПН_v2_J1201010_TAB1.xlsx' , 'select * from [Лист1$]') as ex;
	INSERT ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo
		SELECT * FROM #at_t_Medoc_TAB1_v2 WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo)
	SELECT * FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo



	--загружаем справочник с медка реестр КОРРЕКТИРОВОК v2:Заголовки (Реестр_gipo_Дод2_v2_J1201210_TAB1.xlsx' , 'select * from [Лист1$])
	--IF OBJECT_ID (N'ElitDistr.dbo.at_t_Medoc_RET_v2', N'U') IS NOT NULL DROP TABLE ElitDistr.dbo.at_t_Medoc_RET_v2
	--SELECT * into ElitDistr.dbo.at_t_Medoc_RET_v2 FROM #at_t_Medoc_RET_v2 
	IF OBJECT_ID (N'tempdb..#at_t_Medoc_RET_v2', N'U') IS NOT NULL DROP TABLE #at_t_Medoc_RET_v2
	--SELECT   A1_10, A1_101, A1_11, A1_12, A1_14, A1_9, A1_91, A2_9, A2_91, A2_92, CHECKCONTR, CORRCMPL, DEPT_POK, DPA_REG_TIME, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, K1, K2, K3, N1, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N1I, N1_11, N1_12, N1_13, N2, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N2_1, N2_11, N2_12, N2_13, N2_2, N2_3, N3, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, RATE, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, UKTPRESENCE
	SELECT   A1_10, A1_101, A1_11, A1_12, A1_14, A1_9, A1_91, A2_9, A2_91, A2_92, CHECKCONTR, CORRCMPL, DEPT_POK, DPA_REG_TIME, EDRPOU, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, K1, K2, K3, N1, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N1I, N1_11, N1_12, N1_13, N2, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N2_1, N2_11, N2_12, N2_13, N2_2, N2_3, N3, N30, N31_1, N31_2, N31_3, N31_4, N31_5, N32_1, N32_2, N32_3, N32_4, N32_5, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, RATE, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, UKTPRESENCE
	 INTO #at_t_Medoc_RET_v2
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Реестр_v2_gipo\Реестр_gipo_Дод2_v2_J1201210_TAB1.xlsx' , 'select * from [Лист1$]') as ex
	--GROUP BY A1_10, A1_101, A1_11, A1_12, A1_14, A1_9, A1_91, A2_9, A2_91, A2_92, CHECKCONTR, CORRCMPL, DEPT_POK, DPA_REG_TIME, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, K1, K2, K3, N1, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N1I, N1_11, N1_12, N1_13, N2, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N2_1, N2_11, N2_12, N2_13, N2_2, N2_3, N3, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, RATE, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, UKTPRESENCE
	GROUP BY A1_10, A1_101, A1_11, A1_12, A1_14, A1_9, A1_91, A2_9, A2_91, A2_92, CHECKCONTR, CORRCMPL, DEPT_POK, DPA_REG_TIME, EDRPOU, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, K1, K2, K3, N1, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N1I, N1_11, N1_12, N1_13, N2, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N2_1, N2_11, N2_12, N2_13, N2_2, N2_3, N3, N30, N31_1, N31_2, N31_3, N31_4, N31_5, N32_1, N32_2, N32_3, N32_4, N32_5, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, RATE, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, UKTPRESENCE
	--INSERT ElitDistr.dbo.at_t_Medoc_RET_v2 (A1_10, A1_101, A1_11, A1_12, A1_14, A1_9, A1_91, A2_9, A2_91, A2_92, CHECKCONTR, CORRCMPL, DEPT_POK, DPA_REG_TIME, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, K1, K2, K3, N1, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N1I, N1_11, N1_12, N1_13, N2, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N2_1, N2_11, N2_12, N2_13, N2_2, N2_3, N3, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, RATE, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, UKTPRESENCE)
	INSERT ElitDistr.dbo.at_t_Medoc_RET_v2_Gippo
		SELECT A1_10, A1_101, A1_11, A1_12, A1_14, A1_9, A1_91, A2_9, A2_91, A2_92, CHECKCONTR, CORRCMPL, DEPT_POK, DPA_REG_TIME, EDRPOU, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, K1, K2, K3, N1, N10, N11, N12, null N13, N14, N15, N16, N17, N18, N19, N1I, N1_11, N1_12, N1_13, N2, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N2_1, N2_11, N2_12, N2_13, N2_2, N2_3, N3, N30, N31_1, N31_2, N31_3, N31_4, N31_5, N32_1, N32_2, N32_3, N32_4, N32_5, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, RATE, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, UKTPRESENCE 
		FROM #at_t_Medoc_RET_v2 WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET_v2_Gippo)
	SELECT * FROM ElitDistr.dbo.at_t_Medoc_RET_v2_Gippo --where SEND_DPA_RN = 9175515472


--поиск записи которая не инсертится
--BEGIN TRAN
--	--INSERT ElitDistr.dbo.at_t_Medoc_RET_v2_Gippo
--		SELECT top 100 A1_10, A1_101, A1_11, A1_12, A1_14, A1_9, A1_91, A2_9, A2_91, A2_92, CHECKCONTR, CORRCMPL, DEPT_POK, DPA_REG_TIME, EDRPOU, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, K1, K2, K3, N1, N10, N11, N12, null N13, N14, N15, N16, N17, N18, N19, N1I, N1_11, N1_12, N1_13, N2, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N2_1, N2_11, N2_12, N2_13, N2_2, N2_3, N3, N30, N31_1, N31_2, N31_3, N31_4, N31_5, N32_1, N32_2, N32_3, N32_4, N32_5, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, RATE, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, UKTPRESENCE 
--		FROM #at_t_Medoc_RET_v2 WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET_v2_Gippo) 
--		--and SEND_DPA_RN not in ('9239033891')
--		ORDER BY DPA_REG_TIME desc
--ROLLBACK TRAN


	--загружаем справочник с медка реестр КОРРЕКТИРОВОК v2:TAB1 (Реестр_gipo_Дод2_v2_J1201210_TAB1.xlsx' , 'select * from [Лист1$])
	--IF OBJECT_ID (N'ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2', N'U') IS NOT NULL DROP TABLE ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2
	--SELECT * into ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2 FROM #at_t_Medoc_RET_TAB1_v2 
	IF OBJECT_ID (N'tempdb..#at_t_Medoc_RET_TAB1_v2', N'U') IS NOT NULL DROP TABLE #at_t_Medoc_RET_TAB1_v2
	--SELECT SEND_DPA_RN,SEND_DPA_DATE,N2_11 NNN,N2 DNN, TAB1_A01, TAB1_A011, TAB1_A012, TAB1_A013, TAB1_A014, TAB1_A1, TAB1_A10, TAB1_A11, TAB1_A12, TAB1_A13, TAB1_A14, TAB1_A15, TAB1_A2, TAB1_A3, TAB1_A31, TAB1_A32, TAB1_A33, TAB1_A4, TAB1_A41, TAB1_A5, TAB1_A6, TAB1_A7, TAB1_A8, TAB1_A9, TAB1_A91, TAB1_RATE
	SELECT SEND_DPA_RN,SEND_DPA_DATE,N2_11 NNN,N2 DNN,N1_11 Nkor,N15 Dkor, null Pos_NN, TAB1_A, TAB1_A01, TAB1_A011, TAB1_A012, TAB1_A013, TAB1_A014, TAB1_A020, TAB1_A1, TAB1_A10, TAB1_A11, TAB1_A12, TAB1_A13, TAB1_A14, TAB1_A15, TAB1_A2, TAB1_A21, TAB1_A22, TAB1_A3, TAB1_A31, TAB1_A32, TAB1_A33, TAB1_A4, TAB1_A41, TAB1_A5, TAB1_A6, TAB1_A7, TAB1_A8, TAB1_A9, TAB1_A91, TAB1_RATE
	 INTO #at_t_Medoc_RET_TAB1_v2
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Реестр_v2_gipo\Реестр_gipo_Дод2_v2_J1201210_TAB1.xlsx' , 'select * from [Лист1$]') as ex;
	--INSERT ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2 (SEND_DPA_RN,SEND_DPA_DATE,NNN,DNN, TAB1_A01, TAB1_A011, TAB1_A012, TAB1_A013, TAB1_A014, TAB1_A1, TAB1_A10, TAB1_A11, TAB1_A12, TAB1_A13, TAB1_A14, TAB1_A15, TAB1_A2, TAB1_A3, TAB1_A31, TAB1_A32, TAB1_A33, TAB1_A4, TAB1_A41, TAB1_A5, TAB1_A6, TAB1_A7, TAB1_A8, TAB1_A9, TAB1_A91, TAB1_RATE)
	INSERT ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo (SEND_DPA_RN, SEND_DPA_DATE, NNN, DNN, Nkor, Dkor, Pos_NN, TAB1_A, TAB1_A01, TAB1_A011, TAB1_A012, TAB1_A013, TAB1_A014, TAB1_A020, TAB1_A1, TAB1_A10, TAB1_A11, TAB1_A12, TAB1_A13, TAB1_A14, TAB1_A15, TAB1_A2, TAB1_A21, TAB1_A22, TAB1_A3, TAB1_A31, TAB1_A32, TAB1_A33, TAB1_A4, TAB1_A41, TAB1_A5, TAB1_A6, TAB1_A7, TAB1_A8, TAB1_A9, TAB1_A91, TAB1_RATE)
		SELECT * FROM #at_t_Medoc_RET_TAB1_v2 WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo)
	SELECT * FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo where NNN = 7583


	SELECT round(SUM(TAB1_A10),2) 'Сумма без НДС. РН с 1.02.2017' FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo
	SELECT COUNT(*) 'Кол. РН' FROM (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo group by SEND_DPA_RN) s1
	--зарегистрированные корр с 1.02.2017 
	SELECT round(SUM(TAB1_A013),2) 'Сумма без НДС. Корр с 1.02.2017'FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo
	SELECT COUNT(*) 'Кол. Корр' FROM (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo group by SEND_DPA_RN) s1

	--суммы в базах по медку 
	--зарегистрированные РН с 1.01.2020
	SELECT round(SUM(TAB1_A10),2) 'Сумма без НДС. РН с 1.02.2020' FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo where DNN > '2019-12-31'
	SELECT COUNT(*) 'Кол. РН' FROM (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo where DNN > '2019-12-31' group by SEND_DPA_RN) s1
	--зарегистрированные корр с 1.01.2020 
	SELECT round(SUM(TAB1_A013),2) 'Сумма без НДС. Корр с 1.02.2020'FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo where Dkor > '2019-12-31'
	SELECT COUNT(*) 'Кол. Корр' FROM (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo where Dkor > '2019-12-31' group by SEND_DPA_RN) s1

if 1=1
BEGIN
	

--1 обновить позиции в коректировках
if 1=1
BEGIN
	
--BEGIN TRAN

--Обновление номера позиции в РН
UPDATE m
set Pos_NN =
	case 
	--если искомая позиция в корректировке больше максимальной позиции в РН и находится только один вариант
	when ( cast(TAB1_A01 as int) > (SELECT count(*)  FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn  ) ) 
		AND 1 = (SELECT count(distinct TAB1_A01) FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn and s1.TAB1_A3 = m.TAB1_A3 and s1.TAB1_A01 <= (SELECT count(*)  FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn) )
	then (SELECT distinct TAB1_A01 FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn and s1.TAB1_A3 = m.TAB1_A3 and s1.TAB1_A01 <= (SELECT count(*)  FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn) )
	--если искомая позиция в корректировке больше максимальной позиции в РН и находится мнежество вариантов то ищем только в текущей корректировке
	when ( cast(TAB1_A01 as int) > (SELECT count(*)  FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn  ) ) 
		AND 1 = (SELECT count(distinct TAB1_A01) FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn and s1.TAB1_A3 = m.TAB1_A3 and s1.SEND_DPA_RN = m.SEND_DPA_RN and s1.TAB1_A01 <= (SELECT count(*)  FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn) )
	then (SELECT distinct TAB1_A01 FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn and s1.TAB1_A3 = m.TAB1_A3 and s1.SEND_DPA_RN = m.SEND_DPA_RN and s1.TAB1_A01 <= (SELECT count(*)  FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn) )
	--если искомая позиция в корректировке больше максимальной позиции в РН и находится мнежество вариантов то ищем только в текущей корректировке
	when ( cast(TAB1_A01 as int) > (SELECT count(*)  FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn  ) ) 
		AND 1 <> (SELECT count(distinct TAB1_A01) FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn and s1.TAB1_A3 = m.TAB1_A3 and s1.SEND_DPA_RN = m.SEND_DPA_RN and s1.TAB1_A01 <= (SELECT count(*)  FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn) )
	then (SELECT count(distinct TAB1_A01)*-1 FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn and s1.TAB1_A3 = m.TAB1_A3 and s1.SEND_DPA_RN = m.SEND_DPA_RN and s1.TAB1_A01 <= (SELECT count(*)  FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn) )
	else TAB1_A01 end 
FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo m 
	where Pos_NN is null 
	and exists(SELECT top 1 1 FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo s1 with (nolock) where s1.nnn = m.nnn and s1.dnn = m.dnn)
	--and NNN = 831 and dnn = '2017-06-02 00:00:00.000' 


--SELECT * FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2 where Pos_NN is not null 
SELECT * FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo where Pos_NN is  null 

SELECT * FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo where Pos_NN <= 0 ORDER BY dnn,nnn

--ROLLBACK TRAN

END


--создать общую таблицу
IF OBJECT_ID (N'tempdb..#Medoc_All', N'U') IS NOT NULL DROP TABLE #Medoc_All
create table #Medoc_All (dnn date, NNN int, name nvarchar(250), Qty numeric(21,9), Price numeric(21,9), Pos int , Pos_NN int, DocType int)
insert #Medoc_All
SELECT  dnn, NNN, TAB1_A13 name, TAB1_A15 Qty, TAB1_A16 Price, TAB1_A1  Pos, TAB1_A1 Pos_NN , 1 DocType 
FROM ElitDistr.dbo.at_t_Medoc_TAB1_v2_Gippo     with (nolock) where dnn > DATEADD(year ,-3,cast(getdate() as date)) --ORDER BY 1
UNION ALL
SELECT  dnn, NNN, TAB1_A3  name,  TAB1_A5 Qty,  TAB1_A6 Price, TAB1_A01 Pos,         Pos_NN , 2 DocType 
FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo with (nolock) where dnn > DATEADD(year ,-3,cast(getdate() as date)) --ORDER BY 1

----SELECT * FROM #Medoc_All 
--where Pos <> Pos_NN

--генерировать таблицу для поиска возвратов
IF OBJECT_ID (N'tempdb..#Find_Medoc', N'U') IS NOT NULL DROP TABLE #Find_Medoc
SELECT * 
into #Find_Medoc 
FROM (
	SELECT dnn, NNN,Pos_NN,Price,sum(Qty) TQty 
	,(	SELECT top 1 pos  FROM #Medoc_All s4 where s4.nnn = gr.nnn and s4.dnn = gr.dnn and s4.Pos_NN = gr.Pos_NN ORDER BY Pos desc	) Last_pos
	,(	SELECT top 1 name FROM #Medoc_All s4 where s4.nnn = gr.nnn and s4.dnn = gr.dnn and s4.Pos_NN = gr.Pos_NN ORDER BY Pos desc	) Last_Name
	,(	SELECT top 1 name FROM #Medoc_All s4 where s4.nnn = gr.nnn and s4.dnn = gr.dnn and s4.Pos_NN = gr.Pos_NN ORDER BY Pos   	) First_Name

	FROM #Medoc_All gr 
	where 1=1 
	--and name = 'Арманьяк Лобад 1961 0,5*1 в дерев. коробці' 
	and not exists (SELECT top 1 1 FROM ElitDistr.dbo.at_t_Medoc_RET_TAB1_v2_Gippo s1  with (nolock) where  s1.nnn = gr.nnn and s1.dnn = gr.dnn and Pos_NN <= 0)
	--and NNN = 5713 and dnn = '2017-03-21'
	group by dnn, NNN,Pos_NN,Price
	having sum(Qty) <> 0
) gr2 
--where Last_Name in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (32618))
	--ORDER BY 1,2,cast(Pos_NN as int)

--переместить данные в постоянную таблицу elit.dbo.at_t_Medoc_Find_v2_Gippo
--SELECT * into elit.dbo.at_t_Medoc_Find_v2_Gippo FROM #Find_Medoc
delete elit.dbo.at_t_Medoc_Find_v2_Gippo 
insert elit.dbo.at_t_Medoc_Find_v2_Gippo
SELECT * FROM #Find_Medoc

END

END
