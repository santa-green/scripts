USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ALEF_WEB_EDI_GET_ORDERS]    Script Date: 20.08.2021 14:35:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--ALTER PROCEDURE [dbo].[ALEF_WEB_EDI_GET_ORDERS]
	-- Add the parameters for the stored procedure here
	@str varchar(max) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
    create table #tmp (
    Or_ID varchar(12) primary key,
    Or_Num varchar(35) not null,
    Or_Audit smalldatetime not null,
    Or_Date date not null,
    Or_Date_Ch bit not null,
    Or_Seti_ID int not null,
    Or_Seti_Name varchar(250) not null,
    Or_Base_GLN varchar(13) not null,
    Or_Base_Name varchar(250) not null,
    Or_Address_GLN varchar(13) not null,
    Or_Address_Name varchar(250) not null,        
    Or_CompID int not null,
    Or_CompID_Ch bit not null,
    Or_CompAdd int not null,
    Or_CompAdd_Ch bit not null,      
    Or_StockID int not null,
    Or_StockID_Ch bit not null,
    Or_State tinyint not null,
    Or_State_Ch bit not null, 
    Or_Status tinyint not null,
    Or_Prod bit not null,
    Or_Log bit not null,
    Or_Invoice bit not null
    )
    
    insert #tmp
	select 
	distinct
	ZEO_ORDER_ID,
	ZEO_ORDER_NUMBER,
	ZEO_AUDIT_DATE,
	ZEO_ORDER_DATE,
	0,
	EGS_GLN_SETI_ID,
	(select top 1 ESE_SETI_NAME from dbo.ALEF_EDI_SETI_EMPS where ESE_SETI_ID = EGS_GLN_SETI_ID),
	ZEO_ZEC_BASE,
	isnull((select EGS_GLN_NAME from dbo.ALEF_EDI_GLN_SETI where ZEO_ZEC_BASE = EGS_GLN_ID),'новый GLN'),
	ZEO_ZEC_ADD,
	isnull((select EGS_GLN_NAME from dbo.ALEF_EDI_GLN_SETI where ZEO_ZEC_ADD = EGS_GLN_ID),'новый GLN'),
	isnull((SELECT TOP 1 ZEC_KOD_KLN_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD),0),
	0,
	isnull((SELECT TOP 1 ZEC_KOD_ADD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD),0),
	0,
	isnull((SELECT TOP 1 ZEC_KOD_SKLAD_OT FROM dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_BASE = ZEO_ZEC_BASE and ZEC_KOD_ADD = ZEO_ZEC_ADD),0),
	0,
	110,
	0,
	ZEO_ORDER_STATUS,
	0,
	ISNULL((select top 1 1 from dbo.ALEF_EDI_ORDERS_CHANGES where EOC_ORDER_ID = ZEO_ORDER_ID),0),
	0	
	from dbo.ALEF_EDI_ORDERS_2 (nolock)
	inner join
		(select EGS_GLN_ID, EGS_GLN_SETI_ID
		from dbo.ALEF_EDI_GLN_SETI
		inner join dbo.ALEF_Split('881',',') on Splitcolumn = EGS_GLN_SETI_ID) as T
		on EGS_GLN_ID = ZEO_ZEC_BASE or EGS_GLN_ID = ZEO_ZEC_ADD
	where ZEO_AUDIT_DATE > dateadd(MM,-3,cast(convert(char(8), CURRENT_TIMESTAMP, 112) as smalldatetime))

	-- если уже есть накладная отмечаем это в заказе
	--update #tmp 
	--set
	--Or_Invoice = 1
	--where exists (select * from [s-sql-d4].Elit.dbo.at_t_IORes where OrderID = Or_Num and CompID = Or_CompID and StateCode = 140)

	select EOC_ORDER_ID, EOC_TYPE, EOC_POS, EOC_CH_DATA
	into #tmp_2
	from
		(select EOC_ORDER_ID, EOC_TYPE, EOC_POS, EOC_CH_DATA, EOC_CH_DATE, MAX(EOC_CH_DATE) OVER(PARTITION BY EOC_ORDER_ID, EOC_TYPE, EOC_POS) as [Maximum]
		from dbo.ALEF_EDI_ORDERS_CHANGES
		where EOC_ORDER_ID in (select Or_ID from #tmp)
		and EOC_COMMITTED = 0) as T
	where EOC_CH_DATE = [Maximum]
	order by EOC_ORDER_ID, EOC_TYPE, EOC_POS

	-- был перезалив заказа
	update #tmp 
	set
	Or_Status = 1
	from #tmp_2
	where EOC_ORDER_ID = Or_ID
	and EOC_TYPE = 200

	-- были изменения по дате отгрузки
	update #tmp 
	set
	Or_Date = CAST(EOC_CH_DATA as date),
	Or_Date_Ch = 1
	from #tmp_2
	where EOC_ORDER_ID = Or_ID
	and EOC_TYPE = 1

	-- были изменения по коду ТРТ
	update #tmp 
	set
	Or_CompID = CAST(EOC_CH_DATA as int),
	Or_CompID_Ch = 1
	from #tmp_2
	where EOC_ORDER_ID = Or_ID
	and EOC_TYPE = 2

	-- были изменения по коду адреса доставки
	update #tmp 
	set
	Or_CompAdd = CAST(EOC_CH_DATA as int),
	Or_CompAdd_Ch = 1
	from #tmp_2
	where EOC_ORDER_ID = Or_ID
	and EOC_TYPE = 3

	-- были изменения по коду склада отгрузки
	update #tmp 
	set
	Or_StockID = CAST(EOC_CH_DATA as int),
	Or_StockID_Ch = 1
	from #tmp_2
	where EOC_ORDER_ID = Or_ID
	and EOC_TYPE = 4

	-- были изменения в товарной части
	update #tmp 
	set
	Or_Prod = 1
	from #tmp_2
	where EOC_ORDER_ID = Or_ID
	and EOC_TYPE = 5

	-- были изменения по статусу заказа 110(115)
	update #tmp 
	set
	Or_State = CAST(EOC_CH_DATA as int),
	Or_State_Ch = 1
	from #tmp_2
	where EOC_ORDER_ID = Or_ID
	and EOC_TYPE = 7

	select 
	Or_ID,
	Or_Num,
	Or_Audit,
	Or_Date,
	Or_Date_Ch,
	Or_Seti_ID,
	Or_Seti_Name,
	Or_Base_GLN,
	Or_Base_Name,
	Or_Address_GLN,
	Or_Address_Name,
	Or_CompID,
	Or_CompID_Ch,
	isnull((select CompName from [s-sql-d4].Elit.dbo.r_Comps c where CompID = Or_CompID and Or_CompID > 0),'неизвестно'),
	Or_CompAdd,
	Or_CompAdd_Ch,
	isnull((select CompAdd from [s-sql-d4].Elit.dbo.r_CompsAdd ca where CompID = Or_CompID and CompAddID = Or_CompAdd),'неизвестно'),		
	Or_StockID,
	Or_StockID_Ch,
	isnull((select fShortName from DS_FACES (nolock) where fType = 6 and fActiveFlag = 1 and exid = cast(Or_StockID as varchar(4))),'неизвестно'),
	Or_State,
	Or_State_Ch,
	Or_Status,
	Or_Prod,
	Or_Log,
	Or_Invoice
	from #tmp
	order by Or_Audit desc, Or_Date_Ch;

	drop table #tmp
	
END



GO
