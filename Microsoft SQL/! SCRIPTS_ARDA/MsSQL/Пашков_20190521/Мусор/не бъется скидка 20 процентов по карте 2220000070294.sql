--��� ���������� 300�, ����.


SELECT * FROM r_Prods --where PCatID = 210
--where PGrID = 50063
where ProdName like '%��� ��%'


SELECT * FROM r_Prods where ProdID in (605883,607157,607159)



SELECT * FROM r_Prods --where PCatID = 210
--where PGrID = 50063
--where ProdID = 605883
where ProdName like '%�������� ��%'

SELECT * FROM r_DCards 
where DCardID like '%2220000070294%'

--������ ������� �� ������� ������ ������ 20% �� ����� 2220000070294
SELECT * FROM r_Prods where PCatID in (210,202,220,211)
and PGrID1 <> 707 
and PGrID2 <> 40037 
and PGrID3 <> 100