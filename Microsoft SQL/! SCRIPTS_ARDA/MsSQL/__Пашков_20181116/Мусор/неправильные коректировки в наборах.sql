SELECT * FROM (
SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc
FROM ElitDistr.dbo.at_t_Medoc 
	UNION ALL
SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price, TAB1_A013 SumCC,  2 TypeDoc
FROM ElitDistr.dbo.at_t_Medoc_RET 
) s1
--where NNN = 7364 and DNN = '2017-06-23 00:00:00' 
--where NNN = 8248 and DNN = '2017-04-24 00:00:00' 
where NNN = 6885 and DNN = '2018-09-21 00:00:00' 
--and ProdName like 'Коньяк Агмарті%' --'Коньяк Агмарті 3 роки 40%  0,5*12'	
ORDER BY TypeDoc, cast(pos as int) 


SELECT * 
,(SELECT top 1 ProdID FROM ElitDistr.dbo.r_Prods p where p.Notes = rn.ProdName) ProdID
,(SELECT ProdID FROM ElitDistr.dbo.r_Prods p where p.Notes = kor.ProdName) ProdID_ret
,len(kor.ProdName), len(rn.ProdName)
FROM (
SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc
FROM ElitDistr.dbo.at_t_Medoc ) rn
join (SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price, TAB1_A013 SumCC,  2 TypeDoc, N1_11, N15
FROM ElitDistr.dbo.at_t_Medoc_RET ) kor on kor.DNN = rn.DNN and kor.NNN = rn.NNN and kor.pos = rn.pos
where kor.ProdName != rn.ProdName
ORDER BY rn.DNN,rn.NNN,rn.pos
--ORDER BY 2


SELECT distinct 'union all select '+cast(rn.NNN as varchar(21))+','''+CONVERT( varchar, rn.DNN, 120)+''',null,null' FROM (
SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price ,  TAB1_A10 SumCC, 1 TypeDoc
FROM ElitDistr.dbo.at_t_Medoc ) rn
join (SELECT TAB1_A01 Pos,TAB1_A3 ProdName, N2_11 NNN,N2 DNN,TAB1_A4 UM ,TAB1_A5 Qty,TAB1_A6 Price, TAB1_A013 SumCC,  2 TypeDoc
FROM ElitDistr.dbo.at_t_Medoc_RET ) kor on kor.DNN = rn.DNN and kor.NNN = rn.NNN and kor.pos = rn.pos
where kor.ProdName != rn.ProdName
ORDER BY 1


SELECT Notes FROM ElitDistr.dbo.r_Prods where


--загружаем справочник по наборам
	IF OBJECT_ID (N'tempdb..#ProdIdNabor', N'U') IS NOT NULL DROP TABLE #ProdIdNabor
	CREATE TABLE #ProdIdNabor(ProdIDMA int null, ProdID int null, ProdIdNabor int null, ProdName varchar(250))
	INSERT #ProdIdNabor
		SELECT distinct * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\ElitDistr\Справочник_наборов.xlsx' , 'select * from [Лист1$]') as ex;
	--SELECT ProdID FROM #ProdIdNabor

--8248	2017-04-24 00:00:00.000
--5257	2017-05-17 00:00:00.000
--5763	2017-05-18 00:00:00.000
--7706	2017-05-24 00:00:00.000
--8955	2017-05-26 00:00:00.000
--831	2017-06-02 00:00:00.000
--1396	2017-06-06 00:00:00.000
--5651	2017-06-19 00:00:00.000
--808	2017-07-04 00:00:00.000
--3063	2017-07-11 00:00:00.000
--7092	2017-07-21 00:00:00.000
--9516	2017-08-29 00:00:00.000
--4653	2017-10-13 00:00:00.000
--1294	2017-11-03 00:00:00.000
--7081	2017-11-21 00:00:00.000
--9530	2017-11-28 00:00:00.000
--4151	2018-02-13 00:00:00.000
