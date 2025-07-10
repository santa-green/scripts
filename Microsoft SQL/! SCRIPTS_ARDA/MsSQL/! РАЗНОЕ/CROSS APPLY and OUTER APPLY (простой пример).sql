--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*t-sql.ru*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE Alef_Elit_TEST
go
--Создаю тестовую таблицу стран
if object_id ( 'dbo.Countries', 'U' ) is not null
drop table dbo.Countries
go
create table dbo.Countries ( CountryID int, Country nvarchar(255) )
go

--Добавим 5 стран, используя синтаксис SQL Server 2008
insert into dbo.Countries ( CountryID, Country )
values ( 1, N'Россия' ), ( 2, N'США' ), ( 3, N'Германия' )
     , ( 4, N'Франция' ), ( 5, N'Италия' ), ( 6, N'Испания' )
go

--Создаю тестовую таблицу городов
if object_id ( 'dbo.Cities', 'U' ) is not null
drop table dbo.Cities
go
create table dbo.Cities ( CityID int, CountryID int, City nvarchar(255) )
go

--Добавим несколько городов
insert into dbo.Cities ( CityID, CountryID, City )
values ( 1, 1, N'Москва' ), ( 2, 1, N'Санкт-Петербург' ), ( 3, 1, N'Екатеринбург' )
     , ( 4, 1, N'Новосибирс' ), ( 5, 1, N'Самара' ), ( 6, 2, N'Чикаго' )
     , ( 7, 2, N'Вашингтон' ), ( 8, 2, N'Атланта' ), ( 9, 3, N'Берлин' )
     , ( 10, 3, N'Мюнхен' ), ( 11, 3, N'Гамбург' ), ( 12, 3, N'Бремен' )
     , ( 13, 4, N'Париж' ), ( 14, 4, N'Лион' ), ( 15, 5, N'Милан' )
go  

SELECT * FROM Countries
SELECT * FROM Cities

if object_id ( 'dbo.GetCities', 'U' ) is not null drop function dbo.GetCities
go

create function dbo.GetCities(@CountryID int)
returns table
as
return
(
SELECT CityID, City FROM Cities WHERE CountryID = @CountryID
)
go

SELECT * FROM dbo.GetCities(2)

SELECT cs.*, gc.* FROM Countries cs CROSS APPLY dbo.GetCities(cs.CountryID) gc
SELECT cs.*, gc.* FROM Countries cs OUTER APPLY dbo.GetCities(cs.CountryID) gc

SELECT cs.*, gc.* FROM Countries cs outer APPLY (SELECT top(3)* FROM dbo.GetCities(cs.CountryID) ORDER BY City)gc
SELECT cs.*, gc.* FROM Countries cs outer APPLY (SELECT top(3)* FROM Cities c WHERE c.CountryID = cs.CountryID ORDER BY City)gc

SELECT cs.*, gc.* FROM Countries cs outer APPLY (SELECT top(3) *, LEFT(CITY, 1) '1L', LEN(CITY) 'LEN' FROM dbo.GetCities(cs.CountryID) ORDER BY City)gc

select * from dbo.Countries c
cross apply ( select top 3 City from dbo.Cities where CountryID = c.CountryID order by City 
            ) ap
cross apply ( select l 'Letter', sum (cl) 'LetterCount' 
                from
                (select left( ap.City, 1 ) l,
                        len( City ) - len ( replace ( City, left( ap.City, 1 ) ,'' ) )  cl
                   from dbo.Cities where CountryID = c.CountryID
                 ) t 
              group by l
            ) apLetters

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*parse*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Создаю ещё одну тестовую таблицу 
if object_id ( 'dbo.TestTable', 'U' ) is not null
drop table dbo.TestTable
go
create table dbo.TestTable ( val nvarchar(1024) )
insert into dbo.TestTable
select N'Иванов,Иван,Иванович,1980,Москва'
union all
select N'Петров,,,1988'
union all
select N'Сидоров,Иван,Юрьевич,,Саратов'
union all
select N',Степан,,,Екатеринбург'
union all
select N'Кузнецов,,Иванович'
union all
select N'Путин'

select * from dbo.TestTable
------------------------------
--Результат:
------------------------------
--val
-----------------------------------
--Иванов,Иван,Иванович,1980,Москва
--Петров,,,1988
--Сидоров,Иван,Юрьевич,,Саратов
--,Степан,,,Екатеринбург
--Кузнецов,,Иванович
--Путин

select val + ',,,,,' from dbo.TestTable
select CHARINDEX('h', 'hello', 1)

