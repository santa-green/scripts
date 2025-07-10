USE [ElitR]
GO
/****** Object:  StoredProcedure [dbo].[ap_ChangeDCard]    Script Date: 30.04.2021 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ap_ChangeDCard]

  @Status VARCHAR(250), 
  @OldDCardID VARCHAR(250), 
  @NewDCardID VARCHAR(250), 
  @ClientName VARCHAR(200), 
  @BirthDate SMALLDATETIME, 
  @PhoneMob VARCHAR(20),
  @EMail VARCHAR(250),
  @IsCrdCard VARCHAR(250) = 'Нет',
  @FactCity VARCHAR(250) = NULL

WITH RECOMPILE AS

BEGIN
  
SET NOCOUNT ON 
SET XACT_ABORT ON

--#region Тестирование
/*
  EXEC ap_ChangeDCard 'Замена ДК','2220000000796','2500000013928','Мунтян Оксана Павлівна','19790530','676325326','','Нет'
  EXEC ap_ChangeDCard 'Замена ДК','2220000278966','2220000260039','','','','','Нет'
  EXEC ap_ChangeDCard 'Замена ДК','2220000000796','2500000013928','Мунтян Оксана Павлівна','19790530','676325326','','Нет'
  EXEC ap_ChangeDCard 'Новый клиент','','2220000000222','','','','','Нет','ДНЕПР'
  EXEC ap_ChangeDCard 'Замена ДК','2220000068963','2220000456906','Романова Дарья Юрьевна','19831228','963689368','','Нет','ДНЕПР'
*/
--#endregion Тестирование
  
--#region Блок проверок
  /* Проверка каорректности заполнения поля "Статус" */
  IF @Status NOT IN ('Новый клиент','Замена ДК')
  BEGIN 
    RAISERROR ('ВНИМАНИЕ!!! Значение поля "Статус" - [%s] для ДК %s указано неверно! Укажите статус "Новый клиент" или "Замена ДК". Импорт отменён.', 18, 1, @Status, @NewDCardID)
    RETURN
  END
  
  /* Проверка корректности заполнения поля "Кред. лимит" */
  IF @IsCrdCard NOT IN ('Да','Нет')
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! Значение поля "Кред. лимит" - [%s] для ДК %s указано неверно! Импорт отменён.', 18, 1, @IsCrdCard, @NewDCardID)
    RETURN
  END
  
  /* Проверка корректности ввода старой дисконтной карты */
 IF NOT EXISTS (SELECT * FROM r_DCards WITH(NOLOCK) WHERE DCardID = @OldDCardID) AND @Status = 'Замена ДК'
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! При замене ДК произошла ошибка! ДК %s не существует. Импорт отменён.', 18, 1, @OldDCardID)
    RETURN
  END
  
  /* Проверка корректности ввода новой дисконтной карты */
  IF NOT EXISTS (SELECT * FROM r_DCards WITH(NOLOCK) WHERE DCardID = @NewDCardID)
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! При замене ДК произошла ошибка! ДК %s не существует. Импорт отменён.*', 18, 1, @NewDCardID)
    RETURN
  END 
  
  /* Проверка на предмет замены ДК. Если была - ошибка */
  IF EXISTS (SELECT * FROM ir_DCardsOld WHERE OldDCardID = @OldDCardID AND DCardID = @NewDCardID)
  BEGIN
    RAISERROR ('Замена ДК c %s на %s была оформлена ранее!', 18, 1, @OldDCardID, @NewDCardID)
    RETURN
  END
  
  /* Проверка корректности ввода данных по старой ДК */
  IF EXISTS (SELECT * FROM ir_DCardsOld WHERE OldDCardID = @NewDCardID)
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! ДК %s уже участвовала в замене! Импорт отменён.', 18, 1, @NewDCardID)
    RETURN
  END    

  /* Проверка корректности ввода данных по новой ДК */
  IF EXISTS (SELECT * FROM ir_DCardsOld WHERE OldDCardID = @OldDCardID)
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! ДК %s уже участвовала в замене! Импорт отменён.', 18, 1, @OldDCardID)
    RETURN
  END  
--#endregion Блок проверок
 
--#region Объявление переменных
 DECLARE @DCardChId bigint,@OldDCardChId bigint
 SELECT @DCardChId = ChID from r_DCards WHERE DCardID = @NewDCardID
 SELECT @DCardChId
 SELECT @OldDCardChId = ChID from r_DCards WHERE DCardID = @OldDCardID
--#endregion Объявление переменных

--#region Добавление информации о новом клиенте
 IF NOT EXISTS (SELECT * FROM r_PersonDC WHERE DCardChID=@DCardChId)
 BEGIN
 DECLARE @Pers int 
 SELECT @Pers=MAX(PersonID)+1 FROM r_Persons
  INSERT r_Persons 
 (ChID,PersonID,PersonName,Sex,State,Birthday,Phone,EMail,FactCity)
 SELECT (SELECT MAX(CHID)+1 FROM r_Persons),@Pers,
        @ClientName,0,0,@BirthDate,@PhoneMob,@EMail,@FactCity 

 INSERT r_PersonDC (PersonID,DCardChID)
 values(@Pers,@DCardChId)

 END; 
