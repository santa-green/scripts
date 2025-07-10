 --select * from t_saletemp where CRID = @CRID and StockID = @StockID and DocState = 10
 
 -- select * from t_saletemp ORDER BY 2,4
  
 --   select * from [s-marketa].elitv_dp.dbo.t_saletemp ORDER BY 2,4
    
 --   EXECUTE msdb.dbo.sysmail_help_status_sp
 
   IF OBJECT_ID('tempdb..#TOrders') IS NOT NULL  DROP TABLE #TOrders
  IF OBJECT_ID('tempdb..#TOrdersD') IS NOT NULL DROP TABLE #TOrdersD


  CREATE TABLE #TOrders
  (DocID INT, 
   DocDate SMALLDATETIME, 
   ExpDate SMALLDATETIME,
   ExpTime VARCHAR(250), 
   ClientID INT, 
   [Address] VARCHAR(250),
   Notes VARCHAR(250), 
   PayFormCode INT, 
   Recipient VARCHAR(250),
   Phone VARCHAR(250),
   DeliveryType VARCHAR(10), 
   DeliveryPriceCC NUMERIC(21,2),
   RegionID INT, 
   CompType TINYINT, 
   Code VARCHAR(20),
   DCardID VARCHAR(250),
   PRIMARY KEY CLUSTERED(DocID)) 

  CREATE TABLE #TOrdersD
  (DocID INT,
   PosID INT, 
   ProdID INT, 
   Qty INT, 
   PurPrice NUMERIC(21,9),
   Discount NUMERIC(21,9), 
   RemSchID VARCHAR(10),   
   IsVIP TINYINT,
   PRIMARY KEY CLUSTERED(DocID, PosID))

  CREATE NONCLUSTERED INDEX idx_nc_ProdID ON #TOrdersD (ProdID ASC)
  CREATE NONCLUSTERED INDEX idx_nc_RemSchID ON #TOrdersD (RemSchID ASC)

insert  #TOrders
SELECT * FROM [s-marketa].elitv_dp.dbo.test_TOrders where docid = 132124
insert  #TOrdersD
SELECT * FROM [s-marketa].elitv_dp.dbo.test_TOrdersD where docid = 132124

SELECT * FROM #TOrders
SELECT * FROM #TOrdersD


DECLARE @tableHTML  NVARCHAR(MAX) ;  
  
SET @tableHTML =  
    N'<H1>Order</H1>' +  
    N'<table border="1">' +
    N'<tr><th>DocID</th><th>DocDate</th>' +  
    N'<th>ExpDate</th><th>ExpTime</th><th>ClientID</th>' +  
    N'<th>Address</th><th>Notes</th><th>Pay Form Code</th>' +
    N'<th>Recipient</th><th>Phone</th><th>Delivery Type</th>' +
    N'<th>Delivery PriceCC</th><th>Region ID</th><th>CompType</th><th>Code</th><th>DCardID</th></tr>' +   
    CAST ( ( SELECT  td= DocID, '', td= CONVERT( varchar(10), DocDate, 112), '',
     td= CONVERT( varchar(10), ExpDate, 112), '', td= ExpTime, '', td= ClientID, '', 
     td= Address, '', td= Notes, '', td= PayFormCode, '', td= Recipient, '', 
     td= Phone, '', td= DeliveryType, '', td= DeliveryPriceCC, '',
     td= RegionID, '', td= CompType, '', td= isnull(Code,''), '', td= DCardID          
    FROM #TOrders FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) ) +  
    N'</table>' +  
    N'<H1>OrdersD</H1>' +  
    N'<table border="1">' +
    N'<tr><th>DocID</th><th>PosID</th>' +  
    N'<th>ProdID</th><th>Qty</th><th>PurPrice</th>' +  
    N'<th>Discount</th><th>RemSchID</th><th>IsVIP</th></tr>' +  
    CAST ( ( SELECT  td=DocID, '', td=PosID,'', td=ProdID, '',td=Qty, '',td=PurPrice,'', td=Discount,'', td=RemSchID,'', td=IsVIP 
    FROM #TOrdersD FOR XML PATH('tr'), TYPE) AS NVARCHAR(MAX) ) +  
    N'</table>' ;  
  
SELECT @tableHTML
    
    	--Отправка почтового сообщения
	DECLARE @subject varchar(250), @body varchar(max)
	--set @subject = 'Харьков. Новый заказ пришел '
	-- + cast((SELECT DocID FROM #TOrders) as varchar) +'. Отгрузка ' 
	-- + (SELECT CONVERT( varchar(10), ExpDate, 112) FROM #TOrders) + ' ' +
	-- + cast((SELECT ExpTime FROM #TOrders) as varchar) + ' ' +
	-- + ISNULL((SELECT top 1 ' ОПТ ' FROM #TOrdersD where RemSchID = 1),'') + 
	-- + ISNULL((SELECT top 1 ' Розница ' FROM #TOrdersD where RemSchID = 2),'')
    set @subject = (select CONVERT( varchar(30),  getdate(), 21))

	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'main',  
	@recipients = 'pashkovv@const.dp.ua',  
	@body = @tableHTML,  
	@subject = @subject,
	@body_format = 'HTML' ;
	
	

                       
    --@query = 'SELECT top 5 sent_account_id, sent_date FROM msdb.dbo.sysmail_sentitems; SELECT top 10 sent_account_id, sent_date FROM msdb.dbo.sysmail_sentitems '    ;
    
    --SELECT sent_account_id, sent_date FROM msdb.dbo.sysmail_sentitems
    
    --SELECT  CAST ( ( SELECT * FROM #TOrdersD FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX))
    
    --SELECT STUFF( (SELECT ',' + DocID  FROM #TOrdersD FOR XML PATH('')),1,1,'')
    
    --SELECT * FROM #TOrdersD FOR XML PATH('#13')
    
    --SELECT  CAST ( ( SELECT * FROM #TOrdersD FOR XML auto ) AS NVARCHAR(MAX))
    
    