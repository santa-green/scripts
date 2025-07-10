/*--текущие остатки по палетам группированые по партиям
SELECT * FROM (
SELECT /*OurID,*/ StockID,  ProdID, Qty --, AccQty 
,(SELECT ProdName FROM r_Prods p where p.ProdID = gr.ProdID) ProdName
--,(SELECT top 1 mq.BarCode FROM r_ProdMQ mq where mq.ProdID = gr.ProdID ) BarCode
, (SELECT p.WeightGr FROM r_Prods p where p.ProdID = gr.ProdID) WeightGr
, (SELECT top 1 pp.ProdBarCode FROM t_PInP pp where pp.ProdID = gr.ProdID and pp.ProdBarCode <> '' ORDER BY PPID desc) ProdBarCode
, CEILING  (isnull(Qty/(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = gr.ProdID ORDER BY VarName),1)) palet
,(SELECT sum(qty) FROM t_rem p1 where p1.ProdID = gr.ProdID and stockid in (220,218)) sum_qty
,(SELECT max(qty) FROM t_rem p1 where p1.ProdID = gr.ProdID and stockid in (220,218)) max_qty
,(SELECT count(qty) FROM t_rem p1 where p1.ProdID = gr.ProdID and stockid in (220,218) and qty <> 0) count_qty
, Qty/isnull((SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = gr.ProdID ORDER BY VarName),50) palet_raschet
,Qty/CEILING  (isnull(Qty/(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = gr.ProdID ORDER BY VarName),1))*(SELECT p.WeightGr FROM r_Prods p where p.ProdID = gr.ProdID) 'масса_на_палете'
,(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = gr.ProdID ORDER BY VarName) QtyInPalet
from (
SELECT OurID, StockID,  ProdID, sum(Qty) Qty --, AccQty 
FROM t_rem r
where stockid in (220,218) and qty <> 0 
--ORDER BY масса_на_палете desc
group by OurID, StockID,  ProdID
) gr
)s1
where (qty > isnull(QtyInPalet,0))
--and qty > 100
and ProdBarCode is not null
and QtyInPalet is null
ORDER BY 3 desc
*/


--текущие остатки не групированные
SELECT * FROM (
SELECT OurID, StockID, SecID, ProdID, PPID, Qty--, AccQty 
, (SELECT ProdName FROM r_Prods p where p.ProdID = r.ProdID) ProdName
, (SELECT p.WeightGr FROM r_Prods p where p.ProdID = r.ProdID) WeightGr
--, (SELECT top 1 mq.BarCode FROM r_ProdMQ mq where mq.ProdID = r.ProdID ) BarCode
, (SELECT top 1 pp.ProdBarCode FROM t_PInP pp where pp.ProdID = r.ProdID and pp.ProdBarCode <> '' ORDER BY PPID desc) ProdBarCode
,(SELECT sum(qty) FROM t_rem p1 where p1.ProdID = r.ProdID and stockid in (220,218)) sum_qty
,(SELECT max(qty) FROM t_rem p1 where p1.ProdID = r.ProdID and stockid in (220,218)) max_qty
,(SELECT count(qty) FROM t_rem p1 where p1.ProdID = r.ProdID and stockid in (220,218) and qty <> 0) count_qty
, CEILING  (isnull(Qty/(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName),1)) palet_max
, FLOOR   (isnull(Qty/(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName),1)) palet_min
, FLOOR   (isnull(Qty/(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName),1)) * (SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName) qty_min
, Qty/isnull((SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName),50) palet_raschet
,Qty/CEILING  (isnull(Qty/(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName),1))*(SELECT p.WeightGr FROM r_Prods p where p.ProdID = r.ProdID) 'масса_на_палете'
,(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName) QtyInPalet
,(SELECT top 1 VarName FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName) TypePalet
FROM t_rem r
)s1
where stockid in (220,218) and qty <> 0 
and ProdBarCode is not null
--and QtyInPalet is  null --1573 на палетах по норме, 
and qty >= QtyInPalet  -- 

--and qty > 50
--ORDER BY sum_qty desc ,max_qty desc,ProdID,PPID
ORDER BY palet_raschet
--ORDER BY Qty






