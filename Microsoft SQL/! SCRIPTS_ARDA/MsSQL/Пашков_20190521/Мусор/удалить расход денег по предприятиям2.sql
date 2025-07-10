
begin tran

select * from c_compexp where docdate = '20180901' and srcdocid = '1000'

delete c_compexp where docdate = '20180901' and srcdocid = '1000'

select * from c_compexp where docdate = '20180901' and srcdocid = '1000'


rollback tran


select * from t_rec where DocID = 600015272
select * from t_recd where ChID = 27791
