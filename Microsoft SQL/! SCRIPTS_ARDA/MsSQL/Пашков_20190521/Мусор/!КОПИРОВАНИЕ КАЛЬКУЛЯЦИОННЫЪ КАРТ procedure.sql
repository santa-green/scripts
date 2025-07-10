
alter PROCEDURE ip_SpecCopyAll @NewStockid int, @NewDocDate smalldatetime, @NewOurID int, @OurID int, @DocIDs VARCHAR(MAX)
AS
BEGIN

/* опирует калькул€ционные карты с фирмы @OurID и номерами @DocIDs на новый склад @NewStockid новую дату @NewDocDate и новую фирму @NewOurID*/

/*
BEGIN TRAN
	EXEC ip_SpecCopyAll @NewStockid = 1202, @NewDocDate = '20190304', @NewOurID = 12, @OurID = 12, @DocIDs = '600004195,600004196,600004197,600004198,600004199,600004185,600004186,600004203,600004189,600004190,600004191,600004192,600004193,600004194,600004200,600004201,600004202,600004204,600004205,600004206,600004208,600004209'
ROLLBACK TRAN
*/	
	DECLARE @Mchid int, @chid INT
	--,@NewStockid int = 1202, --новый склад карточки 
	--@NewDocDate smalldatetime = '20190216', --нова€ дата карточки
	--@NewOurID int = 12, --новый номер фирмы
	--@OurID int = 12, --старый номер фирмы
	----¬ведите Ќомера документов   	
	--@DocIDs VARCHAR(MAX) = '600002573,600002574,600002575,600002576,600002577,600002553,600002555,600002556,600002557,600002560,600002561,600002562,600002565,600002566,600002568,600002578,600002579,600003417,600003518,600003852,600003853,600003854'

	DECLARE @ChIDTable table(ChID int NULL) 
	insert into @ChIDTable select ChID from it_Spec
		where DocID in (SELECT AValue from zf_FilterToTable(@DocIDs))
	
	
	--SELECT * FROM @ChIDTable

	BEGIN TRAN

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

	IF @@TRANCOUNT > 0 COMMIT TRAN ELSE ROLLBACK TRAN

END

