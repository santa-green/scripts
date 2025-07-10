--загрузка справочников
BEGIN
  
--загружаем справочник по наборам
IF OBJECT_ID (N'tempdb..#Medoc', N'U') IS NOT NULL DROP TABLE #Medoc
--CREATE TABLE #Medoc(ProdIDMA int null, ProdID int null, ProdIdNabor int null, ProdName varchar(250))
--INSERT #Medoc
SELECT * 
INTO #Medoc	
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок.xlsx' , 'select * from [Лист1$]') as ex;

--SELECT * FROM #Medoc


--загружаем справочник во по наборам
IF OBJECT_ID (N'tempdb..#Medoc_RET', N'U') IS NOT NULL DROP TABLE #Medoc_RET
SELECT * 
 INTO #Medoc_RET	
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_Возвраты.xlsx' , 'select * from [Лист1$]') as ex;

--SELECT * FROM #Medoc_RET

END



SELECT Notes FROM r_Prods where ProdID = 30726

SELECT TAB1_A13, N2_11, N11, TAB1_A14, TAB1_A15, TAB1_A1, TAB1_A10, TAB1_A131
,[TAB1_A13],N2_11,N11,TAB1_A14,TAB1_A15,TAB1_51, TAB1_A1, TAB1_A10, TAB1_A11, TAB1_A110, TAB1_A111, TAB1_A12, TAB1_A13, TAB1_A131, TAB1_A132, TAB1_A133, TAB1_A14, TAB1_A141, TAB1_A15, TAB1_A16, TAB1_A17, TAB1_A171, TAB1_A18, TAB1_A19, TAB1_A8, TAB1_A9, TAB1_RATE
,A110, A111, A17, A18, A19, A2_10, A2_11, A2_4, A2_5, A2_6, A2_7, A2_8, A2_9, A3_11, A4_10, A4_101, A4_11, A4_111, A4_4, A4_41, A4_5, A4_51, A4_6, A4_61, A4_7, A4_71, A4_8, A4_81, A4_9, A4_91, A5_10, A5_11, A5_7, A5_71, A5_8, A5_9, A6_10, A6_11, A6_7, A6_71, A6_8, A6_9, A7_10, A7_11, A7_7, A7_71, A7_8, A7_9, CHECKCONTR, CHECKRVS, DEPT_POK, DPA_REG_TIME, EDR_POK, FIRM_ADR, FIRM_CITYCD, FIRM_EDRPOU, FIRM_INN, FIRM_NAME, FIRM_PHON, FIRM_SRPNDS, FIRM_TELORG, INN, N1, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N2, N20, N21, N22, N23, N24, N25, N26, N2_1, N2_11, N2_12, N2_13, N2_1I, N3, N4, N5, N6, N7, N8, N81, N811, N812, N82, N9, NAKL_TYPE, PHON, PKRED, PZOB, REP_KS, RSTCODE, RSTTYPE, SEND_DPA, SEND_DPA_DATE, SEND_DPA_RN, SEND_PERSON, SEND_PERSON_DATE, SERVICEPRESENCE, SMKOR_N1, SN, STYPE, UKTPRESENCE, VER, Z1_5, Z1_6, Z2_5, Z2_6, Z3_5, Z4_5, Z5_5, Z5_6, Z6_5, Z6_6, Z7_5, Z7_6, ZT, TAB1_51, TAB1_A1, TAB1_A10, TAB1_A11, TAB1_A110, TAB1_A111, TAB1_A12, TAB1_A13, TAB1_A131, TAB1_A132, TAB1_A133, TAB1_A14, TAB1_A141, TAB1_A15, TAB1_A16, TAB1_A17, TAB1_A171, TAB1_A18, TAB1_A19, TAB1_A8, TAB1_A9, TAB1_RATE
FROM #Medoc where 
N2_11 = 1432
and N11 = '2017-06-06'--06.06.2017 0:00
and [TAB1_A13] = (SELECT Notes FROM r_Prods where ProdID = 32172)

