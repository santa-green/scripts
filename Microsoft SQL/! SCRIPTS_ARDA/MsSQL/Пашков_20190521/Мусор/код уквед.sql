select ProdID, min(CstProdCode) as CstProdCode from t_PInP

group by ProdID


except

select ProdID, min(CstProdCode) as CstProdCode from t_PInP
where CstProdCode > '0'
group by ProdID
--HAVING CstProdCode >0
order by CstProdCode

