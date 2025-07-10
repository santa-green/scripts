SELECT * FROM af_GetTableInfo('r_DCTypes')
SELECT DCTypeCode, DCTypeName FROM r_DCTypes WHERE DCTypeCode in (3, 4, 5, 6, 35, 36, 37) ORDER BY 1
select * from r_DCards where DCTypeCode = 2
select len('2230000002911')
SELECT * FROM r_ProdMQ WHERE ProdID = 601283 and BarCode = '2260000003403'