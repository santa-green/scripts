SELECT * FROM z_LogPrint where FileName like '%���%'
ORDER BY 2 desc

SELECT FileName, COUNT(FileName) ��������� FROM z_LogPrint 
where FileName like '%���%'
and DocDate > '2017-01-01'
group by FileName
ORDER BY 2 desc


SELECT SrcPosID N, cast(BarCode as varchar(20)) ��������, Qty ��� FROM it_TSD_UnknBarCodes