select string from dbo.TestTable CROSS APPLY (select string = val + ',,,,,') f1
select p1, p2, p3, p4, p5 
  from dbo.TestTable
  cross apply ( select string = val + ',,,,,' ) f1
  cross apply ( select p1 = charindex( ',', string ) ) ap1
  cross apply ( select p2 = charindex( ',', string, p1 + 1 ) ) ap2
  cross apply ( select p3 = charindex( ',', string, p2 + 1 ) ) ap3
  cross apply ( select p4 = charindex( ',', string, p3 + 1 ) ) ap4
  cross apply ( select p5 = charindex( ',', string, p4 + 1 ) ) ap5

  select * 
  from dbo.TestTable
  cross apply ( select string = val + ',,,,,' ) f1
  cross apply ( select p1 = charindex( ',', string ) ) ap1
  cross apply ( select p2 = charindex( ',', string, p1 + 1 ) ) ap2
  cross apply ( select p3 = charindex( ',', string, p2 + 1 ) ) ap3
  cross apply ( select p4 = charindex( ',', string, p3 + 1 ) ) ap4
  cross apply ( select p5 = charindex( ',', string, p4 + 1 ) ) ap5
  cross apply ( select LastName = substring( string, 1, p1-1 )                   
                     , MiddleName = substring( string, p1+1, p2-p1-1 )                   
                     , FirstName = substring( string, p2+1, p3-p2-1 )                   
                     , Year = substring( string, p3+1, p4-p3-1 )
                     , City = substring( string, p4+1, p5-p4-1 )
              ) NewTable

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*codingsight*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [DBO].[EMPLOYEES] 
  ( 
     [EMPLOYEENAME] [VARCHAR](MAX) NULL, 
     [BIRTHDATE]    [DATETIME] NULL, 
     [JOBTITLE]     [VARCHAR](150) NULL, 
     [EMAILID]      [VARCHAR](100) NULL, 
     [PHONENUMBER]  [VARCHAR](20) NULL, 
     [HIREDATE]     [DATETIME] NULL, 
     [DEPARTMENTID] [INT] NULL 
  ) 

GO 

CREATE TABLE [DBO].[DEPARTMENT] 
  ( 
     [DEPARTMENTID]   INT IDENTITY (1, 1), 
     [DEPARTMENTNAME] [VARCHAR](MAX) NULL 
  ) 
GO
--set identity_insert dbo.department off
INSERT [DBO].[DEPARTMENT] 
       ([DEPARTMENTID], 
        [DEPARTMENTNAME]) 
VALUES (1, 
        N'IT'), 
       (2, 
        N'TECHNICAL'), 
       (3, 
        N'RESEARCH AND DEVELOPMENT')
        INSERT [DBO].[EMPLOYEES] 
       ([EMPLOYEENAME], 
        [BIRTHDATE], 
        [JOBTITLE], 
        [EMAILID], 
        [PHONENUMBER], 
        [HIREDATE], 
        [DEPARTMENTID]) 
