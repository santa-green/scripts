select *
from r_comps
order by compid  

update r_comps 
set r_comps.codeID4 = _apcomps.codeid4
from _apcomps 
where r_comps.compid = _apcomps.compid 