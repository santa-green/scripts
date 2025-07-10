IF OBJECT_ID (N'f_DelEnter', N'FN') IS NOT NULL DROP FUNCTION f_DelEnter;  
GO
Create Function f_DelEnter(@txt VarChar(8000), @StrReplace VarChar(200) = '')
returns VarChar(8000)
as
begin

Declare @pos int
set @pos = len(@txt)

while @pos > 0
Begin
	IF ASCII(SUBSTRING(@txt,@pos,1)) in (10,13)
		set @txt = STUFF(@txt,@pos,1,@StrReplace)

	set @pos = @pos - 1
end
	
return @txt
end

GO


IF OBJECT_ID (N'f_FindEnter', N'FN') IS NOT NULL DROP FUNCTION f_FindEnter;  
go
Create Function f_FindEnter(@txt VarChar(8000))
returns INT
as
begin

Declare @pos int
set @pos = len(@txt)

while @pos > 0
Begin
	IF ASCII(SUBSTRING(@txt,@pos,1)) in (10,13)	return 1
	set @pos = @pos - 1
end
	
return 0
end


go
select CarName, dbo.f_DelEnter(CarName,'{ENTER}') from at_r_Drivers where dbo.f_FindEnter(CarName) = 1
select IOH_NOTE, dbo.f_DelEnter(IOH_NOTE,'{ENTER}') from at_t_IORec_Ñ where dbo.f_FindEnter(IOH_NOTE) = 1

go
Drop Function f_DelEnter
Drop Function f_FindEnter
go