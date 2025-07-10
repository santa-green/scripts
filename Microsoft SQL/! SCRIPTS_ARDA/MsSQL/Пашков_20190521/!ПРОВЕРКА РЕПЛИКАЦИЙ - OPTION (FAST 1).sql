--EXECUTE AS LOGIN = 'pvm0' 
--GO
--REVERT

use ElitR
select ReplicaEventID, ReplicaSubCode, ExecStr as 'ЦЕНТРАЛЬНЫЙ СЕРВЕР, Днепр [S-SQL-D4].ElitR 10.1.0.155', Status, Msg, DocTime 
from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) where status != 1 ORDER BY ReplicaEventID  OPTION (FAST 1)
GO
select ReplicaEventID, ReplicaSubCode, ExecStr as 'Днепр, локальный сервер [S-MARKETA].ElitV_DP 192.168.70.2', Status, Msg, DocTime 
from [s-marketa].elitv_dp.dbo.z_replicain WITH (NOLOCK) where status != 1 ORDER BY ReplicaEventID  OPTION (FAST 1)
GO
select '' as 's-marketa3', *,'[s-marketa3].ElitRTS301.dbo.z_replicain' from [s-marketa3].ElitRTS301.dbo.z_replicain WITH (NOLOCK) where status != 1 --Harkov
order by replicaeventid  OPTION (FAST 1)
GO
select '' as 's-marketa4', *, '[s-marketa4].ElitRTS181.dbo.z_replicain' from [s-marketa4].ElitRTS181.dbo.z_replicain WITH (NOLOCK) where status != 1 --nagorka
order by replicaeventid  OPTION (FAST 1)
GO
select '' as 'ElitRTS201', *,'[192.168.174.30].ElitRTS201.dbo.z_replicain' from [192.168.174.30].ElitRTS201.dbo.z_replicain WITH (NOLOCK) where status != 1 
order by replicaeventid  OPTION (FAST 1)
GO
select '' as 'ElitRTS302', *, '[192.168.157.22].ElitRTS302.dbo.z_replicain' from [192.168.157.22].ElitRTS302.dbo.z_replicain WITH (NOLOCK) where status != 1 
order by replicaeventid  OPTION (FAST 1)
GO
select '' as 'ElitRTS220', *,'[192.168.174.38].ElitRTS220.dbo.z_replicain' from [192.168.174.38].ElitRTS220.dbo.z_replicain WITH (NOLOCK) where status != 1 
order by replicaeventid  OPTION (FAST 1)
GO
select '' as 'FFood601', *,'[192.168.42.6].FFood601.dbo.z_replicain' from [192.168.42.6].FFood601.dbo.z_replicain WITH (NOLOCK) where status != 1 
order by replicaeventid  OPTION (FAST 1)
GO