--#endregion Добавление информации о новом клиенте

--#region Обработка нового клиента
    IF @Status = 'Новый клиент'
    BEGIN
      BEGIN TRAN    

      IF EXISTS (SELECT * 
                 FROM r_DCards s WITH(NOLOCK)
				 JOIN r_PersonDC d WITH(NOLOCK) ON d.DCardChID=s.ChID 
				 JOIN r_Persons e WITH(NOLOCK) ON d.PersonID=e.PersonID
                 WHERE
                   DCardID = @NewDCardID AND ( 
                   ISNULL(e.PersonName,'') != ISNULL(@ClientName,'') OR
                   ISNULL(e.Birthday,'') != ISNULL(@BirthDate,'') OR
                   ISNULL(e.Phone,'') != ISNULL(@PhoneMob,'') OR
                   ISNULL(e.EMail,'') != ISNULL(@EMail,'') OR
                   IsCrdCard != CASE @IsCrdCard WHEN 'Да' THEN 1 WHEN 'Нет' THEN 0 END) OR
                   ISNULL(FactCity,'') != ISNULL(@FactCity,'') )
      BEGIN                   
        UPDATE e
        SET 
          e.PersonName = @ClientName,
          e.Birthday = @BirthDate,
         e.Phone= @PhoneMob,
          EMail = @EMail,
          FactCity = @FactCity
		  FROM r_DCards s WITH(NOLOCK)
				 JOIN r_PersonDC d WITH(NOLOCK) ON d.DCardChID=s.ChID 
				 JOIN r_Persons e WITH(NOLOCK) ON d.PersonID=e.PersonID
        WHERE DCardID = @NewDCardID

        IF  @@TRANCOUNT > 0
        BEGIN
          COMMIT
          RAISERROR ('Обновление данных по ДК %s выполнено успешно!', 18, 1, @NewDCardID)  
        END  
        ELSE
        BEGIN
          RAISERROR ('ВНИМАНИЕ!!! Обновление данных по ДК %s выполнено с ошибками. Импорт отменён.', 18, 1, @NewDCardID)  
          ROLLBACK      
          RETURN
        END
      END
      ELSE ROLLBACK   
    END
--#endregion Обработка нового клиента
    
--#region Замена ДК
    IF @Status = 'Замена ДК'
    BEGIN
      BEGIN TRAN
      
      INSERT z_DocDC
      (DocCode,ChID,DCardChID)
      SELECT DocCode,ChID,@DCardChId 
      FROM z_DocDC dc WITH(NOLOCK)
      WHERE DCardChID = @DCardChId AND NOT EXISTS (SELECT * FROM z_DocDC WHERE DocCode = dc.DocCode AND ChID = dc.ChID AND DCardChID = @DCardChId)

/* 
      DECLARE @LogID INT
      SELECT @LogID = MAX(LogID) 
      FROM z_LogDiscRec WITH(XLOCK) 
      JOIN r_DBIs ON 1=1 AND r_DBIs.DBiID = 1
      WHERE LogID BETWEEN ChID_Start AND ChID_End --pvm0 07,07,2017 переполнение диапазона по LogID в базе r_DBIs ChID_End сделал 99 999 999 было (9 999 999)
    
      INSERT z_LogDiscRec
      (LogID,DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID)
      SELECT ROW_NUMBER() OVER (ORDER BY LogID) + @LogID LogID,@NewDCardID DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID
      FROM z_LogDiscRec
      WHERE DCardID = @OldDCardID
*/
		--pvm0 2018-05-10 16.50 
		--Новый алгоритм поиска нового LogID при замене ДК
		DECLARE @LogID INT,@CUR_LogID INT, @CUR_DBiID INT
		DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
		FOR 
			SELECT LogID, DBiID FROM z_LogDiscRec WHERE DCardChID = @OldDCardChId 
      		
		OPEN CURSOR1
			FETCH NEXT FROM CURSOR1 INTO @CUR_LogID, @CUR_DBiID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--Script
			--Найти первый минимальный свободный номер ID
			SELECT  @LogID =  MIN(t1.LogID) + 1  FROM [z_LogDiscRec] as t1 
			LEFT JOIN [z_LogDiscRec] AS diff ON (t1.LogID = diff.LogID - 1) 
			WHERE diff.LogID IS NULL AND t1.LogID BETWEEN (SELECT top 1 ChID_Start FROM r_DBIs WHERE DBiID = @CUR_DBiID) AND (SELECT top 1 ChID_End FROM r_DBIs WHERE DBiID = @CUR_DBiID)
			
			--если не нашли то берем начальный из диапазона для конкретной базы
			IF @LogID IS NULL SET @LogID = (SELECT TOP 1 ChID_Start FROM r_DBIs WHERE DBiID = @CUR_DBiID)

			--SELECT @LogID LogID	,@NewDCardID DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID
			--FROM z_LogDiscRec WHERE DCardID = @OldDCardID and DBiID = @CUR_DBiID and LogID = @CUR_LogID		

			INSERT z_LogDiscRec (LogID,DCardChID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID)
				SELECT @LogID LogID	,@DCardChId DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID
				FROM z_LogDiscRec WHERE DCardChID = @OldDCardChId and DBiID = @CUR_DBiID and LogID = @CUR_LogID		
						
			FETCH NEXT FROM CURSOR1	INTO @CUR_LogID, @CUR_DBiID
		END
		CLOSE CURSOR1
		DEALLOCATE CURSOR1    
    

        
      DELETE z_DocDC WHERE DCardChID = @OldDCardChId

      UPDATE n
      SET 
        n.Discount = o.Discount, 
        n.SumCC = o.SumCC,
        n.Notes = o.Notes,
        n.Value1 = o.Value1,
        n.Value2 = o.Value2,
        n.Value3 = o.Value3,          
        n.IsCrdCard = CASE @IsCrdCard WHEN 'Да' THEN 1 WHEN 'Нет' THEN 0 END,       
        n.Note1 = 'Замена с ' + @OldDCardID + '. Дата/время замены - ' + CONVERT(VARCHAR(10),GETDATE(),104) + ' ' + CONVERT(VARCHAR(10),GETDATE(),108),            
        n.EDate = o.EDate,
       
        n.DCTypeCode = o.DCTypeCode,
        n.FactPostIndex = o.FactPostIndex,
        
        n.SumBonus = o.SumBonus,
        n.Status = o.Status
      FROM r_DCards n
      JOIN r_DCards o ON o.DCardID = @OldDCardID
      WHERE n.DCardID = @NewDCardID
    
