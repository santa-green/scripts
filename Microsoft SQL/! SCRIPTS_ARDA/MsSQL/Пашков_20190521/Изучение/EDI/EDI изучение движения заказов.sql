USE Alef_Elit

--DECLARE @docid int = 45215838
DECLARE @docid VARCHAR(max) = '2018019037'


----����� ������� ������������
--SELECT * FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExp] where docid = @docid ORDER BY 1
--SELECT * FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExpD] where chid in (SELECT chid FROM [S-SQL-D4].[ElitR].[dbo].[t_EOExp] where docid = @docid) ORDER BY 1

SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = CAST(@docid as varchar(30))
SELECT * FROM ALEF_EDI_ORDERS_2_POS where ZEP_ORDER_ID in (SELECT ZEO_ORDER_ID FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_NUMBER = CAST(@docid as varchar(30))) ORDER BY 1, ZEP_POS_ID

--����� ����������: ������������
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_IORecD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_IORec] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID

--����� ����������: ������
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[at_t_IOResD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[at_t_IORes] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID

--��������� ���������
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = CAST(@docid as varchar(30))
SELECT * FROM [S-SQL-D4].[Elit].[dbo].[t_InvD] where chid in (SELECT chid FROM [S-SQL-D4].[Elit].[dbo].[t_Inv] where OrderID = CAST(@docid as varchar(30))) ORDER BY 1, SrcPosID




/*
��� �������	�������� �������
0	����� �����
1	���������� � ��
3	���������� ���������
4	���������������
5	����� ����� � ��
31	����� �����, ��� ������������
32	���� �������� ������ �������
33	����������� ������� ��� ������
34	�� ���������� ����� ����
35	�� ����������� �������� �������
36	��� ���� ��� ������
37	��� �������� ��� �������
38	������ �����
39	��� ���� ���������
null	����������� ������

SELECT * FROM ALEF_EDI_ORDERS_2 where ZEO_ORDER_ID IN (SELECT ZEP_ORDER_ID FROM ALEF_EDI_ORDERS_2_POS where ZEP_POS_KOD IN ('6032166','6032033','6032152','6032173','6032427'))
SELECT * FROM ALEF_EDI_ORDERS_2_POS where ZEP_POS_KOD IN ('6032166','6032033','6032152','6032173','6032427')


SELECT DISTINCT ProdID from r_ProdEC rpe WHERE rpe.ExtProdID IN ('1135889','6032166','6032033','6032173','1135894','1135923','1135924','1135928','1135891','6032152','6032427','1135898')
AND rpe.ProdID NOT IN (26213,31815,31874,29151,28585,28586,29152,31878,26168,31880,3127 ,31879,30843)

*/