/*
select * from [s-marketa4].ElitRTS181.dbo.z_replicain WITH (NOLOCK) where status = 1 --nagorka
order by replicaeventid  OPTION (FAST 1)

select * from [s-marketa4].ElitRTS181.dbo.z_replicaout WITH (NOLOCK) --where status = 1 --nagorka 46763
order by replicaeventid  OPTION (FAST 1)

select * from [s-marketa4].ElitRTS181.dbo.z_ReplicaEvents WITH (NOLOCK)-- where status = 1 --nagorka 46763
order by replicaeventid  OPTION (FAST 1)

15527	1100000000	
z_Replica_INS 1100000000,'z_DocDC','DocCode^;^ChID^;^DCardChID','11035^;^1100036527^;^0',1
2	
The transaction ended in the trigger. The batch has been aborted.  
Невозможно добавление данных в таблицу 'Документы - Дисконтные карты (z_DocDC)'. 
Отсутствуют данные в главной таблице 'Продажа товара оператором: Заголовок (t_Sale)'.	2019-04-16 13:00:00

select * from dbo.z_replicain WITH (NOLOCK) where replicaeventid = 15527 and ReplicaSubCode = 1100000000

BEGIN TRAN

exec z_Replica_INS 1100000000,'z_DocDC','DocCode^;^ChID^;^DCardChID','11035^;^1100036527^;^0',1

SELECT * FROM t_sale where chid = 1100036527

ROLLBACK TRAN

DECLARE @s nvarchar(100) = '%1100036527%'
select  * from z_ReplicaIn where status != 5
and ExecStr like @s + '%'
order by replicaeventid 

z_Replica_INS 1,'r_ProdLV','ProdID^;^LevyID','803925^;^1',1
\
z_Replica_INS 1,'r_ProdLV','ProdID^;^LevyID','803925^;^1',1
z_Replica_INS 1,'r_Prods','ChID^;^ProdID^;^ProdName^;^UM^;^Country^;^Notes^;^PCatID^;^PGrID^;^Article1^;^Article2^;^Article3^;^Weight^;^Age^;^PriceWithTax^;^Note1^;^Note2^;^Note3^;^MinPriceMC^;^MaxPriceMC^;^MinRem^;^CstDty^;^CstPrc^;^CstExc^;^StdExtraR^;^StdExtraE^;^MaxExtra^;^MinExtra^;^UseAlts^;^UseCrts^;^PGrID1^;^PGrID2^;^PGrID3^;^PGrAID^;^PBGrID^;^LExpSet^;^EExpSet^;^InRems^;^IsDecQty^;^File1^;^File2^;^File3^;^AutoSet^;^Extra1^;^Extra2^;^Extra3^;^Extra4^;^Extra5^;^Norma1^;^Norma2^;^Norma3^;^Norma4^;^Norma5^;^RecMinPriceCC^;^RecMaxPriceCC^;^RecStdPriceCC^;^RecRemQty^;^InStopList^;^PrepareTime^;^AmortID^;^PGrID4^;^UseDiscount^;^ScaleGrID^;^ScaleStandard^;^ScaleConditions^;^ScaleComponents^;^PGrID5^;^PGrID6^;^PGrID7^;^UAProdName^;^TaxFreeReason^;^CstProdCode^;^WeightGr^;^WeightGrWP^;^BoxVolume^;^IndWSPriceCC^;^IndRetPriceCC^;^TaxTypeID^;^CstDty2^;^CounID','18050^;^803925^;^''Барон Риказоли Вино Формулае Тоскана Россо красное 3л''^;^''пляш''^;^''Італія''^;^''Барон Ріказолі Вино Формулае Тоскана Россо червоне 3л''^;^0^;^0^;^''''^;^''''^;^''''^;^0.000000000^;^0.000000000^;^1^;^''''^;^''''^;^''''^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^''0''^;^''0''^;^0.000000000^;^0.000000000^;^0^;^0^;^203^;^40014^;^0^;^0^;^34^;^NULL^;^''CurrentDS.PriceCC_wt''^;^1^;^0^;^''''^;^''''^;^''''^;^0^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^13.000000000^;^1.000000000^;^0.000000000^;^2.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0^;^0^;^0^;^2^;^0^;^0^;^NULL^;^NULL^;^NULL^;^28^;^18^;^16^;^''Барон Ріказолі Вино Формулае Тоскана Россо червоне 3л''^;^NULL^;^''2204298000''^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^180.000000000^;^0^;^0.000000000^;^0',1
z_Replica_INS 1,'r_ProdLV','ProdID^;^LevyID','803925^;^1',1	
2	
The transaction ended in the trigger. The batch has been aborted.  
Невозможно добавление данных в таблицу 'Справочник товаров - Сборы (r_ProdLV)'. Отсутствуют данные в главной таблице 'Справочник товаров (r_Prods)'.

SELECT * FROM r_Prods where prodid = 803925
SELECT * FROM [s-marketa].elitv_dp.dbo.r_Prods where prodid = 803925

z_Replica_INS 70000000,'t_MonRec','ChID^;^OurID^;^AccountAC^;^DocDate^;^DocID^;^StockID^;^CompID^;^CompAccountAC^;^CurrID^;^KursMC^;^KursCC^;^SumAC^;^Subject^;^CodeID1^;^CodeID2^;^CodeID3^;^CodeID4^;^CodeID5^;^EmpID^;^StateCode^;^DepID','1700003120^;^12^;^''0''^;^''2019-03-31T00:00:00''^;^1700036685^;^1001^;^1^;^''0''^;^980^;^28.000000000^;^1.000000000^;^12.000000000^;^''''^;^63^;^18^;^75^;^0^;^0^;^10713^;^0^;^0',1
The statement has been terminated.  Violation of PRIMARY KEY constraint 'pk_z_LogCreate'. Cannot insert duplicate key in object 'dbo.z_LogCreate'. The duplicate key value is (11018001, [1700003120]).

SELECT * FROM [192.168.42.6].FFood601.dbo.t_MonRec  ORDER BY 1
SELECT top 10000 * FROM [192.168.42.6].FFood601.dbo.z_LogCreate where TableCode = 11018001 ORDER BY 1
SELECT top 10000 * FROM dbo.z_LogCreate where TableCode = 11018001 ORDER BY 1

select * from dbo.z_replicain WITH (NOLOCK) where status = 1 
and  Msg != ''
order by replicaeventid  OPTION (FAST 1)

update dbo.z_replicain  
set Msg = null 
where status = 1 and  Msg != ''

select * from dbo.z_replicaout WITH (NOLOCK) where 
 status = 2 or Msg != ''
order by replicaeventid  OPTION (FAST 1)

update dbo.z_replicaout  
set Msg = null ,status = 1
where status = 2 and  Msg != ''


select * from [s-marketa4].ElitRTS181.dbo.z_replicain WITH (NOLOCK) where status = 1 --nagorka
and  Msg != ''
order by replicaeventid  OPTION (FAST 1)

update [s-marketa4].ElitRTS181.dbo.z_replicain  
set Msg = null 
where status = 1 and  Msg != ''



a_t_sale_link_for_IM
select top 10 ReplicaEventID, ReplicaSubCode, ExecStr as 'ЦЕНТРАЛЬНЫЙ СЕРВЕР, Днепр [S-SQL-D4].ElitR 10.1.0.155', Status, Msg, DocTime 
from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) where status = 1 ORDER BY ReplicaEventID desc OPTION (FAST 1)

select top 10 '' as 'ElitRTS220', *,'[192.168.174.38].ElitRTS220.dbo.z_replicain' from [192.168.174.38].ElitRTS220.dbo.z_replicain WITH (NOLOCK) 
--where status = 1 
order by replicaeventid desc OPTION (FAST 1)


z_Replica_UPD 19,'r_CompsAC','CompID','11317^;^','CompID^;^CompAccountAC','200593^;^''0''',1	2	
Транзакция завершилась в триггере. Выполнение пакета прервано.  
Невозможно изменение данных в таблице 'Справочник предприятий - Валютные счета (r_CompsAC)'. 
Отсутствуют данные в главной таблице 'Справочник предприятий (r_Comps)'.

SELECT * FROM dbo.r_Comps 
except
SELECT * FROM [192.168.174.38].ElitRTS220.dbo.r_Comps 
except
SELECT * FROM dbo.r_Comps 

SELECT * FROM dbo.r_Comps where chid = 28802 

SELECT * FROM [192.168.174.38].ElitRTS220.dbo.r_Comps where chid = 28802
update [192.168.174.38].ElitRTS220.dbo.r_Comps 
set CompID = 11317
where chid = 28802





DECLARE @s nvarchar(100) = '%800025003%'
select  * from z_ReplicaIn  WITH (NOLOCK)  where status = 1
and ExecStr like @s + '%'
order by replicaeventid 

SELECT * FROM z_ReplicaIn where  ReplicaEventID > 15500 and ReplicaSubCode = 1100000000 ORDER BY ReplicaEventID
SELECT * FROM z_ReplicaIn where  ReplicaEventID in (15525) and ReplicaSubCode = 1100000000
SELECT * FROM z_ReplicaIn where  ReplicaEventID in (15527) and ReplicaSubCode = 1100000000

update z_replicain 
set status = 0
where   ReplicaEventID in (184) and ReplicaSubCode = 800000000


SELECT * FROM [s-marketa].elitv_dp.dbo.z_replicain  where  ReplicaEventID >= 17919010 
and (ExecStr like 'z_Replica_INS%r_ProdLV%ProdID^;^LevyID%')
ORDER BY ReplicaEventID

SELECT * FROM [192.168.42.6].FFood601.dbo.z_replicain  where  ReplicaEventID >= 1 
and (ExecStr like 'z_Replica_INS%r_ProdLV%ProdID^;^LevyID%')
ORDER BY ReplicaEventID


select ReplicaEventID, ReplicaSubCode, ExecStr as 'Днепр, локальный сервер [S-MARKETA].ElitV_DP 192.168.70.2', Status, Msg, DocTime 
from [s-marketa].elitv_dp.dbo.z_replicain WITH (NOLOCK) where status != 1 ORDER BY ReplicaEventID  OPTION (FAST 1)

update [s-marketa].elitv_dp.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17919010,17919048,17919086,17919124,17919162,17919200,17919238,17919276,17919314,17919352,17919390,17919428,17919466,17919517,17919555,17919593,17919631,17919669,17919707,17919745,17919783,17919858,17919896,17919934,17919972,17920010,17920048,17920086,17920124,17920162)
update [s-marketa3].ElitRTS301.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17919010,17919048,17919086,17919124,17919162,17919200,17919238,17919276,17919314,17919352,17919390,17919428,17919466,17919517,17919555,17919593,17919631,17919669,17919707,17919745,17919783,17919858,17919896,17919934,17919972,17920010,17920048,17920086,17920124,17920162)
update [s-marketa4].ElitRTS181.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17919010,17919048,17919086,17919124,17919162,17919200,17919238,17919276,17919314,17919352,17919390,17919428,17919466,17919517,17919555,17919593,17919631,17919669,17919707,17919745,17919783,17919858,17919896,17919934,17919972,17920010,17920048,17920086,17920124,17920162)
update [192.168.174.30].ElitRTS201.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17919010,17919048,17919086,17919124,17919162,17919200,17919238,17919276,17919314,17919352,17919390,17919428,17919466,17919517,17919555,17919593,17919631,17919669,17919707,17919745,17919783,17919858,17919896,17919934,17919972,17920010,17920048,17920086,17920124,17920162)
update [192.168.157.22].ElitRTS302.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17919010,17919048,17919086,17919124,17919162,17919200,17919238,17919276,17919314,17919352,17919390,17919428,17919466,17919517,17919555,17919593,17919631,17919669,17919707,17919745,17919783,17919858,17919896,17919934,17919972,17920010,17920048,17920086,17920124,17920162)
update [192.168.174.38].ElitRTS220.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17919010,17919048,17919086,17919124,17919162,17919200,17919238,17919276,17919314,17919352,17919390,17919428,17919466,17919517,17919555,17919593,17919631,17919669,17919707,17919745,17919783,17919858,17919896,17919934,17919972,17920010,17920048,17920086,17920124,17920162)
update [192.168.42.6].FFood601.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17920630)

*/

