USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EDI_send_DECLAR_bydate]    Script Date: 15.03.2021 16:24:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ap_EDI_send_DECLAR_bydate] @date date, @gln varchar(30)
AS
BEGIN

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Отправка налоговых по сети Новус за определенную дату, если сеть не выслала статус по COMDOC*/
--rkv0 '2020-02-26 15:14' курсор: №заказа -> chid -> запуск процедуры ap_EXITE_CreateMessage
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*TEST*/
--EXEC [dbo].[ap_EDI_send_DECLAR_bydate] '20210224'
/*
begin tran
    EXEC [dbo].[ap_EDI_send_DECLAR_bydate] '20210224', '9863577638028'
rollback tran
--SELECT * FROM [s-sql-d4].[elit].dbo.at_gln WHERE gln = '9863577638028' --GLN Новуса 9863577638028
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @order VARCHAR(100)

DECLARE Novus CURSOR FOR 
SELECT ZEO_ORDER_NUMBER FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ZEC_BASE = @gln AND zeo_order_date = @date ORDER BY zeo_order_date DESC 
OPEN Novus
FETCH NEXT FROM Novus INTO @order
WHILE @@FETCH_STATUS = 0
    BEGIN
--        SELECT @order 'ORDER_TEST';
        DECLARE @novus_chid INT = (SELECT ChID FROM [s-sql-d4].[elit].dbo.t_Inv i WHERE OrderID = @order);
        DECLARE @OutChID INT, @ErrMsg VARCHAR(250); EXEC [s-sql-d4].[elit].dbo.[ap_EXITE_CreateMessage] @MsgType ='DECLAR', @DocCode = 11012, @ChID = @novus_chid, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg;
        FETCH NEXT FROM Novus INTO @order;
    END;
        
CLOSE Novus
DEALLOCATE Novus

END;


GO
