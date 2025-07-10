use otdata
truncate table 	dbo.r_Codes1
truncate table 	dbo.r_Codes1_B1
truncate table 	dbo.r_Codes1_B2
truncate table 	dbo.r_Codes1_B3
truncate table 	dbo.r_Codes1_C
truncate table 	dbo.r_Codes1_E
truncate table 	dbo.r_Codes1_N
truncate table 	dbo.r_Codes1_P
truncate table 	dbo.r_Codes1_S1
truncate table 	dbo.r_Codes1_S2
truncate table 	dbo.r_Codes1_T1
truncate table 	dbo.r_Codes1_T2
truncate table 	dbo.r_Codes2
truncate table 	dbo.r_Codes2_B1
truncate table 	dbo.r_Codes2_B2
truncate table 	dbo.r_Codes2_B3
truncate table 	dbo.r_Codes2_C
truncate table 	dbo.r_Codes2_E
truncate table 	dbo.r_Codes2_N
truncate table 	dbo.r_Codes2_P
truncate table 	dbo.r_Codes2_S1
truncate table 	dbo.r_Codes2_S2
truncate table 	dbo.r_Codes2_T1
truncate table 	dbo.r_Codes2_T2
truncate table 	dbo.r_Codes3
truncate table 	dbo.r_Codes3_B1
truncate table 	dbo.r_Codes3_B2
truncate table 	dbo.r_Codes3_B3
truncate table 	dbo.r_Codes3_C
truncate table 	dbo.r_Codes3_E
truncate table 	dbo.r_Codes3_N
truncate table 	dbo.r_Codes3_P
truncate table 	dbo.r_Codes3_S1
truncate table 	dbo.r_Codes3_S2
truncate table 	dbo.r_Codes3_T1
truncate table 	dbo.r_Codes3_T2
truncate table 	dbo.r_Codes4
truncate table 	dbo.r_Codes4_B1
truncate table 	dbo.r_Codes4_B2
truncate table 	dbo.r_Codes4_B3
truncate table 	dbo.r_Codes4_C
truncate table 	dbo.r_Codes4_E
truncate table 	dbo.r_Codes4_N
truncate table 	dbo.r_Codes4_P
truncate table 	dbo.r_Codes4_S1
truncate table 	dbo.r_Codes4_S2
truncate table 	dbo.r_Codes4_T1
truncate table 	dbo.r_Codes4_T2
truncate table 	dbo.r_CompMG
truncate table 	dbo.r_Comps
truncate table 	dbo.r_Comps_B1
truncate table 	dbo.r_Comps_B2
truncate table 	dbo.r_Comps_C
truncate table 	dbo.r_Comps_E1
truncate table 	dbo.r_Comps_E2
truncate table 	dbo.r_Comps_P
truncate table 	dbo.r_Comps_R
truncate table 	dbo.r_Comps_S
truncate table 	dbo.r_Comps_T
truncate table 	dbo.r_CompsAC
truncate table 	dbo.r_CompsCC
truncate table 	dbo.r_CRMO
truncate table 	dbo.r_CRs
truncate table 	dbo.r_CRSrvs
truncate table 	dbo.r_EmpMO
truncate table 	dbo.r_EmpMPst
truncate table 	dbo.r_PLs
truncate table 	dbo.r_ProdC
truncate table 	dbo.r_ProdG
truncate table 	dbo.r_ProdG1
truncate table 	dbo.r_ProdG2
truncate table 	dbo.r_ProdG3
truncate table 	dbo.r_ProdMP
truncate table 	dbo.r_ProdMPCh
truncate table 	dbo.r_ProdMQ
truncate table 	dbo.r_ProdMQ_T
truncate table 	dbo.r_Prods
truncate table 	dbo.r_Prods_R
truncate table 	dbo.r_Stocks
truncate table 	dbo.r_Stocks_B1
truncate table 	dbo.r_Stocks_B2
truncate table 	dbo.r_Stocks_C
truncate table 	dbo.r_Stocks_E1
truncate table 	dbo.r_Stocks_E2
truncate table 	dbo.r_Stocks_S1
truncate table 	dbo.r_Stocks_S2
truncate table 	dbo.r_Stocks_T1
truncate table 	dbo.r_Stocks_T2
truncate table 	dbo.r_WPrefs
truncate table 	dbo.t_PInP
truncate table 	dbo.t_PInP_T
truncate table 	dbo.t_Rem
truncate table 	dbo.t_zInP
truncate table 	dbo.v_Fields
truncate table 	dbo.v_Formulas
truncate table 	dbo.v_MapSG
truncate table 	dbo.v_Params
truncate table 	dbo.v_RepGrs
truncate table 	dbo.v_Reps
truncate table 	dbo.v_SourceGrs
truncate table 	dbo.v_Sources
truncate table 	dbo.v_Tables
truncate table 	dbo.v_UFields
truncate table 	dbo.v_UParams
truncate table 	dbo.v_UReps
truncate table 	dbo.z_BarMask
truncate table 	dbo.z_DocDF
truncate table 	dbo.z_WCopy
truncate table 	dbo.z_WCopyD
truncate table 	dbo.z_WCopyDF
truncate table 	dbo.z_WCopyDV
truncate table 	dbo.z_WCopyF
truncate table 	dbo.z_WCopyFUF
truncate table 	dbo.z_WCopyFV
truncate table 	dbo.z_WCopyFVUF
truncate table 	dbo.z_WCopyP
truncate table 	dbo.z_WCopyT
truncate table 	dbo.z_WCopyUV

