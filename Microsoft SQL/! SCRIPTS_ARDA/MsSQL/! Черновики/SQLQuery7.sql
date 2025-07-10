/*
SELECT *
FROM dbo.at_EDI_reg_files --ORDER BY InsertData DESC
WHERE ChID = 54094

WHERE DocType = 24000
	--AND [Status] IN (3,4)				--Новый статус
	AND Notes LIKE 'COMDOC%'			--Только по COMDOC
	AND Notes NOT LIKE '%успешно%'	--Если пришло что-то кроме хороших статусов.
	AND RetailersID = 17154			--Розетка
    ORDER BY LastUpdateData DESC
    */
 
 --update [alef_elit].dbo.at_EDI_reg_files set [Status] = 3 WHERE ChID = 9395
 --DECLARE @orderid varchar(128) = (SELECT ID FROM [S-PPC.CONST.ALEF.UA].alef_elit.dbo.at_EDI_reg_files WHERE ChID = 54094)
 DECLARE @orderid varchar(128) = 'РОЗ01097216'
 --DECLARE @orderid varchar(128) = 'РОЗ01088936'
--SELECT * FROM [S-PPC.CONST.ALEF.UA].alef_elit.dbo.at_EDI_reg_files WHERE id = @orderid
 --SELECT @orderid


/*SELECT aer.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer --ORDER BY REC_INV_DATE DESC
JOIN [s-sql-d4].[elit].dbo.t_inv ti ON ti.Orderid = aer.REC_ORD_ID
JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
JOIN [s-sql-d4].[elit].dbo.t_InvD tid ON ti.ChID = tid.ChID
JOIN [s-sql-d4].[elit].dbo.r_prodec rp ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD
WHERE ti.orderid = @orderid

SELECT aerp.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer --ORDER BY REC_INV_DATE DESC
JOIN [s-sql-d4].[elit].dbo.t_inv ti ON ti.Orderid = aer.REC_ORD_ID
JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
JOIN [s-sql-d4].[elit].dbo.t_InvD tid ON ti.ChID = tid.ChID
JOIN [s-sql-d4].[elit].dbo.r_prodec rp ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD
WHERE ti.orderid = @orderid

SELECT ti.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer --ORDER BY REC_INV_DATE DESC
JOIN [s-sql-d4].[elit].dbo.t_inv ti ON ti.Orderid = aer.REC_ORD_ID
JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
JOIN [s-sql-d4].[elit].dbo.t_InvD tid ON ti.ChID = tid.ChID
JOIN [s-sql-d4].[elit].dbo.r_prodec rp ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD
WHERE ti.orderid = @orderid

SELECT tid.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer --ORDER BY REC_INV_DATE DESC
JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
JOIN [s-sql-d4].[elit].dbo.t_inv ti ON ti.Orderid = aer.REC_ORD_ID
JOIN [s-sql-d4].[elit].dbo.t_InvD tid ON ti.ChID = tid.ChID
JOIN [s-sql-d4].[elit].dbo.r_prodec rp ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD
WHERE ti.orderid = @orderid

SELECT rp.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer --ORDER BY REC_INV_DATE DESC
JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
JOIN [s-sql-d4].[elit].dbo.t_inv ti ON ti.Orderid = aer.REC_ORD_ID
JOIN [s-sql-d4].[elit].dbo.t_InvD tid ON ti.ChID = tid.ChID
JOIN [s-sql-d4].[elit].dbo.r_prodec rp ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD
WHERE ti.orderid = @orderid*/

--final
SET NOCOUNT ON;
SELECT '===>>>' 'RECADV', aer.REC_ORD_ID 'Номер заказа', ti.CompID 'Предприятие', aerp.REP_POS_KOD 'Код сети', aerp.REP_ACCEPT_QTY 'Принято, бут.', aerp.REP_DELIVER_QTY 'Отправлено, бут.',
       '===>>>' 'РАСХОДНАЯ (детали)', tid.Prodid 'Наш код',  rp.ExtProdID 'Внешний код', ps.ProdName 'Товар', tid.Qty 'Количество, бут.', '===>>>' 'ВОЗВРАТЫ',
       CASE WHEN CAST((tid.Qty - aerp.REP_ACCEPT_QTY) as int) = 0 THEN 0 ELSE CAST((tid.Qty - aerp.REP_ACCEPT_QTY) as int) END 'Вернули, бут.' 
FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
RIGHT JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
WHERE ti.orderid = @orderid
ORDER BY ps.ProdName ASC

