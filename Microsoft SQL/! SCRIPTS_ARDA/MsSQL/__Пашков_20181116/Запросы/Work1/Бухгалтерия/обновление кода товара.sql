

ALTER TABLE 	dbo.r_prods 	DISABLE TRIGGER TU_r_Prods
ALTER TABLE 	dbo.t_recD 	DISABLE TRIGGER TRU_t_RecD
ALTER TABLE 	dbo.t_PInP 	DISABLE TRIGGER TU_t_PInP
ALTER TABLE 	dbo.t_SaleD 	DISABLE TRIGGER TRU_t_SaleD
ALTER TABLE 	dbo.t_VenA 	DISABLE TRIGGER TU_t_VenA
ALTER TABLE 	dbo.t_VenD 	DISABLE TRIGGER TRU_t_VenD
ALTER TABLE 	dbo.t_zInP 	DISABLE TRIGGER TRU_t_zInP


	update r_prods-- справочник товаров 
		set prodid = 100111
		from r_prods  where prodid = 100


/*select *
from r_prods_r
where prodid = 100
*/
	update r_prods_r-- справочник товаров зеркало
		set prodid = 100111
		from r_prods_r  where prodid = 100





/*select *
from t_pinp 
where prodid = 100
*/


	update t_pinp  --цены прихода
		set prodid = 100111
		from t_pinp  where prodid = 100



/*select *
from t_recD
where prodid = 100
*/

	update t_recD -- приход 
		set prodid = 100111
		from t_recD where prodid = 100

/*select *
from t_saleD
where prodid =100
*/
	update t_saleD -- продажа 
	set prodid = 100111
	from t_saleD where prodid = 100


/*select *
from t_venA
where prodid =100111

	update t_venA -- инвентаризация
	set prodid = 100111
	from t_venA  where prodid = 100
*/
/*select *
from t_venD
where DetProdID =100
*/
	update t_venD -- инвентаризация расчет
	set DetProdID = 100111
	from t_venD  where DetProdID = 100

/*select *
from t_zInP
where prodid = 100
*/
	update t_zInP-- входящие остатки
	set ProdID = 100111
	from t_zInP where ProdID = 100



/*
select *
from t_rem
where prodid = 100111
*/
	update t_rem -- входящие остатки
	set ProdID = 100111
	from t_rem where ProdID = 100


/*select *
from t_CRRetD 
where prodid = 100
*/
	update t_CRRetD  -- возврат в магазин
		set prodid = 100111
		from t_CRRetD  where prodid = 100





ALTER TABLE 	dbo.r_prods 	ENABLE TRIGGER TU_r_Prods
ALTER TABLE 	dbo.t_recD 	ENABLE TRIGGER TRU_t_RecD
ALTER TABLE 	dbo.t_PInP 	ENABLE TRIGGER TU_t_PInP
ALTER TABLE 	dbo.t_SaleD 	ENABLE TRIGGER TRU_t_SaleD
ALTER TABLE 	dbo.t_VenA 	ENABLE TRIGGER TU_t_VenA
ALTER TABLE 	dbo.t_VenD 	ENABLE TRIGGER TRU_t_VenD
ALTER TABLE 	dbo.t_zInP 	ENABLE TRIGGER TRU_t_zInP

