
BEGIN TRAN

DECLARE @n int = (SELECT MAX(ChID) FROM r_Prods_)
SELECT @n

;DISABLE TRIGGER ALL ON r_Prods_;  

insert r_Prods_

SELECT ROW_NUMBER()OVER(ORDER BY ChID) + @n as ChID
      ,[ProdID]
      ,ProdName + '&A N' as ProdName
      ,'набір' UM
      ,[Country]
      ,Notes + '&A N' as Notes
      ,[PCatID]
      ,[PGrID]
      ,[Article1]
      ,[Article2]
      ,[Article3]
      ,[Weight]
      ,[Age]
      ,[TaxPercent]
      ,[PriceWithTax]
      ,[Note1]
      ,[Note2]
      ,[Note3]
      ,[MinPriceMC]
      ,[MaxPriceMC]
      ,[MinRem]
      ,[CstDty]
      ,[CstPrc]
      ,[CstExc]
      ,[StdExtraR]
      ,[StdExtraE]
      ,[MaxExtra]
      ,[MinExtra]
      ,[UseAlts]
      ,[UseCrts]
      ,[PGrID1]
      ,[PGrID2]
      ,[PGrID3]
      ,[PGrAID]
      ,[PBGrID]
      ,[LExpSet]
      ,[EExpSet]
      ,[InRems]
      ,[IsDecQty]
      ,[File1]
      ,[File2]
      ,[File3]
      ,[AutoSet]
      ,[Extra1]
      ,[Extra2]
      ,[Extra3]
      ,[Extra4]
      ,[Extra5]
      ,[Norma1]
      ,[Norma2]
      ,[Norma3]
      ,[Norma4]
      ,[Norma5]
      ,[RecMinPriceCC]
      ,[RecMaxPriceCC]
      ,[RecStdPriceCC]
      ,[RecRemQty]
      ,[InStopList]
      ,[PrepareTime]
      ,[AmortID]
      ,[WeightGr]
      ,[WeightGrWP]
      ,[PGrID4]
      ,[PGrID5]
      ,[DistrID]
      ,[ImpID]
      ,CstProdCode AS [FEAprodID]
      ,[ScaleGrID]
      ,[ScaleStandard]
      ,[ScaleConditions]
      ,[ScaleComponents]
      ,[ExcCostCC]
      ,[CstDtyNotes]
      ,[CstExcNotes]
      ,[BoxVolume]
      ,[SalesChannelID]
      ,[IndRetPriceCC]
      ,[IndWSPriceCC]
      ,[SupID]
  FROM [s-sql-d4].[Elit].[dbo].[r_Prods] a
	JOIN [s-sql-d4].[Elit].[dbo].[r_TaxRates] b ON b.TaxTypeID = a.TaxTypeID
where a.ProdID in (
30767,26135,26136,26137,26133,26139,4165,4167,4149,21398,24412,28574,32060,32791,31629,32784,28240,28241,23775,23774,24549,23776,31391,32035,31389,32032,32549,32602,33715,31970,32465,31271,31963,32467,32434,32150,32996,31833,32453,32699,31283,32444,31280,31760,31922,32446,33438,32149,33299,33296,32445,33300,32345,31363,32083,32558,31618,32048,32573,30755,31451,32045,32850,32574,30726,31395,28958,28957,28261,28978,3499,29054,30691,32164,27761,31853,29873,29880,31910,32300,32893,31909,32301,29808,33219,32433,32998,31306,32479,33025,32107,32378,30715,31441,30894,32665,31828,32666,31965,32610,32167,32543,33610,32542,33711,31324,32111,32485,31439,31574,31794,31795,32020,31934,31959,31957,31958,31960,32147,32168,33255,33244,31947,31950,32180,32317,32236,32237,32595,32370,32373,32550,32387,32551,32447,33577,32438,32393,32394,32397,32389,32654,32390,32655,32414,32384,32385,32718,32719,32630,33086,32649,33246,32650,32993,33095,33714,33098
)

