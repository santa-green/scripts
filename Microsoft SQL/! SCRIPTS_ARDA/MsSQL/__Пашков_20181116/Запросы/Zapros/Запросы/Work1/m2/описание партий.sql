USE OTData

UPDATE t_PInP
SET PPDesc = '' WHERE PPID > 0

UPDATE t_PInP
SET t_PInP.PPDesc = str(t_RecD.Qty, 10, 2) + ' -' + str(t_RecD.Extra, 10, 2)+'%'
FROM t_PInP INNER JOIN
    t_RecD ON t_PInP.ProdID = t_RecD.ProdID AND 
    t_PInP.PPID = t_RecD.PPID INNER JOIN
    t_Rec ON t_RecD.ChID = t_Rec.ChID
WHERE t_PInP.PPDesc = ''

UPDATE t_PInP
SET PPDesc = 'Неправильная партия' WHERE PPDesc = '' AND PPID > 0