drop table Files

CREATE TABLE Files
(
  FileId int,
  FileData varbinary(max)
)

DECLARE @b varbinary(max)--= 0x0102
DECLARE @S varchar(max)= '0xffffffff000102'

set @b = CONVERT(varbinary(max),@S,1)

SELECT @b, @S

--insert into Files (FileId, FileData) values (1, 0x010203040506)

insert Files
SELECT 1, @S --cast(@S as varbinary(256))

--SELECT sys.fn_varbintohexstr(0x010203040506)
--SELECT sys.fn_hexstrtovarbin('0x0102030405069089')

SELECT * FROM Files