SELECT TAB1_A3,N2_11,N2,TAB1_A4,TAB1_A5,TAB1_A01,TAB1_A013,TAB1_A31,TAB1_A2
--[TAB1_A13],N2,TAB1_A01,TAB1_A5,TAB1_A01, TAB1_A011, TAB1_A012, TAB1_A013, TAB1_A014, TAB1_A1, TAB1_A10, TAB1_A11, TAB1_A12, TAB1_A13, TAB1_A14, TAB1_A15, TAB1_A2, TAB1_A3, TAB1_A31, TAB1_A32, TAB1_A33, TAB1_A4, TAB1_A41, TAB1_A5, TAB1_A6, TAB1_A7, TAB1_A8, TAB1_A9, TAB1_A91, TAB1_RATE,
--* 
FROM #Medoc_RET 
where 
N2_11 = 379
and N2 = '2017-06-06'--06.06.2017 0:00
and TAB1_A3 = (SELECT Notes FROM r_Prods where ProdID = 32172)





SELECT *, TAB1_A15 + isnull([возвраты_общие],0) as [можно_вернуть] FROM (
SELECT TAB1_A13, N2_11, N11, TAB1_A14, TAB1_A15, TAB1_A1, TAB1_A10, TAB1_A131

,(SELECT SUM( TAB1_A5)
FROM #Medoc_RET r
where 
N2_11 = m.N2_11
and N2 = m.N11
and TAB1_A3 = m.TAB1_A13
group by TAB1_A3) возвраты_общие

FROM #Medoc m where 
N2_11 = 3614
and N11 = '2017-04-11' --11.04.2017
AND [TAB1_A13] = (SELECT Notes FROM r_Prods where ProdID = 3499)
) s1

ORDER BY cast(s1.TAB1_A1 as int)



/*
SELECT TAB1_A3,SUM( TAB1_A5)
FROM #Medoc_RET 
where 
N2_11 = 9203
and N2 = '2017-08-29'
--and TAB1_A3 = 'Вино Verdegar. Вінья Верде Ескола біле 0,75*6'
group by TAB1_A3
*/

SELECT SUM(medr.TAB1_A5)*-1 FROM #Medoc_RET medr 
where medr.N2_11 = 3614
and medr.N2 = '2017-04-11'
and medr.TAB1_A3 = (SELECT Notes FROM r_Prods  p where p.ProdID = 3499)
group by medr.TAB1_A3



SELECT TAB1_A13, N2_11, N11, TAB1_A14, TAB1_A15, TAB1_A1, TAB1_A10, TAB1_A131
FROM #Medoc where 
[TAB1_A13] = (SELECT Notes FROM r_Prods where ProdID = 3499)
and N2_11 = 3614
and N11 = '2017-04-11'


SELECT TAB1_A3,N2_11,N2,TAB1_A4,TAB1_A5,TAB1_A01,TAB1_A013,TAB1_A31,TAB1_A2
FROM #Medoc_RET 
where 
N2_11 = 3614
and N2 =  '2017-04-11'
and TAB1_A3 = (SELECT Notes FROM r_Prods where ProdID = 3499)

--##############################################################################
--##############################################################################
--проект синхронизация позиций в возратах медок и базы
SELECT TAB1_A1 TAB1_A1_Поз,TAB1_A13, TAB1_A131, N2_11, N11, TAB1_A14, TAB1_A15 TAB1_A15_Кол,  TAB1_A10
FROM #Medoc where 
[TAB1_A13] = (SELECT Notes FROM r_Prods where ProdID = 3499)
and N2_11 = 3929
and N11 = '2018-03-13 00:00:00.000'
ORDER BY N11,N2_11, cast(TAB1_A1 as int)


