USE ElitR
GO

--https://info-comp.ru/obucheniest/441-ranking-functions-in-transact-sql.html
SELECT 
    ROW_NUMBER() over (order by Notes) '---row',
    ROW_NUMBER() over (PARTITION BY Notes order by Notes) '---row---PARTITION',
    rank() over (order by Notes) '---rank',
    dense_rank() over (order by Notes) '---dense_rank',
    NTILE(6) over (order by Notes) '---ntile',
    Notes
FROM iv_ComplexMenuA