--update r_Prods_ set ProdID = 634000 where ProdID = 30767
begin
update r_Prods_ set ProdID = 634000 where ProdID = 30767
update r_Prods_ set ProdID = 634001 where ProdID = 26135
update r_Prods_ set ProdID = 634002 where ProdID = 26136
update r_Prods_ set ProdID = 634003 where ProdID = 26137
update r_Prods_ set ProdID = 634004 where ProdID = 26133
update r_Prods_ set ProdID = 634005 where ProdID = 26139
update r_Prods_ set ProdID = 634006 where ProdID = 4165
update r_Prods_ set ProdID = 634007 where ProdID = 4167
update r_Prods_ set ProdID = 634008 where ProdID = 4149
update r_Prods_ set ProdID = 634009 where ProdID = 21398
update r_Prods_ set ProdID = 634010 where ProdID = 24412
update r_Prods_ set ProdID = 634011 where ProdID = 28574
update r_Prods_ set ProdID = 634012 where ProdID = 32060
update r_Prods_ set ProdID = 634013 where ProdID = 32791
update r_Prods_ set ProdID = 634014 where ProdID = 31629
update r_Prods_ set ProdID = 634015 where ProdID = 32784
update r_Prods_ set ProdID = 634016 where ProdID = 28240
update r_Prods_ set ProdID = 634017 where ProdID = 28241
update r_Prods_ set ProdID = 634018 where ProdID = 23775
update r_Prods_ set ProdID = 634019 where ProdID = 23774
update r_Prods_ set ProdID = 634020 where ProdID = 24549
update r_Prods_ set ProdID = 634021 where ProdID = 23776
update r_Prods_ set ProdID = 634022 where ProdID = 31391
update r_Prods_ set ProdID = 634023 where ProdID = 32035
update r_Prods_ set ProdID = 634024 where ProdID = 31389
update r_Prods_ set ProdID = 634025 where ProdID = 32032
update r_Prods_ set ProdID = 634026 where ProdID = 32549
update r_Prods_ set ProdID = 634027 where ProdID = 32602
update r_Prods_ set ProdID = 634028 where ProdID = 33715
update r_Prods_ set ProdID = 634029 where ProdID = 31970
update r_Prods_ set ProdID = 634030 where ProdID = 32465
update r_Prods_ set ProdID = 634031 where ProdID = 31271
update r_Prods_ set ProdID = 634032 where ProdID = 31963
update r_Prods_ set ProdID = 634033 where ProdID = 32467
update r_Prods_ set ProdID = 634034 where ProdID = 32434
update r_Prods_ set ProdID = 634035 where ProdID = 32150
update r_Prods_ set ProdID = 634036 where ProdID = 32996
update r_Prods_ set ProdID = 634037 where ProdID = 31833
update r_Prods_ set ProdID = 634038 where ProdID = 32453
update r_Prods_ set ProdID = 634039 where ProdID = 32699
update r_Prods_ set ProdID = 634040 where ProdID = 31283
update r_Prods_ set ProdID = 634041 where ProdID = 32444
update r_Prods_ set ProdID = 634042 where ProdID = 31280
update r_Prods_ set ProdID = 634043 where ProdID = 31760
update r_Prods_ set ProdID = 634044 where ProdID = 31922
update r_Prods_ set ProdID = 634045 where ProdID = 32446
update r_Prods_ set ProdID = 634046 where ProdID = 33438
update r_Prods_ set ProdID = 634047 where ProdID = 32149
update r_Prods_ set ProdID = 634048 where ProdID = 33299
update r_Prods_ set ProdID = 634049 where ProdID = 33296
update r_Prods_ set ProdID = 634050 where ProdID = 32445
update r_Prods_ set ProdID = 634051 where ProdID = 33300
update r_Prods_ set ProdID = 634052 where ProdID = 32345
update r_Prods_ set ProdID = 634053 where ProdID = 31363
update r_Prods_ set ProdID = 634054 where ProdID = 32083
update r_Prods_ set ProdID = 634055 where ProdID = 32558
update r_Prods_ set ProdID = 634056 where ProdID = 31618
update r_Prods_ set ProdID = 634057 where ProdID = 32048
update r_Prods_ set ProdID = 634058 where ProdID = 32573
update r_Prods_ set ProdID = 634059 where ProdID = 30755
update r_Prods_ set ProdID = 634060 where ProdID = 31451
update r_Prods_ set ProdID = 634061 where ProdID = 32045
update r_Prods_ set ProdID = 634062 where ProdID = 32850
update r_Prods_ set ProdID = 634063 where ProdID = 32574
update r_Prods_ set ProdID = 634064 where ProdID = 30726
update r_Prods_ set ProdID = 634065 where ProdID = 31395
update r_Prods_ set ProdID = 634066 where ProdID = 28958
update r_Prods_ set ProdID = 634067 where ProdID = 28957
update r_Prods_ set ProdID = 634068 where ProdID = 28261
update r_Prods_ set ProdID = 634069 where ProdID = 28978
update r_Prods_ set ProdID = 634070 where ProdID = 3499
update r_Prods_ set ProdID = 634071 where ProdID = 29054
update r_Prods_ set ProdID = 634072 where ProdID = 30691
update r_Prods_ set ProdID = 634073 where ProdID = 32164
update r_Prods_ set ProdID = 634074 where ProdID = 27761
update r_Prods_ set ProdID = 634075 where ProdID = 31853
update r_Prods_ set ProdID = 634076 where ProdID = 29873
update r_Prods_ set ProdID = 634077 where ProdID = 29880
update r_Prods_ set ProdID = 634078 where ProdID = 31910
update r_Prods_ set ProdID = 634079 where ProdID = 32300
update r_Prods_ set ProdID = 634080 where ProdID = 32893
update r_Prods_ set ProdID = 634081 where ProdID = 31909
update r_Prods_ set ProdID = 634082 where ProdID = 32301
update r_Prods_ set ProdID = 634083 where ProdID = 29808
update r_Prods_ set ProdID = 634084 where ProdID = 33219
update r_Prods_ set ProdID = 634085 where ProdID = 32433
update r_Prods_ set ProdID = 634086 where ProdID = 32998
update r_Prods_ set ProdID = 634087 where ProdID = 31306
update r_Prods_ set ProdID = 634088 where ProdID = 32479
update r_Prods_ set ProdID = 634089 where ProdID = 33025
update r_Prods_ set ProdID = 634090 where ProdID = 32107
update r_Prods_ set ProdID = 634091 where ProdID = 32378
update r_Prods_ set ProdID = 634092 where ProdID = 30715
update r_Prods_ set ProdID = 634093 where ProdID = 31441
update r_Prods_ set ProdID = 634094 where ProdID = 30894
update r_Prods_ set ProdID = 634095 where ProdID = 32665
update r_Prods_ set ProdID = 634096 where ProdID = 31828
update r_Prods_ set ProdID = 634097 where ProdID = 32666
update r_Prods_ set ProdID = 634098 where ProdID = 31965
update r_Prods_ set ProdID = 634099 where ProdID = 32610
update r_Prods_ set ProdID = 634100 where ProdID = 32167
update r_Prods_ set ProdID = 634101 where ProdID = 32543
update r_Prods_ set ProdID = 634102 where ProdID = 33610
update r_Prods_ set ProdID = 634103 where ProdID = 32542
update r_Prods_ set ProdID = 634104 where ProdID = 33711
update r_Prods_ set ProdID = 634105 where ProdID = 31324
update r_Prods_ set ProdID = 634106 where ProdID = 32111
update r_Prods_ set ProdID = 634107 where ProdID = 32485
update r_Prods_ set ProdID = 634108 where ProdID = 31439
update r_Prods_ set ProdID = 634109 where ProdID = 31574
update r_Prods_ set ProdID = 634110 where ProdID = 31794
update r_Prods_ set ProdID = 634111 where ProdID = 31795
update r_Prods_ set ProdID = 634112 where ProdID = 32020
update r_Prods_ set ProdID = 634113 where ProdID = 31934
update r_Prods_ set ProdID = 634114 where ProdID = 31959
update r_Prods_ set ProdID = 634115 where ProdID = 31957
update r_Prods_ set ProdID = 634116 where ProdID = 31958
update r_Prods_ set ProdID = 634117 where ProdID = 31960
update r_Prods_ set ProdID = 634118 where ProdID = 32147
update r_Prods_ set ProdID = 634119 where ProdID = 32168
update r_Prods_ set ProdID = 634120 where ProdID = 33255
update r_Prods_ set ProdID = 634121 where ProdID = 33244
update r_Prods_ set ProdID = 634122 where ProdID = 31947
update r_Prods_ set ProdID = 634123 where ProdID = 31950
update r_Prods_ set ProdID = 634124 where ProdID = 32180
update r_Prods_ set ProdID = 634125 where ProdID = 32317
update r_Prods_ set ProdID = 634126 where ProdID = 32236
update r_Prods_ set ProdID = 634127 where ProdID = 32237
update r_Prods_ set ProdID = 634128 where ProdID = 32595
update r_Prods_ set ProdID = 634129 where ProdID = 32370
update r_Prods_ set ProdID = 634130 where ProdID = 32373
update r_Prods_ set ProdID = 634131 where ProdID = 32550
update r_Prods_ set ProdID = 634132 where ProdID = 32387
update r_Prods_ set ProdID = 634133 where ProdID = 32551
update r_Prods_ set ProdID = 634134 where ProdID = 32447
update r_Prods_ set ProdID = 634135 where ProdID = 33577
update r_Prods_ set ProdID = 634136 where ProdID = 32438
update r_Prods_ set ProdID = 634137 where ProdID = 32393
update r_Prods_ set ProdID = 634138 where ProdID = 32394
update r_Prods_ set ProdID = 634139 where ProdID = 32397
update r_Prods_ set ProdID = 634140 where ProdID = 32389
update r_Prods_ set ProdID = 634141 where ProdID = 32654
update r_Prods_ set ProdID = 634142 where ProdID = 32390
update r_Prods_ set ProdID = 634143 where ProdID = 32655
update r_Prods_ set ProdID = 634144 where ProdID = 32414
update r_Prods_ set ProdID = 634145 where ProdID = 32384
update r_Prods_ set ProdID = 634146 where ProdID = 32385
update r_Prods_ set ProdID = 634147 where ProdID = 32718
update r_Prods_ set ProdID = 634148 where ProdID = 32719
update r_Prods_ set ProdID = 634149 where ProdID = 32630
update r_Prods_ set ProdID = 634150 where ProdID = 33086
update r_Prods_ set ProdID = 634151 where ProdID = 32649
update r_Prods_ set ProdID = 634152 where ProdID = 33246
update r_Prods_ set ProdID = 634153 where ProdID = 32650
update r_Prods_ set ProdID = 634154 where ProdID = 32993
update r_Prods_ set ProdID = 634155 where ProdID = 33095
update r_Prods_ set ProdID = 634156 where ProdID = 33714
update r_Prods_ set ProdID = 634157 where ProdID = 33098
end

--INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634000,'набір',1.000000000,0.000000000,NULL,'634000_набір','634000_набір',0)
begin
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634000,'набір',1.000000000,0.000000000,NULL,'634000_набір','634000_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634001,'набір',1.000000000,0.000000000,NULL,'634001_набір','634001_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634002,'набір',1.000000000,0.000000000,NULL,'634002_набір','634002_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634003,'набір',1.000000000,0.000000000,NULL,'634003_набір','634003_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634004,'набір',1.000000000,0.000000000,NULL,'634004_набір','634004_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634005,'набір',1.000000000,0.000000000,NULL,'634005_набір','634005_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634006,'набір',1.000000000,0.000000000,NULL,'634006_набір','634006_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634007,'набір',1.000000000,0.000000000,NULL,'634007_набір','634007_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634008,'набір',1.000000000,0.000000000,NULL,'634008_набір','634008_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634009,'набір',1.000000000,0.000000000,NULL,'634009_набір','634009_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634010,'набір',1.000000000,0.000000000,NULL,'634010_набір','634010_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634011,'набір',1.000000000,0.000000000,NULL,'634011_набір','634011_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634012,'набір',1.000000000,0.000000000,NULL,'634012_набір','634012_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634013,'набір',1.000000000,0.000000000,NULL,'634013_набір','634013_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634014,'набір',1.000000000,0.000000000,NULL,'634014_набір','634014_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634015,'набір',1.000000000,0.000000000,NULL,'634015_набір','634015_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634016,'набір',1.000000000,0.000000000,NULL,'634016_набір','634016_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634017,'набір',1.000000000,0.000000000,NULL,'634017_набір','634017_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634018,'набір',1.000000000,0.000000000,NULL,'634018_набір','634018_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634019,'набір',1.000000000,0.000000000,NULL,'634019_набір','634019_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634020,'набір',1.000000000,0.000000000,NULL,'634020_набір','634020_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634021,'набір',1.000000000,0.000000000,NULL,'634021_набір','634021_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634022,'набір',1.000000000,0.000000000,NULL,'634022_набір','634022_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634023,'набір',1.000000000,0.000000000,NULL,'634023_набір','634023_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634024,'набір',1.000000000,0.000000000,NULL,'634024_набір','634024_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634025,'набір',1.000000000,0.000000000,NULL,'634025_набір','634025_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634026,'набір',1.000000000,0.000000000,NULL,'634026_набір','634026_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634027,'набір',1.000000000,0.000000000,NULL,'634027_набір','634027_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634028,'набір',1.000000000,0.000000000,NULL,'634028_набір','634028_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634029,'набір',1.000000000,0.000000000,NULL,'634029_набір','634029_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634030,'набір',1.000000000,0.000000000,NULL,'634030_набір','634030_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634031,'набір',1.000000000,0.000000000,NULL,'634031_набір','634031_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634032,'набір',1.000000000,0.000000000,NULL,'634032_набір','634032_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634033,'набір',1.000000000,0.000000000,NULL,'634033_набір','634033_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634034,'набір',1.000000000,0.000000000,NULL,'634034_набір','634034_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634035,'набір',1.000000000,0.000000000,NULL,'634035_набір','634035_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634036,'набір',1.000000000,0.000000000,NULL,'634036_набір','634036_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634037,'набір',1.000000000,0.000000000,NULL,'634037_набір','634037_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634038,'набір',1.000000000,0.000000000,NULL,'634038_набір','634038_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634039,'набір',1.000000000,0.000000000,NULL,'634039_набір','634039_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634040,'набір',1.000000000,0.000000000,NULL,'634040_набір','634040_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634041,'набір',1.000000000,0.000000000,NULL,'634041_набір','634041_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634042,'набір',1.000000000,0.000000000,NULL,'634042_набір','634042_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634043,'набір',1.000000000,0.000000000,NULL,'634043_набір','634043_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634044,'набір',1.000000000,0.000000000,NULL,'634044_набір','634044_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634045,'набір',1.000000000,0.000000000,NULL,'634045_набір','634045_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634046,'набір',1.000000000,0.000000000,NULL,'634046_набір','634046_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634047,'набір',1.000000000,0.000000000,NULL,'634047_набір','634047_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634048,'набір',1.000000000,0.000000000,NULL,'634048_набір','634048_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634049,'набір',1.000000000,0.000000000,NULL,'634049_набір','634049_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634050,'набір',1.000000000,0.000000000,NULL,'634050_набір','634050_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634051,'набір',1.000000000,0.000000000,NULL,'634051_набір','634051_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634052,'набір',1.000000000,0.000000000,NULL,'634052_набір','634052_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634053,'набір',1.000000000,0.000000000,NULL,'634053_набір','634053_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634054,'набір',1.000000000,0.000000000,NULL,'634054_набір','634054_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634055,'набір',1.000000000,0.000000000,NULL,'634055_набір','634055_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634056,'набір',1.000000000,0.000000000,NULL,'634056_набір','634056_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634057,'набір',1.000000000,0.000000000,NULL,'634057_набір','634057_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634058,'набір',1.000000000,0.000000000,NULL,'634058_набір','634058_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634059,'набір',1.000000000,0.000000000,NULL,'634059_набір','634059_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634060,'набір',1.000000000,0.000000000,NULL,'634060_набір','634060_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634061,'набір',1.000000000,0.000000000,NULL,'634061_набір','634061_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634062,'набір',1.000000000,0.000000000,NULL,'634062_набір','634062_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634063,'набір',1.000000000,0.000000000,NULL,'634063_набір','634063_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634064,'набір',1.000000000,0.000000000,NULL,'634064_набір','634064_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634065,'набір',1.000000000,0.000000000,NULL,'634065_набір','634065_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634066,'набір',1.000000000,0.000000000,NULL,'634066_набір','634066_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634067,'набір',1.000000000,0.000000000,NULL,'634067_набір','634067_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634068,'набір',1.000000000,0.000000000,NULL,'634068_набір','634068_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634069,'набір',1.000000000,0.000000000,NULL,'634069_набір','634069_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634070,'набір',1.000000000,0.000000000,NULL,'634070_набір','634070_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634071,'набір',1.000000000,0.000000000,NULL,'634071_набір','634071_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634072,'набір',1.000000000,0.000000000,NULL,'634072_набір','634072_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634073,'набір',1.000000000,0.000000000,NULL,'634073_набір','634073_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634074,'набір',1.000000000,0.000000000,NULL,'634074_набір','634074_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634075,'набір',1.000000000,0.000000000,NULL,'634075_набір','634075_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634076,'набір',1.000000000,0.000000000,NULL,'634076_набір','634076_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634077,'набір',1.000000000,0.000000000,NULL,'634077_набір','634077_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634078,'набір',1.000000000,0.000000000,NULL,'634078_набір','634078_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634079,'набір',1.000000000,0.000000000,NULL,'634079_набір','634079_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634080,'набір',1.000000000,0.000000000,NULL,'634080_набір','634080_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634081,'набір',1.000000000,0.000000000,NULL,'634081_набір','634081_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634082,'набір',1.000000000,0.000000000,NULL,'634082_набір','634082_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634083,'набір',1.000000000,0.000000000,NULL,'634083_набір','634083_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634084,'набір',1.000000000,0.000000000,NULL,'634084_набір','634084_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634085,'набір',1.000000000,0.000000000,NULL,'634085_набір','634085_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634086,'набір',1.000000000,0.000000000,NULL,'634086_набір','634086_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634087,'набір',1.000000000,0.000000000,NULL,'634087_набір','634087_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634088,'набір',1.000000000,0.000000000,NULL,'634088_набір','634088_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634089,'набір',1.000000000,0.000000000,NULL,'634089_набір','634089_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634090,'набір',1.000000000,0.000000000,NULL,'634090_набір','634090_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634091,'набір',1.000000000,0.000000000,NULL,'634091_набір','634091_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634092,'набір',1.000000000,0.000000000,NULL,'634092_набір','634092_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634093,'набір',1.000000000,0.000000000,NULL,'634093_набір','634093_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634094,'набір',1.000000000,0.000000000,NULL,'634094_набір','634094_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634095,'набір',1.000000000,0.000000000,NULL,'634095_набір','634095_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634096,'набір',1.000000000,0.000000000,NULL,'634096_набір','634096_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634097,'набір',1.000000000,0.000000000,NULL,'634097_набір','634097_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634098,'набір',1.000000000,0.000000000,NULL,'634098_набір','634098_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634099,'набір',1.000000000,0.000000000,NULL,'634099_набір','634099_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634100,'набір',1.000000000,0.000000000,NULL,'634100_набір','634100_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634101,'набір',1.000000000,0.000000000,NULL,'634101_набір','634101_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634102,'набір',1.000000000,0.000000000,NULL,'634102_набір','634102_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634103,'набір',1.000000000,0.000000000,NULL,'634103_набір','634103_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634104,'набір',1.000000000,0.000000000,NULL,'634104_набір','634104_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634105,'набір',1.000000000,0.000000000,NULL,'634105_набір','634105_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634106,'набір',1.000000000,0.000000000,NULL,'634106_набір','634106_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634107,'набір',1.000000000,0.000000000,NULL,'634107_набір','634107_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634108,'набір',1.000000000,0.000000000,NULL,'634108_набір','634108_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634109,'набір',1.000000000,0.000000000,NULL,'634109_набір','634109_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634110,'набір',1.000000000,0.000000000,NULL,'634110_набір','634110_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634111,'набір',1.000000000,0.000000000,NULL,'634111_набір','634111_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634112,'набір',1.000000000,0.000000000,NULL,'634112_набір','634112_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634113,'набір',1.000000000,0.000000000,NULL,'634113_набір','634113_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634114,'набір',1.000000000,0.000000000,NULL,'634114_набір','634114_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634115,'набір',1.000000000,0.000000000,NULL,'634115_набір','634115_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634116,'набір',1.000000000,0.000000000,NULL,'634116_набір','634116_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634117,'набір',1.000000000,0.000000000,NULL,'634117_набір','634117_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634118,'набір',1.000000000,0.000000000,NULL,'634118_набір','634118_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634119,'набір',1.000000000,0.000000000,NULL,'634119_набір','634119_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634120,'набір',1.000000000,0.000000000,NULL,'634120_набір','634120_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634121,'набір',1.000000000,0.000000000,NULL,'634121_набір','634121_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634122,'набір',1.000000000,0.000000000,NULL,'634122_набір','634122_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634123,'набір',1.000000000,0.000000000,NULL,'634123_набір','634123_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634124,'набір',1.000000000,0.000000000,NULL,'634124_набір','634124_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634125,'набір',1.000000000,0.000000000,NULL,'634125_набір','634125_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634126,'набір',1.000000000,0.000000000,NULL,'634126_набір','634126_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634127,'набір',1.000000000,0.000000000,NULL,'634127_набір','634127_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634128,'набір',1.000000000,0.000000000,NULL,'634128_набір','634128_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634129,'набір',1.000000000,0.000000000,NULL,'634129_набір','634129_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634130,'набір',1.000000000,0.000000000,NULL,'634130_набір','634130_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634131,'набір',1.000000000,0.000000000,NULL,'634131_набір','634131_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634132,'набір',1.000000000,0.000000000,NULL,'634132_набір','634132_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634133,'набір',1.000000000,0.000000000,NULL,'634133_набір','634133_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634134,'набір',1.000000000,0.000000000,NULL,'634134_набір','634134_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634135,'набір',1.000000000,0.000000000,NULL,'634135_набір','634135_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634136,'набір',1.000000000,0.000000000,NULL,'634136_набір','634136_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634137,'набір',1.000000000,0.000000000,NULL,'634137_набір','634137_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634138,'набір',1.000000000,0.000000000,NULL,'634138_набір','634138_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634139,'набір',1.000000000,0.000000000,NULL,'634139_набір','634139_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634140,'набір',1.000000000,0.000000000,NULL,'634140_набір','634140_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634141,'набір',1.000000000,0.000000000,NULL,'634141_набір','634141_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634142,'набір',1.000000000,0.000000000,NULL,'634142_набір','634142_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634143,'набір',1.000000000,0.000000000,NULL,'634143_набір','634143_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634144,'набір',1.000000000,0.000000000,NULL,'634144_набір','634144_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634145,'набір',1.000000000,0.000000000,NULL,'634145_набір','634145_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634146,'набір',1.000000000,0.000000000,NULL,'634146_набір','634146_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634147,'набір',1.000000000,0.000000000,NULL,'634147_набір','634147_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634148,'набір',1.000000000,0.000000000,NULL,'634148_набір','634148_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634149,'набір',1.000000000,0.000000000,NULL,'634149_набір','634149_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634150,'набір',1.000000000,0.000000000,NULL,'634150_набір','634150_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634151,'набір',1.000000000,0.000000000,NULL,'634151_набір','634151_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634152,'набір',1.000000000,0.000000000,NULL,'634152_набір','634152_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634153,'набір',1.000000000,0.000000000,NULL,'634153_набір','634153_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634154,'набір',1.000000000,0.000000000,NULL,'634154_набір','634154_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634155,'набір',1.000000000,0.000000000,NULL,'634155_набір','634155_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634156,'набір',1.000000000,0.000000000,NULL,'634156_набір','634156_набір',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634157,'набір',1.000000000,0.000000000,NULL,'634157_набір','634157_набір',0)
end

