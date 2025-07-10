--обновление города ДК по первой покупке
/*
BEGIN TRAN

UPDATE  r_DCards
SET FactCity = up.город
from r_DCards 
join (
	SELECT d.DCardID, m2.DocTime, 
		CASE WHEN m2.CRID in (4,501,502,10,11,12,13,14,15,101,102,103,104,105,106,107,108,109,110,120,151,152,153,154,156,157,158,159,160,161,180,181) THEN 'ДНЕПР' 
					WHEN m2.CRID in (5,201,202,203,204,205,206,207,208,209,210,211) THEN 'КИЕВ' 
					WHEN m2.CRID in (6,300,301,302,350) THEN 'ХАРЬКОВ' 
					WHEN m2.CRID in (8,401) THEN 'ОДЕССА' 
					ELSE str(m2.CRID) END as 'город',
					dc.FactCity, dc.ChID as r_DCards_ChID
	FROM t_Sale m2
	join z_DocDC d on d.ChID = m2.ChID and d.DocCode = 11035 and d.DCardID <> '<Нет дисконтной карты>'and TRealSum <>0 
	join (
			SELECT DCardID, MIN(gr.DocTime) as MinDocTime FROM (
				SELECT d.DCardID, m.DocTime, m.CRID
				FROM t_Sale m
				join z_DocDC d on d.ChID = m.ChID 
				where d.DocCode = 11035 
				and d.DCardID <> '<Нет дисконтной карты>'
				and TRealSum <>0
			) gr group by DCardID
		) gr2 on gr2.DCardID = d.DCardID and gr2.MinDocTime = m2.DocTime
	join r_DCards dc on dc.DCardID = gr2.DCardID
) up on up.DCardID = r_DCards.DCardID
where isnull(r_DCards.FactCity, '') not in ('ДНЕПР','КИЕВ','ХАРЬКОВ')


SELECT * FROM r_DCards 
where isnull(r_DCards.FactCity, '') not in ('ДНЕПР','КИЕВ','ХАРЬКОВ')
and DCTypeCode in (1,2) and InUse = 1

ROLLBACK TRAN
*/





SELECT d.DCardID, m2.DocTime, 
CASE WHEN m2.CRID in (4,501,502,10,11,12,13,14,15,101,102,103,104,105,106,107,108,109,110,120,151,152,153,154,156,157,158,159,160,161,180,181) THEN 'ДНЕПР' 
			WHEN m2.CRID in (5,201,202,203,204,205,206,207,208,209,210,211) THEN 'КИЕВ' 
			WHEN m2.CRID in (6,300,301,302,350) THEN 'ХАРЬКОВ' 
			WHEN m2.CRID in (8,401) THEN 'ОДЕССА' 
			ELSE str(m2.CRID) END as 'город'
, dc.FactCity, dc.ChID as r_DCards_ChID
,* 
FROM t_Sale m2
join z_DocDC d on d.ChID = m2.ChID and d.DocCode = 11035 and d.DCardID <> '<Нет дисконтной карты>'and TRealSum <>0 
join (
		SELECT DCardID, MIN(gr.DocTime) as MinDocTime FROM (
			SELECT d.DCardID, m.DocTime, m.CRID
			FROM t_Sale m
			join z_DocDC d on d.ChID = m.ChID 
			where d.DocCode = 11035 
			and d.DCardID <> '<Нет дисконтной карты>'
			and TRealSum <>0
		) gr group by DCardID
	) gr2 on gr2.DCardID = d.DCardID and gr2.MinDocTime = m2.DocTime
join r_DCards dc on dc.DCardID = gr2.DCardID
where isnull(dc.FactCity, '') not in ('ДНЕПР','КИЕВ','ХАРЬКОВ') --or dc.FactCity is null
ORDER BY dc.FactCity 



