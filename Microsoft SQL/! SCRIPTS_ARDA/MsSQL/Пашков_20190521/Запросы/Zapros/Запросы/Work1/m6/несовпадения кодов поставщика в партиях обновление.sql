USE OTData
-- поставить перед обновлением "--"
SELECT t.DocID, t.docdate ,tp.proddate ,t.CompID, rc.CompName, r.ProdID, r.ProdName, tp.PPID, tp.CompID, rc1.CompName
--update t_pinp                -- убрать для обновления  "--"
--set t_pinp.proddate = t.docdate ,    -- убрать для обновления  "--"
 --t_pinp.compid = t.compid        -- убрать для обновления  "--"
FROM t_RecD td
INNER JOIN t_Rec t ON td.ChID = t.ChID
INNER JOIN t_PInP tp ON tp.PPID = td.PPID AND tp.ProdID = td.ProdID
INNER JOIN r_Prods r ON r.ProdID = td.ProdID
INNER JOIN r_Comps rc ON rc.CompID = t.CompID
INNER JOIN r_Comps rc1 ON rc1.CompID = tp.CompID
WHERE t.CompID <> tp.CompID AND td.PPID > 0