SELECT 
--(SELECT top 1 ProdID FROM r_Prods where Notes = TAB1_A3) ProdID,
TAB1_A01,TAB1_A3,TAB1_A31,N2_11,N2,TAB1_A4,TAB1_A5 TAB1_A5_Кол,TAB1_A013,TAB1_A2,TAB1_A1
FROM #Medoc_RET 
where 1=1
and TAB1_A3 = (SELECT Notes FROM r_Prods where ProdID = 3499) 
and N2_11 = 8248
and N2 =  '2017-04-24 00:00:00.000'
ORDER BY TAB1_A1,N2,N2_11, cast(TAB1_A01 as int) 


SELECT TAB1_A1 TAB1_A1_Поз,TAB1_A13, TAB1_A131, N2_11, N11, TAB1_A14, TAB1_A15 TAB1_A15_Кол,  TAB1_A10
FROM #Medoc where 1=1
and [TAB1_A13] = (SELECT Notes FROM r_Prods where ProdID = 3499)
and N2_11 = 3929
and N11 = '2018-03-13 00:00:00.000'
ORDER BY N11,N2_11, cast(TAB1_A1 as int)



SELECT top 1 ProdID FROM r_Prods where Notes like 'Вино Michele Satta. Мішель Сатта Больгері Розато 2012 рожеве сухе 0,75*6'
SELECT * FROM r_Prods where Notes like '%Redmi%' ORDER BY Notes

SELECT 
(SELECT top 1 ProdID FROM r_Prods where Notes = TAB1_A3) ProdID 
,TAB1_A3
FROM #Medoc_RET 
where (SELECT top 1 ProdID FROM r_Prods where Notes = TAB1_A3) is null
group BY TAB1_A3

SELECT 
(SELECT top 1 ProdID FROM r_Prods where Notes = TAB1_A13) ProdID 
,TAB1_A13
FROM #Medoc 
where (SELECT top 1 ProdID FROM r_Prods where Notes = TAB1_A13) is null
group BY TAB1_A13

SELECT SUM(medr.TAB1_A5)*-1 FROM #Medoc_RET medr 
where medr.N2_11 = 3614
and medr.N2 = '2017-04-11'
and medr.TAB1_A3 = (SELECT Notes FROM r_Prods  p where p.ProdID = 3499)
group by medr.TAB1_A3

SELECT mr.SrcTaxDocID, dr.* FROM t_Ret mr
JOIN t_RetD dr ON dr.ChID = mr.ChID
WHERE mr.OurID = 1
and mr.DocDate = '2018-04-01'
ORDER BY  dr.ProdID


SELECT SrcTaxDocDate, SrcTaxDocID
--суммарный возврат из медка по налоговой накладной
,(SELECT SUM(medr.TAB1_A5)*-1 FROM #Medoc_RET medr 
where medr.N2_11 = mr.SrcTaxDocID 
and medr.N2 = mr.SrcTaxDocDate
and medr.TAB1_A3 = (SELECT Notes FROM ElitDistr.dbo.r_Prods  p where p.ProdID = dr.ProdID)
group by medr.TAB1_A3) as vozv_Medoc  

--суммарное кол по налоговой накладной
,(SELECT SUM(eid.Qty) FROM Elit.dbo.t_InvD eid where eid.ChID = mr.ChID and eid.ProdID = dr.ProdID) as sumQtyInv

,* 
FROM t_Ret mr
JOIN t_RetD dr ON dr.ChID = mr.ChID
WHERE mr.OurID = 1
and mr.DocDate = '2018-04-01'
ORDER BY  1,2





SELECT * FROM (
	SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
	FROM #Medoc WHERE TAB1_A13 = (SELECT Notes FROM r_Prods where ProdID = 3499) and N2_11 = 3929 and N11 = '2018-03-13 00:00:00.000'
UNION ALL
	SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
	FROM #Medoc_RET WHERE TAB1_A3 = (SELECT Notes FROM r_Prods where ProdID = 3499) and N2_11 = 3929 and N2 =  '2018-03-13 00:00:00.000'
) un ORDER BY Pos, TypeDoc


