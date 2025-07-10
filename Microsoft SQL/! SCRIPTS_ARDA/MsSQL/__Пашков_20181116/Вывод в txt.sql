--SELECT * FROM t_EOExpD where StockID = 1257

--SELECT cast(p.ProdID as char(6))+'-'+cast(p.UAProdName as varchar(250)) + '#;#' as Наименования,
--cast(mq.BarCode as varchar(14)) + '#;#' as Штрих_код,
--cast(d.Count_doc as varchar(10)) + '#;#' as Кол_учет,
--cast(g.Good_price as varchar(14)) + '#;#' as Цена,
--cast(d.Count_real as varchar(14)) as Кол_факт
----, *
-- FROM it_TSD_doc_head h
--join it_TSD_doc_details d on d.Id_doc = h.Id_doc
--join r_ProdMQ mq on mq.ProdID = d.Id_good
--join r_Prods p on p.ProdID = d.Id_good
--left join it_TSD_goods g on g.Id_good = d.Id_good
--where sklad_in_id = 1257 and h.Id_doc in (20598)


SELECT cast(p.ProdID as char(6))+'-'+cast(p.UAProdName as varchar(250)) + '#;#' +cast(mq.BarCode as varchar(14)) + '#;#' +cast(d.Count_doc as varchar(10)) + '#;#' +cast(g.Good_price as varchar(14)) + '#;#' +cast(d.Count_real as varchar(14))
 FROM ElitR.dbo.it_TSD_doc_head h
join ElitR.dbo.it_TSD_doc_details d on d.Id_doc = h.Id_doc
join ElitR.dbo.r_Prods p on p.ProdID = d.Id_good
left join ElitR.dbo.it_TSD_goods g on g.Id_good = d.Id_good
left join ElitR.dbo.it_TSD_barcode mq on mq.Id_good = d.Id_good
where h.sklad_in_id = 1257 and h.Id_doc in (20598)

--ксента абсент#;#5000289925440#;#9#;#323#;#12

SELECT * FROM r_PCs



SELECT cast(p.ProdID as char(6))+'-'+cast(p.UAProdName as varchar(250)) + '#;#' +cast(mq.BarCode as varchar(14)) + '#;#' +cast(d.Count_doc as varchar(10)) + '#;#' +cast(g.Good_price as varchar(14)) + '#;#' +cast(d.Count_real as varchar(14))  FROM ElitR.dbo.it_TSD_doc_head h join ElitR.dbo.it_TSD_doc_details d on d.Id_doc = h.Id_doc join ElitR.dbo.r_Prods p on p.ProdID = d.Id_good left join ElitR.dbo.it_TSD_goods g on g.Id_good = d.Id_good left join ElitR.dbo.it_TSD_barcode mq on mq.Id_good = d.Id_good where h.sklad_in_id = 1257 and h.Id_doc in (20598)


    --'WHERE  ((p.ProdID BETWEEN 600001 AND 605000) OR (p.ProdID BETWEEN 800000 AND 900000)) AND LEN (barcode) > 6 AND mq.qty  = 1 AND mq.barcode not in (select barcode from it_TSD_barcode) ' + Chr(13) + 
    --           ' AND p.ProdID NOT IN (601280,601281,601282,601283,803028,803029,803030) and mq.BarCode not like  ''%[^0-9]%'' ' + filter + Chr(13)+
