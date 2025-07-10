USE [Elit_TEST]
GO
/****** Object:  Trigger [dbo].[at_rCompsAdd_CheckValues_IU]    Script Date: 01.12.2020 16:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[at_rCompsAdd_CheckValues_IU] ON [dbo].[r_CompsAdd]
FOR INSERT,UPDATE
AS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Pashkov '2019-10-03 22:34:53.613' добавил запрет на ввод  непечатываемых символов
--[CHANGED] Maslov Oleg '2020-08-13 16:52:56.529' По заявке от Танцюры (№ 42116). Пользователи не могли менять адрес доставки, если он не участвует в товарных документах.
--[ADDED] Maslov Oleg '2020-08-13 17:11:39.911' По договоренности с Танцюрой. Только указанные пользователи могут менять поле "Адрес предпр.".
--[ADDED] Maslov Oleg '2020-08-27 15:26:23.944' ##RE-42608## Добавил pvi5 в исключение проверки.
--[ADDED] Maslov Oleg '2020-10-05 14:46:42.391' ##RE-1121## Добавил пользователя 'yaa6' (Юпик Анну Анатольевну (код сл. 7217)) в исключения.
--[ADDED] rkv0 '2020-12-01 18:22' добавил запрет на ввод нулевого значения в поле CompGrID2.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[ADDED] rkv0 '2020-12-01 18:22' добавил запрет на ввод нулевого значения в поле CompGrID2.
IF UPDATE(CompGrID2)
    IF EXISTS (SELECT * FROM inserted WHERE CompGrID2 = 0)
    begin
          RAISERROR('Обязательно должна быть указана "Группа предприятий 2" ! [at_rCompsAdd_CompGrId2_IU]', 18, 1) --Severity, State.
              --Severity levels from 0 through 18 can be specified by any user. Severity levels from 19 through 25 can only be specified by members of the sysadmin fixed server role or users with ALTER TRACE permissions. For severity levels from 19 through 25, the WITH LOG option is required. Severity levels less than 0 are interpreted as 0. Severity levels greater than 25 are interpreted as 25.
              --Severity levels from 20 through 25 are considered fatal. If a fatal severity level is encountered, the client connection is terminated after receiving the message, and the error is logged in the error and application logs.
              --state Is an integer from 0 through 255. Negative values default to 1. Values larger than 255 should not be used.
              --https://docs.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-error-severities?view=sql-server-ver15
              --17-19 	Indicate software errors that cannot be corrected by the user. Inform your system administrator of the problem.
		  ROLLBACK
		  RETURN
    end;
/*
IF UPDATE(GLNCode)
  IF EXISTS(SELECT * FROM inserted WHERE DATALENGTH(GLNCode) > 0)  
    IF EXISTS(SELECT * FROM inserted WHERE DATALENGTH(GLNCode) > 0 AND GLNCode NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
    BEGIN
      RAISERROR('ВНИМАНИЕ!!! Недопустимый формат данных в поле "Номер GLN"! Сохранение невозможно.', 18, 1)
      ROLLBACK
      RETURN
    END
*/
/*IF UPDATE(CompAddCharID)
  IF EXISTS(SELECT * FROM inserted WHERE CompAddCharID = 0)
  BEGIN
    RAISERROR('ВНИМАНИЕ!!! Для данного кода ТРТ не установлена характеристика. Сохранение невозможно.', 18, 1)
    ROLLBACK
    RETURN
  END */

--[ADDED] Maslov Oleg '2020-08-27 15:26:23.944' ##RE-42608## Добавил pvi5 в исключение проверки.
--[ADDED] Maslov Oleg '2020-08-13 17:11:39.911' По договоренности с Танцюрой. Только указанные пользователи могут менять поле "Адрес предпр.".
IF UPDATE(CompAdd)
	--[ADDED] Maslov Oleg '2020-10-05 14:46:42.391' ##RE-1121## Добавил пользователя 'yaa6' (Юпик Анну Анатольевну (код сл. 7217)) в исключения.
	IF SUSER_SNAME() NOT IN ('corp\rumyantsev'/*test*/,  'gnv','ptv','aav2','ntg','goy','mim2','moa6','ntg2','sas13','kiv24','zua','hia3','pnv5','arv','bla3','dya5','pvv4','sev28','kgv5','bag3','pvi5','yaa6')
	BEGIN
		  RAISERROR('[at_rCompsAdd_CheckValues_IU] ВНИМАНИЕ!!! Запрещено менять поле "Адрес предпр."! Сохранение невозможно.', 18, 1)
		  ROLLBACK
		  RETURN
	END;

