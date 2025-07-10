	DECLARE @ChID INT, @Status INT
	DECLARE @CompID VARCHAR(100)
	        ,@DocID VARCHAR(100)
			,@Note VARCHAR(500)
			,@ans VARCHAR(100)
			,@SQL_Select NVARCHAR(MAX)
			,@subject VARCHAR(250)
			,@msg VARCHAR(max)
			--,@rec VARCHAR(250) = 'maslov@const.dp.ua' --for test things
			,@rec VARCHAR(250) = ''
			,@temp VARCHAR(100) = ''
            ,@xml varchar(max)
            ,@body varchar(max)
            ,@ID varchar(255)

IF 1 = 1 --For status (Rozetka).
BEGIN

/*
update TOP(1) [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files set [status] = 3 WHERE chid = 72623 and doctype = 24000 and id = '���01088936'
update TOP(1) [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files set [status] = 3 WHERE chid = 72400 and doctype = 24000 and id = '���01088864'
SELECT * FROM  [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE /*doctype = 24000 and id = '���01088864' and */ chid = 73299 ORDER BY lastupdatedata DESC
exec [dbo].[ap_SendEmailEDI] @doctype = 24000
*/

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 

	SELECT ChID, ID
	--SELECT *
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE /*DocType = 24000
	  AND [Status] IN (3,4)				--����� ������
	  AND Notes LIKE 'COMDOC%'			--������ �� COMDOC
	  AND Notes NOT LIKE '%�������%'	--���� ������ ���-�� ����� ������� ��������.
	  AND RetailersID = 17154			--�������*/
      ID = '���10225103' AND CHID = 83968

      

      

    
	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID, @ID
	WHILE @@FETCH_STATUS = 0 --0 - The FETCH statement was successful.
    BEGIN	

      DECLARE @filename varchar(255);
      DECLARE @hyperlink varchar(max);
      DECLARE @edi_guid varchar(100);
      SET @filename = (SELECT TOP(1) REC_FILENAME FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV WITH(NOLOCK) WHERE REC_ORD_ID = @ID ORDER BY REC_AUDIT_DATE DESC);
      SET @edi_guid = (SELECT SUBSTRING(PString, 1, LEN(Pstring) - 4 /*.xml*/) from dbo.[af_SplitString] (@filename, '_') WHERE Pstring like '%-%');
      SET @hyperlink = 'https://edo-v2.edi-n.com/app/#/service/edi/view/' + @edi_guid + '/recadv';
      select @hyperlink
        
        DECLARE @orderid varchar(128) = (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID)
        -- [FIXED] rkv0 '2020-12-02 16:27' ������� ����, ������� �� ���������� email ����������� �� ��� ���, ���� �� ����� ������� RECADV �� ����� ������.
        IF NOT EXISTS (SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                    WHERE m.REC_ORD_ID = @orderid)
        BEGIN
            FETCH NEXT FROM DocsLoop INTO @ChID, @ID
            CONTINUE
        END;

            --�������� ��������� ���������
			BEGIN TRY 

            -- [ADDED] rkv0 '2020-10-27 18:35' �������� ������ � ������ (������ #380).
/*			  DECLARE @query varchar(max) = 
                    'SET NOCOUNT ON; SELECT TOP(1) ti.CompID ''� �����������'', rc.CompName ''�������'', ti.TaxDocID ''� ���������'', ti.TaxDocDate ''���� ���������'', ti.OrderID ''� ������'', ti.DocID ''� ���������'', ti.TSumCC_wt ''����� � ���, ���'' FROM t_Inv ti
                    JOIN r_Comps rc ON rc.CompID = ti.Compid
                    WHERE ti.OrderID = ' + '''' + cast(@orderid as varchar) + '''';*/
            
            --SET @subject = '������ �� ������ ' + CAST( (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) AS VARCHAR)
			  SET @subject = '������� - ������ �� ������ ' + CAST( @orderid AS VARCHAR) + ' => ' + (SELECT TOP 1 Notes
			                          FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
			                            	WHERE ChID = @ChID
			                          ORDER BY ChID DESC)

			  SET @msg = '<p style="font-size: 12;color:gray"><i>���������� [S-PPC] JOB Workflow ��� 1 (Import_Status / Import_Status_reg_use.ps1)</i></p>'
            
            SET @xml = CAST((
               SELECT TOP(1)
                     ti.CompID 'td', ' ' --� �����������
                    ,rc.CompName 'td', ' ' --�������
                    ,ti.TaxDocID 'td', ' ' --� ���������
                    ,CONVERT(varchar, ti.TaxDocDate, 104) 'td', ' ' --���� ��������� --https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
                    ,ti.OrderID 'td', ' ' --� ������
                    ,ti.DocID 'td', ' ' --� ��������� � �������
                    ,ti.TSumCC_wt 'td', ' ' --����� � ���, ���
-- [ADDED] rkv0 '2020-11-30 17:07' �������� ������ �� �������� � ��������; ���� ������� (������ #1876).
                    --,(SELECT SUM(REP_DELIVER_QTY) FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                    --    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                    --    WHERE m.REC_ORD_ID = @orderid) 'td', ' ' --���������� ������� (recadv), ��.
                    ,(SELECT CAST(SUM(Qty) as int) FROM t_inv m
                    JOIN t_InvD d ON m.ChID = d.ChID WHERE m.OrderID = @orderid) 'td', ' ' --���������� ������� (��), ��.

                    ,(SELECT COUNT(SrcPosID) FROM t_inv m
                        JOIN t_InvD d ON m.ChID = d.ChID WHERE m.OrderID = @orderid) 'td', ' ' --���������� ������� (��), ��.
                    , '==>>' 'td', ' '
                    
/*                    ,ISNULL((SELECT SUM(REP_DELIVER_QTY) FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                    WHERE m.REC_ORD_ID = @orderid), 0) 'td', ' ' --���������� �������, ��. (recadv)
*/
                        ,ISNULL(
                        (SELECT SUM(CAST(aerp.REP_DELIVER_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID) AS int))
                        FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
                        JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
                        JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
                        RIGHT JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
                        JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
                        JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
                        JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
                        WHERE ti.orderid = @orderid
                        group by aer.REC_ORD_ID), 0
                        ) 'td', ' ' --���������� �������, ��. (recadv)

/*                    ,ISNULL((SELECT SUM(REP_ACCEPT_QTY) FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                        JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                        WHERE m.REC_ORD_ID = @orderid), 0) 'td', ' ' --������� �������, ��. (recadv)
*/                   
                        ,ISNULL(
                        (SELECT SUM(CAST(aerp.REP_ACCEPT_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID) AS int))
                        FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
                        JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
                        JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
                        RIGHT JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
                        JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
                        JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
                        JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
                        WHERE ti.orderid = @orderid
                        group by aer.REC_ORD_ID), 0
                        ) 'td', ' ' --������� �������, ��. (recadv)
                    
                    ,(SELECT COUNT(REP_POS_ID) FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
                        JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
                        WHERE m.REC_ORD_ID = @orderid) 'td', ' ' --������� ������� (recadv)
                    ,@hyperlink 'td', ''

                    FROM t_Inv ti
                    JOIN r_Comps rc ON rc.CompID = ti.Compid
                    JOIN t_InvD tid ON ti.ChID = tid.ChID
                    WHERE ti.OrderID = @orderid
                    FOR XML PATH('tr'), ELEMENTS)
                as nvarchar(max)
                ) 

            --https://htmlcolorcodes.com/
            SET @body = '<html> 
                <head>
                <style>
                    table{border: 2px solid blue, border-collapse: collapse; background-color:   #ffcefd  } th,td{text-align: center}
                    caption { background-color:  #bf76ce ; color: white; font-weight: bold;}
                </style>
                </head>
                <body>
                <table border = "3" bordercolor=" #FF5733 "> 
                    <tr>
                        <th> � ����������� </th> 
                        <th> ������� </th>--
                        <th> � ��������� </th>
                        <th> ���� ��������� </th>
                        <th> � ������ </th>
                        <th> � ��������� � ������� </th>
                        <th> ����� � ���, ��� </th>
                        <th><font color="#5e9572"> ���������� �������, ��. </font> <font color="#595959"><i>(������� �� � ����)</i></font></th></th>
                        <th><font color="#5e9572"> ���������� �������, ��. </font> <font color="#595959"><i>(������� �� � ����)</i></font></th></th>
                        <th> ==>> </th>
                        <th><font color="#C70039"> ���������� �������, ��. </font> <font color="#595959"><i>(����������� � ������ �� ����)</i></font></th>
                        <th><font color="#C70039"> ������� �������, ��. </font> <font color="#595959"><i>(����������� � ������ �� ����)</i></font></th>
                        <th><font color="#C70039"> ������� ������� </font> <font color="#595959"><i>(����������� � ������ �� ����)</i></font></th>
                        <th><font color="#7688df"> ������ �� �������� � EDI </font> <font color="#7688df"><i>(����������� � ������ �� ����)</i></font></th>
                    </tr>'
                    
-- [ADDED] rkv0 '2020-12-08 20:05' ������� ����������� �� ������� � ��������� ����������� (������� #2887).
            DECLARE @xml2 varchar(max)
            SET @xml2 = cast((
                SELECT 
                '===>>>' 'td', ' ' --����������� � ������
                ,aer.REC_ORD_ID 'td', ' ' --����� ������
                ,ti.CompID  'td', ' ' --�����������
                ,aerp.REP_POS_KOD  'td', ' ' --��� ����
                -- [ADDED] rkv0 '2021-01-21 12:04' ������� �������� �� �������-�������.
                -- ,aerp.REP_ACCEPT_QTY 'td', ' ' --�������, ���.
                --,aerp.REP_DELIVER_QTY  'td', ' ' --����������, ���.
                ,CAST(aerp.REP_ACCEPT_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID) AS int) 'td', ' ' --�������, ���.
                ,CAST(aerp.REP_DELIVER_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID) AS int) 'td', ' ' --����������, ���.
                ,'===>>>'  'td', ' ' --��������� (������)
                ,tid.SrcPosID 'td', ' ' --� �/�
                ,tid.Prodid  'td', ' ' --��� ���
                ,rp.ExtProdID  'td', ' ' --������� ���
                ,ps.ProdName  'td', ' ' --�����
                ,CAST(tid.Qty AS int) 'td', ' ' --����������, ���.
                ,'===>>>'  'td', ' ' --��������
                ,CASE WHEN CAST((tid.Qty - aerp.REP_ACCEPT_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID)) as int) = 0 THEN 0 ELSE CAST((tid.Qty - aerp.REP_ACCEPT_QTY * [dbo].[af_GetQtyPack_ROZETKA](tid.ProdID)) as int) END 'td', ' '  --�������, ���.
                    
                FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
                JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
                JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
                RIGHT JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
                JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
                JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
                JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
                    
                WHERE ti.orderid = @orderid
                ORDER BY tid.SrcPosID ASC
                FOR XML PATH('tr'), ELEMENTS)
            as nvarchar(max)
            )

            DECLARE @body2 varchar(max)
            set @body2 = '
            <br> <br>
            <table border = "2" bordercolor=" #4451a4 ">
            <caption> �������� </caption>
            <tr>
                <th><font color=" #0023ff "> ����������� � ������ </font></th>
                <th><font color=" #0023ff "> ����� ������ </font> </th>
                <th><font color=" #0023ff "> ����������� </font> </th>
                <th><font color=" #0023ff "> ��� ���� </font> </th>
                <th><font color=" #0023ff "> �������, ���. </font> </th>
                <th><font color=" #0023ff "> ����������, ���. </font> </th>
                <th><font color=" #3c7057 "> ��������� (������) </font> </th>
                <th><font color=" #3c7057 "> � �/� </font> </th>
                <th><font color=" #3c7057 "> ��� ��� </font> </th>
                <th><font color=" #3c7057 "> ������� ��� </font> </th>
                <th><font color=" #3c7057 "> ����� </font> </th>
                <th><font color=" #3c7057 "> ����������, ���. </font> </th>
                <th><font color=" #ff2821 "> �������� </font> </th>
                <th><font color=" #ff2821 "> �������, ���. </font> </th>
            </tr>'