SELECT * FROM (
	SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
	FROM #Medoc WHERE  N2_11 = 3929 and N11 = '2018-03-13 00:00:00.000'
UNION ALL
	SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
	FROM #Medoc_RET WHERE N2_11 = 3929 and N2 =  '2018-03-13 00:00:00.000'
) un ORDER BY Pos, TypeDoc


DECLARE  @ProdIDMA INT = 600712
--(SELECT distinct ec.ProdID FROM elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA))
--(SELECT Notes FROM r_Prods where ProdID in (SELECT distinct ec.ProdID FROM elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA)))

SELECT @ProdIDMA ProdIDMA, (SELECT top 1 p1.ProdID FROM elit.dbo.r_Prods p1 where p1.Notes = un.ProdName) ProdID_Elit, 
DNN,NNN, ProdName,UM,Pos , SUM(Qty) TQty, MAX(Price) Price, SUM(Qty) * MAX(Price) SumCC FROM (
	SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC, 1 TypeDoc
	FROM #Medoc WHERE TAB1_A13 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA))) 
UNION ALL
	SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price,TAB1_A013 SumCC,  2 TypeDoc
	FROM #Medoc_RET WHERE TAB1_A3 in (SELECT p.Notes FROM elit.dbo.r_Prods p where p.ProdID in (SELECT distinct ec.ProdID FROM elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (@ProdIDMA)))
) un 
group by DNN,NNN, ProdName,UM,Pos 
having SUM(Qty) > 0 
--ORDER BY DNN,NNN,Pos
ORDER BY Price,TQty desc


SELECT TAB1_A1 TAB1_A1_Поз,TAB1_A13, TAB1_A131, N2_11, N11, TAB1_A14, TAB1_A15 TAB1_A15_Кол, TAB1_A16, TAB1_A10
FROM #Medoc where 
[TAB1_A13] = (SELECT Notes FROM r_Prods where ProdID = 3499)
and N2_11 = 5221
and N11 = '2017-11-15 00:00:00.000'
ORDER BY N11,N2_11, cast(TAB1_A1 as int)

SELECT 
--(SELECT top 1 ProdID FROM r_Prods where Notes = TAB1_A3) ProdID,
TAB1_A01,TAB1_A3,TAB1_A31,N2_11,N2,TAB1_A4,TAB1_A5 TAB1_A5_Кол,TAB1_A6,TAB1_A013,TAB1_A2,TAB1_A1
FROM #Medoc_RET 
where 1=1
and TAB1_A3 = (SELECT Notes FROM r_Prods where ProdID = 3499) 
and N2_11 = 5221
and N2 =  '2017-11-15 00:00:00.000'
ORDER BY TAB1_A1,N2,N2_11, cast(TAB1_A01 as int) 


SELECT distinct TAB1_A13 FROM ElitDistr.dbo.at_t_Medoc
SELECT distinct TAB1_A3 FROM ElitDistr.dbo.at_t_Medoc_RET ORDER BY 1
SELECT * FROM ElitDistr.dbo.at_t_Medoc_RET where TAB1_A3 is null

SELECT ProdID, Notes, TAB1_A3 FROM ElitDistr.dbo.r_Prods r
right join (SELECT distinct TAB1_A3 FROM ElitDistr.dbo.at_t_Medoc_RET where TAB1_A3 is not null) med on med.TAB1_A3 = r.Notes
where Notes is null or  TAB1_A3 is null

SELECT ProdID, Notes, TAB1_A13 FROM ElitDistr.dbo.r_Prods r
right join (SELECT distinct TAB1_A13 FROM ElitDistr.dbo.at_t_Medoc where TAB1_A13 is not null) med on med.TAB1_A13 = r.Notes
where Notes is null or  TAB1_A13 is null




