--���� ���� ��������� �� �� �� 2016-2017 ��� 
SELECT gor.�����, gor.DCardID, gor.maxDocTime, gor.sumTRealSum ,gor.COUNTTRealSum, gor.AVGTRealSum, 
dc.Discount, dc.InUse, dc.ClientName, CASE dc.DCTypeCode WHEN 1 THEN '��������������' WHEN 2 THEN '�������������' END, dc.BirthDate, dc.PhoneMob, dc.EMail FROM (
SELECT gr.�����, gr.DCardID , max(gr.DocTime) maxDocTime, SUM(gr.TRealSum) sumTRealSum, COUNT(gr.TRealSum) COUNTTRealSum, AVG(gr.TRealSum) AVGTRealSum FROM (
SELECT CASE WHEN m.CRID in (4,10,101,102,103,104,106,108,109,110,120,154,160,159,180) THEN '�����' 
			WHEN m.CRID in (5,201,202,203,211) THEN '����' 
			WHEN m.CRID in (300,350) THEN '�������' 
			WHEN m.CRID in (8) THEN '������' 
			ELSE str(m.CRID) END as '�����',  
d.DCardID, m.DocTime, m.TRealSum
FROM t_Sale m
join z_DocDC d on d.ChID = m.ChID 
where d.DocCode = 11035 
and d.DCardID <> '<��� ���������� �����>'
and TRealSum <>0
and m.DocDate > '2016-01-01'
) gr
group by �����, DCardID
)gor
join r_DCards dc on dc.DCardID = gor.DCardID 
where dc.PhoneMob  <> ''
or dc.EMail  <> ''  
order by 1,2
