--Синхронизация РН элит и медок
USE Elit
EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'

IF 11=0
BEGIN  
	--догружаем справочник с медка реестр налоговых накладных J1201009
	IF OBJECT_ID (N'tempdb..#Medoc', N'U') IS NOT NULL DROP TABLE #Medoc
	SELECT * 
	 INTO #Medoc	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_дозаливка_J1201009.xlsx' , 'select * from [Лист1$]') as ex;
	--SELECT * FROM #Medoc
	--Удалить не зарегестрированные РН
	DELETE ElitDistr.dbo.at_t_Medoc WHERE SEND_DPA_RN = '' OR SEND_DPA_RN IS NULL
	--Добавить новые и зарегестрированные РН
	SELECT * FROM #Medoc WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc)
	INSERT ElitDistr.dbo.at_t_Medoc
		SELECT * FROM #Medoc WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc)	

	--догружаем справочник с медка реестр налоговых накладных J1201010
	IF OBJECT_ID (N'tempdb..#Medoc10', N'U') IS NOT NULL DROP TABLE #Medoc10
	SELECT A110, A111, A17, A18, A19, A2_10, A2_11, A2_4, A2_5, A2_6, A2_7, A2_8, A2_9, A3_11, A4_10, A4_101, A4_11, A4_111, A4_4, A4_41, A4_5, A4_51, A4_6, A4_61, A4_7, A4_71, A4_8, A4_81, A4_9, A4_91, A5_10, A5_11, A5_7, A5_71, A5_8, A5_9, A6_10, A6_11, A6_7, A6_71, A6_8, A6_9, A7_10, A7_11, A7_7, A7_71, A7_8, A7_9, CHECKCONTR, CHECKRVS, DEPT_POK, DPA_REG_TIME, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, N1, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N2, N20, N21, N22, N23, N24, N25, N26, N2_1, N2_11, N2_12, N2_13, N2_1I, N3, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, SN, STYPE, UKTPRESENCE, VER, Z1_5, Z1_6, Z2_5, Z2_6, Z3_5, Z4_5, Z5_5, Z5_6, Z6_5, Z6_6, Z7_5, Z7_6, ZT, TAB1_51, TAB1_A1, TAB1_A10, TAB1_A11, TAB1_A110, TAB1_A111, TAB1_A12, TAB1_A13, TAB1_A131, TAB1_A132, TAB1_A133, TAB1_A14, TAB1_A141, TAB1_A15, TAB1_A16, TAB1_A17, TAB1_A171, TAB1_A18, TAB1_A19, TAB1_A8, TAB1_A9, TAB1_RATE 
	 INTO #Medoc10	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_дозаливка_J1201010.xlsx' , 'select * from [Лист1$]') as ex;
	--SELECT * FROM #Medoc10
	--Удалить не зарегестрированные РН
	DELETE ElitDistr.dbo.at_t_Medoc WHERE SEND_DPA_RN = '' OR SEND_DPA_RN IS NULL
	--Добавить новые и зарегестрированные РН
	SELECT * FROM #Medoc10 WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc)
	INSERT ElitDistr.dbo.at_t_Medoc
		SELECT * FROM #Medoc10 WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc)	
	
	--J1201209 догружаем справочник с медка по корректировкам
	IF OBJECT_ID (N'tempdb..#Medoc_RET', N'U') IS NOT NULL DROP TABLE #Medoc_RET
	SELECT *
	 INTO #Medoc_RET	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_Возвраты_дозаливка_J1201209.xlsx' , 'select * from [Лист1$]') as ex;
    --SELECT * FROM #Medoc_RET WHERE SEND_DPA_RN IS not NULL
	--Удалить не зарегестрированные корректировки к РН
	DELETE ElitDistr.dbo.at_t_Medoc_RET WHERE SEND_DPA_RN = '' OR SEND_DPA_RN IS NULL
	--Добавить новые и зарегестрированные корректировки к РН
	SELECT * FROM #Medoc_RET WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET)
	INSERT ElitDistr.dbo.at_t_Medoc_RET
		SELECT * FROM #Medoc_RET WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET) 

	--J1201210 догружаем справочник с медка по корректировкам Реестр_Медок_Возвраты_дозаливка_J1201210.xlsx
	IF OBJECT_ID (N'tempdb..#Medoc10x_RET', N'U') IS NOT NULL DROP TABLE #Medoc10x_RET
  --SELECT A1_10,A1_101,A1_11,A1_12,A1_14,A1_9,A1_91,A2_9,A2_91,A2_92,CHECKCONTR,CORRCMPL,DEPT_POK,DPA_REG_TIME,EDRPOU,EDR_POK,FIRM_ADR,FIRM_CITYCD,FIRM_EDRPOU,FIRM_INN,FIRM_NAME,FIRM_PHON,FIRM_SRPNDS,FIRM_TELORG,INN,K1,K2,K3,N1,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N1I,N1_11,N1_12,N1_13,N2,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N2_1,N2_11,N2_12,N2_13,N2_2,N2_3,N3,N30,N31_1,N31_2,N31_3,N31_4,N31_5,N32_1,N32_2,N32_3,N32_4,N32_5,N4,N5,N6,N7,N8,N81,N811,N812,N82,N9,NAKL_TYPE,PHON,PKRED,PZOB,RATE,REP_KS,RSTCODE,RSTTYPE,SEND_DPA,SEND_DPA_DATE,SEND_DPA_RN,SEND_PERSON,SEND_PERSON_DATE,SERVICEPRESENCE,SMKOR_N1,UKTPRESENCE,TAB1_A,TAB1_A01,TAB1_A011,TAB1_A012,TAB1_A013,TAB1_A014,TAB1_A020,TAB1_A1,TAB1_A10,TAB1_A11,TAB1_A12,TAB1_A13,TAB1_A14,TAB1_A15,TAB1_A2,TAB1_A21,TAB1_A22,TAB1_A3,TAB1_A31,TAB1_A32,TAB1_A33,TAB1_A4,TAB1_A41,TAB1_A5,TAB1_A6,TAB1_A7,TAB1_A8,TAB1_A9,TAB1_A91,TAB1_RATE 
	SELECT A1_10,A1_101,A1_11,A1_12,A1_14,A1_9,A1_91,A2_9,A2_91,A2_92,CHECKCONTR,CORRCMPL,DEPT_POK,DPA_REG_TIME,EDR_POK,FIRM_ADR,FIRM_CITYCD,FIRM_EDRPOU,FIRM_INN,FIRM_NAME,FIRM_PHON,FIRM_SRPNDS,FIRM_TELORG,INN,K1,K2,K3,N1,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N1I,N1_11,N1_12,N1_13,N2,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N2_1,N2_11,N2_12,N2_13,N2_2,N2_3,N3,N4,N5,N6,N7,N8,N81,N811,N812,N82,N9,NAKL_TYPE,PHON,PKRED,PZOB,RATE,REP_KS,RSTCODE,RSTTYPE,SEND_DPA,SEND_DPA_DATE,SEND_DPA_RN,SEND_PERSON,SEND_PERSON_DATE,SERVICEPRESENCE,SMKOR_N1,UKTPRESENCE,TAB1_A01,TAB1_A011,TAB1_A012,TAB1_A013,TAB1_A014,TAB1_A1,TAB1_A10,TAB1_A11,TAB1_A12,TAB1_A13,TAB1_A14,TAB1_A15,TAB1_A2,TAB1_A3,TAB1_A31,TAB1_A32,TAB1_A33,TAB1_A4,TAB1_A41,TAB1_A5,TAB1_A6,TAB1_A7,TAB1_A8,TAB1_A9,TAB1_A91,TAB1_RATE
	 INTO #Medoc10x_RET	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_Возвраты_дозаливка_J1201210.xlsx' , 'select * from [Лист1$]') as ex;
    --SELECT * FROM #Medoc_RET WHERE SEND_DPA_RN IS not NULL
	--Удалить не зарегестрированные корректировки к РН
	DELETE ElitDistr.dbo.at_t_Medoc_RET WHERE SEND_DPA_RN = '' OR SEND_DPA_RN IS NULL
	--Добавить новые и зарегестрированные корректировки к РН
	--SELECT top 1 * FROM ElitDistr.dbo.at_t_Medoc_RET where SEND_DPA_RN not in (9270555208)
	SELECT * FROM #Medoc10x_RET WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET)
	INSERT ElitDistr.dbo.at_t_Medoc_RET
		SELECT * FROM #Medoc10x_RET WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET) 

	--J1201210 догружаем справочник с медка по корректировкам Реестр_Медок_Возвраты_дозаливка_J1201210.xls
	IF OBJECT_ID (N'tempdb..#Medoc10_RET', N'U') IS NOT NULL DROP TABLE #Medoc10_RET
  --SELECT A1_10,A1_101,A1_11,A1_12,A1_14,A1_9,A1_91,A2_9,A2_91,A2_92,CHECKCONTR,CORRCMPL,DEPT_POK,DPA_REG_TIME,EDRPOU,EDR_POK,FIRM_ADR,FIRM_CITYCD,FIRM_EDRPOU,FIRM_INN,FIRM_NAME,FIRM_PHON,FIRM_SRPNDS,FIRM_TELORG,INN,K1,K2,K3,N1,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N1I,N1_11,N1_12,N1_13,N2,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N2_1,N2_11,N2_12,N2_13,N2_2,N2_3,N3,N30,N31_1,N31_2,N31_3,N31_4,N31_5,N32_1,N32_2,N32_3,N32_4,N32_5,N4,N5,N6,N7,N8,N81,N811,N812,N82,N9,NAKL_TYPE,PHON,PKRED,PZOB,RATE,REP_KS,RSTCODE,RSTTYPE,SEND_DPA,SEND_DPA_DATE,SEND_DPA_RN,SEND_PERSON,SEND_PERSON_DATE,SERVICEPRESENCE,SMKOR_N1,UKTPRESENCE,TAB1_A,TAB1_A01,TAB1_A011,TAB1_A012,TAB1_A013,TAB1_A014,TAB1_A020,TAB1_A1,TAB1_A10,TAB1_A11,TAB1_A12,TAB1_A13,TAB1_A14,TAB1_A15,TAB1_A2,TAB1_A21,TAB1_A22,TAB1_A3,TAB1_A31,TAB1_A32,TAB1_A33,TAB1_A4,TAB1_A41,TAB1_A5,TAB1_A6,TAB1_A7,TAB1_A8,TAB1_A9,TAB1_A91,TAB1_RATE 
	SELECT A1_10,A1_101,A1_11,A1_12,A1_14,A1_9,A1_91,A2_9,A2_91,A2_92,CHECKCONTR,CORRCMPL,DEPT_POK,DPA_REG_TIME,EDR_POK,FIRM_ADR,FIRM_CITYCD,FIRM_EDRPOU,FIRM_INN,FIRM_NAME,FIRM_PHON,FIRM_SRPNDS,FIRM_TELORG,INN,K1,K2,K3,N1,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N1I,N1_11,N1_12,N1_13,N2,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N2_1,N2_11,N2_12,N2_13,N2_2,N2_3,N3,N4,N5,N6,N7,N8,N81,N811,N812,N82,N9,NAKL_TYPE,PHON,PKRED,PZOB,RATE,REP_KS,RSTCODE,RSTTYPE,SEND_DPA,SEND_DPA_DATE,SEND_DPA_RN,SEND_PERSON,SEND_PERSON_DATE,SERVICEPRESENCE,SMKOR_N1,UKTPRESENCE,TAB1_A01,TAB1_A011,TAB1_A012,TAB1_A013,TAB1_A014,TAB1_A1,TAB1_A10,TAB1_A11,TAB1_A12,TAB1_A13,TAB1_A14,TAB1_A15,TAB1_A2,TAB1_A3,TAB1_A31,TAB1_A32,TAB1_A33,TAB1_A4,TAB1_A41,TAB1_A5,TAB1_A6,TAB1_A7,TAB1_A8,TAB1_A9,TAB1_A91,TAB1_RATE
	 INTO #Medoc10_RET	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_Возвраты_дозаливка_J1201210.xls' , 'select * from [Sheet1$]') as ex;
    --SELECT * FROM #Medoc_RET WHERE SEND_DPA_RN IS not NULL
	--Удалить не зарегестрированные корректировки к РН
	DELETE ElitDistr.dbo.at_t_Medoc_RET WHERE SEND_DPA_RN = '' OR SEND_DPA_RN IS NULL
	--Добавить новые и зарегестрированные корректировки к РН
	--SELECT top 1 * FROM ElitDistr.dbo.at_t_Medoc_RET where SEND_DPA_RN not in (9270555208)
	SELECT * FROM #Medoc10_RET WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET)
	INSERT ElitDistr.dbo.at_t_Medoc_RET
		SELECT  A1_10,A1_101,A1_11,A1_12,A1_14,A1_9,A1_91,A2_9,A2_91,A2_92,CHECKCONTR,CORRCMPL,DEPT_POK,DPA_REG_TIME,EDR_POK,FIRM_ADR,FIRM_CITYCD,FIRM_EDRPOU,FIRM_INN,FIRM_NAME,FIRM_PHON,FIRM_SRPNDS,FIRM_TELORG,INN,K1,K2,K3,N1,N10,N11
		,convert(datetime, N12 ,104 ) N12 ,N13,N14,N15,N16,N17,N18,N19,N1I,N1_11,N1_12,N1_13,N2,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N2_1,N2_11,N2_12,N2_13
		,convert(datetime, N2_2 ,104 ) N2_2,N2_3,N3,N4,N5,N6,N7,N8,N81,N811,N812
		,convert(datetime, N82 ,104 ) N82,N9,NAKL_TYPE,PHON,PKRED,PZOB,RATE,REP_KS,RSTCODE,RSTTYPE,SEND_DPA,SEND_DPA_DATE,SEND_DPA_RN,SEND_PERSON,SEND_PERSON_DATE,SERVICEPRESENCE,SMKOR_N1,UKTPRESENCE,TAB1_A01,TAB1_A011,TAB1_A012,TAB1_A013,TAB1_A014
		,convert(datetime, TAB1_A1 ,104 ) TAB1_A1,TAB1_A10,TAB1_A11,TAB1_A12,TAB1_A13,TAB1_A14,TAB1_A15,TAB1_A2,TAB1_A3,TAB1_A31,TAB1_A32,TAB1_A33,TAB1_A4,TAB1_A41,TAB1_A5,TAB1_A6,TAB1_A7,TAB1_A8,TAB1_A9,TAB1_A91,TAB1_RATE
		FROM #Medoc10_RET WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET)
		
	--суммы в базах по медку 
	--зарегистрированные РН с 1.02.2017 
	SELECT round(SUM(TAB1_A10),2) 'Сумма без НДС. РН с 1.02.2017' FROM ElitDistr.dbo.at_t_Medoc
	SELECT COUNT(*) 'Кол. РН' FROM (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc group by SEND_DPA_RN) s1
	--зарегистрированные корр с 1.02.2017 
	SELECT round(SUM(TAB1_A013),2) 'Сумма без НДС. Корр с 1.02.2017'FROM ElitDistr.dbo.at_t_Medoc_RET
	SELECT COUNT(*) 'Кол. Корр' FROM (SELECT SEND_DPA_RN FROM ElitDistr.dbo.at_t_Medoc_RET group by SEND_DPA_RN) s1



