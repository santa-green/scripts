--BEGIN TRAN;

--INSERT INTO [S-SQL-D4].[ElitR].[dbo].[z_ReplicaIn]
SELECT 
      zre.ReplicaEventID*-1 AS ReplicaEventID, zre.ReplicaPubCode AS ReplicaSubCode
	 ,CASE WHEN zre.ReplEventType = 0
               THEN 'z_Replica_INS '
			WHEN zre.ReplEventType = 1
               THEN 'z_Replica_UPD '
			ELSE '' END
	   + CAST(zre.ReplicaPubCode AS VARCHAR(20)) + ','''
	   + zt.TableName + ''','
	   + CASE WHEN zre.ReplEventType = 0 
	            THEN '''' + zre.ChangeFields + ''',' + '''' + SUBSTRING(REPLACE(zre.ChangeFieldValues, '''',''''''),1,CHARINDEX('^^',REPLACE(zre.ChangeFieldValues, '''',''''''))-1) + ''',1'
			  WHEN zre.ReplEventType = 1
			    THEN '''' + zre.ChangeFields + ''',' + '''' + SUBSTRING(REPLACE(zre.ChangeFieldValues, '''',''''''),1,CHARINDEX('^^',REPLACE(zre.ChangeFieldValues, '''','''''')) ) + ''',''' + zre.PKFields + ''',''' + zre.PKValue +  ''',1'
			  ELSE '' END  AS ExecStr
	,0 AS 'Status'
	, 'Maslov Oleg ' + CONVERT(VARCHAR,GETDATE(),120) + ' Ёти записи выпали из синхронизации.' AS Msg
	, CAST(GETDATE() AS SMALLDATETIME) AS DocTime
FROM z_ReplicaEvents zre
LEFT JOIN z_Tables zt on zre.TableCode = zt.TableCode
WHERE (zre.PKValue LIKE '%100750546%' OR zre.ChangeFieldValues LIKE '%100750546%')
   AND zre.ReplicaEventID < 1892431
ORDER BY ReplicaEventID DESC

--ROLLBACK TRAN;

/*
z_Replica_INS 100000001,'t_SaleD','ChID^;^SrcPosID^;^ProdID^;^PPID^;^UM^;^Qty^;^PriceCC_nt^;^SumCC_nt^;^Tax^;^TaxSum^;^PriceCC_wt^;^SumCC_wt^;^BarCode^;^SecID^;^PurPriceCC_nt^;^PurTax^;^PurPriceCC_wt^;^PLID^;^Discount^;^DepID^;^IsFiscal^;^SubStockID^;^OutQty^;^EmpID^;^CreateTime^;^ModifyTime^;^TaxTypeID^;^RealPrice^;^RealSum','100750547^;^1^;^600728^;^0^;^''пл€ш''^;^1.000000000^;^325.000000000^;^325.000000000^;^65.000000000^;^65.000000000^;^390.000000000^;^390.000000000^;^''7791203001231''^;^1^;^416.666666670^;^83.333333330^;^500.000000000^;^70^;^0.000000000^;^0^;^1^;^0^;^1.000000000^;^10724^;^''2019-11-20T09:49:55.630''^;^''2019-11-20T09:49:55.630''^;^0^;^390.000000000^;^390.000000000',1
z_Replica_INS 100000001,'t_SaleD','ChID^;^SrcPosID^;^ProdID^;^PPID^;^UM^;^Qty^;^PriceCC_nt^;^SumCC_nt^;^Tax^;^TaxSum^;^PriceCC_wt^;^SumCC_wt^;^BarCode^;^SecID^;^PurPriceCC_nt^;^PurTax^;^PurPriceCC_wt^;^PLID^;^Discount^;^DepID^;^IsFiscal^;^SubStockID^;^OutQty^;^EmpID^;^CreateTime^;^ModifyTime^;^TaxTypeID^;^RealPrice^;^RealSum','100750547^;^1^;^600728^;^0^;^''пл€ш''^;^1.000000000^;^325.000000000^;^325.000000000^;^65.000000000^;^65.000000000^;^390.000000000^;^390.000000000^;^''7791203001231''^;^1^;^416.666666670^;^83.333333330^;^500.000000000^;^70^;^0.000000000^;^0^;^1^;^0^;^1.000000000^;^10724^;^''2019-11-20T09:49:55.630''^;^''2019-11-20T09:49:55.630''^;^0^;^390.000000000^;^390.000000000',1

SELECT * FROM [S-SQL-D4].[ElitR].[dbo].[z_ReplicaIn]

z_Replica_UPD 100000001,'t_Sale','StateCode','22^;^','ChID','100750546',1
z_Replica_UPD 100000001,'t_Sale','StateCode','22^;^','ChID','100750546',1

SELECT * FROM z_ReplicaEvents zre
LEFT JOIN z_Tables zt on zre.TableCode = zt.TableCode
WHERE (zre.PKValue LIKE '%100750546%' OR zre.ChangeFieldValues LIKE '%100750546%')
   --AND zre.ReplicaEventID < 1892431
   z_Replica_INS 100000001,'z_LogDiscExp','LogID^;^TempBonus^;^DocCode^;^ChID^;^SrcPosID^;^DiscCode^;^SumBonus^;^Discount^;^LogDate^;^BonusType^;^GroupSumBonus^;^GroupDiscount^;^DBiID^;^DCardChID','1994722^;^0^;^11035^;^100750547^;^1^;^27^;^0.000000000^;^22.000000000^;^''2019-11-20T09:50:00''^;^0^;^NULL^;^NULL^;^2^;^0',1
SELECT * FROM z_LogDiscExp WHERE LogID = 1994720

SELECT * FROM [dbo].[z_ReplicaCMDs]
SELECT * FROM [dbo].[z_ReplicaConfigEvents]
SELECT * FROM [dbo].[z_ReplicaConfigIn]
*/