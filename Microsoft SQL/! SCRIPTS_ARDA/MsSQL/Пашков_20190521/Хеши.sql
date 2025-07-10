use master-- Сервер куда нужно преренести

declare @ServerParent nvarchar(50) ='s-sql-d4' --откуда нужно перенести
declare @UserName nvarchar(50) = 'qqqqqq' --пользователь

declare @PWD nvarchar(max)
declare @Query nvarchar(max)

set  @Query = N'SELECT @PWD = dbo.fn_varbintohexstr(cast(l.password as varbinary(256)))  from  ['+@ServerParent+'].master.[dbo].syslogins l WHERE   upper(l.name) like upper('''+ @UserName +''')';

exec sp_executesql  @Query, N'@PWD nvarchar(max) out',@PWD = @PWD out;
--print @PWD


exec( 'ALTER LOGIN '+ @UserName+' WITH CHECK_POLICY = OFF');
exec( 'ALTER LOGIN '+ @UserName+' WITH PASSWORD='+@PWD+' HASHED '); 
exec( 'ALTER LOGIN '+ @UserName+' WITH CHECK_POLICY = ON');

--------------------------------------------------------------------------
--Вывод на экран Хэша--
use master-- Сервер куда нужно преренести

declare @ServerParent nvarchar(50) ='s-sql-d3' --откуда нужно перенести
declare @UserName nvarchar(50) = 'rss0' --пользователь

declare @PWD nvarchar(max)
declare @Query nvarchar(max)

set  @Query = N'SELECT @PWD = dbo.fn_varbintohexstr(cast(l.password as varbinary(256)))  from  ['+@ServerParent+'].master.[dbo].syslogins l WHERE   upper(l.name) like upper('''+ @UserName +''')';

exec sp_executesql  @Query, N'@PWD nvarchar(max) out',@PWD = @PWD out;
print @PWD




---------------------------------------------------------------------------
--Вывод на экран Хэша текущего сервера
use master--

declare @UserName nvarchar(50) = 'sa' --пользователь kgv5 0x0100dd45072a9c214e77813debef7e203ac2cabe8ad7e0dc78c6



declare @PWD nvarchar(max)
declare @Query nvarchar(max)

set  @Query = N'SELECT @PWD = dbo.fn_varbintohexstr(cast(l.password as varbinary(256)))  from  master.[dbo].syslogins l WHERE   upper(l.name) like upper('''+ @UserName +''')';

exec sp_executesql  @Query, N'@PWD nvarchar(max) out',@PWD = @PWD out;
print @PWD

---------------------------------------------------------------------------
--Присвоение хэша--

declare @UserName nvarchar(50) = 'kgv5' --пользователь
declare @PWD nvarchar(max)


set @PWD = '0x0100dd45072a9c214e77813debef7e203ac2cabe8ad7e0dc78c6' --вставить хэш --( 0x0100fc1bc3a04bd52946002fac7fcac792c1be38c676f6c6adbd ) для пароля smeniparol


exec( 'ALTER LOGIN '+ @UserName+' WITH CHECK_POLICY = OFF');
exec( 'ALTER LOGIN '+ @UserName+' WITH PASSWORD='+@PWD+' HASHED '); 
exec( 'ALTER LOGIN '+ @UserName+' WITH CHECK_POLICY = ON');




/*
tester 0x0100ca883b1f39e7897f075b5902351e603ec463c02f51aca275  (88888888)
kiv1 0x01007b5e187a8265404de8063049dba9921214a048b294242c38
kiv15 0x0100e0d8f071852477ff157dcb65abf49b0848309a7a5b92945f
eas1 0x0100b9d8d7b259c1e3a0605ef9c8b4dc98166f825ccfea3a7651

kiv2 0x01001c419678c8e9ec962f95baf4996e32003a66d0f7a532972e
gkn1 0x0100fc1bc3a011f840ea46d4b2bf2b28ca04a5c495704026bbb3
0x0100fc1bc3a04bd52946002fac7fcac792c1be38c676f6c6adbd для пароля smeniparol
saa 0x0100376b3fa351e79b1c82ff4da8808662f6e84a0f100fd84e50
hia3 0x01001cca2dad04ac00fce0d8db0e5a8f635ccd1f75d2e53b4613
boe 0x0100b9493e551f32563e80e533af144f41017dfa0b04fb167a9d
pnv5 0x0100fc1bc3a052801160e7da76738217c1c2c03d3dc4313dd889
kgv5 0x0100dd45072a9c214e77813debef7e203ac2cabe8ad7e0dc78c6
sa	0x010031ef72cc4a1373cfd977d7793ba9ce557cb72826317e6c5f --26.04.2019-11.15
*/

SELECT  loginname,dbo.fn_varbintohexstr(cast(l.password as varbinary(256))) hash,*  from  master.[dbo].syslogins l