/*
==================================================================

--1. лечение. пропусть эту реплику
update z_replicain 
set status = 1
where status != 1 and ReplicaEventID in (184)

==================================================================

--1. лечение. пропусть эту реплику на сетевом сервере 
update [s-marketa].elitv_dp.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17919010)
update [s-marketa3].ElitRTS301.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (16954108)
update [s-marketa4].ElitRTS181.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (16954108)
update [192.168.174.30].ElitRTS201.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (15578276)
update [192.168.157.22].ElitRTS302.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (16954108)
update [192.168.174.38].ElitRTS220.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (16954108)
update [192.168.42.6].FFood601.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (16954108)
==================================================================

--2. лечение. пропусть реплики по условию
--поиск репликций
DECLARE @s nvarchar(100) = '%1100036527%'
select  * from z_ReplicaIn where status != 1
and ExecStr like @s + '%'
order by replicaeventid 

--Изменение статуса на 1 для отмены репликации
update z_replicain 
set status = 1
where status != 1 and ExecStr like @s + '%'

==================================================================

--3. лечение. пропусть реплики по условию
select  * from z_ReplicaIn 
where status != 1 and replicaeventid between 4526 and 4997
order by replicaeventid 

--Изменение статуса на 1 для отмены репликации
update z_replicain 
set status = 1
where status != 1 and replicaeventid between 4526 and 4997

==================================================================

==================================================================
--4. генерировать ExecStr

SELECT ReplicaPubCode, TableCode, DocTime, ReplEventType, PKFields, PKValue, ChangeFields, ChangeFieldValues, ReplicaEventID
,case ReplEventType when 0 then 'z_Replica_INS ' when 1 then 'z_Replica_UPD ' when 2 then 'z_Replica_DEL 'else '' end 
+ cast(ReplicaPubCode as varchar) + ',''' + (SELECT TableName FROM z_tables t where t.TableCode = m.TableCode) + ''','''
+ cast(ChangeFields as varchar(max))+ ''','''+replace(replace(ChangeFieldValues,'''',''''''),'^^;^^1','')+ ''',1' 'ExecStr'
 FROM z_ReplicaEvents m where ReplicaEventID in (15535) 
==================================================================

*/

