BEGIN TRY                      

EXEC ap_ChangeDCard
  @Status = :Status,
  @OldDCardID = :OldDCardID,
  @NewDCardID = :NewDCardID,
  @ClientName = :ClientName,
  @BirthDate = :BirthDate,
  @PhoneMob = :PhoneMob,
  @EMail = :EMail,
  @FactCity = :FactCity      

SELECT NULL                           

END TRY

BEGIN CATCH
  SELECT CAST(ERROR_MESSAGE() AS VARCHAR(250))
END CATCH  
