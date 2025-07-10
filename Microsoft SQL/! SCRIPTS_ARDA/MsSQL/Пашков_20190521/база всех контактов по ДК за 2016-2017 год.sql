--база всех контактов по ДК за 2016-2017 год 
SELECT gor.город, gor.DCardID, gor.maxDocTime, gor.sumTRealSum ,gor.COUNTTRealSum, gor.AVGTRealSum, 
dc.Discount, dc.InUse, dc.ClientName, CASE dc.DCTypeCode WHEN 1 THEN 'Индивидуальная' WHEN 2 THEN 'Накопительная' END, dc.BirthDate, dc.PhoneMob, dc.EMail FROM (
SELECT gr.город, gr.DCardID , max(gr.DocTime) maxDocTime, SUM(gr.TRealSum) sumTRealSum, COUNT(gr.TRealSum) COUNTTRealSum, AVG(gr.TRealSum) AVGTRealSum FROM (
SELECT CASE WHEN m.CRID in (4,10,101,102,103,104,106,108,109,110,120,154,160,159,180) THEN 'ДНЕПР' 
			WHEN m.CRID in (5,201,202,203,211) THEN 'КИЕВ' 
			WHEN m.CRID in (300,350) THEN 'ХАРЬКОВ' 
			WHEN m.CRID in (8) THEN 'ОДЕССА' 
			ELSE str(m.CRID) END as 'город',  
d.DCardID, m.DocTime, m.TRealSum
FROM t_Sale m
join z_DocDC d on d.ChID = m.ChID 
where d.DocCode = 11035 
and d.DCardID <> '<Нет дисконтной карты>'
and TRealSum <>0
and m.DocDate > '2016-01-01'
) gr
group by город, DCardID
)gor
join r_DCards dc on dc.DCardID = gor.DCardID 
where dc.PhoneMob  <> ''
or dc.EMail  <> ''  
order by 1,2
