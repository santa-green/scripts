ALTER PROCEDURE [dbo].[ap_VC_GetNewOrdersToReg]
AS
/*
Процедура, которая достает новые заказы со старого интернет-магазина и добавляет их в реестр.
*/
BEGIN
/*
EXEC ap_VC_GetNewOrdersToReg
*/
  SET NOCOUNT ON
  SET XACT_ABORT ON

  DECLARE @new_orders TABLE
  (	DocID INT,
	DocDate SMALLDATETIME,
	ExpDate SMALLDATETIME,
	ExpTime VARCHAR(250),
	ClientID BIGINT,
	Address VARCHAR(250),
	Notes VARCHAR(250),
	PayFormCode INT,
	Recipient VARCHAR(250),
	Phone VARCHAR(250),
	DeliveryType VARCHAR(250),
	DeliveryPriceCC NUMERIC(21, 2),
	RegionID INT,
	CompType TINYINT,
	Code VARCHAR(20),
	DCardID VARCHAR(250),
	ShopifyOrderID BIGINT,
	ImportDate SMALLDATETIME,
	Status INT)
  
  INSERT INTO @new_orders
  SELECT
   Id DocID, create_Date DocDate, dos_Date ExpDate,  Value ExpTime, COALESCE(user_id,0) ClientID, name_for_np+' '+dos_Adr Address, SUBSTRING(dos_Com,1,250) Notes, 
   CASE Payment WHEN 'cash' THEN 1 WHEN 'noncash' THEN 2 END PayFormCode, Name Recipient, Phone,
   dos_Type DeliveryType, dos DeliveryPriceCC, Region RegionID, 
   CASE type_register WHEN 'fast' THEN 1 WHEN 'physical' THEN 1 WHEN 'juridical' THEN 2 END CompType, ISNULL(RegInfoOKPO, '') Code, 
   CASE WHEN create_Date + CAST(create_Time AS DATETIME) > discount_registration THEN CAST(discount_num AS VARCHAR(250)) ELSE '<Нет дисконтной карты>' END DCardID
   ,0 ShopifyOrderID , GETDATE() ImportDate, 0 Status
  FROM OPENQUERY(VintageClub,
	'SELECT HIGH_PRIORITY
	 o.Id, o.create_Date, o.create_Time, o.dos_Date, t.Value, o.user_Id, d.name_for_np, o.dos_Adr, o.dos_Com, o.Phone, o.Payment,
	 o.Name, o.dos_Type, o.Dos, o.Region, o.type_register, j.RegInfoOKPO, disc.discount_num, disc.discount_registration
	FROM vintagemarket.order o
	JOIN vintagemarket.dostavka d ON d.Id = o.dos_Sity
	LEFT JOIN vintagemarket.dostavka_time t ON t.Id = o.dos_Time
	LEFT JOIN vintagemarket.users u ON u.Id = o.user_Id
	LEFT JOIN vintagemarket.discount disc ON disc.discount_num = u.discount_Num AND disc.status = ''active''
	LEFT JOIN vintagemarket.users_juristic j ON j.user_Id = o.user_id AND o.type_register = ''juridical''
	WHERE o.Imported = 0 AND  o.Id > 130123
	  AND o.dos_Date >= o.create_Date
	ORDER BY Id DESC
	') vc
  WHERE NOT EXISTS (SELECT * FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = vc.Id)
    AND EXISTS (SELECT * FROM dbo.at_r_Clients WITH(NOLOCK) WHERE ClientID = COALESCE(vc.user_id,0))
    AND (EXISTS (SELECT * FROM dbo.r_Comps WITH(NOLOCK) WHERE Code = vc.RegInfoOKPO AND vc.type_register = 'juridical') OR vc.type_register IN ('fast','physical'))
    AND (EXISTS(SELECT * FROM dbo.r_DCards WHERE DCardID = CASE WHEN vc.create_Date + CAST(vc.create_Time AS DATETIME) > vc.discount_registration THEN CAST(vc.discount_num AS VARCHAR(250)) ELSE '<Нет дисконтной карты>' END))    
	AND NOT EXISTS (SELECT 1 FROM t_IMOrders WHERE DocID = vc.Id)
  
  IF NOT EXISTS(SELECT DocID FROM @new_orders)
  BEGIN
	RETURN
  END;

  INSERT INTO t_IMOrders
  SELECT DocID,	DocDate, ExpDate, ExpTime, ClientID, Address,
		 Notes, PayFormCode, Recipient, Phone, DeliveryType,
		 DeliveryPriceCC, RegionID, CompType, Code, DCardID,
		 ShopifyOrderID, ImportDate, Status
  FROM @new_orders

  INSERT INTO t_IMOrdersD
  SELECT
   DocID, ROW_NUMBER() OVER (PARTITION BY DocID ORDER BY DocID, PosID) PosID, 
   ProdID, Qty, dbo.af_VC_GetPriceCC(2,ProdID,0) PurPrice, Discount, 
   CASE WHEN RemSch LIKE '%опт%' THEN 1 WHEN RemSch LIKE '%розн%' THEN 2 END RemSchID, 
   CASE WHEN COALESCE(vip,1) IN (1,2) THEN 0 WHEN COALESCE(vip,1) IN (3,4) THEN 1 END IsVIP
  FROM OPENQUERY(VintageClub,
	'SELECT HIGH_PRIORITY 
	  o.Id DocID, oi.id PosID, ot.item_id ProdID, ot.Count Qty, ot.Discount, s.name RemSch, u.vip, o.Region
	FROM vintagemarket.order_tmp ot
	JOIN vintagemarket.order_item oi on oi.order_Id = ot.order_Id and oi.unikod = ot.item_id
	JOIN vintagemarket.order o ON o.Id = oi.Order_Id
	LEFT JOIN vintagemarket.users u ON u.Id = o.user_id
	JOIN vintagemarket.storage s ON s.storage_Id = ot.storage_id
	WHERE o.Imported = 0 AND  o.Id > 130123
	  AND o.dos_Date >= o.create_Date
	ORDER BY o.Id, oi.Id  
	') vc 
  WHERE vc.DocID IN (SELECT DocID FROM @new_orders)
  
END