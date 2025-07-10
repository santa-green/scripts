EXECUTE AS LOGIN = 'rkv0' -- дл€ запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'...)
	GO
IF OBJECT_ID ('tempdb..#edi_docs', 'U') IS NOT NULL DROP TABLE #edi_docs;

SELECT * INTO #edi_docs FROM 
OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Temp\edi2revenue.xlsx', 'select * from [1$]')

REVERT
GO
--select SYSTEM_USER

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*— –»ѕ“*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--блок объ€влени€ переменных
DECLARE @month tinyint = 3
DECLARE @year smallint = 2020
DECLARE @ourID tinyint = 1
DECLARE @docs_price_per_unit smallint = 3.896
DECLARE @netname nvarchar(max)
DECLARE @docs_qty int

--создаем временные таблицы: #edi2revenue - итогова€ сравнительна€ таблица, #edi_docs - промежуточна€ таблица (экспорт из Excel..).
--#edi2revenue
IF OBJECT_ID('tempdb..#edi2revenue', 'U') IS NOT NULL DROP TABLE #edi2revenue
CREATE TABLE #edi2revenue (
    Network_name nvarchar(max),
    Docs_qty int,
    [EDI_docs_expenses, UAH] int,
    [Total_network_revenue, UAH] int
)
--#edi_docs
--см. выше в начале скрипта.

--курсор-https://www.sqlservertutorial.net/sql-server-stored-procedures/sql-server-cursor/
DECLARE EDI2REVENUE CURSOR FOR
SELECT * FROM #edi_docs
OPEN EDI2REVENUE
FETCH NEXT FROM EDI2REVENUE INTO @netname, @docs_qty
WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO #edi2revenue (Network_name, Docs_qty, [EDI_docs_expenses, UAH], [Total_network_revenue, UAH]) VALUES (@netname, @docs_qty, @docs_qty * @docs_price_per_unit, 
            --считаем Total_network_revenue, UAH
            (--считаем все –ј—’ќƒЌџ≈ по данной сети
            SELECT SUM(total) 'Total network revenue, UAH' FROM 
            (

                SELECT ISNULL(SUM(TSumCC_wt),0) 'total' FROM t_Inv WHERE month(DocDate) = @month AND year(docdate) = @year AND OurID = @ourID AND CompID IN 
                (
                --берем все compid по сети
                SELECT DISTINCT ZEC_KOD_KLN_OT FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_ADD in 
                (
                --берем все GLN из таблицы at_GLN по данной сети
                SELECT GLN FROM at_GLN WHERE RetailersName = @netname
                )
                )
                UNION ALL
                --считаем (отминусовываем) все ¬ќ«¬–ј“Ќџ≈ по данной сети
                SELECT ISNULL(-SUM(TSumCC_wt),0) 'total' FROM t_Ret WHERE month(DocDate) = @month AND year(docdate) = @year AND OurID = @ourID AND CompID IN 
                (
                --берем все compid по сети
                SELECT DISTINCT ZEC_KOD_KLN_OT FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_ADD in 
                (
                --берем все GLN из таблицы at_GLN по данной сети
                SELECT GLN FROM at_GLN WHERE RetailersName = @netname
                )
                )

            ) AS m)
                    )
        FETCH NEXT FROM EDI2REVENUE INTO @netname, @docs_qty
    END;
CLOSE EDI2REVENUE
DEALLOCATE EDI2REVENUE

SELECT * FROM #edi2revenue


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*вспомогательные материалы...*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
SELECT CompID, SUM(TSumCC_wt) FROM t_Inv WHERE month(DocDate) = 3 AND year(docdate) = 2020 AND OurID = 1 GROUP BY compid ORDER BY 1
SELECT SUM(TSumCC_wt) FROM t_Inv WHERE month(DocDate) = 3 AND year(docdate) = 2020 AND OurID = 1 AND CompID = 7065 
SELECT * FROM t_Inv WHERE month(DocDate) = 3 AND year(docdate) = 2020

--SELECT SUM(TSumCC_wt) FROM t_Inv WHERE year(docdate) = 2020  
--SELECT year(docdate), TSumCC_wt, * FROM t_Inv WHERE year(docdate) = 2020 ORDER BY docdate DESC

DECLARE @month tinyint = 3 --выбираем є мес€ца
DECLARE @year smallint = 2020 --выбираем є мес€ца

SELECT m.CompID, d.CompName, CAST(SUM(m.TSumCC_wt) as int) '—умма с Ќƒ—, грн' 
FROM t_Inv m
JOIN r_Comps d ON m.CompID = d.CompID
WHERE month(m.DocDate) = @month AND year(m.docdate) = 2020 --AND d.CompGrID2 = 2098
GROUP BY m.CompID, d.CompName
ORDER BY CAST(SUM(m.TSumCC_wt) as int) DESC

SELECT compid, * FROM t_Inv WHERE CompID = 7060 ORDER BY DocDate DESC
SELECT * FROM r_Comps WHERE CompID = 7060

SELECT * FROM at_GLN WHERE RetailersName = 'Ћьв≥вхолод' ORDER BY GLN DESC
    
--SELECT * FROM at_GLN WHERE GLNName like '%Ћьв≥вхолод%' ORDER BY GLN DESC
SELECT * FROM r_Comps WHERE CompID = 7060
SELECT * FROM at_GLN WHERE gln = '4820038509988'
SELECT * FROM at_GLN WHERE gln = '4820038509629'
*/