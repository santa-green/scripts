BEGIN TRAN

DECLARE
--#region ��������� ���������
  @Status VARCHAR(250) = '������ ��', 
  @OldDCardID VARCHAR(250) = '2220000068963', 
  @NewDCardID VARCHAR(250) = '2220000456906', 
  @ClientName VARCHAR(200) = '�������� ����� �������', 
  @BirthDate SMALLDATETIME = '19831228', 
  @PhoneMob VARCHAR(20) = '963689368',
  @EMail VARCHAR(250) ='',
  @IsCrdCard VARCHAR(250) = '���',
  @FactCity VARCHAR(250) = NULL
--#endregion ��������� ���������

BEGIN
  
SET NOCOUNT ON 
SET XACT_ABORT ON

--#region ������������
/*
  EXEC ap_ChangeDCard '������ ��','2220000000796','2500000013928','������ ������ �������','19790530','676325326','','���'
  EXEC ap_ChangeDCard '������ ��','2220000278966','2220000260039','','','','','���'
  EXEC ap_ChangeDCard '������ ��','2220000000796','2500000013928','������ ������ �������','19790530','676325326','','���'
  EXEC ap_ChangeDCard '����� ������','','2220000000222','','','','','���','�����'
  EXEC ap_ChangeDCard '������ ��','2220000068963','2220000456906','�������� ����� �������','19831228','963689368','','���','�����'
*/
--#endregion ������������
  
--#region ���� ��������
  /* �������� ������������� ���������� ���� "������" */
  IF @Status NOT IN ('����� ������','������ ��')
  BEGIN 
    RAISERROR ('��������!!! �������� ���� "������" - [%s] ��� �� %s ������� �������! ������� ������ "����� ������" ��� "������ ��". ������ ������.', 18, 1, @Status, @NewDCardID)
    RETURN
  END
  
  /* �������� ������������ ���������� ���� "����. �����" */
  IF @IsCrdCard NOT IN ('��','���')
  BEGIN
    RAISERROR ('��������!!! �������� ���� "����. �����" - [%s] ��� �� %s ������� �������! ������ ������.', 18, 1, @IsCrdCard, @NewDCardID)
    RETURN
  END
  
  /* �������� ������������ ����� ������ ���������� ����� */
 IF NOT EXISTS (SELECT * FROM r_DCards WITH(NOLOCK) WHERE DCardID = @OldDCardID) AND @Status = '������ ��'
  BEGIN
    RAISERROR ('��������!!! ��� ������ �� ��������� ������! �� %s �� ����������. ������ ������.', 18, 1, @OldDCardID)
    RETURN
  END
  
  /* �������� ������������ ����� ����� ���������� ����� */
  IF NOT EXISTS (SELECT * FROM r_DCards WITH(NOLOCK) WHERE DCardID = @NewDCardID)
  BEGIN
    RAISERROR ('��������!!! ��� ������ �� ��������� ������! �� %s �� ����������. ������ ������.*', 18, 1, @NewDCardID)
    RETURN
  END 
  
  /* �������� �� ������� ������ ��. ���� ���� - ������ */
  IF EXISTS (SELECT * FROM ir_DCardsOld WHERE OldDCardID = @OldDCardID AND DCardID = @NewDCardID)
  BEGIN
    RAISERROR ('������ �� c %s �� %s ���� ��������� �����!', 18, 1, @OldDCardID, @NewDCardID)
    RETURN
  END
  
  /* �������� ������������ ����� ������ �� ������ �� */
  IF EXISTS (SELECT * FROM ir_DCardsOld WHERE OldDCardID = @NewDCardID)
  BEGIN
    RAISERROR ('��������!!! �� %s ��� ����������� � ������! ������ ������.', 18, 1, @NewDCardID)
    RETURN
  END    

  /* �������� ������������ ����� ������ �� ����� �� */
  IF EXISTS (SELECT * FROM ir_DCardsOld WHERE OldDCardID = @OldDCardID)
  BEGIN
    RAISERROR ('��������!!! �� %s ��� ����������� � ������! ������ ������.', 18, 1, @OldDCardID)
    RETURN
  END  
--#endregion ���� ��������
 
--#region ���������� ����������
 DECLARE @DCardChId bigint, @OldDCardChId bigint
 SELECT @DCardChId = ChID from r_DCards WHERE DCardID = @NewDCardID
 SELECT @DCardChId '@DCardChId'
 SELECT @OldDCardChId = ChID from r_DCards WHERE DCardID = @OldDCardID
 SELECT @OldDCardChId '@OldDCardChId'
--#endregion ���������� ����������
   
