--plpgsql.
begin;
	do 
	$$
	declare row_count int;
	begin
		delete from addressplacecustomerdetails where custom_id = 'Ejdnr';
		get diagnostics row_count = ROW_COUNT;
		raise notice 'Rows deleted: %', row_count;
	end;
	$$
	language plpgsql;
rollback;

--sql.
begin;
	with del_cte as (
		delete
		from
			addressplacecustomerdetails
		where
			custom_id = 'Ejdnr'
			returning *
			)
	select count(*) from del_cte;
rollback;

--deleted rows check.
begin;	
	select count(*) from addressplacecustomerdetails where custom_id = 'Ejdnr';
	delete from addressplacecustomerdetails where custom_id = 'Ejdnr' returning *;
	select count(*) from addressplacecustomerdetails where custom_id = 'Ejdnr';
rollback;