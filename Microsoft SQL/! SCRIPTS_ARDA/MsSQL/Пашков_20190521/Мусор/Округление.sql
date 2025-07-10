--SELECT distinct m.ChID, m.DocID,m.OurID,m.StockID,m.CodeID3, m.TRealSum 
--, (SELECT sum(SumAC) FROM t_MonRec mr WHERE mr.DocID =m.DocID and  mr.OurID = m.OurID ) as MonRec 
--,m.DocDate
--FROM t_Sale m
--JOIN t_SaleD d ON d.ChID = m.ChID
--JOIN r_Prods p ON p.ProdID = d.ProdID
--WHERE m.DocDate > '2018-01-01' --= dbo.zf_GetDate(GETDATE())
----and  m.OurID = 6
--and m.CodeID3 <> 27
--and round((SELECT sum(SumAC)  FROM t_MonRec mr WHERE mr.DocID =m.DocID and  mr.OurID = m.OurID ),2) <> round(m.TRealSum,2)
--ORDER BY 1


--SELECT * FROM t_MonRec mr WHERE mr.DocID in (100045592) and  mr.OurID = 6
--ORDER BY 1


select FLOOR(220.434660000,2)
select TRUNCATE(220.434660000,2)
select round(1.49,0)
select round(100.425000000 ,2)
select round(220.434990000,2)
select cast(220.434660000 as numeric(9,2))


select CEILING(220.034990000)
 
select round(2.5,0)
select round(3.5,0)

select round(11.5,0)
select round(12.5,0)

select round(11.5,0,0)
select round(12.5,0,0)


declare @var1 decimal(38,10) = 0.0000007,
        @var2 decimal(38,10) = 1;
select @var1 * @var2;

declare @var1 decimal(38,10) = 0.0000007,
        @var2 decimal(38,10) = 1,
        @res sql_variant;
set @res = @var1 * @var2;
select @res, 
       SQL_VARIANT_PROPERTY(@res, 'BaseType') as BaseType, 
       SQL_VARIANT_PROPERTY(@res, 'Precision') as Precision,
       SQL_VARIANT_PROPERTY(@res, 'Scale') as Scale;
       

       