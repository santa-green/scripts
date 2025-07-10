
setuser 'rly'

select IS_SRVROLEMEMBER('sysadmin') 
		select IS_MEMBER('ƒнепр Ёкономист') 
		select IS_MEMBER(' иев Ёкономист') 
		select IS_MEMBER('’арьков Ёкономист')
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
	OR ISNULL( IS_MEMBER('ƒнепр Ёкономист')   ,0) = 1
	OR ISNULL( IS_MEMBER(' иев Ёкономист')    ,0) = 1
	OR ISNULL( IS_MEMBER('’арьков Ёкономист') ,0) = 1
	OR SUSER_SNAME() IN ('paa18', 'rnu')
	  PRINT '”словие выполн€етс€ дл€ ' + SUSER_SNAME()
	ELSE
    BEGIN
      RAISERROR('[a_tIORes_IS_U] ¬Ќ»ћјЌ»≈!!! »зменение документа запрещено, так как дл€ данного заказа отпечатан фискальный чек!!!', 18, 1)
      ROLLBACK
      RETURN
    END
  