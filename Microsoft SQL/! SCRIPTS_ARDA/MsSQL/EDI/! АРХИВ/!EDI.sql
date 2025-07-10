--Проверка РН по заказу в EDI
USE Elit
--DECLARE @n bigint = 4455786001 --№ заказа покупателя EDI
DECLARE @n VARCHAR(max) = '4510313421' --№ заказа покупателя EDI

SELECT DocID 'Номер документа', DocDate 'Дата документа',  TaxDocID '№ налоговой накладной', TaxDocDate '№ налоговой накладной', 
TSumCC_nt 'Всего без НДС', TTaxSum 'НДС по документу', TSumCC 'Всего с НДС',
OrderID,OurID,i.CompID,(SELECT top 1 CompShort FROM  Elit.dbo.r_Comps c where c.CompID = i.CompID) CompShort, Address, * 
FROM Elit.dbo.t_Inv i WHERE OrderID like cast(@n as varchar)
and EXISTS (SELECT * FROM Elit.dbo.t_InvD d WHERE d.ChID = i.ChID )

SELECT * FROM Elit.dbo.t_InvD i WHERE ChID in (SELECT ChID FROM Elit.dbo.t_Inv i WHERE OrderID like cast(@n as varchar)) ORDER BY 6

/*
select * from ALEF_EDI_ORDERS_2 m
join ALEF_EDI_ORDERS_2_POS d on d.ZEP_ORDER_ID = m.ZEO_ORDER_ID
where  ZEO_ORDER_NUMBER in ('9926-4772212')
select * from ALEF_EDI_ORDERS_2 m
join ALEF_EDI_ORDERS_2_POS d on d.ZEP_ORDER_ID = m.ZEO_ORDER_ID
where  ZEO_ORDER_NUMBER in ('9926-4749447')

SELECT * FROM ALEF_ERROR_DICT
SELECT * FROM dbo.DS_UserErr
*/
/*
--задублированые позиции в EDI
;WITH CTE as (SELECT ZEP_ORDER_ID, ZEP_POS_ID, ZEP_POS_KOD, ZEP_POS_QTY, ZEP_ORDER_STATUS
,ROW_NUMBER()OVER(PARTITION BY ZEP_ORDER_ID, ZEP_POS_ID, ZEP_POS_KOD, ZEP_POS_QTY, ZEP_ORDER_STATUS ORDER BY ZEP_ORDER_ID, ZEP_POS_ID) n
FROM  ALEF_EDI_ORDERS_2_POS d)

SELECT * FROM CTE where N > 1 ORDER BY 1,2
--Удалить дубликаты
--delete  CTE where N > 1 
*/

/*
select * from ALEF_EDI_ORDERS_2 m
join ALEF_EDI_ORDERS_2_POS d on d.ZEP_ORDER_ID = m.ZEO_ORDER_ID
where  ZEP_ORDER_ID in (
SELECT ZEP_ORDER_ID FROM ALEF_EDI_ORDERS_2_POS group by ZEP_ORDER_ID, ZEP_POS_ID having count(ZEP_POS_ID) > 1
)
ORDER BY ZEP_ORDER_ID,ZEP_POS_ID

SELECT * FROM ALEF_EDI_ORDERS_2_POS where  ZEP_ORDER_ID in (SELECT ZEP_ORDER_ID FROM ALEF_EDI_ORDERS_2_POS group by ZEP_ORDER_ID, ZEP_POS_ID having count(ZEP_POS_ID) > 1)
*/
/*

*/

/*
--переподвязать код
BEGIN TRAN
	--exec Elit.dbo.ap_KPK_SetProdsExtProdID @CompID = 64030, @ProdID = 32620, @ExtProdID = '9-0019000'
ROLLBACK TRAN



select * from Elit.dbo.r_compsadd where compid= 7031

--каждые 15 мин
--job EDI запускает powershell -command E:\Exite\powershell\Import_EDI_Orders.ps1
-- и заполняет таблицы
SELECT * FROM Alef_Elit.dbo.ALEF_EDI_ORDERS_2
SELECT * FROM Alef_Elit.dbo.ALEF_EDI_ORDERS_2_POS


--S-ppc job EDI
select * from Elit.dbo.t_IORec where OrderID='45201884'


SELECT CompShort FROM  Elit.dbo.r_Comps where CompID = 7001
--s-sql-d4  ELIT OrderProcessing
--заказ внутрений резерв

--потом вручную девочки делают РН



SELECT * FROM c_CompExp

*/