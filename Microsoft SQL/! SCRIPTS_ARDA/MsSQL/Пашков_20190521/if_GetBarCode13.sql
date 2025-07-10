declare @s char(13),@Note char(5),@ChID bigint = 222000028000

SELECT @s = dbo.if_GetBarCode13(222000028000)
print @s
   
	SELECT @Note = RIGHT(CAST(@ChID AS varchar(12)),5)
	print @Note