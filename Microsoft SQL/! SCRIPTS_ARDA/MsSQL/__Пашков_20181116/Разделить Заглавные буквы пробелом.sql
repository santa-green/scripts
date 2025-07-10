--Разделить Заглавные буквы пробелом

IF OBJECT_ID (N'fnExtNum', N'FN') IS NOT NULL  
    DROP FUNCTION fnExtNum;  
GO
Create Function fnExtNum(@txt VarChar(8000))
returns VarChar(8000)
as
BEGIN

	Declare @pos int, @new_txt VarChar(8000) = ''
	set @pos = 1

	while @pos <= len(@txt)
	Begin
		IF (Substring(@txt,@pos,1)  COLLATE Cyrillic_General_BIN  LIKE '[А-Я,A-Z,Ё,І,Є,Ї,Ґ]%') 
			SET @new_txt = @new_txt + ' ' + Substring(@txt,@pos,1)
			ELSE SET @new_txt = @new_txt +  Substring(@txt,@pos,1)

		SET @pos = @pos + 1
	End

	SET @new_txt = REPLACE(@new_txt,'  ',' ')--удалить двойные пробелы

	RETURN LTRIM(RTRIM(@new_txt))
END

go
/*
СобкаІнна Олегівна
ТретякЄвген Юрійович
*/
--SELECT dbo.fnExtNum('ТестФункции')

SELECT ClientName, dbo.fnExtNum(ClientName) new FROM r_DCards where ClientName not like '% %' and ClientName <> '' and LEN(ClientName) > 13
ORDER BY LEN(ClientName) 


BEGIN TRAN

update r_DCards 
SET ClientName = dbo.fnExtNum(ClientName)
FROM r_DCards where ClientName not like '% %' and ClientName <> '' and LEN(ClientName) > 13

SELECT ClientName, dbo.fnExtNum(ClientName) new FROM r_DCards where ClientName not like '% %' and ClientName <> '' and LEN(ClientName) > 13
ORDER BY LEN(ClientName) 

ROLLBACK TRAN 
IF @@TRANCOUNT > 0 COMMIT TRAN


go
Drop Function fnExtNum
go


--SELECT *
--FROM fn_helpcollations()