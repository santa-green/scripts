SELECT * FROM r_CompsAdd WITH(NOLOCK) WHERE CompID = 10798 and ChDate >= '20210426' ORDER BY ChDate DESC
SELECT * FROM r_CompsAdd WITH(NOLOCK) WHERE CompID = 10798 and CompAdd like '%мудрого%' ORDER BY ChDate DESC
SELECT * FROM ALEF_EDI_GLN_SETI WITH(NOLOCK) WHERE EGS_GLN_SETI_ID = 847 and EGS_GLN_ID = 1247
Винтаж супермаркет Харьков

while 1 = 1
    begin
        if exists(SELECT * FROM r_CompsAdd WITH(NOLOCK) WHERE CompID = 10798 and ChDate >= '20210426')
            begin
                    exec msdb.dbo.sp_send_dbmail
                     @profile_name = 'arda'
                    ,@from_address = '<support_arda@const.dp.ua>'
                    ,@blind_copy_recipients = 'rumyantsev@const.dp.ua;rumyantsev@gmail.com'
                    ,@subject = 'СИСТЕМА: Добавлен адрес'
                    --,@body = @body
                    ,@body_format = 'HTML'
                    ,@append_query_error = 1;
                return
            end;
    end;