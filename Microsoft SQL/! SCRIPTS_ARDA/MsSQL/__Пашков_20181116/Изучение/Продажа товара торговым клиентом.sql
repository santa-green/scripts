exec t_SaleUniInputAction 777,1011,11,@p4 output,@p5 output,@p6 output
/* ���������� ����� ��������� ���������� �������� � ���� ������� ����� */ 

exec t_SaleSavePays 1011,11,1,1,200,0,0,0,'',''
/* ��������� ������ ��� ���������� ���� ��������� */
EXEC t_SaleGetPays 1011, 11
/* ��������� ������ ����� ��� ���������� ���� ��������� */

exec t_SaleCreateMasterRecord 11,777,361,200,56,@p6 output,@p7 output,@p8 output,@p9 output
/* ��������� ������ � ��������� ��������� ������� ������ ���������� */ 
EXEC t_SaleCRCheque 11
/* ���������� ����� ������, �� �������� ���������� ���. */

EXEC t_SaleCRCommentPos 11
/* ���������� ����������� � �������� ���� */

SELECT d.TaxID, d.Override
FROM r_ProdLV m
  JOIN r_Prods p ON m.ProdID = p.ProdID
  JOIN r_LevyCR d ON m.LevyID = d.LevyID 
WHERE m.ProdID = 802412 AND d.CashType = 8 AND d.TaxTypeID = 0 AND
  ((p.TaxTypeID = d.TaxTypeID AND d.Override = 1) OR (d.Override = 0))

exec t_SaleEmptyTempTable 11,2682
/* ���������� �������� ������ � ������� ������ �� ��������� ������� � �������� ������� */

exec t_SaleAfterClose 2682,0,@p3 output,@p4 output,@p5 output
 /* ��������� ����� �������� ���� */
 
SELECT dbo.tf_CRShiftBegin(777)
/* ���������� ����� ������ ����� */

exec t_OpenCheque 777,9,0,361,@p5 output
/* ������� ��������� �� ��������� ��������� ������� */ 

SELECT dbo.zf_GetChequeSumCC_wt(11)
/* ���������� ����� ���� */

