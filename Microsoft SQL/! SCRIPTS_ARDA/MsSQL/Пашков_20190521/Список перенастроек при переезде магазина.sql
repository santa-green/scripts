--������ ������������ ��� �������� ��������
/*
1. ���������� ���� 
�������� ����� � 1241 �� 1243 �� ������ 201,220,222
*/

/*
2. ���������� ����� 
�������� ���� 63 ���� (174.103)
IP 192.168.174.103
����� � 1241 �� 1243
*/

/*
3. �������� � [192.168.174.38].ElitRTS220.dbo.[t_SaleAfterClose] ������ WHEN m.StockID IN (1243) THEN 94 -- ���� �������� �������� 2�
   �������� � [192.168.174.30].ElitRTS201.dbo.[t_SaleAfterClose] ������ WHEN m.StockID IN (1243) THEN 94 -- ���� �������� �������� 2�
   �������� � [192.168.174.38].ElitRTS220.dbo.[t_SaleRetAfterClose] ������ WHEN m.StockID IN (1243) THEN 94 -- ���� �������� �������� 2�
   �������� � [192.168.174.30].ElitRTS201.dbo.[t_SaleRetAfterClose] ������ WHEN m.StockID IN (1243) THEN 94 -- ���� �������� �������� 2�
  
  /* ��������� ��������� ��������� */
  IF (SELECT COUNT(*) 
      FROM t_Sale m WITH(NOLOCK)
      JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID AND m.ChID = @ChID
      WHERE p.Notes NOT LIKE '�����') = 1
        UPDATE m
	    SET m.CodeID1 = 63, 
	        m.CodeID2 = 18, 
	        m.CodeID3 = CASE p.PayFormCode WHEN 1 THEN (CASE WHEN m.StockID IN (1201,1202,1315) THEN 81 
		         									         WHEN m.StockID IN (1257) THEN 73
		         									         WHEN m.StockID IN (1260) THEN 92
		         									         WHEN m.StockID IN (1221,1222) THEN 82
		         									         WHEN m.StockID IN (1241) THEN 93
		         									         WHEN m.StockID IN (1243) THEN 94 -- ���� �������� �������� 2�
		         									         WHEN m.StockID IN (1252) THEN 78
		         									         WHEN m.StockID IN (723) THEN 91
		         									         WHEN m.StockID IN (1001) THEN 75
													         WHEN m.StockID IN (1310,1314) THEN 84 END)    
	    							       WHEN 2 THEN 27 WHEN 5 THEN 70 END

	    							       
*/
/*
4. ���������� �������
�� ������ 1243 ����������� ����� 85
*/
/*
5. �������� �����
�������� ����� 1243 � �� ����� ��� ���� ����� 1241
*/
/*
6. �����: ����� ������� �� ����
�������� � ����������� ����� 1241 �� 1243
*/
/*
7. ��� �������� ��������
�������� � �������� ����� 1241 �� 1243
[ap_VC_SaleTemp_Export_201]
[ap_VC_Exprot_SaleTemp_Kiev]
[av_VC_ExportRemsR_Kiev]
[af_VC_GetDocStockID]
[ap_VC_SaleTemp_Export]
[af_GetStocksUser]
[a_cCompExp_IUD]
[a_cCompRec_IUD]
[a_tIORes_IS_U]
[a_t_sale_link_for_IM]
[af_GetStocksUser]
ap_ReWriteOffNegRems
[a_tRem_CheckNegativeRems_IU]

*/
/*
6. �����: ����� ������� �� ����
�������� � �������� ����� 1241 �� 1243 � �������� ����� 2708
[192.168.174.38].[ElitRTS220].[dbo].[a_tRem_CheckNegativeRems_IU]
[192.168.174.30].[ElitRTS201].[dbo].[a_tRem_CheckNegativeRems_IU]
[a_tRem_CheckNegativeRems_IU]
*/
