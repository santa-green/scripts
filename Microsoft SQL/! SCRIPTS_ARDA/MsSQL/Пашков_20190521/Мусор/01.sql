

SELECT * FROM z_Objects where ObjName like '%Rem%' ORDER BY 2


SELECT * FROM z_Docs where DocName like '%перео%'

[ip_SRecDSpecCalc] 
ip_SRecASpecCalcc
[ap_UpdatePromoPricesFrom_t_SEst]

ap_CalcSRec_B_date_E_date

SELECT MAX(DocID) FROM t_SEst WHERE OurID=6

aft_GetPriceCCCost
aft_GetPriceCCIn
af_IS_GetPriceCC
tf_GetRemTotal
tf_GetRem

SELECT * FROM r_Prods

SELECT SUM(Qty-AccQty) FROM  af_CalcRemD_F('2017-09-26', 6, 1201, 1, 802375)
SELECT  [dbo].[af_CalcRemTotalD_F] ('2017-09-26', 6, 1201, 1, 802375)
SELECT  [dbo].[af_CalcRemTotalD_F] ('2017-09-26', 6, 1201, 1, 800779)

SELECT SUM(Qty-AccQty) FROM t_Rem WITH(NOLOCK) WHERE OurID=6 AND ProdID=600135
SELECT * FROM t_Rem WITH(NOLOCK) WHERE OurID=6 AND ProdID=600135

SELECT * FROM r_Stocks where PLID = 28