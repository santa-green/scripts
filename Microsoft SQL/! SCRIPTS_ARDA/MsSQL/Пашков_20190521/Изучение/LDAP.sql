/*EXEC master.dbo.sp_addlinkedserver 
    @server = N'ADSI', 
    @srvproduct=N'Active Directory Services 2.5', 
    @provider=N'ADsDSOObject', 
    @datasrc=N'adsdatasource', 
    @provstr=N'ADSDSOObject'

EXEC master.dbo.sp_addlinkedsrvlogin
    @rmtsrvname=N'ADSI',
    @useself=N'False',
    @locallogin=NULL,
    @rmtuser=N'CONST\vintagednepr1',
    @rmtpassword='dnepr20191'
*/

SELECT distinguishedName, sAMAccountName, objectGUID, objectSid, givenName, sn
FROM OPENQUERY(ADSI, 
    'SELECT sn, givenName, objectSid, objectGUID, sAMAccountName, distinguishedName FROM ''LDAP://DC=CONST,DC=alef,DC=ua'' WHERE objectClass=''User'' AND sAMAccountName = ''vintagednepr1'''
    )
AS derivedtbl_1

--EXEC master..xp_cmdshell  'ipconfig /all'

SELECT *
FROM OPENQUERY(ADSI, 
    'SELECT sn, givenName, objectSid, objectGUID, sAMAccountName, distinguishedName FROM ''LDAP://DC=CONST,DC=alef,DC=ua'' WHERE objectClass=''User''  '
    )
AS derivedtbl_12
