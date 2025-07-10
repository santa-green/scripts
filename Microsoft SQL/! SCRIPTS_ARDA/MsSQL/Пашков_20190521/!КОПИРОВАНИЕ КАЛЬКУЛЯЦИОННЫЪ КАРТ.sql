/*
select * from it_Spec where  ChID in 
  (select ChID from it_Spec where  OurID = 12  AND DocID in (
  
178,52,51,334,54,55,344,44,45,47,48,40,123,125,330,340,295,294,332,91,290,289,124,168,170,1299,600000928,600000930,600000940,600000936,600002052,600002055
  order by DocDate
*/

BEGIN TRAN


DECLARE @Mchid int, @chid INT,
@NewStockid int = 1202, --новый склад карточки 
@NewDocDate smalldatetime = '20190304', --нова€ дата карточки
@OurID int = 12, --старый номер фирмы
@NewOurID int = 12 --новый номер фирмы
DECLARE @ChIDTable table(ChID int NULL) 
insert into @ChIDTable select ChID from it_Spec
	where DocID in (
--¬ведите Ќомера документов   	

600004195,600004196,600004197,600004198,600004199,600004185,600004186,600004203,600004189,600004190,600004191,600004192,600004193,600004194,600004200,600004201,600004202,600004204,600004205,600004206,600004208,600004209
)
	
--SELECT * FROM @ChIDTable

select @Mchid = MAX (chid)+1 from it_Spec
select @Mchid as Mchid, @Mchid + (SELECT COUNT(*) FROM @ChIDTable) EndChid

select * from it_Spec 
where OurID = @OurID and ChID in ( SELECT * FROM @ChIDTable)
	
DECLARE kalc CURSOR 
FOR
	select  chid from it_Spec 
	where OurID = @OurID and ChID in ( SELECT * FROM @ChIDTable)
OPEN kalc
FETCH NEXT FROM kalc INTO @chid 
WHILE @@FETCH_STATUS = 0    		 
BEGIN
	--select 'EXEC ip_SpecCopy   @chid,@NewOurID,@NewDocDate,@NewStockid '
	--select 'EXEC ip_SpecCopy '+  cast(@chid as varchar)+','++cast(@NewOurID as varchar)+','+CONVERT( varchar, @NewDocDate, 104)+','++cast(@NewStockid as varchar)
	IF EXISTS ( SELECT top 1 1 FROM it_Spec WHERE OurID = @NewOurID and StockID = @NewStockid and DocDate = @NewDocDate and ProdID in (SELECT ProdID FROM it_Spec WHERE ChiD = @chid) )
	BEGIN--если есть дубликат карточки
		 SELECT '≈сть дубликат карточки, карта не скопированна',* FROM it_Spec WHERE OurID = @NewOurID and StockID = @NewStockid and DocDate = @NewDocDate and ProdID in (SELECT ProdID FROM it_Spec WHERE ChiD = @chid)
	END
	ELSE
	BEGIN
		EXEC ip_SpecCopy  @chid,@NewOurID,@NewDocDate,@NewStockid
	END
	FETCH NEXT FROM kalc INTO @chid 
  END
CLOSE kalc
DEALLOCATE kalc


select * from it_Spec where ChID >= @Mchid
select * from it_SpecParams where ChID >= @Mchid

update it_SpecParams
set StockID = @NewStockid , ProdDate = @NewDocDate
from it_SpecParams where ChID >= @Mchid

select * from it_SpecParams where ChID >= @Mchid


ROLLBACK TRAN

--IF @@TRANCOUNT > 0 COMMIT TRAN ELSE ROLLBACK TRAN