--����� �� ���������� ������

DECLARE @s nvarchar(100) = '2220000236065' -- ���� �������� ������ 

SELECT * FROM r_DCards where DCardID like '%' + @s + '%'
SELECT * FROM r_DCards where Notes like '%' + @s + '%'
SELECT * FROM r_DCards where Note1 like '%' + @s + '%'
SELECT * FROM r_DCards where ClientName like '%' + @s + '%'
SELECT * FROM r_DCards where PhoneMob like '%' + @s + '%'
SELECT * FROM r_DCards where EMail like '%' + @s + '%'

/*

*/

SELECT * FROM z_LogDiscRec where DCardID  like '%' + @s + '%'
SELECT * FROM z_LogDiscExp where DCardID  like '%' + @s + '%'
SELECT * FROM z_DocDC where DCardID  like '%' + @s + '%'