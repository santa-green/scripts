--#region ���������� ���� �� ���� ����������
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
    DECLARE @new_user varchar(100) = '�������'
    SELECT empid, EmpName FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%')
    DECLARE @new_user_short varchar(100)
    select @new_user_short = REVERSE(SUBSTRING(LTRIM(reverse(empname)), CHARINDEX(' ', LTRIM(reverse(empname))) + 1, 100))
    FROM [s-sql-d4].[elit].dbo.r_emps
    WHERE empname like ('%' + @new_user + '%')
    select @new_user_short '��� �������'
    INSERT INTO #new_edin_network (new_user_short) VALUES (@new_user_short)
END;

--SELECT * FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%')
SELECT * FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%') and empid = 6053

DECLARE @new_network varchar(100) = '����'

SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.Alef_EDI_EMPS WHERE EEA_EMP_NAME like ('%' + @new_user + '%')
SELECT * FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompName like ('%' + @new_network + '%')
DECLARE @compid varchar(max) = 72195
SELECT CodeID2, * FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompID IN (@compid)

SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.alef_edi_SETI_EMPS WHERE ESE_SETI_NAME like ('%' + @new_network + '%')--ESE_SETI_EMP_ID = 7077
--SELECT * FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompName like '%�������%'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHECKPOINT 2021-08-19 14:22:37*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--��������� ������ ������������ �� ���� ����������
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
--��������� ������ ������������-����.
IF 1 = 0
--IF 1 = 1
BEGIN
    BEGIN TRAN
        INSERT INTO ALEF_EDI_SETI_EMPS (ESE_SETI_ID, ESE_SETI_NAME, ESE_SETI_LOGO, ESE_SETI_EMP_ID) VALUES(
            (SELECT CodeID2 FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompID IN (@compid)),
            @new_network,
            '��� ����.jpg', --����� ������ �������� �����. --�������� �������� ����� �� s-ppc - c:\inetpub\wwwroot\edi\img\
            (SELECT empid FROM [s-sql-d4].[elit].dbo.r_emps WHERE empname like ('%' + @new_user + '%'))
            );
    SELECT * FROM ALEF_EDI_SETI_EMPS WHERE ESE_SETI_ID = (SELECT CodeID2 FROM [s-sql-d4].[elit].dbo.r_Comps WHERE CompID IN (@compid))
    ROLLBACK TRAN
    --COMMIT TRAN
END;

/* ���� ���� �������� ��� ������������� ������������ ����/����������� */
--SELECT * FROM ALEF_EDI_SETI_EMPS WHERE ESE_SETI_EMP_ID = 66803
--SELECT * FROM ALEF_EDI_SETI_EMPS WHERE ESE_SETI_NAME like '%��������%'
--SELECT * FROM Alef_EDI_EMPS
--TRAN
--BEGIN TRAN
--    SELECT count(*) from ALEF_EDI_SETI_EMPS WHERE ESE_SETI_NAME like '%�����%'
--    SELECT * FROM ALEF_EDI_SETI_EMPS WHERE  ESE_SETI_NAME like '%�����%' ORDER BY 1 DESC
--        update ALEF_EDI_SETI_EMPS/*...�����������!*/ set ESE_SETI_EMP_ID = 7077 WHERE ESE_SETI_NAME like '%�����%'
--    SELECT * FROM ALEF_EDI_SETI_EMPS WHERE  ESE_SETI_NAME like '%�����%' ORDER BY 1 DESC
--    SELECT count(*) from ALEF_EDI_SETI_EMPS WHERE ESE_SETI_NAME like '%�����%'
--ROLLBACK TRAN
--#endregion ���������� ���� �� ���� ����������

--#region ���������� ���� � �����������

--#region TRAN 80019 "EDI - ���������� ����  ���������� �� �����"
    /*ORDER - �����, ORDRSP - ������������� ������, DESADV - ����������� �� ��������, RECADV - ����������� � ������, COMDOC - ���������, ���������, �������� ���������, 
    DECLAR - ��������� ���������, INVOICE - ����*/
    --��� ������� ���� ����������� ������ ���� ��������� ������ ��������.
    BEGIN TRAN ref_80019
        USE Elit
        GO
        DECLARE @compid int = 59318 --�������� �������� 1
        DECLARE @compname varchar(255) = '��� ����' --�������� �������� 2
        DECLARE @docs_edi varchar(255) = 'ORDRSP, DESADV' --�������� �������� 3
        SELECT * FROM r_Uni WHERE RefTypeID = 80019 and RefID = @compid
        --insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) SELECT '80019', CompID, CompShort + ' (���������)', @docs_edi FROM r_Comps WHERE CompID = @compid
        insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) SELECT '80019', CompID, @compname, @docs_edi FROM r_Comps WHERE CompID = @compid
        UPDATE r_Uni SET Notes = @docs_edi WHERE RefID = @compid 
        SELECT * FROM r_Uni WHERE RefTypeID = 80019 and RefID = @compid  
        --SELECT * FROM r_Uni WHERE RefTypeID = 80019 and REFID = 7138  
    ROLLBACK TRAN ref_80019
