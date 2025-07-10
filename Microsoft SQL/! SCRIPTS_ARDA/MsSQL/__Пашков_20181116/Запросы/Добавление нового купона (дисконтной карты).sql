  declare @i int 
  set @i =100
  
  
  while @i > 0
  begin
     DECLARE @Dcard varchar(13)  , @Newchid int , @date date , @DCTypeCode int , @SumBonus  AS numeric(21, 2)
     	 SET @DCTypeCode = 14
     	 SET @SumBonus =100
     LABEL1:
     SET @Dcard = left (dbo.if_GetBarCode  (CHECKSUM(GETDATE())),13)
     IF EXISTS (SELECT * FROM r_DCards WHERE DCardID = @Dcard  )GOTO label1
	 SET @date = dbo.zf_GetDate (GETDATE ()+39) -- срок действия дисконтной карты
	 EXEC dbo.z_NewChID 'r_DCards', @Newchid OUTPUT
--	INSERT INTO  r_DCards 
        SELECT @Newchid ,1 ,@Dcard,0,0,1,'' Notes, 0 Value1, 0 Value2, 0 Value3, 0 IsCrdCard, '' Note1, @date EDate, '' ClientName, @DCTypeCode as DCTypeCode, 0 BirthDate, 0 FactRegion, 0 FactDistrict, '' FactCity, '' FactStreet, '' FactHouse, '' FactBlock,'' FactAptNo,'' FactPostIndex,'' PhoneMob,'' PhoneHome,''PhoneWork,'' EMail,@SumBonus as  SumBonus,0 Status, 0 IsPayCard
--INSERT z_DocDC
SELECT 11035 , 0 ,@Dcard
--INSERT z_LogDiscRec
SELECT MAX (LogID)+1,@Dcard,0,11035 DocCode,0,0,0,@SumBonus, dbo.zf_GetDate (GETDATE ())as LogDate,0 BonusType, 0 SaleSrcPosID, 2 DBiID
FROM z_LogDiscRec

set @i =@i-1
end

--  select   * from z_LogDiscRec where DCardID in  (select DCardID from r_DCards where DCTypeCode =14)order by LogID

select * from r_DCards where DCTypeCode =14 order by ChID


