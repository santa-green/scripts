use mc
declare tests cursor
for
select _m7.prodid ,_m6.prodid ,_m7.prodname
from _m7 inner join _m6 on _m7.barcode = _m6.barcode
where _m7.prodid < = 103006
order by _m7.prodid
DECLARE @OldProdID INT, @NewProdID INT , @prodname varchar(200)
open tests
FETCH NEXT FROM tests into @NewProdID ,@OldProdID , @prodname 
WHILE @@Fetch_Status = 0
BEGIN
print @NewProdID 
print @OldProdID  
print @prodname 
FETCH NEXT FROM tests into @NewProdID ,@OldProdID , @prodname 
END
CLOSE tests
DEALLOCATE tests