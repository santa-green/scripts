
--  delete it_PrintPriceList

SELECT EmpName,* FROM  it_PrintPriceList p
left join r_Users u on u.UserID = p.UserCode
left join r_Emps e on e.EmpID=u.EmpID
ORDER BY UserCode,SrcPosID
