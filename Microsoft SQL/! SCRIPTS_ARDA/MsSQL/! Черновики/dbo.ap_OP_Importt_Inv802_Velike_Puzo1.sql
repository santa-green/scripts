USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_OP_Importt_Inv802_Velike_Puzo]    Script Date: 18.01.2021 0:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ap_OP_Import_inv_Velike_Puzo] AS 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT inv.ChID FROM t_Inv inv  
           JOIN r_Comps co ON inv.CompID=co.CompID  
           WHERE 1 = 1
            --AND co.CodeID2 = 810 --нужно только для 61480, 73385, 73388.
            AND co.compid in (61480, 73385, 73388)
            AND DocDate >= '20210101'
            AND inv.ChID NOT IN (select ChID from at_SendXML where ChID = inv.ChID)
            GROUP BY inv.ChID)

BEGIN
 
BEGIN TRAN

DECLARE @ChId INT;

DECLARE Cursor_PUZO CURSOR LOCAL FAST_FORWARD FOR 
    SELECT inv.ChID FROM t_Inv inv WITH(NOLOCK) 
    JOIN r_Comps co ON inv.CompID=co.CompID  
    WHERE 
    --AND co.CodeID2 = 810 --нужно только для 61480, 73385, 73388.
    co.compid in (61480, 73385, 73388)
    AND DocDate >= '20210101'
    AND inv.ChID NOT IN (select ChID from at_SendXML where ChID = inv.ChID)
    GROUP BY inv.ChID;    
                
OPEN Cursor_PUZO; 
FETCH NEXT FROM Cursor_PUZO INTO @ChId;
   
    WHILE @@FETCH_STATUS = 0
        BEGIN 
            
            DECLARE @xml XML, @token INT; 
            EXEC [ap_EXITE_ExportDoc] @DocType='COMDOC_PUZO', @DocCode = 11012, @ChID = @ChId,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT; 
            SELECT @token 'Token', @xml 'XML';
          
            INSERT at_SendXML (ChID, DateCreate, xml)
            SELECT @ChId, GETDATE(), @xml xml
            SELECT * FROM at_SendXML m ORDER BY m.DateCreate DESC
            FETCH NEXT FROM Cursor_PUZO INTO @ChID

        END; 
   
   CLOSE Cursor_PUZO;
   DEALLOCATE Cursor_PUZO;
   
   IF @@TRANCOUNT > 0 COMMIT;

END;


END;

GO
