/*
SELECT * FROM r_CompGrs2

SELECT * FROM z_Tables ORDER BY 3;
*/

SELECT DISTINCT at_r_Discs_1.DiscCode, at_r_Discs_1.DiscName
	  ,at_r_Discs_1.BDate, at_r_Discs_1.EDate
	  ,r_Prods_8.ProdID, r_Prods_8.ProdName
	  ,at_r_ProdMDP_6.Discount, 0 PriceMC25, dbo.afx_CorrectPriceForTax(r_ProdMP_9.PriceMC * (1.00 - at_r_ProdMDP_6.Discount / 100.00) * 28.00, 20.00) DiscPriceCC
	  ,r_CompGrs2_13.CompGrName2 CompGrName2
FROM at_r_Discs at_r_Discs_1 WITH(NOLOCK)
LEFT JOIN at_r_DiscComps at_r_DiscComps_2 WITH(NOLOCK) ON (at_r_DiscComps_2.DiscCode=at_r_Discs_1.DiscCode)
JOIN at_r_DiscPLMaps at_r_DiscPLMaps_3 WITH(NOLOCK) ON (at_r_DiscPLMaps_3.DiscCode=at_r_Discs_1.DiscCode)
JOIN at_r_DiscPls at_r_DiscPls_4 WITH(NOLOCK) ON (at_r_DiscPls_4.DiscPLID=at_r_DiscPLMaps_3.DiscPLID)
JOIN at_r_ProdMDP at_r_ProdMDP_6 WITH(NOLOCK) ON (at_r_ProdMDP_6.DiscPLID=at_r_DiscPls_4.DiscPLID)
JOIN r_PLs r_PLs_5 WITH(NOLOCK) ON (r_PLs_5.PLID=at_r_DiscPls_4.PLID)
JOIN r_Prods r_Prods_8 WITH(NOLOCK) ON (r_Prods_8.ProdID=at_r_ProdMDP_6.ProdID)
JOIN r_ProdBG r_ProdBG_12 WITH(NOLOCK) ON (r_ProdBG_12.PBGrID=r_Prods_8.PBGrID)
JOIN r_ProdC r_ProdC_11 WITH(NOLOCK) ON (r_ProdC_11.PCatID=r_Prods_8.PCatID)
JOIN r_ProdG r_ProdG_10 WITH(NOLOCK) ON (r_ProdG_10.PGrID=r_Prods_8.PGrID)
JOIN r_ProdMP r_ProdMP_9 WITH(NOLOCK) ON (r_ProdMP_9.ProdID=r_Prods_8.ProdID AND r_ProdMP_9.PLID=r_PLs_5.PLID)
LEFT JOIN r_Comps r_Comps_7 WITH(NOLOCK) ON (r_Comps_7.CompID=at_r_DiscComps_2.CompID)
JOIN r_CompGrs2 r_CompGrs2_13 WITH(NOLOCK) ON (r_CompGrs2_13.CompGrID2=r_Comps_7.CompGrID2)
  WHERE  (at_r_DiscComps_2.Active = 1)
     AND (at_r_Discs_1.DiscCode = 210)
	 AND (at_r_Discs_1.StateCode = 181)
	 AND (r_Prods_8.ProdID = 1010)
	 AND (CAST('20190502' as smalldatetime) BETWEEN at_r_Discs_1.BDate AND at_r_Discs_1.EDate
	 AND r_Prods_8.PGrID1 BETWEEN at_r_DiscPLMaps_3.PGrID1_B AND at_r_DiscPLMaps_3.PGrID1_E)


--INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=G:\testing.xlsx;', 'SELECT * FROM [Лист1$]')
INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=\\s-sql-d4\OT38ElitServer\Import\Discounts\Dnepr.xlsx;', 'SELECT * FROM [Данные$]')
--INSERT INTO OPENROWSET('Microsoft.Jet.OLEDB.4.0', 'Excel 5.0;IMEX=0;Database=\\s-sql-d4\OT38ElitServer\Import\Discounts\Dnepr.xls;', 'SELECT * FROM [SQL$]')
SELECT DISTINCT
	   m.DiscCode, m.DiscName
	  ,CONVERT(VARCHAR(20),m.BDate,23), CONVERT(VARCHAR(20), m.EDate,23)
	  ,rc.CompID, rc.CompName
	  --,rp.PGrID1
	  --,rp.ProdID, rp.ProdName
	  --,REPLACE(CAST( CAST(ROUND(arpmdp.Discount,2) AS FLOAT) AS VARCHAR(100)),'.',',') Discount
	  --, (SELECT REPLACE(CAST( CAST(ROUND(rpmp1.PriceMC*rc.KursMC, 2) AS FLOAT) AS VARCHAR(100)),'.',',')
				--FROM r_ProdMP rpmp1 JOIN r_Currs rc WITH(NOLOCK) ON rc.CurrID = 2 WHERE rpmp1.PLID = 25 AND rpmp1.ProdID = rp.ProdID) PriceMC25
	  --,REPLACE(CAST( CAST(dbo.afx_CorrectPriceForTax(rpmp.PriceMC * (1.00 - arpmdp.Discount / 100.00) * 28.00, 20.00) AS FLOAT) AS VARCHAR(100) ),'.',',') DiscPriceCC
