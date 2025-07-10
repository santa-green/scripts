BEGIN TRAN
    SELECT [ID], [RetailersID], [DocType], [FileName], [InsertData], [LastUpdateData], [Status], [DocSum], [CompID], [Notes] FROM [alef_elit_test].dbo.at_EDI_reg_files
	TRUNCATE TABLE [alef_elit_test].dbo.at_EDI_reg_files
    SELECT [ID], [RetailersID], [DocType], [FileName], [InsertData], [LastUpdateData], [Status], [DocSum], [CompID], [Notes] FROM [alef_elit_test].dbo.at_EDI_reg_files
    
    SELECT 'INSERT'
    --SET IDENTITY_INSERT [alef_elit_test].dbo.at_EDI_reg_files OFF
    INSERT INTO [alef_elit_test].dbo.at_EDI_reg_files ([ID], [RetailersID], [DocType], [FileName], [InsertData], [LastUpdateData], [Status], [DocSum], [CompID], [Notes])
    SELECT [ID], [RetailersID], [DocType], [FileName], [InsertData], [LastUpdateData], [Status], [DocSum], [CompID], [Notes] FROM [alef_elit].dbo.at_EDI_reg_files

    SELECT [ID], [RetailersID], [DocType], [FileName], [InsertData], [LastUpdateData], [Status], [DocSum], [CompID], [Notes] FROM [alef_elit_test].dbo.at_EDI_reg_files
    SELECT [ID], [RetailersID], [DocType], [FileName], [InsertData], [LastUpdateData], [Status], [DocSum], [CompID], [Notes] FROM [alef_elit].dbo.at_EDI_reg_files
ROLLBACK TRAN