/*
--киев ElitRTS220 192.168.174.38
--Обновить статусы репликаций которые уже были обработаны 

SELECT * FROM z_replicain
where status != 1 
and ReplicaSubCode = 1600000000
and ReplicaEventID in (SELECT ReplicaEventID FROM [192.168.174.38].ElitRTS220.dbo.z_ReplicaOut WITH (NOLOCK) where status = 1)


update z_replicain 
set status = 1
where status != 1 
and ReplicaSubCode = 1600000000
and ReplicaEventID in (SELECT ReplicaEventID FROM [192.168.174.38].ElitRTS220.dbo.z_ReplicaOut WITH (NOLOCK) where status = 1)

*/

/*
--киев ElitRTS201 192.168.174.30
--Обновить статусы репликаций которые уже были обработаны 

SELECT * FROM z_replicain
where status != 1 
and ReplicaSubCode = 800000000
and ReplicaEventID in (SELECT ReplicaEventID FROM [192.168.174.30].ElitRTS201.dbo.z_ReplicaOut WITH (NOLOCK) where status != 1)


update z_replicain 
set status = 1
where status != 1 
and ReplicaSubCode = 800000000
and ReplicaEventID in (SELECT ReplicaEventID FROM [192.168.174.30].ElitRTS201.dbo.z_ReplicaOut WITH (NOLOCK) where status = 1)

*/

