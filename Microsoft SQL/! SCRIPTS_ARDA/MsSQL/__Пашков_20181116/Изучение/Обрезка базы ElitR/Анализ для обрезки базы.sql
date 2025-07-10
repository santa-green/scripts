SELECT COUNT(*) t_ZInP  FROM t_ZInP  
SELECT COUNT(*) t_Ret   FROM t_Ret   
SELECT COUNT(*) t_CRRet FROM t_CRRet 
SELECT COUNT(*) t_Rec   FROM t_Rec   
SELECT COUNT(*) t_Exc   FROM t_Exc   
SELECT COUNT(*) t_Est   FROM t_Est   
SELECT COUNT(*) t_Ven   FROM t_Ven   
SELECT COUNT(*) t_Acc   FROM t_Acc   
SELECT COUNT(*) t_SRec  FROM t_SRec  
SELECT COUNT(*) t_SExp  FROM t_SExp  
SELECT COUNT(*) t_Inv   FROM t_Inv   
SELECT COUNT(*) t_Exp   FROM t_Exp   
SELECT COUNT(*) t_Epp   FROM t_Epp   
SELECT COUNT(*) t_Sale  FROM t_Sale  
SELECT COUNT(*) t_CRet  FROM t_CRet  

SELECT COUNT(*) t_RetD   FROM t_RetD  
SELECT COUNT(*) t_CRRetD FROM t_CRRetD
SELECT COUNT(*) t_RecD   FROM t_RecD  
SELECT COUNT(*) t_ExcD   FROM t_ExcD  
SELECT COUNT(*) t_EstD   FROM t_EstD  
SELECT COUNT(*) t_VenD   FROM t_VenD  
SELECT COUNT(*) t_AccD   FROM t_AccD  
SELECT COUNT(*) t_SRecD  FROM t_SRecD 
SELECT COUNT(*) t_SExpD  FROM t_SExpD 
SELECT COUNT(*) t_InvD   FROM t_InvD  
SELECT COUNT(*) t_ExpD   FROM t_ExpD  
SELECT COUNT(*) t_EppD   FROM t_EppD  
SELECT COUNT(*) t_SaleD  FROM t_SaleD 
SELECT COUNT(*) t_CRetD  FROM t_CRetD 

SELECT * FROM t_ZInP  
SELECT * FROM t_Ret   
SELECT * FROM t_CRRet 
SELECT * FROM t_Rec   
SELECT * FROM t_Exc   
SELECT * FROM t_Est   
SELECT * FROM t_Ven   
SELECT * FROM t_Acc   
SELECT * FROM t_SRec  
SELECT * FROM t_SExp  
SELECT * FROM t_Inv   
SELECT * FROM t_Exp   
SELECT * FROM t_Epp   
SELECT * FROM t_Sale  
SELECT * FROM t_CRet  

SELECT TOP 1 * FROM t_ZInP  
SELECT TOP 1 * FROM t_Ret   
SELECT TOP 1 * FROM t_CRRet 
SELECT TOP 1 * FROM t_Rec   
SELECT TOP 1 * FROM t_Exc   
SELECT TOP 1 * FROM t_Est   
SELECT TOP 1 * FROM t_Ven   
SELECT TOP 1 * FROM t_Acc   
SELECT TOP 1 * FROM t_SRec  
SELECT TOP 1 * FROM t_SExp  
SELECT TOP 1 * FROM t_Inv   
SELECT TOP 1 * FROM t_Exp   
SELECT TOP 1 * FROM t_Epp   
SELECT (SELECT COUNT(DocDate) FROM t_Sale f), COUNT(DocDate) FROM t_Sale WHERE DocDate > '2017-01-01'  --1259827 -- 735264
SELECT TOP 1 * FROM t_CRet  


SELECT (SELECT COUNT(DocDate) FROM t_Ret    f)/ COUNT(DocDate) t_Ret   FROM t_Ret    WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_CRRet  f)/ COUNT(DocDate) t_CRRet FROM t_CRRet  WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_Rec    f)/ COUNT(DocDate) t_Rec   FROM t_Rec    WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_Exc    f)/ COUNT(DocDate) t_Exc   FROM t_Exc    WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_Est    f)/ COUNT(DocDate) t_Est   FROM t_Est    WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_Ven    f)/ COUNT(DocDate) t_Ven   FROM t_Ven    WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_Acc    f)/ COUNT(DocDate) t_Acc   FROM t_Acc    WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_SRec   f)/ COUNT(DocDate) t_SRec  FROM t_SRec   WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_SExp   f)/ COUNT(DocDate) t_SExp  FROM t_SExp   WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_Inv    f)/ COUNT(DocDate) t_Inv   FROM t_Inv    WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_Exp    f)/ COUNT(DocDate) t_Exp   FROM t_Exp    WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_Epp    f)/ COUNT(DocDate) t_Epp   FROM t_Epp    WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_Sale   f)/ COUNT(DocDate) t_Sale  FROM t_Sale   WHERE DocDate > '2017-01-01'
SELECT (SELECT COUNT(DocDate) FROM t_CRet   f)/ COUNT(DocDate) t_CRet  FROM t_CRet   WHERE DocDate > '2017-01-01'

select  [dbo].[af_CalcRemTotalD_F]('2017-10-30',  6, 1201,  1,  600001)