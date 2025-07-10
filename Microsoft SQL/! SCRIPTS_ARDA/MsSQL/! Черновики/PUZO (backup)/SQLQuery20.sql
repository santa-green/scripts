SELECT inv.ChID FROM t_Inv inv  
           JOIN r_Comps co ON inv.CompID=co.CompID  
           WHERE 1 = 1
            --AND co.CodeID2 = 810
            AND co.compid in (61480, 73385, 73388)
            AND DocDate >= '20210101'
            AND inv.ChID NOT IN (select ChID from at_SendXML where ChID = inv.ChID)
            GROUP BY inv.ChID

            SELECT * FROM at_SendXML m ORDER BY m.DateCreate DESC
            SELECT * FROM at_SendXML m WHERE ChID = 200460990
            
            begin tran
            SELECT * FROM at_SendXML m WHERE ChID IN (200460990, 200460991, 200460942, 200460953, 200460950)
            delete FROM at_SendXML WHERE ChID IN (200460990, 200460991, 200460942, 200460953, 200460950)
            SELECT * FROM at_SendXML m WHERE ChID IN (200460990, 200460991, 200460942, 200460953, 200460950)
            rollback tran
            
            SELECT CompID, * FROM t_Inv WHERE ChID = 200460991
            
