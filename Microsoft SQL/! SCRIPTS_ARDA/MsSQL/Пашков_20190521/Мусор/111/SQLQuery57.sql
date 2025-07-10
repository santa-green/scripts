BEGIN TRAN


exec [dbo].[ip_ImpFromTSD_Oll_T_rec] @Type = 0, @Chid_t_EOExp = 20849	


ROLLBACK TRAN