--update r_Prods_ set FEAprodID = 2205101000 where ProdID = 634000
BEGIN
update r_Prods_ set FEAprodID = 2205101000 where ProdID = 634000
update r_Prods_ set FEAprodID = 2208307100 where ProdID = 634001
update r_Prods_ set FEAprodID = 2208307100 where ProdID = 634002
update r_Prods_ set FEAprodID = 2208307100 where ProdID = 634003
update r_Prods_ set FEAprodID = 2208307100 where ProdID = 634004
update r_Prods_ set FEAprodID = 2208307100 where ProdID = 634005
update r_Prods_ set FEAprodID = 2208307100 where ProdID = 634006
update r_Prods_ set FEAprodID = 2208305200 where ProdID = 634007
update r_Prods_ set FEAprodID = 2208303000 where ProdID = 634008
update r_Prods_ set FEAprodID = 2208501100 where ProdID = 634009
update r_Prods_ set FEAprodID = 2208501100 where ProdID = 634010
update r_Prods_ set FEAprodID = 2208202900 where ProdID = 634011
update r_Prods_ set FEAprodID = 2204219800 where ProdID = 634012
update r_Prods_ set FEAprodID = 2204219400 where ProdID = 634013
update r_Prods_ set FEAprodID = 2204219300 where ProdID = 634014
update r_Prods_ set FEAprodID = 2204219300 where ProdID = 634015
update r_Prods_ set FEAprodID = 2204219400 where ProdID = 634016
update r_Prods_ set FEAprodID = 2204219400 where ProdID = 634017
update r_Prods_ set FEAprodID = 2204218300 where ProdID = 634018
update r_Prods_ set FEAprodID = 2204218400 where ProdID = 634019
update r_Prods_ set FEAprodID = 2204218300 where ProdID = 634020
update r_Prods_ set FEAprodID = 2204218400 where ProdID = 634021
update r_Prods_ set FEAprodID = 2204213800 where ProdID = 634022
update r_Prods_ set FEAprodID = 2204213800 where ProdID = 634023
update r_Prods_ set FEAprodID = 2204218100 where ProdID = 634024
update r_Prods_ set FEAprodID = 2204218100 where ProdID = 634025
update r_Prods_ set FEAprodID = 2204217900 where ProdID = 634026
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634027
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634028
update r_Prods_ set FEAprodID = 2204216600 where ProdID = 634029
update r_Prods_ set FEAprodID = 2204216600 where ProdID = 634030
update r_Prods_ set FEAprodID = 2204213800 where ProdID = 634031
update r_Prods_ set FEAprodID = 2204213800 where ProdID = 634032
update r_Prods_ set FEAprodID = 2204216200 where ProdID = 634033
update r_Prods_ set FEAprodID = 2204218000 where ProdID = 634034
update r_Prods_ set FEAprodID = 2204212600 where ProdID = 634035
update r_Prods_ set FEAprodID = 2204212600 where ProdID = 634036
update r_Prods_ set FEAprodID = 2204216600 where ProdID = 634037
update r_Prods_ set FEAprodID = 2204216600 where ProdID = 634038
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634039
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634040
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634041
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634042
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634043
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634044
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634045
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634046
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634047
update r_Prods_ set FEAprodID = 2204216800 where ProdID = 634048
update r_Prods_ set FEAprodID = 2204216600 where ProdID = 634049
update r_Prods_ set FEAprodID = 2204217900 where ProdID = 634050
update r_Prods_ set FEAprodID = 2204217900 where ProdID = 634051
update r_Prods_ set FEAprodID = 2204212700 where ProdID = 634052
update r_Prods_ set FEAprodID = 2204212800 where ProdID = 634053
update r_Prods_ set FEAprodID = 2204212800 where ProdID = 634054
update r_Prods_ set FEAprodID = 2204214800 where ProdID = 634055
update r_Prods_ set FEAprodID = 2204219400 where ProdID = 634056
update r_Prods_ set FEAprodID = 2204219400 where ProdID = 634057
update r_Prods_ set FEAprodID = 2204219400 where ProdID = 634058
update r_Prods_ set FEAprodID = 2204219300 where ProdID = 634059
update r_Prods_ set FEAprodID = 2204219700 where ProdID = 634060
update r_Prods_ set FEAprodID = 2204219300 where ProdID = 634061
update r_Prods_ set FEAprodID = 2204219300 where ProdID = 634062
update r_Prods_ set FEAprodID = 2204219300 where ProdID = 634063
update r_Prods_ set FEAprodID = 2204219700 where ProdID = 634064
update r_Prods_ set FEAprodID = 2204219300 where ProdID = 634065
update r_Prods_ set FEAprodID = 2204109300 where ProdID = 634066
update r_Prods_ set FEAprodID = 2204109300 where ProdID = 634067
update r_Prods_ set FEAprodID = 2204109300 where ProdID = 634068
update r_Prods_ set FEAprodID = 2204109300 where ProdID = 634069
update r_Prods_ set FEAprodID = 2204109300 where ProdID = 634070
update r_Prods_ set FEAprodID = 2204109100 where ProdID = 634071
update r_Prods_ set FEAprodID = 2208601100 where ProdID = 634072
update r_Prods_ set FEAprodID = 2204218200 where ProdID = 634073
update r_Prods_ set FEAprodID = 2204109300 where ProdID = 634074
update r_Prods_ set FEAprodID = 2204211300 where ProdID = 634075
update r_Prods_ set FEAprodID = 2208501100 where ProdID = 634076
update r_Prods_ set FEAprodID = 2208301100 where ProdID = 634077
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634078
update r_Prods_ set FEAprodID = 2204214200 where ProdID = 634079
update r_Prods_ set FEAprodID = 2204218000 where ProdID = 634080
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634081
update r_Prods_ set FEAprodID = 2204214200 where ProdID = 634082
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634083
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634084
update r_Prods_ set FEAprodID = 2204213800 where ProdID = 634085
update r_Prods_ set FEAprodID = 2204213800 where ProdID = 634086
update r_Prods_ set FEAprodID = 2204212400 where ProdID = 634087
update r_Prods_ set FEAprodID = 2204212400 where ProdID = 634088
update r_Prods_ set FEAprodID = 2204212400 where ProdID = 634089
update r_Prods_ set FEAprodID = 2204214200 where ProdID = 634090
update r_Prods_ set FEAprodID = 2204217600 where ProdID = 634091
update r_Prods_ set FEAprodID = 2204218400 where ProdID = 634092
update r_Prods_ set FEAprodID = 2208906900 where ProdID = 634093
update r_Prods_ set FEAprodID = 2205101000 where ProdID = 634094
update r_Prods_ set FEAprodID = 2204214700 where ProdID = 634095
update r_Prods_ set FEAprodID = 2204217900 where ProdID = 634096
update r_Prods_ set FEAprodID = 2204213800 where ProdID = 634097
update r_Prods_ set FEAprodID = 2204211100 where ProdID = 634098
update r_Prods_ set FEAprodID = 2204211100 where ProdID = 634099
update r_Prods_ set FEAprodID = 2204217900 where ProdID = 634100
update r_Prods_ set FEAprodID = 2204211800 where ProdID = 634101
update r_Prods_ set FEAprodID = 2204211800 where ProdID = 634102
update r_Prods_ set FEAprodID = 2204211800 where ProdID = 634103
update r_Prods_ set FEAprodID = 2204211800 where ProdID = 634104
update r_Prods_ set FEAprodID = 2204212700 where ProdID = 634105
update r_Prods_ set FEAprodID = 2204212700 where ProdID = 634106
update r_Prods_ set FEAprodID = 2204212700 where ProdID = 634107
update r_Prods_ set FEAprodID = 2208303000 where ProdID = 634108
update r_Prods_ set FEAprodID = 2204210600 where ProdID = 634109
update r_Prods_ set FEAprodID = 2204213700 where ProdID = 634110
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634111
update r_Prods_ set FEAprodID = 2208601100 where ProdID = 634112
update r_Prods_ set FEAprodID = 2208905400 where ProdID = 634113
update r_Prods_ set FEAprodID = 2204218300 where ProdID = 634114
update r_Prods_ set FEAprodID = 2204218400 where ProdID = 634115
update r_Prods_ set FEAprodID = 2204218400 where ProdID = 634116
update r_Prods_ set FEAprodID = 2204218300 where ProdID = 634117
update r_Prods_ set FEAprodID = 2208601100 where ProdID = 634118
update r_Prods_ set FEAprodID = 2204212800 where ProdID = 634119
update r_Prods_ set FEAprodID = 2204218100 where ProdID = 634120
update r_Prods_ set FEAprodID = 2204219400 where ProdID = 634121
update r_Prods_ set FEAprodID = 2204218300 where ProdID = 634122
update r_Prods_ set FEAprodID = 2204109800 where ProdID = 634123
update r_Prods_ set FEAprodID = 2204219400 where ProdID = 634124
update r_Prods_ set FEAprodID = 2208308200 where ProdID = 634125
update r_Prods_ set FEAprodID = 2204219500 where ProdID = 634126
update r_Prods_ set FEAprodID = 2204219600 where ProdID = 634127
update r_Prods_ set FEAprodID = 2208601100 where ProdID = 634128
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634129
update r_Prods_ set FEAprodID = 2204109300 where ProdID = 634130
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634131
update r_Prods_ set FEAprodID = 2204212800 where ProdID = 634132
update r_Prods_ set FEAprodID = 2204218300 where ProdID = 634133
update r_Prods_ set FEAprodID = 2204109600 where ProdID = 634134
update r_Prods_ set FEAprodID = 2204109300 where ProdID = 634135
update r_Prods_ set FEAprodID = 2204109300 where ProdID = 634136
update r_Prods_ set FEAprodID = 2204213200 where ProdID = 634137
update r_Prods_ set FEAprodID = 2204213200 where ProdID = 634138
update r_Prods_ set FEAprodID = 2204217800 where ProdID = 634139
update r_Prods_ set FEAprodID = 2204218000 where ProdID = 634140
update r_Prods_ set FEAprodID = 2204218400 where ProdID = 634141
update r_Prods_ set FEAprodID = 2204217900 where ProdID = 634142
update r_Prods_ set FEAprodID = 2204218300 where ProdID = 634143
update r_Prods_ set FEAprodID = 2205101000 where ProdID = 634144
update r_Prods_ set FEAprodID = 2204218300 where ProdID = 634145
update r_Prods_ set FEAprodID = 2204218400 where ProdID = 634146
update r_Prods_ set FEAprodID = 2204217900 where ProdID = 634147
update r_Prods_ set FEAprodID = 2204218000 where ProdID = 634148
update r_Prods_ set FEAprodID = 2204218000 where ProdID = 634149
update r_Prods_ set FEAprodID = 2204218000 where ProdID = 634150
update r_Prods_ set FEAprodID = 2204214800 where ProdID = 634151
update r_Prods_ set FEAprodID = 2204214800 where ProdID = 634152
update r_Prods_ set FEAprodID = 2204214800 where ProdID = 634153
update r_Prods_ set FEAprodID = 2204213800 where ProdID = 634154
update r_Prods_ set FEAprodID = 2204219800 where ProdID = 634155
update r_Prods_ set FEAprodID = 2204218000 where ProdID = 634156
update r_Prods_ set FEAprodID = 2204218100 where ProdID = 634157
  
