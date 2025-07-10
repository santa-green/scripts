--список заказов ИМ проданых в определенный день
SELECT * FROM at_t_IORes where DocID in (
	SELECT InDocID FROM t_Sale
	WHERE DocDate = '2018-06-01' 
	and OurID = 6
	and StockID = 1201
	and DeskCode = 233
)

--список чеков ИМ проданых в определенный день
	SELECT (SELECT top 1 DocDate FROM at_t_IORes io where io.DocID = s.InDocID ) DateIORes,* FROM t_Sale s
	WHERE DocDate = '2018-06-01' 
	and OurID = 6
	and StockID = 1201
	and DeskCode = 233
	and (SELECT top 1 DocDate FROM at_t_IORes io where io.DocID = s.InDocID ) < s.DocDate --
