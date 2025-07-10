--J1201008
IF OBJECT_ID (N'tempdb..#Medoc', N'U') IS NOT NULL DROP TABLE #Medoc

SELECT --top 1
FIRM_EDRPOU
,'''' + CONVERT( varchar, N11, 4) N11
,N2_11
,EDR_POK
,(SELECT top 1 CompID FROM Elit.dbo.t_Inv i WHERE i.TaxDocDate = ex.N11 and i.TaxDocID = ex.N2_11) CompID
,TAB1_A1
,TAB1_A13
,(SELECT top 1 p1.ProdID FROM Elit.dbo.r_Prods p1 where p1.Notes = ex.[TAB1_A13]) ProdID
,TAB1_A14
,TAB1_A131
,(SELECT top 1 case p1.ImpID when 1 then 'Импортированный товар' else 'Товар' end FROM Elit.dbo.r_Prods p1 where p1.Notes = ex.[TAB1_A13]) TAB1_A132 --ImpID
,(SELECT top 1 p1.PCatID FROM Elit.dbo.r_Prods p1 where p1.Notes = ex.[TAB1_A13]) PCatID --код категории
,(SELECT top 1 p1.PBGrID FROM Elit.dbo.r_Prods p1 where p1.Notes = ex.[TAB1_A13]) PBGrID --код Бух. группы ТМЦ
,TAB1_A15
,TAB1_A16
,TAB1_A8
,TAB1_A10
--,* 
 INTO #Medoc	
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\1C-Medoc\excel\Январь 2017.xlsx' , 'select * from [Лист1$]') as ex;

SELECT *
-- INTO tmp_Medoc1C
FROM #Medoc
ORDER BY 2,3,CAST(TAB1_A1 as int)

--SELECT * FROM #Medoc where ProdID is null
INSERT tmp_Medoc1C
SELECT * FROM #Medoc

SELECT * FROM tmp_Medoc1C