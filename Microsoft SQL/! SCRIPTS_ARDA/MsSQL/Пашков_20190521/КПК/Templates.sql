
-- ������� ����� ����:

select *
from D_Options;

�ttr:128 (�������) default
�ttr:561 (����/�������) default

exec DMT_Set_Option 128,'���',null,null,305664  -- ��������� �������� �� ���������
exec DMT_Set_Option 9,'���� ����',null,null,null -- ����� ������ ��������� � ����������
exec DMT_Set_Option 19,0,null,null,0  -- ����� ������� � ����� ��������
exec DMT_Set_Option 20,3,null,null,3  -- ���� ��������� ����������� ������: ��������� -- ������ -- �����
exec DMT_Set_Option 832,1,null,null,1 -- ���������� ���������� ���� ���������� � ����������
exec DMT_Set_Option 745,1,null,null,1 -- �������� ������ ��������� ��������������� � ������
exec DMT_Set_Option 112,0,null,null,0 -- ������� �� ������� �������������
exec DMT_Set_Option 82,2,null,null,2 -- ��������� ��������� ����������� ��������� �������
exec DMT_Set_Option 761,1,null,null,1 -- ��������� �������������� ������ �� ����� ������

exec dbo.DMT_Set_Attribute @ExAttrId='600', @AttrID=600, @AttrTypeID=1, @AttrName='�����������', @AttrSystemFlag=2080, @ActiveFlag=1, @Sort=null, @OtherFields=null -- �������� �������� "�����������"
exec dbo.DMT_Set_AttributeValueEx @AttrID=600, @ExAttrId='600', @AttrValueID=null, @AttrValueName='���� ��������', @ExAttrValueId='1', @AttrValueSystemFlag=1002, @ActiveFlag=1, @OtherFields=null
exec dbo.DMT_Set_AttributeValueEx @AttrID=600, @ExAttrId='600', @AttrValueID=null, @AttrValueName='���� ���', @ExAttrValueId='3', @AttrValueSystemFlag=1002, @ActiveFlag=1, @OtherFields=null 


exec dbo.DMT_Set_ClientEx @exid='61077', @exidRep='4367', @activeFlag=1, @name='���������� �.�. ��', @ShortName='���������� �.�.', @Address='���. ������, 1/7', @inn='', @ftype=10, @exidOwner='61077', @fcomment='', @OKPO='', @OKONH=''
exec dbo.DMT_Set_ClientEx @exid='0061077001', @exidRep='4367', @activeFlag=1, @name='���������� �.�. �� (�������� 24 ������)/��. �����, 54�', @ShortName='���������� �.�./��. �����, 54�', @Address='�. ���������������, ��. �����, 54�', @inn='', @ftype=1, @exidOwner='61077', @fcomment='', @OKPO='', @OKONH=''


exec DMT_Set_Option 302,'225;',null,null,null -- ����� ������ ��������� � ����������
exec DMT_Set_Option 1029,'{Item.Name}\n{Is:Prices}{����: {OrItem.Cost} ���. �����: {Or.Sum} ���.\n}',null,null,null

exec dbo.DMT_Set_FirmEx @exid='1', @activeFlag=1, @Name='���� ��������', @ShortName='���� ��������', @Address='52500, �.������������, ���.����, �.29, ��.28', @Prefix='arda', @UrAddress='52500, �.������������, ���.����, �.29, ��.28', @inn='370295404124'
exec dbo.DMT_Set_FirmEx @exid='3', @activeFlag=1, @Name='���� ���', @ShortName='���� ���', @Address='49083, �.��������������, ���.���i����, �.1', @Prefix='aqua', @UrAddress='49083, �.��������������, ���.���i����, �.1', @inn='368410304616'

-- �������� ������� ��������� 
exec DMT_Set_ClientRouteEx @RepIDD='140', @ClientIDD='0002570001A', @PlaneDate='20120606', @Ord=null, @Period=null, @ActiveFlag=2

