USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EDI_Rozetka_Techimport]    Script Date: 20.07.2021 14:37:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[ap_EDI_Rozetka_Techimport] @orderid varchar(30)
as
    --exec [ap_EDI_Rozetka_Techimport] 'РОЗ10713694'
begin
DECLARE @gln_base varchar(30)
DECLARE @gln_address varchar(30)
DECLARE @compid int
SELECT @gln_base = ZEO_ZEC_BASE, @gln_address = ZEO_ZEC_ADD FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_NUMBER = @orderid
SELECT @compid = Compid FROM at_EDI_reg_files WHERE ID = @orderid

--обновляем на техимпорт.
SELECT * FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = @gln_base AND ZEC_KOD_ADD = @gln_address
UPDATE ALEF_EDI_GLN_OT SET zec_kod_kln_ot = 7158 WHERE zec_kod_base = @gln_base AND ZEC_KOD_ADD = @gln_address
SELECT * FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = @gln_base AND ZEC_KOD_ADD = @gln_address

--Перезалить заказ.
BEGIN
    DECLARE @ZEO_ORDER_ID varchar(max) = (SELECT ZEO_ORDER_ID FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_NUMBER = @orderid)
    SELECT * FROM ALEF_EDI_ORDERS_CHANGES WHERE EOC_ORDER_ID = @ZEO_ORDER_ID

    INSERT INTO ALEF_EDI_ORDERS_CHANGES (EOC_ORDER_ID, EOC_CH_DATE,EOC_TYPE, EOC_POS, EOC_CH_DATA, EOC_COMMITTED, EOC_EMP)
    VALUES 
    --(@ZEO_ORDER_ID, CURRENT_TIMESTAMP, 1, 0, '2021-06-15', 0, 7277) --изменение даты.
    (@ZEO_ORDER_ID, CURRENT_TIMESTAMP, 200, 0, 0, 0, 7277) --перезаливка.

    SELECT * FROM ALEF_EDI_ORDERS_CHANGES WHERE EOC_ORDER_ID = @ZEO_ORDER_ID
END;

EXEC msdb.dbo.sp_start_job 'EDI', @step_name = 'Importing_Orders_OT'
while 1 = 1
    begin
        IF EXISTS (
            SELECT TOP(1) * FROM [msdb].dbo.sysjobhistory h 
            inner join [msdb].dbo.sysjobs j
            ON j.job_id = h.job_id
            WHERE j.name = 'edi' 
            AND [msdb].dbo.agent_datetime(h.run_date, h.run_time) > CAST(DATEADD(MINUTE, -1, SYSDATETIME()) AS datetime)
            AND h.step_id = 13
            ORDER BY h.run_date DESC, h.run_time DESC, h.step_id DESC
            ) 
            BREAK
    end;

--возвращаем старую привязку.
SELECT * FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = @gln_base AND ZEC_KOD_ADD = @gln_address
UPDATE ALEF_EDI_GLN_OT SET zec_kod_kln_ot = @compid WHERE zec_kod_base = @gln_base AND ZEC_KOD_ADD = @gln_address
SELECT * FROM ALEF_EDI_GLN_OT WHERE zec_kod_base = @gln_base AND ZEC_KOD_ADD = @gln_address
end
GO

