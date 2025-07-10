USE Alef_Elit
/*закзы слитые сегодня
select top 1000 *
from DS_Orders o with (nolock) 
where  orDate > cast(getdate() as date)
--where  orNumber like '%arda77%'
--where  MasterFID in (1094499)
ORDER BY orDate desc


SELECT * FROM mobiles where MasterFid in (1094499)
1000122 --Филь Игорь
SELECT * FROM [dbo].[DS_Orders] where MasterFID in (1094499)
SELECT * FROM [dbo].[DS_FACES] where fID in (1094499)
SELECT * FROM [dbo].[DS_FACES] where fID in (1057585)

SELECT * FROM [dbo].[DS_FACES] where fType = 4 and fID in (1094499)
SELECT * FROM [dbo].[DS_FACES] where fType = 4 and fName like '%тест%'

     SELECT * FROM PDA_State WHERE MobID = -1512495580 ORDER BY SendDate desc,Type
     SELECT * FROM dbo.DS_SyncLog WHERE MobID = -1512495580 and LogDate > '2020-11-25 18:24:26.487' ORDER BY LogDate desc
     SELECT * FROM dbo.DS_ActionsLog WHERE ObjectID = -1512495580 and LogDate > '2020-11-25 18:24:26.487' ORDER BY LogDate desc
 
*/

IF 1=1
BEGIN

