--���������� � ��������� ���
IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable

--������� ��������� ��� �� ���� ������� �� ��������� ������� #temptable 
SELECT  * INTO #temptable FROM 
(
SELECT mp.ProdID 'ProdID', mp.PLID 'PLID', [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) 'PriceToDay', mp.PriceMC,  s.PriceMC oldPriceMC, mp.PromoPriceCC, s.PromoPriceCC oldPromoPriceCC, mp.BDate, mp.EDate, s.BDate OldBDate, s.EDate OldEDate,
cast(ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2)) 'PriceBefore',
case when ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) then '�������'  else '��������'  end 'ChPrice'
		, ps.ProdName ProdName
FROM dbo.r_ProdMP_Snapshot s
JOIN  dbo.r_ProdMP mp ON mp.ProdID = s.ProdID and mp.PLID = s.PLID
JOIN dbo.r_Prods ps ON ps.ProdID = s.ProdID
WHERE 
(
( cast( ISNULL( (SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK)
				WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2)) 
				<> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID)
AND [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) <> 0
)
OR 
s.PriceMC <> mp.PriceMC
)
) temp


SELECT * FROM #temptable ORDER BY PLID,ChPrice,ProdID


DECLARE @PLID INT, @recipients NVARCHAR(MAX), @tableHTML  NVARCHAR(MAX), @subject varchar(250), @body varchar(max)

		
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT RefID, Notes FROM r_Uni WITH (NOLOCK)
WHERE RefTypeID = 1000000007
ORDER BY  RefID

OPEN CURSOR1
FETCH NEXT FROM CURSOR1 INTO @PLID, @recipients
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @PLID, @recipients

	IF EXISTS (SELECT top 1 1 FROM #temptable WHERE PLID = @PLID)
	BEGIN
		--�������� ������ ��� ���������
		SET @tableHTML =  
			N'<H1></H1><table border="1">' +
			N'<tr><th>�����</th><th>�����-����</th><th>�������� ������</th><th>������� ����</th><th>��� ����</th></tr>' +   
			CAST ( ( SELECT  td= ProdID, '', td= PLID, '', td= ProdName, '', td= ISNULL(cast(PriceToDay as numeric(15,3)),0), '', td= ChPrice          
			FROM #temptable WHERE PLID = @PLID ORDER BY PLID,ChPrice,ProdID FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) )  

		SELECT @tableHTML
	    
    	--�������� ��������� ���������

		set @subject = '��������!!! ���������� ���� �� ������ ' + cast(@PLID as varchar) + ' �� ���� ' + (select CONVERT( varchar(30),  getdate(), 21)) 

		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'main',  
		@recipients = @recipients,  
		@body = @tableHTML,  
		@subject = @subject,
		@body_format = 'HTML' ;
	END	
	
FETCH NEXT FROM CURSOR1	INTO @PLID, @recipients
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

	--�������� ��� �������
	IF EXISTS (SELECT top 1 1 FROM #temptable)
	BEGIN
		--��������� ������ ��� �������
		SET @tableHTML =  
			N'<H1></H1>' +  
			N'<table border="1">' +
			N'<tr><th>�����</th><th>�����-����</th>' +  
			N'<th>PriceToDay</th><th>PriceMC</th><th>oldPriceMC</th>' +  
			N'<th>Promo PriceCC</th><th>oldPromo PriceCC</th><th>BDate</th>' +
			N'<th>EDate</th><th>OldBDate</th><th>OldEDate</th>' +
			N'<th>Price Before</th><th>ChPrice</th></tr>' +   
			CAST ( ( SELECT  td= ProdID, '', td= PLID, '',
			 td= ISNULL(cast(PriceToDay as numeric(15,3)),0), '', td= ISNULL(cast(PriceMC as numeric(15,3)),0), '', td= ISNULL(cast(oldPriceMC as numeric(15,3)),0), '', 
			 td= ISNULL(cast(PromoPriceCC as numeric(15,3)),0), '', td= ISNULL(cast(oldPromoPriceCC as numeric(15,3)),0), '', td= ISNULL(CONVERT( varchar(10), BDate, 112),' '), '', td= ISNULL(CONVERT( varchar(10), EDate, 112),' '), '', 
			 td= ISNULL(CONVERT( varchar(10), OldBDate, 112),' '), '', td= ISNULL(CONVERT( varchar(10), OldEDate, 112),' '), '', td= ISNULL(cast(PriceBefore as numeric(15,3)),0), '',
			 td= ChPrice          
			FROM #temptable  ORDER BY PLID,ChPrice,ProdID FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) )  
		
		SELECT @tableHTML
	    
    	--�������� ��������� ���������

		set @subject = '��������!!! ���������� ���� �� �������  �� ���� ' + (select CONVERT( varchar(30),  getdate(), 21)) 

		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'main',  
		@recipients = 'vintagednepr2@const.dp.ua',  
		@body = @tableHTML,  
		@subject = @subject,
		@body_format = 'HTML' ;
	END	