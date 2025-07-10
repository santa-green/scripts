SELECT * FROM [S-SQL-D4].elit.dbo.at_gln ORDER BY ImportDate desc

--сравнить адреса Elit и реестр gln
SELECT GLN,RetailersName,CompID, CompAddID, Adress, CompAdd, CompAddDesc, CompDefaultAdd 
, dbo.fnDiffStr4( Adress, CompAdd,4) diff4
, dbo.fnDiffStr( Adress, CompAdd) diff
FROM [S-SQL-D4].elit.dbo.at_gln s1
join (SELECT CompID, CompAdd, CompAddDesc, CompDefaultAdd, CompAddID, CompGrID1, CompGrID2, GLNCode, Latitude, Longitude, CompAddCharID, ChDate, TerrID
		FROM [S-SQL-D4].elit.dbo.r_CompsAdd) s2 on s2.GLNCode = s1.GLN
ORDER BY diff,2,3,4

SELECT * ,len(s1.AValue) FROM (
SELECT
 --chid,
distinct a.AValue
--,g.Adress 
FROM [S-SQL-D4].elit.dbo.at_gln g
cross apply dbo.fnStrToWords(g.Adress,4) a
where len(a.AValue) > 3
) s1
ORDER BY len(s1.AValue),1


SELECT ChID, RetailersID, RetailersName, GLN, GLNName, Adress, ImportDate, Notes
FROM [S-SQL-D4].elit.dbo.at_gln ORDER BY ImportDate desc


SELECT * FROM [S-SQL-D4].elit_test.dbo.at_gln ORDER BY ImportDate desc

SELECT EGS_GLN_ID,RetailersID, EGS_GLN_SETI_ID, Adress,  EGS_GLN_NAME, EGS_STATUS FROM at_gln s1
join (SELECT * FROM [S-PPC.CONST.ALEF.UA].[Alef_Elit].dbo.ALEF_EDI_GLN_SETI) s2 on s2.EGS_GLN_ID = s1.GLN
ORDER BY 2

SELECT * FROM [S-SQL-D4].elit.dbo.at_gln 
where gln not in (SELECT GLN FROM [S-SQL-D4].elit_test.dbo.at_gln )
and RetailersID in (SELECT id FROM [S-SQL-D4].elit_test.dbo.at_gln)
ORDER BY 2
--ORDER BY ImportDate desc
--check_GLN

IF 1=1
BEGIN
IF OBJECT_ID (N'fnDiffStr', N'FN') IS NOT NULL  DROP FUNCTION fnDiffStr 
IF OBJECT_ID (N'fnStrToWords') IS NOT NULL DROP FUNCTION fnStrToWords 
IF OBJECT_ID (N'fnDiffStr4', N'FN') IS NOT NULL DROP FUNCTION fnDiffStr4  

Create Function fnDiffStr(@txt1 VarChar(8000),@txt2 VarChar(8000))
returns int
as
begin

	Declare @diff int = 0
	Declare @pos int
	Declare @MaxLen int
	set @pos = 1
	
	IF LEN(@txt1) >= LEN(@txt2) SET @MaxLen = LEN(@txt1) ELSE SET @MaxLen = LEN(@txt2)

	while @pos <= @MaxLen
	Begin
		IF ISNULL(Substring(@txt1,@pos,1),'') != ISNULL(Substring(@txt2,@pos,1),'')
			set @diff = @diff + 1

		set @pos = @pos + 1
	end

	return @diff
end

/*
IF OBJECT_ID (N'fnDiffStr2', N'P') IS NOT NULL  
    DROP PROC fnDiffStr2;  
GO
CREATE PROC fnDiffStr2 @str VarChar(8000),@str2 VarChar(8000),@diff int OUTPUT
as
begin
	--Declare @diff int = 0
	select @str='select '''+replace(@str, ' ', ''' as val union all select ''')+''''
	select @str2='select '''+replace(@str2, ' ', ''' as val union all select ''')+''''
	declare @t1 table(id int identity, val varchar(100))
	declare @t2 table(id int identity, val varchar(100))
	insert into @t1	
	exec (@str)
	insert into @t2	
	exec (@str2)
	delete @t1 where val=''
	delete @t2 where val=''
	--select val from @t1
	--select val from @t2

	IF (SELECT COUNT(*) FROM @t1) >= (SELECT COUNT(*) FROM @t2)
	BEGIN
		set @diff = (SELECT SUM(kol) FROM (select (select top 1 dbo.fnDiffStr(t1.val, t2.val)  from @t2 t2 ORDER BY dbo.fnDiffStr(t1.val, t2.val) ) kol from @t1 t1) gr1)
	END
	ELSE
	BEGIN
		set @diff = (SELECT SUM(kol) FROM (select (select top 1 dbo.fnDiffStr(t2.val, t1.val)  from @t1 t1 ORDER BY dbo.fnDiffStr(t2.val, t1.val) ) kol from @t2 t2) gr1)
	END
	
	select @diff
end
*/

CREATE FUNCTION [dbo].fnStrToWords(@Filter varchar(MAX),@MinLenWord int)
RETURNS @out TABLE (AValue varchar(MAX)) AS
BEGIN
  DECLARE @i int, @ABegVal int, @AEndVal int, @APos int, @ADashInd int, @ANumber varchar(MAX)
  --SELECT @Filter = REPLACE(REPLACE(@Filter, ',', ';'), ' ', '') + ';'
  SELECT @Filter = RTRIM(LTRIM(@Filter)) + ' '
  SET @i = 1
  SET @APos = 0
  WHILE @i <= LEN(@Filter)+1
    BEGIN
      IF SUBSTRING(@Filter, @i, 1)= ' '
        BEGIN
          SELECT @ANumber = SUBSTRING(@Filter, @APos, @i - @APos)
		  If len(@ANumber) >= @MinLenWord
            INSERT @out VALUES(@ANumber)
          SET @APos = @i + 1
        END
      SET @i = @i + 1   
    END
  delete @out where  AValue = '' 
  RETURN 
END

Create Function fnDiffStr4(@str VarChar(8000),@str2 VarChar(8000),@MinLenWord int)
returns int
as
begin
	Declare @diff int = 0
	--select @str='select '''+replace(@str, ' ', ''' as val union all select ''')+''''
	--select @str2='select '''+replace(@str2, ' ', ''' as val union all select ''')+''''
	declare @t1 table(val varchar(max))
	declare @t2 table(val varchar(max))
	insert into @t1	SELECT * FROM fnStrToWords(@str,@MinLenWord)
	insert into @t2	SELECT * FROM fnStrToWords(@str2,@MinLenWord)

	IF (SELECT COUNT(*) FROM @t1) >= (SELECT COUNT(*) FROM @t2)
	BEGIN
		set @diff = (SELECT SUM(kol) FROM (select (select top 1 dbo.fnDiffStr(t1.val, t2.val)  from @t2 t2 ORDER BY dbo.fnDiffStr(t1.val, t2.val) ) kol from @t1 t1) gr1)
	END
	ELSE
	BEGIN
		set @diff = (SELECT SUM(kol) FROM (select (select top 1 dbo.fnDiffStr(t2.val, t1.val)  from @t1 t1 ORDER BY dbo.fnDiffStr(t2.val, t1.val) ) kol from @t2 t2) gr1)
	END
	
	RETURN @diff
end

END