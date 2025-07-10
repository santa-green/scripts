IF OBJECT_ID (N'fnDiffStr', N'FN') IS NOT NULL  DROP FUNCTION fnDiffStr;  
GO
Create Function fnDiffStr(@txt1 VarChar(8000),@txt2 VarChar(8000))
returns int
as
begin

	Declare @diff int = 0
	Declare @pos int
	Declare @MaxLen int
	set @pos = 1
	
	IF LEN(@txt1) >= LEN(@txt2) SET @MaxLen = LEN(@txt1) ELSE SET @MaxLen = LEN(@txt2)

	while @pos <= @MaxLen
	Begin
		IF ISNULL(Substring(@txt1,@pos,1),'') != ISNULL(Substring(@txt2,@pos,1),'')
			set @diff = @diff + 1

		set @pos = @pos + 1
	end

	return @diff
end

GO
/*
IF OBJECT_ID (N'fnDiffStr2', N'P') IS NOT NULL  
    DROP PROC fnDiffStr2;  
GO
CREATE PROC fnDiffStr2 @str VarChar(8000),@str2 VarChar(8000),@diff int OUTPUT
as
begin
	--Declare @diff int = 0
	select @str='select '''+replace(@str, ' ', ''' as val union all select ''')+''''
	select @str2='select '''+replace(@str2, ' ', ''' as val union all select ''')+''''
	declare @t1 table(id int identity, val varchar(100))
	declare @t2 table(id int identity, val varchar(100))
	insert into @t1	
	exec (@str)
	insert into @t2	
	exec (@str2)
	delete @t1 where val=''
	delete @t2 where val=''
	--select val from @t1
	--select val from @t2

	IF (SELECT COUNT(*) FROM @t1) >= (SELECT COUNT(*) FROM @t2)
	BEGIN
		set @diff = (SELECT SUM(kol) FROM (select (select top 1 dbo.fnDiffStr(t1.val, t2.val)  from @t2 t2 ORDER BY dbo.fnDiffStr(t1.val, t2.val) ) kol from @t1 t1) gr1)
	END
	ELSE
	BEGIN
		set @diff = (SELECT SUM(kol) FROM (select (select top 1 dbo.fnDiffStr(t2.val, t1.val)  from @t1 t1 ORDER BY dbo.fnDiffStr(t2.val, t1.val) ) kol from @t2 t2) gr1)
	END
	
	select @diff
end
*/
GO
IF OBJECT_ID (N'fnStrToWords') IS NOT NULL DROP FUNCTION fnStrToWords;  
GO
CREATE FUNCTION [dbo].fnStrToWords(@Filter varchar(MAX))
RETURNS @out TABLE (AValue varchar(MAX)) AS
BEGIN
  DECLARE @i int, @ABegVal int, @AEndVal int, @APos int, @ADashInd int, @ANumber varchar(MAX)
  --SELECT @Filter = REPLACE(REPLACE(@Filter, ',', ';'), ' ', '') + ';'
  SELECT @Filter = RTRIM(LTRIM(@Filter)) + ' '
  SET @i = 1
  SET @APos = 0
  WHILE @i <= LEN(@Filter)+1
    BEGIN
      IF SUBSTRING(@Filter, @i, 1)= ' '
        BEGIN
          SELECT @ANumber = SUBSTRING(@Filter, @APos, @i - @APos)
            INSERT @out VALUES(@ANumber)
          SET @APos = @i + 1
        END
      SET @i = @i + 1   
    END
  delete @out where  AValue = '' 
  RETURN 
END

