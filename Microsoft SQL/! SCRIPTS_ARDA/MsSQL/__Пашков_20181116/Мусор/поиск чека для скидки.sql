SELECT * FROM t_saletemp t
join t_saletempd d on d.ChID = t.ChID
where t.DocDate = '2017-04-07'
and t.CRID in (106) 
and t.DeskCode = 227

SELECT t.TRealSum TRealSum,* FROM t_sale t
join t_saled d on d.ChID = t.ChID
where t.DocDate = '2017-04-07'
and t.CRID in (104,106,108,159)
order by t.TRealSum

SELECT * FROM t_saletemp t
join t_saletempd d on d.ChID = t.ChID
where t.DocDate = '2017-04-07'
and t.CRID in (108)


SELECT * FROM t_saletemp t
join t_saletempd d on d.ChID = t.ChID
where t.DocDate = '2017-04-07'
and t.CRID in (106) 
and t.DeskCode = 227
order by SrcPosID


SELECT ProdID FROM t_saletempd
where ChID = 100203251
group by ProdID
having sum(Qty)>0

SELECT * FROM r_Prods where ProdID in (605156,605169,605174,606336,606722,606841,607186)

SELECT * FROM t_saletempd
where ChID = 100203251