use otdatacafe 
select 30 as AChID ,identity(smallint,1,1) as SubSrcPosID ,rms.sprodid as SubProdID ,max (tr.ppid)as SubPPID ,r.um as SubUM ,
	
		(_t.qty*rms.rexp)as SubQty , 1 as SubPriceCC_nt ,2 as SubSumCC_nt ,3 as SubTax ,
			4 as SubTaxSum , 5 as SubPriceCC_wt ,6 as SubSumCC_wt ,7 as SubNewPriceCC_nt ,8 as SubNewSumCC_nt ,
		9 as SubNewTax ,10 as SubNewTaxSum ,11 as SubNewPriceCC_wt ,12 as SubNewSumCC_wt ,1 as SubSecID ,rq.barcode as SubBarCode

into _t_srecD

from _t_srecA as _t inner join r_prodms rms on  _t.prodid = rms.prodid 
		inner join t_rem tr on rms.sprodid = tr.prodid inner join r_prods r on rms.sprodid = r.prodid 
			inner join r_prodmq rq on rms.sprodid = rq.prodid 


group by  rms.sprodid ,r.um ,_t.qty ,rms.rexp,rq.barcode