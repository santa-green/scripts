
select * from r_EmpAdd
join r_Emps on r_Emps.EmpID=r_EmpAdd.EmpID
where FactCity like '%новомо%'