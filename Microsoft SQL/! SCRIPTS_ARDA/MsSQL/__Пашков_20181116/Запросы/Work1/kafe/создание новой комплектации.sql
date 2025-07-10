use otdatacafe
declare @chid int
select @chid = max(chid) 
from t_srec
print @chid

	insert into t_srec
	select ChID+1 as chid,DocID+1 as DocID,IntDocID+1 as IntDocID,getdate ()as DocDate,KursMC,OurID,StockID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,DocStatID,EmpID,Notes,getdate() as SubDocDate,SubStockID,Value1,Value2,Value3 
	  from t_srec
	where chid = @chid
