--Поиск по дисконтным картам
/*

1.	Носачев Егор Владимирович т. 0683202111-10%
2.	Еремина Алена т. 0503206115-10%
3.	Журавлева Дарья т. 0961618544
4.	Скороход Игорь Анатольевич т.0676360654----------------------2220000237208
5.	Бендюгина Марьяна т.0502991181
6.	Давидов Денис Михайлович т.0676392277-10%--------------------2500000070525
7.	Свир Станислав т. 0505016431, 0676310961-10%-----------------2500000060335
8.	Буряк Андрей Вячеславович т.0505263390,0675661214
9.	Леонов Юрий т. 0675620788-10% -------------------------------2500000069345
10.	Семенко Настасья Олеговна т. 0675684980-10%------------------2220000065665
11.	Жарикова Татьяна №5370036110210395 -10% т.0675630112
2220000075251	2220000283502	Чуенко Максим Евгеньевич	10.11.1980	380504701409		ДНЕПР

2220000010542	Скидка 10%
	Итого
2220000027199	Скидка 10% Данович Александр Викторович 
	Итого
2220000067355	Скидка 10% РОГОЖИНА ТАТЬЯНА ВАСИЛЬЕВНА
	Итого
2220000070294	Скидка 20%
	Итого

*/
USE ElitR
DECLARE @s nvarchar(100) = '2220000355001' -- ввод критерия поиска 


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


