use elit_test
GO

IF OBJECT_ID('ELIT_test..TestTable', 'U') IS NOT NULL DROP TABLE TestTable
IF OBJECT_ID('ELIT_test..TestTableDop', 'U') IS NOT NULL DROP TABLE TestTableDop
--Merge
--https://info-comp.ru/obucheniest/561-merge-in-t-sql.html
--MERGE – операция в языке T-SQL, при которой происходит обновление, вставка или удаление данных в таблице на основе результатов соединения с данными другой таблицы или SQL запроса. Другими словами, с помощью MERGE можно осуществить слияние двух таблиц, т.е. синхронизировать их.

--Целевая таблица
  CREATE TABLE dbo.TestTable(
        ProductId INT NOT NULL,
        ProductName VARCHAR(50) NULL,
        Summa MONEY NULL,
  CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (ProductId ASC)
  )
  GO

  --Таблица источник
  CREATE TABLE dbo.TestTableDop(
        ProductId INT NOT NULL,
        ProductName VARCHAR(50) NULL,
        Summa MONEY NULL,
  CONSTRAINT PK_TestTableDop PRIMARY KEY CLUSTERED (ProductId ASC)
  )
  GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Добавляем данные в основную таблицу
        INSERT INTO dbo.TestTable
                           (ProductId,ProductName,Summa)
                 VALUES
                           (1, 'Компьютер', 0)
        GO
        INSERT INTO dbo.TestTable
                           (ProductId,ProductName,Summa)
                 VALUES
                           (2, 'Принтер', 0)
        GO
        INSERT INTO dbo.TestTable
                           (ProductId,ProductName,Summa)
                 VALUES
        (3, 'Монитор', 0)
        GO
        --Добавляем данные в таблицу источника
        INSERT INTO dbo.TestTableDop
                           (ProductId,ProductName,Summa)
                 VALUES
                           (1, 'Компьютер', 500)
        GO
        INSERT INTO dbo.TestTableDop
                           (ProductId,ProductName,Summa)
                 VALUES
                           (2, 'Принтер', 300)
        GO
        INSERT INTO dbo.TestTableDop
                           (ProductId,ProductName,Summa)
                 VALUES
                           (4, 'Монитор', 400)
        GO

SELECT * FROM dbo.TestTable --target table.

SELECT * FROM dbo.TestTableDop --source table.

MERGE TestTable t --целевая таблица (target table).
USING TestTableDop s --таблица источник (source table).
ON t.ProductID = s.ProductID
WHEN MATCHED THEN
    UPDATE SET t.ProductName = s.ProductName, t.Summa = s.Summa
WHEN NOT MATCHED THEN
    INSERT ([ProductId], [ProductName], [Summa])
    VALUES (s.[ProductId], s.[ProductName], s.[Summa])
OUTPUT 
    $action AS [Операция], 
    Inserted.ProductID, 
    Inserted.ProductName 'Product Name NEW', 
    Inserted.Summa 'Summa NEW', 
    Deleted.ProductName 'Product Name OLD',
    Deleted.Summa 'Summa OLD'
;

SELECT '' 'TARGET TABLE', * FROM dbo.TestTable
SELECT '' 'SOURCE TABLE', * FROM dbo.TestTableDop

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --Удаление строки с ProductId = 4 
--для того чтобы отработало условие WHEN NOT MATCHED
DELETE dbo.TestTable WHERE ProductId = 4
--Запрос MERGE для синхронизации таблиц
MERGE dbo.TestTable AS T_Base --Целевая таблица
--Запрос в качестве источника
USING (SELECT ProductId, ProductName, Summa 
            FROM dbo.TestTableDop) AS T_Source (ProductId, ProductName, Summa) 
ON (T_Base.ProductId = T_Source.ProductId) --Условие объединения
WHEN MATCHED THEN --Если истина (UPDATE)
            UPDATE SET ProductName = T_Source.ProductName, Summa = T_Source.Summa
WHEN NOT MATCHED THEN --Если НЕ истина (INSERT)
            INSERT (ProductId, ProductName, Summa)
            VALUES (T_Source.ProductId, T_Source.ProductName, T_Source.Summa)
    --Удаляем строки, если их нет в TestTableDOP
WHEN NOT MATCHED BY SOURCE THEN
            DELETE  
--Посмотрим, что мы сделали
OUTPUT $action AS [Операция], Inserted.ProductId, Inserted.ProductName AS ProductNameNEW,
            Inserted.Summa AS SummaNEW,Deleted.ProductName AS ProductNameOLD, 
            Deleted.Summa AS SummaOLD; --Не забываем про точку с запятой
--Итоговый результат
SELECT * FROM dbo.TestTable
SELECT * FROM dbo.TestTableDop 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Очищаем поле сумма у одной строки в TestTableDop
        UPDATE dbo. TestTableDop SET Summa = NULL 
        WHERE ProductId = 2
        --Запрос MERGE 
        MERGE dbo.TestTable AS T_Base --Целевая таблица
        USING dbo.TestTableDop AS T_Source --Таблица источник
        ON (T_Base.ProductId = T_Source.ProductId) --Условие объединения
        --Если истина + доп. условие отработало (UPDATE)
        WHEN MATCHED AND T_Source.Summa IS NOT NULL THEN
                 UPDATE SET ProductName = T_Source.ProductName, Summa = T_Source.Summa
        WHEN NOT MATCHED THEN --Если НЕ истина (INSERT)
                 INSERT (ProductId, ProductName, Summa)
                 VALUES (T_Source.ProductId, T_Source.ProductName, T_Source.Summa)
        --Посмотрим, что мы сделали
        OUTPUT $action AS [Операция], Inserted.ProductId,
                   Inserted.ProductName AS ProductNameNEW, 
                   Inserted.Summa AS SummaNEW, 
                   Deleted.ProductName AS ProductNameOLD, 
                   Deleted.Summa AS SummaOLD; --Не забываем про точку с запятой
        --Итоговый результат
        SELECT * FROM dbo.TestTable
        SELECT * FROM dbo.TestTableDop

        select floor(798.77)
        @@ROWCOUNT

        SELECT CONCAT(1, 3)

        SELECT summa, 
        CONCAT('Сумма: ',  (summa AS VARCHAR(50))) AS line_summa
FROM orders;

SELECT NumberRow
FROM (VALUES(1),(2),(3),(4),(5)) AS list (NumberRow); 


SELECT NumberRow
FROM (VALUES(1),(2),(3),(4),(5)) AS list (RowNumber); 


SELECT month,
       order_summa, 
        (order_summa) OVER (PARTITION BY  ) AS result 
FROM orders;

SELECT DISTINCT * FROM (VALUES (1), (1), (1), (2), (5), (1), (6)) AS X(a)
select * from (values(GETDATE())) as arbasba(b)