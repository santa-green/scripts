EXEC sp_addlinkedserver 'ExcelSource',  
   'Jet 4.0',  
   'Microsoft.Jet.OLEDB.4.0',  
   'c:\Tmp\test.xls ',  
   NULL,  
   'Excel 5.0';
 
 EXEC sp_addlinkedserver @server = N'ExcelDataSource',   
@srvproduct=N'ExcelData', @provider=N'Microsoft.ACE.OLEDB.12.0',   
@datasrc=N'c:\Tmp\test.xlsx',  
@provstr=N'EXCEL 12.0' ;   
     
SELECT *  
   FROM ExcelDataSource
