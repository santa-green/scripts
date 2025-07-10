--заливка Справочников компьютеров
SELECT * FROM dbo.r_PCs;

DISABLE TRIGGER ALL ON r_PCs; delete r_PCs;ENABLE  TRIGGER ALL ON r_PCs;
insert r_PCs
	SELECT * FROM [s-sql-d4].elitr.dbo.r_PCs



--заливка Справочников  базы данных
SELECT * FROM r_DBIs

DISABLE TRIGGER ALL ON r_DBIs; delete r_DBIs;ENABLE  TRIGGER ALL ON r_DBIs;
insert r_DBIs
	SELECT * FROM [s-sql-d4].elitr.dbo.r_DBIs