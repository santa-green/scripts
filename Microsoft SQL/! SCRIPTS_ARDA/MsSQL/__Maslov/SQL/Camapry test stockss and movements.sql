
SELECT * 
,CONVERT( varchar, gr.Data, 102)
,(SELECT isnull(SUM(Qty),0) FROM [dbo].[af_CamparyDelivery]('4,304,11,311,27,327,85,385,220,320', 1,CONVERT( varchar, gr.Data, 102), '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')) dviz

FROM (
SELECT Data , sum(qty) tqty
FROM elit.dbo.[tmp_CamparyStocksInDay]
group by Data) gr
where (SELECT isnull(SUM(Qty),0) FROM [dbo].[af_CamparyDelivery]('4,304,11,311,27,327,85,385,220,320', 1,CONVERT( varchar, gr.Data, 102), '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')) <> tqty
order by 1

/*
select CONVERT( varchar, GETDATE(), 104)

(SELECT SUM(Qty) FROM [dbo].[af_CamparyDelivery]('4,304,11,311,27,327,85,385,220,320', 1 ,'2017.01.03', '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684'))
*/