SELECT DocCode,TableDesc FROM z_Tables
WHERE TableDesc like('%Справочник%')
ORDER BY 2

SELECT * FROM z_AppPrints -- Отчеты

SELECT * FROM vz_AppDocs --Документы
WHERE AppName in ('Бизнес') /*AND DocName NOT LIKE ('%Справочник%')*/ AND DocCatCode = 1 OR DocName LIKE ('%Калькуляционная%')
ORDER BY DocName

SELECT * FROM vz_AppDocs --Прочее
WHERE AppName in ('Бизнес') AND DocCatCode = 4  OR DocName LIKE ('%Договор%')
ORDER BY DocName

--43-44

SELECT * FROM vz_AppDocs --Реестры
WHERE AppName in ('Бизнес') AND DocName LIKE ('%Реестр%')
ORDER BY DocName