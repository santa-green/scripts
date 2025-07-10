USE ElitR
GO
;WITH S2_CTE AS (
SELECT * 
    ,(SELECT cast(sum(qty) as numeric(21,9)) FROM t_sale_r r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) Tqty_R --4
    ,(SELECT sum(qty) FROM t_saleD d with (nolock) where d.chid = (SELECT chid FROM t_sale r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) ) Tqty --6

    ,(SELECT cast(sum(SumCC_wt) as numeric(21,9)) FROM t_sale_r r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) TSumCC_wt_R --330
    ,(SELECT sum(RealSum) FROM t_saleD d with (nolock) where d.chid = (SELECT chid FROM t_sale r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) ) TRealSum --520
    ,(SELECT sum(SumCC_wt) FROM t_SalePays d with (nolock) where d.chid = (SELECT chid FROM t_sale r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) ) TSalePays --520
    ,(SELECT sum(SumAC) FROM t_MonRec r with (nolock) where r.Docid = s1.Docid and r.OurID = s1.OurID) TSumAC_MonRec
    --SELECT * FROM t_MonRec r with (nolock) where r.Docid = 231530
FROM 
(SELECT distinct Docid,OurID FROM t_sale_r with (nolock) where Docdate >= DATEADD(day ,-15,dbo.zf_GetDate(getdate())) ) s1
)

--check
SELECT *
FROM S2_CTE 
--WHERE Docid = 231530
where round(Tqty_R , 3) <> round(Tqty , 3)
	or round(TSumCC_wt_R , 2) <> round(TRealSum , 2)
	or round(TSumCC_wt_R , 2) <> round(TSalePays , 2)
	or round(TSumCC_wt_R , 2) <> round(TSumAC_MonRec , 2)
    --[FIXED] '2021-05-17 16:02' rkv0 добавил проверку на IS NULL
    or Tqty_R IS NULL or Tqty IS NULL or TRealSum IS NULL

SELECT 'distinct'; SELECT distinct Docid,OurID FROM t_sale_r with (nolock) where Docdate >= DATEADD(day ,-15,dbo.zf_GetDate(getdate())) 
SELECT 't_sale_r'; SELECT qty, * FROM t_sale_r WHERE Docid = 231530
SELECT 't_SaleD'; SELECT qty, * FROM t_SaleD WHERE ChID = 1800026873
SELECT 't_Sale'; SELECT * FROM t_Sale WHERE ChID = 1800026873 --Docid = 231530
SELECT 't_Sale'; SELECT * FROM t_Sale WHERE Docid = 231530
SELECT 't_Sale'; SELECT * FROM t_Sale WHERE DocDate = '2021-05-07 00:00:00'

	SELECT DISTINCT docid , crid  FROM t_Sale_R
		WHERE   Docid  in (231530) --****************************************************************************************
		--or Docid  in (231313) 
		ORDER BY docid 
