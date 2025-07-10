SELECT * FROM t_saletemp where DocDate = CAST(GETDATE() as DATE)
and CRID between 104 and 159
order by 4 desc
100197453

SELECT * FROM t_saletempd where ChID = 100197453

SELECT * FROM t_sale where DocDate = CAST(GETDATE() as DATE)
and CRID between 104 and 159
order by DocTime desc


SELECT * FROM z_LogDiscRec where ChID in (
	SELECT ChID FROM t_sale where DocDate = CAST(GETDATE() as DATE)
	and CRID between 104 and 159)

	
	
SELECT * FROM z_LogDiscRec where  LogDate between CAST(GETDATE() as DATE) and CAST(GETDATE()+1 as DATE)
and DCardID = '2220000313223'
order by LogDate desc
