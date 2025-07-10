   --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   /*ОТПРАВКА PACKAGE ПРИ НАРУШЕНИИ ПОСЛЕДОВАТЕЛЬНОСТИ RECADV-INVOICE*/
   --Если сеть отправила RECADV после того, как был отправлен INVOICE учетом.
   --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    DECLARE @orderid varchar(max) = '45285531'
    SELECT * FROM at_z_FilesExchange WHERE FileData.value('(INVOICE/ORDERNUMBER)[1]','varchar(30)') = @orderid
    UPDATE at_z_FilesExchange SET StateCode = 403 WHERE FileData.value('(INVOICE/ORDERNUMBER)[1]','varchar(30)') = @orderid
    SELECT * FROM at_z_FilesExchange WHERE FileData.value('(INVOICE/ORDERNUMBER)[1]','varchar(30)') = @orderid
