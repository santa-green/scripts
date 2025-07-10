
BEGIN TRAN

DECLARE @n int = (SELECT MAX(ChID) FROM r_Prods_)
SELECT @n

;DISABLE TRIGGER ALL ON r_Prods_;  

insert r_Prods_

SELECT ROW_NUMBER()OVER(ORDER BY ChID) + @n as ChID
      ,[ProdID]
      ,ProdName + '&A N' as ProdName
      ,'����' UM
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

--INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634000,'����',1.000000000,0.000000000,NULL,'634000_����','634000_����',0)
begin
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634000,'����',1.000000000,0.000000000,NULL,'634000_����','634000_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634001,'����',1.000000000,0.000000000,NULL,'634001_����','634001_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634002,'����',1.000000000,0.000000000,NULL,'634002_����','634002_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634003,'����',1.000000000,0.000000000,NULL,'634003_����','634003_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634004,'����',1.000000000,0.000000000,NULL,'634004_����','634004_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634005,'����',1.000000000,0.000000000,NULL,'634005_����','634005_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634006,'����',1.000000000,0.000000000,NULL,'634006_����','634006_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634007,'����',1.000000000,0.000000000,NULL,'634007_����','634007_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634008,'����',1.000000000,0.000000000,NULL,'634008_����','634008_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634009,'����',1.000000000,0.000000000,NULL,'634009_����','634009_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634010,'����',1.000000000,0.000000000,NULL,'634010_����','634010_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634011,'����',1.000000000,0.000000000,NULL,'634011_����','634011_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634012,'����',1.000000000,0.000000000,NULL,'634012_����','634012_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634013,'����',1.000000000,0.000000000,NULL,'634013_����','634013_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634014,'����',1.000000000,0.000000000,NULL,'634014_����','634014_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634015,'����',1.000000000,0.000000000,NULL,'634015_����','634015_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634016,'����',1.000000000,0.000000000,NULL,'634016_����','634016_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634017,'����',1.000000000,0.000000000,NULL,'634017_����','634017_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634018,'����',1.000000000,0.000000000,NULL,'634018_����','634018_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634019,'����',1.000000000,0.000000000,NULL,'634019_����','634019_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634020,'����',1.000000000,0.000000000,NULL,'634020_����','634020_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634021,'����',1.000000000,0.000000000,NULL,'634021_����','634021_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634022,'����',1.000000000,0.000000000,NULL,'634022_����','634022_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634023,'����',1.000000000,0.000000000,NULL,'634023_����','634023_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634024,'����',1.000000000,0.000000000,NULL,'634024_����','634024_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634025,'����',1.000000000,0.000000000,NULL,'634025_����','634025_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634026,'����',1.000000000,0.000000000,NULL,'634026_����','634026_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634027,'����',1.000000000,0.000000000,NULL,'634027_����','634027_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634028,'����',1.000000000,0.000000000,NULL,'634028_����','634028_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634029,'����',1.000000000,0.000000000,NULL,'634029_����','634029_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634030,'����',1.000000000,0.000000000,NULL,'634030_����','634030_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634031,'����',1.000000000,0.000000000,NULL,'634031_����','634031_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634032,'����',1.000000000,0.000000000,NULL,'634032_����','634032_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634033,'����',1.000000000,0.000000000,NULL,'634033_����','634033_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634034,'����',1.000000000,0.000000000,NULL,'634034_����','634034_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634035,'����',1.000000000,0.000000000,NULL,'634035_����','634035_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634036,'����',1.000000000,0.000000000,NULL,'634036_����','634036_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634037,'����',1.000000000,0.000000000,NULL,'634037_����','634037_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634038,'����',1.000000000,0.000000000,NULL,'634038_����','634038_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634039,'����',1.000000000,0.000000000,NULL,'634039_����','634039_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634040,'����',1.000000000,0.000000000,NULL,'634040_����','634040_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634041,'����',1.000000000,0.000000000,NULL,'634041_����','634041_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634042,'����',1.000000000,0.000000000,NULL,'634042_����','634042_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634043,'����',1.000000000,0.000000000,NULL,'634043_����','634043_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634044,'����',1.000000000,0.000000000,NULL,'634044_����','634044_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634045,'����',1.000000000,0.000000000,NULL,'634045_����','634045_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634046,'����',1.000000000,0.000000000,NULL,'634046_����','634046_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634047,'����',1.000000000,0.000000000,NULL,'634047_����','634047_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634048,'����',1.000000000,0.000000000,NULL,'634048_����','634048_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634049,'����',1.000000000,0.000000000,NULL,'634049_����','634049_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634050,'����',1.000000000,0.000000000,NULL,'634050_����','634050_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634051,'����',1.000000000,0.000000000,NULL,'634051_����','634051_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634052,'����',1.000000000,0.000000000,NULL,'634052_����','634052_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634053,'����',1.000000000,0.000000000,NULL,'634053_����','634053_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634054,'����',1.000000000,0.000000000,NULL,'634054_����','634054_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634055,'����',1.000000000,0.000000000,NULL,'634055_����','634055_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634056,'����',1.000000000,0.000000000,NULL,'634056_����','634056_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634057,'����',1.000000000,0.000000000,NULL,'634057_����','634057_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634058,'����',1.000000000,0.000000000,NULL,'634058_����','634058_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634059,'����',1.000000000,0.000000000,NULL,'634059_����','634059_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634060,'����',1.000000000,0.000000000,NULL,'634060_����','634060_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634061,'����',1.000000000,0.000000000,NULL,'634061_����','634061_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634062,'����',1.000000000,0.000000000,NULL,'634062_����','634062_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634063,'����',1.000000000,0.000000000,NULL,'634063_����','634063_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634064,'����',1.000000000,0.000000000,NULL,'634064_����','634064_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634065,'����',1.000000000,0.000000000,NULL,'634065_����','634065_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634066,'����',1.000000000,0.000000000,NULL,'634066_����','634066_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634067,'����',1.000000000,0.000000000,NULL,'634067_����','634067_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634068,'����',1.000000000,0.000000000,NULL,'634068_����','634068_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634069,'����',1.000000000,0.000000000,NULL,'634069_����','634069_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634070,'����',1.000000000,0.000000000,NULL,'634070_����','634070_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634071,'����',1.000000000,0.000000000,NULL,'634071_����','634071_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634072,'����',1.000000000,0.000000000,NULL,'634072_����','634072_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634073,'����',1.000000000,0.000000000,NULL,'634073_����','634073_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634074,'����',1.000000000,0.000000000,NULL,'634074_����','634074_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634075,'����',1.000000000,0.000000000,NULL,'634075_����','634075_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634076,'����',1.000000000,0.000000000,NULL,'634076_����','634076_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634077,'����',1.000000000,0.000000000,NULL,'634077_����','634077_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634078,'����',1.000000000,0.000000000,NULL,'634078_����','634078_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634079,'����',1.000000000,0.000000000,NULL,'634079_����','634079_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634080,'����',1.000000000,0.000000000,NULL,'634080_����','634080_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634081,'����',1.000000000,0.000000000,NULL,'634081_����','634081_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634082,'����',1.000000000,0.000000000,NULL,'634082_����','634082_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634083,'����',1.000000000,0.000000000,NULL,'634083_����','634083_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634084,'����',1.000000000,0.000000000,NULL,'634084_����','634084_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634085,'����',1.000000000,0.000000000,NULL,'634085_����','634085_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634086,'����',1.000000000,0.000000000,NULL,'634086_����','634086_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634087,'����',1.000000000,0.000000000,NULL,'634087_����','634087_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634088,'����',1.000000000,0.000000000,NULL,'634088_����','634088_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634089,'����',1.000000000,0.000000000,NULL,'634089_����','634089_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634090,'����',1.000000000,0.000000000,NULL,'634090_����','634090_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634091,'����',1.000000000,0.000000000,NULL,'634091_����','634091_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634092,'����',1.000000000,0.000000000,NULL,'634092_����','634092_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634093,'����',1.000000000,0.000000000,NULL,'634093_����','634093_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634094,'����',1.000000000,0.000000000,NULL,'634094_����','634094_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634095,'����',1.000000000,0.000000000,NULL,'634095_����','634095_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634096,'����',1.000000000,0.000000000,NULL,'634096_����','634096_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634097,'����',1.000000000,0.000000000,NULL,'634097_����','634097_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634098,'����',1.000000000,0.000000000,NULL,'634098_����','634098_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634099,'����',1.000000000,0.000000000,NULL,'634099_����','634099_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634100,'����',1.000000000,0.000000000,NULL,'634100_����','634100_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634101,'����',1.000000000,0.000000000,NULL,'634101_����','634101_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634102,'����',1.000000000,0.000000000,NULL,'634102_����','634102_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634103,'����',1.000000000,0.000000000,NULL,'634103_����','634103_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634104,'����',1.000000000,0.000000000,NULL,'634104_����','634104_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634105,'����',1.000000000,0.000000000,NULL,'634105_����','634105_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634106,'����',1.000000000,0.000000000,NULL,'634106_����','634106_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634107,'����',1.000000000,0.000000000,NULL,'634107_����','634107_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634108,'����',1.000000000,0.000000000,NULL,'634108_����','634108_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634109,'����',1.000000000,0.000000000,NULL,'634109_����','634109_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634110,'����',1.000000000,0.000000000,NULL,'634110_����','634110_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634111,'����',1.000000000,0.000000000,NULL,'634111_����','634111_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634112,'����',1.000000000,0.000000000,NULL,'634112_����','634112_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634113,'����',1.000000000,0.000000000,NULL,'634113_����','634113_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634114,'����',1.000000000,0.000000000,NULL,'634114_����','634114_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634115,'����',1.000000000,0.000000000,NULL,'634115_����','634115_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634116,'����',1.000000000,0.000000000,NULL,'634116_����','634116_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634117,'����',1.000000000,0.000000000,NULL,'634117_����','634117_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634118,'����',1.000000000,0.000000000,NULL,'634118_����','634118_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634119,'����',1.000000000,0.000000000,NULL,'634119_����','634119_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634120,'����',1.000000000,0.000000000,NULL,'634120_����','634120_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634121,'����',1.000000000,0.000000000,NULL,'634121_����','634121_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634122,'����',1.000000000,0.000000000,NULL,'634122_����','634122_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634123,'����',1.000000000,0.000000000,NULL,'634123_����','634123_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634124,'����',1.000000000,0.000000000,NULL,'634124_����','634124_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634125,'����',1.000000000,0.000000000,NULL,'634125_����','634125_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634126,'����',1.000000000,0.000000000,NULL,'634126_����','634126_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634127,'����',1.000000000,0.000000000,NULL,'634127_����','634127_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634128,'����',1.000000000,0.000000000,NULL,'634128_����','634128_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634129,'����',1.000000000,0.000000000,NULL,'634129_����','634129_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634130,'����',1.000000000,0.000000000,NULL,'634130_����','634130_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634131,'����',1.000000000,0.000000000,NULL,'634131_����','634131_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634132,'����',1.000000000,0.000000000,NULL,'634132_����','634132_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634133,'����',1.000000000,0.000000000,NULL,'634133_����','634133_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634134,'����',1.000000000,0.000000000,NULL,'634134_����','634134_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634135,'����',1.000000000,0.000000000,NULL,'634135_����','634135_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634136,'����',1.000000000,0.000000000,NULL,'634136_����','634136_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634137,'����',1.000000000,0.000000000,NULL,'634137_����','634137_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634138,'����',1.000000000,0.000000000,NULL,'634138_����','634138_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634139,'����',1.000000000,0.000000000,NULL,'634139_����','634139_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634140,'����',1.000000000,0.000000000,NULL,'634140_����','634140_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634141,'����',1.000000000,0.000000000,NULL,'634141_����','634141_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634142,'����',1.000000000,0.000000000,NULL,'634142_����','634142_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634143,'����',1.000000000,0.000000000,NULL,'634143_����','634143_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634144,'����',1.000000000,0.000000000,NULL,'634144_����','634144_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634145,'����',1.000000000,0.000000000,NULL,'634145_����','634145_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634146,'����',1.000000000,0.000000000,NULL,'634146_����','634146_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634147,'����',1.000000000,0.000000000,NULL,'634147_����','634147_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634148,'����',1.000000000,0.000000000,NULL,'634148_����','634148_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634149,'����',1.000000000,0.000000000,NULL,'634149_����','634149_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634150,'����',1.000000000,0.000000000,NULL,'634150_����','634150_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634151,'����',1.000000000,0.000000000,NULL,'634151_����','634151_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634152,'����',1.000000000,0.000000000,NULL,'634152_����','634152_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634153,'����',1.000000000,0.000000000,NULL,'634153_����','634153_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634154,'����',1.000000000,0.000000000,NULL,'634154_����','634154_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634155,'����',1.000000000,0.000000000,NULL,'634155_����','634155_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634156,'����',1.000000000,0.000000000,NULL,'634156_����','634156_����',0)
INSERT r_ProdMQ_ (ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID) VALUES (634157,'����',1.000000000,0.000000000,NULL,'634157_����','634157_����',0)
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



--�������� ���������� ����������� �� �� ���� � �� ��������� �� ������������ 10790-10799
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



--��������  ������� ������������� �� �� ���� � �� ��������� �� ������������ 10790-10799
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
