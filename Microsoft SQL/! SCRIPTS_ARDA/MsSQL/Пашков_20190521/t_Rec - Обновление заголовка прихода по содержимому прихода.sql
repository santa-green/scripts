--Обновление заголовка прихода по содержимому прихода
BEGIN TRAN
/*
*/

DECLARE @ChID int = 6788

SELECT * FROM t_Rec where ChID = @ChID

SELECT * FROM t_Recd where ChID = @ChID

  UPDATE r
  SET 
    r.TSumCC_nt = q.TSumCC_nt, 
    r.TTaxSum   = q.TTaxSum, 
    r.TSumCC_wt = q.TSumCC_wt
  FROM t_Rec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt 
     FROM t_Rec WITH (NOLOCK), t_RecD m
     WHERE t_Rec.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID and r.ChID = @ChID

SELECT * FROM t_Rec where ChID = @ChID

SELECT * FROM t_Recd where ChID = @ChID


ROLLBACK TRAN


--проверка заголовков приходов
/*

  SELECT r.TSumCC_nt - q.TSumCC_wt, r.TSumCC_nt, r.TTaxSum, r.TSumCC_wt, q.TSumCC_nt, q.TTaxSum, q.TSumCC_wt, *  FROM  t_Rec r, 
    (SELECT m.ChID, 
       ISNULL(SUM(m.SumCC_nt), 0) TSumCC_nt,
       ISNULL(SUM(m.TaxSum), 0) TTaxSum,
       ISNULL(SUM(m.SumCC_wt), 0) TSumCC_wt 
     FROM t_Rec r WITH (NOLOCK), t_RecD m
     WHERE r.ChID = m.ChID
     GROUP BY m.ChID) q
  WHERE q.ChID = r.ChID and (r.TSumCC_nt - q.TSumCC_nt <> 0 OR r.TSumCC_wt - q.TSumCC_wt <> 0 OR r.TTaxSum - q.TTaxSum <> 0)
  ORDER BY DocDate
  
*/
