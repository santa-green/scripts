SELECT * FROM r_DCards
where DCTypeCode in (1,2)
order by 2


SELECT * FROM z_LogDiscRec where DCardID  = '3200046032127'
SELECT * FROM z_LogDiscExp where DCardID  = '3200046032127'
SELECT * FROM z_DocDC where DCardID  = '3200046032127'

SELECT * FROM z_LogDiscRec where DCardID  = '7858250032073'
SELECT * FROM z_LogDiscExp where DCardID  = '7858250032073'
SELECT * FROM z_DocDC where DCardID  = '7858250032073'


delete r_DCards where ChID in (100007461,100007466)

