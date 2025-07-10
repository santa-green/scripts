
SELECT tYear*100+tMonth,geoid,artid,sum(SalesQty) TSalesQty FROM dbo.DATA
--group by tYear,tMonth,geoid,artid
--11599748
--11650006

SELECT tYear_tMonth,geoid,artid,sum(SalesQty) TSalesQty  FROM (
SELECT top 100000 tYear*100+tMonth tYear_tMonth,geoid,artid,SalesQty,BPrice,SPrice FROM dbo.DATA
)gr
group by tYear_tMonth,geoid,artid

SELECT * into Data_group FROM  [dbo].[v_Data_group]
 
SELECT count(*) FROM  DATA
SELECT sum(SalesQty) FROM  DATA

--11599748
SELECT count(*) FROM  dbo.Data_group
SELECT sum(SalesQty) FROM  dbo.Data_group


--KOD,tYear,tMonth,geoid,artid,SalesQty,BPrice,SPrice
