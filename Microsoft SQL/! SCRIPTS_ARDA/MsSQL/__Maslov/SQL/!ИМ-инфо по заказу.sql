USE ElitR

--EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'
--GO
----REVERT

DECLARE @DocID int = 178847 --152171  -- номер заказа в ИМ

IF EXISTS (SELECT 1 FROM elit.dbo.t_Inv where SrcDocID = cast(@DocID as varchar))
BEGIN
	SELECT 'РН в элитке'
	SELECT * FROM elit.dbo.t_Inv where SrcDocID = cast(@DocID as varchar)
	SELECT * FROM elit.dbo.t_InvD where ChID = (SELECT ChID FROM elit.dbo.t_Inv where SrcDocID = cast(@DocID as varchar))
END
IF EXISTS (SELECT 1 FROM at_t_IORes where DocID = @DocID)
BEGIN
	SELECT 'ЗВР'
	SELECT * FROM at_t_IORes where DocID = @DocID
	SELECT * FROM at_t_IOResD where ChID in (SELECT ChID FROM at_t_IORes where DocID = @DocID) ORDER BY ChID,SrcPosID
END
IF EXISTS (SELECT 1 FROM t_Rec where InDocID = cast(@DocID as varchar))
BEGIN
	SELECT 'приход'
	SELECT * FROM t_Rec where InDocID = cast(@DocID as varchar)
	SELECT * FROM t_RecD where ChID = (SELECT ChID FROM t_Rec where InDocID = cast(@DocID as varchar))
END
IF EXISTS (SELECT 1 FROM t_Exc where SrcDocID = cast(@DocID as varchar))
BEGIN
	SELECT 'перемещение'
	SELECT * FROM t_Exc where SrcDocID = cast(@DocID as varchar)
	SELECT * FROM t_ExcD where ChID = (SELECT ChID FROM t_Exc where SrcDocID = cast(@DocID as varchar))
END
IF EXISTS (SELECT 1 FROM t_SaleTemp where Notes like cast(@DocID as varchar) + '%')
BEGIN
	SELECT 'temp'
	SELECT * FROM t_SaleTemp where Notes like cast(@DocID as varchar) + '%'
	SELECT * FROM t_SaleTempD where ChID in (SELECT ChID FROM t_SaleTemp where Notes like cast(@DocID as varchar) + '%')
END
IF EXISTS (SELECT 1 FROM t_Sale where Notes like cast(@DocID as varchar) + '%')
BEGIN
	SELECT 'продажи t_Sale'
	SELECT * FROM t_Sale where Notes like cast(@DocID as varchar) + '%'
	SELECT * FROM t_SaleD where ChID in (SELECT ChID FROM t_Sale where Notes like cast(@DocID as varchar) + '%')
END

IF 1=0
--BEGIN
	
