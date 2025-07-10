--товары с неправильными штрихкодами по основным еденицам измерений
-- из-за этого в заказы ИМ подтягавались неправильные штрихкода
SELECT * FROM r_ProdMQ 
where ProdID in (SELECT distinct ProdID FROM r_ProdMQ where UM  in (SELECT distinct UM FROM r_Prods) and isnumeric(BarCode) != 1 )
and ProdID in (SELECT distinct ProdID FROM r_ProdMQ where UM  not in (SELECT distinct UM FROM r_Prods) and isnumeric(BarCode) = 1 )
ORDER BY 1

SELECT distinct mq.BarCode--mq.* 
	FROM r_ProdMQ mq
	join r_Prods p on p.ProdID = mq.ProdID and p.UM = mq.UM
	join r_ProdMP mp on mp.ProdID = p.ProdID and mp.PLID in (86,84,70,85,72,71)
	where LEN(mq.BarCode) > 8 and (mq.BarCode not like  '%[^0-9]%' )

--не числовой штрихкод	
SELECT * FROM r_ProdMQ where  isnumeric(BarCode) != 1  and LEN(BarCode) > 7 
--and BarCode like '%8033210410439'
ORDER BY BarCode

/*
SELECT d.BarCode, d.ProdID, * FROM at_t_IORes m
JOIN at_t_IOResD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE isnumeric(d.BarCode) != 1 and OurID = 6
ORDER BY m.DocDate desc
*/




----штрих коды под замену
--SELECT * , (SELECT ProdName FROM r_Prods p1 where p1.ProdID = s1.ProdID) FROM (
--	SELECT distinct mq.* 
--	FROM r_ProdMQ mq
--	join r_Prods p on p.ProdID = mq.ProdID and p.UM = mq.UM
--	join r_ProdMP mp on mp.ProdID = p.ProdID and mp.PLID in (86,84,70,85,72,71)
--	where LEN(BarCode) < 8 or BarCode like  '%[^0-9]%' 
--) s1
--join (SELECT distinct * FROM r_ProdMQ where BarCode not like  '%[^0-9]%' and LEN(BarCode) > 6 ) mq2 on mq2.ProdID = s1.ProdID
--where mq2.BarCode <> s1.BarCode and mq2.ProdID Not in (601280,601281,601282,601283,601286,803028,803029,803030, 8000, 800311)
--ORDER BY 1




BEGIN TRAN

--обновить неправильные штрихкода и найти правильные
update  up 
set up.barcode = up.BarCode + '-b_g-' + mq2.BarCode
,up.ProdBarCode = up.BarCode + '-b_g-' + mq2.BarCode
,up.Notes = mq2.UM
 FROM r_ProdMQ up 
join (	SELECT distinct mq.* 
	FROM r_ProdMQ mq
	join r_Prods p on p.ProdID = mq.ProdID and p.UM = mq.UM
	join r_ProdMP mp on mp.ProdID = p.ProdID and mp.PLID in (86,84,70,85,72,71)
	where LEN(BarCode) < 8 or BarCode like  '%[^0-9]%' 
) s1 on s1.ProdID = up.ProdID  and s1.UM = up.UM
join (SELECT distinct * FROM r_ProdMQ where BarCode not like  '%[^0-9]%' and LEN(BarCode) > 6) mq2 on mq2.ProdID = s1.ProdID
where mq2.BarCode <> s1.BarCode and mq2.ProdID Not in (601280,601281,601282,601283,601286,803028,803029,803030, 8000, 800311)

SELECT * FROM r_ProdMQ where BarCode like '%b_g%'
ORDER BY 1

