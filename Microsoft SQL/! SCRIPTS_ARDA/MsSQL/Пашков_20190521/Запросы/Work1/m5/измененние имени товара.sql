use otdata
update r_prods set
  r_prods.prodname = replace( r_prods.prodname, '����-�����', '�����')
from
  r_prods
where
  prodname like '%����-�����%'