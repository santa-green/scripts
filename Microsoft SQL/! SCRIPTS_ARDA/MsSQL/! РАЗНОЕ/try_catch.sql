begin tran
        DECLARE @err varchar(max)
        SELECT * FROM r_CompsAdd WHERE CompID = 66682 and CompAddID = 1
        update r_CompsAdd set glncode = '986423216950' WHERE CompID = 66682 and CompAddID = 1 --9864232169634
        SELECT * FROM r_CompsAdd WHERE CompID = 66682 and CompAddID = 1
        --DELETE FROM r_CompsAdd WHERE CompID = 66682 and CompAddID = 2
        select 2/0
        select @err = @@ERROR
IF @err <> 0 
    BEGIN 
        RAISERROR(8134, 10, 1, '--TEST--')
        SELECT @err 'ERROR'
        SELECT 'ROLLING BACK...'
        ROLLBACK 
    END;
ELSE BEGIN
    SELECT 'COMMITING...'
    COMMIT TRAN
    END;

SELECT @err 'ERROR'
SELECT XACT_STATE() 'XACT_STATE()'