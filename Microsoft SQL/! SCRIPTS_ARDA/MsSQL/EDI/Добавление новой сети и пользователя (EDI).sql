/*
1. ����������� ����� � ����� �� ���������������� (�������� �������: ��������� ��� "���" (EDIN), ���������: ORDRSP, DESADV, RECADV, COMDOC, DECLAR...).
2. �� ����� ���������� https://edo-v2.edin.ua/app/#/service/personal/counterparties/edi/retailer/list/0 �������� ���� (����� ������� �����: ������) � ������� ������ �� �����������. ����������� ���.
3. ���� ������ ����������� �������������� ������ (���� ��� �� ������ � �� �����������).
4. �������� ������ ������������ ����� �������� ����� ������� (���� ���������� ���� - ������� ���� ����).
5. �������� �� ���� �������� �����.
6. ����� ��������� ����������� �������� �� ������� ����.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*���������� ���� �� ���� ����������: S-PPC -> Alef_Elit*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE Alef_Elit
GO

BEGIN
    DECLARE @new_user varchar(100) = '�������' --������� �������.
    DECLARE @compid int = 72195 --��� 33--������� ��� �����������.
    DECLARE @new_network varchar(100) = '����' --������� �������� ����.
    DECLARE @docs_edi varchar(100) = 'DESADV, COMDOC, DECLAR' --������� �������� ����.

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
/*��������� ������ ������������ �� ���� ����������*/
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
        /*��������� ������ ������������-����*/
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        INSERT INTO ALEF_EDI_SETI_EMPS (ESE_SETI_ID, ESE_SETI_NAME, ESE_SETI_LOGO, ESE_SETI_EMP_ID) 
            SELECT 
                CodeID2, 
                New_Network,
                '����.png', --����� ������ �������� �����. --�������� �������� ����� �� s-ppc - c:\inetpub\wwwroot\edi\img\
                EmpID
            FROM new_edin_network   
    SELECT * FROM ALEF_EDI_SETI_EMPS WHERE ESE_SETI_ID = (SELECT CodeID2 FROM new_edin_network)

ROLLBACK TRAN site_perebrosov



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*���������� ���� � �����������: D4 -> Elit*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE Elit
GO

DECLARE @compid int = 72195 --��� 33--������� ��� �����������.

BEGIN TRAN r_Uni_update

    IF OBJECT_ID('tempdb..#new_edin_network', 'U') IS NOT NULL
	    DROP TABLE #new_edin_network

    SELECT new_user_short, EmpID, CompID, New_Network, CodeID2, CompName, CompShort, edi_docs, RetailersID
	    INTO #new_edin_network
    FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.new_edin_network
    SELECT * FROM #new_edin_network
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*TRAN 80019 "EDI - ���������� ����  ���������� �� �����"*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --��� ������� ���� ����������� ������ ���� (!) ��������� ������ ��������.
    INSERT INTO r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) 
    SELECT '80019', CompID, CompName, edi_docs FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.new_edin_network
        
    SELECT '80019 "EDI - ���������� ����  ���������� �� �����"', * FROM r_Uni WHERE RefTypeID = 80019 and REFID = @compid  

    --#region TRAN 6680116 "EDI - ���������� ���������"
        /* ����, ������� �������� � ���� �� EDI (�������� ������ ������ �����, ���������� � EDI � ������� - ������� 08.02.2019). 
        ����������: "1" - ���� �������� � ����, "0" - �� �������� � ����. ��� �����������: ID ���� (������� EDI). ��� �����������: ����.*/
        --��� ����.
            update r_Uni set Notes = 1 WHERE RefTypeID = 6680116 and RefID = (SELECT RetailersID FROM #new_edin_network);
            SELECT '6680116 "EDI - ���������� ���������"', * FROM r_Uni WHERE RefTypeID = 6680116 and RefID = (SELECT RetailersID FROM #new_edin_network);
            /* --����� ����� ������� ������ ���������� ���� GLN_check �� s-elit-dp (�� ������� ��� ����� gln � ������ at_gln).
             EXEC [S-ELIT-DP\MSSQLSERVER2].[msdb].dbo.sp_start_job 'GLN_check' */
    --#endregion TRAN 6680116 "EDI - ���������� ���������"

    --#region TRAN 6680117 "EDI - ���������� ������������ ����� ����������� � ����� (�� EDI)"
        /*��� ����������� - ��� ��� ����������� (CompID), ��� ����������� - �������� ����������� (CompName) => "�������� ����", 
        ���������� - ������� ��� ���� (�� EDI) ["0" - �� ��������]*/
        --������� ���������, � ����� ������� ������.
        --��� ������� ���� ����������� ������ ���� ��������� ������ ��������.
            INSERT INTO r_Uni ( [RefTypeID], [RefID], [RefName], [Notes] )
            SELECT '6680117'
            ,      compid
            ,      CompShort + ' => ' + New_Network
            ,      RetailersID
            FROM #new_edin_network
            
            SELECT '6680117 "EDI - ���������� ������������ ����� ����������� � ����� (�� EDI)"', * FROM r_Uni 
                WHERE RefTypeID = 6680117 and Notes = (SELECT RetailersID FROM #new_edin_network);
    
    --#endregion TRAN 6680117 "EDI - ���������� ������������ ����� ����������� � ����� (�� EDI)"
ROLLBACK TRAN r_Uni_update

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*���������� GLN_AUTO - �������� ������� GLN !!!, ����� �� ������� �������� �������� � ����� ����� �� ����� ���������� ����� ��� ������!*/
--�������� � ��� ��������� ����� �� ��� ��������� �� ���������� �������� GLN.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM at_GLN ORDER BY ImportDate DESC
SELECT * FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ORDER_NUMBER = '�0000032204' --������� GLN (ZEO_ZEC_BASE) ����� ����� �����.
SELECT * FROM ALEF_EDI_ORDERS_2 WHERE ZEO_ZEC_BASE = '9864232445906'

BEGIN TRAN base_gln
    DECLARE @compid varchar(max) = 72220
    DECLARE @base_gln varchar(max) = '9864232445906'
    SELECT * FROM r_CompValues WHERE Compid = @compid
        INSERT INTO r_CompValues (CompID, VarName, VarValue) --PK: CompID, VarName
        VALUES (@compid, 'BASE_GLN', @base_gln) --(!) ������ ��������� �����.       
    SELECT * FROM r_CompValues WHERE Compid = @compid
ROLLBACK TRAN base_gln

--���������� ��� 22 ���� �� ���� � �������� GLN = '9864232445906'
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
WHERE g.gln in (9864232446224,9864232445920,9864232446217,9864232446149,9864232446118,9864232446033) --������ 6 �������.
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
WHERE g.gln in (9864232446224,9864232445920,9864232446217,9864232446149,9864232446118,9864232446033) --������ 6 �������.
    
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


