
--ALTER PROC [dbo].[ap_Copy_it_CancPrice] 
DECLARE @ChID INT = 6417, @Stocks VARCHAR(200) = '1201,1252,1260'
--AS
BEGIN tran
/* Процедура дублирования документов Спецификации поставщика с другими складами*/  
	/*
	EXEC [dbo].[ap_Copy_it_CancPrice]  @ChID = 6417, @Stocks = '1201,1252,1260'
	EXEC [dbo].[ap_Copy_it_CancPrice]  @ChID = 6417, @Stocks = '1201'
	*/
	DECLARE @Msg VARCHAR(MAX) = '',	@DocDate smalldatetime,	@Stock int, @OurID int , @NewChID int, @NewDocID int, @NewPLID int
	
	IF @ChID IS NULL RAISERROR ('PROCEDURE [dbo].[ap_Copy_it_CancPrice]. @ChID IS NULL', 18, 1)
	
	--проверка на пустой список прайсов
	IF @Stocks = ''
	BEGIN
		RAISERROR ('PROCEDURE [dbo].[ap_Copy_it_CancPrice]. Не заполнено поле склады', 18, 1)
		RETURN  
	END

	--замена точек запятыми
	SET @Stocks = REPLACE(@Stocks, '.', ',')
	--удаление пробелов
	SET @Stocks = REPLACE(@Stocks, ' ', '')
	
	--проверка на запрещеные символы 
	DECLARE @pos INT = 1, @err VarChar(max) = '', @txt VarChar(max) = @Stocks
	WHILE @pos <= LEN(@txt)
	BEGIN
		IF SUBSTRING(@txt,@pos,1) NOT LIKE '[0-9,.;]'
			SET @err = @err + SUBSTRING(@txt,@pos,1) + ' '
		SET @pos = @pos + 1
	END
	
	IF @err <> ''
	BEGIN
		RAISERROR ('PROCEDURE [dbo].[ap_Copy_it_CancPrice]. Следующие символы запрещены в номерах прайсов: %s', 18, 1,@err)
		RETURN  
	END
	
	--проверка наличия склада в справочнике
	IF EXISTS (SELECT top 1 1 FROM dbo.zf_FilterToTable(@Stocks) WHERE AValue NOT IN (SELECT StockID FROM r_Stocks))
	BEGIN
		SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10)) FROM dbo.zf_FilterToTable(@Stocks) WHERE AValue NOT IN (SELECT StockID FROM r_Stocks)
		SELECT @Msg = SUBSTRING(@Msg,2,65535) -- обрезаем запятую спереди
		RAISERROR ('PROCEDURE [dbo].[ap_Copy_it_CancPrice]. Отсутствуют склады в справочнике: %s', 18, 1,@Msg)
		RETURN  
	END
		
	--ограничение доступа к процедуре
	IF SUSER_NAME() NOT IN ('pvm0', 'sao', 'CORP\Cluster', 'dmv2', 'const\pashkovv')
	BEGIN
		RAISERROR ('PROCEDURE [dbo].[ap_Copy_it_CancPrice]. У Вас нет доступа', 18, 1)
		RETURN  
	END
	
	--дата, фирма и склад текущего документа
	SELECT @DocDate = DocDate, @OurID = OurID, @Stock = StockID FROM it_CancPrice WHERE ChID = @ChID


	--SET XACT_ABORT ON  

	--BEGIN TRAN
	
		--курсор прайсов по которым будут дубликаты документов
		DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
		FOR 
		SELECT AValue FROM dbo.zf_FilterToTable(@Stocks) WHERE AValue <> @Stock ORDER BY 1

		OPEN CURSOR1
			FETCH NEXT FROM CURSOR1 INTO @Stock
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--Script
			--Получаем новые ChID  и DocID
			EXEC z_NewChID 'it_CancPrice', @NewChID OUTPUT
			SET @NewDocID = ISNULL((SELECT MAX(DocID) FROM it_CancPrice WHERE OurID = @OurID), 0) + 1
			
			select @NewChID
			
			
			--Создаем новый заголовок it_CancPrice
			INSERT it_CancPrice
				SELECT @NewChID ChID,OurID,@Stock StockID,DocDate,@NewDocID DocID,PriceType,CompID
				FROM it_CancPrice WHERE ChID = @ChID
				
			--Копируем детали в  it_CancPriceD
			INSERT it_CancPriceD
				SELECT @NewChID ChID,ProdID,PriceCC,UM,SrcPosID 
				FROM it_CancPriceD d WHERE ChID = @ChID
			
			FETCH NEXT FROM CURSOR1 INTO @Stock
		END
		CLOSE CURSOR1
		DEALLOCATE CURSOR1

	--IF @@TRANCOUNT > 0 
	  --COMMIT TRAN

	  SELECT * FROM it_CancPrice where ChID = @ChID
	  SELECT * FROM it_CancPriceD where ChID = @ChID ORDER BY 1, SrcPosID
	  
	  
	  	  
	  SELECT * FROM it_CancPrice where ChID >= 6498
	  SELECT * FROM it_CancPriceD where ChID >= 6498 ORDER BY 1, SrcPosID
rollback tran

                                   



GO
