/*CROSS APPLY and OUTER APPLY*/

SELECT * FROM dbo.ALEF_EDI_ORDERS_2 m
cross apply (
    SELECT * FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680117 
	and isnumeric(notes) = 1 and cast(notes as int) in (SELECT RefID FROM [S-SQL-D4].Elit.dbo.r_uni where  RefTypeID = 6680116 and notes = '1')  
	and cast(notes as int) <> 0
	and Notes in (SELECT TOP 1 RetailersID FROM [S-SQL-D4].Elit.dbo.at_gln p1 where p1.GLN = m.ZEO_ZEC_BASE) 
) g 

--if you have a table-valued expression on the right part and in some cases the use of the APPLY operator boosts performance of your query
--CROSS APPLY -> Inner join
--OUTER APPLY -> Left join
--Usage scope: table-valued function / inline SELECT statements.
--Вызов табличной функции для каждой строки.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*пример*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Например, как вывести по 3 города для каждой страны, отсортированных по алфавиту!? С помощью оператора APPLY это сделать достаточно легко:

select * from dbo.Countries c
cross apply ( select top 3 City from dbo.Cities 
                where CountryID = c.CountryID order by City 
            ) ap

SELECT rc.compid, CompShort, m.CompAdd, m.TerrID FROM r_Comps rc
cross apply (SELECT top(4) * from r_CompsAdd WHERE CompID = rc.CompID ORDER BY CompID DESC) m
WHERE rc.CompID in (7001, 7003)

SELECT top(4) rc.compid, CompShort, rca.CompAdd, rca.TerrID FROM r_Comps rc
join r_CompsAdd rca ON rca.CompID = rc.CompID
--cross apply (SELECT top(4) * from r_CompsAdd WHERE CompID = rc.CompID ORDER BY CompID DESC) m
WHERE rc.CompID in (7001, 7003)

------------------------------
--Результат:
------------------------------            
--CountryID   Country         City
------------- --------------- ---------------
--1           Россия          Екатеринбург
--1           Россия          Москва
--1           Россия          Новосибирс
--2           США             Атланта
--2           США             Вашингтон
--2           США             Чикаго
--3           Германия        Берлин
--3           Германия        Бремен
--3           Германия        Гамбург
--4           Франция         Лион
--4           Франция         Париж
--5           Италия          Милан






--Script #1 - Creating some temporary objects to work on...

USE [tempdb] 
GO
 
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[Employee]') AND type IN (N'U')) 
BEGIN 
   DROP TABLE [Employee] 
END 
GO 

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[Department]') AND type IN (N'U')) 
BEGIN 
   DROP TABLE [Department] 
END 

CREATE TABLE [Department]( 
   [DepartmentID] [int] NOT NULL PRIMARY KEY, 
   [Name] VARCHAR(250) NOT NULL, 
) ON [PRIMARY] 

INSERT [Department] ([DepartmentID], [Name])  
VALUES (1, N'Engineering') 
INSERT [Department] ([DepartmentID], [Name])  
VALUES (2, N'Administration') 
INSERT [Department] ([DepartmentID], [Name])  
VALUES (3, N'Sales') 
INSERT [Department] ([DepartmentID], [Name])  
VALUES (4, N'Marketing') 
INSERT [Department] ([DepartmentID], [Name])  
VALUES (5, N'Finance') 
GO 

CREATE TABLE [Employee]( 
   [EmployeeID] [int] NOT NULL PRIMARY KEY, 
   [FirstName] VARCHAR(250) NOT NULL, 
   [LastName] VARCHAR(250) NOT NULL, 
   [DepartmentID] [int] NOT NULL REFERENCES [Department](DepartmentID), 
) ON [PRIMARY] 
GO
 
INSERT [Employee] ([EmployeeID], [FirstName], [LastName], [DepartmentID]) 
VALUES (1, N'Orlando', N'Gee', 1 ) 
INSERT [Employee] ([EmployeeID], [FirstName], [LastName], [DepartmentID]) 
VALUES (2, N'Keith', N'Harris', 2 ) 
INSERT [Employee] ([EmployeeID], [FirstName], [LastName], [DepartmentID]) 
VALUES (3, N'Donna', N'Carreras', 3 ) 
INSERT [Employee] ([EmployeeID], [FirstName], [LastName], [DepartmentID]) 
VALUES (4, N'Janet', N'Gates', 3 ) 

SELECT * FROM [Department]
SELECT * FROM [Employee]

--Script #2 - CROSS APPLY and INNER JOIN

SELECT * FROM Department D 
CROSS APPLY 
   ( 
   SELECT * FROM Employee E 
   WHERE E.DepartmentID = D.DepartmentID 
   ) A 
GO
 
SELECT * FROM Department D 
inner JOIN Employee E ON D.DepartmentID = E.DepartmentID 
GO 

--Script #3 - OUTER APPLY and LEFT OUTER JOIN

SELECT * FROM Department D 
OUTER APPLY 
   ( 
   SELECT * FROM Employee E 
   WHERE E.DepartmentID = D.DepartmentID 
   ) A 
GO
 
SELECT * FROM Department D 
LEFT OUTER JOIN Employee E ON D.DepartmentID = E.DepartmentID 
GO 



--Script #4 - APPLY with table-valued function

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[fn_GetAllEmployeeOfADepartment]') AND type IN (N'IF')) 
BEGIN 
   DROP FUNCTION dbo.fn_GetAllEmployeeOfADepartment 
END 
GO
 
CREATE FUNCTION dbo.fn_GetAllEmployeeOfADepartment(@DeptID AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
   SELECT * FROM Employee E 
   WHERE E.DepartmentID = @DeptID 
   ) 
GO
 
SELECT * FROM Department D 
CROSS APPLY dbo.fn_GetAllEmployeeOfADepartment(D.DepartmentID) 
GO
 
SELECT * FROM Department D 
OUTER APPLY dbo.fn_GetAllEmployeeOfADepartment(D.DepartmentID) 
GO 

--SELECT * FROM dbo.fn_GetAllEmployeeOfADepartment(3) 

SELECT * FROM r_comps r  
join r_compsadd rc on rc.compid = r.compid
WHERE rc.compaddid = 1 and rc.compid = 7001


SELECT * FROM r_comps r  --WHERE r.chid = 1406
cross apply (SELECT * FROM r_compsadd WHERE compaddid = 1 and compid = 7001) m
WHERE r.compid = 7001

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
