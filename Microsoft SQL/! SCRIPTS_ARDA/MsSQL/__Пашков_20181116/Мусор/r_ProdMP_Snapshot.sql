SELECT * FROM r_ProdMP where InUse = 1



SELECT top 1000 * FROM r_ProdMPChs ORDER BY 3 desc


SELECT TOP 0 * INTO r_ProdMP_Snapshot FROM r_ProdMP


SELECT * FROM r_ProdMPChs_Snapshot


SELECT distinct PLID,(SELECT top 1 PLName FROM r_PLs where PLID = d.PLID) FROM 	t_SEstD d WITH(NOLOCK)
JOIN t_SEst m WITH(NOLOCK) ON m.ChID = d.ChID
WHERE m.DocDate > '2017-01-01'

ORDER BY 1

SELECT distinct PLID FROM t_SEstD d WITH(NOLOCK)
JOIN t_SEst m WITH(NOLOCK) ON m.ChID = d.ChID
WHERE m.DocDate > '2017-01-01'




--очистить таблицу снимка цен по прайслистам
TRUNCATE TABLE  dbo.r_ProdMP_Snapshot 

--Сделать снимок  цен по прайслистам
INSERT dbo.r_ProdMP_Snapshot
SELECT * FROM dbo.r_ProdMP 
WHERE PLID IN (70,83,84,85,86) AND InUse = 1



SELECT * FROM (
	SELECT * FROM dbo.r_ProdMP 
	WHERE PLID IN (70,83,84,85,86) AND InUse = 1
	except
	SELECT * FROM dbo.r_ProdMP_Snapshot) ex
WHERE PLID = 85

--Товар	Прайс-лист

SELECT mp.ProdID 'Товар', mp.PLID 'Прайс-лист', [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) 'Текушая цена', mp.PriceMC, mp.PromoPriceCC, s.PriceMC oldPriceMC, s.PromoPriceCC oldPromoPriceCC, mp.BDate, mp.EDate,
cast(ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2)) 'Цена до переоценки',
case when ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) then 1  else null end 'Изменение цены'
FROM dbo.r_ProdMP_Snapshot s
JOIN  dbo.r_ProdMP mp ON mp.ProdID = s.ProdID and mp.PLID = s.PLID
WHERE ISNULL( (SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
				WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) 
				<> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID)
AND [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) <> 0
ORDER BY 2,1


--(mp.PriceMC <> s.PriceMC OR mp.PromoPriceCC <> s.PromoPriceCC) 


 
and mp.PLID = 85 
and (mp.PriceMC <> s.PriceMC and mp.PromoPriceCC <> s.PromoPriceCC )
and mp.ProdID = 600006


 
  
    

SELECT * FROM z_Objects where ObjDesc like '%цена%'
SELECT * FROM z_Objects where ObjName like '%price%'
and ObjType = 'fn'
/*
aft_GetPriceCCCost
aft_GetPriceCCIn
zf_GetProdPrice_wt
*/
SELECT * FROM dbo.r_ProdMP_Snapshot
except
SELECT * FROM dbo.r_ProdMP 
WHERE PLID IN (70,83,84,85,86) AND InUse = 1
except
SELECT * FROM dbo.r_ProdMP_Snapshot



SELECT mp.ProdID 'Товар', mp.PLID 'Прайс-лист', [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) 'Текушая цена', mp.PriceMC, mp.PromoPriceCC, s.PriceMC oldPriceMC, s.PromoPriceCC oldPromoPriceCC, mp.BDate, mp.EDate,
cast(ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2)) 'Цена до переоценки',
case when ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) then 1  else null end 'Изменение цены'
FROM dbo.r_ProdMP_Snapshot s
JOIN  dbo.r_ProdMP mp ON mp.ProdID = s.ProdID and mp.PLID = s.PLID
WHERE ISNULL( (SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
				WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) 
				<> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID)
--AND [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) <> 0
and s.ProdID = 802830
ORDER BY 2,1

SELECT * FROM dbo.r_ProdMP_Snapshot where ProdID = 802800


SELECT * FROM dbo.r_ProdMP where ProdID = 802800


603562	70	159.300000000	NULL	980	0	1	138.600000000	2017-09-08 00:00:00	2017-10-01 00:00:00	0
603562	70	172.500000000	NULL	980	0	1	138.600000000	2017-09-08 00:00:00	2017-10-01 00:00:00	0

select  [dbo].[af_GetPriceToDay](600565, 70)

  SELECT  * 
  FROM r_ProdMP WITH(NOLOCK)  
  WHERE ProdID = 802830 AND PLID = 70 AND (dbo.zf_GetDate(GETDATE()) BETWEEN BDate AND EDate)  
  
  SELECT  case when (dbo.zf_GetDate(GETDATE()) BETWEEN BDate AND EDate) then PromoPriceCC else PriceMC end   
  FROM r_ProdMP WITH(NOLOCK)  
  WHERE ProdID = 802830 AND PLID = 70 
  
  
