DECLARE @period tinyint = 30

--#region отбираем уведомления со статусом != 17, т.е. те, по которым еще уведомления не были отправлены.
    SELECT * FROM at_EDI_reg_files reg --RetailersID = 0 ORDER BY InsertData DESC
    WHERE DocType = 5000 --RECADV
    and RetailersID = -1
    and [FileName] like '%recadv%'
    AND CompID in (0, 7001, 7003)
    --AND Notes NOT LIKE '9%' --ручники (обычные заказы начинаются с цифры 4).
    --AND Notes NOT LIKE '4%' --ручники (обычные заказы начинаются с цифры 4).
    AND Notes NOT LIKE 'OR%' --ручники (обычные заказы начинаются с цифры 4).
    ORDER BY InsertData DESC 

      --AND InsertData >= GETDATE() - @period
      --AND [Status] != 17
      AND RetailersID = 17
      ORDER BY InsertData DESC
      AND Notes NOT LIKE '4%' --ручники (обычные заказы начинаются с цифры 4).


          SELECT * FROM at_EDI_reg_files reg WHERE [FileName] like '%recadv_20210512003657_871d1bad-f141-4e37-a234-0e04a814b383.xml%'
          SELECT * FROM at_EDI_reg_files reg WHERE [FileName] like '%recadv_20201226003718_8ac94a6d-0cc6-4161-9e45-6baef840a64f.xml%'
          SELECT * FROM at_EDI_reg_files reg WHERE [FileName] like '%recadv_20210519114736_1542bd03-51d2-40e6-bbb8-f4259bf51d12.xml%'

          SELECT * FROM at_EDI_reg_files reg WHERE id = '131122'
    WHERE DocType = 5000 --RECADV
      --AND InsertData >= GETDATE() - @period
      AND [Status] = 17
      AND RetailersID = 17
      AND Notes NOT LIKE '4%' --ручники (обычные заказы начинаются с цифры 4).
    ORDER BY InsertData DESC 

    SELECT [FileName] FROM at_EDI_reg_files WHERE [FileName] LIKE 'recadv_%_xml' AND [Status] = 0;
    SELECT * FROM ALEF_EDI_RECADV m WHERE m.REC_REC_ID = '360145'
    SELECT * FROM ALEF_EDI_RECADV m WHERE m.REC_REC_ID = '131122'
    SELECT * FROM ALEF_EDI_RECADV m WHERE m.REC_REC_ID = '5016504393'

    DECLARE @period tinyint = 8

--#region отбираем уведомления со статусом != 17, т.е. те, по которым еще уведомления не были отправлены.
    SELECT * FROM at_EDI_reg_files reg
    WHERE DocType = 5000 --RECADV
      AND InsertData >= GETDATE() - @period
      AND [Status] != 17
      AND RetailersID = 17
      AND Notes NOT LIKE '4%' --ручники (обычные заказы начинаются с цифры 4).