-- �������� ����������� ��������� 
exec DMT_Set_ClientService @ServiceExId='0040607001A-20120716', @FidExId='0040607001A', @StartDate='20120716', @EndDate='20500101', @Period=7, @ReqTimeBegin='09:00:00', @ReqTimeEnd=null, @Options=null, @ActiveFlag=1
exec DMT_Set_ServiceMatrix @MasterFidExId='547', @ServiceExId='0040607001A-20120716', @StartDate='20120716', @EndDate='20500101', @ReqTimeBegin='09:00:00', @ReqTimeEnd=null, @ActiveFlag=1
-- �������� ����������� ��������� 
Exec DSFS_Set_ServiceMatrix @SMID=1990349, @MasterFid=1003206, @ServiceId=1014239, @Startdate=null, @EndDate=null, @ReqTimeBegin=null, @ReqTimeEnd=null, @ActiveFlag=0, @OwnerDistId=1
exec DMT_Set_ClientService @ServiceExId='0040607001A-20120716', @FidExId='0040607001A', @StartDate=null, @EndDate=null, @Period=null, @ReqTimeBegin=null, @ReqTimeEnd=null, @Options=null, @ActiveFlag=0

---------------------------------------------------------

-- ������� ������ ���������;

select *
from dbo.DS_UnitTypes;

exec DMT_Set_UnitEx null,'11','�������','���.','�������',1
exec DMT_Set_UnitEx null,'21','�����','���.','�����',1
exec DMT_Set_UnitEx null,'31','����','����','����',1
exec DMT_Set_UnitEx null,'41','�����','��.','�����',1
exec DMT_Set_UnitEx null,'51','�����','���.','�����',1
exec DMT_Set_UnitEx null,'12','����','��.','����',1
exec DMT_Set_UnitEx null,'22','��������','��.','��������',1

----------------------------------------------------------

-- ������� ��������� ������;

select *
from dbo.DS_ITYPES

exec DMT_Set_ItemTypes '11','��������',1
exec DMT_Set_ItemTypes '3','������',1
exec DMT_Set_ItemTypes '1','����',1
exec DMT_Set_ItemTypes '19','���� ������.',1
exec DMT_Set_ItemTypes '18','���� ����.',1
exec DMT_Set_ItemTypes '4','�����',1
exec DMT_Set_ItemTypes '21','����',1
exec DMT_Set_ItemTypes '2','�����',1
exec DMT_Set_ItemTypes '12','������',1
exec DMT_Set_ItemTypes '6','����',1
exec DMT_Set_ItemTypes '10','���������',1
exec DMT_Set_ItemTypes '9','������',1
exec DMT_Set_ItemTypes '8','������',1
exec DMT_Set_ItemTypes '5','�����',1
exec DMT_Set_ItemTypes '20','����� �����.',1
exec DMT_Set_ItemTypes '16','���',1
exec DMT_Set_ItemTypes '22','�����',1
exec DMT_Set_ItemTypes '15','������',1
exec DMT_Set_ItemTypes '23','���',1
exec DMT_Set_ItemTypes '29','����',1
exec DMT_Set_ItemTypes '97','���������� �������',1
exec DMT_Set_ItemTypes '501','�����',1

----------------------------------------------------------

-- ������� ����� ������;

select *
from  DS_IGroups 

