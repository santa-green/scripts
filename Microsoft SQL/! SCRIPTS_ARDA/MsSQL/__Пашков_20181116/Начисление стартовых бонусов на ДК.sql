BEGIN TRAN

--SET NOCOUNT ON
--SET NOCOUNT OFF
DECLARE 
@CARDCODE BIGINT,
@LogID int , --номер регистрации логов
@DBiID int = 1 --номер базы данных

DECLARE @ChIDTable table(ChID bigint NULL) 
INSERT INTO @ChIDTable 
	SELECT DCardID FROM r_DCards where ISNUMERIC(Notes) = 1 AND cast(Notes as bigint) between 35500 and 35999 ORDER BY Notes

SELECT * FROM @ChIDTable

SELECT * FROM z_LogDiscRec WHERE  ISNUMERIC(DCardID) = 1 AND CAST(DCardID as bigint) in (SELECT * FROM @ChIDTable)
SELECT * FROM z_DocDC WHERE  ISNUMERIC(DCardID) = 1 AND CAST(DCardID as bigint) in (SELECT * FROM @ChIDTable)

--select @Mchid = MAX (chid)+1 from it_Spec
--select @Mchid as Mchid

--select * from it_Spec 
--where OurID = @OurID and ChID in ( SELECT * FROM @ChIDTable)
	
DECLARE kalc CURSOR FOR
SELECT * FROM @ChIDTable

OPEN kalc
FETCH NEXT FROM kalc INTO @CARDCODE 
WHILE @@FETCH_STATUS = 0    		 
BEGIN  

	IF NOT EXISTS (SELECT * FROM dbo.z_DocDC WITH(NOLOCK) WHERE DocCode = 11035 AND ChID = 0 AND DCardID = @CARDCODE)
		INSERT dbo.z_DocDC (DocCode, ChID, DCardID) VALUES (11035, 0, @CARDCODE) 
		
	SELECT @LogID = MAX(LogID) + 1 FROM dbo.z_LogDiscRec WHERE DBiID = @DBiID
	
	--для отладки
	--SELECT @LogID
	
	INSERT dbo.z_LogDiscRec
		(LogID, DCardID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, logdate ,BonusType, DBiID)
		VALUES 
		(@LogID, @CARDCODE, 0, 11035, 0, 1, 0,  2000, GETDATE(), 0, @DBiID)

	FETCH NEXT FROM kalc INTO @CARDCODE 
END
CLOSE kalc
DEALLOCATE kalc


SELECT * FROM z_LogDiscRec WHERE  ISNUMERIC(DCardID) = 1 AND CAST(DCardID as bigint) in (SELECT * FROM @ChIDTable)
SELECT * FROM z_DocDC WHERE  ISNUMERIC(DCardID) = 1 AND CAST(DCardID as bigint) in (SELECT * FROM @ChIDTable)
SELECT * FROM r_DCards WHERE  ISNUMERIC(DCardID) = 1 AND CAST(DCardID as bigint) in (SELECT * FROM @ChIDTable)

--для отладки
SELECT d.DCardID, max(d.SumBonus) DCSumBonus, max(d.Discount) DCDiscount, ISNULL(SUM(l.SumBonus),0) LogSumBonus, dbo.af_GetDiscountFromSumBonus(ISNULL(SUM(l.SumBonus),0)) Скидка 
FROM r_DCards d
left join z_LogDiscRec l on l.DCardID = d.DCardID
where d.InUse = 1 
and d.DCTypeCode = 2 /* Накопичувальна*/
group by d.DCardID
having max(d.SumBonus) <> ISNULL(SUM(l.SumBonus),0) or max(d.Discount) <> dbo.af_GetDiscountFromSumBonus(ISNULL(SUM(l.SumBonus),0))
ORDER BY 1

ROLLBACK TRAN

/*

UPDATE r_DCards 
SET Note1 = 'В связи с проведением промо мероприятия начисленно 2000 грн бонусов для скидки 5 (2018-06-04)'
where ISNUMERIC(Notes) = 1 AND cast(Notes as bigint) between 35500 and 35999 

SELECT * FROM r_DCards where ISNUMERIC(Notes) = 1 AND cast(Notes as bigint) between 35500 and 35999 
ORDER BY Notes
*/