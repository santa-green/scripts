USE ElitV_DP_Test_Rkiper
GO

/****** Object:  Table dbo.t_VenA_tmp    Script Date: 01/30/2017 10:36:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE dbo.t_VenA_tmp(
	ChID int NOT NULL,
	ProdID int NOT NULL,
	UM varchar(10) NOT NULL,
	TQty numeric(21, 9) NOT NULL,
	TNewQty numeric(21, 9) NOT NULL,
	TSumCC_nt numeric(21, 9) NOT NULL,
	TTaxSum numeric(21, 9) NOT NULL,
	TSumCC_wt numeric(21, 9) NOT NULL,
	TNewSumCC_nt numeric(21, 9) NOT NULL,
	TNewTaxSum numeric(21, 9) NOT NULL,
	TNewSumCC_wt numeric(21, 9) NOT NULL,
	BarCode varchar(42) NOT NULL,
	Norma1 numeric(21, 9) NOT NULL,
	TSrcPosID int NOT NULL,
	HandCorrected bit NOT NULL

        '  ChID int NOT NULL,						'#13+
        '  ProdID int NOT NULL,						'#13+
        '  UM varchar(10) NOT NULL,					'#13+
        '  TQty numeric(21, 9) NOT NULL,			'#13+
        '  TNewQty numeric(21, 9) NOT NULL,			'#13+
        '  TSumCC_nt numeric(21, 9) NOT NULL,       '#13+
        '  TTaxSum numeric(21, 9) NOT NULL,         '#13+
        '  TSumCC_wt numeric(21, 9) NOT NULL,       '#13+
        '  TNewSumCC_nt numeric(21, 9) NOT NULL,	'#13+
        '  TNewTaxSum numeric(21, 9) NOT NULL,      '#13+
        '  TNewSumCC_wt numeric(21, 9) NOT NULL,    '#13+
        '  BarCode varchar(42) NOT NULL,            '#13+
        '  Norma1 numeric(21, 9) NOT NULL,          '#13+
		'  TSrcPosID int NOT NULL,					'#13+
		
		
		
		'  HandCorrected bit NOT NULL				'#13+
		
		
		
        '  ChID INT NOT NULL,					                 	'#13+
        '  ProdID INT NOT NULL,					                '#13+
        '  UM VARCHAR(10) NOT NULL,				             '#13+
        '  TQty NUMERIC(21,9) NOT NULL,		  	         '#13+
        '  TNewQty NUMERIC(21, 9) NOT NULL,		      	'#13+
        '  TSumCC_nt NUMERIC(21, 9) NOT NULL,       '#13+
        '  TTaxSum NUMERIC(21, 9) NOT NULL,         '#13+
        '  TSumCC_wt NUMERIC(21, 9) NOT NULL,       '#13+
        '  TNewSumCC_nt NUMERIC(21, 9) NOT NULL,   	'#13+
        '  TNewTaxSum NUMERIC(21, 9) NOT NULL,      '#13+
        '  TNewSumCC_wt NUMERIC(21, 9) NOT NULL,    '#13+
        '  BarCode VARCHAR(42) NOT NULL,            '#13+
        '  Norma1 NUMERIC(21, 9) NOT NULL,          '#13+
	      	'  TSrcPosID INT NOT NULL,					             '#13+
	      	'  HandCorrected BIT NOT NULL				           '#13+		
	      	
	      	
t_vena_tmp

DELETE dbo.t_VenA_tmp WHERE UserID = dbo.zf_GetUserCode()

SELECT * FROM tempdb.dbo.sysobjects WHERE id = OBJECT_ID('tempdb.' + CURRENT_USER + '.##TVenA') and xtype in (N'U')

SELECT * FROM tempdb.dbo.sysobjects WHERE name = 'TVenA'

select OBJECT_ID('TVenA') 