IF OBJECT_ID (N'tempdb..#N', N'U') IS NOT NULL DROP TABLE #N
CREATE TABLE #N (
--ORDER_NUMBER varchar(max)
orID int
,orDate datetime
,ES_DATA1 int
,ES_DATA2 int
,IOH_ID int
,ZF_DocID int
)
INSERT #N (orID,orDate,ZF_DocID) VALUES (
'30'--orID Номер заказа
,'2021-01-17'--orDate дата слива заказа в КПК '2019-07-15'
,null --'2450'
)
(SELECT * FROM #N)

update #N set ES_DATA1 = (select top 1 orID from DS_Orders o  with (nolock) where orID = (SELECT orID FROM #N) and cast(orDate as date) = (SELECT orDate FROM #N)) 
update #N set ES_DATA2 = (select top 1 MasterFID from DS_Orders o  with (nolock) where orID = (SELECT orID FROM #N) and cast(orDate as date) = (SELECT orDate FROM #N)) 
update #N set IOH_ID = (select top 1 ES_EXP from dbo.ALEF_EXPORT_SUCCESS where ES_SUB = 0 and ES_OUR = 1 
							and ES_DATA1 = (SELECT ES_DATA1 FROM #N)
							and ES_DATA2 = (SELECT ES_DATA2 FROM #N))

--1 синхронизация в КПК
--заказ попадает в DS_Orders
SELECT 'Заказ DS_Orders и DS_Orders_Items'
select top 10 orID,MasterFID,orDate,orShippingDate,ptID,(select p.exid from DS_PRICELISTS p with (nolock) where p.plID = o.PLID) PLID,mfID,orComment,StoreID,CreateDate,*
from DS_Orders o with (nolock) where orID = (SELECT orID FROM #N) and cast(orDate as date) = (SELECT orDate FROM #N)

SELECT top 1000 * FROM [dbo].[DS_Orders_Items] with (nolock) where orID = (SELECT orID FROM #N) and MasterFID = (SELECT ES_DATA2 FROM #N)

SELECT 'таблица ALEF_EXPORT_SUCCESS'
select top 10 * from dbo.ALEF_EXPORT_SUCCESS with (nolock) where ES_DATA1 = (SELECT ES_DATA1 FROM #N) and ES_DATA2 = (SELECT ES_DATA2 FROM #N)
--and ES_SUB = 0 and ES_OUR = 1  


--2 запускается на S-PPC джоб ZAM
--шаг S1 exec dbo.ALEF_EXPORT_ZAM;
SELECT 'Заказ at_t_IORec_С и at_t_IORecD_С'
SELECT top 10 * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С  with (nolock) where IOH_ID = (SELECT IOH_ID FROM #N)
SELECT top 1000 * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORecD_С  with (nolock) where IOD_IOH_ID = (SELECT IOH_ID FROM #N)

--шаг S2 exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=1; --1 заказы КПК

IF (SELECT orID FROM #N) IS NULL
BEGIN
	SELECT 'Заказ внутренний: Формирование по ZF_DocID'
	SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where DocID = (SELECT ZF_DocID FROM #N)
	SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORecD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where  DocID = (SELECT ZF_DocID FROM #N)) ORDER BY 1, SrcPosID
	SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORecD]  ORDER BY ForeCastQty desc

END
ELSE
BEGIN
	SELECT 'Заказ внутренний: Формирование по orID'
	SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where InDocID = CAST((SELECT IOH_ID FROM #N) as varchar(30))
	SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORecD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where InDocID = CAST((SELECT IOH_ID FROM #N) as varchar(30))) ORDER BY 1, SrcPosID
END
--[S-SQL-D4].[Elit].[dbo].ap_OP_OrderProcessing  --Здесь запускается на S-SQL-D4 джоб ELIT OrderProcessing
--в шаге UpdateCodes4 запускаем EXEC [S-SQL-D4].[Elit].[dbo].ap_OP_SetResCodeID4

SELECT 'Заказ внутренний: Резерв'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = (SELECT OrderID FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where InDocID = CAST((SELECT IOH_ID FROM #N) as varchar(30)))--IOH_ORDER
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IOResD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = (SELECT OrderID FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where InDocID = CAST((SELECT IOH_ID FROM #N) as varchar(30)))) ORDER BY 1, SrcPosID

SELECT 'Перемещение товара'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_Exc] where SrcDocID = (SELECT OrderID FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where InDocID = CAST((SELECT IOH_ID FROM #N) as varchar(30)))--IOH_ORDER
SELECT * FROM [S-SQL-D4].[Elit].[dbo].t_ExcD where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_Exc] where SrcDocID = (SELECT OrderID FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where InDocID = CAST((SELECT IOH_ID FROM #N) as varchar(30)))) ORDER BY 1, SrcPosID


-- Здесь Девочки руками делают РН мастером копирования

SELECT 'Расходная накладная'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = (SELECT OrderID FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where InDocID = CAST((SELECT IOH_ID FROM #N) as varchar(30)))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_InvD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = (SELECT OrderID FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where InDocID = CAST((SELECT IOH_ID FROM #N) as varchar(30)))) ORDER BY 1, SrcPosID

	
END









/*МОНИТОР ЗАКАЗОВ*/
SELECT 'Count_New_DS_Orders_КПК' [Name]
,cast((select count(*) 
from DS_Orders o with (nolock)
where orType = 0 and Condition = 1 and fState = 0
and orDate between dateadd(dd,-5,current_timestamp) and dateadd(dd,1,current_timestamp)
and orShippingDate >= CAST(GETDATE() as date)
and not exists (select 1 from [s-sql-d4].elit.dbo.at_t_IORec_С with (nolock) where IOH_ID in (select ES_EXP from dbo.ALEF_EXPORT_SUCCESS with (nolock) where ES_DATA1 = orID and ES_DATA2 = MasterFID))
)  as varchar(50)) [Value]
, 'EXEC ALEF_EXPORT_ZAM' [Scrip_for_Run]
UNION ALL
--,(select count(*)
--from dbo.ALEF_EDI_ORDERS_2  with (nolock)
--join dbo.ALEF_EDI_ORDERS_2_POS  with (nolock) on ZEO_ORDER_ID = ZEP_ORDER_ID
--where ZEO_ORDER_STATUS in (0,1)
--or ZEO_ORDER_ID in (select EOC_ORDER_ID	from dbo.ALEF_EDI_ORDERS_CHANGES  with (nolock)	where EOC_COMMITTED = 0	and EOC_TYPE = 200)
--) ALEF_EDI_ORDERS
SELECT 'Count_New_at_t_IORec_С_КПК' [Name]
,cast((	SELECT count(*)	FROM  [s-sql-d4].elit.dbo.at_t_IORec_С  with (nolock)
	WHERE IOH_STATE = 0	and (1 = 0 	or (1 = 1 and IOH_ORDER is null)or (1 = 2 and IOH_ORDER is not null))		
)  as varchar(50))  
, 'exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=1' [Scrip_for_Run]
UNION ALL
SELECT 'Count_New_at_t_IORec_С_EDI' [Name]
,cast((	SELECT count(*)	FROM  [s-sql-d4].elit.dbo.at_t_IORec_С  with (nolock)
	WHERE IOH_STATE = 0	and (2 = 0 	or (2 = 1 and IOH_ORDER is null)or (2 = 2 and IOH_ORDER is not null))		
)  as varchar(50))  
, 'exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=2' [Scrip_for_Run]
UNION ALL
SELECT 'Count_New_t_IORec_ЗВФ' [Name]
,cast((  SELECT count(*) FROM  [s-sql-d4].elit.dbo.t_IORec m with (nolock)--Заказ внутренний: Формирование: Заголовок
  WHERE (m.StateCode=110) AND (m.OurID<>10) AND  NOT EXISTS (SELECT top 1 1 FROM [s-sql-d4].elit.dbo.z_DocLinks with (nolock)WHERE ParentChID=m.ChID AND ParentDocCode=11221 AND ChildDocCode=11016)
)  as varchar(50))  
, 'exec [S-SQL-D4].[Elit].[dbo].ap_OP_OrderProcessing' [Scrip_for_Run]

--Журнал EDI краткий на сегодня
SELECT top 100 j.name, instance_id, step_id, step_name,  run_date, run_time, run_duration
, substring(RIGHT ('000000' + cast(run_duration as varchar),6),1,2) + ':' +  substring(RIGHT ('000000' + cast(run_duration as varchar),6),3,2) + ':' +  substring(RIGHT ('000000' + cast(run_duration as varchar),6),5,2) длительность
, run_status, sql_message_id, sql_severity, message
FROM  msdb.dbo.sysjobhistory jsh WITH (NOLOCK)
JOIN msdb.dbo.sysjobs j WITH (NOLOCK) ON jsh.job_id = j.job_id
where name = 'EDI' and step_id = 0 
and run_date = CONVERT( varchar, GETDATE(), 112)
ORDER BY instance_id desc

--Журнал ELIT OrderProcessing краткий на сегодня
SELECT top 1000 j.name, instance_id, step_id, step_name,  run_date, run_time, run_duration
, substring(RIGHT ('000000' + cast(run_duration as varchar),6),1,2) + ':' +  substring(RIGHT ('000000' + cast(run_duration as varchar),6),3,2) + ':' +  substring(RIGHT ('000000' + cast(run_duration as varchar),6),5,2) длительность
, run_status, sql_message_id, sql_severity, message
FROM  [s-sql-d4].msdb.dbo.sysjobhistory jsh WITH (NOLOCK)
JOIN [s-sql-d4].msdb.dbo.sysjobs j WITH (NOLOCK) ON jsh.job_id = j.job_id
where name = 'ELIT OrderProcessing' and step_id = 0 
--and run_date = CONVERT( varchar, GETDATE(), 112)
ORDER BY instance_id desc


--Журнал EDI краткий на сегодня по шагу
SELECT top 100 j.name, instance_id, step_id, step_name,  run_date, run_time, run_duration
, substring(RIGHT ('000000' + cast(run_duration as varchar),6),1,2) + ':' +  substring(RIGHT ('000000' + cast(run_duration as varchar),6),3,2) + ':' +  substring(RIGHT ('000000' + cast(run_duration as varchar),6),5,2) длительность
, run_status, sql_message_id, sql_severity, message
FROM  msdb.dbo.sysjobhistory jsh WITH (NOLOCK)
JOIN msdb.dbo.sysjobs j WITH (NOLOCK) ON jsh.job_id = j.job_id
where name = 'EDI' and step_id = 3 
and run_date = CONVERT( varchar, GETDATE(), 112)
ORDER BY instance_id desc

--Состояние службы MAS.Net (Mobile Application Server)
if 1=1 BEGIN
	IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable
	CREATE TABLE #temptable(line nvarchar(max))
	INSERT #temptable(line)	EXEC master..xp_cmdshell  'sc query "Mobile Application Server"'
	--SELECT * FROM #temptable
	select case 
	when EXISTS (SELECT top 1 1 FROM #temptable where line like '%RUNNING%') then '1 - RUNNING'
	when EXISTS (SELECT top 1 1 FROM #temptable where line like '%STOPPED%') then '0 - STOPPED'
	else 'null - ошибка' end 'Состояние службы MAS.Net (Mobile Application Server)'
END

--Журнал EDI
SELECT top 26 j.name, instance_id, step_id, step_name,  run_date, run_time, run_duration,run_status, sql_message_id, sql_severity, message
FROM  msdb.dbo.sysjobhistory jsh WITH (NOLOCK)
JOIN msdb.dbo.sysjobs j WITH (NOLOCK) ON jsh.job_id = j.job_id
where name = 'EDI'
ORDER BY instance_id desc


--Журнал EDI текущий шаг
SELECT top 13 j.name, instance_id, step_id, step_name,  run_date, run_time, run_duration,run_status, sql_message_id, sql_severity, message
FROM  msdb.dbo.sysjobhistory jsh WITH (NOLOCK)
JOIN msdb.dbo.sysjobs j WITH (NOLOCK) ON jsh.job_id = j.job_id
where name = 'EDI'
and  instance_id >= (SELECT max(instance_id) FROM msdb.dbo.sysjobhistory jsh WITH (NOLOCK) 
JOIN msdb.dbo.sysjobs j WITH (NOLOCK) ON jsh.job_id = j.job_id
where name = 'EDI' and step_id = 0 )
ORDER BY instance_id desc


SELECT top 13 'JOB ' + j.name +  ' step_id = ' + cast(step_id as varchar), cast(run_duration as varchar), cast(run_time as varchar) + ' ' +step_name 
  , run_time, run_duration,run_status, sql_message_id, sql_severity, message
FROM  msdb.dbo.sysjobhistory jsh WITH (NOLOCK)
JOIN msdb.dbo.sysjobs j WITH (NOLOCK) ON jsh.job_id = j.job_id
where name = 'EDI'
and  instance_id >= (SELECT max(instance_id) FROM msdb.dbo.sysjobhistory jsh WITH (NOLOCK) 
JOIN msdb.dbo.sysjobs j WITH (NOLOCK) ON jsh.job_id = j.job_id
where name = 'EDI' and step_id = 0 )
ORDER BY instance_id desc




/*

SELECT 'Count_New_at_t_IORec_С_КПК' [Name]
,(	SELECT *	FROM  [s-sql-d4].elit.dbo.at_t_IORec_С  with (nolock)
	WHERE IOH_STATE = 0	and (1 = 0 	or (1 = 1 and IOH_ORDER is null)or (1 = 2 and IOH_ORDER is not null))		
)  as varchar(50))  
, 'exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=1' [Scrip_for_Run]


EXEC ALEF_EXPORT_ZAM
exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=1
exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=2

SELECT top 10 * FROM  msdb.dbo.sysjobhistory   WITH (NOLOCK)

[ap_EDI_Importing_Orders_OT]   

[dbo].[_monitoring_TEST]
*/

select count(*) ALEF_EDI_ORDERS
from dbo.ALEF_EDI_ORDERS_2  with (nolock)
where ZEO_ORDER_STATUS in (0,1)
or ZEO_ORDER_ID in (select EOC_ORDER_ID	from dbo.ALEF_EDI_ORDERS_CHANGES  with (nolock)	where EOC_COMMITTED = 0	and EOC_TYPE = 200)

select count(*) ALEF_EDI_ORDERS
from dbo.ALEF_EDI_ORDERS_2  with (nolock)
where ZEO_ORDER_STATUS in (0,1)





/* 
select top 100 
orDate 'Дата создания'
,(SELECT exid FROM DS_Faces f where f.fID = o.MasterFID) MasterFID
,(SELECT fShortName FROM DS_Faces f where f.fID = o.MasterFID) MasterFID
,cast(substring((SELECT exid FROM DS_Faces f where f.fID = o.mfID),1,7) as int) CompID
,(SELECT fShortName FROM DS_Faces f where f.fID = o.mfID) fShortName
,(SELECT fAddress FROM DS_Faces f where f.fID = o.mfID) fAddress
,'грн' Валюта
,orSum Сумма
, 1 'Назначение платежа'
, 63 'Примечание'
,(SELECT exid FROM DS_Faces f where f.fID = o.mfID)
,* 
from DS_Orders o with (nolock) where orType = 56
ORDER BY cast(orDate as date),2


SELECT * FROM [s-sql-d4].elit.dbo.r_emps where EmpID = 1948
SELECT * FROM DS_Faces where fType = 4


select count(*)	from dbo.ALEF_EDI_ORDERS_CHANGES  with (nolock)	where EOC_COMMITTED = 0	and EOC_TYPE = 200

		SELECT top 10 * FROM  msdb.dbo.sysjobstepslogs jsl WITH (NOLOCK)
        JOIN msdb.dbo.sysjobsteps js WITH (NOLOCK) ON jsl.step_uid = js.step_uid 
        JOIN msdb.dbo.sysjobs j WITH (NOLOCK) ON js.job_id = j.job_id
		where name = 'EDI'


EXEC msdb.dbo.sp_start_job N'S-ppc_Check_TimeRunJobs' ; 
EXEC msdb.dbo.sp_start_job N'ZAM'; 
EXEC msdb.dbo.sp_start_job N'EDI'; 

USE msdb ; EXEC dbo.sp_stop_job N'zam'

EXEC sp_Locks 

--поздний сброс
 SELECT * FROM  [s-sql-d4].elit.dbo.[at_t_IORes] m with (nolock)--Заказ внутренний: Формирование: Заголовок
  WHERE (m.StateCode=203) and DocDate > '2019-07-17'


--1 синхронизация в КПК
--заказ попадает в DS_Orders
	select orID,MasterFID,orDate,orShippingDate,ptID,(select p.exid from DS_PRICELISTS p with (nolock) where p.plID = o.PLID),mfID,orComment,StoreID,CreateDate
	,*
	from DS_Orders o with (nolock)
	where orType = 0
	-- only active orders
	and Condition = 1
	-- only new orders
	--and fState = 0
	--and orDate between @periodFrom and @periodTo
	--and orShippingDate < '2019-07-09' -- блокировка заказов
	and orShippingDate >= CAST(GETDATE() as date)
	--and not exists (select 1 from [s-sql-d4].elit.dbo.at_t_IORec_С with (nolock) where IOH_ID in (select ES_EXP from dbo.ALEF_EXPORT_SUCCESS with (nolock) where ES_DATA1 = orID and ES_DATA2 = MasterFID))
	ORDER BY 3 desc

--2 запускается на S-PPC джоб ZAM
--шаг S1 exec dbo.ALEF_EXPORT_ZAM;
declare @periodFrom as smalldatetime = dateadd(dd,-5,current_timestamp)
declare @periodTo as smalldatetime = dateadd(dd,1,current_timestamp)
	-- Достаем свежие шапки-ушанки
	--insert #resTable(h_orID,h_repID,h_orDate,h_orShippingDate,h_PtID,h_plID,h_fID,h_orComment,h_Stock,h_CreateDate)
	select orID,MasterFID,orDate,orShippingDate,ptID,(select p.exid from DS_PRICELISTS p with (nolock) where p.plID = o.PLID),mfID,orComment,StoreID,CreateDate
	,*
	from DS_Orders o with (nolock)
	where orType = 0
	-- only active orders
	and Condition = 1
	-- only new orders
	--and fState = 0
	and orDate between @periodFrom and @periodTo
	--and orShippingDate < '2016-02-23' -- блокировка заказов
	and orShippingDate >= CAST(GETDATE() as date)
	and not exists (select 1 from [s-sql-d4].elit.dbo.at_t_IORec_С with (nolock) where IOH_ID in (select ES_EXP from dbo.ALEF_EXPORT_SUCCESS with (nolock) where ES_DATA1 = orID and ES_DATA2 = MasterFID))
	ORDER BY 3 desc


	select top 100 orID,MasterFID,orDate,orShippingDate,ptID,(select p.exid from DS_PRICELISTS p with (nolock) where p.plID = o.PLID) PLID,mfID,orComment,StoreID,CreateDate,*
	from DS_Orders o  with (nolock)
	where orID = 22514
	--where orDate > '2019-07-05 00:13:48.000' and  orDate < '2019-07-05 23:13:48.000'
	ORDER BY 3 desc

	select orID,MasterFID,orDate,orShippingDate,ptID,(select p.exid from DS_PRICELISTS p with (nolock) where p.plID = o.PLID) PLID,mfID,orComment,StoreID,CreateDate,*
	from DS_Orders o  with (nolock)
	where orType = 0
	-- only active orders
	and Condition = 1
	-- only new orders
	and fState = 0
	and orShippingDate >= CAST(GETDATE() as date)
	and not exists (select 1 from [s-sql-d4].elit.dbo.at_t_IORec_С with (nolock) where IOH_ID in (select ES_EXP from dbo.ALEF_EXPORT_SUCCESS with (nolock) where ES_DATA1 = orID and ES_DATA2 = MasterFID))
	ORDER BY 3 desc


SELECT top 1000 * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С 
where IOH_EMP = 1405 --код торгового
--where IOH_COMP = 73227 --код точки
ORDER BY IOH_ADD_DATE desc

	SELECT exid 'h_CityID =',
	 case when 10001 = 10002 then 4 else exid end 'h_code3 =',*
	from DS_FacesAttributes fa with(nolock),
		 DS_AttributesValues av with(nolock)
	where fa.AttrId = 30
	and fa.ActiveFlag = 1
	and av.AttrId = fa.AttrId
	and av.AttrValueID = fa.AttrValueID
	and 1093933 = fa.fid
	and 0 = 0

	SELECT top 100 * FROM DS_FacesAttributes fa where fa.AttrId = 30 and fa.ActiveFlag = 1 and AttrValueID = 305668 and 1093933 = fa.fid
	SELECT top 100 * FROM DS_AttributesValues av where av.AttrId = 30 and av.AttrValueID = 305668




--SELECT 'Заказ at_t_IORec_С и at_t_IORecD_С'
--SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С where IOH_ORDER = CAST(@docid as varchar(30))
--SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORecD_С where IOD_IOH_ID in (SELECT IOH_ID FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С where IOH_ORDER = CAST(@docid as varchar(30))) ORDER BY 1, IOD_POS


--шаг S2 exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=1; --1 заказы КПК, 

*/
--DECLARE @docid int = 45215838

---------------------------
--Microsoft Excel  Отчеты_(06_08_14).xlsm кнопка Запуск
---------------------------
/*
exec dbo.ALEF_REPORT_ORDERS_2 '6571','08.07.2019','09.07.2019';
*/
---------------------------
---------------------------
--Microsoft Excel Отчеты_(06_08_14).xlsm кнопка Импорт ТРТ
---------------------------
--exec dbo.ALEF_IMPORT_KLIENTS '4358'
---------------------------
--	select distinct Splitcolumn
--	from dbo.ALEF_Split('4358-6307',';')
--	where ISNUMERIC(Splitcolumn) = 1
-----------------------------

--SELECT * FROM  [s-sql-d4].Elit.dbo.[zf_FilterToTable]('4358,6307')

--SELECT top 100 * FROM DS_Orders o (nolock) ORDER BY CreateDate desc


--select top 100 * from ALEF_EDI_ORDERS_2 m ORDER BY  ZEO_AUDIT_DATE desc


/*
DECLARE @docid VARCHAR(max) = '1125116153'

SELECT 'Заказ ALEF_EDI_ORDERS_2 и ALEF_EDI_ORDERS_2_POS'
SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = CAST(@docid as varchar(30))
SELECT * FROM ALEF_EDI_ORDERS_2_POS where ZEP_ORDER_ID in (SELECT ZEO_ORDER_ID FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = CAST(@docid as varchar(30))) ORDER BY 1, ZEP_POS_ID

--[ap_EDI_Importing_Orders_OT]   --Здесь запускается на S-PPC джоб EDI
/*
кнопка Перезалить Заказы меняет поле EOC_COMMITTED на 0 в таблице ALEF_EDI_ORDERS_CHANGES (Alef_Elit)
select * from dbo.ALEF_EDI_ORDERS_CHANGES where EOC_COMMITTED = 0
and EOC_TYPE = 200
*/

SELECT 'Заказ at_t_IORec_С и at_t_IORecD_С'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С where IOH_ORDER = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORecD_С where IOD_IOH_ID in (SELECT IOH_ID FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С where IOH_ORDER = CAST(@docid as varchar(30))) ORDER BY 1, IOD_POS


SELECT 'Заказ внутренний: Формирование'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORecD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID

--[S-SQL-D4].[Elit].[dbo].ap_OP_OrderProcessing  --Здесь запускается на S-SQL-D4 джоб ELIT OrderProcessing

SELECT 'Заказ внутренний: Резерв'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IOResD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID

-- Здесь Девочки руками делают РН мастером копирования

SELECT 'Расходная накладная'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_InvD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID
*/
/*

SELECT * FROM [S-SQL-D4].[Elit].[dbo].t_Rem where prodid in (34405)
SELECT * FROM [S-SQL-D4].[Elit].[dbo].t_Rem where prodid in (34405)

SELECT rpec.ProdID, m.ZEO_ORDER_ID, d.ZEP_POS_KOD, d.ZEP_POS_QTY, tiord.Qty, tiord.Qty/d.ZEP_POS_QTY AS 'Metro_val'
FROM ALEF_EDI_ORDERS_2 m
JOIN ALEF_EDI_ORDERS_2_POS d ON d.ZEP_ORDER_ID = m.ZEO_ORDER_ID
JOIN [S-SQL-D4].[Elit].[dbo].[t_IORec] tior ON tior.OrderID = m.ZEO_ORDER_NUMBER
JOIN [S-SQL-D4].[Elit].[dbo].[t_IORecD] tiord ON  tiord.ChID = tior.ChID
JOIN [S-SQL-D4].[Elit].[dbo].[r_ProdEC] rpec ON rpec.ProdID = tiord.ProdID AND rpec.ExtProdID = d.ZEP_POS_KOD AND rpec.CompID = tior.CompID
WHERE m.ZEO_AUDIT_DATE > '20170101' AND tior.CompID in (7001,7003,7002) --AND d.ZEP_POS_QTY != 0--m.ZEO_ORDER_ID = '463620540'
ORDER BY 6,1

SELECT * FROM ALEF_EDI_ORDERS_2 m
JOIN ALEF_EDI_ORDERS_2_POS d ON d.ZEP_ORDER_ID = m.ZEO_ORDER_ID
WHERE m.ZEO_AUDIT_DATE > '20190301' AND d.ZEP_POS_QTY = 0



SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С where IOH_ORDER = '600008086'
SELECT * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORecD_С where IOD_IOH_ID = 1042867

SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = '600008086'


select ZEO_ORDER_ID from dbo.ALEF_EDI_ORDERS_2
Код статуса	Значение статуса
0	Новый заказ
1	Заливается в ОТ
3	Блокировка менеджера
4	Задублированный
5	Заказ залит в ОТ
31	Новый адрес, нет соответствия
32	Дата доставки меньше текущей
33	Неизвестный внешний код товара
34	Не установлен прайс лист
35	Не установлена отсрочка платежа
36	Нет цены для товара
37	Нет сканкода для товараа
38	Пустой заказ
39	Уже есть накладная
null	Неизвестная ошибка

SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_ID IN (SELECT ZEP_ORDER_ID FROM ALEF_EDI_ORDERS_2_POS where ZEP_POS_KOD IN ('6032166','6032033','6032152','6032173','6032427'))
SELECT * FROM ALEF_EDI_ORDERS_2_POS where ZEP_POS_KOD IN ('6032166','6032033','6032152','6032173','6032427')

SELECT * FROM [S-SQL-D4].[Elit].[dbo].r_ProdEC 

SELECT DISTINCT ProdID from r_ProdEC rpe WHERE rpe.ExtProdID IN ('1135889','6032166','6032033','6032173','1135894','1135923','1135924','1135928','1135891','6032152','6032427','1135898')
AND rpe.ProdID NOT IN (26213,31815,31874,29151,28585,28586,29152,31878,26168,31880,3127 ,31879,30843)


SELECT * FROM z_tables

SELECT top 1000 * FROM [S-SQL-D4].[Elit].[dbo].at_t_IORec_С 
where IOH_DEP_DATE = '2019-01-21 00:00:00.000' and IOH_STOCK = 11
ORDER BY 3 desc

--ap_EDI_Importing_Orders_OT
*/
/*
IF OBJECT_ID (N'tempdb..#EDI2OT', N'U') IS NOT NULL DROP TABLE #EDI2OT

select
-- Existing Staff
ZEO_ORDER_ID,
ZEO_ORDER_NUMBER,
ZEO_ORDER_DATE,
(SELECT TOP 1 ZEC_KOD_KLN_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_KOD, --700
(SELECT TOP 1 ZEC_KOD_ADD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_ADD,--1001
(SELECT TOP 1 ZEC_KOD_SKLAD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_SKL,
(SELECT TOP 1 ZEC_KOD_BASE FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_BASE,
cast(0 as tinyint) as ZEO_OT_SKL_CH,
cast('' as varchar(200)) ZEO_NOTE,
ZEP_POS_ID, 
ZEP_POS_KOD, 
ZEP_POS_QTY, 
ZEO_AUDIT_DATE,
ZEO_XML_HEAD,
-- New Staff
cast(0 as int) as ZE_ORDER_ExID,
cast(0 as tinyint) as ZE_ORDER_SubID,
cast(0 as smallint) as ZE_KLN_OT_DELAY,
cast(0 as smallint) as ZE_KLN_OT_PRICE,
cast('' as varchar(200)) as ZE_KLN_OT_JOB3,
cast(0 as int) as ZE_POS_OT_KOD,
cast('' as varchar(42)) as ZE_POS_BAR,
cast(0 as numeric(21,9)) as ZE_POS_CENA,
cast(4 as int) as ZE_CODE_3,
cast(110 as int) as ZE_STATUS,
cast(0 as tinyint) as ZE_READY_STATUS
 into #EDI2OT
from dbo.ALEF_EDI_ORDERS_2 
join dbo.ALEF_EDI_ORDERS_2_POS on ZEO_ORDER_ID = ZEP_ORDER_ID
where 
ZEO_ORDER_ID in (28572)
--ZEO_ORDER_STATUS in (0,1)
--or ZEO_ORDER_ID in (
--	select EOC_ORDER_ID
--	from dbo.ALEF_EDI_ORDERS_CHANGES
--	where EOC_COMMITTED = 0
--	and EOC_TYPE = 200)

SELECT * FROM #EDI2OT

update #EDI2OT
set
ZE_POS_OT_KOD = SelectedProd
from
	(select ZEO_ORDER_ID, ZEP_POS_ID, MAX(ProdID) SelectedProd 
	from 
		(select ZEO_ORDER_ID, ZEP_POS_ID, ZEP_POS_QTY, ProdID, Rem, MAX(Rem) OVER(partition by ZEO_ORDER_ID, ZEP_POS_ID) MaxRem 
		from 
			(
			select ZEO_ORDER_ID, ZEP_POS_ID, ZEP_POS_QTY, ProdID, isnull((select sum(Qty-AccQty) from [s-sql-d4].Elit.dbo.t_Rem r where r.ProdID = ec.ProdID and StockID = ZEO_OT_SKL),0) Rem 
			from [s-sql-d4].Elit.dbo.r_ProdEC ec 
			join #EDI2OT t on ExtProdID = ZEP_POS_KOD and Compid = ZEO_OT_KOD 
					--Pashkovv '2019-04-02 11:51:10.920' теперь в альтернативные товары попадают только товары которые присутствуют в прайсе 66
		and exists(SELECT top 1 1 FROM [s-sql-d4].Elit.dbo.r_ProdMP mp 
					where mp.PLID = (SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = ZEO_OT_KOD) 
					and mp.ProdID = ec.ProdID
					)

			) as R
		) as RR
	where Rem = MaxRem or Rem >= ZEP_POS_QTY
	group by ZEO_ORDER_ID, ZEP_POS_ID) as Pr
where Pr.ZEO_ORDER_ID = #EDI2OT.ZEO_ORDER_ID
and Pr.ZEP_POS_ID = #EDI2OT.ZEP_POS_ID
and ZE_POS_OT_KOD = 0
and ZE_READY_STATUS = 0

SELECT * FROM #EDI2OT

SELECT PLID,UsePL,* FROM [s-sql-d4].Elit.dbo.r_Comps ORDER BY 1
SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = ZEO_OT_KOD

-- Разделяем по складам 4 и 1104; 220 и 1130; 11 и 1111 
create table #MarketA(
or_ID varchar(12),
or_Sklad smallint,
or_PosID smallint,
alt_ProdID int,
alt_ProdQty int
);

;with kika as(
	select 
	ZEO_ORDER_ID,
	ZEO_OT_SKL,
	ZEP_POS_ID,
	ZEP_POS_QTY,
	ROW_NUMBER() over(partition by ZEO_ORDER_ID,ZEP_POS_ID order by ALT_QTY desc) ROW_ID,
	ALT_PROD,
	ALT_QTY
	from 
		(
		select ZEO_ORDER_ID, case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end ZEO_OT_SKL, ZEP_POS_ID, ZEP_POS_QTY,
		ec.prodid ALT_PROD, isnull((select sum(Qty) from [s-sql-d4].Elit.dbo.t_Rem r where ec.ProdID = r.ProdID and StockID = case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end),0) ALT_QTY
		from #EDI2OT
		inner join [s-sql-d4].Elit.dbo.r_ProdEC ec on Compid = ZEO_OT_KOD and extprodid = ZEP_POS_KOD
		where ZEO_OT_KOD in (10797,10798)
		and ZEO_OT_SKL in (4,11,220)
		and ZEO_OT_SKL_CH = 0
		and ZEP_POS_QTY > 0
		) as T
	where ALT_QTY > 0
)
insert #MarketA
select ZEO_ORDER_ID, ZEO_OT_SKL, ZEP_POS_ID, ALT_PROD, case when ZEP_POS_QTY >= STOCKS then ALT_QTY else ZEP_POS_QTY - (STOCKS - ALT_QTY) end QTY
from
	(select *,	(select SUM(ALT_QTY) from kika k2 where k1.ZEO_ORDER_ID = k2.ZEO_ORDER_ID and k1.ZEP_POS_ID = k2.ZEP_POS_ID and k2.ROW_ID <= k1.ROW_ID) STOCKS
	from kika k1) as T
where ZEP_POS_QTY >= STOCKS
or (ZEP_POS_QTY < STOCKS and ZEP_POS_QTY > isnull((select SUM(ALT_QTY) from kika k where k.ZEO_ORDER_ID = T.ZEO_ORDER_ID and k.ZEP_POS_ID = T.ZEP_POS_ID and k.ROW_ID < T.ROW_ID),0))

SELECT * FROM #MarketA
SELECT * FROM #EDI2OT


		select ZEO_ORDER_ID, case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end ZEO_OT_SKL, ZEP_POS_ID, ZEP_POS_QTY,
		ec.prodid ALT_PROD,
		 isnull((select sum(Qty) from [s-sql-d4].Elit.dbo.t_Rem r where ec.ProdID = r.ProdID and StockID = case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end),0) ALT_QTY
		from #EDI2OT
		inner join [s-sql-d4].Elit.dbo.r_ProdEC ec on Compid = ZEO_OT_KOD and extprodid = ZEP_POS_KOD
		where ZEO_OT_KOD in (10797,10798)
		and ZEO_OT_SKL in (4,11,220)
		and ZEO_OT_SKL_CH = 0
		and ZEP_POS_QTY > 0
		and exists(SELECT top 1 1 FROM [s-sql-d4].Elit.dbo.r_ProdMP mp 
					where mp.PLID = (SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = ZEO_OT_KOD) 
					and mp.ProdID = ec.ProdID
					)

		SELECT * FROM [s-sql-d4].Elit.dbo.r_prodmp where PLID = 66 and ProdID = 32479


			select ZEO_ORDER_ID, ZEP_POS_ID, ZEP_POS_QTY, ProdID, isnull((select sum(Qty-AccQty) from [s-sql-d4].Elit.dbo.t_Rem r where r.ProdID = ec.ProdID and StockID = ZEO_OT_SKL),0) Rem 
			from [s-sql-d4].Elit.dbo.r_ProdEC ec 
			join #EDI2OT t on ExtProdID = ZEP_POS_KOD and Compid = ZEO_OT_KOD 
			--Pashkovv '2019-04-02 11:51:10.920' теперь в альтернативные товары попадают только товары которые присутствуют в прайсе 66
			and exists(SELECT top 1 1 FROM [s-sql-d4].Elit.dbo.r_ProdMP mp 
						where mp.PLID = (SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = ZEO_OT_KOD) 
						and mp.ProdID = ec.ProdID
						)


select
-- Existing Staff
(SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where c.UsePL = 1 and c.CompID = (SELECT TOP 1 ZEC_KOD_KLN_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD)) plid,
ZEO_ORDER_ID,
ZEO_ORDER_NUMBER,
ZEO_ORDER_DATE,
(SELECT TOP 1 ZEC_KOD_KLN_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_KOD, --700
(SELECT TOP 1 ZEC_KOD_ADD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_ADD,--1001
(SELECT TOP 1 ZEC_KOD_SKLAD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_SKL,
(SELECT TOP 1 ZEC_KOD_BASE FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_BASE,
cast(0 as tinyint) as ZEO_OT_SKL_CH,
cast('' as varchar(200)) ZEO_NOTE,
ZEP_POS_ID, 
ZEP_POS_KOD, 
ZEP_POS_QTY, 
ZEO_AUDIT_DATE,
ZEO_XML_HEAD,
-- New Staff
cast(0 as int) as ZE_ORDER_ExID,
cast(0 as tinyint) as ZE_ORDER_SubID,
cast(0 as smallint) as ZE_KLN_OT_DELAY,
cast(0 as smallint) as ZE_KLN_OT_PRICE,
cast('' as varchar(200)) as ZE_KLN_OT_JOB3,
cast(0 as int) as ZE_POS_OT_KOD,
cast('' as varchar(42)) as ZE_POS_BAR,
cast(0 as numeric(21,9)) as ZE_POS_CENA,
cast(4 as int) as ZE_CODE_3,
cast(110 as int) as ZE_STATUS,
cast(0 as tinyint) as ZE_READY_STATUS
 --into #EDI2OT
from dbo.ALEF_EDI_ORDERS_2 
join dbo.ALEF_EDI_ORDERS_2_POS on ZEO_ORDER_ID = ZEP_ORDER_ID
where ZEO_ORDER_STATUS in (0,1)
or ZEO_ORDER_ID in (
	select EOC_ORDER_ID
	from dbo.ALEF_EDI_ORDERS_CHANGES
	where EOC_COMMITTED = 0
	and EOC_TYPE = 200)


SELECT * from dbo.ALEF_EDI_ORDERS_2 
join dbo.ALEF_EDI_ORDERS_2_POS on ZEO_ORDER_ID = ZEP_ORDER_ID
where ZEO_ORDER_STATUS in (0,1) 

SELECT * FROM DS_items where iName like '%-%'
SELECT len(iName),len(iShortName),* FROM DS_items where len(iidText) < 6  AND len(iName) >94 ORDER BY 1 desc
SELECT len(iName),len(iShortName),* FROM DS_items ORDER BY 1 desc
SELECT * FROM DS_items ORDER BY len(iidText) desc,2
SELECT * FROM [s-sql-d4].Elit.dbo.r_prods ORDER BY 2 desc

SELECT * FROM DS_Items 
where len(iidText) < 6 and  len(iName) < 95 
ORDER BY 2




BEGIN TRAN

--update DS_Items set iName = '=' + iName
--where iName like '%=%'

--противоядие для отмены кодов в названии товаров
--update DS_Items set iName =  SUBSTRING (iName,PATINDEX ('%=%',iName) + 1,200)
--where len(iidText) < 6 and iName like '%=%'

--SELECT PATINDEX ('%=%',iName) , SUBSTRING (iName,PATINDEX ('%=%',iName) + 1,200),* FROM DS_Items
--where len(iidText) < 6 and iName like '%=%'

--SELECT * FROM DS_Items 
--where len(iidText) < 6
--ORDER BY 2

SELECT * FROM DS_Items 
where iID in (
1007240,1007168,1007216,1007312,1007224,1007220,1007172,1007158,1007159,1007161,1007290,1007162,1007163,1007164,1007160,1007165,1007149,1007150,1007151,1007152,1007153,1007154,1007155,1007156,1007208,1007305,1007148,1007306,1007169,1007170,1007171,1007194,1007190,1007294,1007191,1007195,1007196,1007197,1007178,1007295,1007296,1007186,1007187,1007188,1007189,1007166,1007167,1007181,1007182,1007183,1007184,1007297,1007298,1007299,1007300,1007185,1007157,1007307,1007176,1007177,1007308,1007309,1007310,1007198,1007199,1007200,1007201,1007232,1007233,1007209,1007210,1007211,1007212,1007213,1007214,1007302,1007204,1007192,1007180,1007193,1007243,1007173,1007174,1007205,1007175,1007206,1007207,1007179,1007265,1007266,1007267,1007268,1007257,1007287,1007273,1007288,1007255,1007246,1007258,1007303,1007218,1007274,1007275,1007251,1007252,1007253,1007254,1007286,1007278,1007263,1007264,1007301,1007280,1007250,1007279,1007272,1007311,1007283,1007203,1007217,1007261,1007289,1007262,1007245,1007256,1007276,1007277,1007221,1007222,1007223,1007244,1007269,1007284,1007285,1007270,1007271,1007202,1007281,1007259,1007304,1007260,1007219,1007215,1007234,1007241,1007242,1007225,1007291,1007292,1007247,1007235,1007293,1007248,1007236,1007226,1007237,1007227,1007249,1007228,1007229,1007230,1007231,1007238,1007239,1007313,1007314,1007315,1007282,1007316
)

SELECT * FROM DS_Items 
where len(iidText) < 6 and  len(iName) > 95 and iName not like '%=%'
ORDER BY 2




SELECT len(iName), * FROM DS_Items ORDER BY 1 desc


ROLLBACK TRAN
*/





--проверка на названия больше 100 символов
SELECT len(iName), * FROM DS_Items 
where len(iidText) < 6 
and  len(iName) > 93
and iName not like '%=%'
ORDER BY 2

--товары к обновлению
SELECT * FROM DS_Items 
where len(iidText) < 6 and  len(iName) < 93 and iName not like '%=%'
ORDER BY 2

BEGIN TRAN

--добавить коды в название товаров
update DS_Items set iName = '=' + iidText + '=' + iName
where len(iidText) < 6 and  len(iName) < 93 and iName not like '%=%'

ROLLBACK TRAN

