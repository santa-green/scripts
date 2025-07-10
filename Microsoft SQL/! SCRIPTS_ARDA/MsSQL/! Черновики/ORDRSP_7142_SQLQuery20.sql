SELECT Prodid, Notes FROM r_Prods WHERE PCatID in (21) group by Prodid, Notes
SELECT Prodid, Notes FROM r_Prods WHERE Notes != '0' and PCatID in (24,30,32,34,38,48,49,95,99,1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19) group by Prodid, Notes

SELECT DISTINCT (PCatID)
FROM t_invd  ti
JOIN r_Prods rp ON rp.Prodid = ti.prodid
WHERE ti.ChID = 200497472

SELECT * FROM r_Prods