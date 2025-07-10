ALTER PROCEDURE [dbo].[ap_Check_OffCalcExpDebt] @GUID VARCHAR (MAX) = NULL
AS
BEGIN
/*
EXEC ap_Check_OffCalcExpDebt @GUID = '6707200F-570B-4175-BCF1-3F4F938C3033'
*/

/*
Процедура проверяет поставлено ли предприятие в исключение проверки дебиторской
задолженности.
*/
	IF @GUID = NULL
	BEGIN
		RETURN
	END;

	DECLARE @DocChID INT = (SELECT DocChID FROM at_WEB_Run_Script WHERE GUID = @GUID)
	DECLARE @CompID INT = (SELECT CompID FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @DocChID)
	DECLARE @CompName VARCHAR(250) = (SELECT CompName FROM r_Comps WITH (NOLOCK) WHERE CompID = @CompID)
	DECLARE @OurID INT = (SELECT OurID FROM at_t_IORes WITH (NOLOCK) WHERE ChID = @DocChID)
	DECLARE @Msg VARCHAR(4000) = ''

	SELECT @Msg = @Msg +
		   CASE WHEN CalcExpDebt = 1
				THEN '<p>Проверка триггера по дебиторской задолженности на предприятии</p><p>' + CAST(@CompID AS VARCHAR(20)) + ' - "' + @CompName + '"</p><p>Состояние: триггер по попросроченной ДЗ АКТИВЕН.</p>'
				ELSE '<p>Проверка триггера по дебиторской задолженности на предприятии</p><p>' + CAST(@CompID AS VARCHAR(20)) + ' - "' + @CompName + '"</p><p><b>Состояние: триггер по попросроченной ДЗ снят.</b></p>' END
	FROM dbo.at_r_CompOurTerms  
	WHERE OurID = @OurID AND CompID = @CompID
	
	UPDATE at_WEB_Run_Script SET MSG_True = @Msg WHERE GUID = @GUID
END;