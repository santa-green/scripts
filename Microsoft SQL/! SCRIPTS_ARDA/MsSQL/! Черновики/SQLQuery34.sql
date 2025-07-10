alter trigger at_rCompsAdd_CompGrId2_IU ON r_CompsAdd
FOR INSERT, UPDATE -- {FOR | AFTER | INSTEAD OF} => {INSERT | UPDATE | DELETE}
as
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ADDED] rkv0 '2020-12-01 18:22' добавил триггер на тестовой базе.

IF UPDATE(CompGrID2)
    IF EXISTS (SELECT * FROM inserted WHERE CompGrID2 = 0)
    begin
          RAISERROR('[at_rCompsAdd_CompGrId2_IU] Обязательно должна быть указана группа предприятий 2!', 18, 1) --Severity, State.
              --Severity levels from 0 through 18 can be specified by any user. Severity levels from 19 through 25 can only be specified by members of the sysadmin fixed server role or users with ALTER TRACE permissions. For severity levels from 19 through 25, the WITH LOG option is required. Severity levels less than 0 are interpreted as 0. Severity levels greater than 25 are interpreted as 25.
              --Severity levels from 20 through 25 are considered fatal. If a fatal severity level is encountered, the client connection is terminated after receiving the message, and the error is logged in the error and application logs.
              --state Is an integer from 0 through 255. Negative values default to 1. Values larger than 255 should not be used.
              --https://docs.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-error-severities?view=sql-server-ver15
              --17-19 	Indicate software errors that cannot be corrected by the user. Inform your system administrator of the problem.
		  ROLLBACK
		  RETURN
    end;