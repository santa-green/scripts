--список пользователей которым доступен склад
DECLARE @Stocks int = 735  -- номер склада

SELECT UserID, UserName, u.EmpID, e.EmpName, ValidStocks FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
where ValidStocks not in ('','-1') 
and EXISTS(SELECT 1 FROM dbo.zf_FilterToTable(ValidStocks) where AValue = @Stocks )


--количество доступных складов
SELECT UserID, UserName, u.EmpID, e.EmpName, ValidStocks , (SELECT count(*) FROM dbo.zf_FilterToTable(u.ValidStocks)) kol FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
where ValidStocks not in ('','-1') 
ORDER BY kol



BEGIN TRAN

SELECT * FROM r_Users where UserID in (
1500,1858,1820,1880,1687,1843,1851,1498,1677
)

--Добавить склад 
update r_Users
set ValidStocks = ValidStocks + ',737'
where UserID in (
1500,1858,1820,1880,1687,1843,1851,1498,1677
)

SELECT * FROM r_Users where UserID in (
1500,1858,1820,1880,1687,1843,1851,1498,1677
)

ROLLBACK TRAN

/*
SELECT UserID, UserName, u.EmpID, e.EmpName, ValidStocks FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
where UserID in (
1500,1858,1820,1880,1687,1843,1851,1498,1677
)

 
SELECT UserID, UserName, u.EmpID, e.EmpName, ValidStocks FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
 where ValidStocks like '%30000%'
 
 SELECT * FROM r_Stocks

*/