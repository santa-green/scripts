USE Alef_Elit_TEST
go
SELECT * FROM 
Product, Laptop;

SELECT P.*, L.*  FROM 
Product P JOIN Laptop L ON P.model= L.model;

SELECT * FROM Product --ORDER BY maker
SELECT * FROM Laptop
SELECT P.*, L.*  FROM 
Product P 
CROSS APPLY
(SELECT * FROM Laptop L WHERE P.model= L.model) L;

SELECT * FROM Laptop
SELECT m.model, (SELECT MAX(price) from laptop i WHERE i.model = m.model) 'max price for this model' FROM laptop m
group by m.model

select l.model, MAX(price) 'max price' from laptop l
join product p ON l.model = p.model
group by l.model

SELECT *, (SELECT MAX(price) FROM Laptop L2
JOIN  Product P1 ON L2.model=P1.model 
WHERE p1.maker = (SELECT p2.maker FROM Product P2 WHERE P2.model= L1.model)) max_price 
FROM laptop L1;

SELECT *
    FROM laptop L1
    CROSS APPLY
    (SELECT MAX(price) max_price FROM Laptop L2
JOIN  Product P1 ON L2.model=P1.model 
WHERE maker = (SELECT maker FROM Product P2 WHERE P2.model= L1.model)) X;

SELECT *, (SELECT MAX(price), MIN(price) FROM Laptop L2
JOIN  Product P1 ON L2.model=P1.model 
WHERE p1.maker = (SELECT p2.maker FROM Product P2 WHERE P2.model= L1.model)) max_price
FROM laptop L1;

SELECT *
    FROM laptop L1
    CROSS APPLY
    (SELECT MAX(price) max_price, MIN(price) min_price, AVG(price) avg_price FROM Laptop L2
JOIN  Product P1 ON L2.model=P1.model 
WHERE maker = (SELECT maker FROM Product P2 WHERE P2.model= L1.model)) X;

    SELECT * FROM laptop L1
    outer APPLY
    (SELECT TOP 1 * FROM Laptop L2 
    WHERE L1.model < L2.model OR (L1.model = L2.model AND L1.code < L2.code) 
    ORDER BY model, code) X
    ORDER BY L1.model;

SELECT * FROM Product ORDER BY maker

SELECT pr1.type, pr1.model, count(*) 'num' FROM Product pr1 
join product pr2 ON pr1.model >= pr2.model and pr1.type = pr2.type
group by pr1.model, pr1.type
having count(*) <= 3
ORDER BY type DESC, model

SELECT * FROM Product pr1 
join product pr2 ON pr1.model = pr2.model

;WITH rank_cte as (
SELECT RANK() over (PARTITION BY type ORDER BY model) 'rank_num', model, type FROM Product pr1 
)
SELECT * FROM rank_cte WHERE rank_num <= 3 

SELECT * FROM (SELECT DISTINCT type FROM product) Pr1 
cross apply (select top 3 * from product pr2 WHERE pr2.type = pr1.type ORDER BY pr2.model) x

--SELECT r1.chid, r1.OurID, r2.OurID, r1.OurName, r2.OurName, r1.[Address], r1.City, r2.City FROM r_Ours r1, r_Ours r2
--WHERE r1.City = r2.City and r1.OurID <> r2.OurID

--SELECT * FROM r_Ours WHERE OurID in (16, 17)

select p1.*, p2.* from product p1, product p2 WHERE p1.type != p2.type --ORDER BY pr2.model

SELECT * FROM laptop

SELECT name, value 
FROM (
VALUES('speed', 1)
,('ram', 1)
,('hd', 1)
,('screen', 1)
) Spec(name, value);

SELECT code, name, value 
FROM Laptop
CROSS APPLY (
VALUES('speed', 1)
,('ram', 1)
,('hd', 1)
,('screen', 1)
) Spec(name, value)
WHERE code < 4 -- для уменьшения размера выборки
;

    SELECT code, name, value FROM Laptop
    CROSS APPLY
    (VALUES('speed', speed)
    ,('ram', ram)
    ,('hd', hd)
    ,('screen', screen)
    ) spec(name, value)
    WHERE code < 4 -- для уменьшения размера выборки
    ORDER BY code, name, value;

SELECT * FROM sys.tables ORDER BY create_date DESC

use Elit_test
go

SELECT ru.ChID, ru.UserID, ru.UserName, ru.EmpID, afg.* FROM r_Users ru
--join af_GetUserInfo(DEFAULT) afg ON afg.UserName = ru.UserName
cross apply af_GetUserInfo(ru.UserName) afg
WHERE ru.UserID in (30, 50, 61)

SELECT * FROM af_GetUserInfo('cev')



