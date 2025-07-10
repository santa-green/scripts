USE ELIT_TEST
GO
alter FUNCTION dbo.af_double_num (@num int = 5)
RETURNS int
as 
begin
    begin try
        set @num *= 2;
    end try
    begin catch
        PRINT 'ERROR'
    end catch

    RETURN(@num);
end;

select dbo.af_double_num(5)
drop function af_double_num

--    begin try
--        SELECT 1
--        SELECT 5 + '3F3'
--            RAISERROR ('Error raised in TRY block.', -- Message text.  
--               16, -- Severity.  
--               1 -- State.  
--               ); 
--    end try
--    begin catch
--        DECLARE @ErrorMessage NVARCHAR(4000);  
--    DECLARE @ErrorSeverity INT;  
--    DECLARE @ErrorState INT;  
  
--    SELECT   
--        @ErrorMessage = ERROR_MESSAGE(),  
--        @ErrorSeverity = ERROR_SEVERITY(),  
--        @ErrorState = ERROR_STATE();  
--        SELECT ERROR_NUMBER() 'ERROR_NUMBER'
--        , ERROR_SEVERITY() 'ERROR_SEVERITY'
--        , ERROR_STATE() 'ERROR_STATE'
--        , ERROR_PROCEDURE() 'ERROR_PROCEDURE'
--        , ERROR_LINE() 'ERROR_LINE'
--        , ERROR_MESSAGE() 'ERROR_MESSAGE'
--            RAISERROR (@ErrorMessage, -- Message text.  
--               @ErrorSeverity, -- Severity.  
--               @ErrorState -- State.  
--               );  
--    end catch


--    BEGIN TRY  
--    -- RAISERROR with severity 11-19 will cause execution to   
--    -- jump to the CATCH block.  
--    RAISERROR ('Error raised in TRY block.', -- Message text.  
--               16, -- Severity.  
--               1 -- State.  
--               );  
--END TRY  
--BEGIN CATCH  
--    DECLARE @ErrorMessage NVARCHAR(4000);  
--    DECLARE @ErrorSeverity INT;  
--    DECLARE @ErrorState INT;  
  
--    SELECT   
--        @ErrorMessage = ERROR_MESSAGE(),  
--        @ErrorSeverity = ERROR_SEVERITY(),  
--        @ErrorState = ERROR_STATE();  
  
--    -- Use RAISERROR inside the CATCH block to return error  
--    -- information about the original error that caused  
--    -- execution to jump to the CATCH block.  
--    RAISERROR (@ErrorMessage, -- Message text.  
--               @ErrorSeverity, -- Severity.  
--               @ErrorState -- State.  
--               );  
--END CATCH;


--DECLARE @StringVariable NVARCHAR(50);  
--SET @StringVariable = N'<\<%7.3s>>';  
  
--RAISERROR (@StringVariable, -- Message text.  
--           10, -- Severity,  
--           1, -- State,  
--           N'abcde'); -- First argument supplies the string.  
---- The message text returned is: <<    abc>>.  
--GO

--getdate()

create function dbo.af_getprodname(@prodid int)
returns table
as
return(
select prodid, ProdName, Notes from r_prods WHERE ProdID = @prodid
)

SELECT * FROM dbo.af_getprodname(52)


alter function dbo.af_getprodname2(@prodid int)
returns table
as
return(
select top(3) prodid, ProdName, Notes, ProdID * 100 '100' from r_prods WHERE ProdID = @prodid
)
go

SELECT * FROM dbo.af_getprodname2(2)

SELECT * FROM dbo.af_getprodname2() afg 
JOIN r_prods rp ON rp.ProdID = afg.prodid


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*multi-statement*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--drop FUNCTION dbo.af_double_num_multi (@prodid int)
create FUNCTION dbo.af_double_num_multi (@prodid int)
RETURNS @table TABLE (prodid int, ProdName varchar(200), Notes varchar(200), CstProdCode varchar(250))
--WITH SCHEMABINDING
as 
begin
    INSERT INTO @table
    select prodid, ProdName, Notes, ISNULL(m.CstProdCode, '-') from dbo.r_prods m WHERE ProdID = @prodid
    RETURN
end;
GO

SELECT * FROM dbo.af_double_num_multi(4556)
SELECT NULLIF(3, 3)

SELECT CAST(ISNULL(ProdID, '-') AS INT) FROM r_Prods
SELECT ISNULL(ProdID, '-') FROM r_Prods
alter table dbo.r_prods alter column notes int
alter table dbo.r_prods add notes_2 int not null default ''
alter table dbo.r_prods alter column notes_2 int
alter table dbo.r_prods drop constraint DF__r_Prods__notes_2__6682C4C5

alter table dbo.r_prods drop column notes_2
sp_help 'r_prods'
SELECT COALESCE(NULL, 5, 3, 4, 0, NULL)


select count('count it, man!') from r_Prods --26895
select count(Country) from r_Prods --21184
select count(distinct Country) from r_Prods --1508

select count(Country) from r_Prods WHERE ProdID > 1000
select count(CASE WHEN ProdID > 1000 THEN Country END) from r_Prods 