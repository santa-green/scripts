   --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   /*�������� PACKAGE ��� ��������� ������������������ RECADV-INVOICE*/
   --���� ���� ��������� RECADV ����� ����, ��� ��� ��������� INVOICE ������.
   --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    DECLARE @orderid varchar(max) = '45285531'
    SELECT * FROM at_z_FilesExchange WHERE FileData.value('(INVOICE/ORDERNUMBER)[1]','varchar(30)') = @orderid
    UPDATE at_z_FilesExchange SET StateCode = 403 WHERE FileData.value('(INVOICE/ORDERNUMBER)[1]','varchar(30)') = @orderid
    SELECT * FROM at_z_FilesExchange WHERE FileData.value('(INVOICE/ORDERNUMBER)[1]','varchar(30)') = @orderid
