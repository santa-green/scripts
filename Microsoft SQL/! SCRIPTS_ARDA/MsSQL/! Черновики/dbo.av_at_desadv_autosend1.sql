USE [Elit_test]
GO

alter table at_t_invload add [DeliveryTime] time
--alter table at_t_invload alter column [DeliveryTime] time
--update at_t_InvLoad set deliverytime = '15:00' WHERE ChID = '200479797'
--update at_t_InvLoad set ExpDate = '20210429' WHERE ChID = '200347162'
SELECT * FROM at_t_InvLoad WHERE ChID = '200347162'
SELECT * FROM at_t_InvLoad ORDER BY ChID DESC
insert into at_t_InvLoad SELECT 200479796+1 ChID, BoxQty, PalQty, '20210429' ExpDate, CarQty, PalType, CarPayload, PalQtyMAX, '15:00' DeliveryTime FROM at_t_InvLoad WHERE ChID = '200347162'

--SELECT * FROM z_FieldsRep WHERE FieldName like '%deliv%'