/*
--создать таблицу
SELECT  * 
 INTO vintagemarket_online_user_url
FROM OPENQUERY(VintageClub,
'SELECT  * FROM vintagemarket.online_user_url ') vc
*/
/*
--добавить новые записи
INSERT vintagemarket_online_user_url
	SELECT * FROM OPENQUERY(VintageClub,
	'SELECT  * FROM vintagemarket.online_user_url ') vc
	WHERE id NOT IN (SELECT id FROM vintagemarket_online_user_url)
*/

SELECT top 1000 cast([time] as date),* FROM vintagemarket_online_user_url
ORDER BY time desc


SELECT session, COUNT(session) kol, max(date) max_date FROM (
SELECT   cast([time] as date) date, m.session FROM vintagemarket_online_user_url m) gr
group by session
ORDER BY 3 desc

--кол сессий;
SELECT max_date, COUNT (max_date) unik_ID FROM (
SELECT session, COUNT(date) kol, max(date) max_date FROM (
SELECT   cast([time] as date) date, m.session FROM vintagemarket_online_user_url m) gr
group by session) gr2
group by max_date
ORDER BY 1 desc

--кол IP
SELECT max_date, COUNT (max_date) unik_IP FROM (
SELECT IP, COUNT(date) kol, max(date) max_date FROM (
SELECT   cast([time] as date) date, m.IP FROM vintagemarket_online_user_url m) gr
group by IP) gr2
group by max_date
ORDER BY 1 desc


SELECT url, COUNT(url) kol, max(date) max_date FROM (
SELECT   cast([time] as date) date, m.url FROM vintagemarket_online_user_url m) gr
group by url
ORDER BY 2 desc