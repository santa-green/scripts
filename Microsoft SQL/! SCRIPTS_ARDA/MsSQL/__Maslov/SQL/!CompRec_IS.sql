DECLARE @CheckoutIDs VARCHAR(8000) = '12930504851569,12932244602993,12932121034865,12930439217265,12930900328561,12930824274033,12934174146673,12931595174001' --�������� Order ID
DECLARE @Subject VARCHAR(200) = '��� "�� "������" ������ �� ��������� �������� 2020-04-21 ��� 6529.00 ��� 176.29' --������������
DECLARE @f INT = 2	--@f = 1 - ��� ������� ����� �� ������������
					--@f = 2 - ��� ������� ����� �� ������������
DECLARE @per NUMERIC(21,9) = 2.7	--�������� �����.
DECLARE @EmpID INT = 26				--��� ���������.

SELECT CASE WHEN @f = 1
			 THEN 6
			ELSE 8 END AS '�����'
	  ,CONVERT(VARCHAR, GETDATE(), 104) AS '����'
	  ,m.StockID AS '�����'
	  ,CASE WHEN @f = 1
			 THEN 63
			ELSE 2040 END AS '������� 1'
	  ,CASE WHEN @f = 1
			 THEN 18
			ELSE 2241 END AS '������� 2'
	  ,19 AS '������� 3'
	  ,CASE WHEN @f != 1 AND (m.StockID = 1200 OR m.StockID = 1201)
			 THEN 2531
			WHEN @f != 1 AND (m.StockID = 731)
			 THEN 2530
			WHEN @f != 1 AND (m.StockID = 1252)
			 THEN 2536
			ELSE 0 END AS '������� 4'
	  ,CASE WHEN @f != 1
			 THEN 2018
			ELSE 0 END AS '������� 5'
	  ,CASE WHEN @f = 1
			 THEN 1
			ELSE 10450 END AS '�����������'
	  ,dbo.zf_GetCurrCC() AS '������'
	  ,CASE WHEN @f = 1
			 THEN REPLACE( CAST( ROUND(SUM(d.SumCC_wt), 2) AS VARCHAR), '.', ',' )
			 ELSE REPLACE( CAST( ROUND(SUM(d.SumCC_wt)*(@per/100), 2) AS VARCHAR), '.', ',' ) END AS '����� ��'
	  ,@EmpID AS '��������'
	  ,@Subject AS '������������'
	  ,CASE WHEN @f = 1
			 THEN m.DocID
			 ELSE CAST(YEAR(GETDATE()) AS VARCHAR) + RIGHT('00' + CAST(MONTH(GETDATE()) AS VARCHAR), 2) END AS '�����'
	  ,CAST(dbo.zf_GetRateMC(dbo.zf_GetCurrCC()) AS INT) AS '���� ��'
	  ,1 AS '���� ��'
FROM at_t_IORes m
JOIN at_t_IOResD d ON d.ChID = m.ChID
WHERE m.DocID IN
(
SELECT DocID FROM t_IMOrders WHERE ShopifyCheckoutID IN (SELECT AValue FROM zf_FilterToTableBIGINT(@CheckoutIDs))
)
GROUP BY m.StockID, m.DocID
ORDER BY m.DocID
/*
12932244602993
��� "�� "������" ������ �� ��������� �������� 2020-04-21 ��� 6529.00 ��� 176.29
��� "�� "������" ������ �� ��������� �������� 2020-04-21 ��� 6529.00 ��� 176.29

*/