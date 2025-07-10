DECLARE @PLIDs VARCHAR(MAX) = 'q28,2370.133,       444 23g'
DECLARE @Msg VARCHAR(MAX) = ''
DECLARE @DocDate smalldatetime,	@PLID int, @OurID int , @DocID int ,@ChID int

			EXEC z_NewChID 't_SEst', @ChID OUTPUT
			EXEC dbo.z_NewDocID 11032, 't_SEst', @OurID, @DocID OUTPUT  
			select @ChID, @DocID
			
SET @PLIDs = REPLACE(@PLIDs, '.', ',')
SET @PLIDs = REPLACE(@PLIDs, ' ', '')

	--проверка на запрещеные символы 
	DECLARE @pos INT = 1, @err VarChar(max) = '', @txt VarChar(max) = @PLIDs
	WHILE @pos <= LEN(@txt)
	BEGIN
		IF SUBSTRING(@txt,@pos,1) NOT LIKE '[0-9,.;]'
			SET @err = @err + SUBSTRING(@txt,@pos,1) + ' '
		SET @pos = @pos + 1
	END
	
	IF @err <> ''
	BEGIN
		RAISERROR ('PROCEDURE [dbo].[ap_Copy_t_SEst]. Следующие символы запрещены в номерах прайсов: %s', 18, 1,@err)
		RETURN  
	END
	



SELECT * FROM dbo.zf_FilterToTable(@PLIDs) WHERE ISNUMERIC(AValue) = 0 

SELECT top 1 1 FROM dbo.zf_FilterToTable(@PLIDs) WHERE AValue NOT IN (SELECT PLID FROM r_PLs)
SELECT AValue FROM dbo.zf_FilterToTable(@PLIDs) WHERE AValue NOT IN (SELECT PLID FROM r_PLs)

SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10))
      FROM dbo.zf_FilterToTable(@PLIDs) WHERE AValue NOT IN (SELECT PLID FROM r_PLs)
SELECT @Msg = SUBSTRING(@Msg,2,65535) 
SELECT @Msg    
      
SELECT PLID FROM r_PLs WHERE PLID  IN (SELECT AValue FROM dbo.zf_FilterToTable(@PLIDs))




	SELECT * FROM t_SEst where ChID = 6201
	SELECT * FROM t_SEstD where ChID = 6201
	
	SELECT ChID_Start, ChID_End FROM r_DBIs WHERE DBiID = dbo.zf_Var('OT_DBiID')
	
	
	
	BEGIN TRAN
	
	
		EXEC [dbo].[ap_Copy_t_SEst]  @ChID = null, @PLIDs = '70.83,28.45'
		
	SELECT * FROM t_SEst where ChID = 6201
	SELECT * FROM t_SEstD where ChID = 6201
	SELECT * FROM t_SEst where ChID > 6201
	SELECT * FROM t_SEstD where ChID > 6201
	
	ROLLBACK TRAN
	\\
SELECT PriceMC
      FROM r_ProdMP WITH(NOLOCK)  
      WHERE ProdID = @ProdID AND PLID = 	
      
 SELECT * FROM      r_ProdMP
 
 SELECT * FROM t_Rem
 
 
 SELECT top 1 PriceMC FROM r_ProdMP mp WITH(NOLOCK) WHERE mp.ProdID = 600003 AND mp.PLID = 85