exec DMT_Set_ItemGroups '1101','�����',1
exec DMT_Set_ItemGroups '305','�����',1
exec DMT_Set_ItemGroups '302','�������',1
exec DMT_Set_ItemGroups '300','�����',1
exec DMT_Set_ItemGroups '172','����������� ����',1
exec DMT_Set_ItemGroups '192','�������',1
exec DMT_Set_ItemGroups '112','�����',1
exec DMT_Set_ItemGroups '133','������ � ������',1
exec DMT_Set_ItemGroups '161','����� ��������',1
exec DMT_Set_ItemGroups '27','��������� ������',1
exec DMT_Set_ItemGroups '132','������� ������',1
exec DMT_Set_ItemGroups '101','���� ����',1
exec DMT_Set_ItemGroups '103','����� ��� & ��c',1
exec DMT_Set_ItemGroups '169','����� �����',1
exec DMT_Set_ItemGroups '141','��������',1
exec DMT_Set_ItemGroups '105','�������',1
exec DMT_Set_ItemGroups '165','�� ���� �����',1
exec DMT_Set_ItemGroups '94','������� ������',1
exec DMT_Set_ItemGroups '178','�������� �� �������',1
exec DMT_Set_ItemGroups '114','���� ������',1
exec DMT_Set_ItemGroups '153','�������� �����',1
exec DMT_Set_ItemGroups '179','��������',1
exec DMT_Set_ItemGroups '191','�����',1
exec DMT_Set_ItemGroups '147','��������',1
exec DMT_Set_ItemGroups '106','��� �������',1
exec DMT_Set_ItemGroups '104','��� ������ ����� �����',1
exec DMT_Set_ItemGroups '187','���������',1
exec DMT_Set_ItemGroups '168','��������',1
exec DMT_Set_ItemGroups '108','�� ����',1
exec DMT_Set_ItemGroups '26','�������� ��������� ��������',1
exec DMT_Set_ItemGroups '124','��������',1
exec DMT_Set_ItemGroups '152','���-������ ������',1
exec DMT_Set_ItemGroups '184','�� �����',1
exec DMT_Set_ItemGroups '166','�� ������',1
exec DMT_Set_ItemGroups '122','���� �����',1
exec DMT_Set_ItemGroups '195','������� �����',1
exec DMT_Set_ItemGroups '125','�������',1
exec DMT_Set_ItemGroups '134','������',1
exec DMT_Set_ItemGroups '149','���� ����� �������',1
exec DMT_Set_ItemGroups '190','�������',1
exec DMT_Set_ItemGroups '176','���� �� ������',1
exec DMT_Set_ItemGroups '175','������� �� �����',1
exec DMT_Set_ItemGroups '142','������ �� �������',1
exec DMT_Set_ItemGroups '131','������ �� ������',1
exec DMT_Set_ItemGroups '30','������ ������',1
exec DMT_Set_ItemGroups '99','���� ����',1
exec DMT_Set_ItemGroups '164','����� �������',1
exec DMT_Set_ItemGroups '127','������� �����',1
exec DMT_Set_ItemGroups '98','��������',1
exec DMT_Set_ItemGroups '174','������ ���������',1
exec DMT_Set_ItemGroups '109','��������',1
exec DMT_Set_ItemGroups '160','��������',1
exec DMT_Set_ItemGroups '173','����������',1
exec DMT_Set_ItemGroups '197','������',1
exec DMT_Set_ItemGroups '102','������ ����',1
exec DMT_Set_ItemGroups '171','����� �����',1
exec DMT_Set_ItemGroups '25','����� ��������',1
exec DMT_Set_ItemGroups '93','����� ����',1
exec DMT_Set_ItemGroups '100','������� �����',1
exec DMT_Set_ItemGroups '151','���������',1
exec DMT_Set_ItemGroups '126','��������� �������',1
exec DMT_Set_ItemGroups '170','�������',1
exec DMT_Set_ItemGroups '123','����',1
exec DMT_Set_ItemGroups '162','������ ��� �������',1
exec DMT_Set_ItemGroups '130','��� ����� ��������',1
exec DMT_Set_ItemGroups '145','�������',1
exec DMT_Set_ItemGroups '92','���������',1
exec DMT_Set_ItemGroups '28','������� ������',1
exec DMT_Set_ItemGroups '107','����� �����',1
exec DMT_Set_ItemGroups '150','����� ��������',1
exec DMT_Set_ItemGroups '185','����� �����������',1
exec DMT_Set_ItemGroups '163','�����',1
exec DMT_Set_ItemGroups '430','�����',1
exec DMT_Set_ItemGroups '407','��������� �����',1
exec DMT_Set_ItemGroups '408','�������� ���',1
exec DMT_Set_ItemGroups '402','����������� ������.',1
exec DMT_Set_ItemGroups '429','������',1
exec DMT_Set_ItemGroups '400','����� ���������',1
exec DMT_Set_ItemGroups '412','���� ���',1
exec DMT_Set_ItemGroups '428','���������',1
exec DMT_Set_ItemGroups '410','���������',1
exec DMT_Set_ItemGroups '2104','�����',1
exec DMT_Set_ItemGroups '2100','�����',1
exec DMT_Set_ItemGroups '203','�������',1
exec DMT_Set_ItemGroups '201','���������',1
exec DMT_Set_ItemGroups '205','���� ���',1
exec DMT_Set_ItemGroups '1200','������',1
exec DMT_Set_ItemGroups '606','������',1
exec DMT_Set_ItemGroups '600','��������',1
exec DMT_Set_ItemGroups '1901','�������',1
exec DMT_Set_ItemGroups '167','���������',1
exec DMT_Set_ItemGroups '141','��������',1
exec DMT_Set_ItemGroups '19','���� ���� ������',1
exec DMT_Set_ItemGroups '1000','��� �������',1
exec DMT_Set_ItemGroups '900','�������',1
exec DMT_Set_ItemGroups '901','����',1
exec DMT_Set_ItemGroups '814','�����',1
exec DMT_Set_ItemGroups '820','���� �� ���',1
exec DMT_Set_ItemGroups '800','���� �������',1
exec DMT_Set_ItemGroups '811','��',1
exec DMT_Set_ItemGroups '803','���������',1
exec DMT_Set_ItemGroups '810','���� ������',1
exec DMT_Set_ItemGroups '505','���������',1
exec DMT_Set_ItemGroups '500','�� ������',1
exec DMT_Set_ItemGroups '518','����������',1
exec DMT_Set_ItemGroups '502','����������',1
exec DMT_Set_ItemGroups '501','�������',1
exec DMT_Set_ItemGroups '519','���� ������',1
exec DMT_Set_ItemGroups '2002','����� ��������',1
exec DMT_Set_ItemGroups '1600','�������',1
exec DMT_Set_ItemGroups '2201','�����',1
exec DMT_Set_ItemGroups '1512','������ �����',1
exec DMT_Set_ItemGroups '1501','�����',1
exec DMT_Set_ItemGroups '1506','������',1
exec DMT_Set_ItemGroups '2902','�����',1
exec DMT_Set_ItemGroups '2905','������',1
exec DMT_Set_ItemGroups '2901','�����',1
exec DMT_Set_ItemGroups '2301','�����',1
exec DMT_Set_ItemGroups '2302','�������',1
exec DMT_Set_ItemGroups '1800','�����',1
exec DMT_Set_ItemGroups '9700','��� ������',1
exec DMT_Set_ItemGroups '3000','����� �����',1