--	SELECT distinct * FROM OPENQUERY(VintageClub,
--	'SELECT distinct id,i.order_id,unikod,price,i.discount,discount_type,num,info,create_time,  t.order_id as order_id_t,item_id,storage_id,count,t.discount as discount_t FROM vintagemarket.order_item i, vintagemarket.order_tmp t where i.order_id = t.order_id and i.unikod = t.item_id 
--	') vc
--	WHERE order_id in (@DocID)
--	ORDER BY 2

--	SELECT   *
--	FROM OPENQUERY(VintageClub,
--	'SELECT * FROM vintagemarket.order ') vc
--	WHERE id = @DocID

--	SELECT   *
--	FROM OPENQUERY(VintageClub,
--	'SELECT * FROM vintagemarket.order_tmp ') vc
--	WHERE order_id = @DocID

--	SELECT   *
--	FROM OPENQUERY(VintageClub,
--	'SELECT * FROM vintagemarket.order_item ') vc
--	WHERE order_id = @DocID
--END

SELECT '[s-marketa].elitv_dp.dbo.t_SaleTemp'
SELECT * FROM [s-marketa].elitv_dp.dbo.t_SaleTemp where Notes like cast(@DocID as varchar) + '%'
SELECT * FROM [s-marketa].elitv_dp.dbo.t_SaleTempD where ChID in (SELECT ChID FROM [s-marketa].elitv_dp.dbo.t_SaleTemp where Notes like cast(@DocID as varchar) + '%')

SELECT 'продажи [s-marketa].elitv_dp.dbo.t_Sale'
SELECT * FROM [s-marketa].elitv_dp.dbo.t_Sale where Notes like cast(@DocID as varchar) + '%'
SELECT * FROM [s-marketa].elitv_dp.dbo.t_SaleD where ChID in (SELECT ChID FROM [s-marketa].elitv_dp.dbo.t_Sale where Notes like cast(@DocID as varchar) + '%')


SELECT '[s-marketa3].ElitRTS301.dbo.t_SaleTemp'
SELECT * FROM [s-marketa3].ElitRTS301.dbo.t_SaleTemp where Notes like cast(@DocID as varchar) + '%'
SELECT * FROM [s-marketa3].ElitRTS301.dbo.t_SaleTempD where ChID in (SELECT ChID FROM [s-marketa3].ElitRTS301.dbo.t_SaleTemp where Notes like cast(@DocID as varchar) + '%')

SELECT 'продажи [s-marketa3].ElitRTS301.dbo.t_Sale'
SELECT * FROM [s-marketa3].ElitRTS301.dbo.t_Sale where Notes like cast(@DocID as varchar) + '%'
SELECT * FROM [s-marketa3].ElitRTS301.dbo.t_SaleD where ChID in (SELECT ChID FROM [s-marketa3].ElitRTS301.dbo.t_Sale where Notes like cast(@DocID as varchar) + '%')


SELECT '[192.168.174.30].ElitRTS201.dbo.t_SaleTemp'
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_SaleTemp where Notes like cast(@DocID as varchar) + '%'
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_SaleTempD where ChID in (SELECT ChID FROM [192.168.174.30].ElitRTS201.dbo.t_SaleTemp where Notes like cast(@DocID as varchar) + '%')

SELECT 'продажи [192.168.174.30].ElitRTS201.dbo.t_Sale'
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_Sale where Notes like cast(@DocID as varchar) + '%'
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_SaleD where ChID in (SELECT ChID FROM [192.168.174.30].ElitRTS201.dbo.t_Sale where Notes like cast(@DocID as varchar) + '%')


--SELECT '[192.168.22.21].ElitRTS401.dbo.t_SaleTemp'
--SELECT * FROM [192.168.22.21].ElitRTS401.dbo.t_SaleTemp where Notes like cast(@DocID as varchar) + '%'
--SELECT * FROM [192.168.22.21].ElitRTS401.dbo.t_SaleTempD where ChID in (SELECT ChID FROM [192.168.22.21].ElitRTS401.dbo.t_SaleTemp where Notes like cast(@DocID as varchar) + '%')

--SELECT 'продажи [192.168.22.21].ElitRTS401.dbo.t_Sale'
--SELECT * FROM [192.168.22.21].ElitRTS401.dbo.t_Sale where Notes like cast(@DocID as varchar) + '%'
--SELECT * FROM [192.168.22.21].ElitRTS401.dbo.t_SaleD where ChID in (SELECT ChID FROM [192.168.22.21].ElitRTS401.dbo.t_Sale where Notes like cast(@DocID as varchar) + '%')

/*

SELECT * FROM t_SaleTemp where StockID = 1201 ORDER BY 3

SELECT * FROM t_Sale where Notes like cast(@DocID as varchar) + '%'

SELECT * FROM t_Sale where StockID = 1252 ORDER BY 3 desc


SELECT * FROM t_SaleTemp WHERE ChiD = 8037


update t_SaleTemp
set CRID = 301
WHERE ChiD = 8037


	SELECT * FROM at_t_IORes where DocID = 152557
	update at_t_IORes 
	set statecode = 110
	where ChiD = 10829

EXEC [dbo].[ap_VC_SaleTemp_Export] @CHID_IORes = 10829


SELECT * 
                   FROM at_t_IORes i
                   JOIN z_LogPrint lp WITH(NOLOCK) ON lp.ChID = i.ChID AND lp.DocCode = 666004 AND lp.AppCode = 11000 and i.ChiD = 10829
                   WHERE lp.FileName LIKE '%Фишка.fr3'
                   
                   
*/                   