insert into  otdata.	dbo.r_Codes1	select * from otdataM5.	dbo.r_Codes1
insert into  otdata.	dbo.r_Codes1_B1	select * from otdataM5.	dbo.r_Codes1_B1
insert into  otdata.	dbo.r_Codes1_B2	select * from otdataM5.	dbo.r_Codes1_B2
insert into  otdata.	dbo.r_Codes1_B3	select * from otdataM5.	dbo.r_Codes1_B3
insert into  otdata.	dbo.r_Codes1_C	select * from otdataM5.	dbo.r_Codes1_C
insert into  otdata.	dbo.r_Codes1_E	select * from otdataM5.	dbo.r_Codes1_E
insert into  otdata.	dbo.r_Codes1_N	select * from otdataM5.	dbo.r_Codes1_N
insert into  otdata.	dbo.r_Codes1_P	select * from otdataM5.	dbo.r_Codes1_P
insert into  otdata.	dbo.r_Codes1_S1	select * from otdataM5.	dbo.r_Codes1_S1
insert into  otdata.	dbo.r_Codes1_S2	select * from otdataM5.	dbo.r_Codes1_S2
insert into  otdata.	dbo.r_Codes1_T1	select * from otdataM5.	dbo.r_Codes1_T1
insert into  otdata.	dbo.r_Codes1_T2	select * from otdataM5.	dbo.r_Codes1_T2
insert into  otdata.	dbo.r_Codes2	select * from otdataM5.	dbo.r_Codes2
insert into  otdata.	dbo.r_Codes2_B1	select * from otdataM5.	dbo.r_Codes2_B1
insert into  otdata.	dbo.r_Codes2_B2	select * from otdataM5.	dbo.r_Codes2_B2
insert into  otdata.	dbo.r_Codes2_B3	select * from otdataM5.	dbo.r_Codes2_B3
insert into  otdata.	dbo.r_Codes2_C	select * from otdataM5.	dbo.r_Codes2_C
insert into  otdata.	dbo.r_Codes2_E	select * from otdataM5.	dbo.r_Codes2_E
insert into  otdata.	dbo.r_Codes2_N	select * from otdataM5.	dbo.r_Codes2_N
insert into  otdata.	dbo.r_Codes2_P	select * from otdataM5.	dbo.r_Codes2_P
insert into  otdata.	dbo.r_Codes2_S1	select * from otdataM5.	dbo.r_Codes2_S1
insert into  otdata.	dbo.r_Codes2_S2	select * from otdataM5.	dbo.r_Codes2_S2
insert into  otdata.	dbo.r_Codes2_T1	select * from otdataM5.	dbo.r_Codes2_T1
insert into  otdata.	dbo.r_Codes2_T2	select * from otdataM5.	dbo.r_Codes2_T2
insert into  otdata.	dbo.r_Codes3	select * from otdataM5.	dbo.r_Codes3
insert into  otdata.	dbo.r_Codes3_B1	select * from otdataM5.	dbo.r_Codes3_B1
insert into  otdata.	dbo.r_Codes3_B2	select * from otdataM5.	dbo.r_Codes3_B2
insert into  otdata.	dbo.r_Codes3_B3	select * from otdataM5.	dbo.r_Codes3_B3
insert into  otdata.	dbo.r_Codes3_C	select * from otdataM5.	dbo.r_Codes3_C
insert into  otdata.	dbo.r_Codes3_E	select * from otdataM5.	dbo.r_Codes3_E
insert into  otdata.	dbo.r_Codes3_N	select * from otdataM5.	dbo.r_Codes3_N
insert into  otdata.	dbo.r_Codes3_P	select * from otdataM5.	dbo.r_Codes3_P
insert into  otdata.	dbo.r_Codes3_S1	select * from otdataM5.	dbo.r_Codes3_S1
insert into  otdata.	dbo.r_Codes3_S2	select * from otdataM5.	dbo.r_Codes3_S2
insert into  otdata.	dbo.r_Codes3_T1	select * from otdataM5.	dbo.r_Codes3_T1
insert into  otdata.	dbo.r_Codes3_T2	select * from otdataM5.	dbo.r_Codes3_T2
insert into  otdata.	dbo.r_Codes4	select * from otdataM5.	dbo.r_Codes4
insert into  otdata.	dbo.r_Codes4_B1	select * from otdataM5.	dbo.r_Codes4_B1
insert into  otdata.	dbo.r_Codes4_B2	select * from otdataM5.	dbo.r_Codes4_B2
insert into  otdata.	dbo.r_Codes4_B3	select * from otdataM5.	dbo.r_Codes4_B3
insert into  otdata.	dbo.r_Codes4_C	select * from otdataM5.	dbo.r_Codes4_C
insert into  otdata.	dbo.r_Codes4_E	select * from otdataM5.	dbo.r_Codes4_E
insert into  otdata.	dbo.r_Codes4_N	select * from otdataM5.	dbo.r_Codes4_N
insert into  otdata.	dbo.r_Codes4_P	select * from otdataM5.	dbo.r_Codes4_P
insert into  otdata.	dbo.r_Codes4_S1	select * from otdataM5.	dbo.r_Codes4_S1
insert into  otdata.	dbo.r_Codes4_S2	select * from otdataM5.	dbo.r_Codes4_S2
insert into  otdata.	dbo.r_Codes4_T1	select * from otdataM5.	dbo.r_Codes4_T1
insert into  otdata.	dbo.r_Codes4_T2	select * from otdataM5.	dbo.r_Codes4_T2
insert into  otdata.	dbo.r_PLs	select * from otdataM5.	dbo.r_PLs

