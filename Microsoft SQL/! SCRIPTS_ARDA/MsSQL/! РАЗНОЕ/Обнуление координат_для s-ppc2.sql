use Alef_Elit2
go

--Обнуление координат для торговых
--база Alef_Elit2
select*from DS_ObjectsAttributes where AttrID in (360, 361) and attrtext like '1' and Activeflag=1
-- update DS_ObjectsAttributes set Activeflag=0, Changedate=GETDATE () where AttrID in (360, 361) and attrtext like '1' and Activeflag=1


