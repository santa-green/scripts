use ElitCP1	
-- ���������� ����������� ����� ���� � s-sql-d4 � ElitCP1	
insert r_DCTypes
	select * from [s-sql-d4].elitr.dbo.r_DCTypes 
	where DCTypeCode not in (select DCTypeCode from r_DCTypes )