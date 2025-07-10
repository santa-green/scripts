--DISABLE TRIGGER TEST_LOG_IU ON R_compsAdd
alter TRIGGER test_log_IU
    ON [dbo].[r_compsAdd]
    INSTEAD OF UPDATE
    AS
    BEGIN
    SET NOCOUNT ON
    IF UPDATE(GLNCode)
    IF EXISTS (SELECT TOP 1 1 FROM inserted WHERE CompGrID2 = 0)
        begin
            RAISERROR('я теб€ запомнил! ƒанное действие было залогировано. [at_rCompsAdd_CheckValues_IU]', 16, 1)
            ROLLBACK
            INSERT INTO test_log (log_control, Notes) VALUES(GETDATE(), (SELECT GLNCODE from inserted))
            RETURN
        end
    END
    
/*
SELECT * FROM test_log ORDER BY id DESC
truncate table test_log
dbcc checkident('test_log', reseed, 1)
alter table test_log add Notes varchar(250)
*/ 