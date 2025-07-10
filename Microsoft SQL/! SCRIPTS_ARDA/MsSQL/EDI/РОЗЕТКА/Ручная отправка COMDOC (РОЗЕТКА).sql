--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE Alef_Elit
GO

--����� ��������� �� ���� � compid:
SELECT OrderID, TaxDocID, * FROM t_inv WHERE CompID in (7138) and (DocDate = '20210309' or DocDate = '20210310' or DocDate = '20210311')
  
 /*��������� ������� ������������:*/
  BEGIN TRAN
	select COUNT(*) from at_EDI_reg_files 
	select top 20 * from at_EDI_reg_files  order by LastUpdateData desc 
	INSERT INTO at_EDI_reg_files (ID, RetailersID, DocType, [FileName], InsertData, LastUpdateData, [Status], DocSum, CompID, Notes) VALUES
								   ('���10202733', 17154, 24000, 'status_manual.xml', getdate(), getdate(), 3, 0, 0, 'DESADV; manual')
								 , ('���10211227', 17154, 24000, 'status_manual.xml', getdate(), getdate(), 3, 0, 0, 'DESADV; manual')
								 , ('���10212639', 17154, 24000, 'status_manual.xml', getdate(), getdate(), 3, 0, 0, 'DESADV; manual')
								 , ('���10216148', 17154, 24000, 'status_manual.xml', getdate(), getdate(), 3, 0, 0, 'DESADV; manual')
	select top 20 * from at_EDI_reg_files  order by LastUpdateData desc
	select COUNT(*) from at_EDI_reg_files 
  ROLLBACK TRAN

/*��������� �������� ��������� �� ���� �������:*/
--use msdb; exec sp_start_job @job_name = 'Workflow', @step_name = 'Create_Comdoc_006_Rozetka'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DRAFT*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    select top 10 * from at_EDI_reg_files order by LastUpdateData desc
	select * from ALEF_EDI_ORDERS_2 where ZEO_ZEC_BASE = '4829900024055' and ZEO_AUDIT_DATE between '20210219' and '20210311' ORDER BY ZEO_AUDIT_DATE DESC
	--4829900024055 �������������
	--4829900023799 �������.��
	
  select * from at_EDI_reg_files
  WHERE Status = 3 and
  DocType = 24000
  AND Notes LIKE 'DESADV%'
  AND InsertData > '2019-10-21'
  AND RetailersID = 17154 --17154 - ���� �������
  order by LastUpdateData desc
    
  BEGIN TRAN
	select COUNT(*) from at_EDI_reg_files
	select top 20 * from at_EDI_reg_files order by LastUpdateData desc 
	INSERT INTO at_EDI_reg_files (ID, RetailersID, DocType, [FileName], InsertData, LastUpdateData, [Status], DocSum, CompID, Notes) VALUES
								 ('���10216079', 17154, 24000, 'status_manual.xml', getdate(), getdate(), 3, 0, 0, 'DESADV; manual')
	select top 20 * from at_EDI_reg_files order by LastUpdateData desc
	select COUNT(*) from at_EDI_reg_files
  ROLLBACK TRAN

SELECT * FROM at_EDI_reg_files WHERE id = '���10216079'
SELECT * FROM at_EDI_reg_files WHERE id = '���10198390'
SELECT * from ALEF_EDI_ORDERS_2 where ZEO_ZEC_BASE = '4829900024055' and ZEO_AUDIT_DATE between '20210309' and '20210311' ORDER BY ZEO_AUDIT_DATE DESC
