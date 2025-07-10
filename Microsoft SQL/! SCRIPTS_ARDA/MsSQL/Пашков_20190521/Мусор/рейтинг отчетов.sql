SELECT * FROM z_LogPrint where FileName like '%ттн%'
ORDER BY 2 desc

SELECT FileName, COUNT(FileName) количесто FROM z_LogPrint 
where FileName like '%ттн%'
and DocDate > '2017-01-01'
group by FileName
ORDER BY 2 desc


SELECT SrcPosID N, cast(BarCode as varchar(20)) Штрихкод, Qty Кол FROM it_TSD_UnknBarCodes

