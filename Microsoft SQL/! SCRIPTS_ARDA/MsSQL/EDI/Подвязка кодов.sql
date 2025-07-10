SELECT * FROM r_ProdEC WHERE compid in (7001,7003) AND ExtProdID = '381341'
SELECT * FROM r_ProdEC WHERE compid in (7001,7003) AND ProdID = 32144
SELECT * FROM r_ProdEC WHERE compid in (7001,7003) AND ProdID = 32318


--TRAN
BEGIN TRAN
    SELECT COUNT(*) 'INITIAL...' FROM r_ProdEC --контроль
    
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*insert block*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --SELECT 'START' 'START',* FROM r_ProdEC WHERE compid in (7001,7003) AND ProdID = 32318
    --INSERT INTO r_ProdEC (ProdID, CompID, ExtProdID) VALUES (32318, 7003,'409378')
    --SELECT 'INSERTED' 'INSERTED',* FROM r_ProdEC WHERE compid in (7001,7003) AND ProdID = 32318

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*delete block*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --SELECT 'DELETED' 'DELETED',* FROM r_ProdEC WHERE compid in (7001,7003) AND ProdID = 32318
    --DELETE FROM r_ProdEC WHERE compid in (7001,7003) AND ProdID = 32318
    --SELECT 'FINAL' 'FINAL',* FROM r_ProdEC WHERE compid in (7001,7003) AND ProdID = 32318

    SELECT COUNT(*) 'FINAL.' FROM r_ProdEC --контроль
ROLLBACK TRAN


