--Use it on [S-VINTAGE].
BEGIN TRAN;

DECLARE @DCardID VARCHAR(100) = '2250000003213'
	   ,@InsertMode BIT = 0						--!!!!!!!!!Если @InsertMode = 0, то это проверочный режим (в базу ничего НЕ попадет). @InsertMode = 1 - вставка всех значений в базу.
	   ,@MRChID INT
DECLARE @DCardChID INT = (SELECT ChID FROM r_DCards where DCardID = @DCardID)
DECLARE @Price NUMERIC(21,9) = (SELECT PriceMC FROM r_ProdMP WHERE PLID = 70 AND ProdID = (SELECT ProdID FROM r_DCTypes WHERE DCTypeCode = (SELECT DCTypeCode FROM r_DCards where DCardID = @DCardID) ) )


IF 1 = 1
BEGIN
	IF @InsertMode = 0
	BEGIN
		
		SELECT 'Info about DCard'
		SELECT * FROM r_DCards where DCardID = @DCardID
		
		EXEC z_NewChID 't_Sale', @MRChID OUTPUT
		
		SELECT 'In t_Sale'
		SELECT @MRChID,@MRChID,GETDATE(),0,0,0,0,0,0,0,0,0,0,'Empty sale for activated certificate',777,1,'',GETDATE(),0,NULL,NULL,0,NULL,0,0,0,0,0,0,0,0,0,0,0.000000000,0.000000000,GETDATE(),0,0,0,NULL,NULL,NULL,0,0.000000000,0.000000000,0,777,NULL
		
		SELECT 'In z_DocDC'
		SELECT 11035,@MRChID,@DCardChID
		
		SELECT 'In z_LogDiscRec'
		SELECT MAX(LogID) + 1,0,11035,@MRChID,NULL,0,@Price,GETDATE(),0,NULL,dbo.zf_Var('OT_DBiID'),@DCardChID
		FROM z_LogDiscRec
	END;

	IF @InsertMode = 1
	BEGIN
		EXEC z_NewChID 't_Sale', @MRChID OUTPUT
		UPDATE r_DCards SET InUse = 1 where DCardID = @DCardID
		INSERT INTO t_Sale
		SELECT @MRChID,@MRChID,GETDATE(),0,0,0,0,0,0,0,0,0,0,'Empty sale for activated certificate',777,1,'',GETDATE(),0,NULL,NULL,0,NULL,0,0,0,0,0,0,0,0,0,0,0.000000000,0.000000000,GETDATE(),0,0,0,NULL,NULL,NULL,0,0.000000000,0.000000000,0,777,NULL
		INSERT INTO z_DocDC
		SELECT 11035,@MRChID,@DCardChID
		INSERT INTO z_LogDiscRec
		SELECT MAX(LogID) + 1,0,11035,@MRChID,NULL,0,@Price,GETDATE(),0,NULL,dbo.zf_Var('OT_DBiID'),@DCardChID
		FROM z_LogDiscRec
	END;

END;

ROLLBACK TRAN;
/*
SELECT * FROM r_DCards where DCardID = '2250000003213'

SELECT * FROM z_LogDiscRec
--WHERE DCardChID = 200021138
WHERE LogID = 101752452

SELECT * FROM z_DocDC
WHERE DCardChID = 200021138

--UPDATE z_LogDiscRec SET DBiID = 15 WHERE LogID = 101752452 
--UPDATE r_Users SET UseOpenAge = 0 WHERE ChID = 2047 

DELETE t_Sale WHERE ChID = 1500000804
DELETE z_DocDC WHERE ChID = 1500000804
DELETE z_LogDiscRec WHERE LogID = 101752452

tf_GetDCardPaySum
t_DiscGetPosPrice
t_SaleDCardEnter

SELECT * FROM z_LogDiscRec WITH(NOLOCK) WHERE DCardChID = 200021138
SELECT * FROM z_LogDiscExp WITH(NOLOCK) WHERE DCardChID = 200021138

SELECT * FROM dbo.tf_DocDCards(1011, 1500000000, 2)
SELECT dbo.tf_GetDCardInfo(1011, 1500000000, '2250000003213', 2, 0)
SELECT dbo.tf_GetDCardInfo(1011, 1500000000, '2250000003213', 2, 0)
EXEC t_SaleGetDCPays 1011, 1500000001

r_DCTypes 
r_OperCRs
SELECT * FROM t_Sale ORDER BY 1 DESC

SELECT * FROM r_ProdMP WHERE ProdId = 601282
*/