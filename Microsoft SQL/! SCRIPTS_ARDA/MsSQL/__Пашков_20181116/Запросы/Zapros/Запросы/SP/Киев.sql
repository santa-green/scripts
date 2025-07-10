-- локалка Киев
update r_DBIs
set ChID = 2 ,DBiName = 'Винтаж Киев'
from r_DBIs where ChID  = 100000001 

insert r_DBIs
select * from [s-sql-d4].ElitV_TEST.dbo.r_DBIs  where ChID in (1,2)

update r_DBIs
set IsDefault = 0 
from r_DBIs where ChID  = 1 

-- ставим Днепр основной
update r_DBIs
set IsDefault = 1
from r_DBIs where ChID  = 3


select *
into t_SaleTemp_T
from t_SaleTemp 

select *
into t_SaleTempD_T
from t_SaleTempD

select *
into t_SaleTempM_T
from t_SaleTempM

select *
into t_SaleTempPays_T
from t_SaleTempPays

delete from t_SaleTemp
delete from t_SaleTempD
delete from t_SaleTempM
delete from t_SaleTempPays

-- После выполнения SP
/*
insert t_SaleTemp
select *
from t_SaleTemp_T
insert t_SaleTempD
select *
from t_SaleTempD_T
insert t_SaleTempM
select *
from t_SaleTempM_T
insert t_SaleTempPays
select *
from t_SaleTempPays_T

--- удаляем временые таблицы (данные есть в бэкапе)
drop table t_SaleTemp_T
drop table t_SaleTempD_T
drop table t_SaleTempM_T
drop table t_SaleTempPays_T
*/