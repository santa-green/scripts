 --справочник товаров
SELECT * FROM OPENQUERY(VintageClub,
'SELECT unikod,status,admin,vip,img,img_big,name_ru,keywords_ru,description_ru,title_ru,category,note,tegs,map,color,type,country,region,subregion,year,manufacturer,classification,volume,sort,gastro,harakter,vid,upakovka,aromat,alkogol,recommend,indi,price_vip1,price_vip2,shippingWeight,discount,indi_min,event 
FROM shop_item') vc
where status = 'active'
ORDER BY unikod
 
 --Цены и остатки
SELECT * FROM OPENQUERY(VintageClub,
'SELECT * FROM vintagemarket.shop_item_price p
join vintagemarket.shop_item_balance b on b.item_id = p.unikod and b.region_id = p.region') vc
WHERE price <> 0 
and count <> 0
and storage_id in( 1,2)
--and unikod in (601070,600754,603936)
order by storage_id , unikod

--склады
SELECT   *
FROM OPENQUERY(VintageClub,
'SELECT * FROM vintagemarket.storage ') vc
--storage_id	region_id	name	status	prio	work_time	work_day
--1					1		Опт.	1		1	{"1":["09",10,11,12,13,14,15,16,17,18],"2":["09",10,11,12,13,14,15,16,17,18],"3":["09",10,11,12,13,14,15,16,17,18],"4":["09",10,11,12,13,14,15,16,17,18],"5":["09",10,11,12,13,14,15,16,17,18]}	[1,2,3,4,5]
--2					1		Розн.	1		2	{"1":["09",10,11,12,13,14,15,16,17,18],"2":["09",10,11,12,13,14,15,16,17,18],"3":["09",10,11,12,13,14,15,16,17,18],"4":["09",10,11,12,13,14,15,16,17,18],"5":["09",10,11,12,13,14,15,16,17,18]}	[1,2,3,4,5]
--3					2		Опт.	1		1	{"1":["09",10,11,12,13,14,15,16,17,18],"2":["09",10,11,12,13,14,15,16,17,18],"3":["09",10,11,12,13,14,15,16,17,18],"4":["09",10,11,12,13,14,15,16,17,18],"5":["09",10,11,12,13,14,15,16,17,18]}	[1,2,3,4,5]
--4					2		Розн.	1		2	[["09",10,11,12,13,14,15,16,17,18],["09",10,11,12,13,14,15,16,17,18],["09",10,11,12,13,14,15,16,17,18],["09",10,11,12,13,14,15,16,17,18],["09",10,11,12,13,14,15,16,17,18],["09",10,11,12,13,14,15,16,17,18],["09",10,11,12,13,14,15,16,17,18]]	[0,1,2,3,4,5,6]
--5					3		Опт.	1		1	{"2":["9",10,11,12,13,14,15,16,17,18],"3":["9",10,11,12,13,14,15,16,17,18],"4":["9",10,11,12,13,14,15,16,17,18],"5":["9",10,11,12,13,14,15,16,17,18]}	[2,3,4,5]
--6					3		Розн.	1		2	{"2":["9",10,11,12,13,14,15,16,17,18,19,20,21,22],"3":["9",10,11,12,13,14,15,16,17,18,19,20,21,22],"4":["9",10,11,12,13,14,15,16,17,18,19,20,21,22],"5":["9",10,11,12,13,14,15,16,17,18,19,20,21,22]}	[2,3,4,5]
--7					5		Опт.	1		1	{"2":["09",10,11,12,13,14,15,16,17,18],"3":["09",10,11,12,13,14,15,16,17,18],"4":["09",10,11,12,13,14,15,16,17,18],"5":["09",10,11,12,13,14,15,16,17,18]}	[2,3,4,5]
--8					5		Розн.	1		2	{"2":["9",10,11,12,13,14,15,16,17,18,19,20,21,22],"3":["9",10,11,12,13,14,15,16,17,18,19,20,21,22],"4":["9",10,11,12,13,14,15,16,17,18,19,20,21,22],"5":["9",10,11,12,13,14,15,16,17,18,19,20,21,22]}	[2,3,4,5]

--Цены
SELECT   *
FROM OPENQUERY(VintageClub,
'SELECT * FROM vintagemarket.shop_item_price ') vc
WHERE unikod = 600063
order by 1 desc 

--остатки
SELECT   *
FROM OPENQUERY(VintageClub,
'SELECT * FROM vintagemarket.shop_item_balance ') vc
WHERE  storage_id = 2 and count <> 0 --item_id = 802391
order by 4 desc 


FROM vintagemarket.order_tmp ot
JOIN vintagemarket.order_item oi on oi.order_Id = ot.order_Id and oi.unikod = ot.item_id
JOIN vintagemarket.order o ON o.Id = oi.Order_Id
LEFT JOIN vintagemarket.users u ON u.Id = o.user_id
JOIN vintagemarket.storage s ON s.storage_Id = ot.storage_id


order by 2 desc

 WHERE item_id = 802391

 ot_order_id in( 122281, 122844)
 and item_id = 600134

SELECT *, GETDATE() FROM OPENQUERY(VintageClub,'SELECT NOW() ') vc

--EXEC ap_VC_ExportProds
 
SELECT   *
FROM OPENQUERY(VintageClub,
'SELECT id,cart_id,status,imported,type_register,user_id,user_vip,name,phone,dos_sity,dos_type,dos_adr,
cast(dos_date as datetime),dos_time,dos_self,dos_com,payment,sum,dos,
cast(create_date as datetime),create_time,region,num,promo_kod,point_code,novaPoshtaType,novaPoshtaOtdel,tabDate
 FROM vintagemarket.order ') vc
WHERE id = 158849

SELECT * FROM OPENQUERY(VintageClub,
'SHOW CREATE TABLE vintagemarket.order ') vc

SELECT * FROM OPENQUERY(VintageClub,
'SHOW COLUMNS FROM vintagemarket.order ') vc
--enum('rezerv','new','active','shipped','return','blocked','dummy','imported')

SELECT   *
FROM OPENQUERY(VintageClub,
'SELECT id,DATE_FORMAT(create_date,''%d.%m.%Y %T''), cast(create_date as datetime)
 FROM vintagemarket.order ') vc
WHERE id = 156144


--
SELECT   *
FROM OPENQUERY(VintageClub,
'SELECT * FROM vintagemarket.order_tmp ') vc
WHERE order_id = 156144

SELECT   *
FROM OPENQUERY(VintageClub,
'SELECT * FROM vintagemarket.order_item ') vc
WHERE order_id = 156144


SELECT distinct * FROM OPENQUERY(VintageClub,
'SELECT distinct id,i.order_id,unikod,price,i.discount,discount_type,num,info,create_time,  t.order_id as order_id_t,item_id,storage_id,count,t.discount as discount_t FROM vintagemarket.order_item i, vintagemarket.order_tmp t where i.order_id = t.order_id and i.unikod = t.item_id 
') vc
WHERE order_id in (156144)
ORDER BY 2


SELECT  * FROM OPENQUERY(VintageClub,
'SELECT distinct id,i.order_id,unikod,price,i.discount,discount_type,num,info,create_time,  t.order_id as order_id_t,item_id,storage_id,count,t.discount as discount_t FROM vintagemarket.order_item i, vintagemarket.order_tmp t where i.order_id = t.order_id and i.unikod = t.item_id 
and num <> count') vc
ORDER BY 2

SELECT distinct * FROM OPENQUERY(VintageClub,
'SELECT distinct i.order_id FROM vintagemarket.order_item i, vintagemarket.order_tmp t where i.order_id = t.order_id and i.unikod = t.item_id 
and num <> count') vc 
ORDER BY 1



SELECT   *
FROM OPENQUERY(VintageClub,
'SELECT name, email, regpass FROM vintagemarket.users ') vc
ORDER BY 2



SELECT * FROM OPENQUERY(VintageClub,
'SHOW DATABASES') vc

SELECT * FROM OPENQUERY(VintageClub,
'SHOW STATUS') vc

SELECT * FROM OPENQUERY(VintageClub,
'SHOW FULL PROCESSLIST') vc

SELECT * FROM OPENQUERY(VintageClub,
'SHOW TABLES') vc

SELECT * FROM OPENQUERY(VintageClub,
'SHOW TABLE STATUS') vc

SELECT * FROM OPENQUERY(VintageClub,
'SHOW VARIABLES') vc



SELECT * FROM OPENQUERY(VintageClub,
'SHOW CREATE TABLE shop_item') vc

SELECT * FROM OPENQUERY(VintageClub,
'SHOW COLUMNS FROM shop_item') vc


SELECT * FROM OPENQUERY(VintageClub,
'SHOW CREATE TABLE vintagemarket.order') vc

SELECT * FROM OPENQUERY(VintageClub,
'SHOW COLUMNS FROM vintagemarket.order') vc



--600386 802451
SELECT vc.unikod, vc.name_ru, p.ProdName,p.UAProdName, * FROM OPENQUERY(VintageClub,
'SELECT unikod,status,admin,vip,name_ru,keywords_ru,description_ru,title_ru,category,note,
tegs,map,color,type,country,region,subregion,year,manufacturer,classification,volume,sort,
gastro,harakter,vid,upakovka,aromat,alkogol,recommend,indi,price_vip1,price_vip2,shippingWeight,
discount,indi_min,event FROM shop_item') vc
join ElitR.dbo.r_Prods p on p.ProdID = vc.unikod
where vc.name_ru <> p.ProdName and status = 'active'
and p.ProdID = 600386


SELECT * FROM ElitR.dbo.r_Prods where ProdID =600386

SELECT * FROM ElitR.dbo.r_Prods where ProdName like '%Карта Бланка%'

SELECT * FROM ElitR.dbo.t_Rem where ProdID = 600386
and OurID = 6 --and StockID in ()

SELECT * FROM ElitR.dbo.t_Rem where ProdID = 802451
and OurID = 6 --and StockID in ()

SELECT * FROM ElitR.dbo.r_ProdMP where ProdID =600386

SELECT * FROM ElitR.dbo.r_ProdMP where ProdID =802451

SELECT distinct ProdID FROM ElitR.dbo.r_ProdMP where PLID in (28,40,45,48) 
and PriceMC > 0


SELECT vc.unikod, vc.name_ru, p.ProdID, p.ProdName,p.UAProdName, * FROM OPENQUERY(VintageClub,
'SELECT unikod,status,admin,vip,name_ru,keywords_ru,description_ru,title_ru,category,note,
tegs,map,color,type,country,region,subregion,year,manufacturer,classification,volume,sort,
gastro,harakter,vid,upakovka,aromat,alkogol,recommend,indi,price_vip1,price_vip2,shippingWeight,
discount,indi_min,event FROM shop_item') vc
right join  ElitR.dbo.r_Prods p on p.ProdID = vc.unikod 
where p.ProdID in (  
  SELECT distinct rp.ProdID
  FROM ElitR.dbo.r_Prods rp WITH(NOLOCK)
  JOIN ElitR.dbo.ir_AMStocks ams WITH(NOLOCK) ON ams.StockID IN (1200,1201,1252,1241,723)
  LEFT JOIN ElitR.dbo.ir_AMD amd WITH(NOLOCK) ON amd.AMID = ams.AMID AND amd.ProdID = rp.ProdID 
  join ElitR.dbo.r_ProdMP mp on mp.ProdID = rp.ProdID and mp.PLID in (28,40,45,48)
  JOIN ElitR.dbo.t_Rem tr WITH(NOLOCK) ON tr.ProdID = rp.ProdID AND tr.OurID = 6 AND tr.StockID = ams.StockID
)
and p.PGrID1 IN (SELECT AValue FROM ElitR.dbo.zf_FilterToTable('200-207,209-399,401-501'))
and vc.unikod is null



SELECT * FROM OPENQUERY(VintageClub,
'SHOW COLUMNS FROM discount') vc

SELECT top 10 * FROM r_DCards

SELECT vc.*, dc.DCardID, dc.Discount, dc.ClientName FROM OPENQUERY(VintageClub,
'SELECT * FROM vintagemarket.discount ') vc
join r_DCards dc on dc.DCardID = cast(vc.discount_num as varchar) --ORDER BY discount_num
--where vc.discount != dc.Discount


--список товаров на сайте
SELECT  * FROM OPENQUERY(VintageClub,
'SELECT unikod,status,admin,vip,name_ru,keywords_ru,description_ru,title_ru,category,note,
tegs,map,color,type,country,region,subregion,year,manufacturer,classification,volume,sort,
gastro,harakter,vid,upakovka,aromat,alkogol,recommend,indi,price_vip1,price_vip2,shippingWeight,
discount,indi_min,event FROM shop_item') vc


SELECT  * FROM OPENQUERY(VintageClub,
'SELECT  * FROM vintagemarket.online_user_url ') vc
ORDER BY 4 desc


SELECT unikod Уникальный_идентификатор, unikod Код_товара, name_ru, harakter, 'r', 'UAH',	'шт.',	'+',	'http://vintagemarket.com.ua' + img
,cast((SELECT SUM(Qty-AccQty) tqty FROM t_Rem r where r.ProdID = vc.unikod) as int) tqty
,isnull((SELECT top 1 PriceMC FROM r_ProdMP mp where mp.PriceMC > 0 and mp.PLID = 28 and mp.ProdID = vc.unikod),0) Price 
,isnull((SELECT top 1 cast(cast((1-PromoPriceCC/PriceMC)*100 as int) as varchar) + '%'  FROM r_ProdMP mp where mp.PriceMC > 0 and mp.PLID = 28 and cast(GETDATE() as date) between mp.BDate and mp.EDate and mp.ProdID = vc.unikod),'') promo 
FROM OPENQUERY(VintageClub,
'SELECT unikod,status,admin,vip,img,img_big,name_ru,keywords_ru,description_ru,title_ru,category,note,tegs,map,color,type,country,region,subregion,year,manufacturer,classification,volume,sort,gastro,harakter,vid,upakovka,aromat,alkogol,recommend,indi,price_vip1,price_vip2,shippingWeight,discount,indi_min,event 
FROM shop_item') vc
where status = 'active'
and unikod > 600000
and (SELECT SUM(Qty-AccQty) tqty FROM t_Rem r where r.ProdID = vc.unikod) > 1
and isnull((SELECT top 1 PriceMC FROM r_ProdMP mp where mp.PriceMC > 0 and mp.PLID = 28 and mp.ProdID = vc.unikod),0) > 0
ORDER BY unikod


/*  --обновление статуса заказа
  DECLARE @UpdStr NVARCHAR(MAX) = '' 
 
  SELECT @UpdStr =
'UPDATE vintagemarket.order 
SET status = ''return''
WHERE id = 158849;
 FROM OPENQUERY(VintageClub,
SELECT HIGH_PRIORITY status 
FROM vintagemarket.order
WHERE id = 158849) vc)'
  
  --IF LEN(@UpdStr) > 0 
  select @UpdStr
  
  EXEC (@UpdStr) AT [VintageClub]  
  
*/
  
select * from  OPENQUERY ([VintageClub], 'SELECT HIGH_PRIORITY status FROM vintagemarket.order WHERE id = 158849') 


--enum('rezerv','new','active','shipped','return','blocked','dummy','imported')

--обновление статуса заказа  
  EXEC ('UPDATE vintagemarket.order 
SET status = ''new''
WHERE id = 158849;
 FROM OPENQUERY(VintageClub,
SELECT HIGH_PRIORITY status 
FROM vintagemarket.order
WHERE id = 158849) vc)') AT [VintageClub]  


/*
UPDATE OPENQUERY ([VintageClub], 'SELECT HIGH_PRIORITY status FROM vintagemarket.order WHERE id = 158849')
SET status = 'rezerv'

*/