USE Elit_test
GO
--xact abort on
SET XACT_ABORT OFF
DECLARE @XACT_ABORT VARCHAR(3) = 'OFF';
IF ( (16384 & @@OPTIONS) = 16384 ) SET @XACT_ABORT = 'ON';
SELECT @XACT_ABORT AS XACT_ABORT;

BEGIN TRAN
    SELECT * FROM r_CompsAdd WHERE CompID = 66682 and CompAddID = 1
    update r_CompsAdd set glncode = '986423216955' WHERE CompID = 66682 and CompAddID = 1 --9864232169634
    SELECT * FROM r_CompsAdd WHERE CompID = 66682 and CompAddID = 1
    --DELETE FROM r_CompsAdd WHERE CompID = 66682 and CompAddID = 2
    select 2/0
COMMIT TRAN

--TRY...CATCH
BEGIN TRY
    BEGIN TRAN
        SELECT * FROM r_CompsAdd WHERE CompID = 66682 and CompAddID in (1, 2)
        update r_CompsAdd set glncode = '98642321555' WHERE CompID = 66682 and CompAddID = 1 
        select 2/0
        --DELETE FROM r_CompsAdd WHERE CompID = 66682 and CompAddID = 2
        update r_CompsAdd set glncode = '98642321666' WHERE CompID = 66682 and CompAddID = 2
        SELECT 'committing...'
    COMMIT TRAN
END TRY
BEGIN CATCH
    SELECT 'rolling back...'
    --ROLLBACK TRAN
END CATCH
