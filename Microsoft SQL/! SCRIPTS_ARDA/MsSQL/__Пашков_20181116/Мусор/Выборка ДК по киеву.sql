
SELECT ���� , count(����) ���_���� FROM (

SELECT '1 ������� ���� ������' as '����',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =1 )
and InUse = 1
union
SELECT '2 ������ �����' as '����',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =2 )
and InUse = 1
union
SELECT '3 ������ ����' as '����',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =3 )
and InUse = 1
union
SELECT '4 �������' as '����',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =4 )
and InUse = 1
union
SELECT '5 ������� �����' as '����',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =5 )
and InUse = 1
union
SELECT '6 ������  ������' as '����',DCardID, Discount, ClientName, DCTypeCode, BirthDate, PhoneMob, EMail, SumBonus FROM r_DCards where DCardID in (SELECT distinct DCardID FROM z_LogDiscRec
where LogDate > '2016-01-01' and DBiID =6 )
and InUse = 1
--order by 1,2
) a
group by ����
order by 1

--SELECT distinct DCardID FROM z_LogDiscRec
--where LogDate > '2016-01-01' and DBiID =3 

--SELECT * FROM r_DBIs

SELECT top 100 * FROM z_LogDiscRec where DBiID = 5
order by LogDate desc