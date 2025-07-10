SELECT SUM(SumCC_wt) FROM t_Sale_R m WHERE cast(m.DocTime as date) in ('20210629', '20210630')
SELECT SUM(SumCC_wt) FROM t_Sale_R m WHERE cast(m.DocTime as date) BETWEEN '20210629' AND '20210630'
SELECT SUM(SumCC_wt) FROM t_Sale_R m WHERE cast(m.DocTime as date) >= '20210629'

SELECT m.DocTime 'Открытие чека', m.DocCreateTime 'Закрытие чека' FROM t_Sale_R m WHERE cast(m.DocTime as date) in ('20210629', '20210630') ORDER BY DocTime

SELECT m.DocTime 'Открытие чека', m.DocCreateTime 'Закрытие чека' FROM t_Sale m 
WHERE CRID in (153) and cast(m.DocTime as date) in ('20210629', '20210630') ORDER BY DocTime

SELECT SUM(TSumCC_wt) FROM t_Sale m --при импорте из t_Sale_R в t_Sale некоторые чеки могут заливаться в другие дни (перекос по дням). Поэтому точнее смотреть в t_Sale_R!
WHERE 
    CRID in (153, 160, 109) 
    AND CodeID3 in (27, 81, 89) 
    AND cast(m.DocDate as date) in ('20210629', '20210630')


SELECT * FROM t_Sale_R
SELECT SUM(TRealSum) FROM t_Sale WHERE CRID in (153, 160, 109) AND CodeID3 in (27, 81, 89) and DocDate = '20210629'--and docid = 231899
