DECLARE @DocID int = 132264 -- номер заказа
SELECT * FROM at_t_IORes where DocID = @DocID
SELECT * FROM at_t_IOResD where ChID in (SELECT ChID FROM at_t_IORes where DocID = @DocID)

SELECT * FROM t_SaleTemp where Notes like '%' + cast(@DocID as varchar) + '%'
SELECT * FROM t_SaleTempD where ChID in (SELECT ChID FROM t_SaleTemp where Notes like '%' + cast(@DocID as varchar) + '%')

SELECT * FROM [S-SQL-D4].Elit.dbo.t_Inv where CompID = 10791 and SrcDocID = cast(@DocID as varchar)
ORDER BY DocDate desc

SELECT * FROM [S-SQL-D4].Elit.dbo.t_Invd 
WHERE ChID in (SELECT ChID FROM [S-SQL-D4].Elit.dbo.t_Inv WHERE CompID = 10791 and SrcDocID = cast(@DocID as varchar))

SELECT * FROM t_Rec where InDocID = @DocID
SELECT * FROM t_RecD where ChID in (SELECT ChID FROM t_Rec where InDocID = @DocID)




SELECT top 1000 * FROM [S-SQL-D4].Elit_test_IM.dbo.t_Inv where CompID = 10790 and SrcDocID = '131273'
ORDER BY DocDate desc


SELECT top 100 * FROM [S-SQL-D4].Elit_test_IM.dbo.t_Invd where ChID = 101542230
ORDER BY DocDate desc

SELECT * FROM [S-SQL-D4].Elit_test_IM.dbo.r_Comps where CompID in (10790,10791)

SELECT * FROM r_Comps

SELECT top 1000 * FROM [S-SQL-D4].Elit.dbo.t_Inv where CompID = 10791 and SrcDocID = '132264'
ORDER BY DocDate desc

SELECT top 100 * FROM [S-SQL-D4].Elit.dbo.t_Invd where ChID = 101544489

