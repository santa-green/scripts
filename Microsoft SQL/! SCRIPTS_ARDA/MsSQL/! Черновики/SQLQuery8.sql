IF @DocType = 24000 --For status.
BEGIN

	DECLARE DocsLoop CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT ChID
	FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files
	WHERE DocType = 24000
	  AND [Status] IN (3,4)				--����� ������
	  AND Notes LIKE 'COMDOC%'			--������ �� COMDOC
	  AND Notes NOT LIKE '%�������%'	--���� ������ ���-�� ����� ������� ��������.
	  AND RetailersID = 17154			--�������
    
	OPEN DocsLoop
		FETCH NEXT FROM DocsLoop INTO @ChID
	WHILE @@FETCH_STATUS = 0		 
	BEGIN	
            DECLARE @orderid varchar(128) = (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID)       
            --�������� ��������� ���������
			BEGIN TRY 
            -- [ADDED] rkv0 '2020-10-27 18:35' �������� ������ � ������ (������ #380).
/*			  DECLARE @query varchar(max) = 
                    'SET NOCOUNT ON; SELECT TOP(1) ti.CompID ''� �����������'', rc.CompName ''�������'', ti.TaxDocID ''� ���������'', ti.TaxDocDate ''���� ���������'', ti.OrderID ''� ������'', ti.DocID ''� ���������'', ti.TSumCC_wt ''����� � ���, ���'' FROM t_Inv ti
                    JOIN r_Comps rc ON rc.CompID = ti.Compid
                    WHERE ti.OrderID = ' + '''' + cast(@orderid as varchar) + '''';
*/            
            --SET @subject = '������ �� ������ ' + CAST( (SELECT ID FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE ChID = @ChID) AS VARCHAR)
			  SET @subject = '������� - ������ �� ������ ' + CAST( @orderid AS VARCHAR) + ' => ' + (SELECT TOP 1 Notes
			                          FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
			                            	WHERE ChID = @ChID
			                          ORDER BY ChID DESC)

			  SET @msg = '<p style="font-size: 12;color:gray"><i>���������� [S-PPC] JOB Workflow ��� 1 (Import_Status / Import_Status_reg_use.ps1)</i></p>'
            
            DECLARE @xml varchar(max)
            SET @xml = CAST((
               SELECT 
                    ti.CompID 'td', ' ',
                    rc.CompName 'td', ' ',
                    ti.TaxDocID 'td', ' ',
                    CONVERT(varchar, ti.TaxDocDate, 104) 'td', ' ', --https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
                    ti.OrderID 'td', ' ',
                    ti.DocID 'td', ' ',
                    ti.TSumCC_wt 'td', ' '
                    FROM t_Inv ti
                    JOIN r_Comps rc ON rc.CompID = ti.Compid
                    WHERE ti.OrderID = @orderid
                    FOR XML PATH('tr'), ELEMENTS)
                as nvarchar(max)
                ) 

            DECLARE @body varchar(max) --https://htmlcolorcodes.com/
            SET @body = '<html>
                <head>
                <style>
                    table{border: 2px solid blue, border-collapse: collapse; background-color: #f1f1c1} th,td{text-align: center}
                </style>
                </head>
                <body>
                <table border = "3" bordercolor="#ec7f34"> 
                    <tr>
                        <th> � ����������� </th> 
                        <th> ������� </th>
                        <th> � ��������� </th>
                        <th> ���� ��������� </th>
                        <th> � ������ </th>
                        <th> � ��������� � ������� </th>
                        <th> ����� � ��� </th>
                    </tr>'

            SET @body = @body + @xml + '</table>' + @msg + '</body> </html>'


              EXEC msdb.dbo.sp_send_dbmail  
			   @profile_name = 'arda'
              -- [FIXED] '2020-03-11 11:08' rkv0 ������ "," ����� ";"
			  ,@recipients = 'jarmola@const.dp.ua;tancyura@const.dp.ua'
			  --,@recipients = 'rumyantsev@const.dp.ua'
--[CHANGED] rkv0 '2020-08-21 14:01' ������� ����� �� arda_servicedesk@const.dp.ua (����� � ������).
--[CHANGED] rkv0 '2020-10-27 17:14' ������� ������� �� support_arda@const.dp.ua (���� ����� ���������� �� ������� �� ����� �������).
              ,@copy_recipients = 'support_arda@const.dp.ua'
              --@copy_recipients = 'arda_servicedesk@const.dp.ua', 
			  ,@subject = @subject
			  ,@body = @body
			  ,@body_format = 'HTML'
-- [ADDED] rkv0 '2020-10-27 18:35' �������� ������ � ������ (������ #380).
              --,@query = @query
              --,@query_result_header = 1 --include column headers. type bit. 1 by default.
              --,@attach_query_result_as_file = 1 --type bit, with a default of 0 (message body).
              --,@query_attachment_filename = '������ �� ������ � ����� ����' --nvarchar(255); ignored when attach_query_result is 0; arbitrary filename by default.
              --,@execute_query_database = 'Elit' --only applicable if @query is specified.
              --,@query_result_separator = '--' --type char(1). Defaults to ' ' (space).
              ,@append_query_error = 1 --bit, with a default of 0. includes the query error message in the body of the e-mail message.


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
		
		FETCH NEXT FROM DocsLoop INTO @ChID
	END
	CLOSE DocsLoop
	DEALLOCATE DocsLoop

END; -- if doctype = 24000
