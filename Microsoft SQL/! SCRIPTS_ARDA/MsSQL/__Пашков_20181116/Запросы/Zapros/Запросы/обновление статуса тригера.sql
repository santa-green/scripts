
select * 
from Z_Objects 
where objname = 'tf_DiscCanEditQty'

update Z_Objects 
set Z_Objects.RevId = 1
from Z_Objects 
where objname = 'tf_DiscCanEditQty'
