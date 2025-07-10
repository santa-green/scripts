--проверка скидок
SELECT t1.DCardID, t1.Discount,t2.DCardID, t2.Discount FROM r_dcards t1 
join ElitR_Shop.dbo.r_dcards t2 on t2.DCardID = t1.DCardID
where t1.DCTypeCode in (1,2)
and t1.Discount < t2.Discount

	--EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'
	--GO
	--REVERT


	
--проверка на соответствие t_Sale и t_MonRec
SELECT m.TRealSum,mr.SumAC,m.ChID, m.DocID, m.DocDate,m.DocTime, mr.ChID FROM  t_Sale m 
FULL JOIN t_MonRec mr on mr.DocID = m.DocID
WHERE isnull(round(m.TRealSum,2),0) <> isnull(round(mr.SumAC,2),0)
and m.docdate > '20180101'


SELECT CRID,CodeID1, CodeID2, CodeID3, CodeID4, CodeID5 FROM t_Sale
where DocTime > '20190301'
 group by CRID,CodeID1, CodeID2, CodeID3, CodeID4, CodeID5

ORDER BY DocTime desc

SELECT top 100000  * FROM t_Saled ORDER BY CreateTime desc

SELECT top 1000  * FROM t_Sale ORDER BY DocTime desc
SELECT top 100  * FROM t_Sale ORDER BY 3 desc

SELECT top 1000 * FROM [s-marketa].elitv_dp.dbo.t_Sale ORDER BY DocTime desc
SELECT top 1000 * FROM [s-marketa4].ElitRTS181.dbo.t_Sale ORDER BY DocTime desc
SELECT top 1000 * FROM [s-marketa3].ElitRTS301.dbo.t_Sale ORDER BY DocTime desc
SELECT top 1000 * FROM [192.168.157.22].ElitRTS302.dbo.t_Sale ORDER BY DocTime desc
SELECT top 1000 * FROM [192.168.174.30].ElitRTS201.dbo.t_Sale ORDER BY DocTime desc
SELECT top 1000 * FROM [192.168.174.38].ElitRTS220.dbo.t_Sale ORDER BY DocTime desc
SELECT top 10 * FROM [192.168.42.6].FFood601.dbo.t_Sale ORDER BY DocTime desc

insert z_AppPrints
SELECT * FROM [s-marketa3].ElitRTS301_20190316.dbo.z_AppPrints WHERE AppCode = 11010 

insert [192.168.174.30].ElitRTS201.dbo.z_AppPrints
SELECT * FROM z_AppPrints WHERE AppCode = 11010  and FileName not in (
	SELECT FileName FROM [192.168.174.30].ElitRTS201.dbo.z_AppPrints WHERE AppCode = 11010 
)


SELECT * FROM dbo.r_ProdMP
except
SELECT * FROM [s-marketa].elitv_dp.dbo.r_ProdMP


SELECT * FROM [s-marketa].elitv_dp.dbo.r_ProdMP
except
SELECT * FROM dbo.r_ProdMP

--Проверка диапазонов
SELECT 'ElitR',* FROM r_dbis where IsDefault = 1 union all
SELECT '[s-marketa].elitv_dp.dbo.',* FROM [s-marketa].elitv_dp.dbo.r_dbis where IsDefault = 1 union all 
SELECT '[s-marketa4].ElitRTS181.dbo.',* FROM [s-marketa4].ElitRTS181.dbo.r_dbis where IsDefault = 1 union all
SELECT '[s-marketa3].ElitRTS301.dbo.',* FROM [s-marketa3].ElitRTS301.dbo.r_dbis where IsDefault = 1 union all
SELECT '[192.168.157.22].ElitRTS302.dbo.',* FROM [192.168.157.22].ElitRTS302.dbo.r_dbis where IsDefault = 1 union all
SELECT '[192.168.174.30].ElitRTS201.dbo.',* FROM [192.168.174.30].ElitRTS201.dbo.r_dbis where IsDefault = 1 union all
SELECT '[192.168.174.38].ElitRTS220.dbo.',* FROM [192.168.174.38].ElitRTS220.dbo.r_dbis where IsDefault = 1 union all
SELECT '[192.168.42.6].FFood601.dbo.',* FROM [192.168.42.6].FFood601.dbo.r_dbis where IsDefault = 1 