END

;ENABLE  TRIGGER ALL ON r_Prods_;

DECLARE @ProdID INT
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT ProdID FROM r_Prods_ WITH (NOLOCK)
WHERE 
	ProdID between 634000 and 634157
GROUP BY 
	ProdID 

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 
	INTO @ProdID
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	
	insert t_PInP_
		SELECT @ProdID ProdID, PPID, PPDesc, PriceMC_In, PriceMC, Priority, NULL ProdDate, CurrID, CompID, Article, CostAC, PPWeight, File1, File2, File3, PriceCC_In, CostCC, PPDelay, ProdPPDate, DLSDate, IsCommission, CostMC, PriceAC_In, IsCert, '' FEAProdID, ProdBarCode, PPHumidity, PPImpurity, CustDocNum, '' CustDocDate 
		FROM Elit.dbo.t_PInP a 
		where a.ProdID in (32595) and PPID = 0

	FETCH NEXT FROM CURSOR1 
	INTO @ProdID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

--INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634056, 10790, 601070, NULL, NULL)
BEGIN
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634056, 10790, 601070, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634014, 10790, 600721, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634043, 10790, 600884, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634110, 10790, 801098, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634111, 10790, 801099, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634037, 10790, 600840, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634113, 10790, 801451, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634115, 10790, 801563, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634116, 10790, 801564, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634114, 10790, 801562, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634117, 10790, 801565, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634112, 10790, 801301, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634023, 10790, 600757, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634047, 10790, 600885, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634100, 10790, 800164, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634119, 10790, 801720, NULL, 747505008093)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634041, 10790, 600883, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634045, 10790, 600884, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634038, 10790, 600840, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634039, 10790, 600882, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634070, 10793, 601116, NULL, 8002235835053)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634008, 10793, 600168, NULL, 5010509427067)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634006, 10793, 600159, NULL, 5010509003001)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634007, 10793, 600160, NULL, 5010509003087)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634009, 10793, 600267, NULL, 4062400311700)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634019, 10793, 600743, NULL, 8427894007632)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634018, 10793, 600742, NULL, 8427894007656)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634021, 10793, 600745, NULL, 8427894007045)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634010, 10793, 600267, NULL, 4062400311700)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634020, 10793, 600744, NULL, 8427894007038)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634004, 10793, 600135, NULL, 2900006001354)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634001, 10793, 600132, NULL, 5010509415705)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634002, 10793, 600133, NULL, 5010509001243)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634003, 10793, 600134, NULL, 5010509001229)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634005, 10793, 600136, NULL, 5010509414081)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634074, 10793, 602042, NULL, 8002235005579)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634016, 10793, 600731, NULL, 4867601703374)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634017, 10793, 600732, NULL, 4867601703367)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634068, 10793, 601111, NULL, 8002235005722)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634011, 10793, 600299, NULL, 4860053012650)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634067, 10793, 601106, NULL, 8410310607622)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634066, 10793, 601105, NULL, 8410310608773)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634069, 10793, 601115, NULL, 8002235004091)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634071, 10793, 601626, NULL, 8006315900136)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634083, 10793, 602669, NULL, 8427894003108)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634076, 10793, 602505, NULL, 4006714004880)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634077, 10793, 602507, NULL, 4006714004941)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634072, 10793, 601773, NULL, 4820139240056)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634092, 10793, 603975, NULL, 8028936008831)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634064, 10793, 601095, NULL, 7804350004540)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634059, 10793, 601085, NULL, 7804414001225)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634000, 10793, 600072, NULL, 4820024226301)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634094, 10793, 604851, NULL, 4820024226325)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634031, 10793, 600816, NULL, 8002350133881)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634042, 10793, 600884, NULL, 8002235692052)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634040, 10793, 600883, NULL, 8002235572552)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634087, 10793, 603053, NULL, 8000100645974)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634105, 10793, 800594, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634053, 10793, 600895, NULL, 8002235662550)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634024, 10793, 600758, NULL, 8410310607196)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634022, 10793, 600757, NULL, 8410310606977)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634065, 10793, 601095, NULL, 7804350004540)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634108, 10793, 800621, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634093, 10793, 604603, NULL, 8002230000012)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634060, 10793, 601085, NULL, 7804414001225)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634109, 10793, 800779, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634056, 10793, 601070, NULL, 7804414001171)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634014, 10793, 600721, NULL, 7791203001316)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634043, 10793, 600884, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634110, 10793, 801098, NULL, 8410310613432)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634111, 10793, 801099, NULL, 8410310613418)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634096, 10793, 604980, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634037, 10793, 600840, NULL, 8002235023313)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634075, 10793, 602290, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634081, 10793, 602564, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634078, 10793, 602563, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634113, 10793, 801451, NULL, 4820180020188)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634122, 10793, 801949, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634123, 10793, 801952, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634115, 10793, 801563, NULL, 3395940520709)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634116, 10793, 801564, NULL, 3395940520686)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634114, 10793, 801562, NULL, 3395940520662)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634117, 10793, 801565, NULL, 3395940520648)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634029, 10793, 600773, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634112, 10793, 801301, NULL, 4820139240247)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634023, 10793, 600757, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634090, 10793, 603928, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634118, 10793, 801642, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634047, 10793, 600885, NULL, 8002235692557)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634035, 10793, 600839, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634100, 10793, 800164, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634119, 10793, 801720, NULL, 747505008093)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634124, 10793, 802174, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634126, 10793, 802375, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634127, 10793, 802376, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634125, 10793, 802185, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634130, 10793, 802402, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634091, 10793, 603936, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634041, 10793, 600883, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634045, 10793, 600884, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634038, 10793, 600840, NULL, 8002235023313)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634133, 10793, 802412, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634128, 10793, 802394, NULL, NULL)
INSERT r_ProdEC (ProdID, CompID, ExtProdID, ExtProdName, ExtBarCode) VALUES (634039, 10793, 600882, NULL, NULL)
END



