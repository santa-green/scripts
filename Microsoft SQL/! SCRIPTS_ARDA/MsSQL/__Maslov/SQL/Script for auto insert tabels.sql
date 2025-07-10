begin tran;

if (SELECT SUBSTRING((SELECT   ',' + TableName as [text()] FROM ElitR_316.dbo.z_Tables
for XML PATH('')),2,65535)) = (SELECT SUBSTRING((SELECT   ',' + TableName as [text()] FROM ElitR_316.dbo.z_Tables
for XML PATH('')),2,65535))


print N'Everything is fine'
else
print N'Dat was bad'


ROLLBACK TRAN;