FROM at_r_Discs m
LEFT JOIN at_r_DiscComps ardc WITH(NOLOCK) ON ardc.DiscCode = m.DiscCode
LEFT JOIN r_Comps rc WITH(NOLOCK) ON rc.CompID = ardc.CompID
--JOIN at_r_DiscPLMaps ardm WITH(NOLOCK) ON ardm.DiscCode = m.DiscCode
--JOIN at_r_DiscPls ardp WITH(NOLOCK) ON ardp.DiscPLID = ardm.DiscPLID
--JOIN at_r_ProdMDP arpmdp WITH(NOLOCK) ON arpmdp.DiscPLID = ardp.DiscPLID
--JOIN r_PLs rpl WITH(NOLOCK) ON rpl.PLID = ardp.PLID
--JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = arpmdp.ProdID
--JOIN r_ProdMP rpmp WITH(NOLOCK) ON rpmp.ProdID = rp.ProdID AND rpmp.PLID = rpl.PLID
WHERE ardc.Active = 1	--Фильтр активной акции.
  AND m.StateCode = 181	--181 - акция активна; 182 - акция завершена;
  --AND rp.ProdID = 1010	--Для отладки и быстрой работы отчета можно взять один товар.
  --AND rp.PGrID1 BETWEEN ardm.PGrID1_B AND ardm.PGrID1_E --Без понятия зачем этот фильтр. Он просто был в запросе отчета.
  AND GETDATE() BETWEEN m.BDate AND m.EDate	--Если акция работает прямо сейчас.
  AND (MONTH(GETDATE()) = MONTH(m.EDate) OR MONTH(GETDATE()) + 1 = MONTH(m.EDate) )
  AND rc.CompGrID2 = 2031

SELECT MONTH(GETDATE()) + 1
/*
UPDATE  a    SET a.PriceMC25 =  (b.PriceMC * c.KursMC) FROM [AzTempDB].[CONST\maslov].[v_014_00922_1_CONST\maslov] a    --цена в доллар переводим в грн    
 LEFT JOIN r_ProdMP b ON a.ProdID = b.ProdID 
 LEFT JOIN r_Currs c ON c.CurrID = 2  --укр гривна
 WHERE b.PLID = 25
группа предприятий 2
Акция, Имя акции, Начальная дата, Конечная дата, Группа 1, Товар, Имя товара, "Скидка, %", Цена в ВС по ценам 25 прайс-листа, Цена ВС со скидкой




insert into OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=G:\testing.xlsx;', 'SELECT * FROM [Лист1$]') select top 10 ChID 'Тити', CompID, CompName, City from r_Comps

/*
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO


USE [master]
GO
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO

*/


/*
create procedure proc_generate_excel_with_columns
(*/
DECLARE @db_name    varchar(100),
    @table_name varchar(100),   
    @file_name  varchar(100) = 'G:\Sika_kek.xls'
/*
)
as
*/
--Generate column names as a recordset
declare @columns varchar(8000), @sql varchar(8000), @data_file varchar(100)
select 
    @columns=coalesce(@columns+',','')+column_name+' as '+column_name 
from 
    information_schema.columns
where 
    table_name='r_Comps'
	
select @columns=''''''+replace(replace(@columns,' as ',''''' as '),',',',''''')
SELECT @columns
--Create a dummy file to have actual data
select @data_file=substring(@file_name,1,len(@file_name)-charindex('\',reverse(@file_name)))+'\data_file.xls'

--select @data_file='G:\Sika_kek.xls'

--Generate column names in the passed EXCEL file
set @sql='exec master..xp_cmdshell ''bcp " select * from (select '+@columns+') as t" queryout "'+@file_name+'" -c -t'''
exec(@sql)

--Generate data in the dummy file
set @sql='exec master..xp_cmdshell ''bcp "select top 10 * from r_Comps" queryout "'+@data_file+'" -c -t'''
exec(@sql)

--Copy dummy file to passed EXCEL file
set @sql= 'exec master..xp_cmdshell ''type '+@data_file+' >> "'+@file_name+'"'''
exec(@sql)

--Delete dummy file 
set @sql= 'exec master..xp_cmdshell ''del '+@data_file+''''
exec(@sql)
*/