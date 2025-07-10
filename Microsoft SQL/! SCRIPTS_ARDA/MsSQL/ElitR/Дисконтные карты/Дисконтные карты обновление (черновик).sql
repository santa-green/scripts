USE ElitR
GO

SELECT * FROM z_LogDiscRec WHERE DCardChID = '2220000068963' 
SELECT top(10) * FROM z_LogDiscRec 
SELECT LogID, DBiID FROM z_LogDiscRec WHERE DCardChID = '2220000456906' 
SELECT * FROM z_LogDiscRec WHERE LogID = '20094429'
SELECT * FROM z_LogDiscRec WHERE LogID = '20094631'
SELECT * FROM z_LogDiscRec WHERE DBiID = 2 ORDER BY LogID DESC
SELECT top(10)* FROM z_LogDiscRec ORDER BY LogID DESC
SELECT * FROM z_LogDiscRec WHERE DCardChID = '100014998' ORDER BY LogID DESC
SELECT * FROM z_LogDiscRec WHERE DCardChID = '200023993' ORDER BY LogID DESC

SELECT * FROM r_DBIs
/*2*/  100000001 - 199999999
/*14*/ 1400000000 - 1499999999
select len(900000000)
select len(1100000000)

--Старая ДК 2220000068963
--Новая ДК 2220000456906

SELECT * FROM r_DCards WHERE DCardID = '2220000068963'; --r_DCards	Справочник дисконтных карт; --ChID 200008778
SELECT * FROM z_DocDC WHERE DCardChID = '100014998'; --z_DocDC	Документы - Дисконтные карты; --11035-Продажа товара оператором, 10400-Справочник дисконтных карт
SELECT * FROM r_PersonDC WHERE DCardChID = '100014998'; --r_PersonDC	Справочник персон - дисконтные карты; --WHERE ChID = '100003647' --WHERE Phone like '%0676339619%'--PersonName like '%никитенков%'
SELECT * FROM r_Persons WHERE PersonID = '25015'; --r_Persons	Справочник персон; --WHERE ChID = '100003647' --WHERE Phone like '%0676339619%'--PersonName like '%никитенков%'


SELECT * FROM r_DCards WHERE DCardID = '2220000456906'; --r_DCards	Справочник дисконтных карт; --ChID 200008778
SELECT * FROM z_DocDC WHERE DCardChID = '200023993'; --z_DocDC	Документы - Дисконтные карты; --11035-Продажа товара оператором, 10400-Справочник дисконтных карт
SELECT * FROM r_PersonDC WHERE DCardChID = '200023993'; --r_PersonDC	Справочник персон - дисконтные карты; --WHERE ChID = '100003647' --WHERE Phone like '%0676339619%'--PersonName like '%никитенков%'
SELECT * FROM r_Persons WHERE PersonID = '50429'; --r_Persons	Справочник персон; --WHERE ChID = '100003647' --WHERE Phone like '%0676339619%'--PersonName like '%никитенков%'

SELECT * FROM r_DCardKin --Invalid object name 'r_DCardKin'.
SELECT * FROM r_PersonKin --Таблица пустая.
SELECT * FROM r_PersonKinLog --Таблица пустая.
SELECT * FROM ir_DCardsOld ORDER BY Notes DESC
SELECT * FROM ir_DCardsOld WHERE DCardID = '2220000456906'

SELECT zd.dcardchid, rs.PersonID, rs.PersonName, rs.Phone, * FROM r_DCards rd --r_DCards	Справочник дисконтных карт
JOIN z_DocDC zd ON rd.ChID = zd.ChID --z_DocDC	Документы - Дисконтные карты
JOIN r_PersonDC rp ON rp.DCardChID = zd.ChID --r_PersonDC	Справочник персон - дисконтные карты
JOIN r_Persons rs ON rs.PersonID = rp.PersonID --r_Persons	Справочник персон
WHERE rd.DCardID = '2220000456906'

z_RelationError