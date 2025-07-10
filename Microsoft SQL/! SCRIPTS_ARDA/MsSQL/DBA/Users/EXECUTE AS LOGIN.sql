SELECT * FROM dbo.t_saletemp where CRID = 1 and DocDate = dbo.zf_GetDate(GETDATE()) and StockID = 1241 ORDER BY DocDate
SELECT * FROM dbo.t_saletemp where CRID in (2,3,201) and DocDate =dbo.zf_GetDate(GETDATE())  and StockID = 1241
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_saletemp where chid < 800000000


SELECT * FROM dbo.t_saletemp where CRID = 1 and DocDate = dbo.zf_GetDate(GETDATE())  and StockID = 1252 ORDER BY DocDate
SELECT * FROM dbo.t_saletemp where CRID in (2,3,301) and DocDate = dbo.zf_GetDate(GETDATE())  and StockID = 1252
SELECT * FROM [s-marketa3].ElitRTS301.dbo.t_saletemp where chid < 900000000
SELECT * FROM [s-marketa3].ElitRTS301.dbo.t_saletempd


SELECT * FROM dbo.t_saletemp where CRID in (2,3,201) ORDER BY 3 desc
SELECT * FROM dbo.t_saletemp ORDER BY 3 desc
/*
setuser 'kev19'
setuser '201'
setuser 'CORP\Cluster'
select SUSER_NAME()
select USER_NAME()


EXECUTE AS LOGIN = 'kev19';
EXECUTE AS LOGIN = '201';

REVERT 



UPDATE at_t_IORes  SET StateCode = 120 WHERE StateCode = 110 AND ChID = 7112
UPDATE at_t_IORes  SET StateCode = 110 WHERE StateCode = 120 AND ChID = 7112

exec [ap_VC_SaleTemp_Export] 7112

		insert [192.168.174.30].ElitRTS201.dbo.t_saletemp
			select ChID, 1 CRID, DocDate, DocTime, DocState, RateMC, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, CreditID,
				DCardID, Discount, Notes, DeskCode, OperID, Visitors, CashSumCC, ChangeSumCC, SaleDocID, EmpID, IsPrinted, 
				OurID, StockID, InChID from t_saletemp where /*CRID = @CRID and */ChID = 4319
				
				SELECT * FROM  [192.168.174.30].ElitRTS201.dbo.t_saletemp
				

*/
SELECT * FROM t_saletemp where chid = 4346 -- 141862 - ÐÎÇÍÈÖÀ
SELECT * FROM at_t_IORes where chid = 7112 -- 141862 - ÐÎÇÍÈÖÀ

				
SELECT *  FROM [192.168.174.30].ElitRTS201.dbo.t_SaleTemp
SELECT *  FROM [192.168.174.30].ElitRTS201.dbo.r_PCs	


SELECT  MONTH(BirthDay),DAY(BirthDay),   * FROM r_Emps where EmpName not like  '%óâîëåí%' and MONTH(BirthDay) = 9 ORDER BY 1,2 
SELECT  MONTH(BirthDay),DAY(BirthDay),   * FROM Elit.dbo.r_Emps where EmpName not like  '%óâîëåí%' and MONTH(BirthDay) = 9 ORDER BY 1,2 

--kev19	
--mISYwOK822


SELECT * FROM dbo.t_saletemp where chid = 4119
SELECT * FROM dbo.t_saletempd where chid = 4331
SELECT * FROM dbo.z_DocDC where chid = 4331 and DocCode =1011
SELECT * FROM dbo.z_LogDiscExp where chid = 4331 and DocCode =1011
SELECT * FROM dbo.z_LogDiscRec where chid = 4331 and DocCode =1011

SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_saletemp where chid = 4319
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_saletempd where chid = 4319
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.z_DocDC where chid = 4319
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.z_LogDiscExp where chid = 4319
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.z_LogDiscRec where chid = 4319


SELECT * FROM [s-marketa3].ElitRTS301.dbo.z_LogDiscExp where DocCode =1011
/*

delete [192.168.174.30].ElitRTS201.dbo.t_saletemp where chid = 4319

update t_saletemp set CRID = 1	where CRID = 2 and chid =  4319

UPDATE at_t_IORes  SET StateCode = 110 WHERE StateCode = 120 AND ChID = 7112

*/
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.z_LogDiscExp WHERE  DocCode =1011

select (select ISNULL(max(LogID),1) from [192.168.174.30].ElitRTS201.dbo.z_LogDiscExp) + SrcPosID as LogID, 
--áûëî äî 15-12-2016 10,13 select LogID,
DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,Discount,LogDate,BonusType,GroupSumBonus,GroupDiscount,8 DBiID
from z_LogDiscExp where  DocCode =1011 ORDER BY LogDate


SELECT * FROM dbo.z_LogDiscExp 
where DBiID = 1 
--and DocCode =1011
ORDER BY 1 desc ,LogDate desc

SELECT * FROM dbo.z_LogDiscRec where chid = 4331 and DocCode =1011


EXEC dbo.ap_PF_TTN_Master @DocCode = 11035, @OurID = 6, @DocIDs = '800019235,800019236', @AAccountCC = '26001010459357';


SELECT * FROM [s-marketa3].ElitRTS301.dbo.z_LogDiscExp
--where DBiID = 1 
--and DocCode =1011
ORDER BY LogDate desc


SELECT * FROM dbo.z_LogDiscExp
where DBiID = 9 
--and DocCode =1011
ORDER BY LogDate desc