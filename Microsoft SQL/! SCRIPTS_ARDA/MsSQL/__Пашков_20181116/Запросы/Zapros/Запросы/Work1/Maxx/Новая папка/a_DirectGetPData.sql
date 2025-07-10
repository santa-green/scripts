create procedure dbo.a_DirectGetPData
@Server varchar(64), @DBName varchar(64), 
@User varchar(64), @Pass varchar(64), @VenID int
as begin
declare @SQL varchar(2048), @OurID varchar(16), @StockID varchar(16),
@SecIDs varchar(1024), @SecID varchar(16)
select @OurID=OurID from a_Ven where VenID=@VenID
select @StockID=StockID from a_Ven where VenID=@VenID

declare Sections cursor for
select distinct va.SecID from a_VenA va inner join a_Ven v
on v.ChID=va.ChID where v.VenID=@VenID
OPEN Sections
FETCH Next FROM Sections INTO @SecID
select @SecIDs=null
WHILE @@FETCH_STATUS=0 BEGIN
select @SecIDs=case when @SecIDs is not null 
then @SecIDs+','+@SecID else @SecID end
FETCH Next FROM Sections INTO @SecID
end
close Sections
deallocate Sections

delete from a_VenResult where VenID=@VenID

select @SQL='insert into a_VenResult(VenID, ProdID, VenPrice, PQty) '+
'SELECT * FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''select '+cast(@VenID as varchar(16))+
' as VenID, ProdID, isnull((select top 1 PriceCC_In from '+
@DBName+'.dbo.t_Pinp pp with (nolock) where pp.ProdID=ProdID '+
'and PriceCC_In<>0 order by PPID desc), 0) as VenPrice, '+
'isnull((select Sum(Qty) from '+@DBName+'.dbo.t_Rem r where r.OurID='+
@OurID+' and r.StockID='+@StockID+' and r.SecID in ('+@SecIDs+') '+
'and r.ProdID=p.ProdID), 0) as PQty '+
'from '+@DBName+'.dbo.r_Prods p order by ProdID'')'
execute(@SQL)

end


GO
