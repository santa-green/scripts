--����� ����� � ����������� ����� ElitR
BEGIN TRAN

DECLARE @Date DATE = '20180901' --���� ����� �����
DECLARE @New_KursMC numeric(21,9) = 29.00 -- ����� ���� �������

SELECT * FROM r_Currs WHERE  CurrID = 980 --���������� ������
SELECT * FROM r_CurrH WHERE  CurrID = 980 ORDER BY DocDate desc --���������� ������

SELECT * FROM r_Currs WHERE  CurrID = 840 --������������ ������
SELECT * FROM r_CurrH WHERE  CurrID = 840 ORDER BY DocDate desc --������������ ������

UPDATE r_Currs SET KursCC = @New_KursMC WHERE  CurrID = 840 --������������ ������
INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (840, @Date, 1.00, @New_KursMC) --������������ ������
UPDATE r_Currs SET KursMC = @New_KursMC WHERE  CurrID = 980 --���������� ������
INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (980, @Date, @New_KursMC, 1.00) --���������� ������

SELECT * FROM r_Currs WHERE  CurrID = 980 --���������� ������
SELECT * FROM r_CurrH WHERE  CurrID = 980 ORDER BY DocDate desc --���������� ������

SELECT * FROM r_Currs WHERE  CurrID = 840 --������������ ������
SELECT * FROM r_CurrH WHERE  CurrID = 840 ORDER BY DocDate desc --������������ ������


ROLLBACK TRAN