--#region ������ ��
    IF @Status = '������ ��'
    BEGIN
      BEGIN TRAN
      
      INSERT z_DocDC
      (DocCode,ChID,DCardChID)
      SELECT DocCode,ChID,@DCardChId 
      FROM z_DocDC dc WITH(NOLOCK)
      WHERE DCardChID = @OldDCardChId /*@DCardChId*/ AND NOT EXISTS (SELECT * FROM z_DocDC WHERE DocCode = dc.DocCode AND ChID = dc.ChID AND DCardChID = @DCardChId)

      SELECT * FROM z_DocDC WHERE DCardChID = @OldDCardChId /*@DCardChId*/
      --SELECT top(1000) * FROM z_LogDiscRec ORDER BY LogID DESC --z_LogDiscRec	����������� �������� - ���������� �������
      --SELECT top(1000) * FROM z_LogDiscRec ORDER BY LogDate DESC --z_LogDiscRec	����������� �������� - ���������� �������

--#region ������ ����� ���������� ������ � z_LogDiscRec
/*      select '������ ����� ���������� ������ � z_LogDiscRec' 
      DECLARE @LogID INT
      SELECT @LogID = MAX(LogID) 
      FROM z_LogDiscRec WITH(XLOCK) 
      JOIN r_DBIs ON 1=1 AND r_DBIs.DBiID = 1
      WHERE LogID BETWEEN ChID_Start AND ChID_End --pvm0 07,07,2017 ������������ ��������� �� LogID � ���� r_DBIs ChID_End ������ 99 999 999 ���� (9 999 999)
      SELECT @LogID
      
      --INSERT z_LogDiscRec
      --(LogID,DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID)
      SELECT ROW_NUMBER() OVER (ORDER BY LogID) + @LogID 'LogID', @NewDCardID 'DCardID', TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID, DBiID
      FROM z_LogDiscRec
      WHERE DCardChID /*���� DCardID*/ = @OldDCardChId /*���� @OldDCardID*/
      ORDER BY LogDate DESC*/

--#endregion ������ ����� ���������� ������ � z_LogDiscRec

SELECT LogID, DBiID FROM z_LogDiscRec WHERE DCardChID = @OldDCardChId

--#region CURSOR1
		--pvm0 2018-05-10 16.50 
		--����� �������� ������ ������ LogID ��� ������ ��
		DECLARE @LogID INT, @CUR_LogID INT, @CUR_DBiID INT
		DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
		FOR 
			SELECT /*top(10)*/ LogID, DBiID FROM z_LogDiscRec WHERE DCardChID = @OldDCardChId --205 ������� ~ 6 ��� (� rollback ~ 12 ���..).
      		
		OPEN CURSOR1
			FETCH NEXT FROM CURSOR1 INTO @CUR_LogID, @CUR_DBiID
		WHILE @@FETCH_STATUS = 0
		
        BEGIN
			--Script
			--����� ������ ����������� ��������� ����� ID
            --DECLARE @LogID INT
            SELECT  @LogID =  MIN(t1.LogID) + 1  FROM [z_LogDiscRec] as t1 
            --SELECT top(100)* FROM [z_LogDiscRec] WHERE LogID like '%-%'
            --SELECT  @LogID
			LEFT JOIN [z_LogDiscRec] AS diff ON (t1.LogID = diff.LogID - 1) 
			WHERE diff.LogID IS NULL AND t1.LogID BETWEEN (SELECT top 1 ChID_Start FROM r_DBIs WHERE DBiID = @CUR_DBiID) AND (SELECT top 1 ChID_End FROM r_DBIs WHERE DBiID = @CUR_DBiID)
			
			--���� �� ����� �� ����� ��������� �� ��������� ��� ���������� ����
			IF @LogID IS NULL SET @LogID = (SELECT TOP 1 ChID_Start FROM r_DBIs WHERE DBiID = @CUR_DBiID)

			--SELECT @LogID LogID	,@NewDCardID DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID
			--FROM z_LogDiscRec WHERE DCardID = @OldDCardID and DBiID = @CUR_DBiID and LogID = @CUR_LogID		

			INSERT z_LogDiscRec (LogID,DCardChID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID)
				SELECT @LogID LogID	,@DCardChId DCardID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID
				FROM z_LogDiscRec WHERE DCardChID = @OldDCardChId and DBiID = @CUR_DBiID and LogID = @CUR_LogID		
						
			--select @CUR_LogID, @CUR_DBiID
            FETCH NEXT FROM CURSOR1	INTO @CUR_LogID, @CUR_DBiID
		END;
		CLOSE CURSOR1
		DEALLOCATE CURSOR1   
