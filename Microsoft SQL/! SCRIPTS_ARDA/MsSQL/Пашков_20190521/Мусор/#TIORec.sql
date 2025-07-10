IF OBJECT_ID('tempdb.' + CURRENT_USER + '.#TIORec', N'U') IS NOT NULL
DROP TABLE #TIORec
CREATE TABLE #TIORec (OurID INT, DocDate SMALLDATETIME, CompID INT, CodeID2 INT, CodeID3 INT, CompAddID SMALLINT, Address VARCHAR(250), OrderID VARCHAR(250), ExtProdID VARCHAR(250), Qty NUMERIC(21,9))

exec sp_executesql N'INSERT INTO "#TIORec" ("OurID" ,"DocDate" ,"CompID" ,"CodeID2" ,"CodeID3" ,"CompAddID" ,"Address" ,"OrderID" ,"ExtProdID" ,"Qty" )  VALUES (@P1, @P2, @P3, @P4, @P5, @P6, @P7, @P8, @P9, @P10)',N'@P1 int,@P2 smalldatetime,@P3 int,@P4 int,@P5 int,@P6 smallint,@P7 varchar(250),@P8 varchar(250),@P9 varchar(250),@P10 numeric(21,9)',11,'2017-05-19 00:00:00',10797,23,4,3,'магазин "Vintage" м.Дніпропетровськ, б-р Катеринославський, 1','600000109','601756',1.000000000
exec sp_executesql N'INSERT INTO "#TIORec" ("OurID" ,"DocDate" ,"CompID" ,"CodeID2" ,"CodeID3" ,"CompAddID" ,"Address" ,"OrderID" ,"ExtProdID" ,"Qty" )  VALUES (@P1, @P2, @P3, @P4, @P5, @P6, @P7, @P8, @P9, @P10)',N'@P1 int,@P2 smalldatetime,@P3 int,@P4 int,@P5 int,@P6 smallint,@P7 varchar(250),@P8 varchar(250),@P9 varchar(250),@P10 numeric(21,9)',11,'2017-05-19 00:00:00',10797,23,4,3,'магазин "Vintage" м.Дніпропетровськ, б-р Катеринославський, 1','600000109','802536',1.000000000

SELECT * FROM #TIORec

exec dbo.ap_OrderCreate


