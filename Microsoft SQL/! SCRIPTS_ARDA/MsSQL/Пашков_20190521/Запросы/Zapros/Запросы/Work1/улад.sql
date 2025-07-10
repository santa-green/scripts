use otdata
delete 
from t_sale 
where t_sale.docdate  = CONVERT(DATETIME, '2005-05-08 00:00:00', 102)
