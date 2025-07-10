

--exec dbo.ALEF_IMPORT_PRICES;
--exec dbo.ALEF_IMPORT_REMAINS;
--exec dbo.ALEF_IMPORT_PRODUCTS
exec ALEF_IMPORT_PRODUCTS_CHECK

--добавление нового товара
BEGIN TRAN
	exec dbo.ALEF_IMPORT_PRODUCTS @ProdCat=1, @ProdGr=16, @ProdID=35084, @ProdFullName='Вино Domaine de Deux Vallees. Розе де Луар 2018 розовое 0,75*6', @ProdShortName='Вино Domaine de Deux Vallees. Розе де Луар 2018 ро', @ProdWeight=0.75, @ProdUnit=6, @ProdFirma=2, @EAN = '3413030000723' ;
ROLLBACK TRAN

BEGIN TRAN
		exec dbo.DMT_Set_ItemsEx 1, 35084, 'Вино Domaine de Deux Vallees. Розе де Луар 2018 ро','Вино Domaine de Deux Vallees. Розе де Луар 2018 ро',1, 0.75,0, 1, 20, 0, 16,null
		SELECT * FROM dbo.DS_ITEMS where iidText IN ('32649','35084')
ROLLBACK TRAN

BEGIN TRAN
		insert dbo.DS_ITEMS
		select 1006564, 35084, iid2, itID, 'Вино Domaine de Deux Vallees. Розе де Луар 2018 ро','Вино Domaine de Deux Vallees. Розе де Луар 2018 ро', it2ID, GETDATE(), activeFlag, Unit2, Unit3, 0.75, NDS, sort, OwnerDistId, DistId
		from dbo.DS_ITEMS
		where iidText = 32649

		SELECT top 100 * FROM dbo.DS_ITEMS where iidText IN ('32649','35084') --справочник системы

ROLLBACK TRAN




SELECT top 100 * FROM dbo.DS_ITEMS where iidText IN ('32649','35084') --справочник системы

select * from DS_IGROUPS where IgIdText = 16 --проверка группы товаров

SELECT top 100 * FROM EDIST_Items where distItemID IN ('35084','32649') --справочник дистрибутора

SELECT top 100 * FROM EDIST_ItemsConnections where distItemID IN ('35084','32649') --связка справочника дистрибутора и справочника системы

SELECT top 100 * FROM dbo.DS_ITEMS where iID = 100656