select * from r_Currs where CurrID = 2

/*
ALTER TABLE dbo.r_Currs DISABLE TRIGGER TRel2_Upd_r_Currs
update r_Currs 
set CurrID = 980 
from r_Currs where CurrID = 2
ALTER TABLE dbo.r_Currs ENABLE TRIGGER TRel2_Upd_r_Currs
2900006012848
*/


SELECT * FROM r_ProdMP WHERE PLID = 70 and CurrID =  980 aND ProdID = 601284

ElitV_DP_TEST
update r_ProdMP 
set CurrID = 980
 FROM r_ProdMP WHERE PLID = 70 and CurrID =  2

select  * from z_Vars