/*
SELECT * FROM r_ProdValues where prodid in (4886)



--SELECT distinct  'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v04-Количество шт на паллете 800х1200'',''' + cast(QtyInPalet  as varchar) +''',''sao'');'
--FROM #ProdsPalet where WidthPalet = 800 and prodid not in (SELECT prodid FROM r_ProdValues where VarName = 'v04-Количество шт на паллете 800х1200')
--union 
--SELECT distinct  'INSERT r_ProdValues (ProdID, VarName, VarValue,subum) VALUES (' +  cast(ProdID as varchar) + ',''v05-Количество шт на паллете 1000х1200'',''' + cast(QtyInPalet  as varchar) +''',''sao'');'
--FROM #ProdsPalet where WidthPalet = 1000 and prodid not in (SELECT prodid FROM r_ProdValues where VarName = 'v05-Количество шт на паллете 1000х1200')

*/
--текущие остатки по палетам
/*
SELECT OurID, StockID, SecID, ProdID, PPID, Qty--, AccQty 
, (SELECT ProdName FROM r_Prods p where p.ProdID = r.ProdID) ProdName
--, (SELECT top 1 mq.BarCode FROM r_ProdMQ mq where mq.ProdID = r.ProdID ) BarCode
, (SELECT p.WeightGr FROM r_Prods p where p.ProdID = r.ProdID) WeightGr
, (SELECT top 1 pp.ProdBarCode FROM t_PInP pp where pp.ProdID = r.ProdID and pp.ProdBarCode <> '' ORDER BY PPID desc) ProdBarCode
, CEILING  (isnull(Qty/(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName),1)) palet
,Qty/CEILING  (isnull(Qty/(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName),1))*(SELECT p.WeightGr FROM r_Prods p where p.ProdID = r.ProdID) 'масса_на_палете'
,(SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = r.ProdID ORDER BY VarName) QtyInPalet
FROM t_rem r
where stockid in (220,218) and qty <> 0 
and r.ProdID in (33324,34789,34754)
--and r.ProdID in (31878,29873,33926,34130,31879,32142,34111,3127,32142,30497,26213,     30766,30767,28246,28245,30497,4165,4167,26135,26136,26137,26133,26139,3127,26168,26213,30843,31878,31879,31880,32143,32142,32144)
--ORDER BY масса_на_палете desc
--ORDER BY QtyInPalet,6 desc
*/


--SELECT * FROM r_ProdValues pv where pv.VarName like 'v04-Количество шт на паллете 1000х1200' 
--update  r_ProdValues  set  VarName = 'v05-Количество шт на паллете 1000х1200'
--where VarName like 'v04-Количество шт на паллете 1000х1200' 

--SELECT top 1 cast(VarValue as int) FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' and pv.ProdID = gr.ProdID ORDER BY VarName
--SELECT * FROM r_ProdValues pv where pv.VarName like '%-Количество шт на паллете%' ORDER BY VarName

