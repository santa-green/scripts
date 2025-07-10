DECLARE @pass as varchar(10) = '' -- пароль для ТСД

SELECT HASHBYTES('MD5', @pass)
SELECT substring(master.dbo.fn_varbintohexstr (HASHBYTES('MD5', @pass)),3 ,100)


/*
логин пароль
paa18   456  250cf8b51c773f3f8dc8b4be867a9a02
kea20   789  68053af2923e00204c3ca7c6a3150cf7
kev19   123  202cb962ac59075b964b07152d234b70
not password d41d8cd98f00b204e9800998ecf8427e
*/

SELECT * FROM dbo.it_TSD_users
