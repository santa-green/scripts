SELECT DocCode,TableDesc FROM z_Tables
WHERE TableDesc like('%����������%')
ORDER BY 2

SELECT * FROM z_AppPrints -- ������

SELECT * FROM vz_AppDocs --���������
WHERE AppName in ('������') /*AND DocName NOT LIKE ('%����������%')*/ AND DocCatCode = 1 OR DocName LIKE ('%���������������%')
ORDER BY DocName

SELECT * FROM vz_AppDocs --������
WHERE AppName in ('������') AND DocCatCode = 4  OR DocName LIKE ('%�������%')
ORDER BY DocName

--43-44

SELECT * FROM vz_AppDocs --�������
WHERE AppName in ('������') AND DocName LIKE ('%������%')
ORDER BY DocName