-- [ADDED] rkv0 '2020-12-09 12:16' ������� �������������� ���� �� ���������� �����; ���� ������� (������ #2984).
           IF EXISTS (SELECT --���� ���� ������� � ���������, �� ������� ���� �������� ������� ����.
                     d.SrcPosID  'td', ' '
                    ,d.ProdID  'td', ' '
                FROM t_Inv m WITH(NOLOCK)   
                JOIN t_InvD d WITH(NOLOCK) ON m.ChID = d.ChID
                LEFT JOIN r_ProdEC re ON re.ProdID = d.ProdID and m.CompID = re.CompID
                WHERE m.OrderID = @orderid AND re.ProdID IS NULL)
            BEGIN
           
               DECLARE @xml3 varchar(max)
                SET @xml3 = cast((
                    SELECT 
                         d.SrcPosID  'td', ' '
                        ,d.ProdID  'td', ' '
                    FROM t_Inv m WITH(NOLOCK)   
                    JOIN t_InvD d WITH(NOLOCK) ON m.ChID = d.ChID
                    LEFT JOIN r_ProdEC re ON re.ProdID = d.ProdID and m.CompID = re.CompID
                    WHERE m.OrderID = @orderid AND re.ProdID IS NULL
                    FOR XML PATH('tr'), ELEMENTS)
                as nvarchar(max)
                )

                DECLARE @body3 varchar(max)
                set @body3 = '
                <br> <br>
                <table border = "2" bordercolor=" #4451a4 ">
                <caption> ��� ��� �������! ������ ������� �� ������������ � �������! </caption>
                <tr>
                    <th><font color=" #0023ff "> ���������� ����� ������� � ��������� </font></th>
                    <th><font color=" #0023ff "> ��� ��� ������ </font> </th>
                </tr>'
            SET @body = @body + @xml + '</table>' + @body2 + @xml2 + '</table>' + @body3 + @xml3 + '</table>' + @msg + '</body> </html>'
            GOTO send_mail
            END;

            SET @body = @body + @xml + '</table>' + @body2 + @xml2 + '</table>' + @msg + '</body> </html>'

              send_mail:
              EXEC msdb.dbo.sp_send_dbmail  
			   @profile_name = 'arda'
              -- [FIXED] '2020-03-11 11:08' rkv0 ������ "," ����� ";"
--[CHANGED] rkv0 '2020-08-21 14:01' ������� ����� �� arda_servicedesk@const.dp.ua (����� � ������).
--[CHANGED] rkv0 '2020-10-27 17:14' ������� ������� �� support_arda@const.dp.ua (���� ����� ���������� �� ������� �� ����� �������).

			  ,@recipients = 'rumyantsev@const.dp.ua'
			  --,@recipients = 'jarmola@const.dp.ua;tancyura@const.dp.ua'
              --,@copy_recipients = 'support_arda@const.dp.ua'

			  ,@subject = @subject
			  ,@body = @body
			  ,@body_format = 'HTML'
-- [ADDED] rkv0 '2020-10-27 18:35' �������� ������ � ������ (������ #380).
              --,@query = @query
              --,@query_result_header = 1 --include column headers. type bit. 1 by default.
              --,@attach_query_result_as_file = 1 --type bit, with a default of 0 (message body).
              --,@query_attachment_filename = '������ �� ������ � ����� ����.csv' --nvarchar(255); ignored when attach_query_result is 0; arbitrary filename by default.
              --,@execute_query_database = 'Elit' --only applicable if @query is specified.
              --,@query_result_separator = '; ' --type char(1). Defaults to ' ' (space).
              ,@append_query_error = 1 --bit, with a default of 0. includes the query error message in the body of the e-mail message.
              --,@query_result_no_padding = 1


			END TRY  
			BEGIN CATCH
			  SELECT  
			  ERROR_NUMBER() AS ErrorNumber  
			  ,ERROR_SEVERITY() AS ErrorSeverity  
			  ,ERROR_STATE() AS ErrorState  
			  ,ERROR_PROCEDURE() AS ErrorProcedure  
			  ,ERROR_LINE() AS ErrorLine  
			  ,ERROR_MESSAGE() AS ErrorMessage; 
			END CATCH
			
			UPDATE [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
			SET [Status] = 10
			   ,LastUpdateData = GETDATE()
			WHERE ChID = @ChID
        FETCH NEXT FROM DocsLoop INTO @ChID, @ID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

END; -- if doctype = 24000 (status; Rozetka)


���10225103 

	SELECT ChID, ID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 24000
	  AND [Status] IN (3,4)				--����� ������
	  AND Notes LIKE 'COMDOC%'			--������ �� COMDOC
	  AND Notes NOT LIKE '%�������%'	--���� ������ ���-�� ����� ������� ��������.
	  AND RetailersID = 17154			--�������