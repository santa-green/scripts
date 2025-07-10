-- В базе магазина в табличку _bonusdc впихиваем номер ДК и сумму бонусов дельше тыкаем F5 

DECLARE Bonus CURSOR FOR
SELECT * FROM _bonusdc order by dcardid

OPEN Bonus
DECLARE @DCardID varchar(13), @chid int , @sum numeric (29,2)
FETCH NEXT FROM Bonus into @DCardID , @sum
WHILE @@Fetch_Status = 0
BEGIN
SELECT @chid = chid FROM r_DCards WHERE DCardID  = @DCardID
SELECT @chid , @DCardID , @sum 


IF NOT EXISTS(SELECT TOP 1 1 FROM z_DocDC WHERE DocCode = 10400 AND ChID =@chid AND DCardID = @DCardID)
INSERT INTO z_DocDC(DocCode, ChID, DCardID)
VALUES(10400, @chid, @DCardID)

INSERT INTO z_LogDiscRec(LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, LogDate, DBiID)
VALUES ((SELECT MAX (LogID)+1 FROM z_LogDiscRec), @DCardID, 0, 10400 , @chid , NULL, 0, @sum, GETDATE(),2)   -- ВНИМАНИЕ 2 ДНЕПР 3 КИЕВ!!!!
SELECT * FROM z_LogDiscRec WHERE DCardID = @DCardID
delete from _Bonusdc where DCardID = @DCardID
FETCH NEXT FROM Bonus INTO @DCardID , @sum

END

CLOSE Bonus
DEALLOCATE  Bonus

--TRUNCATE TABLE _bonusdc
