USE ElitR
--Перемещение с днепра на ElitR

begin tran


insert t_Exc 
SELECT * FROM [s-marketa].elitv_dp.dbo.t_Exc where ChID = 100029211

insert t_Excd 
SELECT * FROM [s-marketa].elitv_dp.dbo.t_Excd where ChID = 100029211


rollback tran

SELECT * FROM t_Exc where ChID = 100029211


SELECT * FROM t_Excd where ChID = 100029211