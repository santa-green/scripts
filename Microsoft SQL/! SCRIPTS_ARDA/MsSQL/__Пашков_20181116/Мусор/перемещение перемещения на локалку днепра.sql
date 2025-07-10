select * from [s-marketa].elitv_dp.dbo.t_Sale
where ChID = 100396996

select CRID from t_Sale_r 
where Docdate ='2016-12-03' 
group by CRID


select [ЧП или Нет ] from t_Sale_r 
where Docdate ='2016-12-03' 
group by [ЧП или Нет ]

select * from t_Sale_r 
where Docdate ='2016-12-03' 



select * from [s-sql-d4].elitr.dbo.t_exc where DocID = 200002093 


insert t_exc
select * from [s-sql-d4].elitr.dbo.t_exc where chid = 200002306 


insert t_excd
select * from [s-sql-d4].elitr.dbo.t_excd where chid = 200002306 and SrcPosID not in (select SrcPosID from t_excd where chid = 200002306  )

insert t_PInP
select * from [s-sql-d4].elitr.dbo.t_PInP where prodid = 801287 and ppid = 50027


 TRel1_Ins_t_Rem


select * from t_PInP where prodid = 800468 and ppid = 50029

select * from t_exc where chid = 200002306 

select * from t_excd where chid = 200002306 