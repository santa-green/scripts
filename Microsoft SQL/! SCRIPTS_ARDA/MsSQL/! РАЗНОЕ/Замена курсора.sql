--¬ременна€ таблица дл€ цикла.
DECLARE @ForWhile TABLE (PosID INT, ChID INT)
INSERT INTO @ForWhile VALUES (1, 1111), (2, 2222), (3, 3333); SELECT * FROM @ForWhile
DECLARE @c INT


--¬ыбираем минимальную позицию из таблицу. Ёто будет первой итерацией.
SET @c = (SELECT MIN(PosID) FROM @ForWhile); SELECT @c

WHILE @c IS NOT NULL
BEGIN
       SELECT * FROM @ForWhile WHERE PosID = @c;
       --Next position.
       SET @c = (SELECT MIN(PosID) FROM @ForWhile WHERE PosID > @c);
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*--https://coderoad.ru/5521634/%D0%9A%D0%B0%D0%BA-%D1%8F-%D0%BC%D0%BE%D0%B3%D1%83-%D0%B7%D0%B0%D0%BC%D0%B5%D0%BD%D0%B8%D1%82%D1%8C-%D0%BA%D1%83%D1%80%D1%81%D0%BE%D1%80-%D0%B2-sql-server-2008*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--declare table variable 
declare @tblCustomersVar table
(
    CustomerID int,
    [Name] nvarchar(50),
    Surname nvarchar(50),
    DateOfBirth datetime,
    [Address] nvarchar(200),
    City nvarchar(50),
    County nvarchar(50),
    Country nvarchar(50),
    HomePhone nvarchar(20)
)

INSERT INTO @tblCustomersVar
SELECT CustomerID
,      [Name]
,      Surname
,      DateOfBirth
,      [Address]
,      City
,      County
,      Country
,      HomePhone
FROM OldCustomer

 --declare @counter variable
 declare @counter int
 declare @rowCount int
 set @counter = 1
 set @rowCount = (select COUNT(*) from @tblCustomersVar)

 while(@counter <= @rowCount)
  Begin
    --process here

  --increment
     set @counter = @counter + 1;
  End

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*--https://www.sqlshack.com/sql-while-loop-with-simple-examples*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE tempdb
GO
DROP TABLE IF EXISTS SampleTable
CREATE TABLE SampleTable
(Id INT, CountryName NVARCHAR(100), ReadStatus TINYINT)
GO
INSERT INTO SampleTable ( Id, CountryName, ReadStatus)
Values (1, 'Germany', 0),
        (2, 'France', 0),
        (3, 'Italy', 0),
    (4, 'Netherlands', 0) ,
       (5, 'Poland', 0)
 
 
 
  SELECT * FROM SampleTable
USE tempdb
GO
 
DECLARE @Counter INT , @MaxId INT, 
        @CountryName NVARCHAR(100)
SELECT @Counter = min(Id) , @MaxId = max(Id) 
FROM SampleTable
 
WHILE(@Counter IS NOT NULL
      AND @Counter <= @MaxId)
BEGIN
   SELECT @CountryName = CountryName
   FROM SampleTable WHERE Id = @Counter
    
   PRINT CONVERT(VARCHAR,@Counter) + '. country name is ' + @CountryName  
   SET @Counter  = @Counter  + 1        
END