insert into  otdata.	dbo.r_Stocks	select * from otdataM5.	dbo.r_Stocks
insert into  otdata.	dbo.r_Stocks_B1	select * from otdataM5.	dbo.r_Stocks_B1
insert into  otdata.	dbo.r_Stocks_B2	select * from otdataM5.	dbo.r_Stocks_B2
insert into  otdata.	dbo.r_Stocks_C	select * from otdataM5.	dbo.r_Stocks_C
insert into  otdata.	dbo.r_Stocks_E1	select * from otdataM5.	dbo.r_Stocks_E1
insert into  otdata.	dbo.r_Stocks_E2	select * from otdataM5.	dbo.r_Stocks_E2
insert into  otdata.	dbo.r_Stocks_S1	select * from otdataM5.	dbo.r_Stocks_S1
insert into  otdata.	dbo.r_Stocks_S2	select * from otdataM5.	dbo.r_Stocks_S2
insert into  otdata.	dbo.r_Stocks_T1	select * from otdataM5.	dbo.r_Stocks_T1
insert into  otdata.	dbo.r_Stocks_T2	select * from otdataM5.	dbo.r_Stocks_T2

insert into  otdata.	dbo.r_CRSrvs	select * from otdataM5.	dbo.r_CRSrvs	
insert into  otdata.	dbo.r_CRs	select * from otdataM5.	dbo.r_CRs
insert into  otdata.	dbo.r_EmpMO	select * from otdataM5.	dbo.r_EmpMO
insert into  otdata.	dbo.r_CRMO	select * from otdataM5.	dbo.r_CRMO
insert into  otdata.	dbo.r_EmpMPst	select * from otdataM5.	dbo.r_EmpMPst

insert into  otdata.	dbo.r_Comps	select * from otdataM5.	dbo.r_Comps
insert into  otdata.	dbo.r_CompMG	select * from otdataM5.	dbo.r_CompMG
insert into  otdata.	dbo.r_Comps_B1	select * from otdataM5.	dbo.r_Comps_B1
insert into  otdata.	dbo.r_Comps_B2	select * from otdataM5.	dbo.r_Comps_B2
insert into  otdata.	dbo.r_Comps_C	select * from otdataM5.	dbo.r_Comps_C
insert into  otdata.	dbo.r_Comps_E1	select * from otdataM5.	dbo.r_Comps_E1
insert into  otdata.	dbo.r_Comps_E2	select * from otdataM5.	dbo.r_Comps_E2
insert into  otdata.	dbo.r_Comps_P	select * from otdataM5.	dbo.r_Comps_P
insert into  otdata.	dbo.r_Comps_R	select * from otdataM5.	dbo.r_Comps_R
insert into  otdata.	dbo.r_Comps_S	select * from otdataM5.	dbo.r_Comps_S
insert into  otdata.	dbo.r_Comps_T	select * from otdataM5.	dbo.r_Comps_T
insert into  otdata.	dbo.r_CompsAC	select * from otdataM5.	dbo.r_CompsAC
insert into  otdata.	dbo.r_CompsCC	select * from otdataM5.	dbo.r_CompsCC

