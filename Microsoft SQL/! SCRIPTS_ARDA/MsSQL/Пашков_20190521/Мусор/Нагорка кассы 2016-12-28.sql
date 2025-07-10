
select * from t_sale
where DocDate = '2016-12-28'
and CRID = 180




select SUM(TRealSum) as terminal from t_sale
where DocDate = '2016-12-28'
and CRID = 180
and CodeID3 = 27


select SUM(TRealSum) as nal from t_sale
where DocDate = '2016-12-28'
and CRID = 180
and CodeID3 = 73


select SUM(TRealSum) as nal from t_sale
where DocDate = '2016-12-28'
and CRID = 180
and CodeID3 = 0


select * from t_sale
where DocDate = '2016-12-25'
and CRID = 203
and CodeID3 = 27
--and TRealSum > 1000
and Notes != ''
order by DocTime

select * from t_sale where ChID=100402801
select * from t_saled where ChID=100402801

select * from r_CRs


select * from t_sale
where DocDate = '2016-12-25'
and CRID = 203
and CodeID4 = 123


select  SUM(TRealSum) from t_sale
where DocDate = '2016-12-25'
and CRID = 203
and CodeID3 = 27
--and TRealSum > 1000
and Notes != ''
order by DocTime


select * from t_sale
where DocDate = '2016-12-26'
and CRID = 350
--and CodeID3 = 27
--and TRealSum > 1000
--and Notes != ''
order by TRealSum 

select * from t_saletemp order by DocTime

select * from t_SaleD where ChID= 18465

select * from t_SalePays where ChID in (select chid from t_sale
where DocDate = '2016-12-26'
and CRID = 350)
order by 1


select * from t_CRRet
where DocDate = '2016-12-26'
and CRID = 350

select * from t_CRRetD where ChID=38


select * from t_Sale where docID= 600137532

select * from t_SaleD where ChID=18161