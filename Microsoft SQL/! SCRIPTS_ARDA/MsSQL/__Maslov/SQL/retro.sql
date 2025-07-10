DECLARE @BeginDate DATE = '20180901' --Дата начала выборки
	   ,@OurID VARCHAR(50) = '1-9,11'
	   ,@CodeID1 VARCHAR(50) = '52-79'
	   
IF OBJECT_ID (N'tempdb..#Comps', N'U') IS NOT NULL DROP TABLE #Comps
CREATE TABLE #Comps (CompID INT, Para1 INT, Para2 INT, Para3 INT)
/*
Para1 - 1 = Весь ассортимент; 2 = Весь ассортимент кроме Кока-Кола и Кампари; 3 = СТ 49; 4 = Кока-Кола; 5 = Кофе.
Para2 - 1 = ВЗ 2; 2 = Товаром; 3 = нал-и через СБ;
Para3 - 1 = от оплат; 2 = от отгрузок.
*/
INSERT INTO #Comps
	SELECT 1097, 1, 3, 1  UNION ALL
	SELECT 1230, 1, 3, 1  UNION ALL
	SELECT 1592, 1, 3, 1  UNION ALL
	SELECT 1611, 1, 3, 1  UNION ALL
	SELECT 2157, 2, 1, 1  UNION ALL
	SELECT 2568, 2, 3, 1  UNION ALL
	SELECT 2642, 2, 1, 1  UNION ALL
	SELECT 3040, 2, 2, 1  UNION ALL
	SELECT 3290, 2, 2, 1  UNION ALL
	SELECT 3458, 2, 2, 1  UNION ALL
	SELECT 4715, 1, 2, 1  UNION ALL
	SELECT 6099, 2, 2, 1  UNION ALL
	SELECT 6579, 2, 2, 1  UNION ALL
	SELECT 6615, 2, 3, 1  UNION ALL
	SELECT 9016, 2, 1, 1  UNION ALL
	SELECT 9051, 1, 1, 1  UNION ALL
	SELECT 9267, 2, 1, 1  UNION ALL
	SELECT 9388, 1, 1, 1  UNION ALL
	SELECT 9938, 2, 1, 1  UNION ALL
	SELECT 14009, 1, 1, 1 UNION ALL
	SELECT 14080, 1, 1, 1 UNION ALL
	SELECT 14084, 1, 1, 1 UNION ALL
	SELECT 14169, 1, 1, 1 UNION ALL
	SELECT 14195, 1, 1, 1 UNION ALL
	SELECT 14254, 1, 1, 1 UNION ALL
	SELECT 14480, 2, 1, 1 UNION ALL
	SELECT 14687, 2, 1, 1 UNION ALL
	SELECT 14910, 1, 1, 1 UNION ALL
	SELECT 17084, 2, 1, 1 UNION ALL
	SELECT 17098, 2, 1, 1 UNION ALL
	SELECT 17892, 2, 1, 1 UNION ALL
	SELECT 19296, 2, 1, 1 UNION ALL
	SELECT 19539, 1, 1, 1 UNION ALL
	SELECT 19631, 2, 1, 1 UNION ALL
	SELECT 19740, 2, 1, 1 UNION ALL
	SELECT 19784, 1, 1, 1 UNION ALL
	SELECT 19879, 1, 1, 1 UNION ALL
	SELECT 24110, 2, 1, 1 UNION ALL
	SELECT 29054, 1, 1, 1 UNION ALL
	SELECT 29272, 2, 12, 2 UNION ALL
	SELECT 29308, 2, 12, 2 UNION ALL
	SELECT 29314, 1, 12, 1 UNION ALL
	SELECT 29315, 1, 12, 1 UNION ALL
	SELECT 29325, 2, 12, 2 UNION ALL
	SELECT 29330, 2, 12, 2 UNION ALL
	SELECT 29331, 2, 12, 2 UNION ALL
	SELECT 40358, 2, 2, 1 UNION ALL
	SELECT 43365, 1, 2, 1 UNION ALL
	SELECT 44368, 1, 1, 1 UNION ALL
	SELECT 44507, 1, 1, 1 UNION ALL
	SELECT 44695, 1, 1, 1 UNION ALL
	SELECT 44750, 1, 1, 1 UNION ALL
	SELECT 44871, 1, 1, 1 UNION ALL
	SELECT 48908, 1, 1, 1 UNION ALL
	SELECT 49123, 2, 2, 1 UNION ALL
	SELECT 49228, 2, 2, 1 UNION ALL
	SELECT 49483, 2, 2, 1 UNION ALL
	SELECT 49532, 1, 2, 1 UNION ALL
	SELECT 49589, 2, 2, 1 UNION ALL
	SELECT 49590, 2, 2, 1 UNION ALL
	SELECT 49652, 2, 2, 1 UNION ALL
	SELECT 49695, 2, 2, 1 UNION ALL
	SELECT 49768, 2, 2, 1 UNION ALL
	SELECT 49923, 2, 2, 1 UNION ALL
	SELECT 49971, 1, 2, 1 UNION ALL
	SELECT 54000, 1, 2, 1 UNION ALL
	SELECT 54432, 2, 2, 1 UNION ALL
	SELECT 54571, 1, 2, 1 UNION ALL
	SELECT 56270, 2, 1, 1 UNION ALL
	SELECT 56320, 2, 1, 1 UNION ALL
	SELECT 56382, 2, 1, 1 UNION ALL
	SELECT 58032, 1, 1, 1 UNION ALL
	SELECT 58147, 2, 12, 2 UNION ALL
	SELECT 58148, 2, 12, 2 UNION ALL
	SELECT 58149, 2, 12, 2 UNION ALL
	SELECT 58335, 2, 12, 2 UNION ALL
	SELECT 58423, 1, 12, 1 UNION ALL
	SELECT 58626, 1, 12, 1 UNION ALL
	SELECT 58758, 1, 1, 1 UNION ALL
	SELECT 58787, 2, 1, 1 UNION ALL
	SELECT 58813, 2, 1, 1 UNION ALL
	SELECT 58821, 1, 1, 1 UNION ALL
	SELECT 58833, 1, 2, 1 UNION ALL
	SELECT 58867, 1, 1, 1 UNION ALL
	SELECT 58868, 2, 1, 1 UNION ALL
	SELECT 59048, 1, 1, 1 UNION ALL
	SELECT 59429, 2, 1, 1 UNION ALL
	SELECT 59540, 1, 1, 1 UNION ALL
	SELECT 59555, 2, 1, 1 UNION ALL
	SELECT 59671, 1, 1, 1 UNION ALL
	SELECT 59718, 2, 1, 1 UNION ALL
	SELECT 59760, 2, 1, 1 UNION ALL
	SELECT 59794, 2, 1, 1 UNION ALL
	SELECT 59840, 2, 1, 1 UNION ALL
	SELECT 59852, 2, 1, 1 UNION ALL
	SELECT 59871, 1, 1, 1 UNION ALL
	SELECT 59901, 2, 1, 1 UNION ALL
	SELECT 59941, 1, 1, 1 UNION ALL
	SELECT 59949, 2, 1, 1 UNION ALL
	SELECT 59954, 1, 1, 1 UNION ALL
	SELECT 59972, 2, 1, 1 UNION ALL
	SELECT 61073, 2, 1, 1 UNION ALL
	SELECT 61480, 2, 1, 1 UNION ALL
	SELECT 61497, 1, 3, 1 UNION ALL
	SELECT 61694, 2, 1, 1 UNION ALL
	SELECT 61695, 2, 1, 1 UNION ALL
	SELECT 61696, 2, 1, 1 UNION ALL
	SELECT 61698, 2, 1, 1 UNION ALL
	SELECT 61699, 2, 1, 1 UNION ALL
	SELECT 61700, 2, 1, 1 UNION ALL
	SELECT 61701, 2, 1, 1 UNION ALL
	SELECT 61702, 2, 1, 1 UNION ALL
	SELECT 61836, 2, 1, 1 UNION ALL
	SELECT 61837, 2, 1, 1 UNION ALL
	SELECT 61839, 2, 1, 1 UNION ALL
	SELECT 61905, 1, 3, 1 UNION ALL
	SELECT 61951, 1, 3, 1 UNION ALL
	SELECT 62827, 2, 2, 1 UNION ALL
	SELECT 64044, 2, 1, 1 UNION ALL
	SELECT 64052, 2, 1, 1 UNION ALL
	SELECT 64143, 2, 1, 1 UNION ALL
	SELECT 64157, 2, 1, 1 UNION ALL
	SELECT 64209, 2, 1, 1 UNION ALL
	SELECT 64219, 2, 1, 1 UNION ALL
	SELECT 64233, 2, 1, 1 UNION ALL
	SELECT 64236, 1, 3, 1 UNION ALL
	SELECT 65177, 1, 2, 1 UNION ALL
	SELECT 65240, 1, 2, 1 UNION ALL
	SELECT 65297, 3, 2, 2 UNION ALL
	SELECT 65356, 1, 2, 1 UNION ALL
	SELECT 65856, 1, 2, 1 UNION ALL
	SELECT 65900, 2, 2, 1 UNION ALL
	SELECT 65952, 3, 2, 2 UNION ALL
	SELECT 65991, 3, 2, 2 UNION ALL
	SELECT 66019, 1, 1, 1 UNION ALL
	SELECT 66036, 1, 1, 1 UNION ALL
	SELECT 66052, 1, 1, 1 UNION ALL
	SELECT 66079, 1, 1, 1 UNION ALL
	SELECT 66106, 1, 1, 1 UNION ALL
	SELECT 66155, 2, 3, 1 UNION ALL
	SELECT 66208, 1, 1, 1 UNION ALL
	SELECT 66247, 1, 1, 1 UNION ALL
	SELECT 66284, 1, 1, 1 UNION ALL
	SELECT 66290, 1, 1, 1 UNION ALL
	SELECT 66409, 1, 1, 1 UNION ALL
	SELECT 66477, 1, 1, 1 UNION ALL
	SELECT 66498, 1, 1, 1 UNION ALL
	SELECT 66533, 1, 1, 1 UNION ALL
	SELECT 66540, 1, 1, 1 UNION ALL
	SELECT 66555, 1, 1, 1 UNION ALL
	SELECT 66568, 1, 1, 1 UNION ALL
	SELECT 66585, 1, 1, 1 UNION ALL
	SELECT 66596, 1, 1, 1 UNION ALL
	SELECT 66605, 2, 3, 2 UNION ALL
	SELECT 66632, 1, 1, 1 UNION ALL
	SELECT 69029, 1, 1, 1 UNION ALL
	SELECT 69030, 1, 1, 1 UNION ALL
	SELECT 69031, 1, 1, 1 UNION ALL
	SELECT 69036, 2, 1, 1 UNION ALL
	SELECT 70198, 2, 2, 1 UNION ALL
	SELECT 70508, 2, 2, 1 UNION ALL
	SELECT 70575, 2, 2, 1 UNION ALL
	SELECT 70576, 2, 2, 1 UNION ALL
	SELECT 70704, 2, 2, 1 UNION ALL
	SELECT 71069, 1, 1, 1 UNION ALL
	SELECT 71080, 1, 2, 1 UNION ALL
	SELECT 71096, 3, 2, 2 UNION ALL
	SELECT 71114, 1, 2, 1 UNION ALL
	SELECT 71175, 1, 2, 1 UNION ALL
	SELECT 71249, 4, 2, 2 UNION ALL
	SELECT 71253, 1, 2, 1 UNION ALL
	SELECT 71260, 1, 2, 1 UNION ALL
	SELECT 71265, 1, 2, 1 UNION ALL
	SELECT 71275, 2, 2, 1 UNION ALL
	SELECT 71286, 1, 1, 1 UNION ALL
	SELECT 71311, 1, 2, 1 UNION ALL
	SELECT 71333, 5, 3, 1 UNION ALL
	SELECT 73164, 1, 3, 1 UNION ALL
	SELECT 73191, 1, 3, 1 UNION ALL
	SELECT 73192, 2, 3, 1 UNION ALL
	SELECT 74008, 1, 1, 1 UNION ALL
	SELECT 74017, 1, 1, 1 UNION ALL
	SELECT 74067, 1, 1, 1 UNION ALL
	SELECT 74088, 1, 1, 1 UNION ALL
	SELECT 74105, 1, 1, 1 UNION ALL
	SELECT 74113, 1, 1, 1 UNION ALL
	SELECT 74141, 1, 1, 1 UNION ALL
	SELECT 74163, 1, 1, 1 UNION ALL
	SELECT 75001, 2, 3, 1 UNION ALL
	SELECT 75005, 2, 2, 1

	
