    SELECT *
    FROM [at_EDI_reg_files] WHERE doctype = 70121 and chid = 103485
    --WHERE RetailersID = 15
    ORDER BY lastupdatedata DESC

	    and [Status] = 10
	    and InsertData >= '20210101';

--TRAN
BEGIN TRAN
    SELECT count(*) from [at_EDI_reg_files] WHERE doctype = 70121 and chid = 103485
    SELECT * FROM [at_EDI_reg_files] WHERE doctype = 70121 and chid = 103485
    update [at_EDI_reg_files] set [status] = 14 /*!*/  WHERE doctype = 70121 and chid = 103485
    SELECT * FROM [at_EDI_reg_files] WHERE doctype = 70121 and chid = 103485
    SELECT count(*) from [at_EDI_reg_files] WHERE doctype = 70121 and chid = 103485
ROLLBACK TRAN

--    IF 2 = (SELECT count(*) from [at_EDI_reg_files] WHERE doctype = 70121 and chid = 103485)
--    BEGIN
--        select @@TRANCOUNT '@@TRANCOUNT'
--        COMMIT TRAN
--        select @@TRANCOUNT '@@TRANCOUNT'
--    END;
--    ELSE 
--        RAISERROR('ROLLING BACK...', 18, 1)
--        ROLLBACK TRAN
--select @@TRANCOUNT '@@TRANCOUNT'



SELECT * FROM [at_EDI_reg_files] WHERE chid = 103485
SELECT * FROM [at_EDI_reg_files] WHERE STATUS = 15
SELECT DISTINCT(STATUS) FROM [at_EDI_reg_files] ORDER BY 1 DESC
SELECT DISTINCT(STATUS) FROM [at_EDI_reg_files] WHERE [FileName] like '%comdoc%' ORDER BY 1 DESC

SELECT * FROM [at_EDI_reg_files] WHERE doctype = 70121 and [Status] = 14 and ChID = 103485 ORDER BY InsertData DESC
SELECT [FileName] FROM [at_EDI_reg_files] WHERE doctype = 70121 and [Status] = 14 and ChID = 103485 ORDER BY InsertData DESC


SELECT * FROM [at_EDI_reg_files] WHERE doctype = 70121 and [Status] = 14
SELECT * FROM [at_EDI_reg_files] WHERE ChID in (71744,75882,79042,82332,83510,83511,83512,83513,83514,83515,83516,83525,86521,86522,86523,86703,90230,90231,90232,90714,94843,94844,96097,96098,96099,99092,99093,100998,100999,101000)
SELECT [FileName] FROM [at_EDI_reg_files] WHERE doctype = 70121 and [Status] = 14