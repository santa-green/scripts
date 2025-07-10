CREATE PROCEDURE [dbo].[ap_EDI_Importing_Orders_OT]    
AS    
BEGIN  
SET STATISTICS IO ON
set statistics time on --������������ ���������� �� ������� ��� ����������

set nocount on --��������� ����� ���������� �����

DECLARE @ShowRunTime INT = 1 -- �������� ����� ������� � ���������
DECLARE @RunDate datetime = GETDATE() --  �����  ������ ���������
IF @ShowRunTime = 1 Select '����� ������� 100 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

/*
0	����� �����;
1	���������� � ��;
3	���������� ���������;
4	���������������;
5	����� ����� � ��;
31	����� �����, ��� ������������;
32	���� �������� ������ �������;
33	����������� ������� ��� ������;
34	�� ���������� ����� ����;
35	�� ����������� �������� �������;
36	��� ���� ��� ������;
37	��� �������� ��� ������;
38	������ �����;
39	��� ���� ���������;
	����������� ������;
*/

--Pashkovv '2019-04-02 11:51:10.920' ������ � �������������� ������ �������� ������ ������ ������� ������������ � ������ 
--Pashkovv ''2019-04-02 13:17:50.331' ������ � ������� �������� ������ ������ ������� ������������ � ������ 
--Pashkovv '2019-04-05 14:35' �������� �������� �� ������� ������������ ��������� /*c.UsePL = 1 and*/

-- ��������� ����� ������ ��� ���������� "��. ���" ��� "������� ��������" ��� ������ "��. ����" + "����� ��������" (���������� ���������) 
update dbo.ALEF_EDI_ORDERS_2
set
ZEO_ORDER_STATUS = 3 --3	���������� ���������;
where ZEO_ORDER_STATUS = 0
and (exists(select * from dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD and ZEC_STATUS = 0) 
or exists(select * from dbo.ALEF_EDI_GLN_SETI with (nolock) where EGS_GLN_ID = ZEO_ZEC_BASE and EGS_STATUS = 0)
or exists(select * from dbo.ALEF_EDI_GLN_SETI with (nolock) where EGS_GLN_ID = ZEO_ZEC_ADD and EGS_STATUS = 0))

IF @ShowRunTime = 1 Select '����� ������� 110 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ��������� ��������������� ����� ������ (� ���������� ������� ������). ������ ������ 4 = "���������������". 
-- ���������� ������ ������ ��������� ����� ��� ������������ �� ���-��
update dbo.ALEF_EDI_ORDERS_2
set
ZEO_ORDER_STATUS = 4
where ZEO_ORDER_ID in (
	select ZEO_ORDER_ID
	from
		(select ZEO_ORDER_ID, SumQty, (select SUM(ZEP_POS_QTY) from dbo.ALEF_EDI_ORDERS_2_POS as OO where MinT = OO.ZEP_ORDER_ID) OldSumQty
		from
			(select ZEO_ORDER_ID, 
			(select SUM(ZEP_POS_QTY) from dbo.ALEF_EDI_ORDERS_2_POS with (nolock) where ZEP_ORDER_ID = ZEO_ORDER_ID) SumQty,
			(select MIN(OO.ZEO_ORDER_ID) from dbo.ALEF_EDI_ORDERS_2 OO with (nolock) where O.ZEO_ORDER_NUMBER = OO.ZEO_ORDER_NUMBER and O.ZEO_ZEC_ADD =  OO.ZEO_ZEC_ADD) MinT
			from dbo.ALEF_EDI_ORDERS_2 as O with (nolock) 
			where ZEO_ORDER_STATUS = 0) as T
		where ZEO_ORDER_ID <> MinT) as TT
	where SumQty = OldSumQty)

IF @ShowRunTime = 1 Select '����� ������� 120 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'   

-- �������� ������ � �� ���� ����
declare @today as smalldatetime = cast(convert(char(8), CURRENT_TIMESTAMP, 112) as smalldatetime)
declare @CurCurs as numeric(10,2) = isnull((select * from openquery([s-sql-d4],'select Elit.dbo.zf_GetRateMC(Elit.dbo.zf_GetCurrCC());')),0)

IF @ShowRunTime = 1 Select '����� ������� 130 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'   

if @CurCurs = 0 goto ExitPoint

