CREATE   procedure dbo.a_ImportPData
@Server nvarchar(64), @DBName nvarchar(64), 
@User nvarchar(64), @Pass nvarchar(64), @VenID INt
as begIN
declare @SQL nvarchar(2048), @OurID nvarchar(16), @StockIDs nvarchar(1024),
@SecIDs nvarchar(1024)

SELECT DISTINCT @OurID=OurID FROM a_Ven WHERE VenID=@VenID

SELECT @StockIDs=''
SELECT @StockIDs=@StockIDs+','+CAST(StockID AS nvarchar(16)) FROM (SELECT DISTINCT StockID FROM a_Ven WHERE VenID=@VenID) x
SELECT @StockIDs=RIGHT(@StockIDs,LEN(@StockIDs)-1)

SELECT @SecIDs=''
SELECT @SecIDs=@SecIDs+','+CAST(SecID AS nvarchar(16)) FROM (SELECT DISTINCT SecID FROM a_VenA a INNER JOIN a_Ven m ON a.QID=m.QID WHERE m.VenID=@VenID) x
SELECT @SecIDs=RIGHT(@SecIDs,LEN(@SecIDs)-1)

DELETE FROM a_VenResult WHERE VenID=@VenID

SELECT @SQL='INsert INto a_VenResult(VenID, ProdID, VenPrice, PQty) '+
'SELECT * FROM OPENROWSET(''SQLOLEDB'', '''+
@Server+'''; '''+@User+'''; '''+@Pass+
''', ''SELECT '+cast(@VenID as nvarchar(16))+
' as VenID, ProdID, isnull((SELECT top 1 PriceCC_IN FROM '+
@DBName+'.dbo.t_PINp pp with (nolock) WHERE pp.ProdID=p.ProdID '+
'AND PriceCC_IN<>0 order by PPID desc), 0) as VenPrice, '+
'isnull((SELECT Sum(Qty) FROM '+@DBName+'.dbo.t_Rem r WHERE r.OurID='+
@OurID+' AND r.StockID IN ('+@StockIDs+') AND r.SecID IN ('+@SecIDs+') '+
'AND r.ProdID=p.ProdID), 0) as PQty '+
'FROM '+@DBName+'.dbo.r_Prods p order by ProdID'')'
execute(@SQL)

end
GO
