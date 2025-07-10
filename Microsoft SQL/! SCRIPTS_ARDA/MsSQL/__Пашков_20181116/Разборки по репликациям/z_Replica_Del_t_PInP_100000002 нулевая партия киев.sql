7450155	100000002	
z_Replica_Del_t_PInP_100000002 600226,0	2	
The transaction ended in the trigger. The batch has been aborted.  
Невозможно удаление данных в таблице 'Справочник товаров - Цены прихода Торговли (t_PInP)'. 
Существуют данные в подчиненной таблице 'Остатки товара (Таблица) (t_Rem)'.	2016-10-17 11:00:00.000

--НЕЛЬЗЯ УДАЛЯТЬ НУЛЕВЫЕ ПАРТИИ – ЕСЛИ В ElitR УДАЛАЛИ ТО НУЖНО ВОСТАНОВИТЬ И ВОСТАНОВИТЬ ВО ВСЕХ БАЗАХ
select * from [s-marketa2].elitv_kiev.dbo.z_replicain where status != 1 --Kiev 192.168.74.3
order by replicaeventid

--лечение. пропусть эту реплику
update [s-marketa2].elitv_kiev.dbo.z_replicain
set status = 1
where status != 1 and ReplicaEventID = 7450155