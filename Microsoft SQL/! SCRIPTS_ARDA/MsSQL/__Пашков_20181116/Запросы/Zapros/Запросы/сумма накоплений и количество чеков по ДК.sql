select z.DCardID dcard ,  SUM (t.TSumCC_wt) summ1 , ClientName ,PhoneMob, t.ChID 
 into #_cards
 from z_LogDiscRec z
 join r_DCards r on z.DCardID =r.DCardID
 join t_Sale t on z.ChID =t.ChID 
where DBiID=3 and DocDate > = '20140101' 
and z.DCardID not like '%нет%' and DocCode =11035 --and z.DCardID ='2220000052054'
group by z.DCardID , ClientName ,PhoneMob ,t.ChID
having SUM (z.SumBonus)  >=500
order by z.DCardID 

select dcard , sum (summ1), ClientName , PhoneMob , COUNT (ChID) from #_cards
group by dcard, ClientName ,PhoneMob 
