/*создаем временный обработанный лог */

IF OBJECT_ID (N'tempdb..#LogPrint', N'U') IS NOT NULL DROP TABLE #LogPrint

SELECT (SELECT AppName FROM z_Apps a where a.AppCode = ap.AppCode) AppName 
,*,
case
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else ap.FileName end NewFileName
 into #LogPrint
FROM z_LogPrint ap ORDER BY NewFileName

SELECT * FROM #LogPrint ORDER BY NewFileName
SELECT * FROM #LogPrint where NewFileName like '%MeDoc%'


IF OBJECT_ID (N'tempdb..#AppPrints', N'U') IS NOT NULL DROP TABLE #AppPrints
SELECT distinct
case
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else ap.FileName end NewFileName
 into #AppPrints
FROM z_AppPrints ap ORDER BY NewFileName
SELECT * FROM #AppPrints ORDER BY NewFileName

IF OBJECT_ID (N'tempdb..#DocPrints', N'U') IS NOT NULL DROP TABLE #DocPrints
SELECT distinct
case
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',ap.FileName) <> 0 then replace(ap.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',ap.FileName) <> 0 then replace(ap.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else ap.FileName end NewFileName
 into #DocPrints
FROM z_DocPrints ap ORDER BY NewFileName
SELECT * FROM #DocPrints ORDER BY NewFileName

--общее количество печатей
SELECT * FROM (

SELECT * 
,(SELECT count(*) FROM #LogPrint lp with (nolock) where lp.NewFileName = m.NewFileName) 'кол'
FROM (
SELECT * FROM #AppPrints
union 
SELECT * FROM #DocPrints
) m 

) s1 
--where кол = 0
ORDER BY 2 desc

----------------------------------------------------------------------------------


SELECT * 
,(SELECT count(*) FROM #LogPrint lp with (nolock) where lp.NewFileName = m.NewFileName) 'кол'
FROM (
SELECT * FROM #AppPrints
union 
SELECT * FROM #DocPrints
) m ORDER BY 1


SELECT (SELECT AppName FROM z_Apps a where a.AppCode = m.AppCode) AppName,* FROM z_AppPrints m where FileName like '%test_TaxDocs.fr3%'
SELECT (SELECT DocName FROM z_Docs d where d.DocCode = m.DocCode) DocName ,* FROM z_DocPrints m where FileName like '%test_TaxDocs.fr3%'


--SELECT * into z_AppPrints_old FROM z_AppPrints
--SELECT * into z_DocPrints_old FROM z_DocPrints


SELECT (SELECT DocName FROM z_Docs d where d.DocCode = m.DocCode) DocName,* FROM z_DocPrints m ORDER BY 1,FileDesc
SELECT (SELECT AppName FROM z_Apps d where d.AppCode = m.AppCode) AppName,* FROM z_AppPrints m ORDER BY 1,FileDesc
SELECT * FROM z_AppPrints where  AppCode = 11000 ORDER BY FileDesc
SELECT * FROM z_AppPrints where FileName like '\%'
SELECT * FROM z_DocPrints where FileName like '\%'

SELECT * FROM z_AppPrints where FileName like 'финансы%'
SELECT * FROM z_DocPrints where FileName like 'финансы%'
SELECT * FROM z_DocPrints where DocCode = 11012 ORDER BY FileDesc
SELECT * FROM z_DocPrints_old where FileName like 'Анализатор.fr3%'

--получаем кол печатей z_AppPrints
SELECT (SELECT AppName FROM z_Apps a where a.AppCode = m.AppCode) AppName 
,(SELECT count(*) FROM #LogPrint lp with (nolock) where lp.AppCode = m.AppCode and lp.NewFileName = 
case 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',m.FileName) <> 0 then replace(m.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else m.FileName end ) 'кол печати'
,AppCode,FileName
, FileDesc, OldFileName 
FROM z_AppPrints m ORDER BY 1,FileDesc 

--получаем кол печатей z_DocPrints
SELECT (SELECT DocName FROM z_Docs d where d.DocCode = m.DocCode) DocName 
,(SELECT count(*) FROM #LogPrint lp with (nolock) where lp.DocCode = m.DocCode and lp.NewFileName = 
case 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',m.FileName) <> 0 then replace(m.FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',m.FileName) <> 0 then replace(m.FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',m.FileName) <> 0 then replace(m.FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else m.FileName end ) 'кол печати'
,DocCode,FileName
, FileDesc, OldFileName 
FROM z_DocPrints m ORDER BY 1,FileDesc 


/* Elit_ARHIV
дубли по ПФ в z_AppPrints
Финансы	12000	Бизнес\Дополнительные отчёты\Акт сверки (укр) АКВАВИТ.fr3	Бизнес\Дополнительные отчёты\Акт сверки (укр) АКВАВИТ.fr3	Акт сверки (укр) АКВАВИТ	NULL
Бизнес	11000	Бизнес\Дополнительные отчёты\Акт сверки (укр) АКВАВИТ.fr3	Бизнес\Дополнительные отчёты\Акт сверки (укр) АКВАВИТ.fr3	Акт сверки (укр) АКВАВИТ	NULL
Банк	14010	Общие\Отчеты\Баланс - Предприятие.fr3	Общие\Отчеты\Баланс - Предприятие.fr3	Баланс - Предприятие	NULL
Бухгалтерия	14000	Общие\Отчеты\Баланс - Предприятие.fr3	Общие\Отчеты\Баланс - Предприятие.fr3	Баланс - Предприятие	NULL
Бизнес	11000	Общие\Отчеты\Баланс - Предприятие.fr3	Общие\Отчеты\Баланс - Предприятие.fr3	Баланс - Предприятие	NULL
Финансы	12000	Общие\Отчеты\Баланс - Предприятие.fr3	Общие\Отчеты\Баланс - Предприятие.fr3	Баланс - Предприятие	NULL

дубли по ПФ в z_DocPrints
DocName	DocCode	FileName	NewFileName	FileDesc	OldFileName
Реестр: Перемещение товара	11521	Бизнес\Документы\Перемещение товара\Перемещение товара (склад).fr3	Бизнес\Документы\Перемещение товара\Перемещение товара (склад).fr3	Перемещение товара (склад)	NULL
Перемещение товара	11021	Бизнес\Документы\Перемещение товара\Перемещение товара (склад).fr3	Бизнес\Документы\Перемещение товара\Перемещение товара (склад).fr3	Перемещение товара (склад)	NULL
Перемещение товара	11021	Бизнес\Документы\Перемещение товара\Перемещение товара (ящ) укр.fr3	Бизнес\Документы\Перемещение товара\Перемещение товара (ящ) укр.fr3	Перемещение товара (ящ) укр	NULL
Реестр: Перемещение товара	11521	Бизнес\Документы\Перемещение товара\Перемещение товара (ящ) укр.fr3	Бизнес\Документы\Перемещение товара\Перемещение товара (ящ) укр.fr3	Перемещение товара (ящ) укр	NULL
Реестр: Перемещение товара	11521	Бизнес\Документы\Перемещение товара\Перемещение товара.fr3	Бизнес\Документы\Перемещение товара\Перемещение товара.fr3	Перемещение товара (шт.)	NULL
Перемещение товара	11021	Бизнес\Документы\Перемещение товара\Перемещение товара.fr3	Бизнес\Документы\Перемещение товара\Перемещение товара.fr3	Перемещение товара (шт.)	NULL
Реестр: Перемещение товара	11521	Бизнес\Документы\Перемещение товара\ТТН новая (Бланк).fr3	Бизнес\Документы\Перемещение товара\ТТН новая (Бланк).fr3	ТТН новая (Бланк)	NULL
Перемещение товара	11021	Бизнес\Документы\Перемещение товара\ТТН новая (Бланк).fr3	Бизнес\Документы\Перемещение товара\ТТН новая (Бланк).fr3	ТТН новая (Бланк)	NULL
Перемещение товара	11021	Бизнес\Документы\Перемещение товара\ТТН.fr3	Бизнес\Документы\Перемещение товара\ТТН.fr3	ТТН	NULL
Реестр: Перемещение товара	11521	Бизнес\Документы\Перемещение товара\ТТН.fr3	Бизнес\Документы\Перемещение товара\ТТН.fr3	ТТН	NULL
Расходная накладная	11012	Бизнес\Документы\Расходная накладная\Акт корректировки по цене (количеству) МЕТРО.fr3	Бизнес\Документы\Расходная накладная\Акт корректировки по цене (количеству) МЕТРО.fr3	Акт корректировки по цене (количеству) МЕТРО	NULL
Возврат товара от получателя	11003	Бизнес\Документы\Расходная накладная\Акт корректировки по цене (количеству) МЕТРО.fr3	Бизнес\Документы\Расходная накладная\Акт корректировки по цене (количеству) МЕТРО.fr3	Акт корректировки по цене (количеству) МЕТРО	NULL
Возврат товара от получателя	11003	\\s-sql-d4\OT38ElitServer\Reports\Бизнес\Документы\Расходная накладная\Акт на скидку _ATБ (2020).fr3	Бизнес\Документы\Расходная накладная\Акт на скидку _ATБ (2020).fr3	Акт на скидку _ATБ (2020)	NULL
Расходная накладная	11012	\\s-sql-d4\OT38ElitServer\Reports\Бизнес\Документы\Расходная накладная\Акт на скидку _ATБ (2020).fr3	Бизнес\Документы\Расходная накладная\Акт на скидку _ATБ (2020).fr3	Акт на скидку _ATБ (2020)	NULL
Возврат товара от получателя	11003	Бизнес\Документы\Расходная накладная\Корректировочная накладная (Test).fr3	Бизнес\Документы\Расходная накладная\Корректировочная накладная (Test).fr3	Корректировка по цене/кол-ву (Расчёт корректировки)	NULL
Расходная накладная	11012	Бизнес\Документы\Расходная накладная\Корректировочная накладная (Test).fr3	Бизнес\Документы\Расходная накладная\Корректировочная накладная (Test).fr3	Корректировка по цене/кол-ву (Расчёт корректировки)	NULL
Возврат товара от получателя	11003	Бизнес\Документы\Расходная накладная\Корректировочная накладная.fr3	Бизнес\Документы\Расходная накладная\Корректировочная накладная.fr3	Корректировка по цене/кол-ву (Расчёт корректировки) до 01.12.2016	NULL
Расходная накладная	11012	Бизнес\Документы\Расходная накладная\Корректировочная накладная.fr3	Бизнес\Документы\Расходная накладная\Корректировочная накладная.fr3	Корректировка по цене/кол-ву (Расчёт корректировки) до 01.12.2016	NULL
Расходная накладная	11012	Бизнес\Документы\Расходная накладная\Корректировочная товарная накладная.fr3	Бизнес\Документы\Расходная накладная\Корректировочная товарная накладная.fr3	Корректировка по цене/кол-ву (Акт корректировки) до 01.12.2016	NULL
Возврат товара от получателя	11003	Бизнес\Документы\Расходная накладная\Корректировочная товарная накладная.fr3	Бизнес\Документы\Расходная накладная\Корректировочная товарная накладная.fr3	Корректировка по цене/кол-ву (Акт корректировки) до 01.12.2016	NULL
Расходная накладная	11012	Бизнес\Документы\Расходная накладная\Расходная накладная (пакет документов) УКР (Test).fr3	Бизнес\Документы\Расходная накладная\Расходная накладная (пакет документов) УКР (Test).fr3	Расходная накладная (пакет документов) УКР	NULL
Реестр: Расходная накладная	11512	Бизнес\Документы\Расходная накладная\Расходная накладная (пакет документов) УКР (Test).fr3	Бизнес\Документы\Расходная накладная\Расходная накладная (пакет документов) УКР (Test).fr3	Расходная накладная (пакет документов) УКР	NULL
Реестр: Расходная накладная Контроль	1666045	Бизнес\Документы\Расходная накладная\Расходная накладная (пакет документов) УКР (Test).fr3	Бизнес\Документы\Расходная накладная\Расходная накладная (пакет документов) УКР (Test).fr3	Расходная накладная (пакет документов) УКР (Test)	NULL
Реестр: Расходная накладная Контроль	1666045	Бизнес\Документы\Расходная накладная\Реестр - Расходная накладная.fr3	Бизнес\Документы\Расходная накладная\Реестр - Расходная накладная.fr3	Реестр - Расходная накладная	NULL
Реестр: Расходная накладная	11512	Бизнес\Документы\Расходная накладная\Реестр - Расходная накладная.fr3	Бизнес\Документы\Расходная накладная\Реестр - Расходная накладная.fr3	Реестр - Расходная накладная	NULL
Расходная накладная	11012	Бизнес\Документы\Расходная накладная\ТТН.fr3	Бизнес\Документы\Расходная накладная\ТТН.fr3	ТТН до 01.12.2016	NULL
Реестр: Расходная накладная Контроль	1666045	Бизнес\Документы\Расходная накладная\ТТН.fr3	Бизнес\Документы\Расходная накладная\ТТН.fr3	ТТН	NULL
Реестр: Расходная накладная	11512	Бизнес\Документы\Расходная накладная\ТТН.fr3	Бизнес\Документы\Расходная накладная\ТТН.fr3	ТТН до 01.12.2016	NULL
Реестр: Расходная накладная	11512	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР (2 форма).fr3	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР (2 форма).fr3	Реестр: Расходная накладная (пакет документов) УКР (2 форма)	NULL
Расходная накладная	11012	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР (2 форма).fr3	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР (2 форма).fr3	Реестр: Расходная накладная (пакет документов) УКР (2 форма)	NULL
Расходная накладная	11012	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР (Винтаж).fr3	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР (Винтаж).fr3	Реестр: Расходная накладная (пакет документов) УКР (Винтаж)	NULL
Реестр: Расходная накладная	11512	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР (Винтаж).fr3	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР (Винтаж).fr3	Реестр: Расходная накладная (пакет документов) УКР (Винтаж)	NULL
Реестр: Расходная накладная	11512	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР для беспошлинных предприятий.fr3	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР для беспошлинных предприятий.fr3	Реестр: Расходная накладная (пакет документов) УКР для беспошлинных предприятий	NULL
Расходная накладная	11012	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР для беспошлинных предприятий.fr3	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР для беспошлинных предприятий.fr3	Реестр: Расходная накладная (пакет документов) УКР для беспошлинных предприятий	NULL
Расходная накладная	11012	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР.fr3	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР.fr3	Реестр: Расходная накладная (пакет документов) УКР	NULL
Реестр: Расходная накладная	11512	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР.fr3	Бизнес\Документы\Реестр РН\Расходная накладная (пакет документов) УКР.fr3	Реестр: Расходная накладная (пакет документов) УКР	NULL
ТМЦ: Счет на оплату	14101	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Налоговые накладные исходящие (по связям)	NULL
ТМЦ: Расходная накладная	14111	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Налоговые накладные исходящие (по связям)	NULL
ТМЦ: Расход по ГТД	14132	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Налоговые накладные исходящие (по связям)	NULL
Основные средства: Продажа	14206	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Налоговые накладные исходящие (по связям)	NULL
Расходный документ	11015	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Налоговые накладные исходящие (по связям)	NULL
Расходный документ в ценах прихода	11016	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Налоговые накладные исходящие (по связям)	NULL
Продажа товара оператором	11035	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Налоговые накладные исходящие (по связям)	NULL
Расходная накладная	11012	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Налоговые накладные исходящие (по связям)	NULL
Счет на оплату товара	11001	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Общие\Документы\Налоговые накладные исходящие (по связям).fr3	Налоговые накладные исходящие (по связям)	NULL

*/






SELECT (SELECT AppName FROM z_Apps a where a.AppCode = ap.AppCode) AppName 

,* FROM z_AppPrints ap ORDER BY 1


SELECT (SELECT AppName FROM z_Apps a where a.AppCode = ap.AppCode) AppName ,* FROM z_AppPrints ap ORDER BY 1

SELECT (SELECT DocName FROM z_Docs d where d.DocCode = dp.DocCode) DocName, * FROM z_DocPrints dp ORDER BY 1


SELECT (SELECT AppName FROM z_Apps a where a.AppCode = ap.AppCode) AppName 
,AppCode,FileName
, case 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',FileName) <> 0 then replace(FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else FileName end NewFileName
, FileDesc, OldFileName 
FROM z_AppPrints ap ORDER BY NewFileName


SELECT (SELECT DocName FROM z_Docs d where d.DocCode = dp.DocCode) DocName
,DocCode,FileName
, case 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4.corp.local\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\','') 
when patindex('\\S-SQL-D4\OT38ElitServer\ReportsUni\%',FileName) <> 0 then replace(FileName,'\\S-SQL-D4\OT38ElitServer\ReportsUni\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4\OT38ElitServer\Reports\','') 
when patindex('\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\%',FileName) <> 0 then replace(FileName,'\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\','') 
when patindex('\\s-sql-d4\OT38ElitServer\Import\%',FileName) <> 0 then replace(FileName,'\\s-sql-d4\OT38ElitServer\Import\','') 
else FileName end NewFileName
, FileDesc, OldFileName 
FROM z_DocPrints dp  ORDER BY NewFileName



SELECT * FROM z_LogPrint ORDER BY 7








SELECT (SELECT DocName FROM z_Docs d where d.DocCode = dp.DocCode) DocName, * FROM z_DocPrints dp ORDER BY 1

/*
select * from z_Tables WHERE TableName like '%log%' OR TableDesc like '%log%'
select patindex('\\%','\fsdfsdf')
SELECT * FROM z_vars ORDER BY VarValue
SELECT * FROM z_LogTools
\\s-sql-d4.corp.local\OT38ElitServer\Reports\Бизнес\Документы\Расходный документ\Расходный документ с НДС.fr3
\\s-sql-d4\OT38ElitServer\ReportsUni\Бизнес\Документы\Расходная накладная\02-VN1-Расходная накладная (расходная накладная) УКР (auto)_uni.fr3
\\S-SQL-D4\OT38ElitServer\ReportsUni\Финансы\Документы\Реестр поступлений ДС в кассу(UNI).fr3
\\s-sql-d4\OT38ElitServer\Reports\Общие\Отчеты\Баланс - Предприятие +Elit_ARHIV.fr3
\\S-SQL-D4.CONST.ALEF.UA\OT38ElitServer\Reports\Бизнес\Отчеты\Письмо - Уведомление о сводной налоговой.fr3
\\s-sql-d4\OT38ElitServer\Import\OTFRExporter\TestExport-form.fr3

*/


