IF NOT EXISTS (SELECT * FROM r_PersonDC WHERE DCardChID=@DCardChId)
 BEGIN
 DECLARE @Per int 
 SELECT @Per=  PersonID FROM r_PersonDC WHERE DCardChID=@OldDCardChId

 INSERT r_PersonDC (PersonID,DCardChID)
 values(@Per,@DCardChId)

 END 

	  UPDATE  e1
	  SET
	  e1.Birthday = @BirthDate,
        e1.FactRegion =  e.FactRegion,
        e1.FactDistrict = e.FactDistrict,
        e1.FactCity = e.FactCity,
        e1.FactStreet = e.FactStreet,
        e1.FactHouse = e.FactHouse,
        e1.FactBlock = e.FactBlock,
        e1.FactAptNo = e.FactAptNo,
		e1.Phone = @PhoneMob,
        e1.PhoneHome = e.PhoneHome,
        e1.PhoneWork = e.PhoneWork,
        e1.EMail = @EMail
	  FROM r_DCards n
      JOIN r_DCards o ON o.DCardID = @OldDCardID
	  JOIN r_PersonDC d WITH(NOLOCK) ON d.DCardChID=n.ChID 
	  JOIN r_Persons e WITH(NOLOCK) ON d.PersonID=e.PersonID
	  JOIN r_PersonDC d1 WITH(NOLOCK) ON d1.DCardChID=o.ChID 
	  JOIN r_Persons e1 WITH(NOLOCK) ON d1.PersonID=e1.PersonID
      WHERE n.DCardID = @NewDCardID

      UPDATE r_DCards
      SET 
       InUse = 0,
       Note1 = 'Замена на ' + @NewDCardID + '. Дата/время замены - ' + CONVERT(VARCHAR(10),GETDATE(),104) + ' ' + CONVERT(VARCHAR(10),GETDATE(),108)
      WHERE DCardID = @OldDCardID
    
--#region r_DCardKin
      INSERT r_DCardKin
      (DCardChID,SrcPosID,KinName,KinBirthDay,KinRels)
      SELECT
       @DCardChId ,SrcPosID,KinName,KinBirthDay,KinRels
      FROM r_DCardKin WITH(NOLOCK)
      WHERE @DCardChId = @OldDCardChId
--#endregion r_DCardKin
    
      INSERT ir_DCardsOld
      (DCardID, SrcPosID, OldDCardID, Notes)
      VALUES
      (@NewDCardID, 1, @OldDCardID, CONVERT(VARCHAR(10),GETDATE(),104) + ' ' + CONVERT(VARCHAR(10),GETDATE(),108))
    
      IF @@TRANCOUNT > 0
      BEGIN
        COMMIT
        RAISERROR ('Замена ДК c %s на %s проведена успешно!', 18, 1, @OldDCardID, @NewDCardID)
      END  
      ELSE
      BEGIN  
        RAISERROR ('ВНИМАНИЕ!!! Замена ДК c %s на %s выполнена с ошибками. Импорт отменён.', 18, 1, @OldDCardID, @NewDCardID)
        ROLLBACK
      END
    END
--#endregion Замена ДК

END;      
      


    













GO
