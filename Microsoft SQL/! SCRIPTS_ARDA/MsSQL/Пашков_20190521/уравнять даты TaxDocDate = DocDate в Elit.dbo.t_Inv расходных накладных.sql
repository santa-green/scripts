--уравнять даты TaxDocDate = DocDate в Elit.dbo.t_Inv расходных накладных 

begin tran


SELECT SrcDocID, DocDate, TaxDocDate, * FROM [S-SQL-D4].Elit.dbo.t_Inv  WHERE OurID IN (1,3,11) AND  CompID = 10791 and DocDate <> TaxDocDate 

   UPDATE [S-SQL-D4].Elit.dbo.t_Inv 
    SET TaxDocDate = DocDate
    WHERE  OurID IN (1,3,11) AND  CompID = 10791 and DocDate <> TaxDocDate 
    
SELECT SrcDocID, DocDate, TaxDocDate, * FROM [S-SQL-D4].Elit.dbo.t_Inv  WHERE OurID IN (1,3,11) AND  CompID = 10791 and DocDate <> TaxDocDate   


rollback tran