select *
from  DS_IGroups 
exec DMT_Set_ItemGroups '553','����� ������',1
-----------------------------------------------------------------

-- ������� �������;

select *
from dbo.DS_ITEMS


declare @Cat int
declare @Pid int
declare @ProdN nvarchar(100)
declare @ProdSN nvarchar(50)
declare @W money
declare @UM int
declare @Tax money
declare @Gr int

declare importProdsFromOT cursor
FOR select PCatID,prodid,left(ProdName,100) full_name,'*NEW* ' + left(ProdName,42) short_name,[Weight],isnull((select Qty from [s-sql-d4].elit.dbo.r_ProdMQ q where UM = '��.' and q.ProdID = p.ProdID),1) um, TaxPercent, PGrID
from [s-sql-d4].elit.dbo.r_prods p
where PCatID in (
	select ItIdText
	from dbo.DS_ITYPES
	where isnumeric(ItIdText) = 1)
and PGrID in (
	select IgIdText
	from DS_IGroups
	where isnumeric(IgIdText) = 1)
and not exists(select * from dbo.DS_ITEMS where itID <> 21 and iidText = p.prodid)
and exists(select SUM(Qty) from [s-sql-d4].elit.dbo.t_Rem r where r.prodid = p.prodid and OurID in (1,3) and stockid in (select cast(left(exid,3) as tinyint) from dbo.DS_FACES where fType = 6) having SUM(Qty) > 0)
and exists(select * from [s-sql-d4].elit.dbo.r_ProdMP mp where plid in (24,25,26) and mp.prodid = p.prodid and pricemc > 0)

OPEN importProdsFromOT
FETCH NEXT FROM importProdsFromOT INTO @Cat, @Pid, @ProdN, @ProdSN, @W, @UM, @Tax, @Gr

WHILE @@fetch_status=0
BEGIN

exec DMT_Set_ItemsEx @exidType=@Cat, @exid=@Pid, @iName=@ProdN, @iShortname=@ProdSN, @activeFlag=0, @weight=@W, @unit3=@UM, @VAT=@Tax, @sort=0, @exidGroup=@Gr;

FETCH NEXT FROM importProdsFromOT INTO @Cat, @Pid, @ProdN, @ProdSN, @W, @UM, @Tax, @Gr
END

