--клиентская база

SELECT dc.DCardID, MAX(dc.FactCity) Город, MAX(dc.ClientName) ФИО,cast(MAX(dc.Discount) as Int) Скидка, MAX(dc.DCTypeCode) Тип,
MAX(dc.PhoneMob) Телефон, MAX(dc.EMail) EMail, SUM(m.TRealSum) Сумма_покупок, 
MAX(dc.SumBonus),count(m.TRealSum) Количество,
SUM(m.TRealSum)/count(m.TRealSum) Средний_чек, MAX(m.DocDate) Последняя_покупка 
FROM r_DCards dc
JOIN z_DocDC d on d.DCardID = dc.DCardID and d.DocCode = 11035
JOIN t_Sale m on m.ChID = d.ChID
where dc.InUse = 1 and dc.DCTypeCode in (1,2) and m.TRealSum > 0 
group by dc.DCardID
--having  SUM(m.TRealSum) <> MAX(dc.SumBonus) and MAX(dc.DCTypeCode) = 2
ORDER BY 1

