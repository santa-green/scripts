--���������� ����

SELECT dc.DCardID, MAX(dc.FactCity) �����, MAX(dc.ClientName) ���,cast(MAX(dc.Discount) as Int) ������, MAX(dc.DCTypeCode) ���,
MAX(dc.PhoneMob) �������, MAX(dc.EMail) EMail, SUM(m.TRealSum) �����_�������, 
MAX(dc.SumBonus),count(m.TRealSum) ����������,
SUM(m.TRealSum)/count(m.TRealSum) �������_���, MAX(m.DocDate) ���������_������� 
FROM r_DCards dc
JOIN z_DocDC d on d.DCardID = dc.DCardID and d.DocCode = 11035
JOIN t_Sale m on m.ChID = d.ChID
where dc.InUse = 1 and dc.DCTypeCode in (1,2) and m.TRealSum > 0 
group by dc.DCardID
--having  SUM(m.TRealSum) <> MAX(dc.SumBonus) and MAX(dc.DCTypeCode) = 2
ORDER BY 1

