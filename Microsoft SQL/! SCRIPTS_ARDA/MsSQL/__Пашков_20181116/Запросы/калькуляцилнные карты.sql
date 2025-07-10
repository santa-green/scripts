
select * from _calc

DECLARE kalc CURSOR 
FOR

 SELECT  s.chid
 FROM it_Spec s
 JOIN _calc c ON s.DocID = c.n 
 WHERE StockID !=1310 and s.prodid not in (select prodid  from it_Spec where stockid = 1310)
 ORDER BY  s.chid

/*
DECLARE @chid INT
OPEN kalc
FETCH NEXT FROM kalc INTO @chid
WHILE @@FETCH_STATUS = 0    		 
  BEGIN  
     EXEC ip_SpecCopy  @chid,12,'20130114',1310;
     FETCH NEXT FROM kalc INTO @chid
  END
CLOSE kalc
http://05692.numbers.in.ua/page/155842740/frl-2/

DEALLOCATE kalc
*/
 
 /*
 
 select * from r_Stocks where StockID in (1202, 1222 , 1232)


 exec ip_SpecCopy  10,12,'20130114',1310;


 
 */
 select * from it_Spec order by DocID desc
 
 
 
 select * from it_Spec where ProdID = 605147
 
 select *
 from it_SpecD where Percent2 =  99.999999999
 select *
 from it_SpecD where Percent2 =  100-- and ChID = 10
 
 
 /*
 update it_SpecD
 set Percent2 = 100
 from it_SpecD where ChID = 10 and Percent2 = 99
 
 
  update it_SpecD
 set Percent2 = 100
 from it_SpecD where ChID = 10 and Percent2 = 99.999999999  
 
 */
 
 
