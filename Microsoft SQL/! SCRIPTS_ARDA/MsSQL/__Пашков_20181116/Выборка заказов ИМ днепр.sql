SELECT  *
FROM OPENQUERY(VintageClub,
'SELECT 
ot.order_id as ot_order_id, ot.item_id, ot.storage_id, ot.count, ot.discount as ot_discount,
oi.id, oi.order_id, oi.unikod, oi.price, oi.discount, oi.discount_type, oi.num as oi_num, oi.info, oi.create_time as oi_create_time,
o.id as o_id, o.cart_id, o.status, o.imported, o.type_register, o.user_id, o.user_vip, o.name, o.phone, o.dos_sity, o.dos_type, o.dos_adr, o.dos_date, o.dos_time, o.dos_self, o.dos_com, o.payment, o.sum, o.dos, o.create_date, o.create_time, o.region, o.num, o.promo_kod, o.point_code, o.novaPoshtaType, o.novaPoshtaOtdel, o.tabDate,

u.id as u_id, u.type, u.id_vk, u.id_fb, u.vip, u.email, u.password, u.status as u_status, 
u.date_registration, u.date_last, 
u.name as u_name, 

u.phone as u_phone, 
u.town, 
u.sex, u.activationKod, u.regPass, 
u.discount_num,

u.remember, u.is_update, u.subscribe,
  
s.storage_id as s_storage_id, s.region_id, s.name as s_name, s.status as s_status, s.prio, s.work_time, s.work_day

FROM vintagemarket.order_tmp ot
JOIN vintagemarket.order_item oi on oi.order_Id = ot.order_Id and oi.unikod = ot.item_id
JOIN vintagemarket.order o ON o.Id = oi.Order_Id
LEFT JOIN vintagemarket.users u ON u.Id = o.user_id
JOIN vintagemarket.storage s ON s.storage_Id = ot.storage_id
WHERE o.Imported = 0 AND o.Region = 1 AND o.Id > 40000
  AND o.dos_Date >= o.create_Date
ORDER BY o.Id, oi.Id  
') vc 

 WHERE item_id = 600134

 ot_order_id in( 122281, 122844)
 and item_id = 600134