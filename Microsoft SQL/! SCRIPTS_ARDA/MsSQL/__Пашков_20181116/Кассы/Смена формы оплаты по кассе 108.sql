SELECT TRealSum, * FROM t_sale where DocTime > '2017-03-09 00:00:00'
and CRID in (104,105,106,107,108,109,151,152,153,154,156,157,158,159,160,161)
order by t_sale.TRealSum desc

SELECT * FROM r_CRs

DECLARE  @ChID int = 100421655
SELECT * FROM t_sale where ChID = @ChID

SELECT * FROM t_saled where ChID = @ChID

SELECT * FROM t_MonRec where ChID in (SELECT DocID FROM t_sale where ChID = @ChID)


DECLARE  @ChID int = 100421656
SELECT * FROM t_sale where ChID = @ChID

SELECT * FROM t_saled where ChID = @ChID

SELECT * FROM t_MonRec where ChID in (SELECT DocID FROM t_sale where ChID = @ChID)


--delete t_MonRec where DocID = 100342764

SELECT  * FROM t_sale where DocTime > '2017-02-08 18:00:00'
and CRID in (108)
order by t_sale.TRealSum desc
