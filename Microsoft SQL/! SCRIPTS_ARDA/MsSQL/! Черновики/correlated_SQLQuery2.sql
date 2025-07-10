    select * 
	from dbo.ALEF_EDI_ORDERS_2 m
	where --zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) 
	NOT EXISTS (SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD) --все заказы, где gln базовый и адресный отсутствуют в реестре ALEF_EDI_GLN_OT.
    and ZEO_ORDER_NUMBER = 'O03-00022568'
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    select *, (SELECT * FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD) 
	from dbo.ALEF_EDI_ORDERS_2 m WITH(NOLOCK) 
    WHERE ZEO_ZEC_BASE = '9864232359616'

	where --zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) 
	NOT EXISTS (SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD) --все заказы, где gln базовый и адресный отсутствуют в реестре ALEF_EDI_GLN_OT.
    FOREIGN KEY

    SELECT * FROM ALEF_EDI_GLN_OT WITH(NOLOCK) WHERE ZEC_KOD_BASE = '9864232359616'
    SELECT * FROM ALEF_EDI_ORDERS_2 WITH(NOLOCK) WHERE ZEO_ZEC_BASE = '9864232359616'

    	select top(10) * 
	from dbo.ALEF_EDI_ORDERS_2 m
	where --zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) 
	NOT EXISTS (SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD) --все заказы, где gln базовый и адресный отсутствуют в реестре ALEF_EDI_GLN_OT.

    SELECT * FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = '9864232359616' and s1.ZEC_KOD_ADD = '9864232293224'
    SELECT * FROM ALEF_EDI_ORDERS_2 WITH(NOLOCK) WHERE ZEO_ZEC_BASE = '9864232359616' and ZEO_ZEC_ADD = '9864232293224'

        	select top(10) * 
	SELECT * FROM dbo.ALEF_EDI_ORDERS_2 m WITH(NOLOCK) WHERE ZEO_ZEC_BASE = '9864232191612' and ZEO_ZEC_ADD = '9863521025218'
    SELECT * FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = '9864232191612' and s1.ZEC_KOD_ADD = '9863521025218'
    SELECT * FROM dbo.ALEF_EDI_ORDERS_2 m WITH(NOLOCK) WHERE ZEO_ORDER_NUMBER = 'O03-00022568'