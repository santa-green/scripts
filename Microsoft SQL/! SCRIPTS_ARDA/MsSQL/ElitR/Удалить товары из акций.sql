-- ������� ������ �� �����

USE ElitR

--SELECT * FROM dbo.z_Tables zt	WHERE zt.TableName	= 'r_Prods'
--r_DiscSaleD - ���������� �����: ������ �� ������� --SELECT * FROM dbo.r_DiscSaleD rdsd WHERE DiscCode IN (47, 68)
--r_Discs - ���������� ����� --SELECT * FROM dbo.r_Discs rd WHERE DiscCode IN (47, 68)
--r_Prods - ���������� �������	--SELECT * FROM dbo.r_Prods rp
--PProdFilter - ������ ������� � ������������� �������
--DiscCode - ��� ������
				
BEGIN TRAN

DECLARE  @Update	   int = 0 -- �������: 1 - ��������, 0 - �� ���������.
		,@Update_47    int = 0 -- �������: 1 - ��������, 0 - �� ��������� (��������������_�����).
		,@Update_68_15 int = 0 -- �������: 1 - ��������, 0 - �� ��������� (15% �����������_��_�������������_�������).
		,@Update_68_20 int = 0 -- �������: 1 - ��������, 0 - �� ��������� (20% �����������_��_�������������_�������).
		,@Filter47	   VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 47)
		,@Filter68_151 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '15' and rdsd.SrcPosID = 151)
		,@Filter68_152 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '15' and rdsd.SrcPosID = 152)
		,@Filter68_201 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20' and rdsd.SrcPosID = 201)
		,@Filter68_202 VARCHAR(MAX) = (SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20' and rdsd.SrcPosID = 202)
		,@Msg		   VARCHAR(MAX) = ''

--SELECT @Filter
DECLARE @ProdIDTable table(ProdID int NULL) 
INSERT INTO	@ProdIDTable SELECT ProdID FROM r_Prods	WHERE ProdID in (
--��������� ��� ������ �� �������
--1+1
803712,600212,600072,600073,602508,601093,601094,802206,600076,600077,604851,604850,603891,600325,802406,802405,802403,600080,602280,600274,802205
)

--SELECT ProdID FROM @ProdIDTable	
SET @Msg = ''	
SELECT @Msg = @Msg + ',' + CAST(AValue AS VARCHAR(10)) FROM (	SELECT * FROM dbo.zf_FilterToTable(@Filter47)
WHERE AValue  not in (SELECT ProdID FROM @ProdIDTable)) mmm
SET @Msg = SUBSTRING(@Msg,2,65535)
SELECT @Filter47 '����',len(@Filter47),dbo.af_FilterToFilter(@Msg) Filter47_��������������_�����,len(dbo.af_FilterToFilter(@Msg))

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
SELECT @Filter68_151 + ',' + @Filter68_152 '����',len(@Filter68_151 + ',' + @Filter68_152),dbo.af_FilterToFilter(@Msg) Filter68_15_�����������_��_�������������_�������,len(dbo.af_FilterToFilter(@Msg))

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
SELECT @Filter68_201 '����',len(@Filter68_201),dbo.af_FilterToFilter(@Msg) Filter68_20_�����������_��_�������������_�������,len(dbo.af_FilterToFilter(@Msg))

IF @Update = 1
	UPDATE rdsd
	SET rdsd.PProdFilter = (SELECT dbo.af_FilterToFilter(@Msg))
	FROM r_Discs rd	
	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode 
	WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20'
	
	--SELECT rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 47 

ROLLBACK TRAN	

-- !�����! ���������������� ��������� ���������� �����
--select cast(SELECT top 1 rdsd.PProdFilter FROM r_Discs rd	JOIN  r_DiscSaleD rdsd ON rdsd.DiscCode = rd.DiscCode WHERE rd.DiscCode = 68 and SUBSTRING(rdsd.LDiscountExp,1,2) = '20' as varchar(max))