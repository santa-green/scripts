SELECT d.ProdID, p.ProdName, p.PGrID, d.UM, mq.Qty AS MQQty,
    CAST(REPLACE(REPLACE(REPLACE(pp.File3,'' '',''''),'','','', ''),''-'',''- '') AS VARCHAR(250)) File3, pp.DLSDate,
    SUM(d.Qty) AS TQty, 
    (SELECT ISNULL((SELECT MAX(LTRIM(RTRIM(d1.UM)))FROM dbo.av_t_Exc m1 WITH(NOLOCK)
    JOIN dbo.av_t_ExcD d1 WITH(NOLOCK) ON d1.ChID=m1.ChID JOIN r_Prods rp1 WITH(NOLOCK) ON rp1.ProdID=d1.ProdID
    JOIN r_ProdG1 g11 WITH(NOLOCK) ON g11.PGrID1=rp1.PGrID1
    WHERE (' + ReplaceStr(AFilter,'m.','m1.') + ') AND
    ISNULL(NULLIF(g11.StorageAreas, ''''), ''Крепкая группа'') =
    ISNULL(NULLIF(g1.StorageAreas, ''''), ''Крепкая группа'')
    HAVING COUNT(DISTINCT LTRIM(RTRIM(d.UM))) = 1),''од.'')) GUM,
    ISNULL(NULLIF(g1.StorageAreas, ''''), ''Крепкая группа'') AS PGrName 
    ,SUM(p.WeightGrWP * d.Qty) TWeight     --WeightGrWP	Вес брутто (с уп.)     
    FROM dbo.av_t_Exc m WITH(NOLOCK) JOIN --t_Exc	Перемещение товара: Заголовок
    dbo.av_t_ExcD d WITH(NOLOCK) ON d.ChID=m.ChID LEFT JOIN --t_ExcD	Перемещение товара: Товар (СУММИРУЕМ!)
    dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID=d.ProdID AND mq.UM=''ящ.'' JOIN --r_ProdMQ	Справочник товаров - Виды упаковок
    dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID JOIN
    dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID JOIN --t_PInP	Справочник товаров: Цены прихода Торговли
    dbo.r_ProdG1 g1 WITH(NOLOCK) ON g1.PGrID1=p.PGrID1 --r_ProdG1	Справочник товаров: Подгруппа 1
    WHERE ' + AFilter + #13 +
    GROUP BY d.ProdID, p.ProdName, p.PGrID, mq.Qty, --PGrID	Группа
    ISNULL(NULLIF(g1.StorageAreas, ''''), ''Крепкая группа''), --Storage areas = места хранения.
    CAST(REPLACE(REPLACE(REPLACE(pp.File3,'' '',''''),'','','', ''),''-'',''- '') AS VARCHAR(250)), pp.DLSDate, d.UM --file3 = дата изготовления.
    ORDER BY PGrName, p.ProdName --PGrName	Имя группы