END


--1 ОБНОВИТЬ НЕПРАВИЛЬНЫЕ РН БЕЗ КОР 
BEGIN TRAN

if 1=1
begin


--1 ОБНОВИТЬ НЕПРАВИЛЬНЫЕ РН БЕЗ КОР 
SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc
,(SELECT top 1 d.ProdID ProdName FROM Elit.dbo.t_Inv i join Elit.dbo.t_InvD d on d.ChID = i.ChID where m.N11 = i.TaxDocDate and m.N2_11 = i.TaxDocID and d.ProdID in (32363,28572) /*and m.TAB1_A1 = d.SrcPosID*/ ORDER BY ( abs(d.SrcPosID - m.TAB1_A1)) ) prod_RN
,(SELECT p.Notes FROM Elit.dbo.r_prods p where p.ProdID = (SELECT top 1 d.ProdID ProdName FROM Elit.dbo.t_Inv i join Elit.dbo.t_InvD d on d.ChID = i.ChID where m.N11 = i.TaxDocDate and m.N2_11 = i.TaxDocID and d.ProdID in (32363,28572) /*and m.TAB1_A1 = d.SrcPosID*/ ORDER BY (abs(d.SrcPosID - m.TAB1_A1)) )) кор
,'update m2 set TAB1_A13 = ''' + (SELECT p.Notes FROM Elit.dbo.r_prods p where p.ProdID = (SELECT top 1 d.ProdID ProdName FROM Elit.dbo.t_Inv i join Elit.dbo.t_InvD d on d.ChID = i.ChID where m.N11 = i.TaxDocDate and m.N2_11 = i.TaxDocID 
and d.ProdID in (32363,28572) /*and m.TAB1_A1 = d.SrcPosID*/ ORDER BY (abs(d.SrcPosID - m.TAB1_A1)) ))
 + ''' from ElitDistr.dbo.at_t_Medoc m2 where m2.N11 = ''' + CONVERT( varchar, N11, 102)    + ''' and m2.N2_11 =  ' + N2_11 + ' and m2.TAB1_A13 = ''' + TAB1_A13 + ''''
FROM ElitDistr.dbo.at_t_Medoc m 
where 
TAB1_A13 in ('Коньяк Агмарті 3 роки 40% 0,5*12','Коньяк Агмарті 3 роки 40%  0,5*12','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле 0,75*6','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле  0,75*6')
and (SELECT p.Notes FROM Elit.dbo.r_prods p where p.ProdID = (SELECT top 1 d.ProdID ProdName FROM Elit.dbo.t_Inv i join Elit.dbo.t_InvD d on d.ChID = i.ChID where m.N11 = i.TaxDocDate and m.N2_11 = i.TaxDocID 
and d.ProdID in (32363,28572) /*and m.TAB1_A1 = d.SrcPosID*/ ORDER BY (abs(d.SrcPosID - m.TAB1_A1)) )) <> TAB1_A13

update m2 set TAB1_A13 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc m2 where m2.N11 = '2019.05.03' and m2.N2_11 =  1157 and m2.TAB1_A13 = 'Коньяк Агмарті 3 роки 40% 0,5*12'
update m2 set TAB1_A13 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc m2 where m2.N11 = '2019.05.03' and m2.N2_11 =  1314 and m2.TAB1_A13 = 'Коньяк Агмарті 3 роки 40% 0,5*12'
update m2 set TAB1_A13 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc m2 where m2.N11 = '2019.05.07' and m2.N2_11 =  2119 and m2.TAB1_A13 = 'Коньяк Агмарті 3 роки 40% 0,5*12'
update m2 set TAB1_A13 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc m2 where m2.N11 = '2019.05.07' and m2.N2_11 =  2251 and m2.TAB1_A13 = 'Коньяк Агмарті 3 роки 40% 0,5*12'
update m2 set TAB1_A13 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc m2 where m2.N11 = '2019.05.07' and m2.N2_11 =  2282 and m2.TAB1_A13 = 'Коньяк Агмарті 3 роки 40% 0,5*12'
update m2 set TAB1_A13 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc m2 where m2.N11 = '2019.04.23' and m2.N2_11 =  7669 and m2.TAB1_A13 = 'Коньяк Агмарті 3 роки 40% 0,5*12'

SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc
,(SELECT top 1 d.ProdID ProdName FROM Elit.dbo.t_Inv i join Elit.dbo.t_InvD d on d.ChID = i.ChID where m.N11 = i.TaxDocDate and m.N2_11 = i.TaxDocID and d.ProdID in (32363,28572) /*and m.TAB1_A1 = d.SrcPosID*/ ORDER BY ( abs(d.SrcPosID - m.TAB1_A1)) ) prod_RN
,(SELECT p.Notes FROM Elit.dbo.r_prods p where p.ProdID = (SELECT top 1 d.ProdID ProdName FROM Elit.dbo.t_Inv i join Elit.dbo.t_InvD d on d.ChID = i.ChID where m.N11 = i.TaxDocDate and m.N2_11 = i.TaxDocID and d.ProdID in (32363,28572) /*and m.TAB1_A1 = d.SrcPosID*/ ORDER BY (abs(d.SrcPosID - m.TAB1_A1)) )) кор
,'update m2 set TAB1_A13 = ''' + (SELECT p.Notes FROM Elit.dbo.r_prods p where p.ProdID = (SELECT top 1 d.ProdID ProdName FROM Elit.dbo.t_Inv i join Elit.dbo.t_InvD d on d.ChID = i.ChID where m.N11 = i.TaxDocDate and m.N2_11 = i.TaxDocID 
and d.ProdID in (32363,28572) /*and m.TAB1_A1 = d.SrcPosID*/ ORDER BY (abs(d.SrcPosID - m.TAB1_A1)) ))
 + ''' from ElitDistr.dbo.at_t_Medoc m2 where m2.N11 = ''' + CONVERT( varchar, N11, 102)    + ''' and m2.N2_11 =  ' + N2_11 + ' and m2.TAB1_A13 = ''' + TAB1_A13 + ''''
FROM ElitDistr.dbo.at_t_Medoc m 
where 
TAB1_A13 in ('Коньяк Агмарті 3 роки 40% 0,5*12','Коньяк Агмарті 3 роки 40%  0,5*12','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле 0,75*6','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле  0,75*6')
and (SELECT p.Notes FROM Elit.dbo.r_prods p where p.ProdID = (SELECT top 1 d.ProdID ProdName FROM Elit.dbo.t_Inv i join Elit.dbo.t_InvD d on d.ChID = i.ChID where m.N11 = i.TaxDocDate and m.N2_11 = i.TaxDocID 
and d.ProdID in (32363,28572) /*and m.TAB1_A1 = d.SrcPosID*/ ORDER BY (abs(d.SrcPosID - m.TAB1_A1)) )) <> TAB1_A13

end

ROLLBACK TRAN



--2 ОБНОВИТЬ НАЗВАНИЯ В КОРРЕКТИРОВКАХ ПО РН
BEGIN TRAN

if 1=1
begin

--2 ОБНОВИТЬ НАЗВАНИЯ В КОРРЕКТИРОВКАХ ПО РН
SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc
,(SELECT top 1 TAB1_A3 ProdName FROM ElitDistr.dbo.at_t_Medoc_RET mr where m.N11 = mr.N2 and m.N2_11 = mr.N2_11 and m.TAB1_A1 = mr.TAB1_A01 ) кор
,'update mr set TAB1_A3 = ''' + TAB1_A13 + ''' from ElitDistr.dbo.at_t_Medoc_RET mr where mr.N2 = ''' + CONVERT( varchar, N11, 102)    + ''' and mr.N2_11 =  ' + N2_11 + ' and mr.TAB1_A3 = ''' + 
	(SELECT top 1 TAB1_A3 ProdName FROM ElitDistr.dbo.at_t_Medoc_RET mr where m.N11 = mr.N2 and m.N2_11 = mr.N2_11 and m.TAB1_A1 = mr.TAB1_A01 ) + ''''
FROM ElitDistr.dbo.at_t_Medoc m 
where 
TAB1_A13 in ('Коньяк Агмарті 3 роки 40% 0,5*12','Коньяк Агмарті 3 роки 40%  0,5*12','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле 0,75*6','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле  0,75*6')
and (SELECT top 1 TAB1_A3 ProdName FROM ElitDistr.dbo.at_t_Medoc_RET mr where m.N11 = mr.N2 and m.N2_11 = mr.N2_11 and m.TAB1_A1 = mr.TAB1_A01 ) <> TAB1_A13

update mr set TAB1_A3 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc_RET mr where mr.N2 = '2018.01.19' and mr.N2_11 =  6177 and mr.TAB1_A3 = 'Коньяк Агмарті 3 роки 40% 0,5*12'
update mr set TAB1_A3 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc_RET mr where mr.N2 = '2018.11.27' and mr.N2_11 =  8958 and mr.TAB1_A3 = 'Коньяк Агмарті 3 роки 40% 0,5*12'
update mr set TAB1_A3 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc_RET mr where mr.N2 = '2019.04.12' and mr.N2_11 =  4490 and mr.TAB1_A3 = 'Коньяк Агмарті 3 роки 40% 0,5*12'
update mr set TAB1_A3 = 'Коньяк Агмарті 3 роки 40%  0,5*12' from ElitDistr.dbo.at_t_Medoc_RET mr where mr.N2 = '2019.04.09' and mr.N2_11 =  3206 and mr.TAB1_A3 = 'Коньяк Агмарті 3 роки 40% 0,5*12'


SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc
,(SELECT top 1 TAB1_A3 ProdName FROM ElitDistr.dbo.at_t_Medoc_RET mr where m.N11 = mr.N2 and m.N2_11 = mr.N2_11 and m.TAB1_A1 = mr.TAB1_A01 ) кор
,'update mr set TAB1_A3 = ''' + TAB1_A13 + ''' from ElitDistr.dbo.at_t_Medoc_RET mr where mr.N2 = ''' + CONVERT( varchar, N11, 102)    + ''' and mr.N2_11 =  ' + N2_11 + ' and mr.TAB1_A3 = ''' + 
	(SELECT top 1 TAB1_A3 ProdName FROM ElitDistr.dbo.at_t_Medoc_RET mr where m.N11 = mr.N2 and m.N2_11 = mr.N2_11 and m.TAB1_A1 = mr.TAB1_A01 ) + ''''
FROM ElitDistr.dbo.at_t_Medoc m 
where 
TAB1_A13 in ('Коньяк Агмарті 3 роки 40% 0,5*12','Коньяк Агмарті 3 роки 40%  0,5*12','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле 0,75*6','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле  0,75*6')
and (SELECT top 1 TAB1_A3 ProdName FROM ElitDistr.dbo.at_t_Medoc_RET mr where m.N11 = mr.N2 and m.N2_11 = mr.N2_11 and m.TAB1_A1 = mr.TAB1_A01 ) <> TAB1_A13


end

ROLLBACK TRAN




/*

SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC
FROM ElitDistr.dbo.at_t_Medoc 
ORDER BY DNN , nnn, CAST(TAB1_A1 as int)


SELECT d.*, med.* FROM Elit.dbo.t_Inv m 
JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
Join (SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC FROM ElitDistr.dbo.at_t_Medoc ) med 
on med.NNN = m.TaxDocID and med.DNN = TaxDocDate and med.Pos = d.SrcPosID

WHERE m.TaxDocID = t.NNN and m.TaxDocDate = t.DNN and d.ProdID = t.ProdID_Elit


SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC FROM ElitDistr.dbo.at_t_Medoc med
WHERE not EXISTS (SELECT top 1 1 FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID JOIN Elit.dbo.r_Prods p ON p.ProdID = d.ProdID
			  WHERE med.N11 = m.TaxDocDate and med.N2_11 = m.TaxDocID and med.TAB1_A13 = p.Notes and med.TAB1_A1 = d.SrcPosID and med.TAB1_A15 = d.Qty)
and not EXISTS (SELECT top 1 1 FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID JOIN Elit.dbo.r_Prods p ON p.ProdID = d.ProdID
			  WHERE med.N11 = m.TaxDocDate and med.N2_11 = m.TaxDocID and med.TAB1_A13 = (SELECT top 1 NameMedoc FROM ElitDistr.dbo.at_FindMedocNameD fmd where fmd.InUse = 1 and fmd.ProdID = d.ProdID) and med.TAB1_A1 = d.SrcPosID and med.TAB1_A15 = d.Qty)			  
ORDER BY DNN desc, nnn, CAST(TAB1_A1 as int)


SELECT p.Notes,d.*,m.* FROM Elit.dbo.t_Inv m
JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
JOIN Elit.dbo.r_Prods p ON p.ProdID = d.ProdID
WHERE m.TaxDocID = 10282
and m.TaxDocDate = '2018-05-30 00:00:00.000'
 
ORDER BY SrcPosID

SELECT top 1 NameMedoc FROM ElitDistr.dbo.at_FindMedocNameD fmd where fmd.InUse = 1 and fmd.ProdID = 28602
SELECT top 1 NameMedoc FROM ElitDistr.dbo.at_FindMedocNameD fmd where fmd.Notes_ProdName = 'Вино Zonin. Пино Гриджио Фриули Акилея 2015 белое  0,75*6'
SELECT * FROM ElitDistr.dbo.at_FindMedocNameD fmd where fmd.Notes_ProdName in ('Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле 0,75*6','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле  0,75*6')
SELECT * FROM Elit.dbo.r_prods fmd where Notes in ('Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле 0,75*6','Вино Zonin. Піно Гріджио Фріулі Акілея 2015 біле  0,75*6')

--потеряные корректировки
SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price, TAB1_A013 SumCC,  2 TypeDoc 
,(SELECT TAB1_A13 ProdName FROM ElitDistr.dbo.at_t_Medoc m where m.N11 = mr.N2 and m.N2_11 = mr.N2_11 and m.TAB1_A1 = mr.TAB1_A01 ) 
FROM ElitDistr.dbo.at_t_Medoc_RET mr
WHERE 
not EXISTS (SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc FROM ElitDistr.dbo.at_t_Medoc m
					where m.N11 = mr.N2 and m.N2_11 = mr.N2_11 and m.TAB1_A1 = mr.TAB1_A01 and m.TAB1_A13 = mr.TAB1_A3)

--AND mr.N2 = '2017-04-28 00:00:00.000' and mr.N2_11 = 10360
and 
TAB1_A3 in ('Коньяк Агмарті 3 роки 40% 0,5*12','Коньяк Агмарті 3 роки 40%  0,5*12')

--ORDER BY 10,4,3,cast(TAB1_A01 as int)
ORDER BY 4,3,cast(TAB1_A01 as int)

----РН
--SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc
--FROM ElitDistr.dbo.at_t_Medoc m where m.N11 = '2017-05-11 00:00:00.000' and m.N2_11 = 2832
--ORDER BY 2,cast(TAB1_A1 as int)
----кор
--SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price, TAB1_A013 SumCC,  2 TypeDoc 
--FROM ElitDistr.dbo.at_t_Medoc_RET mr where mr.N2 = '2017-05-11 00:00:00.000' and mr.N2_11 = 2832
--ORDER BY 2,cast(TAB1_A01 as int)



--РН
SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc
FROM ElitDistr.dbo.at_t_Medoc m where m.N11 = '2018-04-24 00:00:00' and m.N2_11 = 7619

ORDER BY cast(TAB1_A1 as int)
--кор
SELECT N15 date_kor,N1_11 n_kor ,TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price, TAB1_A013 SumCC,  2 TypeDoc 
FROM ElitDistr.dbo.at_t_Medoc_RET mr where mr.N2 = '2018-04-24 00:00:00' and mr.N2_11 = 7619
ORDER BY cast(TAB1_A01 as int)



*/