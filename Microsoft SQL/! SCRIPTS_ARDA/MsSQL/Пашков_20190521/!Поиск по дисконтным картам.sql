--����� �� ���������� ������
/*

1.	������� ���� ������������ �. 0683202111-10%
2.	������� ����� �. 0503206115-10%
3.	��������� ����� �. 0961618544
4.	�������� ����� ����������� �.0676360654----------------------2220000237208
5.	��������� ������� �.0502991181
6.	������� ����� ���������� �.0676392277-10%--------------------2500000070525
7.	���� ��������� �. 0505016431, 0676310961-10%-----------------2500000060335
8.	����� ������ ������������ �.0505263390,0675661214
9.	������ ���� �. 0675620788-10% -------------------------------2500000069345
10.	������� �������� �������� �. 0675684980-10%------------------2220000065665
11.	�������� ������� �5370036110210395 -10% �.0675630112
2220000075251	2220000283502	������ ������ ����������	10.11.1980	380504701409		�����

2220000010542	������ 10%
	�����
2220000027199	������ 10% ������� ��������� ���������� 
	�����
2220000067355	������ 10% �������� ������� ����������
	�����
2220000070294	������ 20%
	�����

*/
USE ElitR
DECLARE @s nvarchar(100) = '2220000355001' -- ���� �������� ������ 


IF EXISTS (SELECT * FROM r_DCards where DCardID like '%' + @s + '%') SELECT * FROM r_DCards where DCardID like '%' + @s + '%'
IF EXISTS (SELECT * FROM r_DCards where ClientName like '%' + @s + '%') SELECT * FROM r_DCards where ClientName like '%' + @s + '%'
IF EXISTS (SELECT * FROM r_DCards where PhoneMob like '%' + @s + '%') SELECT * FROM r_DCards where PhoneMob like '%' + @s + '%'
IF EXISTS (SELECT * FROM r_DCards where Notes like '%' + @s + '%') SELECT * FROM r_DCards where Notes like '%' + @s + '%'
IF EXISTS (SELECT * FROM r_DCards where Note1 like '%' + @s + '%') SELECT * FROM r_DCards where Note1 like '%' + @s + '%'
IF EXISTS (SELECT * FROM r_DCards where EMail like '%' + @s + '%') SELECT * FROM r_DCards where EMail like '%' + @s + '%'


IF EXISTS (SELECT * FROM z_LogDiscRec where DCardID  like '%' + @s + '%') SELECT * FROM z_LogDiscRec where DCardID  like '%' + @s + '%' ORDER BY LogDate
IF EXISTS (SELECT * FROM z_LogDiscExp where DCardID  like '%' + @s + '%') SELECT * FROM z_LogDiscExp where DCardID  like '%' + @s + '%' ORDER BY LogDate
IF EXISTS (SELECT * FROM z_DocDC where DCardID  like '%' + @s + '%') SELECT * FROM z_DocDC where DCardID  like '%' + @s + '%'

IF EXISTS (SELECT * FROM t_Sale m join z_DocDC dc on dc.ChID = m.ChID where dc.DCardID  like '%' + @s + '%') 
	SELECT * FROM t_Sale m join z_DocDC dc on dc.ChID = m.ChID where dc.DCardID  like '%' + @s + '%'


