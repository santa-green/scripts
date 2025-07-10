--Обновление заголовка прихода по содержимому прихода
BEGIN TRAN
/*
*/

DECLARE @ChID int = 101543811

SELECT * FROM t_Inv where ChID = @ChID

SELECT * FROM t_Invd where ChID = @ChID

  UPDATE r
  SET 
    r.TSumCC_nt = q.TSumCC_nt, 
    r.TTaxSum   = q.TTaxSum, 
    r.TSumCC_wt = q.TSumCC_wt
  FROM t_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt 
     FROM t_Inv WITH (NOLOCK), t_InvD m
     WHERE t_Inv.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID and r.ChID = @ChID

SELECT * FROM t_Inv where ChID = @ChID

SELECT * FROM t_Invd where ChID = @ChID


ROLLBACK TRAN


--проверка заголовков приходов
/*

  SELECT r.TSumCC_nt - q.TSumCC_wt, r.TSumCC_nt, r.TTaxSum, r.TSumCC_wt, q.TSumCC_nt, q.TTaxSum, q.TSumCC_wt, *  FROM  t_Inv r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt 
     FROM t_Inv r WITH (NOLOCK), t_InvD m
     WHERE r.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID and (r.TSumCC_nt - q.TSumCC_nt <> 0 OR r.TSumCC_wt - q.TSumCC_wt <> 0 OR r.TTaxSum - q.TTaxSum <> 0)
  ORDER BY DocDate
  
*/