GO
IF OBJECT_ID (N'fnDiffStr4', N'FN') IS NOT NULL DROP FUNCTION fnDiffStr4;  
GO
Create Function fnDiffStr4(@str VarChar(8000),@str2 VarChar(8000))
returns int
as
begin
	Declare @diff int = 0
	--select @str='select '''+replace(@str, ' ', ''' as val union all select ''')+''''
	--select @str2='select '''+replace(@str2, ' ', ''' as val union all select ''')+''''
	declare @t1 table(val varchar(max))
	declare @t2 table(val varchar(max))
	insert into @t1	SELECT * FROM fnStrToWords(@str)
	insert into @t2	SELECT * FROM fnStrToWords(@str2)

	IF (SELECT COUNT(*) FROM @t1) >= (SELECT COUNT(*) FROM @t2)
	BEGIN
		set @diff = (SELECT SUM(kol) FROM (select (select top 1 dbo.fnDiffStr(t1.val, t2.val)  from @t2 t2 ORDER BY dbo.fnDiffStr(t1.val, t2.val) ) kol from @t1 t1) gr1)
	END
	ELSE
	BEGIN
		set @diff = (SELECT SUM(kol) FROM (select (select top 1 dbo.fnDiffStr(t2.val, t1.val)  from @t1 t1 ORDER BY dbo.fnDiffStr(t2.val, t1.val) ) kol from @t2 t2) gr1)
	END
	
	RETURN @diff
end

/*

SELECT top 1 dbo.fnDiffStr4('Ликер Шариз 0,7*6',Notes),ProdID,Notes FROM ElitDistr.dbo.r_Prods where Notes is not null ORDER BY 1





SELECT  LEN(RTRIM(LTRIM('Ликер Шариз')) + '  ')
SELECT  LEN('Ликер Шариз' + ' 1')
SELECT * FROM [dbo].fnStrToWords('Ликер     рп   Шариз ')

--DECLARE @diff2 int
--exec dbo.fnDiffStr2 'Ликер Шариз 0,7*6&Ч','Ликер Шариc 0,7*6',@diff2 OUTPUT
--select @diff2

--GO
--IF OBJECT_ID (N'fnDiffStr3', N'FN') IS NOT NULL DROP FUNCTION fnDiffStr3;  
--GO
--Create Function fnDiffStr3(@txt1 VarChar(8000),@txt2 VarChar(8000))
--returns int
--as
--begin
--	DECLARE @diff2 int
--	exec dbo.fnDiffStr2 @txt1,@txt2,@diff2 OUTPUT
--	return @diff2
--end





select t1.val, t2.val, dbo.fnDiffStr(t1.val, t2.val) from @t1 t1,@t2 t2 where t1.val!='' or t2.val!='' ORDER BY 3

select dbo.fnDiffStr('Шариз', t2.val) from @t2 t2  ORDER BY dbo.fnDiffStr('Шариз', t2.val) 


SELECT dbo.fnDiffStr('0,7*6','0,7*6&Ч')
SELECT dbo.fnDiffStr('0,7*6&Ч','0,7*6')


SELECT dbo.fnDiffStr4('Ликер Шариз 0,7*6','Ликер Шhариc 0,7*6&Ч')
SELECT dbo.fnDiffStr('Ликер Шhариc 0,7*6&Ч','Ликер Шариз 0,7*6')
SELECT dbo.fnDiffStr('Ликер','ликер')

SELECT top 1 dbo.fnDiffStr('Ликер Шариз 0,7*6',Notes),ProdID,Notes FROM ElitDistr.dbo.r_Prods where Notes is not null ORDER BY 1




SELECT *, (SELECT top 1 Notes FROM ElitDistr.dbo.r_Prods r  where r.ProdID = s2.ProdID_find) Notes_baze FROM (
SELECT --top 1 
*, (SELECT top 1 ProdID FROM ElitDistr.dbo.r_Prods where len(Notes) > 5 ORDER BY dbo.fnDiffStr4(s1.NameMedoc,Notes)) ProdID_find
FROM (
SELECT --top 1 
ProdID, Notes, TAB1_A13 NameMedoc 
FROM ElitDistr.dbo.r_Prods r
right join (SELECT distinct TAB1_A13 FROM ElitDistr.dbo.at_t_Medoc where TAB1_A13 is not null) med on med.TAB1_A13 = r.Notes
where Notes is null or  TAB1_A13 is null
) s1
) s2


SELECT 
top 20 
(dbo.fnDiffStr4('Вино Domaine de la Perriere. Совіньон Ля Пти Пер`єр 2011, біле 0,75*12',Notes)) diff,
ProdID,Notes  
FROM ElitDistr.dbo.r_Prods where len(Notes) > 5 ORDER BY 1
*/


--подбор товаров с помощью времменых таблиц
IF OBJECT_ID (N'tempdb..#FindMedocName', N'U') IS NOT NULL DROP TABLE #FindMedocName
CREATE TABLE #FindMedocName (ID INT, NameMedoc NVARCHAR(250),  Diff INT, ProdID INT, Notes_ProdName NVARCHAR(250), InUse INT)

IF OBJECT_ID (N'tempdb..#FindMedocNameD', N'U') IS NOT NULL DROP TABLE #FindMedocNameD
CREATE TABLE #FindMedocNameD (ChID INT, ID INT, NameMedoc NVARCHAR(250),  Diff INT, ProdID INT, Notes_ProdName NVARCHAR(250), InUse INT)


IF OBJECT_ID (N'tempdb..#tmp_Prods', N'U') IS NOT NULL DROP TABLE #tmp_Prods
SELECT ProdID, Notes into #tmp_Prods FROM ElitDistr.dbo.r_Prods where len(Notes) > 5 and len(ProdID) <> 6 and PCatID between 1 and 100
--SELECT ProdID, Notes FROM ElitDistr.dbo.r_Prods where len(Notes) > 5 and len(cast(ProdID as varchar)) <> 6 and PCatID between 1 and 100
--SELECT * FROM #tmp_Prods

DELETE #FindMedocName

INSERT #FindMedocName (ID, NameMedoc, Diff, ProdID, Notes_ProdName, InUse)
	SELECT ROW_NUMBER()OVER(ORDER BY NameMedoc) ID, NameMedoc, NULL Diff, NULL ProdID, NULL Notes_ProdName, 0 InUse  FROM (
		SELECT TAB1_A13 NameMedoc FROM ElitDistr.dbo.r_Prods r
		RIGHT JOIN (SELECT DISTINCT TAB1_A13 FROM ElitDistr.dbo.at_t_Medoc WHERE TAB1_A13 is not null) med ON med.TAB1_A13 = r.Notes
		where Notes IS NULL OR  TAB1_A13 IS NULL
		UNION 
		SELECT TAB1_A3 NameMedoc FROM ElitDistr.dbo.r_Prods r
		RIGHT JOIN (SELECT DISTINCT TAB1_A3 FROM ElitDistr.dbo.at_t_Medoc_Ret WHERE TAB1_A3 is not null) med ON med.TAB1_A3 = r.Notes
		where Notes IS NULL OR  TAB1_A3 IS NULL
	) s1
	
SELECT * FROM #FindMedocName

UPDATE #FindMedocName SET InUse = 0
UPDATE #FindMedocName SET InUse = 1 WHERE ID in (18,20,21,22,23,24,25,26,42,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,98,99,142,143,144,145,150,151,187,277,278,279,280,281,283,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,354)

SELECT * FROM #FindMedocName where InUse = 1


DELETE #FindMedocNameD

DECLARE @ID INT, @NameMedoc NVARCHAR(250), @Msg NVARCHAR(250)
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT ID, NameMedoc FROM #FindMedocName WHERE InUse = 1

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ID, @NameMedoc
WHILE @@FETCH_STATUS = 0
BEGIN
	IF 1=0 --1=1 подобрать похожие товары else обновить найденые позиции
	BEGIN--подобрать похожие товары
		SET @Msg = CONVERT( varchar, GETDATE(), 121)
		RAISERROR ('текущее время %s : ID = %u , NameMedoc = %s', 10,1,@Msg,@ID,@NameMedoc) WITH NOWAIT
		
		INSERT #FindMedocNameD
			SELECT top 10 NULL ChID, @ID ID, @NameMedoc NameMedoc, dbo.fnDiffStr4(@NameMedoc,Notes) Diff, ProdID, Notes Notes_ProdName, 0 InUse 
			FROM #tmp_Prods where len(Notes) > 5 and len(cast(ProdID as varchar)) <> 6 ORDER BY dbo.fnDiffStr4(@NameMedoc,Notes)
			
		SELECT * FROM #FindMedocNameD
	END
	ELSE
	BEGIN--обновить найденые позиции
		update #FindMedocNameD 
		SET InUse = 1 
		where chid = (SELECT top 1 ChID FROM #FindMedocNameD  where ID = @ID ORDER BY Diff,ProdID)	  
	END
	
	FETCH NEXT FROM CURSOR1 INTO @ID, @NameMedoc
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

--пронумеровать поле ChID
update s1
set ChID = s1.n
from (SELECT ROW_NUMBER()OVER(ORDER BY ID,Diff) n, * FROM #FindMedocNameD) s1

SELECT * FROM #FindMedocNameD

UPDATE #FindMedocNameD SET InUse = 0
UPDATE #FindMedocNameD SET InUse = 1 WHERE ChID in (8,31,41,51,61,71,81,91,101,111,122,131,141,151,161,171,181,191,201,211,226,234,244,254,261,511,521,531,541,561,571,584,591,601,612,621,631,641,651,661,671,681,691,701,711,731,741,751,771,782,792,801,812,822,831,271,281,291,301,311,321,331,341,351,361,371,381,392,401,411,422,435,441,451,461,471,481,492,501,841,851,861,871,881,891,901,911,921)

SELECT * FROM at_FindMedocNameD  where InUse = 1

/*

SELECT * FROM at_FindMedocNameD where NameMedoc = 'Вино Lozano. Кабальерос де ла Роса Тінто Семидульче , червоне 0,75*12' and InUse = 1


SELECT * FROM #FindMedocName

delete at_FindMedocNameD

insert at_FindMedocNameD
SELECT *  FROM #FindMedocNameD

SELECT ChID, diff,NameMedoc n1 FROM #FindMedocNameD where InUse = 1
union
SELECT ChID, diff, Notes_ProdName n1 FROM #FindMedocNameD where InUse = 1
ORDER BY ChID


SELECT ChID, diff,NameMedoc n1, 1 inMedoc FROM at_FindMedocNameD where InUse = 1
union
SELECT ChID, diff, Notes_ProdName n1, 0 inMedoc FROM at_FindMedocNameD where InUse = 1
ORDER BY ChID, inMedoc


SELECT * into #t1 FROM #FindMedocNameD

SELECT *, (SELECT top 1 Notes FROM ElitDistr.dbo.r_Prods r  where r.ProdID = s2.ProdID_find) Notes_baze FROM (
SELECT --top 1 
*, (SELECT top 1 ProdID FROM ElitDistr.dbo.r_Prods where len(Notes) > 5 and PCatID between 1 and 100 
and ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600267,600299,600712,600712,600721,600721,600731,600732,600742,600743,600744,600745,600757,600757,600758,600758,600758,600760,600760,600773,600773,600816,600816,600816,600832,600839,600839,600840,600840,600882,600883,600883,600884,600884,600884,600884,600884,600885,600885,600887,600891,600891,600892,600895,600895,600987,601070,601070,601078,601085,601085,601085,601085,601086,601095,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602507,602563,602563,602563,602564,602564,602669,602669,602755,602755,603053,603053,603053,603928,603936,603975,604603,604851,604979,604980,604980,800084,800084,800164,800164,800164,800165,800165,800594,800594,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,801952,802174,802185,802375,802376,802394,802399,802402,802408,802412,802412,802424,802424,802471,802484,802485,802486,802489,802489,802490,802490,802511,802650,802651,802656,802657,802705,802705,802751,802751,802752,802982,803013,803013,803016)) 
 ORDER BY dbo.fnDiffStr4(s1.NameMedoc,Notes)) ProdID_find
FROM #FindMedocName s1
) s2

--список товаров в элитке
SELECT * FROM ElitDistr.dbo.r_Prods where len(Notes) > 5 and PCatID between 1 and 100 
and ProdID in (SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600267,600299,600712,600712,600721,600721,600731,600732,600742,600743,600744,600745,600757,600757,600758,600758,600758,600760,600760,600773,600773,600816,600816,600816,600832,600839,600839,600840,600840,600882,600883,600883,600884,600884,600884,600884,600884,600885,600885,600887,600891,600891,600892,600895,600895,600987,601070,601070,601078,601085,601085,601085,601085,601086,601095,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602507,602563,602563,602563,602564,602564,602669,602669,602755,602755,603053,603053,603053,603928,603936,603975,604603,604851,604979,604980,604980,800084,800084,800164,800164,800164,800165,800165,800594,800594,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,801952,802174,802185,802375,802376,802394,802399,802402,802408,802412,802412,802424,802424,802471,802484,802485,802486,802489,802489,802490,802490,802511,802650,802651,802656,802657,802705,802705,802751,802751,802752,802982,803013,803013,803016)) 

--список товаров в элитке которые соответствуют наборам в элитР
SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600267,600299,600712,600712,600721,600721,600731,600732,600742,600743,600744,600745,600757,600757,600758,600758,600758,600760,600760,600773,600773,600816,600816,600816,600832,600839,600839,600840,600840,600882,600883,600883,600884,600884,600884,600884,600884,600885,600885,600887,600891,600891,600892,600895,600895,600987,601070,601070,601078,601085,601085,601085,601085,601086,601095,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602507,602563,602563,602563,602564,602564,602669,602669,602755,602755,603053,603053,603053,603928,603936,603975,604603,604851,604979,604980,604980,800084,800084,800164,800164,800164,800165,800165,800594,800594,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,801952,802174,802185,802375,802376,802394,802399,802402,802408,802412,802412,802424,802424,802471,802484,802485,802486,802489,802489,802490,802490,802511,802650,802651,802656,802657,802705,802705,802751,802751,802752,802982,803013,803013,803016)

--список товаров в элитке которые соответствуют наборам в элитР
SELECT distinct ec.ProdID FROM Elit.dbo.r_ProdEC ec where ISNUMERIC(ExtProdID) = 1 and cast(ExtProdID as bigint) in (600072,600132,600133,600134,600135,600136,600159,600160,600168,600267,600267,600299,600712,600712,600721,600721,600731,600732,600742,600743,600744,600745,600757,600757,600758,600758,600758,600760,600760,600773,600773,600816,600816,600816,600832,600839,600839,600840,600840,600882,600883,600883,600884,600884,600884,600884,600884,600885,600885,600887,600891,600891,600892,600895,600895,600987,601070,601070,601078,601085,601085,601085,601085,601086,601095,601095,601105,601106,601111,601115,601116,601626,601773,601784,602042,602290,602505,602507,602563,602563,602563,602564,602564,602669,602669,602755,602755,603053,603053,603053,603928,603936,603975,604603,604851,604979,604980,604980,800084,800084,800164,800164,800164,800165,800165,800594,800594,800594,800621,800779,801098,801099,801301,801451,801562,801563,801564,801565,801642,801720,801721,801935,801949,801952,802174,802185,802375,802376,802394,802399,802402,802408,802412,802412,802424,802424,802471,802484,802485,802486,802489,802489,802490,802490,802511,802650,802651,802656,802657,802705,802705,802751,802751,802752,802982,803013,803013,803016)
and cast(ProdID as bigint) in (23774,631050,631171,631020,4293,4746,1946,21638,22327,33622,26095,30638,634031,31306,32479,33025,27551,32566,32427,29143,26840,31350,32518,32518,32518,33929,34112,631214,631163,31091,31967,632004,30845,28354,27753,32236,32441,32440,28980,33401,631128,631129,31390,32721,28264,32345,634052,33298,33648,29206,27412,29201,32617,21406,32041,32043,32041,32041,631934,631935,631931,631212,32615,22070,22071,4695,33284,9175,81601,29874,33232,33233,33234,2713,2400,3141,4887,22070,32298,33342,33136,33341,32318,32225,31981,23498,33850,32013,32006,32007,631046,32415,21563,29875)


SELECT * FROM ElitDistr.dbo.r_Prods where Notes like '%Блюдо%'
SELECT * FROM ElitDistr.dbo.r_Prods where ProdID = 1132


		SELECT top 20 NULL ChID, 18 ID, 'Santa Carolina. Премио Семисвит 2011 красное, полусладкое 0,75*12' NameMedoc, dbo.fnDiffStr4('Santa Carolina. Премио Семисвит 2011 красное, полусладкое 0,75*12',Notes) Diff, ProdID, Notes Notes_ProdName, 0 InUse 
		FROM ElitDistr.dbo.r_Prods where len(Notes) > 5 and len(ProdID) <> 6 ORDER BY dbo.fnDiffStr4('Santa Carolina. Премио Семисвит 2011 красное, полусладкое 0,75*12',Notes)

*/