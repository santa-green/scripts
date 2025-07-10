z_Replica_Del_t_PInP_8 602173,0	
The transaction ended in the trigger. The batch has been aborted.  
Невозможно удаление данных в таблице 'Справочник товаров - Цены прихода Торговли (t_PInP)'. 
Существуют данные в подчиненной таблице 'Остатки товара (Таблица) (t_Rem)'.

select * from [ElitR].[dbo].t_Rem where ProdID = 602173
select * from [s-marketa3].elitv_dp2.dbo.t_Rem where ProdID = 602173

SELECT *  FROM [ElitR].[dbo].[z_LogDelete]
  where TableCode = 10350003 and DocDate > '20160930'
  and PKValue like '%602173%'
  order by DocDate

 select EmpName,* from r_Users 
 join r_Emps on r_Users.EmpID = r_Emps.EmpID
 where UserID in (1074,1460)
  