SELECT DIFFERENCE('Ликер Шариз 0,7*6','Ликер Шариc 0,7*6&Ч')
SELECT DIFFERENCE('Ликер Шариз 0,7*6','trt')
SELECT * FROM ElitDistr.dbo.r_Prods where Notes like '%Кава зелена Арабіка%'

SELECT DIFFERENCE('Ликер Шариз 0,7*6',Notes),ProdID,Notes FROM ElitDistr.dbo.r_Prods 
SELECT SOUNDEX(Notes) ,ProdID,Notes FROM ElitDistr.dbo.r_Prods ORDER BY 1
SELECT SOUNDEX(ProdName) ,ProdID,ProdName FROM ElitDistr.dbo.r_Prods ORDER BY 1

DECLARE @SearchWord nvarchar(30)
SET @SearchWord = N'Ликер Шариз 0,7*6'
SELECT Notes 
FROM ElitDistr.dbo.r_Prods
WHERE CONTAINS(ProdName, @SearchWord);
 
 
 
SELECT * FROM at_t_Medoc ORDER BY cast(SEND_DPA_RN as bigint)
SELECT * FROM at_t_Medoc_RET ORDER BY cast(SEND_DPA_RN as bigint)
 
SELECT * FROM at_t_Medoc     where SEND_DPA_RN <> '' 
SELECT * FROM #Medoc     where SEND_DPA_RN <> '' 

--Удалить не зарегестрированные РН
DELETE at_t_Medoc WHERE SEND_DPA_RN = '' OR SEND_DPA_RN IS NULL
--Добавить новые и зарегестрированные РН
INSERT at_t_Medoc
	SELECT * FROM #Medoc WHERE SEND_DPA_RN <> '' and SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM at_t_Medoc) 

--Удалить не зарегестрированные корректировки к РН
DELETE at_t_Medoc_RET WHERE SEND_DPA_RN = '' OR SEND_DPA_RN IS NULL
--Добавить новые и не зарегестрированные корректировки к РН
INSERT at_t_Medoc_RET
	SELECT * FROM #Medoc_RET WHERE SEND_DPA_RN not in (SELECT SEND_DPA_RN FROM at_t_Medoc_RET) 


SELECT * FROM at_t_Medoc_RET where SEND_DPA_RN <> '' 
SELECT * FROM #Medoc_RET



	--догружаем справочник с медка реестр налоговых накладных
	IF OBJECT_ID (N'tempdb..#Medoc', N'U') IS NOT NULL DROP TABLE #Medoc
	SELECT * 
	 INTO #Medoc	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_дозаливка_J1201009.xlsx' , 'select * from [Лист1$]') as ex;
	SELECT * FROM #Medoc
	
	--догружаем справочник с медка по возвратам
	IF OBJECT_ID (N'tempdb..#Medoc_RET', N'U') IS NOT NULL DROP TABLE #Medoc_RET
	SELECT * 
	 INTO #Medoc_RET	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_Возвраты_дозаливка_J1201209.xlsx' , 'select * from [Лист1$]') as ex;
    SELECT * FROM #Medoc_RET


 
 --	--догружаем справочник с медка реестр налоговых накладных
	--IF OBJECT_ID (N'ElitDistr.dbo.at_t_Medoc', N'U') IS NOT NULL DROP TABLE ElitDistr.dbo.at_t_Medoc
	--SELECT * 
	-- --INTO at_t_Medoc	
	--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_дозаливка_J1201009.xlsx' , 'select * from [Лист1$]') as ex;
	----SELECT * FROM ElitDistr.dbo.at_t_Medoc
	
	----догружаем справочник с медка по возвратам
	--IF OBJECT_ID (N'ElitDistr.dbo.at_t_Medoc_RET', N'U') IS NOT NULL DROP TABLE ElitDistr.dbo.at_t_Medoc_RET
	--SELECT * 
	-- --INTO at_t_Medoc_RET	
	--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Реестр_Медок_Возвраты_дозаливка_J1201209.xlsx' , 'select * from [Лист1$]') as ex;
	
	
