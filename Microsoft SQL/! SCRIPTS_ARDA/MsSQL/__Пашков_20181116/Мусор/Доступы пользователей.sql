SELECT u.UserID, u.UserName, u.EmpID, e.EmpName, u.ValidOurs, u.ValidStocks, * FROM r_Users u 
join r_Emps e on e.EmpID = u.EmpID
where u.UserName in ('hvv5','rly','paa18','kev19')
ORDER BY e.EmpName