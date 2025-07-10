--Список перенастроек при переезде магазина
/*
1. справочник ЭККА 
поменять склад с 1260 на 1245 на кассах 302
*/

/*
2. Менеджер доступа
на пользователе 302 доступный склад заменить с 1260 на 1245
*/

/*  
3. добавить в [192.168.157.22].ElitRTS302.dbo.[t_SaleAfterClose] строку WHEN m.StockID IN (1245) THEN 95 --харьков пр.Науки,15
   добавить в [192.168.157.22].ElitRTS302.dbo.[t_SaleRetAfterClose] строку WHEN m.StockID IN (1245) THEN 95 --харьков пр.Науки,15
  
  /* Установка признаков документа */
  IF (SELECT COUNT(*) 
      FROM t_Sale m WITH(NOLOCK)
      JOIN t_SalePays p WITH(NOLOCK) ON p.ChID = m.ChID AND m.ChID = @ChID
      WHERE p.Notes NOT LIKE 'Сдача') = 1
        UPDATE m
	    SET m.CodeID1 = 63, 
	        m.CodeID2 = 18, 
	        m.CodeID3 = CASE p.PayFormCode WHEN 1 THEN (CASE WHEN m.StockID IN (1201,1202,1315) THEN 81 
		         									         WHEN m.StockID IN (1257) THEN 73
		         									         WHEN m.StockID IN (1245) THEN 95 --харьков пр.Науки,15
		         									         WHEN m.StockID IN (1221,1222) THEN 82
		         									         WHEN m.StockID IN (1241) THEN 93
		         									         WHEN m.StockID IN (1243) THEN 94 -- киев генерала вататина 2т
		         									         WHEN m.StockID IN (1252) THEN 78
		         									         WHEN m.StockID IN (723) THEN 91
		         									         WHEN m.StockID IN (1001) THEN 75
													         WHEN m.StockID IN (1310,1314) THEN 84 END)    
	    							       WHEN 2 THEN 27 WHEN 5 THEN 70 ELSE 0 END


  /* Установка признаков документа */
  IF (SELECT COUNT(*) 
      FROM t_CRRet m WITH(NOLOCK)
	  JOIN t_CRRetPays p WITH(NOLOCK) ON p.ChID = m.ChID AND m.ChID = @ChID
	  WHERE p.Notes NOT LIKE 'Сдача') = 1
    UPDATE m 
	   SET m.CodeID1 = 63,
	       m.CodeID2 = 19,
	       --m.CodeID3 = CASE p.PayFormCode WHEN 1 THEN 73 -- изменить для нового магазина
	       m.CodeID3 = CASE p.PayFormCode WHEN 1 THEN (CASE WHEN m.StockID IN (1201,1202,1315) THEN 81 
		         									         WHEN m.StockID IN (1257) THEN 73
		         									         WHEN m.StockID IN (1245) THEN 95 --харьков пр.Науки,15
		         									         WHEN m.StockID IN (1221,1222) THEN 82
		         									         WHEN m.StockID IN (1241) THEN 93
		         									         WHEN m.StockID IN (1243) THEN 94 -- киев генерала вататина 2т
		         									         WHEN m.StockID IN (1252) THEN 78
		         									         WHEN m.StockID IN (723) THEN 91
		         									         WHEN m.StockID IN (1001) THEN 75
													         WHEN m.StockID IN (1310,1314) THEN 84 END)    
	    							       WHEN 2 THEN 27 WHEN 5 THEN 70 ELSE 0 END

	    							       
*/
/*
4. Справочник складов
на складе 1245 уставновить прайс 86
*/
/*
5. Менеджер акций
добавить склад 1245 в те акции где есть склад 1260
*/
/*
6. Отчет: Новые ценники на утро
заменить в инструменте склад 1260 на 1245
*/
/*
7. Для процедур 
заменить в объектах склад 1260 на 1245
*/
/*
8. Отчет: Новые ценники на утро
заменить в объектах склад 1260 на 1245 и добавить групу 2709
[192.168.157.22].ElitRTS302.dbo.[a_tRem_CheckNegativeRems_IU]
[a_tRem_CheckNegativeRems_IU]
*/
