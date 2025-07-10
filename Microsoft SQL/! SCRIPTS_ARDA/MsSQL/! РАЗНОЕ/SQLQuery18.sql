--Галя.
SELECT pp.DLSDate, pp.File3, p.PGrID, d.ProdID, p.ProdName, SUM(d.Qty) TQty, SUM(p.WeightGrWP * d.Qty) TWeight, d.UM,
ISNULL(NULLIF(g1.StorageAreas, ''), 'Крепкая группа') AS PGrName,
SUM(d.Qty) - ISNULL(ROUND(SUM(d.Qty)/mq.Qty,0,1)*mq.Qty,0) TQty1,
ROUND(SUM(d.Qty)/mq.Qty,0,1) TQty2,
(SELECT ISNULL((SELECT MAX(LTRIM(RTRIM(d1.UM))) FROM t_Inv m1 WITH(NOLOCK)
JOIN t_InvD d1 WITH(NOLOCK) ON d1.ChID=m1.ChID JOIN r_Prods rp1 WITH(NOLOCK) ON rp1.ProdID=d1.ProdID
JOIN r_ProdG1 g11 WITH(NOLOCK) ON g11.PGrID1=rp1.PGrID1
WHERE 2=0 AND
ISNULL(NULLIF(g11.StorageAreas, ''), 'Крепкая группа') =
ISNULL(NULLIF(g1.StorageAreas, ''), 'Крепкая группа')
HAVING COUNT(DISTINCT LTRIM(RTRIM(d.UM))) = 1),'од.')) GUM

FROM dbo.t_Inv m WITH(NOLOCK)
JOIN dbo.t_InvD d WITH(NOLOCK) ON d.ChID=m.ChID
LEFT JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID=d.ProdID AND mq.UM='ящ.' AND mq.Qty != 0 --r_ProdMQ	Справочник товаров - Виды упаковок
JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID
JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID --t_PInP	Справочник товаров: Цены прихода Торговли
JOIN dbo.r_ProdG1 g1 WITH(NOLOCK) ON g1.PGrID1=p.PGrID1 --r_ProdG1	Справочник товаров: Подгруппа 1

WHERE 1=0
GROUP BY pp.DLSDate, pp.File3, p.PGrID, d.ProdID, p.ProdName, d.UM, mq.Qty,ISNULL(NULLIF(g1.StorageAreas, ''), 'Крепкая группа')
--DLSDate	Кон. срок реализации
--PGrID	Группа	Код группы
ORDER BY PGrName, p.PGrID, ProdName

SELECT CodeID3 FROM r_Codes3 WITH(NOLOCK) WHERE CForm = 1
  // Формируем строку фильтра
  AFilter := 'm.OurID=' + VarToStr(ctl_OurFirm.KeyValue) + ' AND (' + СписокВУсловиеSQL('m.DocID', ctl_DocIDs.Text) + ')' +
    ' AND m.CodeID3 IN (SELECT CodeID3 FROM r_Codes3 WITH(NOLOCK) WHERE CForm = 1)';


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*TEST*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM [s-sql-d4].[elit].dbo.z_tables WHERE tableName LIKE '%r_ProdMQ%' OR tableDesc LIKE '%t_PInP%';
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME like '%t_PInP%'

SELECT NULLIF(4,4) AS Same, NULLIF(5,7) AS Different
SELECT * FROM [s-sql-d4].[elit].dbo.z_FieldsRep WHERE dbo.z_FieldsRep.FieldName like '%PGrID%' OR dbo.z_FieldsRep.FieldDesc like '%PGrID%'