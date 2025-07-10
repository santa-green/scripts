select * from t_sale where ChID in (select ChID from test_t_sale)
except

insert [ElitV_DP_Denis_TEST].[dbo].t_sale
	select * from t_sale where ChID  in ( select ChID from test_t_sale )
	

insert [ElitV_DP_Denis_TEST].[dbo].r_Desks
	select * from r_Desks where ChID  not in ( select ChID from [ElitV_DP_Denis_TEST].[dbo].r_Desks )



insert [ElitV_DP_Denis_TEST].[dbo].r_DeskG
	select * from r_DeskG where ChID  not in ( select ChID from [ElitV_DP_Denis_TEST].[dbo].r_DeskG )
	
	
insert [ElitV_DP_Denis_TEST].[dbo].t_PInP
	select * from t_PInP where ProdID = 605143 and PPID = 366
	
	
	Сообщение 50000, уровень 18, состояние 1, процедура TRel1_Ins_t_Rem, строка 41
ВНИМАНИЕ!!! В t_PInP отсутствует товар 605143, Партия 366! Действие отменено.