/*
SELECT * FROM z_replicain
where status != 1 
and ReplicaSubCode = 800000000
and ReplicaEventID <= 538645


update z_replicain 
set status = 1
where status != 1 
and ReplicaSubCode = 800000000
and ReplicaEventID <= 538645

*/

/*
select ReplicaEventID, ReplicaSubCode, ExecStr as 'ЦЕНТРАЛЬНЫЙ СЕРВЕР, Днепр [S-SQL-D4].ElitR 10.1.0.155', Status, Msg, DocTime 
from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) where status = 1 
and ReplicaSubCode = 800000000
ORDER BY ReplicaEventID  OPTION (FAST 1)
*/

/*
SELECT * FROM z_ReplicaPubs
SELECT * FROM z_Replicasubs ORDER BY 2

SELECT * FROM z_ReplicaEvents where ReplicaEventID > 17920589 and ReplicaEventID <= 17920627  ORDER BY ReplicaEventID  --17920589 17920627
SELECT * FROM  [s-marketa].elitv_dp.dbo.z_replicain where ReplicaEventID > 17920589 and ReplicaEventID <= 17920627  ORDER BY ReplicaEventID  --17920589 17920627

SELECT * FROM z_ReplicaEvents where TableCode = 10350001 and PKValue = 803925 ORDER BY DocTime desc
select * from z_Tables WHERE TableName = 'r_prods'
select * from z_replicaTables WHERE TableName = 'r_prods'

SELECT * FROM r_PCs
SELECT * FROM z_ReplicaPCs
SELECT * FROM z_ReplicaState
SELECT * FROM z_ReplicaEvents
SELECT * FROM z_ReplicaEvents  where ReplicaEventID = 17688938
SELECT * FROM z_ReplicaEvents  where ReplicaEventID in (17919010,17919011)
SELECT * FROM z_ReplicaOut where ReplicaEventID = 17919011
SELECT * FROM z_Replicain where ReplicaEventID = 17919011
SELECT * FROM [s-marketa].elitv_dp.dbo.z_Replicain where ReplicaEventID in (17919010,17919011)
SELECT * FROM z_ReplicaOut where ReplicaSubCode = 20 and  Status = 1
SELECT * FROM z_ReplicaOut where ReplicaSubCode = 15 and  Status = 1
SELECT * FROM z_ReplicaOut where ReplicaSubCode = 70000000 and  Status = 0


SELECT * FROM z_ReplicaEvents  where ReplicaEventID in (
	SELECT ReplicaEventID FROM z_ReplicaOut where ReplicaSubCode = 21 and  Status = 1
) ORDER BY 3

BEGIN TRAN
SELECT * FROM z_ReplicaOut where ReplicaSubCode = 70000001
update z_ReplicaOut set ReplicaSubCode = 1 where ReplicaSubCode = 70000001

SELECT * FROM z_ReplicaOut where ReplicaSubCode = 70000001

ROLLBACK TRAN


SELECT * FROM z_ReplicaEvents  where TableCode in (10350019,10350001) and ReplicaEventID >= 17919010 and ReplEventType = 0
ORDER BY ReplicaEventID

SELECT * FROM [s-marketa].elitv_dp.dbo.z_replicain  where  ReplicaEventID >= 17919010 
and (ExecStr like 'z_Replica_INS%r_ProdLV%ProdID^;^LevyID%'
or ExecStr like 'z_Replica_INS%r_Prods%ChID^;^ProdID^;^ProdName^;^UM^;%')
ORDER BY ReplicaEventID

SELECT * FROM [s-marketa].elitv_dp.dbo.z_replicain  where  ReplicaEventID >= 17919010 
and (ExecStr like 'z_Replica_INS%r_ProdLV%ProdID^;^LevyID%')
ORDER BY ReplicaEventID

z_Replica_INS 1,'r_Prods','ChID^;^ProdID^;^ProdName^;^UM^;^Country^;^Notes^;^PCatID^;^PGrID^;^Article1^;^Article2^;^Article3^;^Weight^;^Age^;^PriceWithTax^;^Note1^;^Note2^;^Note3^;^MinPriceMC^;^MaxPriceMC^;^MinRem^;^CstDty^;^CstPrc^;^CstExc^;^StdExtraR^;^StdExtraE^;^MaxExtra^;^MinExtra^;^UseAlts^;^UseCrts^;^PGrID1^;^PGrID2^;^PGrID3^;^PGrAID^;^PBGrID^;^LExpSet^;^EExpSet^;^InRems^;^IsDecQty^;^File1^;^File2^;^File3^;^AutoSet^;^Extra1^;^Extra2^;^Extra3^;^Extra4^;^Extra5^;^Norma1^;^Norma2^;^Norma3^;^Norma4^;^Norma5^;^RecMinPriceCC^;^RecMaxPriceCC^;^RecStdPriceCC^;^RecRemQty^;^InStopList^;^PrepareTime^;^AmortID^;^PGrID4^;^UseDiscount^;^ScaleGrID^;^ScaleStandard^;^ScaleConditions^;^ScaleComponents^;^PGrID5^;^PGrID6^;^PGrID7^;^UAProdName^;^TaxFreeReason^;^CstProdCode^;^WeightGr^;^WeightGrWP^;^BoxVolume^;^IndWSPriceCC^;^IndRetPriceCC^;^TaxTypeID^;^CstDty2^;^CounID','18050^;^803925^;^''Барон Риказоли Вино Формулае Тоскана Россо красное 3л''^;^''пляш''^;^''Італія''^;^''Барон Ріказолі Вино Формулае Тоскана Россо червоне 3л''^;^0^;^0^;^''''^;^''''^;^''''^;^0.000000000^;^0.000000000^;^1^;^''''^;^''''^;^''''^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^''0''^;^''0''^;^0.000000000^;^0.000000000^;^0^;^0^;^203^;^40014^;^0^;^0^;^34^;^NULL^;^''CurrentDS.PriceCC_wt''^;^1^;^0^;^''''^;^''''^;^''''^;^0^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^13.000000000^;^1.000000000^;^0.000000000^;^2.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^0^;^0^;^0^;^2^;^0^;^0^;^NULL^;^NULL^;^NULL^;^28^;^18^;^16^;^''Барон Ріказолі Вино Формулае Тоскана Россо червоне 3л''^;^NULL^;^''2204298000''^;^0.000000000^;^0.000000000^;^0.000000000^;^0.000000000^;^180.000000000^;^0^;^0.000000000^;^0',1
*/