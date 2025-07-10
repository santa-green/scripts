	64996217	100000001	z_Replica_Ins_t_ExcD_100000001 100028945,1,800949,8,'пляш',0.000000000,12.500000000,0.000000000,2.500000000,0.000000000,15.000000000,0.000000000,'2900008009495',1,1	2	The transaction ended in the trigger. The batch has been aborted.  Невозможно добавление данных в таблицу 'Перемещение товара: Товар (t_ExcD)'. Отсутствуют данные в главной таблице 'Перемещение товара: Заголовок (t_Exc)'.	2017-01-17 09:40:00
	
	
SELECT * FROM t_Exc where chid = 100028945
SELECT * FROM t_ExcD where chid = 100028945

--insert t_Exc
SELECT * FROM [s-marketa].elitv_dp.dbo.t_Exc where chid = 100028945

SELECT * FROM [s-marketa].elitv_dp.dbo.t_ExcD where chid = 100028945

