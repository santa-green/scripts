
select * from t_Exp where DocID in (4049,4050,4051,4052,4054)  

select * from t_Exp where ChID in (select ChID from t_Exp where DocID in (4049,4050,4051,4052,4054)  )

select * from t_ExpD where ChID in (select ChID from t_Exp where DocID in (4049,4050,4051,4052,4054)  )

select * from [s-marketa].elitv_dp.dbo.t_Exp where ChID in (select ChID from t_Exp where DocID in (4049,4050,4051,4052,4054)  )

select * from [s-marketa].elitv_dp.dbo.t_ExpD where ChID in (select ChID from t_Exp where DocID in (4049,4050,4051,4052,4054)  )



--залить –асходный документ  в локалку днепра
--insert [s-marketa].elitv_dp.dbo.t_Exp
    select * from t_Exp where ChID in (select ChID from t_Exp where DocID in (4049,4050,4051,4052,4054)  )
    
--insert [s-marketa].elitv_dp.dbo.t_ExpD  
    select * from t_ExpD where ChID in (select ChID from t_Exp where DocID in (4049,4050,4051,4052,4054)  )
    