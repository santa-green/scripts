IF OBJECT_ID (N'tempdb..#res',N'U') IS NOT NULL DROP TABLE #res
CREATE TABLE #res
( ObjectName VARCHAR(MAX)
 ,Users VARCHAR(MAX)
 ,EmpName VARCHAR(MAX))

DECLARE @temp TABLE (t VARCHAR(MAX))

DECLARE @obj VARCHAR(MAX)

DECLARE CURSOR2 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT o.name AS Object_Name
FROM sys.sql_modules m with (nolock)
INNER JOIN sys.objects o with (nolock)
ON m.object_id = o.object_id
WHERE
m.definition Like '%SUSER_SNAME%'
--o.name = 'ap_ImportVen'
--and o.type in ('P ','TF','FN')
--and o.name not in (SELECT ObjName FROM z_Objects where ObjType in ('p'))
--order by LEN(m.definition)
ORDER BY 1

OPEN CURSOR2
	FETCH NEXT FROM CURSOR2 INTO @obj
WHILE @@FETCH_STATUS = 0	 
BEGIN
		
				DECLARE @Running_Sql varchar(max) = (SELECT m.definition 
				FROM sys.sql_modules m with (nolock)
				INNER JOIN sys.objects o with (nolock)
				ON m.object_id = o.object_id
				WHERE o.name = @obj
				)

					IF OBJECT_ID (N'tempdb..#linenum', N'U') IS NOT NULL DROP TABLE #linenum
					SELECT ROW_NUMBER()OVER(ORDER BY number) n , number
					into #linenum
					FROM (
						SELECT ROW_NUMBER()OVER(ORDER BY(SELECT 1)) number
						FROM 
						 (SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s1
						,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s2
						,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s3
						,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s4
						,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s5
						,(SELECT*FROM(VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))X(X)) s6
					) gen
					where number BETWEEN 1 AND LEN(@Running_Sql) AND ( SUBSTRING(@Running_Sql,number,1)=char(13) OR SUBSTRING(@Running_Sql,number,1)=char(10))

				--SELECT * FROM #linenum

				DECLARE @num INT, @old_num INT = 0
				DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
				FOR 
				SELECT number FROM #linenum 

				OPEN CURSOR1
					FETCH NEXT FROM CURSOR1 INTO @num
				WHILE @@FETCH_STATUS = 0	 
				BEGIN
	
					INSERT INTO @temp
					SELECT SUBSTRING(m.definition, @old_num, @num-@old_num+2) 
						FROM sys.sql_modules m with (nolock)
						INNER JOIN sys.objects o with (nolock)
						ON m.object_id = o.object_id
						WHERE o.name = @obj
	
					SET @old_num = @num	
					FETCH NEXT FROM CURSOR1 INTO @num
				END
				CLOSE CURSOR1
				DEALLOCATE CURSOR1

				--SELECT * FROM @temp

				DELETE @temp WHERE t NOT LIKE '%SUSER_SNAME%'
				DELETE @temp WHERE t LIKE '%= SUSER_SNAME()%'
				DELETE @temp WHERE t LIKE '%=SUSER_SNAME()%'

				--SELECT * FROM @temp
				DECLARE @patern VARCHAR(256)

				UPDATE @temp SET t = RTRIM(LTRIM(t) )

				SET @patern = 'SUSER_SNAME() NOT IN'
				UPDATE @temp SET t = SUBSTRING(t,CHARINDEX(@patern, t)  + LEN(@patern), 1 + ( LEN(t) - CHARINDEX(')''', REVERSE( t ) ) + 1 ) - ( CHARINDEX(@patern, t) + LEN(@patern) ) ) WHERE t LIKE '%' + @patern + '%'

				SET @patern = 'SUSER_SNAME() IN'
				UPDATE @temp SET t = SUBSTRING(t,CHARINDEX(@patern, t)  + LEN(@patern), 1 + ( LEN(t) - CHARINDEX(')''', REVERSE( t ) ) + 1 ) - ( CHARINDEX(@patern, t) + LEN(@patern) ) ) WHERE t LIKE '%' + @patern + '%'

				SET @patern = 'SUSER_SNAME() ='
				UPDATE @temp SET t = SUBSTRING(t,CHARINDEX(@patern, t)  + LEN(@patern), 1 + ( LEN(t) - CHARINDEX('''', REVERSE( t ) ) + 1 ) - ( CHARINDEX(@patern, t) + LEN(@patern) ) ) WHERE t LIKE '%' + @patern + '%'
				SET @patern = 'SUSER_SNAME()='
				UPDATE @temp SET t = SUBSTRING(t,CHARINDEX(@patern, t)  + LEN(@patern), 1 + ( LEN(t) - CHARINDEX('''', REVERSE( t ) ) + 1 ) - ( CHARINDEX(@patern, t) + LEN(@patern) ) ) WHERE t LIKE '%' + @patern + '%'
				
				SET @patern = 'SUSER_SNAME() !='
				UPDATE @temp SET t = SUBSTRING(t,CHARINDEX(@patern, t)  + LEN(@patern), 1 + ( LEN(t) - CHARINDEX('''', REVERSE( t ) ) + 1 ) - ( CHARINDEX(@patern, t) + LEN(@patern) ) ) WHERE t LIKE '%' + @patern + '%'

				DELETE @temp WHERE t LIKE '%isnull(SUSER_SNAME(),%'

				INSERT INTO #res
				SELECT @obj, t, '' FROM @temp

				DELETE @temp
	
	FETCH NEXT FROM CURSOR2 INTO @obj
END
CLOSE CURSOR2
DEALLOCATE CURSOR2

DELETE #res WHERE Users LIKE ' ''sev12'' RAISERROR(''HelloWorld %s'''
DELETE #res WHERE Users LIKE '%--Шевченко Анна Олеговна%'
DELETE #res WHERE Users LIKE '%Менеджер ВЭД (Логистика)%'

--SELECT * FROM #res
DECLARE @SQL_Select NVARCHAR(MAX), @outs VARCHAR(MAX), @filtr VARCHAR(MAX), @users VARCHAR(MAX)
DECLARE CURSOR3 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT DISTINCT Users FROM #res
--WHERE ObjectName = 'a_tAcc_CheckFieldValues_IU'
ORDER BY 1 ASC

OPEN CURSOR3
	FETCH NEXT FROM CURSOR3 INTO @users
WHILE @@FETCH_STATUS = 0	 
BEGIN	
	
	IF (SELECT CHARINDEX('(', @users)) = 0 OR (SELECT CHARINDEX(')', @users)) = 0
	BEGIN
		SET @filtr = '(' + @users + ')'
	END;
	ELSE
	BEGIN
		SET @filtr = @users--REPLACE(@users, '''', '''''')
	END;
	

	SET @SQL_Select = 'SELECT @out = COALESCE(@out + '', '', '''') + ISNULL(EmpName, ''No User'') FROM r_Emps WHERE EmpID IN (SELECT EmpID FROM r_Users WHERE UserName IN ' + @filtr +')'

	--SELECT @SQL_Select

	EXEC sp_executesql @SQL_Select, N'@out VARCHAR(200) OUT', @outs OUT

	UPDATE #res SET EmpName = @outs WHERE Users = @users

	SELECT @SQL_Select = '', @outs = '', @filtr = ''
	
	FETCH NEXT FROM CURSOR3 INTO @users
END
CLOSE CURSOR3
DEALLOCATE CURSOR3

UPDATE #res SET EmpName = SUBSTRING(EmpName,3,LEN(EmpName))

SELECT * FROM #res

--DECLARE @out VARCHAR(MAX)
--SELECT @out = COALESCE(@out + ', ', '') + ISNULL(EmpName, 'No User') FROM r_Emps WHERE EmpID IN (SELECT ISNULL(EmpID, 0) FROM r_Users WHERE UserName IN  ('diablo'))
--SELECT @out 
--WHERE Result LIKE '%SUSER_SNAME%'
--SELECT SUBSTRING('qwertyuiop',0,3)
--SELECT CHARINDEX('A','ABCADE')
--SELECT LEN('qwertyuiop')
--SELECT REVERSE(''')')
--SELECT REPLACE('assdfssghkjbhjhvbss', 'ss', 'x')
--DECLARE @lol VARCHAR(256) = 'We are made at iron gorn and still '
--SELECT SUBSTRING(@lol, 1, LEN(@lol) - CHARINDEX('A', REVERSE(  @lol ) ) + 1)

/*
				DECLARE @Running_Sqp varchar(max) = (SELECT m.definition 
				FROM sys.sql_modules m with (nolock)
				INNER JOIN sys.objects o with (nolock)
				ON m.object_id = o.object_id
				WHERE o.name = 'a_attPrepay_CheckTaxDoc_IU'
				)

				SELECT ASCII( SUBSTRING(@Running_Sqp, 74, 1) ), char(ASCII( SUBSTRING(@Running_Sqp, 74, 1) ))




SELECT o.name AS Object_Name
,o.type_desc
--,CHARINDEX('AS',m.definition)
--,SUBSTRING(m.definition, CHARINDEX('AS',m.definition), 32000)
,m.definition
,LEN(m.definition) dlina
,*
FROM sys.sql_modules m with (nolock)
INNER JOIN sys.objects o with (nolock)
ON m.object_id = o.object_id
WHERE m.definition Like '%SUSER_SNAME%'
--and o.type in ('P ','TF','FN')
--and o.name not in (SELECT ObjName FROM z_Objects where ObjType in ('p'))
--order by LEN(m.definition)
ORDER BY 1

a_atrCompOurTerms_CheckValues_IU
a_atrDiscComps_CheckValues_IU
a_atrSRs_CheckValues_IUD
a_attPrepay_CheckTaxDoc_IU
a_attPrepay_CheckUserPeriod_IUD

af_GetValidsTable
af_IsAccToView 
*/