select r.prodid , r.prodname, r.um  ,r.country ,rq.barcode
from r_prods r inner join r_prodMQ rq on r.prodid = rq.prodid

where country = '' --���� ������ � �������� ������
and r.um = rq.um --��������  ��� �������� 
and rq.barcode  like '48200%' -- ���� ��� -48200 - �������
and r.pgrid1 = -- ��� ������
order  by r.prodid

update r_prods
	set  r_prods.country = '�������' --����������
from r_prods r inner join r_prodMQ rq on r.prodid = rq.prodid

where country = '' --���� ������ � �������� ������
and r.um = rq.um --��������  ��� �������� 
and rq.barcode  like '48200%' -- ���� ��� -48200 - �������
and r.pgrid1 = -- ��� ������

