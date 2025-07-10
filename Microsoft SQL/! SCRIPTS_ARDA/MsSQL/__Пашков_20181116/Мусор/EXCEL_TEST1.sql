DELETE FROM [EXCEL_TEST1]...[Ëèñò1$]
      WHERE ProdIdNabor = 634130


SELECT * FROM  [EXCEL_TEST1]...[Ëèñò1$]
 WHERE ProdIdNabor = 634130


UPDATE [EXCEL_TEST1]...[Ëèñò1$]
   SET [ProdIdNabor] = null
      ,[ProdID1] = null
      ,[PPID1] = null
      ,[ProdID2] = null
      ,[PPID2] = null
      ,[QtySRec] = null
WHERE ProdIdNabor = 634011


INSERT  [EXCEL_TEST1]...[Ëèñò1$] VALUES (11,2,3,4,5,6)

INSERT OPENQUERY ([EXCEL_TEST1],'select * from [Ëèñò1$]')
VALUES (1,2,3,4,5,6)

UPDATE OPENQUERY ([EXCEL_TEST1], 'select * from [Ëèñò1$] WHERE ProdIdNabor = 634011') 
SET [ProdIdNabor] = null
      ,[ProdID1] = null
      ,[PPID1] = null
      ,[ProdID2] = null
      ,[PPID2] = null
      ,[QtySRec] = null

UPDATE OPENQUERY ([EXCEL_TEST1], 'select * from [Ëèñò1$]') 
SET [ProdIdNabor] = null,[ProdID1] = null,[PPID1] = null,[ProdID2] = null,[PPID2] = null,[QtySRec] = null


DELETE OPENQUERY ([EXCEL_TEST1], 'select * from [Ëèñò1$] WHERE ProdIdNabor = 634011') 
      
SELECT * FROM  OPENQUERY ([EXCEL_TEST1],'select * from [Ëèñò1$]')
SELECT * FROM  OPENQUERY ([EXCEL_TEST1],'select * from [Ëèñò1$] WHERE ProdIdNabor = 634011')
