-- ������� ������ �� �����
-- �� ������ ���������������� ��������� � ���������� ����� ����� ���������� ������ ��������� �������
USE ElitR

BEGIN TRAN

DECLARE @Update int = 0  -- 1 - �������� 
						 -- 0 - �� ���������
		,@Filter47 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 47 )
		,@Filter68_15 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '15')
		,@Filter68_20 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20')
		,@Msg VARCHAR(MAX) = ''
--SELECT @Filter
DECLARE @ProdIDTable table(ProdID int NULL) 
insert into @ProdIDTable select ProdID from r_Prods	where ProdID in (
--��������� ��� ������ �� �������
--1+1
602897,602896,600732,600733,600735,600274,802205
)
--SELECT ProdID FROM @ProdIDTable	
SET @Msg = ''	
SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10)) FROM (	SELECT * FROM dbo.zf_FilterToTable(@Filter47)
WHERE AValue  not in (SELECT ProdID FROM @ProdIDTable)) mmm
SET @Msg = SUBSTRING(@Msg,2,65535)
SELECT @Filter47 '����',len(@Filter47),dbo.af_FilterToFilter(@Msg) Filter47_��������������_�����,len(dbo.af_FilterToFilter(@Msg))

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
SELECT @Filter68_15 '����',len(@Filter68_15),dbo.af_FilterToFilter(@Msg) Filter68_15_�����������_��_�������������_�������,len(dbo.af_FilterToFilter(@Msg))

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
SELECT @Filter68_20 '����',len(@Filter68_20),dbo.af_FilterToFilter(@Msg) Filter68_20_�����������_��_�������������_�������,len(dbo.af_FilterToFilter(@Msg))

if @Update = 1
	update rdsd
	set rdsd.PProdFilter = (SELECT dbo.af_FilterToFilter(@Msg))
	FROM r_Discs rd	
	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode 
	WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20'
	
	--SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 47 

ROLLBACK TRAN	




--select cast(SELECT top 1 rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20' as varchar(max))