
setuser 'rly'

select IS_SRVROLEMEMBER('sysadmin') 
		select IS_MEMBER('����� ���������') 
		select IS_MEMBER('���� ���������') 
		select IS_MEMBER('������� ���������')
		select SUSER_SNAME()

if (0=1 or 0=1 or 0=1 or  0 = 1) and 1=1
print 'yes'
else
print 'no'

if SUSER_SNAME() IN ('paa18', 'rnu')
print 'yes'
else
print 'no'


IF     ISNULL( IS_SRVROLEMEMBER('sysadmin')   ,0) = 1 
	OR ISNULL( IS_MEMBER('����� ���������')   ,0) = 1
	OR ISNULL( IS_MEMBER('���� ���������')    ,0) = 1
	OR ISNULL( IS_MEMBER('������� ���������') ,0) = 1
	OR SUSER_SNAME() IN ('paa18', 'rnu')
	  PRINT '������� ����������� ��� ' + SUSER_SNAME()
	ELSE
    BEGIN
      RAISERROR('[a_tIORes_IS_U] ��������!!! ��������� ��������� ���������, ��� ��� ��� ������� ������ ��������� ���������� ���!!!', 18, 1)
      ROLLBACK
      RETURN
    END
  