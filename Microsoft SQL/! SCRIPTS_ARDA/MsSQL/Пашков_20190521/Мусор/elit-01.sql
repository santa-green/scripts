SELECT MAX(ChID) FROM r_OursCC where EXISTS(SELECT * FROM dbo.t_Inv a WITH(NOLOCK) 
JOIN dbo.r_Comps b WITH(NOLOCK) ON b.CompID=a.CompID WHERE a.ChID = 200067543--200067119--200067294
     AND r_OursCC.OurID = a.OurID AND r_OursCC.CompGrID2 = b.CompGrID2  and r_OursCC.Notes like '%Кредит-Днепр%' )
     AND Notes IS NOT NULL AND Notes <> ''
 
 
 
 SELECT * FROM r_OursCC where EXISTS(SELECT * FROM dbo.t_Inv a WITH(NOLOCK) 
JOIN dbo.r_Comps b WITH(NOLOCK) ON b.CompID=a.CompID WHERE a.ChID = 200067301--200067119--200067294
     AND r_OursCC.OurID = a.OurID AND r_OursCC.CompGrID2 = b.CompGrID2)
     AND Notes IS NOT NULL AND Notes <> ''
     
 
     
 SELECT * FROM r_OursCC where r_OursCC.Notes like '%Кредит-Днепр%'  and OurID = 3 
 SELECT * FROM r_OursCC where OurID = 3  and r_OursCC.Notes like '%Кредит-Днепр%'
 SELECT * FROM r_OursCC where OurID = 1  and r_OursCC.Notes like '%Кредит-Днепр%'
 SELECT CompGrID2, * FROM r_Comps where CompID = 10797 --2098
 SELECT CompGrID2, * FROM r_Comps where CompID in (2030,2036,2031,2039,2035,2034,2030)
 
 Кредит-Днепр  -  Луцк
 
 2030,2036,2031,2039,2035,2034,2030

     
SELECT DISTINCT
-- Служебные данные
MIN(ChID) ChID,
CAST(dbo.af_GetFiltered(AccountCC) + ';' + CAST(BankID AS VARCHAR(10)) AS VARCHAR(250)) AS Acc,
CAST(Notes + ' - ' + dbo.af_GetFiltered(AccountCC) AS VARCHAR(250)) AS AccName, Notes, DefaultAccount,
-- Рабочие данные
dbo.af_GetFiltered(AccountCC) AccountCC, BankID
FROM r_OursCC WITH(NOLOCK)
WHERE OurID in (1,3) AND ISNULL(Notes,'') <> ''
AND (BankID IN (305749, 307123, 351005) OR OurID != 1)
AND ChID not in (1) --для исключения р.с. интернет магазина
GROUP BY dbo.af_GetFiltered(AccountCC),BankID,Notes,DefaultAccount
ORDER BY 1    

select m.DocID, m.OurID,  ( res. MilCalcGrp + res.UAEmpName) as UAEmpName from dbo.t_Inv m JOIN
    dbo.r_Stocks rs WITH(NOLOCK) ON rs.StockID=m.StockID JOIN
    dbo.at_r_OurAccSector ros WITH(NOLOCK) ON ros.OurID = m.OurID AND ros.StockGID = rs.StockGID JOIN
    dbo.r_Emps res WITH(NOLOCK) ON res.EmpID = ros.EmpID
    
    WHERE m.DocID IN (1173261)
     and m.OurID = 3
    ORDER BY m.ChID
    
SELECT OurID, CAST(OurID AS VARCHAR(10)) + ' - ' + OurName AS OurName
FROM dbo.r_Ours WITH(NOLOCK)
WHERE OurID IN (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
ORDER BY 1  

/*
SELECT * FROM t_Inv
WHERE ChiD = 200067543
ORDER BY 1;


DISABLE TRIGGER ALL ON t_Inv;
 
update t_Inv
set CompID = 10797, EmpID = 6420, StockID = 100
WHERE ChiD = 200067543; 



ENABLE  TRIGGER ALL ON t_Inv;  

*/