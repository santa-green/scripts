--������� ���� �� ������� ���� ������� � 2016-01-01
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
--where dc.PhoneMob  <> '' or dc.EMail  <> ''  
order by 1,2


/*

SELECT DCardID, ClientName, Discount FROM r_DCards 
where InUse = 1 


SELECT * FROM z_LogDiscRec where DCardID = '2220000001458'

SELECT * FROM z_LogDiscRec where DocCode = 11035 and DBiID not in (1,2,3,4,5 ) order by LogDate desc

SELECT * FROM z_Docs order by 3


SELECT * FROM z_LogDiscExp where DocCode = 11035 order by LogDate desc

SELECT * FROM r_DCards  where  DCardID = '2220000001458'

SELECT * FROM r_DCTypes 

SELECT * FROM r_DBIs

SELECT * FROM z_DocDC

--SELECT * FROM z_ReplicaTables, z_Tables where z_Tables.TableCode = z_ReplicaTables.TableCode
--and ReplicaPubCode = 800000000


SELECT d.DCardID, max(d.ClientName) as ���,
CASE WHEN SUM(l.SumBonus) <  200   THEN  ' 0'
WHEN SUM(l.SumBonus) BETWEEN 200 AND 1999.99  THEN  ' 3'
WHEN SUM(l.SumBonus) BETWEEN 2000 AND 9999.99 THEN  ' 5'
WHEN SUM(l.SumBonus) BETWEEN 10000 AND 19999.99  THEN  ' 7'
WHEN SUM(l.SumBonus) >= 20000 THEN ' 10' END  as ������, 
SUM(l.SumBonus) as �����, 
MAX(l.LogDate) as [��������� �������],  COUNT(distinct l.ChID) as [���. �����], 
SUM(l.SumBonus)/ COUNT(distinct l.ChID) as [������� ���] 
FROM r_DCards d
join z_LogDiscRec l on l.DCardID = d.DCardID
where d.InUse = 1 
and d.DCTypeCode = 2 -- ��������������
group by d.DCardID
--having MAX(l.LogDate) <> 0 
order by d.DCardID desc

SELECT d.DCardID, max(d.DCTypeCode), max(d.ClientName) as ���,max(d.Discount) as ������, SUM(l.SumBonus) as �����, 
MAX(l.LogDate) as [��������� �������],  COUNT(distinct l.ChID) as [���. �����], 
SUM(l.SumBonus)/ COUNT(distinct l.ChID) as [������� ���] 
FROM r_DCards d
left join z_LogDiscRec l on l.DCardID = d.DCardID
where d.InUse = 1 
and d.DCTypeCode in (1,2) -- ������������
group by d.DCardID
--having MAX(l.LogDate) <> 0 
order by d.DCardID desc


SELECT DCardID,max(DocTime),max(TRealSum) FROM t_Sale
where DCardID <> '<��� ���������� �����>' --'2500000071447'
group by DCardID
order by 2 desc

SELECT DCardID, * FROM t_Sale order by DocTime desc


--����
SELECT d.DCardID,  max(d.ClientName), d.SumBonus, SUM(l.SumBonus), d.SumBonus- SUM(l.SumBonus) as razn, MAX(l.LogDate), COUNT(distinct l.ChID) FROM r_DCards d
join z_LogDiscRec l on l.DCardID = d.DCardID
join r_DBIs db on db.DBiID = l.DBiID
where d.InUse = 1 
and d.DCTypeCode = 2 -- ��������������
--and d.DCardID = '2220000001458'
group by d.DCardID, d.SumBonus
having d.SumBonus- SUM(l.SumBonus) <> 0
--having  d.SumBonus BETWEEN 1900 and 2100
order by razn desc






SELECT dbo.tf_GetDCardInfo(1011, 221, '2220000163897', 1, 0)

SELECT * FROM z_LogDiscRec where DCardID = '2220000163897' order by LogDate desc

SELECT SumBonus, * FROM r_DCards  where  DCardID = '2220000163897'

SELECT DBiID, SUM(SumBonus) FROM z_LogDiscRec where DCardID = '2220000163897'
group by DBiID


SELECT top 10  * FROM z_LogDiscRec l
join t_Sale m on m.ChID = l.ChID and l.DocCode = 11035

SELECT COUNT(*) FROM t_Sale m
join z_DocDC d on d.ChID = m.ChID and d.DocCode = 11035
1093534
967202
964894



--group by 

SELECT * FROM r_crs

SELECT CASE WHEN m.CRID in (4,10,101,102,103,104,106,108,109,110,154,160,159,180) THEN '�����' 
			WHEN m.CRID in (5,201,202,203,211) THEN '����' 
			WHEN m.CRID in (300,350) THEN '�������' 
			WHEN m.CRID in (8) THEN '������' 
			ELSE str(m.CRID) END as '�����'  
			FROM t_Sale m
join z_DocDC d on d.ChID = m.ChID 
where d.DocCode = 11035 
and d.DCardID <> '<��� ���������� �����>'
and TRealSum <>0
and m.DocDate > '2016-01-01'
--and OurID  in (8)
group by m.CRID

*/




