--1 VC_CLIENTS
EXEC ap_VC_ImportClients
GO
--2 VC_PRODS
EXEC ap_VC_ExportProds
GO
--3 ap_VC_ExportProds_Harkov ������� �������� �� �������� � �� ����� 6
EXEC ap_VC_ExportProds_Harkov
GO
--4 ������ ������� � ����� �� �������� dbo.ap_VC_ImportOrders_Harkov
EXEC dbo.ap_VC_ImportOrders_Harkov
GO
--5 ������� ����������� ���� � �������� ������ ElitRTS301 [ap_VC_Exprot_SaleTemp_Harkov]
EXEC [ap_VC_Exprot_SaleTemp_Harkov]
GO
--6 ap_VC_ExportProds_Dnepr ������� �������� �� ������ � �� ����� 6
EXEC ap_VC_ExportProds_Dnepr
GO
--7 ������ ������� � ����� �� ������ dbo.ap_VC_ImportOrders_Dnepr
EXEC dbo.ap_VC_ImportOrders_Dnepr
GO
--8 ������� ����������� ���� � �������� ������ ElitV_DP [ap_VC_Exprot_SaleTemp_Dnepr]
EXEC [ap_VC_Exprot_SaleTemp_Dnepr]
GO
--9 ap_VC_ExportProds_Kiev ������� �������� �� ����� � �� ����� 6
EXEC ap_VC_ExportProds_Kiev
GO
--10 ������ ������� � ����� �� ����� dbo.ap_VC_ImportOrders_Kiev
EXEC dbo.ap_VC_ImportOrders_Kiev
GO
--11 ������� ����������� ���� � �������� ������ ElitRTS201 [ap_VC_Exprot_SaleTemp_Kiev]
IF CONVERT (time, GETDATE()) > '10:00:00' 
  AND CONVERT (time, GETDATE()) < '22:00:00'
    EXEC [ap_VC_Exprot_SaleTemp_Kiev]
GO    
--12 dbo.ap_VC_ExportProds_Odessa  ������� �������� �� ������ � �� ����� 6
EXEC  dbo.ap_VC_ExportProds_Odessa
GO 
--13 ������ ������� � ����� ��  ������ dbo.ap_VC_ImportOrders_Odessa
EXEC  dbo.ap_VC_ImportOrders_Odessa
GO
--14 ������� ����������� ���� � �������� ������ ElitRTS401 [ap_VC_Exprot_SaleTemp_Odessa]    
IF CONVERT (time, GETDATE()) > '09:20:00' 
  AND CONVERT (time, GETDATE()) < '22:00:00' 
  AND DATEPART(weekday, getdate()) in (2,3,4,5,6) -- � �� �� ��
   EXEC ap_VC_Exprot_SaleTemp_Odessa