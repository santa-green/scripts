SELECT * FROM [s-sql-d4].[elit].dbo.z_tables WHERE tableName LIKE '%t_Ret%'
SELECT * FROM [s-sql-d4].[elit].dbo.z_FieldsRep WHERE dbo.z_FieldsRep.FieldName like '%NewPPID%' OR dbo.z_FieldsRep.FieldDesc like '%NewPPID%'
SELECT * FROM r_Uni WHERE RefTypeID = 80019 and RefID in (7001,7003,7011,7031)

        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	Нов Партия
    SELECT rpg1.PGrID1, SUM(0-(d.Qty * tpi.CostMC)) 'SumMC'


    SELECT PartID '№', PartIDName 'Данные', [5],[4],[6],[3],[1],[100] FROM temp_corp_6_1 
PIVOT ( 
MAX(TOTALS) FOR PGrID1 IN ([5],[4],[6],[3],[1],[100]) 
) as pvt
ORDER BY 1