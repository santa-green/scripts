
select docdate ,zrepnum, SUM (SumCC_wt) from t_zRep where CRID = 151 and DocDate between '20131001' and '20131031' group by DocDate  ,zrepnum order by DocDate ,zrepnum

select  docdate , SUM (tsumcc_wt) from t_Sale where CRID = 151 and DocDate between '20131001' and '20131031'group by DocDate order by DocDate