VALUES (N'KEN J SÁNCHEZ', 
        CAST(N'1969-01-29T00:00:00.000' AS DATETIME), 
        N'CHIEF EXECUTIVE OFFICER', 
        N'KEN0@ADVENTURE-WORKS.COM', 
        N'697-555-0142', 
        CAST(N'2009-01-14T00:00:00.000' AS DATETIME), 
        1), 
       (N'TERRI LEE DUFFY', 
        CAST(N'1971-08-01T00:00:00.000' AS DATETIME), 
        N'VICE PRESIDENT OF ENGINEERING', 
        N'TERRI0@ADVENTURE-WORKS.COM', 
        N'819-555-0175', 
        CAST(N'2008-01-31T00:00:00.000' AS DATETIME), 
        NULL), 
       (N'ROBERTO  TAMBURELLO', 
        CAST(N'1974-11-12T00:00:00.000' AS DATETIME), 
        N'ENGINEERING MANAGER', 
        N'ROBERTO0@ADVENTURE-WORKS.COM', 
        N'212-555-0187', 
        CAST(N'2007-11-11T00:00:00.000' AS DATETIME), 
        NULL), 
       (N'ROB  WALTERS', 
        CAST(N'1974-12-23T00:00:00.000' AS DATETIME), 
        N'SENIOR TOOL DESIGNER', 
        N'ROB0@ADVENTURE-WORKS.COM', 
        N'612-555-0100', 
        CAST(N'2007-12-05T00:00:00.000' AS DATETIME), 
        NULL), 
       (N'GAIL A ERICKSON', 
        CAST(N'1952-09-27T00:00:00.000' AS DATETIME), 
        N'DESIGN ENGINEER', 
        N'GAIL0@ADVENTURE-WORKS.COM', 
        N'849-555-0139', 
        CAST(N'2008-01-06T00:00:00.000' AS DATETIME), 
        NULL), 
       (N'JOSSEF H GOLDBERG', 
        CAST(N'1959-03-11T00:00:00.000' AS DATETIME), 
        N'DESIGN ENGINEER', 
        N'JOSSEF0@ADVENTURE-WORKS.COM', 
        N'122-555-0189', 
        CAST(N'2008-01-24T00:00:00.000' AS DATETIME), 
        NULL), 
       (N'DYLAN A MILLER', 
        CAST(N'1987-02-24T00:00:00.000' AS DATETIME), 
        N'RESEARCH AND DEVELOPMENT MANAGER', 
        N'DYLAN0@ADVENTURE-WORKS.COM', 
        N'181-555-0156', 
        CAST(N'2009-02-08T00:00:00.000' AS DATETIME), 
        3), 
       (N'DIANE L MARGHEIM', 
        CAST(N'1986-06-05T00:00:00.000' AS DATETIME), 
        N'RESEARCH AND DEVELOPMENT ENGINEER', 
        N'DIANE1@ADVENTURE-WORKS.COM', 
        N'815-555-0138', 
        CAST(N'2008-12-29T00:00:00.000' AS DATETIME), 
        3), 
       (N'GIGI N MATTHEW', 
        CAST(N'1979-01-21T00:00:00.000' AS DATETIME), 
        N'RESEARCH AND DEVELOPMENT ENGINEER', 
        N'GIGI0@ADVENTURE-WORKS.COM', 
        N'185-555-0186', 
        CAST(N'2009-01-16T00:00:00.000' AS DATETIME), 
        3), 
       (N'MICHAEL  RAHEEM', 
        CAST(N'1984-11-30T00:00:00.000' AS DATETIME), 
        N'RESEARCH AND DEVELOPMENT MANAGER', 
        N'MICHAEL6@ADVENTURE-WORKS.COM', 
        N'330-555-2568', 
        CAST(N'2009-05-03T00:00:00.000' AS DATETIME), 
        3)

SELECT [EMPLOYEENAME], 
       [BIRTHDATE], 
       [JOBTITLE], 
       [EMAILID], 
       [PHONENUMBER], 
       [HIREDATE], 
       [DEPARTMENTID] 
FROM   [EMPLOYEES] 


SELECT [DEPARTMENTID], 
       [DEPARTMENTNAME] 
FROM   [DEPARTMENT] 

SELECT * FROM [EMPLOYEES]
SELECT * FROM [DEPARTMENT] d CROSS APPLY (SELECT * from EMPLOYEES e WHERE e.DEPARTMENTID = d.DEPARTMENTID) x
SELECT * FROM [DEPARTMENT] d outer APPLY (SELECT * from EMPLOYEES e WHERE e.DEPARTMENTID = d.DEPARTMENTID) x
SELECT d.*, geb.* FROM [DEPARTMENT] d outer APPLY dbo.GETEMPLOYEESBYDEPARTMENT(d.DEPARTMENTID) geb

CREATE FUNCTION Getemployeesbydepartment (@DEPARTMENTID INT) 
RETURNS @EMPLOYEES TABLE ( 
  EMPLOYEENAME   VARCHAR (MAX), 
  BIRTHDATE      DATETIME, 
  JOBTITLE       VARCHAR(150), 
  EMAILID        VARCHAR(100), 
  PHONENUMBER    VARCHAR(20), 
  HIREDATE       DATETIME, 
  DEPARTMENTID VARCHAR(500)) 
AS 
  BEGIN 
      INSERT INTO @EMPLOYEES 
      SELECT A.EMPLOYEENAME, 
             A.BIRTHDATE, 
             A.JOBTITLE, 
             A.EMAILID, 
             A.PHONENUMBER, 
             A.HIREDATE, 
             A.DEPARTMENTID 
      FROM   [EMPLOYEES] A 
      WHERE  A.DEPARTMENTID = @DEPARTMENTID 

      RETURN 
  END


  SELECT EMPLOYEENAME,
       BIRTHDATE,
       JOBTITLE,
       EMAILID,
       PHONENUMBER,
       HIREDATE,
       DEPARTMENTID
FROM   GETEMPLOYEESBYDEPARTMENT (1)
SELECT * FROM GETEMPLOYEESBYDEPARTMENT(1)