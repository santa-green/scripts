

--exec dbo.ALEF_IMPORT_PRICES;
--exec dbo.ALEF_IMPORT_REMAINS;
--exec dbo.ALEF_IMPORT_PRODUCTS
exec ALEF_IMPORT_PRODUCTS_CHECK

--���������� ������ ������
BEGIN TRAN
	exec dbo.ALEF_IMPORT_PRODUCTS @ProdCat=1, @ProdGr=16, @ProdID=35084, @ProdFullName='���� Domaine de Deux Vallees. ���� �� ���� 2018 ������� 0,75*6', @ProdShortName='���� Domaine de Deux Vallees. ���� �� ���� 2018 ��', @ProdWeight=0.75, @ProdUnit=6, @ProdFirma=2, @EAN = '3413030000723' ;
ROLLBACK TRAN

BEGIN TRAN
		exec dbo.DMT_Set_ItemsEx 1, 35084, '���� Domaine de Deux Vallees. ���� �� ���� 2018 ��','���� Domaine de Deux Vallees. ���� �� ���� 2018 ��',1, 0.75,0, 1, 20, 0, 16,null
		SELECT * FROM dbo.DS_ITEMS where iidText IN ('32649','35084')
ROLLBACK TRAN

BEGIN TRAN
		insert dbo.DS_ITEMS
		select 1006564, 35084, iid2, itID, '���� Domaine de Deux Vallees. ���� �� ���� 2018 ��','���� Domaine de Deux Vallees. ���� �� ���� 2018 ��', it2ID, GETDATE(), activeFlag, Unit2, Unit3, 0.75, NDS, sort, OwnerDistId, DistId
		from dbo.DS_ITEMS
		where iidText = 32649

		SELECT top 100 * FROM dbo.DS_ITEMS where iidText IN ('32649','35084') --���������� �������

ROLLBACK TRAN




SELECT top 100 * FROM dbo.DS_ITEMS where iidText IN ('32649','35084') --���������� �������

select * from DS_IGROUPS where IgIdText = 16 --�������� ������ �������

SELECT top 100 * FROM EDIST_Items where distItemID IN ('35084','32649') --���������� ������������

SELECT top 100 * FROM EDIST_ItemsConnections where distItemID IN ('35084','32649') --������ ����������� ������������ � ����������� �������

SELECT top 100 * FROM dbo.DS_ITEMS where iID = 100656