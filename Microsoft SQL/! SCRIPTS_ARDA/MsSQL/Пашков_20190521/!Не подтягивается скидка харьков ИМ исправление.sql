/* удаление дубликата отложенного чека в харькове
declare @chid int = 100188481

delete [s-marketa3].elitv_dp2.dbo.t_saletemp
where crid = 300 and chid = @chid

delete [s-marketa3].elitv_dp2.dbo.z_LogDiscExp
where  logid in (select LogID from z_LogDiscExp where ChID = @chid and DocCode =1011)
*/

select * from [s-marketa3].elitv_dp2.dbo.t_saletemp
where crid = 300  
and DocState = 10 
--and chid = 100188481

select * from t_saletemp
where crid = 300


begin tran

exec ap_VC_Exprot_Sale

rollback tran

----insert [s-marketa3].elitv_dp2.dbo.z_LogDiscExp
--select LogID,
--DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,Discount,LogDate,BonusType,GroupSumBonus,GroupDiscount,4 DBiID
--from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp where  logid = 1433900 and DocCode =1011

--select LogID,
--DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,Discount,LogDate,BonusType,GroupSumBonus,GroupDiscount,4 DBiID
--from z_LogDiscExp where ChID = 100187025 and DocCode =1011

----insert [s-marketa3].elitv_dp2.dbo.z_LogDiscExp
--select LogID,
--DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,Discount,LogDate,BonusType,GroupSumBonus,GroupDiscount,4 DBiID
--from z_LogDiscExp where ChID = 100187025 and DocCode =1011

--select (select top 1 max(LogID)+1 from z_LogDiscExp),
--DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,Discount,LogDate,BonusType,GroupSumBonus,GroupDiscount,4 DBiID
--from z_LogDiscExp where ChID = 100187496 and DocCode =1011


--select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp 
--where  logid in (select LogID from z_LogDiscExp where ChID = 100187025 and DocCode =1011)

select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp 
where  logid in (1439495, 1138357) and chid = 100187496

select * from z_LogDiscExp 
where  logid in (1439495, 0)

select top 50 * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp where chid = 100187496 order by LogID desc

select top 50 * from z_LogDiscExp where chid = 100187496 order by LogID desc

Сообщение
Выполняется от имени пользователя: CONST\Cluster.Violation of PRIMARY KEY constraint 'pk_z_LogDiscExp'. Cannot insert duplicate key in object 'dbo.z_LogDiscExp'. The duplicate key value is (4, 1438357). [SQLSTATE 23000] (Ошибка 2627)  The statement has been terminated. [SQLSTATE 01000] (Ошибка 3621).  Шаг завершился с ошибкой.

Сообщение
Выполняется от имени пользователя: CONST\Cluster.Violation of PRIMARY KEY constraint 'pk_t_SaleTemp'. Cannot insert duplicate key in object 'dbo.t_SaleTemp'. The duplicate key value is (100187496). [SQLSTATE 23000] (Ошибка 2627)  The statement has been terminated. [SQLSTATE 01000] (Ошибка 3621).  Шаг завершился с ошибкой.

LogID	DCardID	TempBonus	DocCode	ChID	SrcPosID	DiscCode	SumBonus	Discount	LogDate	BonusType	GroupSumBonus	GroupDiscount	DBiID
1438357	<Нет дисконтной карты>	0	11035	300025451	4	27	0.000000000	5.759457933	2016-12-08 15:19:00.000	0	NULL	NULL	4

select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp 
where  logid in (1439496)
/*
update [s-marketa3].elitv_dp2.dbo.z_LogDiscExp
set logid = 1138357
from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp where  logid in (1438357)
*/

--insert [s-marketa3].elitv_dp2.dbo.z_LogDiscExp
	select (select max(LogID)from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp) + SrcPosID as LogID, -- pvm0 12-12-2016 теперь LogID не будет дублироваться 
	DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,Discount,LogDate,BonusType,GroupSumBonus,GroupDiscount,4 DBiID
	from z_LogDiscExp where ChID = 100188009 and DocCode =1011 
	
	--delete [s-marketa3].elitv_dp2.dbo.z_LogDiscExp  where ChID = 100188009
	