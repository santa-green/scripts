SELECT r.ProdID,r.BarCode,r.ProdBarCode, r.UM, d.UM d,s2.UM s2, s3.UM s3,s4.UM s4,s5.UM s5 ,s6.UM s6,s7.UM s7,s8.UM s8  FROM  r_ProdMQ	r
join [S-MARKETA].ElitV_DP.dbo.r_ProdMQ d on d.prodid = r.ProdID and d.barcode = r.BarCode
join [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ s2 on s2.prodid = r.ProdID and s2.barcode = r.BarCode
join [S-MARKETA3].ElitRTS301.dbo.r_ProdMQ s3 on s3.prodid = r.ProdID and s3.barcode = r.BarCode
join [S-MARKETA4].ElitRTS181.dbo.r_ProdMQ s4 on s4.prodid = r.ProdID and s4.barcode = r.BarCode
join [192.168.22.21].ElitRTS401.dbo.r_ProdMQ s5 on s5.prodid = r.ProdID and s5.barcode = r.BarCode
join [192.168.174.30].ElitRTS201.dbo.r_ProdMQ s6 on s6.prodid = r.ProdID and s6.barcode = r.BarCode
join [192.168.157.22].ElitRTS302.dbo.r_ProdMQ s7 on s7.prodid = r.ProdID and s7.barcode = r.BarCode
join [192.168.174.38].ElitRTS220.dbo.r_ProdMQ s8 on s8.prodid = r.ProdID and s8.barcode = r.BarCode
where r.UM <> d.UM or r.UM <> s2.UM or r.UM <> s3.UM or r.UM <> s4.UM or r.UM <> s5.UM or r.UM <> s6.UM or r.UM <> s7.UM or r.UM <> s8.UM
ORDER BY r.ProdID




SELECT * FROM r_ProdMQ
WHERE ProdID = 600672
ORDER BY 1

SELECT * FROM [S-MARKETA].ElitV_DP.dbo.r_ProdMQ
WHERE ProdID = 600672 and BarCode = '600672'
ORDER BY 1


delete [S-MARKETA].ElitV_DP.dbo.r_ProdMQ
WHERE ProdID = 600672 and BarCode = '600672'

delete [S-MARKETA].ElitV_DP.dbo.r_ProdMQ
WHERE ProdID = 604221 and BarCode = '@@@48209731'

SELECT * FROM  [S-MARKETA].ElitV_DP.dbo.r_ProdMQ
WHERE ProdID = 604221 and BarCode = '@@@48209731'

delete [S-MARKETA].ElitV_DP.dbo.r_ProdMQ
WHERE ProdID = 802729 and BarCode = '0766031306558'

delete [S-MARKETA].ElitV_DP.dbo.r_ProdMQ
WHERE ProdID = 802731 and BarCode = '0766031101221'

delete [S-MARKETA].ElitV_DP.dbo.r_ProdMQ
WHERE ProdID = 802732 and BarCode = '0766031101269'


SELECT * FROM [S-MARKETA].ElitV_DP.dbo.t_VenD_UM where DetProdID = 604221 and DetUM = 'пак_20'


BEGIN TRAN
set XACT_ABORT on 

SELECT * FROM [S-MARKETA].ElitV_DP.dbo.t_VenD_UM where DetProdID = 604221

SELECT * FROM [S-MARKETA].ElitV_DP.dbo.r_ProdMQ where ProdID = 604221

update [S-MARKETA].ElitV_DP.dbo.t_VenD_UM 
set DetUM = 'пак_2'
where DetProdID = 604221 and DetUM = 'пак_20'

SELECT * FROM [S-MARKETA].ElitV_DP.dbo.t_VenD_UM where DetProdID = 604221

ROLLBACK TRAN




SELECT * FROM z_ReplicaEvents where TableCode= 10350004
and PKValue like '601392%'
ORDER BY ReplicaEventID desc



--SELECT * FROM dbo.r_ProdMQ
--except
SELECT * FROM [S-MARKETA].ElitV_DP.dbo.r_ProdMQ
except
SELECT * FROM dbo.r_ProdMQ

SELECT * FROM [S-MARKETA].ElitV_DP.dbo.r_ProdMQ

SELECT * FROM dbo.r_ProdMQ


SELECT * FROM [S-MARKETA3].ElitRTS301.dbo.r_ProdMQ
except
SELECT * FROM dbo.r_ProdMQ
except
SELECT * FROM [S-MARKETA3].ElitRTS301.dbo.r_ProdMQ


delete [S-MARKETA3].ElitRTS301.dbo.r_ProdMQ
WHERE ProdID = 604221 and BarCode = '@@@48209731'



SELECT * FROM [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ
except
SELECT * FROM dbo.r_ProdMQ
except
SELECT * FROM [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ


DISABLE TRIGGER ALL ON [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ; 

delete [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ
WHERE ProdID = 604221 and BarCode = '@@@48209731';
delete [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ
WHERE ProdID = 802729 and BarCode = '0766031306558';
delete [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ
WHERE ProdID = 802731 and BarCode = '0766031101221';
delete [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ
WHERE ProdID = 802732 and BarCode = '0766031101269';

ENABLE  TRIGGER ALL ON [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ;



delete [S-MARKETA2].ElitV_KIEV.dbo.r_ProdMQ
WHERE ProdID = 604221 and BarCode = '@@@48209731'






--список связанных серверов
SELECT * FROM sys.servers where name in 
(
'S-SQL-D4','CP1_DP','S-MARKETA','S-MARKETA2','S-MARKETA3','S-MARKETA4','192.168.22.21','192.168.157.22','192.168.174.38','192.168.174.30','192.168.174.31'
)