/*
SELECT max(qty) FROM t_rem p1 where p1.ProdID = 24876
SELECT * FROM t_rem p1 where p1.ProdID = 24876
SELECT distinct prodid FROM t_rem where stockid in (220,218) and qty <> 0 ORDER BY 1
SELECT distinct prodid FROM t_rem where  qty <> 0 ORDER BY 1

SELECT * FROM #ProdsPalet ORDER BY QtyInPalet 

SELECT distinct BarCode FROM r_prodmq where BarCode like '2%' ORDER BY 1
SELECT distinct * FROM t_pinp where ProdBarCode like '%781682114796%' ORDER BY 1
SELECT distinct prodid,ProdBarCode FROM t_pinp where ProdBarCode like '%781682114796%' ORDER BY 1

SELECT * FROM t_rem p1 where qty < 0
--delete t_rem where qty < 0


--SELECT p.* FROM r_Prods p where p.ProdID = 31878


	EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'
	--GO
	--REVERT

	--загружаем справочник по наборам
	IF OBJECT_ID (N'tempdb..#uCat', N'U') IS NOT NULL DROP TABLE #uCat
	SELECT *
	 INTO #uCat
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\EDI\uCat_шаблон.xls' , 'select * from [Выгрузка$]') as ex;
	
	SELECT * FROM #uCat
	--where UnitDescriptor = 'CASE'

SELECT * FROM r_ProdValues where 
--prodid in (
--34638,34639,34572,34211,34106,33737,33353,32829,32595,31823,29153,29153,31792,31792,31792,24876,24876,24876,24876,24876,24876,32349,32349,33937,33722,33722,34367,34649,34636,34790,33077,33306,33661,33661,33587,33538,33249,33236,33237,33247,33073,33075,33076,33076,33052,33053,33018,33018,32910,32464,32596,32559,32560,32145,32319,32320,32147,32147,32147,32147,32259,32016,30342,30342,30343,30343,34704,34610,34650,34647,34648,34662,34663,34688,34686,34671,34421,34422,34393,34415,34223,34224,34257,34258,34258,34243,34318,34302,34300,34265,34584,34507,34500,34437,34437,34450,33733,33747,33748,33748,33642,33688,33896,33976,33991,33984,34053,34056,34056,34057,34058,34059,34060,34051,34044,33979,33973,34150,34150,34154,34144,34145,34152,34169,34082,34470,34470,34470,34471,34471,31815,31815,31815,31815,28585,32146,33537,33536,32084,32084,32084,28603,34514,34514,34514,34151,33972,33881,33882,33882,33940,33940,33940,31814,31814,29151,29151,29151,32566,33479,33484,33485,33586,33583,33487,33581,33581,33559,33560,33561,33700,33701,33702,33703,33704,33679,33680,34011,34013,34014,34015,34016,34017,34019,34020,34021,34037,34042,34043,34040,34040,34046,34046,34046,34055,34055,34176,34081,34098,34072,34073,34119,34503,34504,34508,34489,34490,34492,34493,34494,34495,34496,34497,34498,34568,34565,34566,34301,34299,34384,34384,34385,34386,34386,34710,30489,30489,30489,26698,26699,28261,29090,28978,28978,28978,31441,32005,32005,22444,21515,4720,4720,4720,3499,3499,2746,2746,2746,2746,33593,32988,32988,32891,32892,32833,32833,33045,33045,32644,32645,32645,32447,32438,32193,32410,32411,32411,32026,31979,32374,32375,32376,32377,32377,32377,32361,34700,34721,34721,34655,34356,34375,34395,34396,34371,34372,34365,34253,34263,34309,34137,34138,33595,33720,31897,32419,32420,32420,32420,32421,32421,32421,32422,32422,32422,32422,32423,32656,32618,32618,32619,32511,33563,33564,33565,33566,33566,33567,33568,33569,33570,33571,1396,1214,4126,4127,4127,4127,4134,4134,4135,4135,4139,4139,4142,4148,4947,4947,22022,22022,21404,24402,24402,31574,31574,33968,33969,33969,33969,33919,33920,34127,34084,34085,34305,34242,34242,34362,34590,34591,34591,34588,34588,34588,34555,34511,34511,34511,34511,34462,34462,34462,34464,34464,34464,34465,34465,34466,34466,34466,34660,34614,34614,34603,34603,34596,34596,34597,34597,34797,34798,34626,34628,34513,34401,34402,34113,34114,34115,33596,33445,33618,33618,33448,33449,33404,33281,33399,33283,33284,33285,33279,33093,33096,32380,32380,32381,32509,32510,32510,32343,33744,33771,33897,33899,33875,33875,33883,33884,33885,33892,33817,33817,33961,33961,33952,33942,33924,34129,34078,34078,34156,34157,34172,34173,34174,34170,34170,34166,34166,34168,34168,34164,34164,34007,34036,34033,33971,33954,33954,34418,34419,34241,34241,34235,34238,34259,34215,34303,34307,34312,34314,34314,34266,34262,34262,34245,34245,34269,34474,34519,34467,34468,34469,34476,34479,34479,34480,34480,34481,34481,34451,34452,34452,34428,34431,34459,34460,34460,34608,34608,34609,34659,34657,34679,34680,34689,34673,34674,34675,34676,34677,34699,34695,34706,34707,34635,33212,33212,33212,33213,33214,33214,33215,33216,33217,33217,33217,33218,33218,33218,33220,33220,33086,33232,33232,33233,33233,33234,33234,33084,33061,32718,33343,33444,33444,32159,32159,32160,32042,32397,32367,32389,32389,32390,32390,32391,32393,32394,32394,32395,32617,32617,4887,4887,34625,34620,34617,34618,34692,34705,34799,34453,34453,34453,34453,34453,34453,34453,34453,34453,34453,34454,34454,34455,34455,34455,34488,34488,34473,34564,34554,34271,34272,34319,34234,34234,34248,34249,34250,34250,34252,34218,34414,34414,34321,34328,34324,34324,34325,34326,34002,34002,33921,33736,33715,33716,33716,22071,22071,22071,22073,22073,33562,33542,33543,33543,33544,33544,33544,33594,32412,32413,32413,28586,28586,28586,22072,22072,22070,29152,29152,29152,29152,33597,33925,34120,34121,34122,34116,34117,34118,34567,31377,2736,2712,28942,32845,32839,32840,32841,32836,32847,32848,1209,1209,1209,1209,4885,34570,34368,4886,4886
--)
--and  
VarName like '%-Количество шт на паллете%'
ORDER BY cast(VarValue as int)

SELECT * FROM r_ProdValues where VarName like '%-Количество слоев на паллете%' and subum = 'склад20190304'
--delete r_ProdValues where VarName like 'v03%' and subum = 'склад20190304'

insert r_Secs (ChID, SecID, SecName, Notes)
SELECT ROW_NUMBER()OVER(ORDER BY ChID)+ 200000000 ChID,SecID, SecName ,Notes FROM r_SecsDef

SELECT * FROM r_Secs
--delete r_SecsDef

BEGIN TRAN

update r_SecsDef 
set СellYmm = СellYmm + 500
 where ChID % 3 = 0

SELECT * FROM r_SecsDef where ChID % 3 = 0

ROLLBACK TRAN

BEGIN TRAN

update r_SecsDef 
set Notes = 'Этаж '+cast(Floor as varchar)+' Ряд '+cast(Row as varchar)+' Ячейка '+cast(Сell as varchar)

SELECT 'Этаж '+cast(Floor as varchar)+' Ряд '+cast(Row as varchar)+' Ячейка '+cast(Сell as varchar), * FROM r_SecsDef 

ROLLBACK TRAN


BEGIN TRAN

update r_SecsDef 
set OnShow = 0
 where Section = 19

SELECT * FROM r_SecsDef  where Section = 20

ROLLBACK TRAN

insert r_SecsDef
SELECT ChID, SecID, SecName, Notes,1, SortID, SecTypeID, SecXmm, SecYmm, SecZmm, Xmm, Ymm, Zmm, Floor, Row, Section, Сell, MaxWeightKg, DoorXmm, DoorYmm, DoorZmm, СellXmm, СellYmm, СellZmm, BarCode, BarCodeEAN13 FROM r_SecsDef_

SELECT top 720 * 
,(SELECT SUBSTRING((SELECT ' | ' + cast(r.ProdID  as VARCHAR) + '-' + cast(r.PPID  as VARCHAR)  + '=' + cast(cast(r.Qty as int)  as VARCHAR) as [text()] FROM t_rem r WHERE r.StockID in (220,218) and r.Qty <> 0 and sd.SecID = r.SecID FOR XML PATH('')),2,65535) )  Hint
FROM r_SecsDef sd order by chid

SELECT * FROM t_rem r where r.StockID in (220,218) and r.ProdID in (24876,34054) and SecID > 1

SELECT top 240 *  FROM r_SecsDef sd where sd.ChID in (SELECT min(chid) chid FROM r_SecsDef gr group by Floor, Row, Section) order by  sd.ChID
*/



