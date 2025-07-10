-- Удалить товары из акций

USE ElitR

--SELECT * FROM dbo.z_Tables zt	WHERE zt.TableName	= 'r_Prods'
--r_DiscSaleD - Справочник акций: Скидка по товарам --SELECT * FROM dbo.r_DiscSaleD rdsd WHERE DiscCode IN (47, 68)
--r_Discs - Справочник акций --SELECT * FROM dbo.r_Discs rd WHERE DiscCode IN (47, 68)
--r_Prods - Справочник товаров	--SELECT * FROM dbo.r_Prods rp
--PProdFilter - список товаров с установленной скидкой
--DiscCode - код скидки
				
BEGIN TRAN

DECLARE  @Update	   int = 0 -- ВЫБРАТЬ: 1 - обновить, 0 - не обновлять.
		,@Update_47    int = 0 -- ВЫБРАТЬ: 1 - обновить, 0 - не обновлять (Количественная_акция).
		,@Update_68_15 int = 0 -- ВЫБРАТЬ: 1 - обновить, 0 - не обновлять (15% Супермаркет_на_торжественные_события).
		,@Update_68_20 int = 0 -- ВЫБРАТЬ: 1 - обновить, 0 - не обновлять (20% Супермаркет_на_торжественные_события).
		,@Filter47	   VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 47)
		,@Filter68_151 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '15' and rdsd.SrcPosID = 151)
		,@Filter68_152 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '15' and rdsd.SrcPosID = 152)
		,@Filter68_201 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20' and rdsd.SrcPosID = 201)
		,@Filter68_202 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20' and rdsd.SrcPosID = 202)
		,@Msg		   VARCHAR(MAX) = ''

--SELECT @Filter
DECLARE @ProdIDTable table(ProdID int NULL) 
INSERT INTO	@ProdIDTable SELECT ProdID FROM r_Prods	WHERE ProdID in (
--исключить эти товары из фильтра
--1+1
803712,600212,600072,600073,602508,601093,601094,802206,600076,600077,604851,604850,603891,600325,802406,802405,802403,600080,602280,600274,802205
)

--SELECT ProdID FROM @ProdIDTable	
SET @Msg = ''	
SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10)) FROM (	SELECT * FROM dbo.zf_FilterToTable(@Filter47)
WHERE AValue  not in (SELECT ProdID FROM @ProdIDTable)) mmm
SET @Msg = SUBSTRING(@Msg,2,65535)
SELECT @Filter47 'было',len(@Filter47),dbo.af_FilterToFilter(@Msg) Filter47_Количественная_акция,len(dbo.af_FilterToFilter(@Msg))

--SELECT @Filter47
if @Update = 0
	UPDATE rdsd
	SET rdsd.PProdFilter = (SELECT dbo.af_FilterToFilter(@Msg))
	FROM r_DiscSaleD rdsd
	JOIN r_Discs rd	  ON rdsd.DiscCode = rd.DiscCode 
	WHERE rd.DiscCode = 47
	
SET @Msg = ''	
SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10)) FROM (	SELECT * FROM dbo.zf_FilterToTable(@Filter68_151 + ',' + @Filter68_152)
WHERE AValue  not in (SELECT ProdID FROM @ProdIDTable)) mmm
SET @Msg = SUBSTRING(@Msg,2,65535)
SELECT @Filter68_151 + ',' + @Filter68_152 'было',len(@Filter68_151 + ',' + @Filter68_152),dbo.af_FilterToFilter(@Msg) Filter68_15_Супермаркет_на_торжественные_события,len(dbo.af_FilterToFilter(@Msg))

IF @Update = 1
	UPDATE rdsd
	SET rdsd.PProdFilter = (SELECT dbo.af_FilterToFilter(@Msg))
	FROM r_Discs rd	
	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode 
	WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '15'
	
SET @Msg = ''	
SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10)) FROM (	SELECT * FROM dbo.zf_FilterToTable(@Filter68_201)
WHERE AValue  not in (SELECT ProdID FROM @ProdIDTable)) mmm
SET @Msg = SUBSTRING(@Msg,2,65535)
SELECT @Filter68_201 'было',len(@Filter68_201),dbo.af_FilterToFilter(@Msg) Filter68_20_Супермаркет_на_торжественные_события,len(dbo.af_FilterToFilter(@Msg))

IF @Update = 1
	UPDATE rdsd
	SET rdsd.PProdFilter = (SELECT dbo.af_FilterToFilter(@Msg))
	FROM r_Discs rd	
	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode 
	WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20'
	
	--SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 47 

ROLLBACK TRAN	

-- !ВАЖНО! перегенерировать процедуры приложении Акции
--select cast(SELECT top 1 rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20' as varchar(max))