--Это скрипт для расчета ретро бонусов
/*
Версия 1. moa0 30-10-2018 13:11
Версия 2. Добавлен "красивый" вывод и подкорректирован алгоритм расчета. moa0 31-10-2018 17:10
*/

/*
SELECT m.AValue, arcot.BonusTypeID
FROM zf_FilterToTable(@CompID) AS m
JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (arcot.CompID=m.AValue)
WHERE arcot.BonusTypeID = 13
*/						   
IF OBJECT_ID (N'tempdb..#Result', N'U') IS NOT NULL DROP TABLE #Result
CREATE TABLE #Result (CompID INT, CompName VARCHAR(250), SumCC NUMERIC(21,9)
						,PDZ NUMERIC(21,9), Bonus NUMERIC(21,9))

SET DATEFIRST 1 --Установить первый день недели - понедельник.
SET NOCOUNT ON  --Это для того чтобы убрать сообщения про количество обработанных строк.

DECLARE  @EndDate DATE --Дата конца выборки
SET @EndDate = DATEADD(MONTH, ((YEAR(@BeginDate) - 1900) * 12) + MONTH(@BeginDate), -1) -- Устанавливаем последний день месяца.

DECLARE @CompID INT, @Para INT --Переменные для курсора
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT CompID, Para1 FROM #Comps					   