SELECT * FROM r_Prods_ where ProdID between 634000 and 634157
SELECT * FROM r_ProdMQ where ProdID between 634000 and 634157
SELECT * FROM t_PInP_ where ProdID between 634000 and 634157

SELECT * FROM r_Prods_ a 
where a.ProdID in (
30767,26135,26136,26137,26133,26139,4165,4167,4149,21398,24412,28574,32060,32791,31629,32784,28240,28241,23775,23774,24549,23776,31391,32035,31389,32032,32549,32602,33715,31970,32465,31271,31963,32467,32434,32150,32996,31833,32453,32699,31283,32444,31280,31760,31922,32446,33438,32149,33299,33296,32445,33300,32345,31363,32083,32558,31618,32048,32573,30755,31451,32045,32850,32574,30726,31395,28958,28957,28261,28978,3499,29054,30691,32164,27761,31853,29873,29880,31910,32300,32893,31909,32301,29808,33219,32433,32998,31306,32479,33025,32107,32378,30715,31441,30894,32665,31828,32666,31965,32610,32167,32543,33610,32542,33711,31324,32111,32485,31439,31574,31794,31795,32020,31934,31959,31957,31958,31960,32147,32168,33255,33244,31947,31950,32180,32317,32236,32237,32595,32370,32373,32550,32387,32551,32447,33577,32438,32393,32394,32397,32389,32654,32390,32655,32414,32384,32385,32718,32719,32630,33086,32649,33246,32650,32993,33095,33714,33098
)

