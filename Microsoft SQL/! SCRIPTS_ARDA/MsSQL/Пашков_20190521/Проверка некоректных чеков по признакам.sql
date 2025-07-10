--проверка некоректных чеков по признакам
select * from t_sale
where DocDate between '20151001' and '20161231'
--and StockID = 1260
--and DocID in (600124592,600125218,600125289)
and TRealSum >0 and (CodeID1 = 0 or CodeID2 = 0 or CodeID3 = 0) --проверка на пустые признаки