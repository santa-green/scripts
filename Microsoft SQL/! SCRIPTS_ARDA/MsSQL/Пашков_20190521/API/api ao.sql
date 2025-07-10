Declare @Object as Int;
Declare @ResponseText as Varchar(8000);
--Declare @test as Varchar(8000);
DECLARE @url varchar(300)  
DECLARE @win int 
DECLARE @hr  int 
SET @url = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/products.xml'
--SET @url = 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/customers.xml'

declare @test nvarchar (4000)
declare @bin as binary(8000)


--Code Snippet
--https://{username}:{password}@{shop}.myshopify.com/admin/{resource}.json
--https://38b3692b6b48a9712b8d909c46e6208d:c2dc0abbdef5825da69ee1647962ce2d@example.myshopify.com/admin/products.json
/*
Вот данные по апи:
API_KEY 4a31bd883165bfd2bb8932c6287e7b9c
Pass 6bab3199775c589f2922cd5bdb48a10b
url - https://vintagemarket-dev.myshopify.com/
name - vintagemarket-dev  
*/
	EXEC @hr=sp_OACreate 'MSXML2.XMLHTTP',@win OUT 
	IF @hr <> 0 EXEC sp_OAGetErrorInfo @win 
	
	EXEC @hr=sp_OAMethod @win, 'Open',null,'GET',@url,'false'
	IF @hr <> 0 EXEC sp_OAGetErrorInfo @win 

 --EXEC @hr=sp_OAMethod @win,N'setRequestHeader',NULL, 'Content-type', 'application/x-www-form-urlencoded; charset=UTF-8'
 --	IF @hr <> 0 EXEC sp_OAGetErrorInfo @win

  EXEC @hr=sp_OAMethod @win,'Send'
	IF @hr <> 0 EXEC sp_OAGetErrorInfo @win 
		
 EXEC @hr=sp_OAGetProperty   @win,'ResponseText', @test output
	IF @hr <> 0 EXEC sp_OAGetErrorInfo @win 

	--EXEC @hr=sp_OAGetProperty @win,'ResponseText', @test output
	--IF @hr <> 0 EXEC sp_OAGetErrorInfo @win

	EXEC @hr=sp_OADestroy @win 
	IF @hr <> 0 EXEC sp_OAGetErrorInfo @win 

	select @test as ff
	select @bin as nc




--Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
--Exec sp_OAMethod @Object, 'open', NULL, 'POST',
--                 'https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/products.json', --Your Web Service Url (invoked)
--                 'false'
--Exec sp_OAMethod @Object, 'send'
--Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

--Select @ResponseText

--Exec sp_OADestroy @Object