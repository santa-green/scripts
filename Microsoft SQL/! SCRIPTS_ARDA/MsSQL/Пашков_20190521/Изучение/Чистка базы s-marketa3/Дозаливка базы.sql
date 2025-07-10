

--insert t_PInP
	SELECT * FROM [s-sql-d4].elitr.dbo.t_pinp where PPID = 0

--insert r_Prods
	SELECT * FROM [s-sql-d4].elitr.dbo.r_Prods where prodid not in (SELECT prodid FROM r_Prods)



SELECT SUSER_SNAME()