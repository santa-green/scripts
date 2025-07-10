--Смена курса в справочнике валют ElitR
BEGIN TRAN

DECLARE @Date DATE = '20180901' --дата смены курса
DECLARE @New_KursMC numeric(21,9) = 29.00 -- новый курс доллара

SELECT * FROM r_Currs WHERE  CurrID = 980 --Украинские гривны
SELECT * FROM r_CurrH WHERE  CurrID = 980 ORDER BY DocDate desc --Украинские гривны

SELECT * FROM r_Currs WHERE  CurrID = 840 --Американский доллар
SELECT * FROM r_CurrH WHERE  CurrID = 840 ORDER BY DocDate desc --Американский доллар

UPDATE r_Currs SET KursCC = @New_KursMC WHERE  CurrID = 840 --Американский доллар
INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (840, @Date, 1.00, @New_KursMC) --Американский доллар
UPDATE r_Currs SET KursMC = @New_KursMC WHERE  CurrID = 980 --Украинские гривны
INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (980, @Date, @New_KursMC, 1.00) --Украинские гривны

SELECT * FROM r_Currs WHERE  CurrID = 980 --Украинские гривны
SELECT * FROM r_CurrH WHERE  CurrID = 980 ORDER BY DocDate desc --Украинские гривны

SELECT * FROM r_Currs WHERE  CurrID = 840 --Американский доллар
SELECT * FROM r_CurrH WHERE  CurrID = 840 ORDER BY DocDate desc --Американский доллар


ROLLBACK TRAN
