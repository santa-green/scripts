
SELECT база , count(база) кол_карт FROM (

SELECT '1 √лавна€ база данных' as 'база',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =1 )
and InUse = 1
union
SELECT '2 ¬интаж ƒнепр' as 'база',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =2 )
and InUse = 1
union
SELECT '3 ¬интаж  иев' as 'база',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =3 )
and InUse = 1
union
SELECT '4 ’арьков' as 'база',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =4 )
and InUse = 1
union
SELECT '5 нагорка ƒнепр' as 'база',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =5 )
and InUse = 1
union
SELECT '6 ¬интаж  ќдесса' as 'база',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =6 )
and InUse = 1
--order by 1,2
) a
group by база
order by 1

--SELECT distinct DCardID FROM z_LogDiscRec
--where LogDate > '2016-01-01' and DBiID =3 

--SELECT * FROM r_DBIs

SELECT top 100 * FROM z_LogDiscRec where DBiID = 5
order by LogDate desc