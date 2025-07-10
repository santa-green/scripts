declare @chid int = 2683

select * from t_sale where chid=@chid

select * from t_saled where chid= @chid

select * from t_SaleDLV where chid = @chid

select * from t_SalePays where chid= @chid

select * from t_SaleC where chid= @chid



select *     FROM t_Sale m
   WHERE m.ChID IN (SELECT m.ChID 
                      FROM t_Sale m WITH(NOLOCK)
                      LEFT JOIN t_SaleD d WITH(NOLOCK) ON m.ChID = d.ChID
                      LEFT JOIN t_SaleDLV l WITH(NOLOCK) ON l.ChID = m.ChID
                  GROUP BY m.ChID, m.TSumCC_nt, m.TSumCC_wt, m.TTaxSum, m.TPurTaxSum, m.TPurSumCC_nt, m.TPurSumCC_wt, m.TRealSum, m.TLevySum
                    HAVING ((m.TSumCC_nt != ISNULL(SUM(d.SumCC_nt),0) 
                        OR m.TSumCC_wt != ISNULL(SUM(d.SumCC_wt),0) 
                        OR m.TTaxSum != ISNULL(SUM(d.TaxSum),0)
                        OR m.TPurTaxSum != ISNULL(SUM(d.PurTax * d.Qty),0)
                        OR m.TPurSumCC_nt != ISNULL(SUM(d.PurPriceCC_nt * d.Qty),0))
                        OR m.TPurSumCC_wt != ISNULL(SUM(d.PurPriceCC_wt * d.Qty),0)
                        OR m.TRealSum != ISNULL(SUM(d.RealSum),0)
                        OR m.TLevySum != ISNULL(SUM(l.LevySum),0)))