--into #EDI2OT
select
-- Existing Staff
ZEO_ORDER_ID,
ZEO_ORDER_NUMBER,
ZEO_ORDER_DATE,
(SELECT TOP 1 ZEC_KOD_KLN_OT FROM dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_KOD, --700
(SELECT TOP 1 ZEC_KOD_ADD_OT FROM dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_ADD,--1001
(SELECT TOP 1 ZEC_KOD_SKLAD_OT FROM dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_SKL,
(SELECT TOP 1 ZEC_KOD_BASE FROM dbo.ALEF_EDI_GLN_OT with (nolock) where ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD) ZEO_OT_BASE,
cast(0 as tinyint) as ZEO_OT_SKL_CH,
cast('' as varchar(200)) ZEO_NOTE,
ZEP_POS_ID, 
ZEP_POS_KOD, 
ZEP_POS_QTY, 
ZEO_AUDIT_DATE,
ZEO_XML_HEAD,
-- New Staff
cast(0 as int) as ZE_ORDER_ExID,
cast(0 as tinyint) as ZE_ORDER_SubID,
cast(0 as smallint) as ZE_KLN_OT_DELAY,
cast(0 as smallint) as ZE_KLN_OT_PRICE,
cast('' as varchar(200)) as ZE_KLN_OT_JOB3,
cast(0 as int) as ZE_POS_OT_KOD,
cast('' as varchar(42)) as ZE_POS_BAR,
cast(0 as numeric(21,9)) as ZE_POS_CENA,
cast(4 as int) as ZE_CODE_3,
cast(110 as int) as ZE_STATUS,
cast(0 as tinyint) as ZE_READY_STATUS
 into #EDI2OT
from dbo.ALEF_EDI_ORDERS_2 with (nolock) 
join dbo.ALEF_EDI_ORDERS_2_POS with (nolock) on ZEO_ORDER_ID = ZEP_ORDER_ID
where ZEO_ORDER_STATUS in (0,1)
or ZEO_ORDER_ID in (
	select EOC_ORDER_ID
	from dbo.ALEF_EDI_ORDERS_CHANGES with (nolock) 
	where EOC_COMMITTED = 0
	and EOC_TYPE = 200)

IF @ShowRunTime = 1 Select '����� ������� 140 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'   

-- ������ "����� � ���������"
UPDATE Ord
set
ZEO_ORDER_STATUS = 1
FROM dbo.ALEF_EDI_ORDERS_2 Ord, #EDI2OT Ord2
WHERE Ord.ZEO_ORDER_STATUS = 0
and Ord.ZEO_ORDER_ID = Ord2.ZEO_ORDER_ID

IF @ShowRunTime = 1 Select '����� ������� 150 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ������� ���� �������� � ������� �� ������� ��� �����
update #EDI2OT
set
ZEO_ORDER_DATE = DATEADD(DAY,-1,ZEO_ORDER_DATE)
where datepart(DW,ZEO_ORDER_DATE) = 7
and ZEO_OT_KOD in (7000,7001,7002,7003)

IF @ShowRunTime = 1 Select '����� ������� 160 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ��������� ��������� ��������� ��� ���������� �������
declare @ch_order varchar(12)
declare @ch_type tinyint
declare @ch_pos tinyint
declare @ch_data varchar(250)

declare ch_cursor cursor fast_forward for
select EOC_ORDER_ID, EOC_TYPE, EOC_POS, EOC_CH_DATA
from
	(select EOC_ORDER_ID, EOC_TYPE, EOC_POS, EOC_CH_DATA, EOC_CH_DATE, MAX(EOC_CH_DATE) OVER(PARTITION BY EOC_ORDER_ID, EOC_TYPE, EOC_POS) as [Maximum]
	from dbo.ALEF_EDI_ORDERS_CHANGES
	where EOC_COMMITTED = 0
	and EOC_TYPE != 0) as T
where EOC_CH_DATE = [Maximum]
order by EOC_ORDER_ID, EOC_TYPE, EOC_POS

open ch_cursor
fetch next from ch_cursor into @ch_order, @ch_type, @ch_pos, @ch_data

while @@FETCH_STATUS = 0
begin

--IF @ShowRunTime = 1 Select '����� ������� 170 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

	-- ===================================
	-- Ch_Types:
	-- 1 - ����� ���� ��������
	-- 2 - ����� �� ���� ��� (Compid � ��)
	-- 3 - ����� ������ �������� (CompAddID � ��)
	-- 4 - ����� ������ �������� (����� ������ � ��)
	-- 5 - ������� ������� �� ������ (PosID �������)
	-- 6 - ������ ������� � ������ (PosID �������)
	-- 7 - ������ ������ 
	-- ===================================
	
	-- 1 - ����� ���� ��������
	if @ch_type = 1
		update #EDI2OT
		set
		ZEO_ORDER_DATE = CAST(@ch_data as date)
		where ZEO_ORDER_ID = @ch_order

--IF @ShowRunTime = 1 Select '����� ������� 180 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'
		
	-- 2 - ����� �� ���� ��� (Compid � ��)		
	if @ch_type = 2
		update #EDI2OT
		set
		ZEO_OT_KOD = CAST(@ch_data as int)
		where ZEO_ORDER_ID = @ch_order

--IF @ShowRunTime = 1 Select '����� ������� 190 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

	-- 3 - ����� ������ �������� (CompAddID � ��)
	if @ch_type = 3
		update #EDI2OT
		set
		ZEO_OT_ADD = CAST(@ch_data as int)
		where ZEO_ORDER_ID = @ch_order

--IF @ShowRunTime = 1 Select '����� ������� 200 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

	-- 4 - ����� ������ �������� (����� ������ � ��)
	if @ch_type = 4
		update #EDI2OT
		set
		ZEO_OT_SKL = CAST(@ch_data as int),
		ZEO_OT_SKL_CH = 1
		where ZEO_ORDER_ID = @ch_order

--IF @ShowRunTime = 1 Select '����� ������� 210 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

	-- 5 - �����������/������� ������� �� ������ (PosID �������)		
	if @ch_type = 5
		update #EDI2OT
		set
		ZEP_POS_QTY = case when @ch_data  = '' then -1 else CAST(@ch_data as int) end
		where ZEO_ORDER_ID = @ch_order
		and ZEP_POS_ID = @ch_pos	

--IF @ShowRunTime = 1 Select '����� ������� 220 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

	-- 6 - ������ ������� � ������ (PosID �������)	
	if @ch_type = 6
		update #EDI2OT
		set
		ZE_POS_OT_KOD = CAST(@ch_data as int) 
		where ZEO_ORDER_ID = @ch_order
		and ZEP_POS_ID = @ch_pos	

--IF @ShowRunTime = 1 Select '����� ������� 230 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

	-- 7 - ������ ������ 115
	if @ch_type = 7
		update #EDI2OT
		set
		ZE_STATUS = CAST(@ch_data as int)
		where ZEO_ORDER_ID = @ch_order

--IF @ShowRunTime = 1 Select '����� ������� 231 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'
		
	fetch next from ch_cursor into @ch_order, @ch_type, @ch_pos, @ch_data

end

close ch_cursor
deallocate ch_cursor

IF @ShowRunTime = 1 Select '����� ������� 240 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ZE_READY_STATUS = 9
--UPDATE #EDI2OT
--set
--ZE_READY_STATUS = 9
--FROM #EDI2OT
--WHERE exists (select * from [s-sql-d4].Elit.dbo.at_t_IORes where OrderID = ZEO_ORDER_NUMBER and CompID = ZEO_OT_KOD and CompAddID = ZEO_OT_ADD and StateCode = 140)
--and ZE_READY_STATUS = 0

-- ZE_READY_STATUS = 1
UPDATE #EDI2OT
set
ZE_READY_STATUS = 1
WHERE ZEO_OT_KOD is null
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 250 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ZE_READY_STATUS = 2
UPDATE #EDI2OT
set
ZE_READY_STATUS = 2
WHERE ZEO_ORDER_DATE < @today
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 260 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ��������� ����������� ������� ����
update #EDI2OT
set
ZEP_POS_KOD = right(ZEP_POS_KOD,LEN(ZEP_POS_KOD)-1)
where ZEO_OT_KOD in (7039,7060)
and left(ZEP_POS_KOD,1) = '0'
and ZE_READY_STATUS = 0

-- ������� ���� ���� �������
--update #EDI2OT
--set
--ZE_POS_OT_KOD =  ex_max
--from
--		(select Compid ex_comp, extprodid ex_prod, max(prodid) ex_max
--		from [s-sql-d4].Elit.dbo.r_ProdEC
--		where exists (select * from #EDI2OT where ZEO_OT_KOD = Compid and ZEP_POS_KOD = extprodid)
--		group by Compid, extprodid) T2
--where ZEO_OT_KOD = ex_comp and ZEP_POS_KOD = ex_prod
--and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 270 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

update #EDI2OT
set
ZE_POS_OT_KOD = SelectedProd
from
	(
	select ZEO_ORDER_ID, ZEP_POS_ID, MAX(ProdID) SelectedProd 
	from 
		(select ZEO_ORDER_ID, ZEP_POS_ID, ZEP_POS_QTY, ProdID, Rem, MAX(Rem) OVER(partition by ZEO_ORDER_ID, ZEP_POS_ID) MaxRem 
		from 
			(
			select ZEO_ORDER_ID, ZEP_POS_ID, ZEP_POS_QTY, ProdID, isnull((select sum(Qty-AccQty) from [s-sql-d4].Elit.dbo.t_Rem r where r.ProdID = ec.ProdID and StockID = ZEO_OT_SKL),0) Rem 
			from [s-sql-d4].Elit.dbo.r_ProdEC ec 
			join #EDI2OT t on ExtProdID = ZEP_POS_KOD and Compid = ZEO_OT_KOD 
			--Pashkovv ''2019-04-02 13:17:50.331' ������ � ������� �������� ������ ������ ������� ������������ � ������ 
			--Pashkovv '2019-04-05 14:35' �������� �������� �� ������� ������������ ��������� /*c.UsePL = 1 and*/
			--����������� ��� ������ ����� ������ � USE [Alef_Elit] StoredProcedure [dbo].[ALEF_WEB_EDI_GET_PROD_MarketA]
			and exists(SELECT top 1 1 FROM [s-sql-d4].Elit.dbo.r_ProdMP mp 
						where mp.PLID = (SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where /*c.UsePL = 1 and*/ c.CompID = ZEO_OT_KOD) 
						and mp.ProdID = ec.ProdID
						)
			) as R
		) as RR
	where Rem = MaxRem or Rem >= ZEP_POS_QTY
	group by ZEO_ORDER_ID, ZEP_POS_ID) as Pr
where Pr.ZEO_ORDER_ID = #EDI2OT.ZEO_ORDER_ID
and Pr.ZEP_POS_ID = #EDI2OT.ZEP_POS_ID
and ZE_POS_OT_KOD = 0
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 280 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ZE_READY_STATUS = 3
UPDATE #EDI2OT
set
ZE_READY_STATUS = 3
WHERE ZE_POS_OT_KOD = 0
and ZEP_POS_QTY > -1
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 290 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ��������� ����� �������
update #EDI2OT
set
ZEP_POS_QTY = case when ZEP_POS_KOD in ('231570','231566','268433','268593','268463','268669','26169','26213') then ZEP_POS_QTY * 20
				  when ZEP_POS_KOD in ('265744','27497','27498') 		then ZEP_POS_QTY * 24  
				  when ZEP_POS_KOD in ('73532','27499','375890','375888')			then ZEP_POS_QTY * 6
				  when ZEP_POS_KOD in ('265755')			then ZEP_POS_QTY * 12
				  else ZEP_POS_QTY
			 end
where ZEO_OT_KOD in (7000,7001,7002,7003)
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 300 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ��������� ������� �������
update #EDI2OT
set
/*ZEP_POS_QTY = case 	
                when ZEP_POS_KOD in ('1135889'  ,'6032166') then ZEP_POS_QTY * 20
                when ZEP_POS_KOD in ('6032033') then ZEP_POS_QTY * 30
				when ZEP_POS_KOD in ('6032173') 	then ZEP_POS_QTY * 24  
				when ZEP_POS_KOD in ('1135894','1135923','1135924','1135928','1135891'  ,'6032152','6032427')	then ZEP_POS_QTY * 6
				when ZEP_POS_KOD in ('1135898') then ZEP_POS_QTY * 12
				else ZEP_POS_QTY
			 end*/
--rkv0 '2019-08-20 17:43' ����� �������-�������.
ZEP_POS_QTY = ZEP_POS_QTY/[dbo].[af_GetQtyPack_ROZETKA](ZEP_POS_KOD)

where ZEO_OT_KOD in (7138)
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 310 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ������� ����� � �������� �������
update #EDI2OT
set
ZE_KLN_OT_DELAY = ct.PayDelay,
ZE_KLN_OT_PRICE = c.PLID,
ZE_KLN_OT_JOB3 = c.Job3
from [s-sql-d4].Elit.dbo.r_Comps c 
left join [s-sql-d4].Elit.dbo.at_r_CompOurTerms ct on c.CompID = ct.CompID
where ZEO_OT_KOD = c.Compid 
and ct.OurID = 1
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 320 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ZE_READY_STATUS = 4
UPDATE #EDI2OT
set
ZE_READY_STATUS = 4
WHERE ZE_KLN_OT_PRICE = 0
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 330 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ZE_READY_STATUS = 5
UPDATE #EDI2OT
set
ZE_READY_STATUS = 5
WHERE ZE_KLN_OT_DELAY = 0
and ZEO_OT_KOD != 10792 -- ���������� ��������� �.�. �� �/���.��� (������ �)
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 340 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ������� ���� � �����-����
update #EDI2OT
set
ZE_POS_CENA = pricemc * @CurCurs/1.2,
ZE_POS_BAR = (select max(ProdBarCode) from [s-sql-d4].Elit.dbo.av_t_PInPAcc pp where pp.prodid = ZE_POS_OT_KOD)
FROM [s-sql-d4].Elit.dbo.r_prodmp
WHERE ZE_POS_OT_KOD = prodid
and ZE_KLN_OT_PRICE = plid
and pricemc > 0
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 350 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

update #EDI2OT
set
ZE_POS_BAR = BarCode
from [s-sql-d4].Elit.dbo.r_ProdMQ
where UM in ('���.','��.','�����.','����.','����','����.','���','��')
and ZE_POS_OT_KOD = ProdID
and isnull(ZE_POS_BAR,'') = ''
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 360 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ZE_READY_STATUS = 6
update #EDI2OT
set
ZE_READY_STATUS = 6
WHERE ZE_POS_CENA = 0
and ZEP_POS_QTY > -1
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 370 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ZE_READY_STATUS = 7
update #EDI2OT
set
ZE_READY_STATUS = 7
WHERE isnull(ZE_POS_BAR,'') = ''
and ZEP_POS_QTY > -1
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 380 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ZE_READY_STATUS = 8
update #EDI2OT
set
ZE_READY_STATUS = 8
FROM
	(SELECT ZEO_ORDER_ID OrdID, MAX(ZEP_POS_QTY) MaxQty
	FROM #EDI2OT
	GROUP BY ZEO_ORDER_ID
	HAVING MAX(ZEP_POS_QTY) < 0) as T
WHERE ZEO_ORDER_ID = OrdID
and ZE_READY_STATUS = 0

IF @ShowRunTime = 1 Select '����� ������� 390 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ������ ����� � ������� ��� ���������
update #EDI2OT
set
ZE_READY_STATUS = T_st
from
	(select ZEO_ORDER_ID, max(ZE_READY_STATUS)
	from #EDI2OT
	group by ZEO_ORDER_ID) as T(T_num, T_st)
where T_num = ZEO_ORDER_ID

IF @ShowRunTime = 1 Select '����� ������� 400 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ������ "Bad"
UPDATE Ord
set
ZEO_ORDER_STATUS = 30 + ZE_READY_STATUS
FROM dbo.ALEF_EDI_ORDERS_2 Ord, #EDI2OT Ord2
WHERE Ord.ZEO_ORDER_ID = Ord2.ZEO_ORDER_ID
and ZE_READY_STATUS > 0

IF @ShowRunTime = 1 Select '����� ������� 410 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ���� ��� ��������� ������ OK
UPDATE dbo.ALEF_EDI_ORDERS_CHANGES
set
EOC_COMMITTED = 1
where EOC_COMMITTED = 0
and EOC_ORDER_ID in (
	select ZEO_ORDER_ID 
	from #EDI2OT
	where ZE_READY_STATUS > 0)

IF @ShowRunTime = 1 Select '����� ������� 420 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ������� ��������� ������ � ������� �� ��������
delete from #EDI2OT
where ZE_READY_STATUS > 0 
or ZEP_POS_QTY < 0

-- ���. ����������� �� ������� ��� ��������� �����
--update #EDI2OT
--set
--ZEO_OT_KOD = case ZEO_OT_KOD when 7006 then 7102 else 7103 end,
--ZEO_OT_ADD = 1,
--ZEO_OT_SKL = 30,
--ZE_ORDER_SubID = 1
--where ZEO_OT_KOD in (7006,7012)
--and exists (select 1 from [s-sql-d4].Elit.dbo.r_Prods where ZE_POS_OT_KOD = ProdID and PGrID in (300,305,1902))

IF @ShowRunTime = 1 Select '����� ������� 430 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- �������� ��� ������ �
-- ���������� ��� ���� � �����
update t
set
t.ZEO_NOTE = case (select o.ZEO_ZEC_ADD from dbo.ALEF_EDI_ORDERS_2 o where o.ZEO_ORDER_ID = t.ZEO_ORDER_ID and o.ZEO_ZEC_ADD in ('1203','1204','1212')) 
	when '1203' then '���'
	when '1212' then '���'
	when '1204' then '�����' 
	else t.ZEO_NOTE end
from #EDI2OT t
where t.ZEO_OT_KOD in (10797,10798)
and exists (select * from dbo.ALEF_EDI_ORDERS_2 o where o.ZEO_ORDER_ID = t.ZEO_ORDER_ID and o.ZEO_ZEC_ADD in ('1203','1204','1212'))

IF @ShowRunTime = 1 Select '����� ������� 440 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ������� ������ ���������� �� �����. �����
update t
set
t.ZE_CODE_3 = case t.ZEO_OT_SKL when 4 then 35 when 220 then 30  when 304 then 35 end
from #EDI2OT t
where t.ZEO_OT_KOD in (10797,10798,10792,10796)
and exists (select * from dbo.ALEF_EDI_ORDERS_2 o where o.ZEO_ORDER_ID = t.ZEO_ORDER_ID and o.ZEO_ZEC_BASE in ('171','181','700','701'))

IF @ShowRunTime = 1 Select '����� ������� 450 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ��������� �� ������� 4 � 1104; 220 � 1130; 11 � 1111 
create table #MarketA(
or_ID varchar(12),
or_Sklad smallint,
or_PosID smallint,
alt_ProdID int,
alt_ProdQty int
);

IF @ShowRunTime = 1 Select '����� ������� 460 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

;with kika as(
	select 
	ZEO_ORDER_ID,
	ZEO_OT_SKL,
	ZEP_POS_ID,
	ZEP_POS_QTY,
	ROW_NUMBER() over(partition by ZEO_ORDER_ID,ZEP_POS_ID order by ALT_QTY desc) ROW_ID,
	ALT_PROD,
	ALT_QTY
	from 
		(select ZEO_ORDER_ID, case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end ZEO_OT_SKL, ZEP_POS_ID, ZEP_POS_QTY,
		ec.prodid ALT_PROD, isnull((select sum(Qty) from [s-sql-d4].Elit.dbo.t_Rem r where ec.ProdID = r.ProdID and StockID = case ZEO_OT_SKL when 4 then 1104 when 220 then 1130 when 11 then 1111 else 0 end),0) ALT_QTY
		from #EDI2OT
		inner join [s-sql-d4].Elit.dbo.r_ProdEC ec on Compid = ZEO_OT_KOD and extprodid = ZEP_POS_KOD
		where ZEO_OT_KOD in (10797,10798)
		and ZEO_OT_SKL in (4,11,220)
		and ZEO_OT_SKL_CH = 0
		and ZEP_POS_QTY > 0
		--Pashkovv '2019-04-02 11:51:10.920' ������ � �������������� ������ �������� ������ ������ ������� ������������ � ������
		--Pashkovv '2019-04-05 14:35' �������� �������� �� ������� ������������ ��������� /*c.UsePL = 1 and*/
		and exists(SELECT top 1 1 FROM [s-sql-d4].Elit.dbo.r_ProdMP mp 
					where mp.PLID = (SELECT PLID FROM [s-sql-d4].Elit.dbo.r_Comps c where /*c.UsePL = 1 and*/ c.CompID = ZEO_OT_KOD) 
					and mp.ProdID = ec.ProdID
				   )
		) as T
	where ALT_QTY > 0
)
insert #MarketA
select ZEO_ORDER_ID, ZEO_OT_SKL, ZEP_POS_ID, ALT_PROD, case when ZEP_POS_QTY >= STOCKS then ALT_QTY else ZEP_POS_QTY - (STOCKS - ALT_QTY) end QTY
from
	(select *,	(select SUM(ALT_QTY) from kika k2 where k1.ZEO_ORDER_ID = k2.ZEO_ORDER_ID and k1.ZEP_POS_ID = k2.ZEP_POS_ID and k2.ROW_ID <= k1.ROW_ID) STOCKS
	from kika k1) as T
where ZEP_POS_QTY >= STOCKS
or (ZEP_POS_QTY < STOCKS and ZEP_POS_QTY > isnull((select SUM(ALT_QTY) from kika k where k.ZEO_ORDER_ID = T.ZEO_ORDER_ID and k.ZEP_POS_ID = T.ZEP_POS_ID and k.ROW_ID < T.ROW_ID),0))

IF @ShowRunTime = 1 Select '����� ������� 470 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

delete from #MarketA
where or_Sklad = 1130
and alt_ProdID = 29877

IF @ShowRunTime = 1 Select '����� ������� 480 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

update #EDI2OT
set
ZEP_POS_QTY = ZEP_POS_QTY - alt_Qty
from
	(select or_ID, or_PosID, SUM(alt_ProdQty) alt_Qty
	from #MarketA
	group by or_ID, or_PosID) as T
where or_ID = ZEO_ORDER_ID
and or_PosID = ZEP_POS_ID

IF @ShowRunTime = 1 Select '����� ������� 490 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

insert #EDI2OT
select ZEO_ORDER_ID, ZEO_ORDER_NUMBER, ZEO_ORDER_DATE, ZEO_OT_KOD, ZEO_OT_ADD, or_Sklad, ZEO_OT_BASE, ZEO_OT_SKL_CH, ZEO_NOTE, ROW_NUMBER() over(partition by ZEO_ORDER_ID order by ZEP_POS_KOD) ROW_ID,
ZEP_POS_KOD, alt_ProdQty, ZEO_AUDIT_DATE, ZEO_XML_HEAD, ZE_ORDER_ExID, 1, ZE_KLN_OT_DELAY, ZE_KLN_OT_PRICE, ZE_KLN_OT_JOB3, alt_ProdID, 
(select top 1 Bar from 
	(select max(ProdBarCode) Bar from [s-sql-d4].Elit.dbo.av_t_PInPAcc where prodid = alt_ProdID union 
	 select BarCode from [s-sql-d4].Elit.dbo.r_ProdMQ where UM in ('���.','��.','�����.','����.','����','����.','���','��') and ProdID = alt_ProdID) as T
order by LEN(Bar) desc), 
isnull((select pricemc * @CurCurs/1.2 from [s-sql-d4].Elit.dbo.r_prodmp where prodid = alt_ProdID and plid = ZE_KLN_OT_PRICE),0), ZE_CODE_3, ZE_STATUS, ZE_READY_STATUS
from #MarketA
inner join #EDI2OT on or_ID = ZEO_ORDER_ID and or_PosID = ZEP_POS_ID 
order by ZEO_ORDER_ID, ROW_ID

IF @ShowRunTime = 1 Select '����� ������� 500 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

delete edi from #EDI2OT edi
inner join #MarketA on or_ID = ZEO_ORDER_ID and or_PosID = ZEP_POS_ID and ZEP_POS_QTY = 0
-- ��������� ������ � �� ������� 4 � 1104; 220 � 1130; 11 � 1111  

IF @ShowRunTime = 1 Select '����� ������� 510 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ���� "������" �� �������� � �� ��������
update #EDI2OT
set
ZE_ORDER_SubID = 1
where ZEO_OT_KOD in (7013,7016,7018)
and exists (select 1 from [s-sql-d4].Elit.dbo.r_Prods where ZE_POS_OT_KOD = ProdID and PGrID1 in (38,64,67,71))

IF @ShowRunTime = 1 Select '����� ������� 520 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

update #EDI2OT
set
ZEO_ORDER_NUMBER = case ZE_ORDER_SubID 
	when 0 then ZEO_ORDER_NUMBER + '_alc'
	when 1 then ZEO_ORDER_NUMBER + '_non-alc'
end
where ZEO_OT_KOD in (7013,7016,7018)

IF @ShowRunTime = 1 Select '����� ������� 530 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

update #EDI2OT
set
ZE_ORDER_SubID = 1,
ZEO_OT_KOD = 7101
where ZEO_OT_KOD = 7015
and exists (select 1 from [s-sql-d4].Elit.dbo.r_Prods where ZE_POS_OT_KOD = ProdID and PCatID = 29)

IF @ShowRunTime = 1 Select '����� ������� 540 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

-- ������� �� ��� ������� � ��
insert dbo.ALEF_EXPORT_SUCCESS(ES_SUB, ES_OUR, ES_DATA1, ES_DATA2, ES_DATA3)
select distinct ZE_ORDER_SubID, CASE WHEN ZEO_OT_KOD=10796 and ZEO_OT_BASE=701 THEN 3 ELSE 1 END, 0, 0, ZEO_ORDER_ID
from #EDI2OT
where 
-- �������� ID ��� ������� � ��
not exists (select * from dbo.ALEF_EXPORT_SUCCESS where ZEO_ORDER_ID = ES_DATA3 and ES_OUR in( 1,3) and ZE_ORDER_SubID = ES_SUB)
-- �������� ID ��� ����������� � ��
or exists (select * from [s-sql-d4].Elit.dbo.at_t_IORec_� where IOH_ID = (select max(ES_EXP) from dbo.ALEF_EXPORT_SUCCESS where ZEO_ORDER_ID = ES_DATA3 and ES_OUR in (1,3) and ZE_ORDER_SubID = ES_SUB))

IF @ShowRunTime = 1 Select '����� ������� 550 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

update #EDI2OT
set
ZE_ORDER_ExID = (select max(ES_EXP) from dbo.ALEF_EXPORT_SUCCESS where ZEO_ORDER_ID = ES_DATA3 and ES_OUR in (1,3) and ZE_ORDER_SubID = ES_SUB)

IF @ShowRunTime = 1 Select '����� ������� 560 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

declare @newid as int 
declare cur_exp cursor fast_forward
for select distinct ZE_ORDER_ExID 
from #EDI2OT

open cur_exp
fetch next from cur_exp into @newid

while @@FETCH_STATUS = 0
begin

--IF @ShowRunTime = 1 Select '����� ������� 570 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'
		
	insert [s-sql-d4].Elit.dbo.at_t_IORec_�(IOH_ID, IOH_DEP_DATE, IOH_OUR, IOH_STOCK, IOH_COMP, IOH_C1, IOH_C2, IOH_C3, IOH_C4, IOH_C5, IOH_PD, IOH_EMP, IOH_NOTE, IOH_ZAM_DATE, IOH_PL_ID, IOH_PL_NAME, IOH_ADD_ID, IOH_ORDER, IOH_ST_CODE, IOH_EDI_XML, IOH_PAYCOND)
	select distinct ZE_ORDER_ExID, ZEO_ORDER_DATE, CASE WHEN ZEO_OT_KOD=10796 and ZEO_OT_BASE=701 THEN 3 ELSE 1 END, ZEO_OT_SKL, ZEO_OT_KOD, CASE WHEN ZEO_OT_KOD=10796 and ZEO_OT_BASE=701 THEN 64 ELSE 63 END, 18, ZE_CODE_3, 0, 0, ZE_KLN_OT_DELAY, 7022, ZEO_NOTE, ZEO_AUDIT_DATE, ZE_KLN_OT_PRICE, ZE_KLN_OT_JOB3, ZEO_OT_ADD, ZEO_ORDER_NUMBER, ZE_STATUS, cast(ZEO_XML_HEAD as varbinary(max)), 1
	from #EDI2OT
	where ZE_ORDER_ExID = @newid

--IF @ShowRunTime = 1 Select '����� ������� 580 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'
		
	insert [s-sql-d4].Elit.dbo.at_t_IORecD_�(IOD_IOH_ID, IOD_POS, IOD_PROD, IOD_QTY, IOD_PRICE, IOD_BAR)
	select distinct ZE_ORDER_ExID, ROW_NUMBER() OVER(ORDER BY ZE_POS_OT_KOD), ZE_POS_OT_KOD, ZEP_POS_QTY, ZE_POS_CENA, ZE_POS_BAR
	from #EDI2OT
	where ZE_ORDER_ExID = @newid

--IF @ShowRunTime = 1 Select '����� ������� 590 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

	-- ������ ������ = "Good"
	UPDATE Ord
	SET
	ZEO_ORDER_STATUS = 5
	FROM dbo.ALEF_EDI_ORDERS_2 Ord, #EDI2OT Ord2
	WHERE Ord.ZEO_ORDER_ID = Ord2.ZEO_ORDER_ID
	and Ord2.ZE_ORDER_ExID = @newid
	
	
--IF @ShowRunTime = 1 Select '����� ������� 600 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'
	
	
	-- ��������� � ������ = "Committed"
	UPDATE dbo.ALEF_EDI_ORDERS_CHANGES
	SET
	EOC_COMMITTED = 1
	FROM #EDI2OT Ord
	WHERE EOC_COMMITTED = 0
	and Ord.ZEO_ORDER_ID = EOC_ORDER_ID
	and Ord.ZE_ORDER_ExID = @newid

--IF @ShowRunTime = 1 Select '����� ������� 610 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

	fetch next from cur_exp into @newid

end

close cur_exp
deallocate cur_exp

IF @ShowRunTime = 1 Select '����� ������� 620 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

drop table #EDI2OT
drop table #MarketA

ExitPoint:

IF @ShowRunTime = 1 Select '����� ������� 999 - ' + CONVERT( varchar, GETDATE(), 21) + ' = ' + cast(DATEDIFF (millisecond,@RunDate,GETDATE()) as varchar) + ' ����������'

set statistics time off
SET STATISTICS IO OFF
END





