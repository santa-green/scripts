/*
t_Sale � ������� ������ ����������: ���������; �� ElitR ���� �������� ��� ������� � ��������� � ���������. ��� �������� �����.
t_SaleD � ��������� ����� � ����, ��� ������.
t_SalePays � ����� ����������� ������ �� ������� (���, ������, �����).
t_Sale_R � �����, �� ����, �������� ������� RKeeper (������������� ������� ����� ������� � ElitR).
r_DBIs � ������ ��� ������ � �� ��������� ChID.
r_DeskG - ������ ��������.
r_Desks - ������� � ������.
Crid = 153 - ����� (���. �6), VISA (��� �6, ���. �6) - ��. ap_Rkiper_Import_Sale (Z-�����)
Crid = 160 - ����������� ����� (�� �� �12)
Crid = 109 - ����������� ����� (��� �� �12)
/*Crid = 181 - ����� �������*/
CodeID3 = 81 --��� (�����)
CodeID3 = 89 --��� (��)
CodeID3 = 27 --�� (VISA)
*/

--13.05 (�������� ����� �������?)
SELECT EXTFISCID, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks WHERE CHECKNUM = 232759
SELECT StockID, CodeID3, CRID, CURRENCYTYPE, CURRENCY, * FROM t_Sale_R WHERE Docid = 231719 and DocDate = '20210513'
SELECT * FROM t_SalePays WHERE ChID = 1800027053 --PayFormCode = '��������' then 1
SELECT StockID, CodeID3, CRID, * FROM t_Sale WHERE Docid = 231719 and DocDate = '20210513'
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210513' and CodeID3 in (27, 81, 89) --and docid = 231899

--07.05
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153) and DocDate = '20210507'--and docid = 231899
SELECT DocID, m.DocTime, TRealSum, * FROM t_Sale m WHERE CRID in (153) and DocDate '20210507' ORDER BY m.DocTime--and docid = 231899
SELECT DocID, * FROM t_Sale WHERE CRID in (153) and DocDate = '20210507' and docid = 231529
SELECT * FROM t_Sale WHERE /*CRID in (153) and*/ DocDate = '20210507' and docid in (231529, 231530) and OurID = 6
SELECT * FROM t_SaleD WHERE ChID = 1800026972
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (160) and DocDate = '20210507'--and docid = 231899
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (109) and DocDate = '20210507'--and docid = 231899
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210507' and CodeID3 = 27 --(18118.500000000 +)
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210507' and CodeID3 = 81 --(1130.000000000 +)
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210507' and CodeID3 = 89 --(DIFF 2760; RK 37219 != GMS 34459.000000000)
SELECT * FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210507' and CodeID3 = 89 ORDER BY DocTime DESC --(DIFF 2760; RK 37219 != GMS 34459.000000000)
SELECT * FROM t_Sale WHERE CRID in (153, 160, 109) /*and DocDate = '20210507'*/ AND DocID in (231657,231658,231659,231660,231661,231662,231663,231664,231665)

--08.05
SELECT * FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210508' ORDER BY DocTime DESC
SELECT * FROM t_Sale_R WHERE CRID in (153, 160, 109) and DocDate = '20210508' AND DocID in (231657,231658,231659,231660,231661,231662,231663,231664,231665)
SELECT EXTFISCID, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks WHERE CHECKNUM in (231657,231658,231659,231660,231661,231662,231663,231664,231665)


SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210507'--and docid = 231899
SELECT SUM(TRealSum) FROM t_Sale WHERE DocDate = '20210507'--and docid = 231899
SELECT * FROM t_Sale WHERE DocDate = '20210507'--and docid = 231899
SELECT * FROM t_Sale WHERE CRID in (153) and DocDate = '20210507'--and docid = 231899



SELECT * FROM t_Sale WHERE CRID = 153 and DocDate = '20210514' and CodeID3 = 81--���
SELECT * FROM t_Sale WHERE CRID = 153 and DocDate = '20210514' and CodeID3 = 27--��
SELECT * FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210513' and docid = 231719
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210507' and CodeID3 in (27, 81, 89) --and docid = 231899
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210514' --and docid = 231899
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210514'--and docid = 231899
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210507'--and docid = 231899

SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210514' and CodeID3 = 27 --VISA 33568.000000000 (+)
/*������� ����� ������ � ��*/ 
--������� = 1155 !!
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210514' and CodeID3 = 81 --����� 3165.000000000 (� ����� = 4320)
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) and DocDate = '20210514' and CodeID3 = 89 --�� 53260.000000000 (� ����� = 52105)

SELECT * FROM t_Sale WHERE DocDate = '20210514' and DocID = 231899

execute as login = 'pvm0'
select SYSTEM_USER

begin tran
SELECT * FROM t_Sale WHERE CRID in (153) and DocDate = '20210507' and docid in (231530) and OurID = 6
update t_Sale set CRID = 160, OurID = 12, DocID = -231530 WHERE CRID in (153) and DocDate = '20210507' and docid in (231530) and OurID = 6
SELECT * FROM t_Sale WHERE CRID in (160) and DocDate = '20210507' and docid in (231530, -231530)
rollback tran

SELECT * FROM t_Sale WHERE DocID = -231530
TRel2_Upd_t_Sale

--��� ��������� � z-�������.
SELECT DocID, DocDate, TRealSum FROM t_Sale WHERE CRID in (153) and DocDate between  '20210507' and '20210515' ORDER BY 3
SELECT DocID, DocDate, TRealSum FROM t_Sale WHERE CRID in (153) and DocDate between  '20210516' and '20210523' ORDER BY 3
SELECT DocID, datepart(day, DocDate), DocDate, TRealSum FROM t_Sale WHERE CRID in (153) and DocDate between  '20210516' and '20210523' ORDER BY 3

--������� �� ������.
SELECT datepart(day, DocDate)
,      SUM(TRealSum)
FROM t_Sale
WHERE CRID in (153)
	and DocDate between  '20210516' and '20210523'
GROUP BY datepart(day, DocDate)
ORDER BY 1

--������ �� ����.
SELECT DocID, DocTime, TRealSum FROM t_Sale WHERE CRID in (153) and DocDate = '20210517' ORDER BY 3
SELECT * FROM t_Sale_R WHERE /*CRID in (153) and*/ DocDate = '20210516' and Prodid = 607920
SELECT * FROM t_Sale_R WHERE /*CRID in (153) and*/ DocDate between  '20210516' and '20210523' and Prodid = 607579
SELECT * FROM t_Sale_R WHERE /*CRID in (153) and*/ DocDate between  '20210517' and '20210517' and Prodid = 607579
SELECT * FROM t_Sale_R WHERE /*CRID in (153) and*/ DocDate between  '20210517' and '20210523' and SumCC_wt = 475
SELECT * FROM t_Sale WHERE /*CRID in (153) and*/ DocDate between  '20210516' and '20210523' and DocID = 232759
SELECT EXTFISCID, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks WHERE CHECKNUM = 232759
SELECT * FROM t_Sale WHERE /*CRID in (153) and*/ DocDate between  '20210516' and '20210523' and DocID = 232864

--��������� DocDate, DocTime.
SELECT m.DocTime
,      m.Docdate
,      *
FROM t_Sale m
WHERE DocDate between  '20210516' and '20210523'
	and datepart(day, DocDate) <> datepart(day, DocTime)
    --and CRID in (153)
ORDER BY m.DocTime DESC

begin tran
/*execute as login = 'pvm0'
revert
select SYSTEM_USER*/
SELECT * FROM t_Sale WHERE /*CRID in (153) and*/ DocDate between  '20210516' and '20210523' /*and DocID = 232759*/
SELECT * FROM t_Sale WHERE /*CRID in (153) and*/ DocDate between '20210516' and '20210523' /*and DocID = 232759*/
update t_Sale set DocDate = '2021-05-16 00:00:00' WHERE ChID = 1800028064
SELECT * FROM t_Sale WHERE /*CRID in (153) and*/ DocDate between  '20210516' and '20210523' and DocID = 232759
rollback tran

--231719
--���	����� (Rkeeper)
--������ ����� 50��, ����.
SELECT CodeID3, CRID, * FROM t_Sale WHERE DocID = 231719 and DocDate = '20210513'
SELECT * FROM t_Sale_R WHERE CRID = 109 and CodeID3 = 89 and [�� ��� ��� ] = '�����' ORDER BY 3 DESC
SELECT * FROM t_Sale WHERE DocID = 231719