SELECT 
--/*distinct*/ m.stockid,StockName,* 
--count(distinct m.ChID),count(d.ProdID)--2485 рн в месяц 10175 позиций
m.docdate,count(distinct m.ChID),count(d.SrcPosID),sum(qty)
FROM t_Inv m
JOIN t_InvD d on d.ChID = m.ChID
JOIN r_Prods p on p.ProdID = d.ProdID
JOIN r_stocks s on s.StockID = m.StockID
--LEFT JOIN t_SaleDLV lv on lv.ChID = m.ChID and d.SrcPosID = lv.SrcPosID
--LEFT JOIN t_MonRec mr on mr.DocID = m.DocID and mr.OurID = m.OurID
--WHERE m.docdate between '20181001' and '20181031'
WHERE year(m.docdate) = 2018 and month(m.docdate) = 10
and m.OurID = 1
and m.stockid in (30,330,1130,220)
group by m.docdate
ORDER BY 1 desc


SELECT distinct m.DocID FROM t_Inv m
JOIN t_InvD d on d.ChID = m.ChID
 where m.chid in (200186532,200186531,200186533

)ORDER BY 1

--SELECT * FROM r_stocks




SELECT 
--/*distinct*/ m.stockid,StockName,* 
--count(distinct m.ChID),count(d.ProdID)--2485 рн в месяц 10175 позиций
m.chid,max(m.docdate)docdate,max(m.docid)docid,count(d.SrcPosID) 'кол_позиций',sum(qty) кол
FROM t_Inv m
JOIN t_InvD d on d.ChID = m.ChID
JOIN r_Prods p on p.ProdID = d.ProdID
JOIN r_stocks s on s.StockID = m.StockID
--LEFT JOIN t_SaleDLV lv on lv.ChID = m.ChID and d.SrcPosID = lv.SrcPosID
--LEFT JOIN t_MonRec mr on mr.DocID = m.DocID and mr.OurID = m.OurID
WHERE m.docdate = '20181017'
--WHERE year(m.docdate) = 2018 and month(m.docdate) = 10
and m.OurID = 1
and m.stockid in (30,330,1130,220)
group by m.chid
ORDER BY 4 desc

