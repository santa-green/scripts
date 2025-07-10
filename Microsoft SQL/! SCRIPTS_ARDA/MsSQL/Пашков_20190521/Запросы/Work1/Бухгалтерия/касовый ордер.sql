create procedure bux
as
	update b_cExp
	set b_cExp.comptxt = r.CompName
	from b_cExp b inner join r_comps r on b.compID = r.compID 
	where b.comptxt like '1'
