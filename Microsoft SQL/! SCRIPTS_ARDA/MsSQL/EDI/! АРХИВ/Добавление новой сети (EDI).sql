SELECT * FROM r_UniTypes WHERE RefTypeName like '%edi%'

--TRAN 80019
BEGIN TRAN
SELECT * FROM r_Uni WHERE RefTypeID = 80019 and RefID = 71711--RefName like '%edi%'
insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) VALUES (80019,	71711,	'ÒçÎÂ  "ÎÊÊÎ Äðàéâ" (Êèåâ)',	'ORDER,ORDRSP,DESADV,COMDOC,RETANN,INVOICE')
SELECT * FROM r_Uni WHERE RefTypeID = 80019 and RefID = 71711--RefName like '%edi%'    
ROLLBACK TRAN

--TRAN 6680116
BEGIN TRAN
SELECT * FROM r_Uni WHERE RefTypeID = 6680116 and RefName like '%îêêî%'
update r_Uni set Notes = 1 WHERE RefTypeID = 6680116 and RefName like '%îêêî%'     
SELECT * FROM r_Uni WHERE RefTypeID = 6680116 and RefName like '%îêêî%'
ROLLBACK TRAN

--TRAN 6680117
BEGIN TRAN
SELECT * FROM r_Uni WHERE RefTypeID = 6680117 and RefID = 71711
--insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) VALUES (6680117,	71711,	'ÒçÎÂ  "ÎÊÊÎ Äðàéâ" (Êèåâ) => OKKO',	0)
update r_Uni set Notes = (
    SELECT top 1 RetailersID FROM at_GLN WHERE RetailersName like '%ÎÊÊÎ%'
    ) WHERE RefTypeID = 6680117 and RefID = 71711
SELECT * FROM r_Uni WHERE RefTypeID = 6680117 and RefID = 71711
ROLLBACK TRAN

SELECT * FROM at_GLN ORDER BY ImportDate DESC
--SELECT * FROM at_GLN WHERE ImportDate > convert(date, GETDATE()-1, 102) ORDER BY ImportDate DESC