--Проверка синхронизации t_Sale
SELECT '[s-marketa].elitv_dp.dbo.',* FROM [s-marketa].elitv_dp.dbo.t_Sale m where m.chid not in (SELECT m2.chid FROM t_Sale m2 where m2.DocCreateTime = m.DocCreateTime and m2.TRealSum = m.TRealSum)  union all 
SELECT '[s-marketa4].ElitRTS181.dbo.',* FROM [s-marketa4].ElitRTS181.dbo.t_Sale m where m.chid not in (SELECT m2.chid FROM t_Sale m2 where m2.DocCreateTime = m.DocCreateTime and m2.TRealSum = m.TRealSum)  union all
SELECT '[s-marketa3].ElitRTS301.dbo.',* FROM [s-marketa3].ElitRTS301.dbo.t_Sale m where m.chid not in (SELECT m2.chid FROM t_Sale m2 where m2.DocCreateTime = m.DocCreateTime and m2.TRealSum = m.TRealSum)  union all
SELECT '[192.168.157.22].ElitRTS302.dbo.',* FROM [192.168.157.22].ElitRTS302.dbo.t_Sale m where m.chid not in (SELECT m2.chid FROM t_Sale m2 where m2.DocCreateTime = m.DocCreateTime and m2.TRealSum = m.TRealSum)  union all
SELECT '[192.168.174.30].ElitRTS201.dbo.',* FROM [192.168.174.30].ElitRTS201.dbo.t_Sale m where m.chid not in (SELECT m2.chid FROM t_Sale m2 where m2.DocCreateTime = m.DocCreateTime and m2.TRealSum = m.TRealSum)  union all
SELECT '[192.168.174.38].ElitRTS220.dbo.',* FROM [192.168.174.38].ElitRTS220.dbo.t_Sale m where m.chid not in (SELECT m2.chid FROM t_Sale m2 where m2.DocCreateTime = m.DocCreateTime and m2.TRealSum = m.TRealSum)  union all
SELECT '[192.168.42.6].FFood601.dbo.',* FROM [192.168.42.6].FFood601.dbo.t_Sale m where m.chid not in (SELECT m2.chid FROM t_Sale m2 where m2.DocCreateTime = m.DocCreateTime and m2.TRealSum = m.TRealSum)  



--Проверка синхронизации r_Comps
SELECT '[s-marketa].elitv_dp.dbo.',* FROM [s-marketa].elitv_dp.dbo.r_Comps m where m.compid not in (SELECT m2.compid FROM r_Comps m2)  union all 
SELECT '[s-marketa4].ElitRTS181.dbo.',* FROM [s-marketa4].ElitRTS181.dbo.r_Comps m where m.compid not in (SELECT m2.compid FROM r_Comps m2)  union all
SELECT '[s-marketa3].ElitRTS301.dbo.',* FROM [s-marketa3].ElitRTS301.dbo.r_Comps m where m.compid not in (SELECT m2.compid FROM r_Comps m2)  union all
SELECT '[192.168.157.22].ElitRTS302.dbo.',* FROM [192.168.157.22].ElitRTS302.dbo.r_Comps m where m.compid not in (SELECT m2.compid FROM r_Comps m2)  union all
SELECT '[192.168.174.30].ElitRTS201.dbo.',* FROM [192.168.174.30].ElitRTS201.dbo.r_Comps m where m.compid not in (SELECT m2.compid FROM r_Comps m2)  union all
SELECT '[192.168.174.38].ElitRTS220.dbo.',* FROM [192.168.174.38].ElitRTS220.dbo.r_Comps m where m.compid not in (SELECT m2.compid FROM r_Comps m2)  union all
SELECT '[192.168.42.6].FFood601.dbo.',* FROM [192.168.42.6].FFood601.dbo.r_Comps m where m.compid not in (SELECT m2.compid FROM r_Comps m2)  


--проверка и изменение порядка выполнения тригеров

--USE ElitR
select * , 'EXEC sp_settriggerorder @triggername=N''[dbo].['+name+']'', @order=N''First'', @stmttype=N''DELETE'''
 from sys.objects where  (type='TR' or type='TA') and ObjectProperty(object_id, 'ExecIsFirstDeleteTrigger') = 1
ORDER BY 1,parent_object_id

