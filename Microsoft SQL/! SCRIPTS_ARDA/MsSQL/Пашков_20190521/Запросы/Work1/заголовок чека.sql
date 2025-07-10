use otdata 
select * 
 into _test5
 from t_sale t
 where t.chid = 12 or t.chid = 11