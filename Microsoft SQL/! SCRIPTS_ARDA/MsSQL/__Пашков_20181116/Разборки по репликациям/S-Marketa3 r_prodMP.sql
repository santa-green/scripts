	10909608	12	z_Replica_Ins_r_ProdMP_12 602407,84,252.700000000,NULL,980,0,1,NULL,NULL,NULL,0	2	Violation of PRIMARY KEY constraint '_pk_r_ProdMP'. Cannot insert duplicate key in object 'dbo.r_ProdMP'. The duplicate key value is (602407, 84).	2017-03-30 09:35:00.000
	
	
	SELECT * FROM r_ProdMP where ProdID = 602407
	
	SELECT * FROM r_PLs
	
	--лечение. пропусть эту реплику
update z_replicain 
set status = 1
where status != 1 and ReplicaEventID in (10909608)