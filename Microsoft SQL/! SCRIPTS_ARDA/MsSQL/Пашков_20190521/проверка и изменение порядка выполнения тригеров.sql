--проверка и изменение порядка выполнения тригеров
select * from sys.objects where  (type='TR' or type='TA') and ObjectProperty(object_id, 'ExecIsFirstDeleteTrigger') = 1
ORDER BY 1,parent_object_id
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_r_DeviceTypes]', @order=N'none', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_t_Sale]', @order=N'none', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_t_SaleD]', @order=N'none', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_t_SaleTemp]', @order=N'none', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_t_SaleTempD]', @order=N'none', @stmttype=N'DELETE'


select * from sys.objects where  (type='TR' or type='TA') and ObjectProperty(object_id, 'ExecIsFirstUpdateTrigger') = 1
ORDER BY 1,parent_object_id
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_r_DeviceTypes]', @order=N'none', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_t_Sale]', @order=N'none', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_t_SaleD]', @order=N'none', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_t_SaleTemp]', @order=N'none', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_t_SaleTempD]', @order=N'none', @stmttype=N'UPDATE'


select * from sys.objects where  (type='TR' or type='TA') and ObjectProperty(object_id, 'ExecIsFirstInsertTrigger') = 1
ORDER BY 1,parent_object_id
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Ins_r_DeviceTypes]', @order=N'none', @stmttype=N'INSERT'

