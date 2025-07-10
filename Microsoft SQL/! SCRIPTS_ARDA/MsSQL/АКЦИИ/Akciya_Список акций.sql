USE Alef_Elit
GO

select DISTINCT
a.AA_ID AS Akciya,
a.AA_NAME AS Opisanie,
b.AS_CODES AS TRT,
c.AO_CODE AS 'Товар в Акции', -- если необходимо показать товар участвующий в акции
--c.AO_isASSORT AS 'Товар под списание', -- какой товар списывается при срабатывании акции
--d.iName AS Nazvanie, -- то же
a.AA_DATE_FROM AS 'Akc OT',
a.AA_DATE_TO 'Akc DO ',
b.AS_DATE_FROM 'TRT OT',
b.AS_DATE_TO 'TRT DO',
	case when a.AA_isPAYTYPE=1  then  'MIX' else 'n+1' end Type,
 --case when AA_isPAYTYPE=1  then  CAST( 'MIX' AS varchar(100)) else CAST ( 0 AS varchar(100)) end AA_isPAYTYPE ,
	case when a.AA_C1 = 50 and a.AA_C3 = 1 then 'КредитНота' else 'Расходы Проэкта' end Reklama,
a.AA_C4 AS 'Признак 4',
a.AA_C5 AS 'Признак 5',
	case when a.AA_isACTIVE=1 then 'Активная' else 'Отключена' end 'Статус акции'
		FROM ALEF_AKCIA a
		JOIN ALEF_AKCIA_SUBJECTS b ON a.AA_ID=b.AS_ID
		JOIN ALEF_AKCIA_OBJECTS c ON a.AA_ID=c.AO_ID
		--JOIN DS_ITEMS d ON c.AO_CODE=d.iidText  -- то же
		WHERE AA_isACTIVE in (1)
			--AND (b.AS_DATE_TO IS NULL)
			--AND (b.AS_DATE_FROM < '2018-11-30')
			AND (AS_DATE_TO > getdate() or AS_DATE_TO is null)
			--AND a.AA_ID IN (13)
			AND (AS_CODES in (66368,66310,66567,66208,66647,66351,66005))
			AND (AO_CODE IN (34048,24664,26133,32144))
		
