--SELECT * FROM ir_AM
--SELECT * FROM ir_AMD
--SELECT * FROM ir_AMStocks

SELECT DISTINCT
       q.AMID AS 'Код АМ', q.AMName AS 'Наименование АМ'
     , q.ProdID AS 'Товар', q.ProdName AS 'Имя товара'
	 , q.EmpID AS 'Служащий', q.EmpName AS 'Имя служащего'
	 , q.ProdType AS 'Код роли', q.RefName AS 'Роль товара'
	 , q.DelGID AS 'Группа поставки', q.DelGName AS 'Имя группы поставки'
FROM (
SELECT rq.AMID, rq.AMName
     , rq.ProdID, rp.ProdName
	 , rq.EmpID, re.EmpName
	 , rq.ProdType, ru.RefName
	 , rq.DelGID, idg.DelGName 
	 , iams.StockID, rs.StockName
	 , rq.InAMID 
FROM
(
SELECT s.AMID, s.AMName, s.ProdID, ISNULL(d.EmpID, 7) AS EmpID, ISNULL(d.ProdType, 0) AS ProdType, ISNULL(d.DelGID, 0) AS DelGID
	 , CASE WHEN EXISTS(SELECT 1 FROM ir_AMD WHERE ProdID = s.ProdID AND AMID = s.AMID)
			 THEN 1
			 ELSE 0 END AS 'InAMID'
FROM (
SELECT DISTINCT m.AMID, m.AMName, d.ProdID FROM ir_AMD d
CROSS JOIN (SELECT DISTINCT AMID, AMName FROM ir_AM) m
     ) s
LEFT JOIN ir_AMD d WITH(NOLOCK) ON d.AMID = s.AMID AND d.ProdID = s.ProdID
) rq --rq = result querry
JOIN ir_AMStocks iams WITH(NOLOCK) ON iams.AMID = rq.AMID
LEFT JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = rq.ProdID
LEFT JOIN r_Emps re WITH(NOLOCK) ON re.EmpID= rq.EmpID
LEFT JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = iams.StockID
JOIN ir_DeliveryGroup idg WITH(NOLOCK) ON idg.DelGID = rq.DelGID
JOIN r_Uni ru WITH(NOLOCK) ON ru.RefID = rq.ProdType AND ru.RefTypeID = 1000002
WHERE rq.DelGID IN (22,222,322 )
--ORDER BY rq.ProdID,rq.AMID
) q

--SELECT * FROM z_Tables ORDER BY TableDesc;
--SELECT * FROM r_Uni
--SELECT * FROM r_UniTypes

