SELECT * FROM t_VenA where ChID = 100009114

SELECT * FROM t_Ven where ChID = 100009114

SELECT * FROM r_Prods


SELECT COUNT(*) FROM ##tVenA

SELECT TSrcPosID,* FROM ##tVenA


insert r_Prods
SELECT * FROM [s-sql-d4].elitr.dbo.r_Prods where ProdID not in (SELECT ProdID FROM r_Prods)

a_rProds_IUD
a_atrProdG6_IUD
a_rProdG_IUD

t_venfillrems

SELECT * FROM at_r_ProdG6


insert at_r_ProdG6
SELECT * FROM [s-sql-d4].elitr.dbo.at_r_ProdG6 where PGrID6 not in (SELECT PGrID6 FROM at_r_ProdG6)

insert r_ProdG
SELECT * FROM [s-sql-d4].elitr.dbo.r_ProdG where PGrID not in (SELECT PGrID FROM r_ProdG)