	SELECT *
	FROM [S-PPC.CONST.ALEF.UA].[Alef_Elit].[dbo].[at_EDI_reg_files] 
    WHERE id in ('60022', '60023')
    WHERE notes like '%Ú‡ÍËÏË Ò‡ÏËÏË ÂÍ‚≥ÁËÚ‡ÏË%'
    WHERE notes like '%ƒŒ ”Ã≈Õ“ Õ≈ œ–»…Õﬂ“Œ%=>%'
    and len(notes) <= 87
	and DocType = 8000
    and id in (122342)
    and insertData >= '20210801'
    ORDER BY LastUpdateData DESC
	  --AND [Status] IN (1)				    --ÕÓ‚˚È ÒÚ‡ÚÛÒ
      select len('ƒŒ ”Ã≈Õ“ Õ≈ œ–»…Õﬂ“Œ.  œË ÌÂÓ·ı≥‰ÌÓÒÚ≥ ‚ËÔ‡‚ÚÂ ‰ÓÍÛÏÂÌÚ Ú‡ Ì‡‰≥¯Î≥Ú¸ ÈÓ„Ó ÁÌÓ‚Û.   => ')

      --SELECT * FROM at_EDI_reg_files WHERE [FileName] LIKE '%.rpl' AND [Status] != 0 AND InsertData > '20201112 19:00'
      SELECT * FROM ALEF_EDI_RPL WHERE AER_TAX_ID in (12234) ORDER BY AER_AUDIT_DATE DESC
      SELECT * FROM ALEF_EDI_RPL WHERE AER_TAX_ID in (6002) ORDER BY AER_AUDIT_DATE DESC
      SELECT * FROM ALEF_EDI_RPL WHERE AER_FILECONTENT.value('(./DECLAR/DECLARBODY/HRESULT)[1]', 'varchar(1000)') like '%ƒŒ ”Ã≈Õ“ Õ≈ œ–»…Õﬂ“Œ%' ORDER BY AER_AUDIT_DATE DESC


      SELECT * FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg WHERE ChID = 104560 ORDER BY ChID DESC

      SELECT rpl.AER_RPL_ID, reg.ID, reg.ChID, *
                FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg
                JOIN [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.[av_EDI_ALEF_EDI_RPL] rpl ON rpl.AER_RPL_ID = reg.ID
                --JOIN [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.[av_EDI_ALEF_EDI_RPL] rpl ON (rpl.AER_RPL_ID = reg.ID AND cast(reg.InsertData as date) = cast(rpl.AER_AUDIT_DATE as date))
                JOIN [s-sql-d4].[elit].dbo.r_comps rc ON rc.CompID = CAST(reg.CompID as varchar(20))
                WHERE reg.ChID = 104560

SELECT * FROM at_EDI_reg_files WHERE [FileName] LIKE '%.rpl' AND [Status] != 0 AND InsertData > '20201112 19:00' and id in ('60022', '60023')
SELECT * FROM at_EDI_reg_files WHERE [FileName] LIKE '%.rpl' AND InsertData > '20201112 19:00' ORDER BY InsertData DESC
SELECT * FROM at_EDI_reg_files WHERE [FileName] LIKE '32000037029549J1201012100006002310820213200_1.RPL'
SELECT * FROM ALEF_EDI_RPL WHERE AER_FILENAME like '%32000037029549J1201012100006002310820213200_1.RPL%'
SELECT * FROM ALEF_EDI_RPL WHERE AER_FILENAME like '%_1.RPL%' ORDER BY AER_AUDIT_DATE DESC--‰Ó‰‡ÚÍÓ‚Ó..
SELECT * FROM ALEF_EDI_RPL WHERE AER_TAX_ID = 6002
--TRAN
BEGIN TRAN
SELECT count(*) from at_EDI_reg_files WHERE chid in (104559, 104560) 
SELECT * FROM at_EDI_reg_files WHERE chid in (104559, 104560) 
update at_EDI_reg_files set [status] = 0 /*!*/  WHERE chid in (104559, 104560)
SELECT * FROM at_EDI_reg_files WHERE chid in (104559, 104560)
SELECT count(*) from at_EDI_reg_files WHERE chid in (104559, 104560)
ROLLBACK TRAN