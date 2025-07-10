BEGIN TRAN
select * from ALEF_AKCIA_SUBJECTS where AS_CODES in (70858, 70752)

--delete from ALEF_AKCIA_SUBJECTS where AS_ID = 94 and AS_CODES in (19784,74122,74143)
			

select * from ALEF_AKCIA where AA_C5 = 2017 AND AA_isACTIVE = 1

select * from ALEF_AKCIA_SUBJECTS where AS_ID IN (100)

select * from ALEF_AKCIA_OBJECTS where AO_ID IN (33)
select * from ALEF_AKCIA where AA_ID IN (45)

select * from ALEF_AKCIA_OBJECTS where AO_CODE in (29796)
select COUNT(*) from ALEF_AKCIA

select * from ALEF_AKCIA where AA_C5 = 2071

BEGIN TRAN
	DECLARE @Akcia varchar(10) = 
		delete from ALEF_AKCIA where AA_ID =  @Akcia
		delete from ALEF_AKCIA_SUBJECTS where AS_ID =  @Akcia
		delete from ALEF_AKCIA_OBJECTS where AO_ID =  @Akcia
ROLLBACK TRAN

delete from ALEF_AKCIA_OBJECTS where AO_ID IN (220)

-- обновление параметров в существующих акциях
update dbo.ALEF_AKCIA
	set
	AA_NAME = 'Intero, 5+1(29796)',
	AA_DATE_FROM = '2019-04-18',
	AA_DATE_TO = '2019-12-31',
	AA_NOTE = '«Intero, 5+1(29796)»',
	AA_isACTIVE = 1,
	--AA_isPAYTYPE = 0,
	--AA_OVERALL = 0
	--AA_C1 = 50,
	--AA_C3 = 1
	--AA_C4 = 2011,
	AA_C5 = 2061
	where AA_ID in (4)
	
select * from ALEF_AKCIA where AA_NAME like '%ламбр%' and AA_isACTIVE  = 0

--создание акций на основе существующих
insert dbo.ALEF_AKCIA
select 45, 'Вина4, Регион (6+1)', '2019-05-20', '2019-08-01', '«Вина3, Регион (6+1)»', 1, AA_isPAYTYPE, AA_isSTOCKCHECK, AA_OVERALL, AA_MDCheck, AA_APCheck, AA_MAXQTY, AA_C1, AA_C2, AA_C3, 2012, 2017
from dbo.ALEF_AKCIA
where AA_ID = 7

SELECT * FROM dbo.ALEF_AKCIA aa WHERE aa.AA_isACTIVE = 0 ORDER BY aa.AA_DATE_TO
--delete from ALEF_AKCIA_SUBJECTS where AS_ID = 142 AND AS_CODES = 47054

--наполнение товарной части акций
--insert dbo.ALEF_AKCIA_OBJECTS
select 43,33422,1,0,0,1,0 union
select 43,33422,6,1,0,1,0 UNION
select 43,34731,1,0,0,2,0 union
select 43,34731,6,1,0,2,0 union
select 113,32144,50,0,0,3,0 union
select 113,32144,100,1,0,3,0 union

select 179,32292,1,0,0,4,0 union
select 179,32292,3,1,0,4,0 UNION
select 179,32293,1,0,0,5,0 union
select 179,32293,3,1,0,5,0


--подключение ТРТ к существующим акциям
exec Add_TRT_Insert_and_update7 12,70877,1, 0,'2018-02-04','2018-03-03'

select * from ALEF_AKCIA where AA_C1 = 50

select iidText, iName, iShortName from DS_ITEMS where iidText in ('31882','32292','31442','34065','31518','34064','31426','33239','33238','32028','32802','33523','31446') order by iShortName, iidText
ROLLBACK TRAN
