SELECT *
FROM
(
	SELECT q2.OurID, ro.OurName, q2.CompID, rc.CompName, rc.CompGrID2, rcg2.CompGrName2, q2.AnswerID AS '№ ответа', ru.RefName AS 'Ответ', q2.RunDate AS 'Дата', q2.CountRun AS Qty
		  ,(SELECT ISNULL(TSumCC, 0) FROM af_GetCompDelayBalance(q2.RunDate, q2.CompID, 0) WHERE OurID = q2.OurID) AS 'Просроч. всего'
	FROM
	(	
		SELECT q1.OurID, q1.CompID, q1.RunDate, q1.AnswerID, q1.CountRun
		, ROW_NUMBER() OVER(PARTITION BY q1.CompID, q1.RunDate ORDER BY q1.CompID) number_of_dublicates
		FROM 
			(SELECT atior.OurID, atior.CompID, CAST(awrs.RunDate AS DATE) AS 'RunDate', awrs.AnswerID, awrs.CountRun
			FROM at_t_IORes atior
			JOIN at_WEB_Run_Script awrs WITH(NOLOCK) ON awrs.DocChID = atior.ChID AND awrs.WebServiceID = 3 AND awrs.DocCode = 666004 AND awrs.RunDate IS NOT NULL
			WHERE atior.ChID IN (SELECT DISTINCT DocChID FROM at_WEB_Run_Script WHERE WebServiceID = 3 AND DocCode = 666004 AND RunDate IS NOT NULL)
			) AS q1
	) AS q2
	JOIN r_Uni ru WITH(NOLOCK) ON ru.RefID = q2.AnswerID AND ru.RefTypeID = 6680123
	JOIN r_Ours ro WITH(NOLOCK) ON ro.OurID = q2.OurID
	JOIN r_Comps rc WITH(NOLOCK) ON rc.CompID = q2.CompID
	JOIN r_CompGrs2 rcg2 WITH(NOLOCK) ON rcg2.CompGrID2 = rc.CompGrID2
	WHERE number_of_dublicates = 1
	  --AND q2.RunDate >= %REPORT_BEGINDATE%
	  --AND q2.RunDate <= %REPORT_ENDDATE%
) mq
WHERE CompID = 2913

SELECT TSumCC FROM af_GetCompDelayBalance(GETDATE(), 2913, 0) WHERE OurID = 1
/*
DECLARE @t TABLE (CompID INT, AnsID INT, AnsName VARCHAR(250), DocDate SMALLDATETIME, Qty INT)
DECLARE @ChID BIGINT

DECLARE Trigg CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT DISTINCT ChID
FROM at_t_IORes
WHERE ChID IN
	(
	 SELECT DISTINCT DocChID
	 FROM at_WEB_Run_Script
	 WHERE WebServiceID = 3
	   AND DocCode = 666004
	   AND RunDate IS NOT NULL
	   --AND RunDate >= %REPORT_BEGINDATE%
	   --AND RunDate <= %REPORT_ENDDATE%
	)
--AND DocDate BETWEEN '20191201' AND '20191231'
--AND DocDate >= %REPORT_BEGINDATE%
--AND DocDate <= %REPORT_ENDDATE%
ORDER BY 1

OPEN Trigg
	FETCH NEXT FROM Trigg INTO @ChID
WHILE @@FETCH_STATUS = 0	 
BEGIN
	
	IF NOT EXISTS( SELECT 1 FROM @t WHERE CompID = (SELECT CompID FROM at_t_IORes WHERE ChID = @ChID) )
	BEGIN
		INSERT INTO @t
		SELECT atior.CompID, ru.RefID, ru.RefName, atior.DocDate, 0
		FROM at_t_IORes atior
		 JOIN r_Uni ru WITH(NOLOCK) ON ru.RefTypeID = 6680123		
		WHERE ChID = @ChID
	END;

	UPDATE t
	SET Qty = Qty + 1
	FROM @t t
	WHERE CompID = (SELECT CompID FROM at_t_IORes WHERE ChID = @ChID)
	  AND AnsID = (SELECT AnswerID FROM at_WEB_Run_Script WHERE DocChID = @ChID AND DocCode = 666004 AND WebServiceID = 3 AND CountRun != 0)
		
	FETCH NEXT FROM Trigg INTO @ChID
END
CLOSE Trigg
DEALLOCATE Trigg

SELECT * FROM (
SELECT t.CompID, rc.CompName, rc.CompGrID2, rcg2.CompGrName2, t.AnsID AS '№ ответа', t.AnsName AS 'Ответ', t.DocDate, t.Qty
FROM @t t
JOIN r_Comps rc WITH(NOLOCK) ON rc.CompID = t.CompID
JOIN r_CompGrs2 rcg2 WITH(NOLOCK) ON rcg2.CompGrID2 = rc.CompGrID2
) AS q
--WHERE @VarWhere
--SELECT * FROM r_Uni

--SELECT * FROM z_Tables ORDER BY TableDesc;
*/
/*

SELECT top 20 * FROM at_WEB_Run_Script

INSERT INTO @t
SELECT DISTINCT atior.CompID, ru.RefID, ru.RefName, 0
FROM at_t_IORes atior
JOIN r_Uni ru WITH(NOLOCK) ON ru.RefTypeID = 6680123
WHERE ChID IN
	(
	 SELECT DISTINCT DocChID
	 FROM at_WEB_Run_Script
	 WHERE WebServiceID = 3
	   AND DocCode = 666004
	)
AND DocDate BETWEEN '20191201' AND '20191231'
ORDER BY 1
*/