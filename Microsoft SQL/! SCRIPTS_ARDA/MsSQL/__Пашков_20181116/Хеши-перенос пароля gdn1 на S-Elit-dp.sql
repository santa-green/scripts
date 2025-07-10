use master-- Сервер куда нужно преренести

declare @ServerParent nvarchar(50) ='S-SQL-D4' --откуда нужно перенести
declare @UserName nvarchar(50) = 'gdn1' --пользователь

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

declare @ServerParent nvarchar(50) ='S-SQL-D4' --откуда нужно перенести
--declare @ServerParent nvarchar(50) ='S-sql-d4' --откуда нужно перенести
declare @UserName nvarchar(50) = 'gdn1' --пользователь

declare @PWD nvarchar(max)
declare @Query nvarchar(max)

set  @Query = N'SELECT @PWD = dbo.fn_varbintohexstr(cast(l.password as varbinary(256)))  from  ['+@ServerParent+'].master.[dbo].syslogins l WHERE   upper(l.name) like upper('''+ @UserName +''')';

exec sp_executesql  @Query, N'@PWD nvarchar(max) out',@PWD = @PWD out;
print @PWD

---------------------------------------------------------------------------
--Присвоение хэша--

declare @UserName nvarchar(50) = 'gdn1' --пользователь
declare @PWD nvarchar(max)

set @PWD = '0x0100fff71dbe1307990c35f459d2aa6903bf54bd12496a356fed' --вставить хэш 88888888

exec( 'ALTER LOGIN '+ @UserName+' WITH CHECK_POLICY = OFF');
exec( 'ALTER LOGIN '+ @UserName+' WITH PASSWORD='+@PWD+' HASHED '); 
exec( 'ALTER LOGIN '+ @UserName+' WITH CHECK_POLICY = ON');

-- хеш 88888888 0x0100fff71dbe1307990c35f459d2aa6903bf54bd12496a356fed