CLOSE importProdsFromOT
DEALLOCATE importProdsFromOT


--------------------------------------------------------------------

-- ������� �������;

select *
from dbo.DS_FACES
where fType = 6

exec DMT_Set_StoreEx @ExId='135', @ActiveFlag=1, @Name='����� ������� 135', @ShortName='������� 135';
exec DMT_Set_StoreEx @ExId='123', @ActiveFlag=1, @Name='����� ������ 123', @ShortName='������ 123';
exec DMT_Set_StoreEx @ExId='124', @ActiveFlag=1, @Name='����� ��������� 124', @ShortName='��������� 124';
exec DMT_Set_StoreEx @ExId='134', @ActiveFlag=1, @Name='����� ���� 134', @ShortName='���� 134';
exec DMT_Set_StoreEx @ExId='136', @ActiveFlag=1, @Name='����� ������� 136', @ShortName='������� 136';
exec DMT_Set_StoreEx @ExId='138', @ActiveFlag=1, @Name='����� �������� 138', @ShortName='�������� 138';
exec DMT_Set_StoreEx @ExId='181', @ActiveFlag=1, @Name='����� ���� 181', @ShortName='���� 181';
exec DMT_Set_StoreEx @ExId='184', @ActiveFlag=1, @Name='����� ��.�����. 184', @ShortName='��.-�����. 184';
exec DMT_Set_StoreEx @ExId='185', @ActiveFlag=1, @Name='����� �������� 185', @ShortName='�������� 185';
exec DMT_Set_StoreEx @ExId='197', @ActiveFlag=1, @Name='����� ������� 197', @ShortName='������� 197';
exec DMT_Set_StoreEx @ExId='4', @ActiveFlag=1, @Name='����� ����� 004', @ShortName='����� 004';
exec DMT_Set_StoreEx @ExId='28', @ActiveFlag=1, @Name='����� ����. 028', @ShortName='����. 028';
exec DMT_Set_StoreEx @ExId='27', @ActiveFlag=1, @Name='����� ����� 027', @ShortName='����� 027';
exec DMT_Set_StoreEx @ExId='30', @ActiveFlag=1, @Name='����� ���� 030', @ShortName='���� 030';
exec DMT_Set_StoreEx @ExId='24', @ActiveFlag=1, @Name='����� ��������� 024', @ShortName='��������� 024';
exec DMT_Set_StoreEx @ExId='11', @ActiveFlag=1, @Name='����� ������� 011', @ShortName='������� 011';
exec DMT_Set_StoreEx @ExId='23', @ActiveFlag=1, @Name='����� ������ 023', @ShortName='������ 023';
exec DMT_Set_StoreEx @ExId='29', @ActiveFlag=1, @Name='����� ������ 029', @ShortName='������ 029';
exec DMT_Set_StoreEx @ExId='35', @ActiveFlag=1, @Name='����� ������� 035', @ShortName='������� 035';
exec DMT_Set_StoreEx @ExId='38', @ActiveFlag=1, @Name='����� �������� 038', @ShortName='�������� 038';
exec DMT_Set_StoreEx @ExId='81', @ActiveFlag=1, @Name='����� ���� 081', @ShortName='���� 081';
exec DMT_Set_StoreEx @ExId='84', @ActiveFlag=1, @Name='����� ��.-�����. 084', @ShortName='��.-�����. 084';
exec DMT_Set_StoreEx @ExId='85', @ActiveFlag=1, @Name='����� �������� 085', @ShortName='�������� 085';
exec DMT_Set_StoreEx @ExId='36', @ActiveFlag=1, @Name='����� ������� 036', @ShortName='������� 036';
exec DMT_Set_StoreEx @ExId='53', @ActiveFlag=1, @Name='����� ���� 053', @ShortName='���� 053';
exec DMT_Set_StoreEx @ExId='130', @ActiveFlag=1, @Name='����� ���� 130', @ShortName='���� 130';
exec DMT_Set_StoreEx @ExId='111', @ActiveFlag=1, @Name='����� ������� 111', @ShortName='������� 111';
exec DMT_Set_StoreEx @ExId='129', @ActiveFlag=1, @Name='����� ������ 129', @ShortName='������ 129';
exec DMT_Set_StoreEx @ExId='104', @ActiveFlag=1, @Name='����� ����� 104', @ShortName='����� 104';
exec DMT_Set_StoreEx @ExId='204', @ActiveFlag=1, @Name='����� ����� 204', @ShortName='����� 204';
exec DMT_Set_StoreEx @ExId='127', @ActiveFlag=1, @Name='����� ����� 127', @ShortName='����� 127';
exec DMT_Set_StoreEx @ExId='97', @ActiveFlag=1, @Name='����� ������� 097', @ShortName='������� 097';
exec DMT_Set_StoreEx @ExId='128', @ActiveFlag=1, @Name='����� ����. 128', @ShortName='����. 128';
exec DMT_Set_StoreEx @ExId='20', @ActiveFlag=1, @Name='����� �����. 020', @ShortName='�����. 020';

