USE ElitR
--опеделить ChID
select * from t_Exc where DocID = 100015704 


--вставить ChID
DECLARE @ChID INT = 100028708

select * from t_Exc where DocID = @ChID  

select * from t_Exc where ChID = @ChID

select * from t_ExcD where ChID = @ChID

select * from [s-marketa].elitv_dp.dbo.t_Exc where ChID = @ChID

select * from [s-marketa].elitv_dp.dbo.t_ExcD where ChID = @ChID


select * from [s-marketa2].elitv_kiev.dbo.t_Exc where ChID = @ChID

select * from [s-marketa2].elitv_kiev.dbo.t_ExcD where ChID = @ChID


--залить перемещение в  иев  
--insert [s-marketa2].elitv_kiev.dbo.t_Exc 
    select * from t_Exc where ChID = @ChID
    
--insert [s-marketa2].elitv_kiev.dbo.t_ExcD 
    select * from t_ExcD where ChID = @ChID
    