--#endregion CURSOR1
      select 'LogID'; SELECT top(10)* FROM z_LogDiscRec ORDER BY LogID DESC
      DELETE z_DocDC WHERE DCardChID = @OldDCardChId
      select '��� ������ ���� �����'; SELECT * FROM z_DocDC WHERE DCardChID = @OldDCardChId

      UPDATE n
      SET 
        n.Discount = o.Discount, 
        n.SumCC = o.SumCC,
        n.Notes = o.Notes,
        n.Value1 = o.Value1,
        n.Value2 = o.Value2,
        n.Value3 = o.Value3,          
        n.IsCrdCard = CASE @IsCrdCard WHEN '��' THEN 1 WHEN '���' THEN 0 END,       
        n.Note1 = '������ � ' + @OldDCardID + '. ����/����� ������ - ' + CONVERT(VARCHAR(10),GETDATE(),104) + ' ' + CONVERT(VARCHAR(10),GETDATE(),108),            
        n.EDate = o.EDate,
       
        n.DCTypeCode = o.DCTypeCode,
        n.FactPostIndex = o.FactPostIndex,
        
        n.SumBonus = o.SumBonus,
        n.Status = o.Status
      FROM r_DCards n
      JOIN r_DCards o ON o.DCardID = @OldDCardID
      WHERE n.DCardID = @NewDCardID

      select 'UPDATE r_DCards'; SELECT * FROM r_DCards WHERE DCardID = @NewDCardID
    
IF NOT EXISTS (SELECT * FROM r_PersonDC WHERE DCardChID=@DCardChId)
 BEGIN
     DECLARE @Per int 
     SELECT @Per=  PersonID FROM r_PersonDC WHERE DCardChID=@OldDCardChId

     INSERT r_PersonDC (PersonID,DCardChID)
     values(@Per,@DCardChId)
 END; 

      select '���������� ������ ��'; SELECT * FROM r_Persons WHERE PersonID = 25015

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

      select '���������� ������ �����'; SELECT * FROM r_Persons WHERE PersonID = 25015

      UPDATE r_DCards
      SET 
       InUse = 0,
       Note1 = '������ �� ' + @NewDCardID + '. ����/����� ������ - ' + CONVERT(VARCHAR(10),GETDATE(),104) + ' ' + CONVERT(VARCHAR(10),GETDATE(),108)
      WHERE DCardID = @OldDCardID

      select '����� ������'; 
      select '������ �����'; SELECT * FROM r_DCards WHERE DCardID = @OldDCardID 
      select '����� �����'; SELECT * FROM r_DCards WHERE DCardID = @NewDCardID 
    
--#region r_DCardKin
/*!!!!!!!!! ����� ������� ��� !!!!!!!!!!!!!* ���� 3 ������� *kin*/
      --r_PersonKinLog --����� --r_PersonKinLog	����������� �����������: ���������� ������ - ����� �����
      --r_PersonKin --����� --r_PersonKin	���������� ������ - ����� �����
      --SELECT * FROM r_EmpKin ORDER BY EmpID DESC --r_EmpKin	���������� �������� - ����� ����� (�� ��� ��������..)
/*      INSERT r_DCardKin
      (DCardChID,SrcPosID,KinName,KinBirthDay,KinRels)
      SELECT
       @DCardChId ,SrcPosID,KinName,KinBirthDay,KinRels
      FROM r_DCardKin WITH(NOLOCK)
      WHERE @DCardChId = @OldDCardChId*/
      
--#endregion r_DCardKin
    
      INSERT ir_DCardsOld
      (DCardID, SrcPosID, OldDCardID, Notes)
      VALUES
      (@NewDCardID, 1, @OldDCardID, CONVERT(VARCHAR(10),GETDATE(),104) + ' ' + CONVERT(VARCHAR(10),GETDATE(),108))

SELECT * FROM z_LogDiscRec WHERE DCardChID = '100014998' ORDER BY LogID DESC
SELECT * FROM z_LogDiscRec WHERE DCardChID = '200023993' ORDER BY LogID DESC
    
      IF @@TRANCOUNT > 0
      BEGIN
        COMMIT
        RAISERROR ('������ �� c %s �� %s ��������� �������!', 18, 1, @OldDCardID, @NewDCardID)
      END  
      ELSE
      BEGIN  
        RAISERROR ('��������!!! ������ �� c %s �� %s ��������� � ��������. ������ ������.', 18, 1, @OldDCardID, @NewDCardID)
        ROLLBACK
      END;
    END;
--#endregion ������ ��


END;      


      
--ROLLBACK TRAN
COMMIT TRAN