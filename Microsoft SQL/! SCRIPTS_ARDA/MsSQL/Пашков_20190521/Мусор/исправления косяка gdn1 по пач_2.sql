BEGIN TRAN
SET XACT_ABORT  ON



DECLARE 
@ProdID INT = 604221
,@BarCode varchar(250) = '@@@48209731'

SELECT * FROM [10.1.0.155].ElitR.dbo.r_ProdMQ
WHERE ProdID = @ProdID
ORDER BY 1

SELECT * FROM dbo.r_ProdMQ
WHERE ProdID = @ProdID
ORDER BY 1

SELECT * FROM dbo.r_ProdMQ
WHERE ProdID = @ProdID and BarCode = @BarCode

update dbo.r_ProdMQ
set UM = UM + '0'
WHERE ProdID = @ProdID and BarCode = @BarCode

SELECT * FROM dbo.r_ProdMQ
WHERE ProdID = @ProdID and BarCode = @BarCode

SELECT * FROM dbo.r_ProdMQ
WHERE ProdID = @ProdID 

update dbo.r_ProdMQ
set UM = '���_2'
WHERE ProdID = @ProdID and UM = '���_3'

SELECT * FROM dbo.r_ProdMQ
WHERE ProdID = @ProdID 



ROLLBACK TRAN