--изменения цен
SELECT mp.ProdID 'Товар', mp.PLID 'Прайс-лист', [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) 'Текушая цена', mp.PriceMC,  s.PriceMC oldPriceMC, mp.PromoPriceCC, s.PromoPriceCC oldPromoPriceCC, mp.BDate, mp.EDate, s.BDate OldBDate, s.EDate OldEDate,
cast(ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2)) 'Текущая цена до переоценки',
case when ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) then 'Сегодня изменилась цена продажи'  else 'Сегодня изменилась основная цена'  end 'Изменение цены'
FROM dbo.r_ProdMP_Snapshot s
JOIN  dbo.r_ProdMP mp ON mp.ProdID = s.ProdID and mp.PLID = s.PLID
WHERE 
(
( cast( ISNULL( (SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK)
				WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2)) 
				<> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID)
AND [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) <> 0
)
OR 
s.PriceMC <> mp.PriceMC
) --and  mp.PLID = 70
ORDER BY 2,11,1



--изменения только не акционной цены после переоценки
SELECT mp.ProdID 'Товар', mp.PLID 'Прайс-лист', [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) 'Текушая цена', mp.PriceMC,  s.PriceMC oldPriceMC, mp.PromoPriceCC, s.PromoPriceCC oldPromoPriceCC, mp.BDate, mp.EDate,
cast(ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2)) 'Текущая цена до переоценки',
case when ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) then 1  else null end 'Изменение цены'
FROM dbo.r_ProdMP_Snapshot s
JOIN  dbo.r_ProdMP mp ON mp.ProdID = s.ProdID and mp.PLID = s.PLID
WHERE 
ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) 
		= [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID)
and s.PriceMC <> mp.PriceMC
 --and  mp.PLID = 70
ORDER BY 2,1

--изменения текущей цены после переоценки
SELECT mp.ProdID 'Товар', mp.PLID 'Прайс-лист', [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) 'Текущая цена', mp.PriceMC,  s.PriceMC oldPriceMC, mp.PromoPriceCC, s.PromoPriceCC oldPromoPriceCC, mp.BDate, mp.EDate,
cast(ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2)) 'Текущая цена до переоценки',
case when ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) then 1  else null end 'Изменение цены'
FROM dbo.r_ProdMP_Snapshot s
JOIN  dbo.r_ProdMP mp ON mp.ProdID = s.ProdID and mp.PLID = s.PLID
WHERE ISNULL( (SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK)
				WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) 
				<> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID)
AND [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) <> 0
 --and  mp.PLID = 70
ORDER BY 2,1

--в разработке
--изменения текущей цены за вчера после последнего снимка
SELECT mp.ProdID 'Товар', mp.PLID 'Прайс-лист', 
cast(ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2))  'Текушая утрешняя цена',
 mp.PriceMC,  s.PriceMC oldPriceMC, s.PromoPriceCC, mp.PromoPriceCC oldPromoPriceCC, s.BDate, s.EDate,  mp.BDate OldBDate, mp.EDate OldEDate,
cast(ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot_Last p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) as numeric(21,2)) 'Текущая вчерашня цена ',
case when ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot_Last p WITH(NOLOCK) 
		WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) <> [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) then 1  else null end 'Изменение цены'
FROM dbo.r_ProdMP_Snapshot_Last s
JOIN  dbo.r_ProdMP_Snapshot mp ON mp.ProdID = s.ProdID and mp.PLID = s.PLID
WHERE ISNULL( (SELECT  PromoPriceCC FROM r_ProdMP_Snapshot_Last p WITH(NOLOCK)
				WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC ) 
	  <> 
	  ISNULL((SELECT  PromoPriceCC FROM r_ProdMP_Snapshot p WITH(NOLOCK) 
		        WHERE p.ProdID = mp.ProdID AND p.PLID = s.PLID AND (DATEADD(day ,-1,dbo.zf_GetDate(GETDATE())) BETWEEN p.BDate AND p.EDate)), s.PriceMC )
		        
--AND [dbo].[af_GetPriceToDay](mp.ProdID, mp.PLID) <> 0
 --and  mp.PLID = 70
ORDER BY 2,1


SELECT * FROM [r_ProdMP_Snapshot]
except
SELECT * FROM [r_ProdMP_Snapshot_Last]
except
SELECT * FROM [r_ProdMP_Snapshot]


SELECT * FROM [r_ProdMP_Snapshot_Last] sl
left join  [r_ProdMP_Snapshot] s on s.ProdID = sl.ProdID and s.PLID = sl.PLID --where s.ProdID is null
where s.PriceMC <> sl.PriceMC or  s.PromoPriceCC <> sl.PromoPriceCC or s.BDate <> sl.BDate or s.EDate <> sl.EDate
 

----очистить таблицу снимка цен по прайслистам
--TRUNCATE TABLE  dbo.r_ProdMP_Snapshot_Last 

----Сделать снимок  цен по прайслистам
--INSERT dbo.r_ProdMP_Snapshot_Last
--  SELECT * FROM dbo.r_ProdMP 
--  WHERE PLID IN (70,83,84,85,86) 
--  AND InUse = 1

SELECT RefID, Notes FROM r_Uni where RefTypeID = 1000000007