ROLLBACK TRAN



--обновить справочник предприятий из БД Элит в БД Элитдистр по предприятиям 10790-10799
BEGIN TRAN


insert r_Comps
SELECT ROW_NUMBER()OVER(ORDER BY ChID) + (SELECT MAX(ChID) FROM r_Comps) ChID, 
CompID, CompName, CompShort, Address, PostIndex, City, Region, Code, TaxRegNo, 
TaxCode, TaxPayer, CompDesc, Contact, Phone1, Phone2, Phone3, Fax, EMail, HTTP, 
Notes, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, UseCodes, PLID, UsePL, Discount, 
UseDiscount, PayDelay, UsePayDelay, MaxCredit, CalcMaxCredit, EmpID, Contract1, 
Contract2, Contract3, License1, License2, License3, Job1, Job2, Job3, TranPrc, 
MorePrc, FirstEventMode, CompType, SysTaxType, FixTaxPercent, InStopList, Value1, 
Value2, Value3, PassNo, PassSer, PassDate, PassDept, CompGrID1, CompGrID2, CompGrID3, 
CompGrID4, CompGrID5, PayDelay2, MaxCredit2, RecipName, RecipAcc, RecipPCardID, 
AltCompID, BlockingID, CompNameFull, ProdCreditDate, ProdCreditDate2, PlanShipSumCC, 
PlanShipSumCC2, IsDutyFree, GLNCode, CanInvoicing, CanDuplicateCode
FROM elit.dbo.r_Comps where CompID between 10790 and 10799 and CompID not in (SELECT CompID FROM r_Comps)


ROLLBACK TRAN



--обновить  договор универсальный из БД Элит в БД Элитдистр по предприятиям 10790-10799
BEGIN TRAN


insert at_z_Contracts
	SELECT ChID, OurID, DocID, DocDate, ContrTypeID, OffTypeID, ContrID, CompID, BDate, EDate, AddContrID, AddBDate, Status, PackingTermType
	FROM elit.dbo.at_z_Contracts where CompID between 10790 and 10799 and DocID not in (SELECT DocID FROM at_z_Contracts where CompID between 10790 and 10799)

;DISABLE TRIGGER ALL ON at_z_ContractsAdd;  
insert at_z_ContractsAdd
	SELECT * FROM elit.dbo.at_z_ContractsAdd where CompID between 10790 and 10799 and ChID not in (SELECT ChID FROM at_z_ContractsAdd where CompID between 10790 and 10799)
;ENABLE  TRIGGER ALL ON at_z_ContractsAdd;


--SELECT ChID, PCatID, DelTermType, DelTermValue FROM elit.dbo.at_z_ContractTerms
--except
--SELECT ChID, PCatID, DelTermType, DelTermValue FROM at_z_ContractTerms


ROLLBACK TRAN