----------------------------------------------------------------------------------------

-- ������� �������� �� �������;

select *
from dbo.DS_Amounts


declare @exid_a nvarchar(50)
declare @prd_a nvarchar(50) 
declare @rem_a decimal(19,9)
declare rem_import cursor
for select exid, prd, isnull(Qty,0) AS rem
from
	(select exid, cast(left(exid,3) as tinyint) stck, cast(right(exid,1) as tinyint) firm, cast(iidText as int) prd
	from dbo.DS_Faces, dbo.DS_ITEMS
	where factiveflag = 1
	and ftype = 6
	and activeFlag = 1) as T1
left join 
	(SELECT StockID, OurID, ProdID, cast(SUM(Qty-AccQty)as int) Qty
	FROM [s-sql-d4].Elit.dbo.t_Rem
	WHERE OurID IN (1,3)
	AND StockID IN (select cast(left(exid,3) as int) from dbo.DS_Faces where factiveflag = 1 and ftype = 6)
	AND ProdID IN (select cast(iidText as int) from dbo.DS_ITEMS where activeFlag = 1)
	GROUP BY OurID, StockID, ProdID) as T2
on prd = ProdID AND firm = OurID AND stck = StockID

open rem_import 
fetch next from rem_import into @exid_a, @prd_a, @rem_a

while @@fetch_status = 0
begin

exec DMT_Set_StockEx  @ItemIdd = @prd_a, @amount = @rem_a, @StoreIDD = @exid_a

fetch next from rem_import into @exid_a, @prd_a, @rem_a
end

close rem_import
deallocate rem_import


----------------------------------------------------------------------------------------

exec DMT_Set_AgentEx '2430',1,'����������� �������','����������� �������','2430','004_1','2430';
exec DMT_Set_AgentEx '2482',1,'���������� ��������','���������� ��������','2482','004_1','2482';
exec DMT_Set_AgentEx '4381',1,'�������� �������','�������� �������','4381','004_1','4381';
exec DMT_Set_AgentEx '4378',1,'����� ����','����� ����','4378','004_1','4378';
exec DMT_Set_AgentEx '4377',1,'���� �������','���� �������','4377','004_1','4377';
exec DMT_Set_AgentEx '4367',1,'������ ������','������ ������','4367','004_1','4367';
exec DMT_Set_AgentEx '1405',1,'������� ����','������� ����','1405','004_1','1405';
exec DMT_Set_AgentEx '4339',1,'�������� ���������','�������� ���������','4339','004_1','4339';
exec DMT_Set_AgentEx '18',1,'������ ������','������ ������','18','004_1','18';
exec DMT_Set_AgentEx '4358',1,'������ ���������','������ ���������','4358','004_3','4358';
exec DMT_Set_AgentEx '41',1,'�������� �����','�������� �����','41','004_3','41';
exec DMT_Set_AgentEx '3492',1,'���������� ���������','���������� ���������','3492','004_3','3492';
exec DMT_Set_AgentEx '3475',1,'������� ������','������� ������','3475','004_3','3475';

-------------------------------------------------------------------------

