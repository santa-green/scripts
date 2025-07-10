declare @wanted_date smalldatetime;
set @wanted_date = '2015-03-01';
SELECT 
'+' DK
,DocNum N_D
,SumAC SUMMA
,DocDate DATE
,(SELECT c2.CompName FROM r_Comps c2 where c2.CompID = c.CompID) PR_NAME
,CompAccountAC PR_RS 
,(select s1.BankID from r_CompsCC s1 where s1.CompID = c.CompID and s1.CompAccountCC = c.CompAccountAC) PR__MFO
,(select rb.BankName from r_Banks rb where rb.BankID = (select s1.BankID from r_CompsCC s1 where s1.CompID = c.CompID and s1.CompAccountCC = c.CompAccountAC)) PR__BANK
,(SELECT ro.OurName FROM r_Ours ro where OurID = c.OurID) ORG_NAME
,AccountAC ORG_RS
,(SELECT ro.BankID FROM r_OursAC ro WITH(NOLOCK) JOIN r_Banks rb WITH(NOLOCK) ON rb.BankID = ro.BankID WHERE ro.AccountAC = c.AccountAC and ro.OurID = c.OurID) ORG_MFO
,(select rb2.BankName from r_Banks rb2 where rb2.BankID = (SELECT ro.BankID FROM r_OursAC ro WITH(NOLOCK) JOIN r_Banks rb WITH(NOLOCK) ON rb.BankID = ro.BankID WHERE ro.AccountAC = c.AccountAC and ro.OurID = c.OurID)) ORG_BANK
,Subject N_P
,CurrID VAL
,(SELECT Code FROM r_Comps s1 where s1.CompID = c.CompID) PR_OKPO
,(SELECT Code FROM r_Ours s1 where s1.OurID = c.OurID) ORG_OKPO
,(SELECT azc.ContrID FROM at_z_Contracts azc where azc.OurID = c.OurID and azc.CompID = c.CompID and azc.Status = 1 and azc.ContrTypeID = 1 /*1 - договор поставки*/) DOGOVOR
FROM c_CompRec c
--where c.DocDate = @wanted_date
order by CompAccountAC desc

SELECT ChID, OurID, AccountAC, DocDate, DocID, StockID, CompID, CompAccountAC, CurrID, KursMC, KursCC, SumAC, Subject, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, StateCode, DepID, DocNum, SrcDocID
FROM c_CompRec where ChID = 101933238

SELECT * FROM at_z_Contracts azc 
SELECT
  RefName, RefID
FROM
  r_Uni WITH(NOLOCK)
WHERE
  RefTypeID = 6660112
ORDER BY
  RefName
SELECT * FROM r_OursAC ro WITH(NOLOCK) JOIN r_Banks rb WITH(NOLOCK) ON rb.BankID = ro.BankID WHERE ro.AccountAC ='0'


SELECT * FROM r_CompsCC cc where cc.CompID = 7062 and cc.DefaultAccount = 1
SELECT * FROM r_CompsCC
select * from r_Banks
select TABLE_NAME from Elit_TEST.INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME = 'BankID';
select * from  r_OursCC


SELECT * FROM r_OursCC s1

SELECT ro.BankID FROM r_OursAC ro WITH(NOLOCK) JOIN r_Banks rb WITH(NOLOCK) ON rb.BankID = ro.BankID WHERE ro.AccountAC = c.AccountAC





SELECT * FROM z_Tables where TableName = 'r_CompsCC'
SELECT * FROM z_Tables where TableName = 'c_CompRec'

SELECT * FROM r_Ours
select * from r_OursCC
select * from r_OursAC


SELECT * FROM r_Currs;

SELECT * FROM r_Comps;
SELECT * FROM r_CompsCC
SELECT * FROM r_CompsAC

select * from r_Banks

select * from c_CompRec

insert r_Users
SELECT 3000 ChID, 3000 UserID, 'CONST\vintagednepr1' UserName, EmpID, Admin, Active, Emps, s_PPAcc, s_Cost, s_CCPL, s_CCPrice, s_CCDiscount, ValidOurs, ValidStocks, ValidPLs, ValidProds, CanCopyRems, BDate, EDate, UseOpenAge, CanInitAltsPL, ShowPLCange, CanChangeStatus, CanChangeDiscount, CanPrintDoc, CanBuffDoc, CanChangeDocID, CanChangeKursMC, AllowRestEditDesk, AllowRestReserve, AllowRestMove, CanExportPrint, p_SalaryAcc, AllowRestChequeUnite, AllowRestChequeDel, OpenAgeBType, OpenAgeBQty, OpenAgeEType, OpenAgeEQty, AllowRestViewDesk
 FROM r_Users where UserName = 'sa'

r_OursCC
r_OursAC
r_CompsCC
r_CompsAC
