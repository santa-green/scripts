USE [master]
GO

DECLARE      @return_value int

EXEC   @return_value = [dbo].[a_KillDeadLocks]

SELECT 'Return Value' = @return_value

GO