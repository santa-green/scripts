--закрытие периода дл€ пользователей базы Elit ќптова€
--¬нимание есть джоб ELIT ClosePeriod в котором можно добавить новые исключени€ и настроить расписание запуска

USE Elit

--@BDate первый день мес€ца
DECLARE @BDate SMALLDATETIME = DATEADD(month,DATEDIFF(month,0,GETDATE()),0)
--SET @BDate = dateadd(month,datediff(month,0,GetDate()),0)--DATEADD(DAY, 1 - DAY(GETDATE()), GETDATE())  
SELECT @BDate



BEGIN TRAN


SELECT UserID, UserName, e.EmpName, u.EmpID, Active, BDate, EDate, u.UseOpenAge  FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
where UserName not in (
--»сключить следующих пользователей
'giv3','kvn1','pvn3','sao','eas1','bag3','oia2','snv10','ssv19','sa','sev12','vvv0','kav0','bos','rnu','dvv4','pai3','mav0','gdn1'
)
ORDER BY BDate

update r_Users 
set UseOpenAge = 1
where UserName not in (
--»сключить следующих пользователей
'giv3','kvn1','pvn3','sao','eas1','bag3','oia2','snv10','ssv19','sa','sev12','vvv0','kav0','bos','rnu','dvv4','pai3','mav0','gdn1'
)
SELECT UserID, UserName, e.EmpName, u.EmpID, Active, Emps, BDate, EDate, u.UseOpenAge  FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
where UserName not in (
--»сключить следующих пользователей
'giv3','kvn1','pvn3','sao','eas1','bag3','oia2','snv10','ssv19','sa','sev12','vvv0','kav0','bos','rnu','dvv4','pai3','mav0','gdn1'
)
ORDER BY BDate

SELECT UserID, cast(UserName as varchar(10)), cast(e.EmpName as varchar(60)), u.EmpID, Active,  BDate, EDate, u.UseOpenAge FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
where u.UseOpenAge = 0
ORDER BY BDate,e.EmpName

ROLLBACK TRAN


/* дл€ джоба

--закрытие периода дл€ пользователей базы Elit ќптова€
USE Elit

--первый день текущего мес€ца
DECLARE @BDate SMALLDATETIME = DATEADD(month,DATEDIFF(month,0,GETDATE()),0)
SELECT @BDate

update r_Users 
set BDate = @BDate, UseOpenAge = 1
where UserName not in (
--»сключить следующих пользователей
'giv3','kvn1','pvn3','sao','eas1','bag3','oia2','snv10','ssv19','sa','sev12','vvv0','kav0','bos','rnu','dvv4','pai3','mav0','gdn1'
)

SELECT UserID, cast(UserName as varchar(10)), cast(e.EmpName as varchar(60)), u.EmpID, Active,  BDate, EDate FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
ORDER BY BDate,e.EmpName

*/

--SELECT UserID, cast(UserName as varchar(10)), cast(e.EmpName as varchar(60)), u.EmpID, Active,  BDate, EDate, u.UseOpenAge FROM r_Users u
--join r_Emps e on e.EmpID = u.EmpID
--where u.UseOpenAge = 0
--ORDER BY BDate,e.EmpName


--SELECT UserID, UserName, e.EmpName, r_Users.EmpID, Active, Emps, BDate, EDate FROM r_Users 
--join r_Emps e on e.EmpID = r_Users.EmpID
--where UserName  in (
----»сключить следующих пользователей
--'giv3','kvn1','pvn3','sao','eas1','bag3','oia2','snv10','ssv19','sa','sev12','vvv0','kav0','bos','rnu','dvv4','pai3','mav0','gdn1'
--)
--ORDER BY 1


--SELECT UserID,UserName,e.EmpName, *
--FROM r_Users 
--join r_Emps e on e.EmpID = r_Users.EmpID
--WHERE UserID  in (1880,1891,239,1790,1921,1806,1892,1893,0,1285,1678,1631,11,141,314,1074,1681,1860)
--ORDER BY 1
