--������ ������������ ��� �������� ��������
/*
1. ���������� ���� 
�������� ����� � 1260 �� 1245 �� ������ 302
*/

/*
2. �������� �������
�� ������������ 302 ��������� ����� �������� � 1260 �� 1245
*/

/*  
3. �������� � [192.168.157.22].ElitRTS302.dbo.[t_SaleAfterClose] ������ WHEN m.StockID IN (1245) THEN 95 --������� ��.�����,15
   �������� � [192.168.157.22].ElitRTS302.dbo.[t_SaleRetAfterClose] ������ WHEN m.StockID IN (1245) THEN 95 --������� ��.�����,15
  
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
		         									         WHEN m.StockID IN (1245) THEN 95 --������� ��.�����,15
		         									         WHEN m.StockID IN (1221,1222) THEN 82
		         									         WHEN m.StockID IN (1241) THEN 93
		         									         WHEN m.StockID IN (1243) THEN 94 -- ���� �������� �������� 2�
		         									         WHEN m.StockID IN (1252) THEN 78
		         									         WHEN m.StockID IN (723) THEN 91
		         									         WHEN m.StockID IN (1001) THEN 75
													         WHEN m.StockID IN (1310,1314) THEN 84 END)    
	    							       WHEN 2 THEN 27 WHEN 5 THEN 70 ELSE 0 END


  /* ��������� ��������� ��������� */
  IF (SELECT COUNT(*) 
      FROM t_CRRet m WITH(NOLOCK)
	  JOIN t_CRRetPays p WITH(NOLOCK) ON p.ChID = m.ChID AND m.ChID = @ChID
	  WHERE p.Notes NOT LIKE '�����') = 1
    UPDATE m 
	   SET m.CodeID1 = 63,
	       m.CodeID2 = 19,
	       --m.CodeID3 = CASE p.PayFormCode WHEN 1 THEN 73 -- �������� ��� ������ ��������
	       m.CodeID3 = CASE p.PayFormCode WHEN 1 THEN (CASE WHEN m.StockID IN (1201,1202,1315) THEN 81 
		         									         WHEN m.StockID IN (1257) THEN 73
		         									         WHEN m.StockID IN (1245) THEN 95 --������� ��.�����,15
		         									         WHEN m.StockID IN (1221,1222) THEN 82
		         									         WHEN m.StockID IN (1241) THEN 93
		         									         WHEN m.StockID IN (1243) THEN 94 -- ���� �������� �������� 2�
		         									         WHEN m.StockID IN (1252) THEN 78
		         									         WHEN m.StockID IN (723) THEN 91
		         									         WHEN m.StockID IN (1001) THEN 75
													         WHEN m.StockID IN (1310,1314) THEN 84 END)    
	    							       WHEN 2 THEN 27 WHEN 5 THEN 70 ELSE 0 END

	    							       
*/
/*
4. ���������� �������
�� ������ 1245 ����������� ����� 86
*/
/*
5. �������� �����
�������� ����� 1245 � �� ����� ��� ���� ����� 1260
*/
/*
6. �����: ����� ������� �� ����
�������� � ����������� ����� 1260 �� 1245
*/
/*
7. ��� �������� 
�������� � �������� ����� 1260 �� 1245
*/
/*
8. �����: ����� ������� �� ����
�������� � �������� ����� 1260 �� 1245 � �������� ����� 2709
[192.168.157.22].ElitRTS302.dbo.[a_tRem_CheckNegativeRems_IU]
[a_tRem_CheckNegativeRems_IU]
*/