if 1=0
BEGIN
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_r_DeviceTypes]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_at_r_Clients]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_at_r_ClientsAdd]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_at_r_ProdG4]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_at_r_ProdG5]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_at_r_ProdG6]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_at_r_ProdG7]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_at_r_ProdsAmort]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_at_r_Regions]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_AM]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_AMD]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_AMStocks]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_DeliveryGroup]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_OperTypes]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_PLProdGrs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_ProdMPA]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_ProdOpers]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_StockFilters]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_ir_StockSubs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Banks]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Codes1]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Codes2]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Codes3]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Codes4]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Codes5]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompContacts]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompGrs1]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompGrs2]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompGrs3]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompGrs4]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompGrs5]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Comps]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompsAC]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompsAdd]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompsCC]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CompValues]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CRDeskG]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CRMM]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CRPOSPays]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CRs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CRShed]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_CRUniInput]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Currs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_DCards]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_DCTypeG]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_DCTypes]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Deps]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_DiscDC]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Discs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Emps]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Levies]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_LevyCR]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_LevyRates]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_OperCRs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Opers]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Ours]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_OursAC]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_OursCC]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_OurValues]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_PayForms]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_PLs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_POSPays]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdA]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdAC]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdBG]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdC]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdCV]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdEC]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdG]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdG1]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdG2]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdG3]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdLV]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdMA]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdME]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdMP]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdMQ]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdMS]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdMSE]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Prods]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ProdValues]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ScaleDefKeys]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ScaleDefs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ScaleGrMW]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_ScaleGrs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Scales]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Spends]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_StateDocs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_StateDocsChange]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_StateRules]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_StateRuleUsers]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_States]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_StockCRProds]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_StockGs]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Stocks]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Taxes]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_TaxRates]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Uni]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_UniTypes]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_r_Users]', @order=N'First', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Del_t_PInP]', @order=N'First', @stmttype=N'DELETE'	
END

select * , 'EXEC sp_settriggerorder @triggername=N''[dbo].['+name+']'', @order=N''First'', @stmttype=N''UPDATE'''
from sys.objects where  (type='TR' or type='TA') and ObjectProperty(object_id, 'ExecIsFirstUpdateTrigger') = 1
ORDER BY 1,parent_object_id

if 1=0
BEGIN
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_r_DeviceTypes]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_at_r_Clients]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_at_r_ClientsAdd]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_at_r_ProdG4]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_at_r_ProdG5]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_at_r_ProdG6]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_at_r_ProdG7]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_at_r_ProdsAmort]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_at_r_Regions]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_AM]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_AMD]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_AMStocks]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_DeliveryGroup]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_OperTypes]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_PLProdGrs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_ProdMPA]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_ProdOpers]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_StockFilters]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_ir_StockSubs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Banks]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Codes1]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Codes2]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Codes3]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Codes4]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Codes5]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompContacts]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompGrs1]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompGrs2]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompGrs3]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompGrs4]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompGrs5]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Comps]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompsAC]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompsAdd]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompsCC]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CompValues]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CRDeskG]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CRMM]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CRPOSPays]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CRs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CRShed]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_CRUniInput]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Currs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_DCards]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_DCTypeG]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_DCTypes]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Deps]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_DiscDC]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Discs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Emps]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Levies]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_LevyCR]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_LevyRates]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_OperCRs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Opers]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Ours]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_OursAC]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_OursCC]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_OurValues]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_PayForms]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_PLs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_POSPays]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdA]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdAC]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdBG]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdC]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdCV]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdEC]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdG]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdG1]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdG2]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdG3]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdLV]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdMA]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdME]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdMP]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdMQ]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdMS]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdMSE]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Prods]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ProdValues]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ScaleDefKeys]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ScaleDefs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ScaleGrMW]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_ScaleGrs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Scales]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Spends]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_StateDocs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_StateDocsChange]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_StateRules]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_StateRuleUsers]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_States]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_StockCRProds]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_StockGs]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Stocks]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Taxes]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_TaxRates]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Uni]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_UniTypes]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_r_Users]', @order=N'First', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Upd_t_PInP]', @order=N'First', @stmttype=N'UPDATE'	
END

select * , 'EXEC sp_settriggerorder @triggername=N''[dbo].['+name+']'', @order=N''First'', @stmttype=N''INSERT'''
from sys.objects where  (type='TR' or type='TA') and ObjectProperty(object_id, 'ExecIsFirstInsertTrigger') = 1
ORDER BY 1,parent_object_id

