/*
delete t_sale
delete t_zRep
delete t_MonRec
delete t_MonIntRec
delete t_MonIntExp
delete t_CRRet
delete t_SaleTemp
delete t_SaleTempD

*/


SELECT * FROM t_SaleTemp
SELECT * FROM t_SaleTempD

SELECT * FROM t_sale
SELECT * FROM t_saled
SELECT * FROM t_salepays
SELECT * FROM t_SaleDLV
SELECT * FROM t_zRep
SELECT * FROM t_MonRec
SELECT * FROM t_MonIntRec
SELECT * FROM t_MonIntExp

SELECT * FROM t_CRRet
SELECT * FROM t_CRRetd
SELECT * FROM t_CRRetDLV
--SELECT * FROM z_DocDC

SELECT * FROM  r_prods where ProdID in (801135,801136,801661,801662,801663,802121,803176,803178,803179,803180,605781,605785,605787,605789,605790,605791,606385,606386,606387,606388,606389,606390,606391,603816,603817,603824,603874,603816,607132,607133,607136,607137,607203,607138,607205,607206,607877,607878,603839,603840,603842,603844,603845,603841,603846,603847,603848,603850,603853,603857,611078,611596,801317,801318,801316,607086,607087,603809,603810,603811,603812,605327,607696,600362,803353,803354,601217,603744,603752,603766,603773,603778,603796,603829,607682,607683,603589,603605,801051,801117,801120,801123,801125,603583,603593,603599,603597,603606,801118,801438,603601,801121,603871,603863,603796,603752,603778,605327,603829)

SELECT * FROM r_MenuP ORDER BY 1

BEGIN TRAN

update t_sale set OurID = 12, KursMC = 29,CodeID1 = 63, CodeID2 = 18 , CodeID3 = 75
update t_sale set OurID = 12, KursMC = 29,CodeID1 = 63, CodeID2 = 18 , CodeID3 = 75
SELECT * FROM t_sale

ROLLBACK TRAN

setuser
setuser '601'

  DECLARE @MRChID INT
  EXEC z_NewChID 't_MonRec', @MRChID OUTPUT
DECLARE @ChID int = 1700000001
  SELECT
   ROW_NUMBER() OVER (ORDER BY m.DocID, p.PayFormCode) - 1 + @MRChID ChID, OurID, '0' AccountAC, DocDate, DocID, StockID, CompID, 
   '0' CompAccountAC, CurrID, KursMC, 1 KursCC, SUM(p.SumCC_wt) SumAC, REPLACE(p.Notes,'Сдача','') Subject, CodeID1, CodeID2, CodeID3, CASE m.StockID WHEN 704 THEN 0 ELSE m.CodeID4 END CodeID4,  CASE m.StockID WHEN 704 THEN 0 ELSE m.CodeID5 END CodeID5, EmpID
  FROM t_Sale m WITH(NOLOCK)
  JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID 
  WHERE m.ChID = @ChID AND p.PayFormCode IN (1,5)
  GROUP BY OurID, DocDate, DocID, StockID, CompID, CurrID, KursMC, REPLACE(p.Notes,'Сдача',''), CodeID1, CodeID2, PayFormCode, CodeID3, CodeID4, CodeID5, EmpID
  HAVING SUM(p.SumCC_wt) != 0


BEGIN TRAN
setuser
setuser '601'

        UPDATE m
	    SET m.CodeID1 = 63, 
	        m.CodeID2 = 18, 
	        m.CodeID3 = CASE p.PayFormCode WHEN 1 THEN (CASE WHEN m.StockID IN (1201,1202,1315) THEN 81 
		         									         WHEN m.StockID IN (1257) THEN 73
		         									         WHEN m.StockID IN (1245) THEN 95 --харьков пр.Науки,15
		         									         WHEN m.StockID IN (1221,1222) THEN 82
		         									         WHEN m.StockID IN (1241) THEN 93
		         									         WHEN m.StockID IN (1243) THEN 94 -- киев генерала вататина 2т
		         									         WHEN m.StockID IN (1252) THEN 78
		         									         WHEN m.StockID IN (723) THEN 91
		         									         WHEN m.StockID IN (1001) THEN 75
													         WHEN m.StockID IN (1310,1314) THEN 84 END)    
	    							       WHEN 2 THEN 27 WHEN 5 THEN 70 ELSE 0 END
  	    FROM t_Sale m WITH(NOLOCK)
	    JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID --AND p.ChID = @ChID
SELECT * FROM t_sale

ROLLBACK TRAN


BEGIN TRAN

;DISABLE TRIGGER ALL ON r_Codes5;

delete r_Codes5
insert r_Codes5
SELECT ChID, CodeID5, CodeName5, Notes FROM [s-sql-d4].elitr.dbo.r_Codes5
SELECT * FROM r_Codes5

;ENABLE TRIGGER ALL ON r_Codes5;

ROLLBACK TRAN

SELECT * FROM r_GOperD


--переделать t_MonRec
BEGIN TRAN

delete t_MonRec

DECLARE @ChID INT
DECLARE CUR CURSOR STATIC FOR
SELECT DISTINCT ChID FROM t_Sale WHERE ChID in (SELECT ChID FROM t_SaleD) ORDER BY 1
OPEN CUR
FETCH NEXT FROM CUR INTO @ChID
WHILE @@FETCH_STATUS = 0    		 
BEGIN
	EXEC dbo.apt_SaleInsertMonRec @ChID = @ChID  
	FETCH NEXT FROM CUR INTO @ChID	
END 
CLOSE CUR
DEALLOCATE CUR

SELECT * FROM t_MonRec

ROLLBACK TRAN



SELECT * FROM [s-sql-d4].elitr.dbo.t_MonRec where StockID = 1001 ORDER BY 4 desc


SELECT * FROM [s-sql-d4].elitr.dbo.r_OperCRs
SELECT * FROM r_OperCRs


DECLARE @BDiap INT = 1700000000,
		@EDiap INT = 1799999999;

(SELECT * FROM t_Sale m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_SaleD m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_SalePays m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_SaleDLV m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_zRep m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_MonRec m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_MonIntRec m WHERE m.ChID BETWEEN @BDiap AND @EDiap);
(SELECT * FROM t_MonIntExp m WHERE m.ChID BETWEEN @BDiap AND @EDiap);


(SELECT * FROM t_Sale m WHERE m.ChID not in (SELECT ChID FROM t_SaleD));
SELECT * FROM t_Sale m WHERE m.ChID in (SELECT ChID FROM t_SaleD) ORDER BY 1

BEGIN TRAN

update t_sale set StateCode = 22 WHERE ChID in (SELECT ChID FROM t_SaleD) and ChID between 1700000000 and 1799999999
--update t_sale set OurID = 12, KursMC = 29,CodeID1 = 63, CodeID2 = 18 , CodeID3 = 75
SELECT * FROM t_sale WHERE ChID in (SELECT ChID FROM t_SaleD) and ChID between 1700000000 and 1799999999

ROLLBACK TRAN