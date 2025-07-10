use ElitCP1	
-- добавление недостающих типов карт с s-sql-d4 в ElitCP1	
insert r_DCTypes
	select * from [s-sql-d4].elitr.dbo.r_DCTypes 
	where DCTypeCode not in (select DCTypeCode from r_DCTypes )