OPEN CURSOR1 --Создаем курсор для перебора введенных в @CompID фирм.
	FETCH NEXT FROM CURSOR1 INTO @CompID, @Para
WHILE @@FETCH_STATUS = 0		 
BEGIN
	
	IF @Para = 1 --Если Весь Ассортимент
	BEGIN
				
		IF OBJECT_ID (N'tempdb..#Rec1', N'U') IS NOT NULL DROP TABLE #Rec1
		CREATE TABLE #Rec1 (CompID INT, SumCC NUMERIC(21,9))

		--1. Приход денег - Приход денег по предприятиям (Приход ДС на листе ДС)
		INSERT INTO #Rec1
		SELECT @CompID, ISNULL(SUM(m.SumAC * m.KursCC),0) SumCC
		FROM c_CompRec m WITH(NOLOCK)
		  WHERE  m.CompID = @CompID
			AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
			AND (m.CodeID2 = 18)
			AND (m.OurID IN (SELECT AValue FROM zf_FilterToTable(@OurID)))
			AND (m.DocDate BETWEEN @BeginDate AND @EndDate)
			GROUP BY m.CompID
			
		    IF OBJECT_ID (N'tempdb..#PDZ1', N'U') IS NOT NULL DROP TABLE #PDZ1
			CREATE TABLE #PDZ1 (CompID INT, SumCC NUMERIC(21,9))
			--8. (ПДЗ с учетом ТК и оплаты. Лист ПДЗ.) = (ПДЗ c учетом ТК и приходом ДС за первые 5 дней текущего мес. Лист Реестр.)
			INSERT INTO #PDZ1
			SELECT @CompID, SUM(s5.SumCC) SumCC
			FROM ( 
					--6. Просрочено всего c учетом ТК. Лист ПДЗ.
					SELECT s3.CompID
						   ,SUM(s3.SumCC) + (SELECT (ISNULL((arcot.MaxCredit+arcot.MaxCredit2),0))) SumCC
					   FROM (
								--Просроч. всего - Расходная накладная:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Inv m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID
								     
								UNION ALL
								--Просроч. всего - Прием наличных денег на склад:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход товара:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Rec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара поставщику:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_CRet m WITH(NOLOCK)
								  WHERE m.CompID = @CompID
								   AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
								   AND (m.OurID = 1)
								   AND (m.DocDate <= @EndDate)
								   GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара от получателя:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Ret m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расход денег по предприятиям:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход денег по предприятиям:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Входящий баланс: Предприятия (Финансы):
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompIn m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Exp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ в ценах прихода:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Epp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Корректировка баланса предприятия:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Планирование: Доходы:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_PlanRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID
						 )s3
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s3.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s3.CompID, arcot.MaxCredit, arcot.MaxCredit2
					
					UNION ALL
					--7. Приход ДС. Лист ПДЗ.
					SELECT s4.CompID, ISNULL(SUM(s4.SumCC),0) SumCC 
					FROM(
								--Оплачено - Прием наличных денег на склад:								SELECT  m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Расход денег по предприятиям:								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Приход денег по предприятиям:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Корректировка баланса предприятия:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
					)s4
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s4.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s4.CompID
			)s5
			GROUP BY s5.CompID

			IF NOT EXISTS(SELECT SumCC FROM #PDZ1)
			BEGIN
			INSERT INTO #PDZ1
			SELECT @CompID, 0
			END
			
			IF NOT EXISTS(SELECT SumCC FROM #Rec1)
			BEGIN
			INSERT INTO #Rec1
			SELECT @CompID, 0
			END
			
			IF (SELECT SumCC FROM #PDZ1) <= -100 --Если сумма ПДЗ <= -100
			BEGIN
			INSERT INTO #Result
			SELECT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ, 0 Bonus
			FROM #Rec1 tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ1 tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END

			ELSE
			BEGIN
			INSERT INTO #Result
			SELECT DISTINCT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ
							,CASE WHEN EXISTS (SELECT BonusTypeID, BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13) THEN (tm.SumCC*((SELECT BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13 AND OurID = 1)/100)) ELSE 0 END Bonus
			FROM #Rec1 tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ1 tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END
	END--end of IF @Para = 1
	
	IF @Para = 2 -- Если НЕ Весь Ассортимент
	BEGIN	
			IF OBJECT_ID (N'tempdb..#Rec', N'U') IS NOT NULL DROP TABLE #Rec
			CREATE TABLE #Rec (CompID INT, SumCC NUMERIC(21,9))

			--1. Приход денег - Приход денег по предприятиям (Приход ДС на листе ДС)
			INSERT INTO #Rec
			SELECT @CompID, ISNULL(SUM(m.SumAC * m.KursCC),0) SumCC
			FROM c_CompRec m WITH(NOLOCK)
			  WHERE  m.CompID = @CompID
				AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
				AND (m.CodeID2 = 18)
				AND (m.OurID IN (SELECT AValue FROM zf_FilterToTable(@OurID)))
				AND (m.DocDate BETWEEN @BeginDate AND @EndDate)
				GROUP BY m.CompID
		
			SET @EndDate = DATEADD(MONTH, ((YEAR(@BeginDate) - 1900) * 12) + (MONTH(@BeginDate)-1), -1)
			SET @BeginDate = DATEADD(MONTH, -1, @BeginDate) --Перенос начальной и конечно даты на месяц назад.


			IF OBJECT_ID (N'tempdb..#Percents', N'U') IS NOT NULL DROP TABLE #Percents
			CREATE TABLE #Percents (CompID INT, Perc NUMERIC(21,9), Other_brands NUMERIC(21,9),Shipm NUMERIC(21,9), ShipKKOaKU NUMERIC(21,9))
			
			INSERT INTO #Percents
			SELECT @CompID, 0, 0, 0, 0
			;WITH
					--2. Отгрузка. Лист ДС.    
					Shipm_CTE AS (SELECT s1.CompID, ISNULL(SUM(s1.SumMC),0) SumMC
								FROM (    
										--Накладные - Расходная накладная (Отгрузка на листе ДС)    
										SELECT m.CompID, SUM(tid.SumCC_wt / m.KursMC) SumMC
										FROM t_Inv m WITH(NOLOCK)
										JOIN t_InvD tid WITH(NOLOCK) ON (tid.ChID=m.ChID)
										  WHERE  m.CompID = @CompID
											AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
											AND (m.OurID IN (select AValue from zf_FilterToTable(@OurID)))
											AND (m.DocDate BETWEEN @BeginDate AND @EndDate) -- это брать за прошлый месяц от расчитуемого
											GROUP BY m.CompID

										UNION ALL

										--Возврат - Возврат товара от получателя (Это нужно вычесть из Отгрузка на листе ДС)
										SELECT m.CompID, -ISNULL(SUM(trd.SumCC_wt / m.KursMC),0) SumMC
										FROM t_Ret m WITH(NOLOCK)
										JOIN t_RetD trd WITH(NOLOCK) ON (trd.ChID=m.ChID)
										  WHERE  m.CompID = @CompID
											AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
											AND (m.OurID IN (select AValue from zf_FilterToTable(@OurID)))
											AND (m.DocDate BETWEEN @BeginDate AND @EndDate) -- это брать за прошлый месяц от расчитуемого
										  GROUP BY m.CompID
								  ) s1
								GROUP BY s1.CompID
								)

					--3. Отгрузка ККО, КЮ. Лист ДС.    
					,Shipm_nKKOaKU_CTE AS (SELECT s2.CompID, ISNULL(SUM(s2.SumMC),0) SumMC
												FROM (    
														--Накладные - Расходная накладная (Отгрузка на листе ДС)    
														SELECT m.CompID, SUM(tid.SumCC_wt / m.KursMC) SumMC
														FROM t_Inv m WITH(NOLOCK)
														JOIN t_InvD tid WITH(NOLOCK) ON (tid.ChID=m.ChID)
														JOIN t_PInP tpinp WITH(NOLOCK) ON (tpinp.PPID=tid.PPID AND tpinp.ProdID=tid.ProdID)
														JOIN r_Prods rp WITH(NOLOCK) ON (rp.ProdID=tpinp.ProdID)
														  WHERE  m.CompID = @CompID
															AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
															AND ( (rp.PGrID1 IN (18,63)) OR (rp.PGrID1 BETWEEN 20 AND 29) )
															AND (m.OurID IN (select AValue from zf_FilterToTable(@OurID)))
															AND (m.DocDate BETWEEN @BeginDate AND @EndDate) -- это брать за прошлый месяц от расчитуемого
															GROUP BY m.CompID, m.CodeID1

														UNION ALL

														--Возврат - Возврат товара от получателя (Это нужно вычесть из Отгрузка на листе ДС)
														SELECT m.CompID, -ISNULL(SUM(trd.SumCC_wt / m.KursMC),0) SumMC
														FROM t_Ret m WITH(NOLOCK)
														JOIN t_RetD trd WITH(NOLOCK) ON (trd.ChID=m.ChID)
														JOIN t_PInP tpinp WITH(NOLOCK) ON (tpinp.PPID=trd.PPID AND tpinp.ProdID=trd.ProdID)
														JOIN r_Prods rp WITH(NOLOCK) ON (rp.ProdID=tpinp.ProdID)
														  WHERE  m.CompID = @CompID
															AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
															AND ( (rp.PGrID1 IN (18,63)) OR (rp.PGrID1 BETWEEN 20 AND 29) )
															AND (m.OurID IN (select AValue from zf_FilterToTable(@OurID)))
															AND (m.DocDate BETWEEN @BeginDate AND @EndDate) -- это брать за прошлый месяц от расчитуемого
														  GROUP BY m.CompID
												  ) s2
												GROUP BY s2.CompID
											)
											
			--4. % КК,КЮ и % остальные бренды. Лист ДС.
			--INSERT INTO #Percents
			--SELECT @CompID, ISNULL((m.SumMC / scte.SumMC),0) Perc, (1-ISNULL((m.SumMC / scte.SumMC),0)) Other_brands, ISNULL(scte.SumMC,0) Shipm, ISNULL(m.SumMC,0) ShipKKOaKU
			--FROM Shipm_nKKOaKU_CTE m
			--JOIN Shipm_CTE scte ON (scte.CompID = @CompID)
			UPDATE #Percents
			SET	Perc = ISNULL((SELECT SumMC FROM Shipm_nKKOaKU_CTE)/(SELECT SumMC FROM Shipm_CTE),0)		
			    ,Other_brands = ISNULL( (1-(SELECT SumMC FROM Shipm_nKKOaKU_CTE)/(SELECT SumMC FROM Shipm_CTE)),0)		
				,Shipm = ISNULL( (SELECT SumMC FROM Shipm_CTE),0)		
				,ShipKKOaKU = ISNULL( (SELECT SumMC FROM Shipm_nKKOaKU_CTE),0)		
			
			--5. (Приход ДС расчет. Лист ДС.) = (Приход ДС. Лист Реестр.)
			UPDATE #Rec
			SET SumCC = (SELECT CASE WHEN Other_brands = 0 THEN (SELECT SumCC FROM #Rec) ELSE (SELECT ISNULL((SumCC * (SELECT Other_brands FROM #Percents)),0) FROM #Rec) END FROM #Percents)
			
			SET @BeginDate = DATEADD(MONTH, +1, @BeginDate) --Возвращаемся на изначальные даты.
			SET @EndDate = DATEADD(MONTH, ((YEAR(@BeginDate) - 1900) * 12) + (MONTH(@BeginDate)), -1)

			IF OBJECT_ID (N'tempdb..#PDZ', N'U') IS NOT NULL DROP TABLE #PDZ
			CREATE TABLE #PDZ (CompID INT, SumCC NUMERIC(21,9))
			--8. (ПДЗ с учетом ТК и оплаты. Лист ПДЗ.) = (ПДЗ c учетом ТК и приходом ДС за первые 5 дней текущего мес. Лист Реестр.)
			INSERT INTO #PDZ
			SELECT @CompID, SUM(s5.SumCC) SumCC
			FROM ( 
					--6. Просрочено всего c учетом ТК. Лист ПДЗ.
					SELECT s3.CompID
						   ,SUM(s3.SumCC) + (SELECT (ISNULL((arcot.MaxCredit+arcot.MaxCredit2),0))) SumCC
					   FROM (
								--Просроч. всего - Расходная накладная:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Inv m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID
								     
								UNION ALL
								--Просроч. всего - Прием наличных денег на склад:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход товара:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Rec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара поставщику:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_CRet m WITH(NOLOCK)
								  WHERE m.CompID = @CompID
								   AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
								   AND (m.OurID = 1)
								   AND (m.DocDate <= @EndDate)
								   GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара от получателя:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Ret m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расход денег по предприятиям:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход денег по предприятиям:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Входящий баланс: Предприятия (Финансы):
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompIn m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Exp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ в ценах прихода:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Epp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Корректировка баланса предприятия:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Планирование: Доходы:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_PlanRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID
						 )s3
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s3.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s3.CompID, arcot.MaxCredit, arcot.MaxCredit2
					
					UNION ALL
					--7. Приход ДС. Лист ПДЗ.
					SELECT s4.CompID, ISNULL(SUM(s4.SumCC),0) SumCC 
					FROM(
								--Оплачено - Прием наличных денег на склад:								SELECT  m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Расход денег по предприятиям:								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Приход денег по предприятиям:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Корректировка баланса предприятия:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
					)s4
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s4.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s4.CompID
			)s5
			GROUP BY s5.CompID

			IF NOT EXISTS(SELECT SumCC FROM #PDZ)
			BEGIN
			INSERT INTO #PDZ
			SELECT @CompID, 0
			END
			
			IF NOT EXISTS(SELECT SumCC FROM #Rec)
			BEGIN
			INSERT INTO #Rec
			SELECT @CompID, 0
			END
			
			IF (SELECT SumCC FROM #PDZ) <= -100 --Если сумма ПДЗ <= -100
			BEGIN
			INSERT INTO #Result
			SELECT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ, 0 Bonus
			FROM #Rec tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END

			ELSE
			BEGIN
			INSERT INTO #Result
			SELECT DISTINCT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ
							,CASE WHEN EXISTS (SELECT BonusTypeID, BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13) THEN (tm.SumCC*((SELECT BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13 AND OurID = 1)/100)) ELSE 0 END Bonus
			FROM #Rec tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END
		END--end of IF @Para = 2
		
		IF @Para = 3 --Если СТ 49
		BEGIN
		
		IF OBJECT_ID (N'tempdb..#Rec2', N'U') IS NOT NULL DROP TABLE #Rec2
			CREATE TABLE #Rec2 (CompID INT, SumCC NUMERIC(21,9))

		--1. Накладные - Расходная накладная (Приход ДС на листе ДС)
		INSERT INTO #Rec2
		SELECT m.CompID, SUM(tid.SumCC_wt) SumMC
			FROM t_Inv m WITH(NOLOCK)
			JOIN t_InvD tid WITH(NOLOCK) ON (tid.ChID=m.ChID)
			JOIN t_PInP tpip WITH(NOLOCK) ON (tpip.PPID=tid.PPID AND tpip.ProdID=tid.ProdID)
			JOIN r_Prods rp WITH(NOLOCK) ON (rp.ProdID=tpip.ProdID)
			  WHERE (rp.PGrID1 = 49)
				AND (m.CompID = @CompID)
				AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
				AND (m.OurID IN (SELECT AValue FROM zf_FilterToTable(@OurID)))
				AND (m.DocDate BETWEEN @BeginDate AND @EndDate)
				GROUP BY m.CompID
		
			IF OBJECT_ID (N'tempdb..#PDZ2', N'U') IS NOT NULL DROP TABLE #PDZ2
			CREATE TABLE #PDZ2 (CompID INT, SumCC NUMERIC(21,9))
			--8. (ПДЗ с учетом ТК и оплаты. Лист ПДЗ.) = (ПДЗ c учетом ТК и приходом ДС за первые 5 дней текущего мес. Лист Реестр.)
			INSERT INTO #PDZ2
			SELECT @CompID, SUM(s5.SumCC) SumCC
			FROM ( 
					--6. Просрочено всего c учетом ТК. Лист ПДЗ.
					SELECT s3.CompID
						   ,SUM(s3.SumCC) + (SELECT (ISNULL((arcot.MaxCredit+arcot.MaxCredit2),0))) SumCC
					   FROM (
								--Просроч. всего - Расходная накладная:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Inv m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID
								     
								UNION ALL
								--Просроч. всего - Прием наличных денег на склад:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход товара:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Rec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара поставщику:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_CRet m WITH(NOLOCK)
								  WHERE m.CompID = @CompID
								   AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
								   AND (m.OurID = 1)
								   AND (m.DocDate <= @EndDate)
								   GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара от получателя:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Ret m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расход денег по предприятиям:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход денег по предприятиям:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Входящий баланс: Предприятия (Финансы):
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompIn m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Exp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ в ценах прихода:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Epp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Корректировка баланса предприятия:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Планирование: Доходы:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_PlanRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID
						 )s3
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s3.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s3.CompID, arcot.MaxCredit, arcot.MaxCredit2
					
					UNION ALL
					--7. Приход ДС. Лист ПДЗ.
					SELECT s4.CompID, ISNULL(SUM(s4.SumCC),0) SumCC 
					FROM(
								--Оплачено - Прием наличных денег на склад:								SELECT  m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Расход денег по предприятиям:								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Приход денег по предприятиям:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Корректировка баланса предприятия:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
					)s4
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s4.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s4.CompID
			)s5
			GROUP BY s5.CompID
			
			IF NOT EXISTS(SELECT SumCC FROM #PDZ2)
			BEGIN
			INSERT INTO #PDZ2
			SELECT @CompID, 0
			END
			
			IF NOT EXISTS(SELECT SumCC FROM #Rec2)
			BEGIN
			INSERT INTO #Rec2
			SELECT @CompID, 0
			END
			
			IF (SELECT SumCC FROM #PDZ2) <= -100 --Если сумма ПДЗ <= -100
			BEGIN
			INSERT INTO #Result
			SELECT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ, 0 Bonus
			FROM #Rec2 tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ2 tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END

			ELSE
			BEGIN
			INSERT INTO #Result
			SELECT DISTINCT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ
							,CASE WHEN EXISTS (SELECT BonusTypeID, BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13) THEN (tm.SumCC*((SELECT BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13 AND OurID = 1)/100)) ELSE 0 END Bonus
			FROM #Rec2 tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ2 tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END
		END
		
		
		IF @Para = 4 --Если Кока-кола
		BEGIN
		
		IF OBJECT_ID (N'tempdb..#Rec3', N'U') IS NOT NULL DROP TABLE #Rec3
			CREATE TABLE #Rec3 (CompID INT, SumCC NUMERIC(21,9))

		--1. Накладные - Расходная накладная (Приход ДС на листе ДС)
		INSERT INTO #Rec3
		SELECT m.CompID, SUM(tid.SumCC_wt) SumMC
			FROM t_Inv m WITH(NOLOCK)
			JOIN t_InvD tid WITH(NOLOCK) ON (tid.ChID=m.ChID)
			JOIN t_PInP tpip WITH(NOLOCK) ON (tpip.PPID=tid.PPID AND tpip.ProdID=tid.ProdID)
			JOIN r_Prods rp WITH(NOLOCK) ON (rp.ProdID=tpip.ProdID)
			  WHERE (rp.PGrID1 IN (27,28,29,63))
				AND (m.CompID = @CompID)
				AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
				AND (m.OurID IN (SELECT AValue FROM zf_FilterToTable(@OurID)))
				AND (m.DocDate BETWEEN @BeginDate AND @EndDate)
				GROUP BY m.CompID
		
			IF OBJECT_ID (N'tempdb..#PDZ3', N'U') IS NOT NULL DROP TABLE #PDZ3
			CREATE TABLE #PDZ3 (CompID INT, SumCC NUMERIC(21,9))
			--8. (ПДЗ с учетом ТК и оплаты. Лист ПДЗ.) = (ПДЗ c учетом ТК и приходом ДС за первые 5 дней текущего мес. Лист Реестр.)
			INSERT INTO #PDZ3
			SELECT @CompID, SUM(s5.SumCC) SumCC
			FROM ( 
					--6. Просрочено всего c учетом ТК. Лист ПДЗ.
					SELECT s3.CompID
						   ,SUM(s3.SumCC) + (SELECT (ISNULL((arcot.MaxCredit+arcot.MaxCredit2),0))) SumCC
					   FROM (
								--Просроч. всего - Расходная накладная:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Inv m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID
								     
								UNION ALL
								--Просроч. всего - Прием наличных денег на склад:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход товара:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Rec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара поставщику:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_CRet m WITH(NOLOCK)
								  WHERE m.CompID = @CompID
								   AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
								   AND (m.OurID = 1)
								   AND (m.DocDate <= @EndDate)
								   GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара от получателя:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Ret m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расход денег по предприятиям:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход денег по предприятиям:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Входящий баланс: Предприятия (Финансы):
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompIn m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Exp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ в ценах прихода:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Epp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Корректировка баланса предприятия:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Планирование: Доходы:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_PlanRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID
						 )s3
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s3.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s3.CompID, arcot.MaxCredit, arcot.MaxCredit2
					
					UNION ALL
					--7. Приход ДС. Лист ПДЗ.
					SELECT s4.CompID, ISNULL(SUM(s4.SumCC),0) SumCC 
					FROM(
								--Оплачено - Прием наличных денег на склад:								SELECT  m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Расход денег по предприятиям:								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Приход денег по предприятиям:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Корректировка баланса предприятия:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
					)s4
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s4.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s4.CompID
			)s5
			GROUP BY s5.CompID
			
			IF NOT EXISTS(SELECT SumCC FROM #PDZ3)
			BEGIN
			INSERT INTO #PDZ3
			SELECT @CompID, 0
			END
			
			IF NOT EXISTS(SELECT SumCC FROM #Rec3)
			BEGIN
			INSERT INTO #Rec3
			SELECT @CompID, 0
			END
			
			IF (SELECT SumCC FROM #PDZ3) <= -100 --Если сумма ПДЗ <= -100
			BEGIN
			INSERT INTO #Result
			SELECT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ, 0 Bonus
			FROM #Rec3 tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ3 tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END

			ELSE
			BEGIN
			INSERT INTO #Result
			SELECT DISTINCT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ
							,CASE WHEN EXISTS (SELECT BonusTypeID, BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13) THEN (tm.SumCC*((SELECT BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13 AND OurID = 1)/100)) ELSE 0 END Bonus
			FROM #Rec3 tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ3 tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END
		END
		
		IF @Para = 5 -- Если Кофе
		BEGIN	
			IF OBJECT_ID (N'tempdb..#Rec4', N'U') IS NOT NULL DROP TABLE #Rec4
			CREATE TABLE #Rec4 (CompID INT, SumCC NUMERIC(21,9))

			--1. Приход денег - Приход денег по предприятиям (Приход ДС на листе ДС)
			INSERT INTO #Rec4
			SELECT @CompID, ISNULL(SUM(m.SumAC * m.KursCC),0) SumCC
			FROM c_CompRec m WITH(NOLOCK)
			  WHERE  m.CompID = @CompID
				AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
				AND (m.CodeID2 = 18)
				AND (m.OurID = 3)
				AND (m.DocDate BETWEEN @BeginDate AND @EndDate)
				GROUP BY m.CompID

			IF OBJECT_ID (N'tempdb..#PDZ4', N'U') IS NOT NULL DROP TABLE #PDZ4
			CREATE TABLE #PDZ4 (CompID INT, SumCC NUMERIC(21,9))
			--8. (ПДЗ с учетом ТК и оплаты. Лист ПДЗ.) = (ПДЗ c учетом ТК и приходом ДС за первые 5 дней текущего мес. Лист Реестр.)
			INSERT INTO #PDZ4
			SELECT @CompID, SUM(s5.SumCC) SumCC
			FROM ( 
					--6. Просрочено всего c учетом ТК. Лист ПДЗ.
					SELECT s3.CompID
						   ,SUM(s3.SumCC) + (SELECT (ISNULL((arcot.MaxCredit+arcot.MaxCredit2),0))) SumCC
					   FROM (
								--Просроч. всего - Расходная накладная:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Inv m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID
								     
								UNION ALL
								--Просроч. всего - Прием наличных денег на склад:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход товара:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Rec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара поставщику:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_CRet m WITH(NOLOCK)
								  WHERE m.CompID = @CompID
								   AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
								   AND (m.OurID = 1)
								   AND (m.DocDate <= @EndDate)
								   GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Возврат товара от получателя:
								SELECT m.CompID, SUM(m.TSumCC_wt * m.KursCC) SumCC
								FROM t_Ret m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расход денег по предприятиям:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Приход денег по предприятиям:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Входящий баланс: Предприятия (Финансы):
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompIn m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Exp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Расходный документ в ценах прихода:
								SELECT m.CompID, SUM(0-(m.TSumCC_wt * m.KursCC)) SumCC
								FROM t_Epp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= (CAST(@EndDate as smalldatetime) - m.PayDelay))
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Корректировка баланса предприятия:
								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID

								UNION ALL
								--Просроч. всего - Планирование: Доходы:
								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_PlanRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate <= @EndDate)
									 GROUP BY m.CompID
						 )s3
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s3.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s3.CompID, arcot.MaxCredit, arcot.MaxCredit2
					
					UNION ALL
					--7. Приход ДС. Лист ПДЗ.
					SELECT s4.CompID, ISNULL(SUM(s4.SumCC),0) SumCC 
					FROM(
								--Оплачено - Прием наличных денег на склад:								SELECT  m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM t_MonRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Расход денег по предприятиям:								SELECT m.CompID, SUM(0-(m.SumAC * m.KursCC)) SumCC
								FROM c_CompExp m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Приход денег по предприятиям:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompRec m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
								UNION ALL								--Оплачено - Корректировка баланса предприятия:								SELECT m.CompID, SUM(m.SumAC * m.KursCC) SumCC
								FROM c_CompCor m WITH(NOLOCK)
								  WHERE  m.CompID = @CompID
									 AND (m.CodeID1 IN (SELECT AValue FROM zf_FilterToTable(@CodeID1)))
									 AND (m.OurID = 1)
									 AND (m.DocDate BETWEEN DATEADD(DAY,1,@EndDate) AND (DATEADD(DAY,7,@EndDate)))
									 GROUP BY m.CompID
					)s4
						 LEFT JOIN at_r_CompOurTerms arcot WITH(NOLOCK) ON (s4.CompID=arcot.CompID)
					WHERE arcot.OurID = 1
					GROUP BY s4.CompID
			)s5
			GROUP BY s5.CompID

			IF NOT EXISTS(SELECT SumCC FROM #PDZ4)
			BEGIN
			INSERT INTO #PDZ4
			SELECT @CompID, 0
			END
			
			IF NOT EXISTS(SELECT SumCC FROM #Rec4)
			BEGIN
			INSERT INTO #Rec4
			SELECT @CompID, 0
			END
			
			IF (SELECT SumCC FROM #PDZ4) <= -100 --Если сумма ПДЗ <= -100
			BEGIN
			INSERT INTO #Result
			SELECT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ, 0 Bonus
			FROM #Rec4 tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ4 tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END

			ELSE
			BEGIN
			INSERT INTO #Result
			SELECT DISTINCT @CompID, rc.CompName, tm.SumCC, tpdz.SumCC PDZ
							,CASE WHEN EXISTS (SELECT BonusTypeID, BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13) THEN (tm.SumCC*((SELECT BonusPercent FROM at_r_CompOurTerms WHERE CompID = @CompID AND BonusTypeID = 13 AND OurID = 1)/100)) ELSE 0 END Bonus
			FROM #Rec4 tm
			JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=@CompID)
			JOIN #PDZ4 tpdz WITH(NOLOCK) ON (tpdz.CompID=tm.CompID)
			END
		END--end of IF @Para = 5
		
	FETCH NEXT FROM CURSOR1 INTO @CompID, @Para
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

/*
Черновик

SELECT * FROM r_CompGrs2
SELECT * FROM r_Comps
WHERE CompID = 3040

SELECT BonusTypeID, BonusPercent FROM at_r_CompOurTerms
WHERE CompID = 71069
  AND BonusTypeID = 13
  
SELECT * FROM at_r_CompOurTerms
WHERE CompID = 14480
  AND BonusTypeID = 13

SELECT * FROM v_Reps
WHERE RepID = 33
*/

SELECT rcg2.CompGrName2 'Дистрибуция'
	   ,(res.CompID) 'ТРТ'
	   ,(res.CompName) 'Имя ТРТ'
	   ,CASE WHEN ct.Para1 = 1 THEN 'Весь ассортимент' 
			 WHEN ct.Para1 = 2 THEN 'Весь ассортимент кроме Кока-Кола и Кампари'
			 WHEN ct.Para1 = 3 THEN 'СТ 49'
			 WHEN ct.Para1 = 4 THEN 'Кока-кола'
			 WHEN ct.Para1 = 5 THEN 'Кофе'
							   ELSE '?' END 'Ассорт. направление (за какие ТМ платится бонус)'
	   ,CASE WHEN ct.Para2 = 1 THEN 'ВЗ 2'
			 WHEN ct.Para2 = 2 THEN 'Товаром'
			 WHEN ct.Para2 = 3 THEN 'нал-и через СБ'
							   ELSE '?' END 'форма выплаты'
	   ,CASE WHEN ct.Para3 = 1 THEN 'от оплат'
			 WHEN ct.Para3 = 2 THEN 'от отгрузок'
							   ELSE '?' END 'Имя типа бонуса (отгрузок или оплат)'
	   ,CASE WHEN EXISTS (SELECT BonusTypeID, BonusPercent FROM at_r_CompOurTerms WHERE CompID = res.CompID AND BonusTypeID = 13) THEN REPLACE((SELECT BonusPercent FROM at_r_CompOurTerms WHERE CompID = res.CompID AND BonusTypeID = 13 AND OurID = 1),'.',',') ELSE '0' END '% бонуса'
	   ,CASE WHEN res.SumCC >= 0 THEN REPLACE(ROUND(res.SumCC,2),'.',',') ELSE '0,00' END 'Приход ДС'
	   ,REPLACE(ROUND(res.PDZ,2),'.',',') 'ПДЗ c учетом ТК и приходом ДС за первые 5 дней текущего мес.'
	   ,REPLACE(ROUND(res.Bonus,2),'.',',') 'Сумма бонуса' 
FROM (
SELECT m.CompID, rc.CompName, 0 SumCC, 0 PDZ, 0 Bonus
FROM #Comps m
JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID=m.CompID)
WHERE m.CompID NOT IN (SELECT CompID FROM #Result)

UNION ALL
SELECT *
FROM #Result m
)res
JOIN r_Comps rc WITH(NOLOCK) ON (rc.CompID = res.CompID)
JOIN r_CompGrs2 rcg2 WITH(NOLOCK) ON (rcg2.CompGrID2 = rc.CompGrID2)
JOIN #Comps ct WITH(NOLOCK) ON (ct.CompID = res.CompID)
ORDER BY 'ТРТ'