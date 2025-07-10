SELECT ChID as z_DocDC FROM [192.168.157.22].ElitRTS302.dbo.z_DocDC except SELECT ChID FROM z_DocDC order by 1
SELECT ChID as z_LogDiscRec FROM [192.168.157.22].ElitRTS302.dbo.z_LogDiscRec except SELECT ChID FROM z_LogDiscRec order by 1
SELECT ChID as z_LogDiscExp FROM [192.168.157.22].ElitRTS302.dbo.z_LogDiscExp except SELECT ChID FROM z_LogDiscExp order by 1
--SELECT ChID as t_CRRet FROM [192.168.157.22].ElitRTS302.dbo.t_CRRet except SELECT ChID FROM t_CRRet order by 1
--SELECT ChID as t_CRRetD FROM [192.168.157.22].ElitRTS302.dbo.t_CRRetD except SELECT ChID FROM t_CRRetD order by 1
--SELECT ChID as t_CRRetPays FROM [192.168.157.22].ElitRTS302.dbo.t_CRRetPays except SELECT ChID FROM t_CRRetPays order by 1
--SELECT ChID as t_CRRetDLV FROM [192.168.157.22].ElitRTS302.dbo.t_CRRetDLV except SELECT ChID FROM t_CRRetDLV order by 1
SELECT ChID as t_MonRec FROM [192.168.157.22].ElitRTS302.dbo.t_MonRec except SELECT ChID FROM t_MonRec order by 1
SELECT ChID as t_Sale FROM [192.168.157.22].ElitRTS302.dbo.t_Sale except SELECT ChID FROM t_Sale order by 1
SELECT ChID as t_SaleD FROM [192.168.157.22].ElitRTS302.dbo.t_SaleD except SELECT ChID FROM t_SaleD order by 1
--SELECT ChID as t_SaleC FROM [192.168.157.22].ElitRTS302.dbo.t_SaleC except SELECT ChID FROM t_SaleC order by 1
SELECT ChID as t_SalePays FROM [192.168.157.22].ElitRTS302.dbo.t_SalePays except SELECT ChID FROM t_SalePays order by 1
SELECT ChID as t_SaleDLV FROM [192.168.157.22].ElitRTS302.dbo.t_SaleDLV except SELECT ChID FROM t_SaleDLV order by 1
--SELECT ChID as t_MonIntRec FROM [192.168.157.22].ElitRTS302.dbo.t_MonIntRec except SELECT ChID FROM t_MonIntRec order by 1
--SELECT ChID as t_MonIntExp FROM [192.168.157.22].ElitRTS302.dbo.t_MonIntExp except SELECT ChID FROM t_MonIntExp order by 1
--SELECT ChID as t_zRep FROM [192.168.157.22].ElitRTS302.dbo.t_zRep except SELECT ChID FROM t_zRep order by 1


 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_DocDC where ChID not in ( SELECT ChID FROM z_DocDC) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_LogDiscRec where ChID not in ( SELECT ChID FROM z_LogDiscRec) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_LogDiscExp where ChID not in ( SELECT ChID FROM z_LogDiscExp) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_CRRet where ChID not in ( SELECT ChID FROM t_CRRet) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_CRRetD where ChID not in ( SELECT ChID FROM t_CRRetD) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_CRRetPays where ChID not in ( SELECT ChID FROM t_CRRetPays) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_CRRetDLV where ChID not in ( SELECT ChID FROM t_CRRetDLV) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_MonRec where ChID not in ( SELECT ChID FROM t_MonRec) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_Sale where ChID not in ( SELECT ChID FROM t_Sale) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_SaleD where ChID not in ( SELECT ChID FROM t_SaleD) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_SaleC where ChID not in ( SELECT ChID FROM t_SaleC) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_SalePays where ChID not in ( SELECT ChID FROM t_SalePays) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_SaleDLV where ChID not in ( SELECT ChID FROM t_SaleDLV) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_MonIntRec where ChID not in ( SELECT ChID FROM t_MonIntRec) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_MonIntExp where ChID not in ( SELECT ChID FROM t_MonIntExp) and ChID < 1100000650 order by 1
 SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_zRep where ChID not in ( SELECT ChID FROM t_zRep) and ChID < 1100000650 order by 1


SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_DocDC where ChID not in (SELECT ChID FROM z_DocDC) order by 1
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_LogDiscRec except SELECT ChID FROM z_LogDiscRec order by 1
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.z_LogDiscExp except SELECT ChID FROM z_LogDiscExp order by 1
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_MonRec except SELECT ChID FROM t_MonRec order by 1
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_Sale except SELECT ChID FROM t_Sale order by 1
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_SaleD except SELECT ChID FROM t_SaleD order by 1
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_SalePays except SELECT ChID FROM t_SalePays order by 1
SELECT * FROM [192.168.157.22].ElitRTS302.dbo.t_SaleDLV except SELECT ChID FROM t_SaleDLV order by 1



BEGIN TRAN

INSERT t_Sale       SELECT *  FROM [192.168.157.22].ElitRTS302.dbo.t_Sale       where ChID not in ( SELECT ChID FROM t_Sale      ) and ChID < 1100000650 order by 1
INSERT t_SaleD      SELECT *  FROM [192.168.157.22].ElitRTS302.dbo.t_SaleD      where ChID not in ( SELECT ChID FROM t_SaleD     ) and ChID < 1100000650 order by 1
INSERT t_SalePays   SELECT *  FROM [192.168.157.22].ElitRTS302.dbo.t_SalePays   where ChID not in ( SELECT ChID FROM t_SalePays  ) and ChID < 1100000650 order by 1
INSERT t_SaleDLV    SELECT *  FROM [192.168.157.22].ElitRTS302.dbo.t_SaleDLV    where ChID not in ( SELECT ChID FROM t_SaleDLV   ) and ChID < 1100000650 order by 1
INSERT z_DocDC      SELECT *  FROM [192.168.157.22].ElitRTS302.dbo.z_DocDC      where ChID not in ( SELECT ChID FROM z_DocDC     ) and ChID < 1100000650 order by 1
INSERT z_LogDiscRec SELECT *  FROM [192.168.157.22].ElitRTS302.dbo.z_LogDiscRec where ChID not in ( SELECT ChID FROM z_LogDiscRec) and ChID < 1100000650 order by 1
INSERT z_LogDiscExp SELECT *  FROM [192.168.157.22].ElitRTS302.dbo.z_LogDiscExp where ChID not in ( SELECT ChID FROM z_LogDiscExp) and ChID < 1100000650 order by 1
INSERT t_MonRec     SELECT *  FROM [192.168.157.22].ElitRTS302.dbo.t_MonRec     where ChID not in ( SELECT ChID FROM t_MonRec    ) and ChID < 1100000650 order by 1

ROLLBACK TRAN