if 1=0
BEGIN
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel1_Ins_r_DeviceTypes]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_at_r_Clients]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_at_r_ClientsAdd]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_at_r_ProdG4]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_at_r_ProdG5]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_at_r_ProdG6]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_at_r_ProdG7]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_at_r_ProdsAmort]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_at_r_Regions]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_AM]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_AMD]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_AMStocks]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_DeliveryGroup]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_OperTypes]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_PLProdGrs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_ProdMPA]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_ProdOpers]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_StockFilters]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_ir_StockSubs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Banks]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Codes1]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Codes2]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Codes3]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Codes4]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Codes5]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompContacts]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompGrs1]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompGrs2]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompGrs3]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompGrs4]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompGrs5]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Comps]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompsAC]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompsAdd]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompsCC]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CompValues]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CRDeskG]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CRMM]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CRPOSPays]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CRs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CRShed]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_CRUniInput]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Currs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_DCards]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_DCTypeG]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_DCTypes]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Deps]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_DiscDC]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Discs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Emps]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Levies]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_LevyCR]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_LevyRates]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_OperCRs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Opers]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Ours]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_OursAC]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_OursCC]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_OurValues]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_PayForms]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_PLs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_POSPays]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdA]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdAC]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdBG]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdC]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdCV]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdEC]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdG]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdG1]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdG2]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdG3]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdLV]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdMA]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdME]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdMP]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdMQ]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdMS]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdMSE]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Prods]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ProdValues]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ScaleDefKeys]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ScaleDefs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ScaleGrMW]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_ScaleGrs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Scales]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Spends]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_StateDocs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_StateDocsChange]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_StateRules]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_StateRuleUsers]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_States]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_StockCRProds]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_StockGs]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Stocks]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Taxes]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_TaxRates]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Uni]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_UniTypes]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_r_Users]', @order=N'First', @stmttype=N'INSERT'
EXEC sp_settriggerorder @triggername=N'[dbo].[TReplica_Ins_t_PInP]', @order=N'First', @stmttype=N'INSERT'
END


/*
TReplica_Upd_at_r_Clients

SELECT *, 'S-marketa' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [s-marketa].elitv_dp.dbo.r_ProdMP
) m

SELECT *, 'S-marketa4' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [s-marketa4].ElitRTS181.dbo.r_ProdMP
) m

SELECT *, 'S-marketa3' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [s-marketa3].ElitRTS301.dbo.r_ProdMP
) m

SELECT *, 'Харьков 302' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [192.168.157.22].ElitRTS302.dbo.r_ProdMP
) m

SELECT *, 'Интернет-магазин' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [192.168.174.30].ElitRTS201.dbo.r_ProdMP 
) m

SELECT *, 'Киев 174.30' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [192.168.174.38].ElitRTS220.dbo.r_ProdMP
) m

SELECT *, 'Кофепоинт МОСТ СИТИ' 'Store'
FROM (
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM r_ProdMP --WHERE ProdID = 70815
EXCEPT
SELECT ProdID, PLID, PriceMC, InUse, PromoPriceCC, BDate, EDate FROM [192.168.42.6].FFood601.dbo.r_ProdMP --WHERE ProdID = 70815
) m
*/


/*
SELECT * FROM z_LogDiscExp where DBiID = 11 ORDER BY 1
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_LogDiscExp where DBiID = 11 ORDER BY 1


SELECT * FROM r_Comps m where m.compid in (200593,11317)
SELECT '[192.168.174.30].ElitRTS201.dbo.',* FROM [192.168.174.30].ElitRTS201.dbo.r_Comps m where m.chid in (200593,11317)
SELECT '[192.168.42.6].FFood601.dbo.',* FROM [192.168.42.6].FFood601.dbo.r_Comps m where m.chid in (200593,11317)

SELECT * FROM r_Comps m where m.chid = 28802
SELECT '[192.168.174.30].ElitRTS201.dbo.',* FROM [192.168.174.30].ElitRTS201.dbo.r_Comps m where m.chid = 28802
SELECT '[192.168.42.6].FFood601.dbo.',* FROM [192.168.42.6].FFood601.dbo.r_Comps m where m.chid = 28802

update [192.168.174.30].ElitRTS201.dbo.r_Comps set compid = 11317 where chid = 28802
update [192.168.42.6].FFood601.dbo.r_Comps set compid = 11317 where chid = 28802

ChID	CompID
28802	200593
*/

SELECT * FROM z_ReplicaPubs
SELECT * FROM z_Replicasubs

SELECT * 
, (select TableName from z_Tables s WHERE s.TableCode= z.TableCode) 
, (select Tabledesc from z_Tables s WHERE s.TableCode= z.TableCode) 
FROM z_ReplicaTables z where ReplicaPubCode = 12
ORDER BY 6

SELECT * FROM r_Discs
SELECT * FROM r_DiscDC

SELECT * FROM r_DiscSaleD
SELECT * FROM [192.168.174.38].ElitRTS220.dbo.r_DiscSaleD


SELECT * FROM r_Discs where InUse = 1
--except
SELECT * FROM [192.168.174.38].ElitRTS220.dbo.r_Discs where InUse = 1


select * from z_Tables s WHERE s.TableName in ('r_Menu', 'r_MenuM', 'r_MenuP','r_DiscSaleD')