SELECT * 
, (SELECT ProdName FROM r_Prods p1 where p1.ProdID = s1.ProdID) ProdName
FROM r_ProdMQ up 
join (	SELECT distinct mq.* 
	FROM r_ProdMQ mq
	join r_Prods p on p.ProdID = mq.ProdID and p.UM = mq.UM
	join r_ProdMP mp on mp.ProdID = p.ProdID and mp.PLID in (86,84,70,85,72,71)
	where LEN(BarCode) < 8 or BarCode like  '%[^0-9]%' 
) s1 on s1.ProdID = up.ProdID and s1.UM = up.UM
join (SELECT distinct * FROM r_ProdMQ where BarCode not like  '%[^0-9]%' and LEN(BarCode) > 6 ) mq2 on mq2.ProdID = s1.ProdID
where mq2.BarCode <> s1.BarCode and mq2.ProdID Not in (601280,601281,601282,601283,601286,803028,803029,803030, 8000, 800311)
ORDER BY 1

SELECT SUBSTRING (mq1.BarCode ,1 ,CHARINDEX ('b_g',mq1.BarCode)-2 ) new ,mq2.* FROM r_ProdMQ mq1
join r_ProdMQ mq2 on mq2.ProdID = mq1.ProdID and mq2.UM = mq1.Notes
where mq1.BarCode like '%b_g%'
ORDER BY 1

--переименовать правильные штрихкода с добавлением <->
update mq2
set mq2.BarCode = mq2.BarCode + '<->' +  SUBSTRING (mq1.BarCode ,1 ,CHARINDEX ('b_g',mq1.BarCode)-2 ) 
, mq2.ProdBarCode = mq2.BarCode + '<->' +  SUBSTRING (mq1.BarCode ,1 ,CHARINDEX ('b_g',mq1.BarCode)-2 ) 
 FROM r_ProdMQ mq1
join r_ProdMQ mq2 on mq2.ProdID = mq1.ProdID and mq2.UM = mq1.Notes
where mq1.BarCode like '%b_g%'


SELECT * FROM r_ProdMQ where BarCode like '%<->%'
ORDER BY 1


SELECT SUBSTRING (mq.BarCode ,CHARINDEX ('<->',mq.BarCode)+3, 100) ,* FROM r_ProdMQ mq where BarCode like '%<->%'

--оставить правильные штрихкода убрав лишнее
update mq
set mq.BarCode = SUBSTRING (mq.BarCode ,CHARINDEX ('<->',mq.BarCode)+3, 100) 
, mq.ProdBarCode = SUBSTRING (mq.ProdBarCode ,CHARINDEX ('<->',mq.ProdBarCode)+3, 100) 
FROM r_ProdMQ mq where BarCode like '%<->%'

SELECT SUBSTRING (mq.ProdBarCode ,CHARINDEX ('b_g',mq.ProdBarCode)+4, 100) ,* FROM r_ProdMQ mq where ProdBarCode like '%b_g%'

--оставить неправильные шрихкода
update mq
set mq.BarCode = SUBSTRING (mq.BarCode ,CHARINDEX ('b_g',mq.BarCode)+4, 100) 
, mq.ProdBarCode = SUBSTRING (mq.ProdBarCode ,CHARINDEX ('b_g',mq.ProdBarCode)+4, 100) 
FROM r_ProdMQ mq where ProdBarCode like '%b_g%'


SELECT * FROM r_ProdMQ up 
join (	SELECT distinct mq.* 
	FROM r_ProdMQ mq
	join r_Prods p on p.ProdID = mq.ProdID and p.UM = mq.UM
	join r_ProdMP mp on mp.ProdID = p.ProdID and mp.PLID in (86,84,70,85,72,71)
	where LEN(BarCode) < 8 or BarCode like  '%[^0-9]%' 
) s1 on s1.ProdID = up.ProdID and s1.UM = up.UM
join (SELECT distinct * FROM r_ProdMQ where BarCode not like  '%[^0-9]%' and LEN(BarCode) > 6) mq2 on mq2.ProdID = s1.ProdID
where mq2.BarCode <> s1.BarCode and mq2.ProdID Not in (601280,601281,601282,601283,601286,803028,803029,803030, 8000, 800311)
ORDER BY 1



ROLLBACK TRAN
