
--insert at_r_Clients
	SELECT * FROM [s-sql-d4].elitr.dbo.at_r_Clients where ClientID = 0
	

/*
DISABLE TRIGGER a_atrProdG4_IUD ON at_r_ProdG4;
insert at_r_ProdG4
	SELECT * FROM [s-sql-d4].elitr.dbo.at_r_ProdG4; 
ENABLE  TRIGGER a_atrProdG4_IUD ON at_r_ProdG4;

DISABLE TRIGGER a_atrProdG5_IUD ON at_r_ProdG5;
insert at_r_ProdG5
	SELECT ChID, PGrID5, PGrName5, Notes FROM [s-sql-d4].elitr.dbo.at_r_ProdG5 where PGrID5 not in (SELECT PGrID5 FROM at_r_ProdG5) ; 
ENABLE  TRIGGER a_atrProdG5_IUD ON at_r_ProdG5;

DISABLE TRIGGER a_atrProdG6_IUD ON at_r_ProdG6;
insert at_r_ProdG6
	SELECT * FROM [s-sql-d4].elitr.dbo.at_r_ProdG6 where PGrID6 not in (SELECT PGrID6 FROM at_r_ProdG6) ; 
ENABLE  TRIGGER a_atrProdG6_IUD ON at_r_ProdG6;

DISABLE TRIGGER a_atrProdG7_IUD ON at_r_ProdG7;
insert at_r_ProdG7
	SELECT * FROM [s-sql-d4].elitr.dbo.at_r_ProdG7 where PGrID7 not in (SELECT PGrID7 FROM at_r_ProdG7) ; 
ENABLE  TRIGGER a_atrProdG7_IUD ON at_r_ProdG7;

DISABLE TRIGGER a_atrProdsAmort_IUD ON at_r_ProdsAmort;
insert at_r_ProdsAmort
	SELECT * FROM [s-sql-d4].elitr.dbo.at_r_ProdsAmort ; 
ENABLE  TRIGGER a_atrProdsAmort_IUD ON at_r_ProdsAmort;
	
SELECT * FROM [s-sql-d4].elitr.dbo.at_r_ProdsAmort
SELECT * FROM at_r_ProdsAmort
*/
	
--a_rProds_IUD
	
--insert r_Prods
	SELECT * FROM [s-sql-d4].elitr.dbo.r_Prods where prodid not in (SELECT prodid FROM r_Prods)	

--insert t_PInP
	SELECT * FROM [s-sql-d4].elitr.dbo.t_pinp where PPID = 0





SELECT SUSER_SNAME()