--—мена курса в справочнике валют Elit
BEGIN TRAN

DECLARE @Date DATE = '20180901' --дата смены курса
DECLARE @New_KursMC numeric(21,9) = 29.00 -- новый курс доллара


SELECT * FROM r_Currs WHERE  CurrID = 2 --”краинские гривны
SELECT * FROM r_CurrH WHERE  CurrID = 2 ORDER BY DocDate desc --”краинские гривны

SELECT * FROM r_Currs WHERE  CurrID = 1 --јмериканский доллар
SELECT * FROM r_CurrH WHERE  CurrID = 1 ORDER BY DocDate desc --јмериканский доллар

UPDATE r_Currs SET KursCC = @New_KursMC WHERE  CurrID = 1 --јмериканский доллар
INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (1, @Date, 1.00, @New_KursMC) --јмериканский доллар
UPDATE r_Currs SET KursMC = @New_KursMC WHERE  CurrID = 2 --”краинские гривны
INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (2, @Date, @New_KursMC, 1.00) --”краинские гривны

SELECT * FROM r_Currs WHERE  CurrID = 2 --”краинские гривны
SELECT * FROM r_CurrH WHERE  CurrID = 2 ORDER BY DocDate desc --”краинские гривны

SELECT * FROM r_Currs WHERE  CurrID = 1 --јмериканский доллар
SELECT * FROM r_CurrH WHERE  CurrID = 1 ORDER BY DocDate desc --јмериканский долла


ROLLBACK TRAN
