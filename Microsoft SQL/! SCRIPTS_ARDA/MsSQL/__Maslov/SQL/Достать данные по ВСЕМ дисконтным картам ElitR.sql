/*
SELECT rd.DCardID AS 'Номер карты', rps.PersonName AS 'ФИО', ISNULL(rps.Phone, 'Нет телефона') AS 'Телефон', ISNULL( CONVERT(VARCHAR, rps.Birthday, 104), 'Нет даты рождения') AS 'Дата рождения', ISNULL(rps.EMail, 'Нет Email') AS 'Email', ISNULL(rps.FactCity, 'Нет города') AS 'Город'
FROM r_DCards rd
JOIN r_PersonDC rpdc WITH(NOLOCK) ON rpdc.DCardChID = rd.ChID
JOIN r_Persons rps WITH(NOLOCK) ON rps.PersonID = rpdc.PersonID
*/

SELECT * FROM (
SELECT DISTINCT rps.PersonName AS 'ФИО', ISNULL(rps.Phone, 'Нет телефона') AS 'Телефон', ISNULL( CONVERT(VARCHAR, rps.Birthday, 104), 'Нет даты рождения') AS 'Дата рождения', ISNULL(rps.EMail, 'Нет Email') AS 'Email', ISNULL(rps.FactCity, 'Нет города') AS 'Город'
FROM r_DCards rd
JOIN r_PersonDC rpdc WITH(NOLOCK) ON rpdc.DCardChID = rd.ChID
JOIN r_Persons rps WITH(NOLOCK) ON rps.PersonID = rpdc.PersonID
) q
ORDER BY 5