--#endregion TRAN 80019 "EDI - ���������� ����  ���������� �� �����"

--#region TRAN 6680116 "EDI - ���������� ���������"
    /*����, ������� �������� � ���� �� EDI (�������� ������ ������ �����, ���������� � EDI � ������� - ������� 08.02.2019). 
    ����������: "1" - ���� �������� � ����, "0" - �� �������� � ����. ��� �����������: ID ���� (������� EDI). ��� �����������: ����.*/
    --��� ����.
    BEGIN TRAN ref_6680116
        DECLARE @network varchar(255) = '��� ����'; --�������� �������� 1
        --DECLARE @refid int = (SELECT RefID FROM r_Uni WHERE RefTypeID = 6680116 and RefName like ('%' + @network +'%'));
        --DECLARE @refid int = (SELECT MAX(RefID) FROM r_Uni WHERE RefTypeID = 6680116 and RefName like ('%' + @network +'%'));
        DECLARE @refid int = (SELECT RefID FROM r_Uni WHERE RefTypeID = 6680116 and RefName /*= @network); --RefName*/ like ('%' + @network +'%')); --��� ���� �����/���� ���� 3 ��������.
        SELECT * FROM r_Uni WHERE RefTypeID = 6680116 and RefID = @refid;
        update r_Uni set Notes = 1 WHERE RefTypeID = 6680116 and RefID = @refid;
        --����� ����� ������� ������ ���������� ���� GLN_check �� s-elit-dp (�� ������� ��� ����� gln � ������ at_gln).
        SELECT * FROM r_Uni WHERE RefTypeID = 6680116 and RefID = @refid;
        --SELECT * FROM r_Uni WHERE RefTypeID = 6680116 and RefName like '%�����%'
    ROLLBACK TRAN ref_6680116
--#endregion TRAN 6680116 "EDI - ���������� ���������"

--#region TRAN 6680117 "EDI - ���������� ������������ ����� ����������� � ����� (�� EDI)"
    /*��� ����������� - ��� ��� ����������� (CompID), ��� ����������� - �������� ����������� (CompName) => "�������� ����", 
    ���������� - ������� ��� ���� (�� EDI) ["0" - �� ��������]*/
    --������� ���������, � ����� ������� ������.
    --��� ������� ���� ����������� ������ ���� ��������� ������ ��������.
    BEGIN TRAN ref_6680117
        DECLARE @network varchar(255) = '��������'; --�������� �������� 1
        SELECT top 1 RetailersID FROM at_GLN WHERE RetailersName like '%' + @network + '%' --��� ��������.
        DECLARE @compid int = 7161 --�������� �������� 2
        SELECT * FROM r_Uni WHERE RefTypeID = 6680117 and RefID = @compid
        --Notes � r_uni = retailersID � at_gln
        --insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) select '6680117', compid, CompShort + ' => ' + @network, 0 FROM r_Comps WHERE CompID = @compid
        --���� ����� �������� ���� ��� ������� ������� (�� ���� ����, ��������).
        --insert into r_Uni ([RefTypeID], [RefID], [RefName], [Notes]) select '6680117', compid, CompShort + ' (����������)' + ' => ' + @network, 0 FROM r_Comps WHERE CompID = @compid
    
        --(!) ����� ���� �������� ������ ���������� ���� GLN_check �� s-elit-dp (�� ������� ��� ����� gln � ������ at_gln).
        update r_Uni set Notes = (SELECT top 1 RetailersID FROM at_GLN WHERE RetailersName like '%' + @network + '%') WHERE RefTypeID = 6680117 and RefID = @compid
    
        --/*���� ��� ��� 1-�� ������ �� ���� � ��� ������ � ������� at_gln*/update r_Uni set Notes = 16532 WHERE RefTypeID = 6680117 and RefID = @compid
        SELECT * FROM r_Uni WHERE RefTypeID = 6680117 and RefID = @compid
        --SELECT * FROM r_Uni WHERE RefTypeID = 6680117 and RefID = 7138
    ROLLBACK TRAN ref_6680117
--#endregion TRAN 6680117 "EDI - ���������� ������������ ����� ����������� � ����� (�� EDI)"

--#endregion ���������� ���� � �����������

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*���������� GLN_AUTO - �������� ������� GLN !!!, ����� �� ������� �������� �������� � ����� ����� �� ����� ���������� ����� ��� ������!*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
--#region EXTRA
BEGIN
--���� �� ���� ��������� (���� ����� ���������) �� ������������ ����������� (DESADV, ORDRSP..):

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
    SELECT * FROM r_Uni WHERE RefTypeID = 6680116 AND RefName like '%�����%'
    SELECT * FROM r_Uni WHERE RefTypeID = 6680117 AND RefName like '%����%'
    SELECT * FROM at_GLN ORDER BY ImportDate DESC
    */
END;
--#endregion EXTRA

