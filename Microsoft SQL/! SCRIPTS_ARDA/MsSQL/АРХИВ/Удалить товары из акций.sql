-- Удалить товары из акций
-- не забудь перегенерировать процедуры в приложении Акции после обновления списка акционных товаров
USE ElitR

BEGIN TRAN

DECLARE @Update int = 0  -- 1 - обновить 
						 -- 0 - не обновлять
		,@Filter47 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 47 )
		,@Filter68_15 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '15')
		,@Filter68_20 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20')
		,@Msg VARCHAR(MAX) = ''
--SELECT @Filter
DECLARE @ProdIDTable table(ProdID int NULL) 
insert into @ProdIDTable select ProdID from r_Prods	where ProdID in (
--исключить эти товары из фильтра
--1+1
602897,602896,600732,600733,600735,600274,802205
)
--SELECT ProdID FROM @ProdIDTable	
SET @Msg = ''	
SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10)) FROM (	SELECT * FROM dbo.zf_FilterToTable(@Filter47)
WHERE AValue  not in (SELECT ProdID FROM @ProdIDTable)) mmm
SET @Msg = SUBSTRING(@Msg,2,65535)
SELECT @Filter47 'было',len(@Filter47),dbo.af_FilterToFilter(@Msg) Filter47_Количественная_акция,len(dbo.af_FilterToFilter(@Msg))

--SELECT @Filter47
if @Update = 1
	update rdsd
	set rdsd.PProdFilter = (SELECT dbo.af_FilterToFilter(@Msg))
	FROM r_DiscSaleD rdsd
	JOIN r_Discs rd	  ON rdsd.DiscCode = rd.DiscCode 
	WHERE rd.DiscCode = 47
	
SET @Msg = ''	
SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10)) FROM (	SELECT * FROM dbo.zf_FilterToTable(@Filter68_15)
WHERE AValue  not in (SELECT ProdID FROM @ProdIDTable)) mmm
SET @Msg = SUBSTRING(@Msg,2,65535)
SELECT @Filter68_15 'было',len(@Filter68_15),dbo.af_FilterToFilter(@Msg) Filter68_15_Супермаркет_на_торжественные_события,len(dbo.af_FilterToFilter(@Msg))

if @Update = 1
	update rdsd
	set rdsd.PProdFilter = (SELECT dbo.af_FilterToFilter(@Msg))
	FROM r_Discs rd	
	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode 
	WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '15'
	
SET @Msg = ''	
SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10)) FROM (	SELECT * FROM dbo.zf_FilterToTable(@Filter68_20)
WHERE AValue  not in (SELECT ProdID FROM @ProdIDTable)) mmm
SET @Msg = SUBSTRING(@Msg,2,65535)
SELECT @Filter68_20 'было',len(@Filter68_20),dbo.af_FilterToFilter(@Msg) Filter68_20_Супермаркет_на_торжественные_события,len(dbo.af_FilterToFilter(@Msg))

if @Update = 1
	update rdsd
	set rdsd.PProdFilter = (SELECT dbo.af_FilterToFilter(@Msg))
	FROM r_Discs rd	
	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode 
	WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20'
	
	--SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 47 

ROLLBACK TRAN	




--select cast(SELECT top 1 rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20' as varchar(max))