--Pashkov '2019-10-03 22:34:53.613' добавил запрет на ввод  непечатываемых символов
  IF UPDATE(CompAdd)
	  IF EXISTS (SELECT top 1 1 FROM inserted where  CompAdd like '%['
				+char(1)+char(2)+char(3)+char(4)+char(5)+char(6)+char(7)+char(8)+char(9)+char(10)
				+char(11)+char(12)+char(13)+char(14)+char(15)+char(16)+char(17)+char(18)+char(19)+char(20)
				+char(21)+char(22)+char(23)+char(24)+char(25)+char(26)+char(27)+char(28)+char(29)+char(30)+char(31)
				+char(160)
				+']%' ESCAPE '|')
		BEGIN
			DECLARE @msg_error as nvarchar(max) =''
			SET @msg_error = (
								SELECT top 1
								REPLACE(CompAdd, char(13) + char(10), ' ') + ' ОШИБКА ' +
								CASE 
								WHEN PATINDEX('%'+char(13) + char(10)+'%', CompAdd) > 0 THEN 'перевод строки'  +' позиция '+cast(PATINDEX('%'+ char(13) + char(10) + '%', CompAdd) as nvarchar(10))    
								WHEN PATINDEX('%'+char(160) + '%', CompAdd) > 0 THEN 'неразрывный пробел'   +' позиция '+cast(PATINDEX('%'+char(160) + '%', CompAdd) as nvarchar(10))   
								WHEN PATINDEX('%'+char(1) + '%', CompAdd) > 0 THEN 'char(1)'  +' позиция '+cast(PATINDEX('%'+char(1) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(2) + '%', CompAdd) > 0 THEN 'char(2)'  +' позиция '+cast(PATINDEX('%'+char(2) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(3) + '%', CompAdd) > 0 THEN 'char(3)'  +' позиция '+cast(PATINDEX('%'+char(3) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(4) + '%', CompAdd) > 0 THEN 'char(4)'  +' позиция '+cast(PATINDEX('%'+char(4) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(5) + '%', CompAdd) > 0 THEN 'char(5)'  +' позиция '+cast(PATINDEX('%'+char(5) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(6) + '%', CompAdd) > 0 THEN 'char(6)'  +' позиция '+cast(PATINDEX('%'+char(6) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(7) + '%', CompAdd) > 0 THEN 'char(7)'  +' позиция '+cast(PATINDEX('%'+char(7) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(8) + '%', CompAdd) > 0 THEN 'char(8)'  +' позиция '+cast(PATINDEX('%'+char(8) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(9) + '%', CompAdd) > 0 THEN 'char(9)'  +' позиция '+cast(PATINDEX('%'+char(9) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(10) + '%', CompAdd) > 0 THEN 'char(10)'  +' позиция '+cast(PATINDEX('%'+char(10) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(11) + '%', CompAdd) > 0 THEN 'char(11)'  +' позиция '+cast(PATINDEX('%'+char(11) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(12) + '%', CompAdd) > 0 THEN 'char(12)'  +' позиция '+cast(PATINDEX('%'+char(12) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(13) + '%', CompAdd) > 0 THEN 'char(13)'  +' позиция '+cast(PATINDEX('%'+char(13) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(14) + '%', CompAdd) > 0 THEN 'char(14)'  +' позиция '+cast(PATINDEX('%'+char(14) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(15) + '%', CompAdd) > 0 THEN 'char(15)'  +' позиция '+cast(PATINDEX('%'+char(15) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(16) + '%', CompAdd) > 0 THEN 'char(16)'  +' позиция '+cast(PATINDEX('%'+char(16) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(17) + '%', CompAdd) > 0 THEN 'char(17)'  +' позиция '+cast(PATINDEX('%'+char(17) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(18) + '%', CompAdd) > 0 THEN 'char(18)'  +' позиция '+cast(PATINDEX('%'+char(18) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(19) + '%', CompAdd) > 0 THEN 'char(19)'  +' позиция '+cast(PATINDEX('%'+char(19) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(20) + '%', CompAdd) > 0 THEN 'char(20)'  +' позиция '+cast(PATINDEX('%'+char(20) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(21) + '%', CompAdd) > 0 THEN 'char(21)'  +' позиция '+cast(PATINDEX('%'+char(21) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(22) + '%', CompAdd) > 0 THEN 'char(22)'  +' позиция '+cast(PATINDEX('%'+char(22) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(23) + '%', CompAdd) > 0 THEN 'char(23)'  +' позиция '+cast(PATINDEX('%'+char(23) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(24) + '%', CompAdd) > 0 THEN 'char(24)'  +' позиция '+cast(PATINDEX('%'+char(24) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(25) + '%', CompAdd) > 0 THEN 'char(25)'  +' позиция '+cast(PATINDEX('%'+char(25) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(26) + '%', CompAdd) > 0 THEN 'char(26)'  +' позиция '+cast(PATINDEX('%'+char(26) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(27) + '%', CompAdd) > 0 THEN 'char(27)'  +' позиция '+cast(PATINDEX('%'+char(27) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(28) + '%', CompAdd) > 0 THEN 'char(28)'  +' позиция '+cast(PATINDEX('%'+char(28) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(29) + '%', CompAdd) > 0 THEN 'char(29)'  +' позиция '+cast(PATINDEX('%'+char(29) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(30) + '%', CompAdd) > 0 THEN 'char(30)'  +' позиция '+cast(PATINDEX('%'+char(30) + '%', CompAdd) as nvarchar(10)) 
								WHEN PATINDEX('%'+char(31) + '%', CompAdd) > 0 THEN 'char(31)'  +' позиция '+cast(PATINDEX('%'+char(31) + '%', CompAdd) as nvarchar(10)) 
								else 'ошибка не определена'
								END 
								--+ ' hex: '+ cast(sys.fn_varbintohexstr(cast(CompAdd as varbinary(250))) as varchar(500) ) ошибка             
								FROM r_CompsAdd ec 
								where  CompAdd like '%['
								+char(1)+char(2)+char(3)+char(4)+char(5)+char(6)+char(7)+char(8)+char(9)+char(10)
								+char(11)+char(12)+char(13)+char(14)+char(15)+char(16)+char(17)+char(18)+char(19)+char(20)
								+char(21)+char(22)+char(23)+char(24)+char(25)+char(26)+char(27)+char(28)+char(29)+char(30)+char(31)
								+']%' ESCAPE '|'
								)
			RAISERROR('[at_rCompsAdd_CheckValues_IU] ВНИМАНИЕ!!! В адресе запрещенный символ. Адрес: %s', 18, 1,@msg_error)  
			IF @@TranCount > 0 Rollback Transaction
			RETURN
		END
  
  IF UPDATE(CompAdd)
    IF SUSER_SNAME() in ('giv3','dmv2','pvm0')
    BEGIN
      UPDATE a SET a.Address =  i.CompAdd FROM t_Inv a, deleted d, inserted i WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID AND i.CompID = d.CompID AND i.CompAddID = d.CompAddID
      UPDATE a SET a.Address =  i.CompAdd FROM t_Ret a, deleted d, inserted i WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID AND i.CompID = d.CompID AND i.CompAddID = d.CompAddID
      UPDATE a SET a.Address =  i.CompAdd FROM t_Exp a, deleted d, inserted i WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID AND i.CompID = d.CompID AND i.CompAddID = d.CompAddID
      UPDATE a SET a.Address =  i.CompAdd FROM t_Acc a, deleted d, inserted i WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID AND i.CompID = d.CompID AND i.CompAddID = d.CompAddID
      UPDATE a SET a.Address =  i.CompAdd FROM t_IORec a, deleted d, inserted i WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID AND i.CompID = d.CompID AND i.CompAddID = d.CompAddID
      UPDATE a SET a.Address =  i.CompAdd FROM t_IOExp a, deleted d, inserted i WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID AND i.CompID = d.CompID AND i.CompAddID = d.CompAddID
      UPDATE a SET a.Address =  i.CompAdd FROM at_t_IORes a, deleted d, inserted i WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID AND i.CompID = d.CompID AND i.CompAddID = d.CompAddID
	  UPDATE a SET a.Address =  i.CompAdd FROM at_z_CommCredit a, deleted d, inserted i WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID AND i.CompID = d.CompID AND i.CompAddID = d.CompAddID
	  UPDATE a SET a.Address =  i.CompAdd FROM at_t_PRet a, deleted d, inserted i WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID AND i.CompID = d.CompID AND i.CompAddID = d.CompAddID
    END

/* r_CompsAdd ^ t_Inv - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ Расходная накладная: Заголовок - Проверка в CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd)  IF EXISTS (SELECT * FROM t_Inv a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ( 'giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 't_Inv', 2
      RETURN
    END

/* r_CompsAdd ^ t_Ret - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ Возврат товара от получателя: Заголовок - Проверка в CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd) IF EXISTS (SELECT * FROM t_Ret a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ( 'giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 't_Ret', 2
      RETURN
    END    

    /* r_CompsAdd ^ t_Exp - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ t_Exp - Проверка в CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd)  IF EXISTS (SELECT * FROM t_Exp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ('giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 't_Exp', 2
      RETURN
    END

/* r_CompsAdd ^ t_Acc - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ t_Acc - Проверка в CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd) IF EXISTS (SELECT * FROM t_Acc a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ( 'giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 't_Acc', 2
      RETURN
    END

/* r_CompsAdd ^ t_IORec - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ t_IORec - Проверка в CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd)  IF EXISTS (SELECT * FROM t_IORec a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ('giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 't_IORec', 2
      RETURN
    END

/* r_CompsAdd ^ t_IOExp - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ t_IOExp - Проверка в CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd) IF EXISTS (SELECT * FROM t_IOExp a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ( 'giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 't_IOExp', 2
      RETURN
    END

/* r_CompsAdd ^ at_t_IORes - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ at_t_IORes - Проверка в CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd) IF EXISTS (SELECT * FROM at_t_IORes a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ( 'giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 'at_t_IORes', 2
      RETURN
    END

/* r_CompsAdd ^ at_z_ContractsAdd - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ at_z_ContractsAdd - Проверка в CHILD */
  --[CHANGED] Maslov Oleg '2020-08-13 16:52:56.529' По заявке от Танцюры (№ 42116). Пользователи не могли менять адрес доставки, если он не участвует в товарных документах.
  --IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd)  IF EXISTS (SELECT * FROM at_z_ContractsAdd a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
  IF UPDATE(CompID) OR UPDATE(CompAddID) IF EXISTS (SELECT * FROM at_z_ContractsAdd a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ( 'giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 'at_z_ContractsAdd', 2
      RETURN
    END

/* r_CompsAdd ^ at_z_CommCredit - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ Товарный кредит: Заголовок - Проверка в CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd) IF EXISTS (SELECT * FROM at_z_CommCredit a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ( 'giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 'at_z_CommCredit', 2
      RETURN
    END    

    /* r_CompsAdd ^ at_t_PRet - Проверка в CHILD */
/* Справочник предприятий - Адреса ^ Возврат товара - проект: Заголовок - Проверка в CHILD */
  IF UPDATE(CompID) OR UPDATE(CompAddID) OR UPDATE(CompAdd)  IF EXISTS (SELECT * FROM at_t_PRet a WITH(NOLOCK), deleted d WHERE a.CompID = d.CompID AND a.CompAddID = d.CompAddID)
      IF SUSER_SNAME() NOT IN ( 'giv3','dmv2', 'kvi1', 'cev','pvm0')
    BEGIN
      EXEC z_RelationError 'r_CompsAdd', 'at_t_PRet', 2
      RETURN
    END




GO
