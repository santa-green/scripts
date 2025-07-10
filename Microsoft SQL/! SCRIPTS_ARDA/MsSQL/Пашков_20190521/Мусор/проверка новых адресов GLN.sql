--�������� ����� �������

--��������� ��������� � ��������� �������
IF  (CONVERT (time, GETDATE()) > '11:00:00' AND CONVERT (time, GETDATE()) < '12:00:00') AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- � �� �� ��
	OR  (CONVERT (time, GETDATE()) > '17:00:00' AND CONVERT (time, GETDATE()) < '18:00:00') AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- � �� �� ��
BEGIN


IF EXISTS (
			select TOP 1 1 
			from dbo.ALEF_EDI_ORDERS_2 m
			where zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) 
			AND ZEO_ORDER_STATUS NOT IN (33,3,4,5)
			AND EXISTS (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) 
			and (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) not in (23501) --��������� �����������
			and m.ZEO_AUDIT_DATE >  DATEADD(day ,-30,getdate()) -- ������ ������ �� ������ 30 ����
)
  --�������� ��������� ���������
  BEGIN TRY 

	delete [S-SQL-D4].Elit.dbo._tmp_EDI_orders_not_GLN

	insert [S-SQL-D4].Elit.dbo._tmp_EDI_orders_not_GLN
		select TOP 10 
		ZEO_ORDER_NUMBER '����� ������'
		,m.ZEO_AUDIT_DATE '���� ������'
		,m.ZEO_ORDER_DATE '���� ��������'
		,m.ZEO_ZEC_ADD GLN
		,(SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) compid
		,(select top 1 compshort from [S-SQL-D4].Elit.dbo.r_Comps p2 where compid =(SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) compshort
		from dbo.ALEF_EDI_ORDERS_2 m
		where zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) 
		AND ZEO_ORDER_STATUS NOT IN (33,3,4,5)
		AND EXISTS (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) 
		and (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) not in (23501) --��������� �����������
		and m.ZEO_AUDIT_DATE >  DATEADD(day ,-30,getdate()) -- ������ ������ �� ������ 30 ����
		ORDER BY ZEO_ORDER_DATE DESC

		DECLARE @SQL_query nvarchar(max) = 'SELECT * FROM Elit.dbo._tmp_EDI_orders_not_GLN'
		DECLARE @body_str nvarchar(max) = '��������� � ����������� ����������� �� ������� ������ �������� � ������� � ������� ������ ���� ������ ����� GLN ' + char(13) 
										+ '(��� ����� ����������  � ������ �� ����� https://edo.edi-n.com) '
		select @body_str

		SELECT @SQL_query
		EXEC [s-sql-d4].msdb.dbo.sp_send_dbmail  
		@profile_name = 'main',  
		@recipients = 'pashkovv@const.dp.ua', 
		--@recipients = 'pashkovv@const.dp.ua;tumaliieva@const.dp.ua;rovnyagina@const.dp.ua;rumyantsev@const.dp.ua',  
		--@recipients = 'pashkovv@const.dp.ua',  
		@body = @body_str,  
		@subject = '������ ������� ������� ������ ����������� � ��������',
		@body_format = 'TEXT'--'HTML'
		,@query = @SQL_query
		,@query_result_header=1
		--,@exclude_query_output=1
		,@query_no_truncate= 0 -- �� ������� ������
		--,@query_attachment_filename= @attachment_filename
		--,@file_attachments='\\s-sql-d4.corp.local\OT38ElitServer\Import\XML\test.xml',
		,@attach_query_result_as_file= 1 -- 1 ������������ �������������� ����� ������� ��� ������������� ����
		;

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

END