USE ElitV_DP2

SELECT * FROM r_ProdMP
where ProdID in (600737) and PLID = 83
SELECT * FROM [s-sql-d4].elitr.dbo.r_ProdMP
where ProdID in (600737) and PLID = 83

SELECT * FROM [s-sql-d4].elitr.dbo.r_ProdMP
where PLID = 83 and ProdID not in (611835,611836,802833,802834,802835,802836,802837,802838)

begin tran

SELECT * FROM r_ProdMP
where  PLID = 83
SELECT * FROM [s-sql-d4].elitr.dbo.r_ProdMP
where  PLID = 83

--Обновление товаров прайс листа 83
update r_ProdMP
set
PriceMC = d4.PriceMC,
PromoPriceCC= d4.PromoPriceCC, 
BDate= d4.BDate, 
EDate= d4.EDate
FROM [s-sql-d4].elitr.dbo.r_ProdMP d4
join r_ProdMP on r_ProdMP.ProdID = d4.prodid and r_ProdMP.PLID = d4.PLID 
where d4.PLID = 83  and d4.ProdID not in (611835,611836,802833,802834,802835,802836,802837,802838) 


SELECT * FROM r_ProdMP
where  PLID = 83
SELECT * FROM [s-sql-d4].elitr.dbo.r_ProdMP
where  PLID = 83

rollback tran




--insert r_ProdMP
SELECT * FROM [s-sql-d4].elitr.dbo.r_ProdMP
where  PLID = 83 and ProdID in (611835,611836,802833,802834,802835,802836,802837,802838)


except
SELECT ProdID FROM r_ProdMP
where PLID = 83 and ProdID in (611835,611836,802833,802834,802835,802836,802837,802838)

a_rProdMP_IUD
SELECT * FROM r_PLs