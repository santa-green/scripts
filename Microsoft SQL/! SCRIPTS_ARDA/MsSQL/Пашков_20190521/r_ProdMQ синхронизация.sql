
select * from r_ProdMQ
except
select * from [s-marketa].elitv_dp.dbo.r_ProdMQ
except
select * from r_ProdMQ
ProdID	UM	Qty	Weight	Notes	BarCode	ProdBarCode	PLID
600672	רע1	1.000000000	0.000000000	NULL	600672	5200322250328	0

select * from r_ProdMQ
except
select * from [s-marketa2].elitv_kiev.dbo.r_ProdMQ
except
select * from r_ProdMQ


ProdID	UM	Qty	Weight	Notes	BarCode	ProdBarCode	PLID
611448	כ	1.000000000	0.000000000	NULL	611448	NULL	0
801910	רע	1.000000000	0.000000000	NULL	5200322250328	5200322250328	0
select * from r_ProdMQ
except
select * from [s-marketa3].elitv_dp2.dbo.r_ProdMQ
except
select * from r_ProdMQ
ProdID	UM	Qty	Weight	Notes	BarCode	ProdBarCode	PLID
600672	רע1	1.000000000	0.000000000	NULL	5200322250328	5200322250328	0


select * from r_ProdMQ
except
select * from [192.168.22.21].elitv_O.dbo.r_ProdMQ
except
select * from r_ProdMQ

select * from r_ProdMQ
except
select * from [CP1_DP].[ElitCP1].[dbo].r_ProdMQ
except
select * from r_ProdMQ