insert into  otdata.	dbo.r_ProdC	select * from otdataM5.	dbo.r_ProdC
insert into  otdata.	dbo.r_ProdG	select * from otdataM5.	dbo.r_ProdG
insert into  otdata.	dbo.r_ProdG1	select * from otdataM5.	dbo.r_ProdG1
insert into  otdata.	dbo.r_ProdG2	select * from otdataM5.	dbo.r_ProdG2
insert into  otdata.	dbo.r_ProdG3	select * from otdataM5.	dbo.r_ProdG3
insert into  otdata.	dbo.r_Prods	select * from otdataM5.	dbo.r_Prods
insert into  otdata.	dbo.r_Prods_R	select * from otdataM5.	dbo.r_Prods_R
insert into  otdata.	dbo.r_ProdMP	select * from otdataM5.	dbo.r_ProdMP
insert into  otdata.	dbo.r_ProdMPCh	select * from otdataM5.	dbo.r_ProdMPCh
insert into  otdata.	dbo.r_ProdMQ	select * from otdataM5.	dbo.r_ProdMQ
insert into  otdata.	dbo.r_ProdMQ_T	select * from otdataM5.	dbo.r_ProdMQ_T
insert into  otdata.	dbo.r_WPrefs	select * from otdataM5.	dbo.r_WPrefs


--- до этого момента все работает
insert into  otdata.	dbo.t_PInP	select * from otdataM5.	dbo.t_PInP
insert into  otdata.	dbo.t_PInP_T	select * from otdataM5.	dbo.t_PInP_T
--insert into  otdata.	dbo.t_Rem	select * from otdataM5.	dbo.t_Rem


select *
into  otdata.dbo._t_zInP	
 from otdataM5.	dbo.t_zInP  -- осё говно 

PRINT '	- Перенос входящих остатков в таблицу t_ZinP'
DECLARE @I INT ,
	@X INT	
SELECT @I = MAX (ChID)
FROM otdata.dbo._t_zInP
SET  @X = 1
WHILE @X <= @I
BEGIN 
INSERT INTO otdata.dbo.t_zInP
SELECT *
FROM otdata.dbo._t_zInP
WHERE otdata.dbo._t_zInP.ChID = @X
SET @X = @X+1
END
DROP TABLE otdata.dbo._t_zInP 

-- после этого то же  
insert into  otdata.	dbo.v_RepGrs	select * from otdataM5.	dbo.v_RepGrs
insert into  otdata.	dbo.v_Reps	select * from otdataM5.	dbo.v_Reps
insert into  otdata.	dbo.v_Fields	select * from otdataM5.	dbo.v_Fields
insert into  otdata.	dbo.v_SourceGrs	select * from otdataM5.	dbo.v_SourceGrs
insert into  otdata.	dbo.v_Sources	select * from otdataM5.	dbo.v_Sources
insert into  otdata.	dbo.v_Formulas	select * from otdataM5.	dbo.v_Formulas
insert into  otdata.	dbo.v_MapSG	select * from otdataM5.	dbo.v_MapSG
insert into  otdata.	dbo.v_Params	select * from otdataM5.	dbo.v_Params
insert into  otdata.	dbo.v_Tables	select * from otdataM5.	dbo.v_Tables
insert into  otdata.	dbo.v_UFields	select * from otdataM5.	dbo.v_UFields
insert into  otdata.	dbo.v_UParams	select * from otdataM5.	dbo.v_UParams
insert into  otdata.	dbo.v_UReps	select * from otdataM5.	dbo.v_UReps

insert into  otdata.	dbo.z_BarMask	select * from otdataM5.	dbo.z_BarMask
insert into  otdata.	dbo.z_DocDF	select * from otdataM5.	dbo.z_DocDF
insert into  otdata.	dbo.z_WCopy	select * from otdataM5.	dbo.z_WCopy
insert into  otdata.	dbo.z_WCopyD	select * from otdataM5.	dbo.z_WCopyD
insert into  otdata.	dbo.z_WCopyUV	select * from otdataM5.	dbo.z_WCopyUV
insert into  otdata.	dbo.z_WCopyDF	select * from otdataM5.	dbo.z_WCopyDF
insert into  otdata.	dbo.z_WCopyT	select * from otdataM5.	dbo.z_WCopyT
insert into  otdata.	dbo.z_WCopyF	select * from otdataM5.	dbo.z_WCopyF
insert into  otdata.	dbo.z_WCopyDV	select * from otdataM5.	dbo.z_WCopyDV
insert into  otdata.	dbo.z_WCopyFUF	select * from otdataM5.	dbo.z_WCopyFUF
insert into  otdata.	dbo.z_WCopyFV	select * from otdataM5.	dbo.z_WCopyFV
insert into  otdata.	dbo.z_WCopyFVUF	select * from otdataM5.	dbo.z_WCopyFVUF
insert into  otdata.	dbo.z_WCopyP	select * from otdataM5.	dbo.z_WCopyP































































