exec DMT_Set_PriceLists '018','�����',1;
exec DMT_Set_PriceLists '019','BK',1;
exec DMT_Set_PriceLists '023','����',1;
exec DMT_Set_PriceLists '024','�������',1;
exec DMT_Set_PriceLists '025','�������5',1;
exec DMT_Set_PriceLists '026','�������10',1;
exec DMT_Set_PriceLists '029','���',1;
exec DMT_Set_PriceLists '032','������',1;
exec DMT_Set_PriceLists '033','��(������)',1;
exec DMT_Set_PriceLists '034','�����',1;
exec DMT_Set_PriceLists '036','����',1;
exec DMT_Set_PriceLists '037','�������5(������)',1;
exec DMT_Set_PriceLists '038','�������10(������)',1;
exec DMT_Set_PriceLists '041','����30',1;
exec DMT_Set_PriceLists '042','����50',1;
exec DMT_Set_PriceLists '043','����15',1;
exec DMT_Set_PriceLists '044','����20',1;
exec DMT_Set_PriceLists '047','�����',1;
exec DMT_Set_PriceLists '048','������',1;
exec DMT_Set_PriceLists '049','������',1;
exec DMT_Set_PriceLists '050','�����',1;
exec DMT_Set_PriceLists '055','��������',1;
exec DMT_Set_PriceLists '056','�������15',1;
exec DMT_Set_PriceLists '057','�������5(��������)',1;
exec DMT_Set_PriceLists '058','�������10(��������)',1;
exec DMT_Set_PriceLists '060','����',1;
exec DMT_Set_PriceLists '067','�������5_��',1;
exec DMT_Set_PriceLists '068','�������5(��������+��)',1;
exec DMT_Set_PriceLists '080','�������',1;
exec DMT_Set_PriceLists '082','������2',1;
exec DMT_Set_PriceLists '083','����',1;
exec DMT_Set_PriceLists '086','������',1;
exec DMT_Set_PriceLists '089','��',1;
exec DMT_Set_PriceLists '037041','�������5(������)_����30',1;
exec DMT_Set_PriceLists '037042','�������5(������)_����50',1;
exec DMT_Set_PriceLists '038041','�������10(������)_����30',1;
exec DMT_Set_PriceLists '038042','�������10(������)_����50',1;
exec DMT_Set_PriceLists '025041','�������5_����30',1;
exec DMT_Set_PriceLists '025042','�������5_����50',1;
exec DMT_Set_PriceLists '026041','�������10_����30',1;
exec DMT_Set_PriceLists '026042','�������10_����50',1;
exec DMT_Set_PriceLists '037044','�������5(������)_����20',1;
exec DMT_Set_PriceLists '038043','�������10(������)_����15',1;
exec DMT_Set_PriceLists '038044','�������10(������)_����20',1;
exec DMT_Set_PriceLists '057042','�������5(��������)_����50',1;


-------------------------------------------------------------------------

-- ������������ ������� � �������� ������� 
select T.ExID, (select exid from dbo.DS_PRICELISTS where c.job3 = plName and activeFlag = 1) plName
into #TPL
from 
	(select cast(LEFT(exid,7) as int) shortExID, ExID 
	from dbo.DS_FACES
	where fActiveFlag = 1
	and ftype = 1) T
inner join [s-sql-d4].Elit.dbo.r_Comps c on compid = shortExID

declare @compadd nvarchar(20)
declare @PriceEx nvarchar(20)
declare curr cursor
for select exid, plName
from #TPL
where plName is not null

open curr
fetch next from curr into @compadd, @PriceEx

while @@FETCH_STATUS = 0
begin	
	
	exec DMT_Set_ClientPriceList @exidClient = @compadd, @exidPriceList = @PriceEx, @activeFlag = 2;
	
	fetch next from curr into @compadd, @PriceEx

end

close curr
deallocate curr

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- ���� ������������ ������ ����� exite
select ZEO_OT_KOD, (select (select CodeName2 from [s-sql-d4].Elit.dbo.r_Codes2 c2 where c2.codeid2 = c.codeid2) from [s-sql-d4].Elit.dbo.r_Comps c where compid = ZEO_OT_KOD), MIN(ZEO_ORDER_STATUS), MAX(ZEO_ORDER_STATUS), MIN(ZEO_OUR_KOD) Arda, MAX(ZEO_OUR_KOD) AV
from dbo.ALEF_EDI_ORDERS
where ZEO_ORDER_STATUS > 2
group by ZEO_OT_KOD
order by 2





select * from dbo.r_CompsAdd
where CompID=7018