--#region ДОБАВЛЕНИЕ ИНФО НА САЙТ ПЕРЕБРОСОВ
IF OBJECT_ID('tempdb..#new_edin_network', 'U') IS NOT NULL DROP TABLE #new_edin_network
CREATE TABLE #new_edin_network (
    new_user nvarchar(30),
    new_user_short nvarchar(30),
    empid int,
    compid int,
    new_network nvarchar(30)
)
SELECT * FROM #new_edin_network

BEGIN
    DECLARE @new_user varchar(100) = 'Быстров'
    SELECT empid, EmpName FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%')
    DECLARE @new_user_short varchar(100)
    select @new_user_short = REVERSE(SUBSTRING(LTRIM(reverse(empname)), CHARINDEX(' ', LTRIM(reverse(empname))) + 1, 100))
    FROM [s-sql-d4].[elit].dbo.r_emps
    WHERE empname like ('%' + @new_user + '%')
    select @new_user_short 'Для таблицы'
    INSERT INTO #new_edin_network (new_user_short) VALUES (@new_user_short)
END;

--SELECT * FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%')
SELECT * FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%') and empid = 6053

DECLARE @new_network varchar(100) = 'ИВЗО'

SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.Alef_EDI_EMPS WHERE EEA_EMP_NAME like ('%' + @new_user + '%')
SELECT * FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompName like ('%' + @new_network + '%')
DECLARE @compid varchar(max) = 72195
SELECT CodeID2, * FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompID IN (@compid)

SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.alef_edi_SETI_EMPS WHERE ESE_SETI_NAME like ('%' + @new_network + '%')--ESE_SETI_EMP_ID = 7077
--SELECT * FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompName like '%гведеон%'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHECKPOINT 2021-08-19 14:22:37*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--добавляем нового пользователя на сайт перебросов
IF 1 = 0
--IF 1 = 1
BEGIN
    --BEGIN TRAN
        INSERT INTO [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_EMPS (EEA_EMP_ID, EEA_EMP_NAME, EEA_EMP_PSWD, EEA_EMP_IMG, EEA_EMP_READONLY) VALUES(
            --(SELECT empid FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%')),
            (SELECT empid FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%') and empid = 3467),
            @new_user_short,
            1,
            'img/male.png',
            NULL);
    SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_EMPS WHERE EEA_EMP_NAME like ('%' + @new_user + '%');
    --ROLLBACK TRAN
    --COMMIT TRAN
END;
--добавляем связку пользователь-сеть.
IF 1 = 0
--IF 1 = 1
BEGIN
    BEGIN TRAN
        INSERT INTO ALEF_EDI_SETI_EMPS (ESE_SETI_ID, ESE_SETI_NAME, ESE_SETI_LOGO, ESE_SETI_EMP_ID) VALUES(
            (SELECT CodeID2 FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompID IN (@compid)),
            @new_network,
            'Два шага.jpg', --здесь меняем название файла. --обновить картинку здесь на s-ppc - c:\inetpub\wwwroot\edi\img\
            (SELECT empid FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%'))
            );
    SELECT * FROM ALEF_EDI_SETI_EMPS WHERE ESE_SETI_ID = (SELECT CodeID2 FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompID IN (@compid))
    ROLLBACK TRAN
    --COMMIT TRAN
END;

/* ЕСЛИ НАДО ДОБАВИТЬ УЖЕ СУЩЕСТВУЮЩЕМУ ПОЛЬЗОВАТЕЛЮ СЕТЬ/ПРЕДПРИЯТИЕ */
--SELECT * FROM ALEF_EDI_SETI_EMPS WHERE ESE_SETI_EMP_ID = 66803
--SELECT * FROM ALEF_EDI_SETI_EMPS WHERE ESE_SETI_NAME like '%эпицентр%'
--SELECT * FROM Alef_EDI_EMPS
--TRAN
--BEGIN TRAN
--    SELECT count(*) from ALEF_EDI_SETI_EMPS WHERE ESE_SETI_NAME like '%дигма%'
--    SELECT * FROM ALEF_EDI_SETI_EMPS WHERE  ESE_SETI_NAME like '%дигма%' ORDER BY 1 DESC
--        update ALEF_EDI_SETI_EMPS/*...ВНИМАТЕЛЬНО!*/ set ESE_SETI_EMP_ID = 7077 WHERE ESE_SETI_NAME like '%дигма%'
--    SELECT * FROM ALEF_EDI_SETI_EMPS WHERE  ESE_SETI_NAME like '%дигма%' ORDER BY 1 DESC
--    SELECT count(*) from ALEF_EDI_SETI_EMPS WHERE ESE_SETI_NAME like '%дигма%'
--ROLLBACK TRAN
--#endregion ДОБАВЛЕНИЕ ИНФО НА САЙТ ПЕРЕБРОСОВ

--#region ДОБАВЛЕНИЕ ИНФО В СПРАВОЧНИКИ

--#region TRAN 80019 "EDI - Допустимые типы  документов по сетям"
    /*ORDER - заказ, ORDRSP - Подтверждение заказа, DESADV - уведомление об отгрузке, RECADV - уведомление о приеме, COMDOC - расходная, приходная, товарная накладная, 
    DECLAR - Налоговая накладная, INVOICE - Счет*/
    --для каждого кода предприятия данной сети запустить скрипт отдельно.
    BEGIN TRAN ref_80019
        USE Elit
        GO
        DECLARE @compid int = 59318 --изменить параметр 1
        DECLARE @compname varchar(255) = 'Два шага' --изменить параметр 2
        DECLARE @docs_edi varchar(255) = 'ORDRSP, DESADV' --изменить параметр 3
        SELECT * FROM r_Uni WHERE RefTypeID = 80019 and RefID = @compid
        --insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) SELECT '80019', CompID, CompShort + ' (техимпорт)', @docs_edi FROM r_Comps WHERE CompID = @compid
        insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) SELECT '80019', CompID, @compname, @docs_edi FROM r_Comps WHERE CompID = @compid
        UPDATE r_Uni SET Notes = @docs_edi WHERE RefID = @compid 
        SELECT * FROM r_Uni WHERE RefTypeID = 80019 and RefID = @compid  
        --SELECT * FROM r_Uni WHERE RefTypeID = 80019 and REFID = 7138  
    ROLLBACK TRAN ref_80019
--#endregion TRAN 80019 "EDI - Допустимые типы  документов по сетям"

--#region TRAN 6680116 "EDI - Справочник партнеров"
    /*Сети, которые работают с нами по EDI (приведен полный список сетей, работающих с EDI в Украине - выкачан 08.02.2019). 
    ПРИМЕЧАНИЕ: "1" - сеть работает с нами, "0" - не работает с нами. КОД СПРАВОЧНИКА: ID сети (внешний EDI). ИМЯ СПРАВОЧНИКА: сеть.*/
    --для сети.
    BEGIN TRAN ref_6680116
        DECLARE @network varchar(255) = 'Два шага'; --изменить параметр 1
        --DECLARE @refid int = (SELECT RefID FROM r_Uni WHERE RefTypeID = 6680116 and RefName like ('%' + @network +'%'));
        --DECLARE @refid int = (SELECT MAX(RefID) FROM r_Uni WHERE RefTypeID = 6680116 and RefName like ('%' + @network +'%'));
        DECLARE @refid int = (SELECT RefID FROM r_Uni WHERE RefTypeID = 6680116 and RefName /*= @network); --RefName*/ like ('%' + @network +'%')); --для сети КОЛОС/ЧУДО есть 3 варианта.
        SELECT * FROM r_Uni WHERE RefTypeID = 6680116 and RefID = @refid;
        update r_Uni set Notes = 1 WHERE RefTypeID = 6680116 and RefID = @refid;
        --После этого апдейта должен отработать джоб GLN_check на s-elit-dp (он затянет все новые gln в реестр at_gln).
        SELECT * FROM r_Uni WHERE RefTypeID = 6680116 and RefID = @refid;
        --SELECT * FROM r_Uni WHERE RefTypeID = 6680116 and RefName like '%салют%'
    ROLLBACK TRAN ref_6680116
--#endregion TRAN 6680116 "EDI - Справочник партнеров"

--#region TRAN 6680117 "EDI - Справочник соответствия кодов предприятий и сетей (по EDI)"
    /*Код справочника - наш код предприятия (CompID), Имя справочника - название предприятия (CompName) => "название сети", 
    Примечание - внешний код сети (по EDI) ["0" - не работаем]*/
    --сначала инсертить, а потом сделать апдейт.
    --для каждого кода предприятия данной сети запустить скрипт отдельно.
    BEGIN TRAN ref_6680117
        DECLARE @network varchar(255) = 'МассМарт'; --изменить параметр 1
        SELECT top 1 RetailersID FROM at_GLN WHERE RetailersName like '%' + @network + '%' --для проверки.
        DECLARE @compid int = 7161 --изменить параметр 2
        SELECT * FROM r_Uni WHERE RefTypeID = 6680117 and RefID = @compid
        --Notes в r_uni = retailersID в at_gln
        --insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) select '6680117', compid, CompShort + ' => ' + @network, 0 FROM r_Comps WHERE CompID = @compid
        --если нужно добавить сеть для другого региона (по типу ОККО, Эпицентр).
        --insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) select '6680117', compid, CompShort + ' (Первомайск)' + ' => ' + @network, 0 FROM r_Comps WHERE CompID = @compid
    
        --(!) Перед этим апдейтом должен отработать джоб GLN_check на s-elit-dp (он затянет все новые gln в реестр at_gln).
        update r_Uni set Notes = (SELECT top 1 RetailersID FROM at_GLN WHERE RetailersName like '%' + @network + '%') WHERE RefTypeID = 6680117 and RefID = @compid
    
        --/*если нет еще 1-го заказа от сети и нет записи в реестре at_gln*/update r_Uni set Notes = 16532 WHERE RefTypeID = 6680117 and RefID = @compid
        SELECT * FROM r_Uni WHERE RefTypeID = 6680117 and RefID = @compid
        --SELECT * FROM r_Uni WHERE RefTypeID = 6680117 and RefID = 7138
    ROLLBACK TRAN ref_6680117
