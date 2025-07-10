USE OTData
SELECT t.DocID, t.CompID,t.docdate , tp.proddate, rc.CompName, r.ProdID, r.ProdName, tp.PPID, tp.CompID, rc1.CompName
FROM t_RecD td
INNER JOIN t_Rec t ON td.ChID = t.ChID
INNER JOIN t_PInP tp ON tp.PPID = td.PPID AND tp.ProdID = td.ProdID
INNER JOIN r_Prods r ON r.ProdID = td.ProdID
INNER JOIN r_Comps rc ON rc.CompID = t.CompID
INNER JOIN r_Comps rc1 ON rc1.CompID = tp.CompID
WHERE t.CompID <> tp.CompID AND td.PPID > 0