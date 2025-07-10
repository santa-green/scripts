
SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdMQ
except
SELECT * FROM dbo.r_ProdMQ
except
SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdMQ


DISABLE TRIGGER ALL ON dbo.r_ProdMQ; 

delete dbo.r_ProdMQ
WHERE ProdID = 604221 and BarCode = '@@@48209731';
delete dbo.r_ProdMQ
WHERE ProdID = 802729 and BarCode = '0766031306558';
delete dbo.r_ProdMQ
WHERE ProdID = 802731 and BarCode = '0766031101221';
delete dbo.r_ProdMQ
WHERE ProdID = 802732 and BarCode = '0766031101269';

ENABLE  TRIGGER ALL ON dbo.r_ProdMQ;