--#endregion TRAN 6680117 "EDI - Справочник соответствия кодов предприятий и сетей (по EDI)"

--#endregion ДОБАВЛЕНИЕ ИНФО В СПРАВОЧНИКИ

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ДОБАВЛЕНИЕ GLN_AUTO - Добавить базовый GLN !!!, Потом по скрипту пройтись пошагово и после этого на сайте перебросов видим уже заказы!*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
--#region EXTRA
BEGIN
--Если по сети автоматом (мимо папки Черновики) не отправляются уведомления (DESADV, ORDRSP..):

    begin
	    IF OBJECT_ID('tempdb..#m1', 'U') IS NOT NULL
		    DROP TABLE #m1
	    IF OBJECT_ID('tempdb..#m2', 'U') IS NOT NULL
		    DROP TABLE #m2
	    select * into #m1
	    from (
	    SELECT ru.refname
	    ,      ru.Notes
	    ,      rc.Compid
	    ,      rc.CompName
	    ,      ru.Reftypeid
	    FROM r_Comps rc
	    join r_uni   ru on ru.refid = rc.compid
	    WHERE ru.reftypeid = 6680117
		    and rc.CompID IN (75137)
	    ) m1
	    --SELECT * FROM #m1

	    select * into #m2
	    from (
	    SELECT ru.refname
	    ,      ru.Notes
	    ,      rc.Compid
	    ,      rc.CompName
	    ,      ru.Reftypeid
	    FROM r_Comps rc
	    join r_uni   ru on ru.refid = rc.compid
	    WHERE ru.reftypeid = 80019
		    and rc.CompID IN (75137)
	    ) m2
	    --SELECT * FROM #m2

	    SELECT *
	    FROM #m1
	    join #m2 ON #m1.compid = #m2.compid
    end;


    SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_KLN_OT = 75137
    insert into r_CompValues values (7132, 'base_gln', '9864066865178')
    SELECT * FROM r_CompValues WHERE compid = 7132

    SELECT top 100 * FROM at_z_FilesExchange ORDER BY 1 DESC


    /*
    SELECT * FROM at_GLN ORDER BY ImportDate DESC
    SELECT * FROM at_GLN WHERE ImportDate > convert(date, GETDATE()-1, 102) ORDER BY ImportDate DESC
    SELECT * FROM r_Uni WHERE RefTypeID = 6680116 ORDER BY RefID DESC
    SELECT * FROM r_Uni WHERE RefTypeID = 6680116 AND RefName like '%колос%'
    SELECT * FROM r_Uni WHERE RefTypeID = 6680117 AND RefName like '%ЧУДО%'
    SELECT * FROM at_GLN ORDER BY ImportDate DESC
    */
END;
--#endregion EXTRA

