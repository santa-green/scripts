/*
1. Подписываем допку с сетью по документообороту (ключевые моменты: провайдер ООО "АТС" (EDIN), документы: ORDRSP, DESADV, RECADV, COMDOC, DECLAR...).
2. На сайте провайдера https://edo-v2.edin.ua/app/#/service/personal/counterparties/edi/retailer/list/0 выбираем сеть (Назва торгової мережі: Делікат) и создаем заявку на подключение. Подписываем КЭП.
3. Сеть должна подтвердить сформированную заявку (хотя это на сейчас и не обязательно).
4. Менеджер должен предоставить Лейле подвязку кодов товаров (наши внутренние коды - внешние коды сети).
5. Получить от сети тестовый заказ.
6. Далее настроить подключение пошагово по скрипту ниже.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ДОБАВЛЕНИЕ ИНФО НА САЙТ ПЕРЕБРОСОВ: S-PPC -> Alef_Elit*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE Alef_Elit
GO

BEGIN
    DECLARE @new_user varchar(100) = 'Быстров' --указать фамилию.
    DECLARE @compid int = 72195 --Імк 33--указать код предприятия.
    DECLARE @new_network varchar(100) = 'ИВЗО' --указать название сети.
    DECLARE @docs_edi varchar(100) = 'DESADV, COMDOC, DECLAR' --указать название сети.

    IF OBJECT_ID('[Alef_Elit]..new_edin_network', 'U') IS NOT NULL
	    DROP TABLE new_edin_network

    SELECT 
        REVERSE(SUBSTRING(LTRIM(reverse(empname)), CHARINDEX(' ', LTRIM(reverse(empname))) + 1, 100)) 'new_user_short',
        EmpID 'EmpID',
        @compid 'CompID',
        @new_network 'New_Network',
        (SELECT CodeID2 FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompID IN (@compid)) 'CodeID2',
        (SELECT CompName FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompID IN (@compid)) 'CompName',
        (SELECT CompShort FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompID IN (@compid)) 'CompShort',
        @docs_edi 'edi_docs',
        (SELECT RefID FROM [s-sql-d4].[elit].dbo.r_Uni WHERE RefTypeID = 6680116 and RefName like ('%' + @new_network +'%')) 'RetailersID'
    INTO new_edin_network
    FROM [s-sql-d4].[elit].dbo.r_emps
    WHERE empname like ('%' + @new_user + '%')
    
    SELECT '' 'new_edin_network', * FROM new_edin_network
END;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*добавляем нового пользователя на сайт перебросов*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN TRAN site_perebrosov
        INSERT INTO ALEF_EDI_EMPS (EEA_EMP_ID, EEA_EMP_NAME, EEA_EMP_PSWD, EEA_EMP_IMG, EEA_EMP_READONLY)
        SELECT 
            EmpID, 
            new_user_short, 
            1, 
            'img/male.png', 
            NULL 
        FROM new_edin_network        
        SELECT * FROM ALEF_EDI_EMPS WHERE EEA_EMP_ID = (SELECT EmpID FROM new_edin_network)
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        /*добавляем связку пользователь-сеть*/
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        INSERT INTO ALEF_EDI_SETI_EMPS (ESE_SETI_ID, ESE_SETI_NAME, ESE_SETI_LOGO, ESE_SETI_EMP_ID) 
            SELECT 
                CodeID2, 
                New_Network,
                'ИВЗО.png', --здесь меняем название файла. --обновить картинку здесь на s-ppc - c:\inetpub\wwwroot\edi\img\
                EmpID
            FROM new_edin_network   
    SELECT * FROM ALEF_EDI_SETI_EMPS WHERE ESE_SETI_ID = (SELECT CodeID2 FROM new_edin_network)

ROLLBACK TRAN site_perebrosov



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ДОБАВЛЕНИЕ ИНФО В СПРАВОЧНИКИ: D4 -> Elit*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE Elit
GO

DECLARE @compid int = 72195 --Імк 33--указать код предприятия.

