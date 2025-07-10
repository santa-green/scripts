--Оставить только цифры в телефонном номере

SELECT PhoneMob,
isnull((
  SELECT SUBSTRING(TT.PhoneMob,V.number,1)
  FROM r_DCards TT JOIN master.dbo.spt_values V ON V.type='P' AND V.number BETWEEN 1 AND LEN(TT.PhoneMob)
  WHERE TT.ChID=T.ChID AND SUBSTRING(TT.PhoneMob,V.number,1) LIKE '[0-9]'
  ORDER BY V.number
  FOR XML PATH('')
),'') as PhoneMobNormal
FROM r_DCards T where PhoneMob  IS NOT NULL and len(PhoneMob) > 0
--and PhoneMob in ('050 310 77 62','050 310 85 96','050-311-04-75')
order by 2

--Нормализация номеров
/*
update r_DCards
set PhoneMob = isnull((
  SELECT SUBSTRING(TT.PhoneMob,V.number,1)
  FROM r_DCards TT JOIN master.dbo.spt_values V ON V.type='P' AND V.number BETWEEN 1 AND LEN(TT.PhoneMob)
  WHERE TT.ChID=T.ChID AND SUBSTRING(TT.PhoneMob,V.number,1) LIKE '[0-9]'
  ORDER BY V.number
  FOR XML PATH('')
),'')
FROM r_DCards T where PhoneMob  IS NOT NULL and len(PhoneMob) > 0
--and PhoneMob in ('050 310 77 62','050 310 85 96','050-311-04-75')
*/


SELECT * FROM  r_DCards T where PhoneMob  IS NOT NULL 
and PhoneMob in ('0503107762','0503108596','0503110475')
order by PhoneMob