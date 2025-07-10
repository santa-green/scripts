USE Elit
--EXCEL формула (если № налоговой <> 4, надо скорректировать) ="SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = "&ПСТР(A29;32;4)&" and m.TaxDocDate = "&"'"&ПСТР(A29;40;10)&"'"&" --"&B29

	  SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4300 and m.TaxDocDate = '2018-11-14' --2018-11-22 12:07:11Z Суммы не сходятся 83928.48 <> 78575.16
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4301 and m.TaxDocDate = '2018-11-14' --2018-11-22 12:07:11Z Суммы не сходятся 80615.58 <> 75411.96
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4299 and m.TaxDocDate = '2018-11-14' --2018-11-22 12:07:11Z Суммы не сходятся 38271.66 <> 36478.74
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4782 and m.TaxDocDate = '2018-11-15' --2018-11-22 12:07:11Z Суммы не сходятся 31899.36 <> 30105.42
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4778 and m.TaxDocDate = '2018-11-15' --2018-11-22 12:07:11Z Суммы не сходятся 74834.70 <> 70333.80
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4781 and m.TaxDocDate = '2018-11-15' --2018-11-22 12:07:11Z Суммы не сходятся 24957.42 <> 24130.68
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4780 and m.TaxDocDate = '2018-11-15' --2018-11-22 12:07:11Z Суммы не сходятся 18397.50 <> 17796.48
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4776 and m.TaxDocDate = '2018-11-15' --2018-11-22 12:07:12Z Суммы не сходятся 42199.92 <> 39811.14
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4774 and m.TaxDocDate = '2018-11-15' --2018-11-22 12:07:12Z Суммы не сходятся 51368.52 <> 48471.72
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4773 and m.TaxDocDate = '2018-11-15' --2018-11-22 12:07:12Z Суммы не сходятся 2784.06 <> 2700.48
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 4779 and m.TaxDocDate = '2018-11-15' --2018-11-22 12:07:12Z Суммы не сходятся 13423.26 <> 13034.10
UNION SELECT m.TSumCC_wt,M.OrderID,* FROM t_Inv m WHERE m.TaxDocID = 6211 and m.TaxDocDate = '2018-11-20' --2018-11-22 12:07:12Z Суммы не сходятся 774.30 <> 1210.98
UNION select m.TSumCC_wt,M.OrderID,* from t_Inv m WHERE m.TaxDocID = 26 and m.TaxDocDate = '2018-11-01' --2018-11-22 12:07:10Z Суммы не сходятся 48263.34 <> 48223.38
UNION select m.TSumCC_wt,M.OrderID,* from t_Inv m WHERE m.TaxDocID = 27 and m.TaxDocDate = '2018-11-01' --2018-11-22 12:07:10Z Суммы не сходятся 4807.44 <> 4762.80
UNION select m.TSumCC_wt,M.OrderID,* from t_Inv m WHERE m.TaxDocID = 29 and m.TaxDocDate = '2018-11-01' --2018-11-22 12:07:10Z Суммы не сходятся 17936.46 <> 18223.86
UNION select m.TSumCC_wt,M.OrderID,* from t_Inv m WHERE m.TaxDocID = 488  and m.TaxDocDate = '2018-11-02 ' --2018-11-22 12:07:10Z Суммы не сходятся 18584.76 <> 18500.16
UNION select m.TSumCC_wt,M.OrderID,* from t_Inv m WHERE m.TaxDocID = 1955 and m.TaxDocDate = '2018-11-07' --2018-11-22 12:07:10Z Суммы не сходятся 60724.92 <> 61897.56
UNION select m.TSumCC_wt,M.OrderID,* from t_Inv m WHERE m.TaxDocID = 1956 and m.TaxDocDate = '2018-11-07' --2018-11-22 12:07:10Z Суммы не сходятся 15321.6 <> 17666.88

ORDER BY 2

select * from az_EDI_Invoices_ M where  M.AEI_INV_DATE = '2018-11-20'  --AEI_P7S_NAME = 'comdoc_20181120142735_432943781_5114012816_007.p7s'
select * from az_EDI_Invoices_ M where  M.AEI_DOC_ID = '5114012816'  --AEI_P7S_NAME = 'comdoc_20181120142735_432943781_5114012816_007.p7s'