BEGIN TRAN r_Uni_update

    IF OBJECT_ID('tempdb..#new_edin_network', 'U') IS NOT NULL
	    DROP TABLE #new_edin_network

    SELECT new_user_short, EmpID, CompID, New_Network, CodeID2, CompName, CompShort, edi_docs, RetailersID
	    INTO #new_edin_network
    FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.new_edin_network
    SELECT * FROM #new_edin_network
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*TRAN 80019 "EDI - Допустимые типы  документов по сетям"*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --для каждого кода предприятия данной сети (!) запустить скрипт отдельно.
    INSERT INTO r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) 
    SELECT '80019', CompID, CompName, edi_docs FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.new_edin_network
        
    SELECT '80019 "EDI - Допустимые типы  документов по сетям"', * FROM r_Uni WHERE RefTypeID = 80019 and REFID = @compid  

    --#region TRAN 6680116 "EDI - Справочник партнеров"
        /* Сети, которые работают с нами по EDI (приведен полный список сетей, работающих с EDI в Украине - выкачан 08.02.2019). 
        ПРИМЕЧАНИЕ: "1" - сеть работает с нами, "0" - не работает с нами. КОД СПРАВОЧНИКА: ID сети (внешний EDI). ИМЯ СПРАВОЧНИКА: сеть.*/
        --для сети.
            update r_Uni set Notes = 1 WHERE RefTypeID = 6680116 and RefID = (SELECT RetailersID FROM #new_edin_network);
            SELECT '6680116 "EDI - Справочник партнеров"', * FROM r_Uni WHERE RefTypeID = 6680116 and RefID = (SELECT RetailersID FROM #new_edin_network);
            /* --После этого апдейта должен отработать джоб GLN_check на s-elit-dp (он затянет все новые gln в реестр at_gln).
             EXEC [S-ELIT-DP\MSSQLSERVER2].[msdb].dbo.sp_start_job 'GLN_check' */
    --#endregion TRAN 6680116 "EDI - Справочник партнеров"

    --#region TRAN 6680117 "EDI - Справочник соответствия кодов предприятий и сетей (по EDI)"
        /*Код справочника - наш код предприятия (CompID), Имя справочника - название предприятия (CompName) => "название сети", 
        Примечание - внешний код сети (по EDI) ["0" - не работаем]*/
        --сначала инсертить, а потом сделать апдейт.
        --для каждого кода предприятия данной сети запустить скрипт отдельно.
            INSERT INTO r_Uni ( [RefTypeID], [RefID], [RefName], [Notes] )
            SELECT '6680117'
            ,      compid
            ,      CompShort + ' => ' + New_Network
            ,      RetailersID
            FROM #new_edin_network
            
            SELECT '6680117 "EDI - Справочник соответствия кодов предприятий и сетей (по EDI)"', * FROM r_Uni 
                WHERE RefTypeID = 6680117 and Notes = (SELECT RetailersID FROM #new_edin_network);
    
    --#endregion TRAN 6680117 "EDI - Справочник соответствия кодов предприятий и сетей (по EDI)"
ROLLBACK TRAN r_Uni_update

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ДОБАВЛЕНИЕ GLN_AUTO - Добавить базовый GLN !!!, Потом по скрипту пройтись пошагово и после этого на сайте перебросов видим уже заказы!*/
--ДОБАВИТЬ В ЭТУ ПРОЦЕДУРУ КУСОК ИЗ ТОЙ ПРОЦЕДУРЫ ПО ДОБАВЛЕНИЮ БАЗОВОГО GLN.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM at_GLN ORDER BY ImportDate DESC
SELECT * FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_NUMBER = 'Ц0000032204' --базовый GLN (ZEO_ZEC_BASE) можно взять здесь.
SELECT * FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ZEC_BASE = '9864232445906'

BEGIN TRAN base_gln
    DECLARE @compid varchar(max) = 72220
    DECLARE @base_gln varchar(max) = '9864232445906'
    SELECT * FROM r_CompValues WHERE Compid = @compid
        INSERT INTO r_CompValues (CompID, VarName, VarValue) --PK: CompID, VarName
        VALUES (@compid, 'BASE_GLN', @base_gln) --(!) меняем параметры здесь.       
    SELECT * FROM r_CompValues WHERE Compid = @compid
ROLLBACK TRAN base_gln

--привязываю все 22 кода по ИВЗО к базовому GLN = '9864232445906'
BEGIN TRAN base_gln
    SELECT * FROM r_CompValues WHERE VarValue = '9864232445906'
        INSERT INTO r_CompValues (CompID, VarName, VarValue) --PK: CompID, VarName
        SELECT Compid, 'BASE_GLN', '9864232445906' FROM r_Comps WHERE compid in (72195,72050,72037,72196,72027,72220,72140,72036,72197,72292,72351,72048,72069,72163,72177,72395,72123,72318,72227,70193,72083,72287)
    SELECT * FROM r_CompValues WHERE VarValue = '9864232445906'
ROLLBACK TRAN base_gln


SELECT CompID
FROM r_CompsAdd
WHERE CompID in (72195,72050,72037,72196,72027,72220,72140,72036,72197,72292,72351,72048,72069,72163,72177,72395,72123,72318,72227,70193,72083,72287)
EXCEPT
SELECT CompID FROM r_CompValues WHERE Compid in (72195,72050,72037,72196,72027,72220,72140,72036,72197,72292,72351,72048,72069,72163,72177,72395,72123,72318,72227,70193,72083,72287)

SELECT * FROM at_GLN g
WHERE g.gln in (9864232446224,9864232445920,9864232446217,9864232446149,9864232446118,9864232446033)

SELECT *
FROM r_CompsAdd
WHERE CompID in (72195,72050,72037,72196,72027,72220,72140,72036,72197,72292,72351,72048,72069,72163,72177,72395,72123,72318,72227,70193,72083,72287)
and CompAdd like '%' + (SELECT TOP 1 PARSENAME(REPLACE(GLNName, ',', '.'), 2) FROM at_GLN g
WHERE g.gln in (9864232446224,9864232445920,9864232446217,9864232446149,9864232446118,9864232446033)) + '%'
and CompAdd like '%' + (SELECT TOP 1 PARSENAME(REPLACE(GLNName, ',', '.'), 1) FROM at_GLN g
WHERE g.gln in (9864232446224,9864232445920,9864232446217,9864232446149,9864232446118,9864232446033)) + '%'

SELECT gln, PARSENAME(REPLACE(GLNName, ',', '.'), 2) 'street_name', PARSENAME(REPLACE(GLNName, ',', '.'), 1) 'number' FROM at_GLN g
WHERE g.gln in (9864232446224,9864232445920,9864232446217,9864232446149,9864232446118,9864232446033) --первые 6 заказов.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHECKPOINT 2021-08-20 12:06:53*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('tempdb..#gln', 'U') IS NOT NULL DROP TABLE #gln
--SELECT TOP(0) COMPID, COMPADD INTO #GLN FROM r_CompsAdd
CREATE TABLE #GLN (compid varchar(100), compadd varchar(100), GLN varchar(100))

DECLARE @street varchar(100)
DECLARE @number varchar(100)
DECLARE @gln varchar(100)
DECLARE compadd_cursor CURSOR LOCAL FAST_FORWARD FOR

SELECT PARSENAME(REPLACE(GLNName, ',', '.'), 2) 'street_name'
,      PARSENAME(REPLACE(GLNName, ',', '.'), 1) 'number'
,      gln 'gln'
FROM at_GLN g
WHERE g.gln in (9864232446224,9864232445920,9864232446217,9864232446149,9864232446118,9864232446033) --первые 6 заказов.
    
OPEN compadd_cursor
FETCH NEXT FROM compadd_cursor INTO @street, @number, @gln
WHILE @@FETCH_STATUS = 0
    BEGIN
    INSERT INTO #gln
    SELECT CompID, CompAdd, @gln
    FROM r_CompsAdd
    WHERE CompID in (72195,72050,72037,72196,72027,72220,72140,72036,72197,72292,72351,72048,72069,72163,72177,72395,72123,72318,72227,70193,72083,72287)
    and CompAdd like '%' + @street + '%'
    and CompAdd like '%' + @number + '%'

        FETCH NEXT FROM compadd_cursor INTO @street, @number, @gln
    END;
CLOSE compadd_cursor
DEALLOCATE compadd_cursor

SELECT * FROM #gln


