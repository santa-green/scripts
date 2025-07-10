--����� ����� � ����������� ����� ElitDistr
BEGIN TRAN

DECLARE @Date DATE = '20190301' --���� ����� �����
DECLARE @New_KursMC numeric(21,9) = 28.00 -- ����� ���� �������


SELECT * FROM r_Currs WHERE  CurrID = 2 --���������� ������
SELECT * FROM r_CurrH WHERE  CurrID = 2 ORDER BY DocDate desc --���������� ������

SELECT * FROM r_Currs WHERE  CurrID = 1 --������������ ������
SELECT * FROM r_CurrH WHERE  CurrID = 1 ORDER BY DocDate desc --������������ ������

UPDATE r_Currs SET KursCC = @New_KursMC WHERE  CurrID = 1 --������������ ������
INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (1, @Date, 1.00, @New_KursMC) --������������ ������
UPDATE r_Currs SET KursMC = @New_KursMC WHERE  CurrID = 2 --���������� ������
INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (2, @Date, @New_KursMC, 1.00) --���������� ������

SELECT * FROM r_Currs WHERE  CurrID = 2 --���������� ������
SELECT * FROM r_CurrH WHERE  CurrID = 2 ORDER BY DocDate desc --���������� ������

SELECT * FROM r_Currs WHERE  CurrID = 1 --������������ ������
SELECT * FROM r_CurrH WHERE  CurrID = 1 ORDER BY DocDate desc --������������ �����


ROLLBACK TRAN
