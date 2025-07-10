SELECT * FROM dbo.it_TSD_barcode
SELECT * FROM dbo.it_TSD_contragents
SELECT * FROM dbo.it_TSD_doc_details
SELECT * FROM dbo.it_TSD_doc_head
SELECT * FROM dbo.it_TSD_goods
SELECT * FROM dbo.it_TSD_sklad
SELECT * FROM dbo.it_TSD_users

Id_doc	Doc_number	Doc_date	Doc_type	Id_contragent	Doc_state	Id_user	sklad_in_id	sklad_out_id
18974	1 - Арда-Трейдинг ООО (б/а и проч.	2017-03-14 00:00:00.000	0	71	110	1847	1241	1241
18975	2 - Арда-Трейдинг ООО (алкоголь)	2017-03-14 00:00:00.000	0	81	110	1847	1241	1241

SELECT * FROM dbo.it_TSD_goods where Id_good = 601284


SELECT * FROM dbo.it_TSD_goods where Id_good in (SELECT Id_good FROM dbo.it_TSD_doc_details)
order by 1

Select count(id_doc) as Doc_count from it_TSD_doc_head where id_doc=(SELECT CAST(1 AS NVARCHAR(1))+(CASE when LEN('18982')>8 then RIGHT(CAST('18982' AS VARCHAR), LEN('18982')-1) ELSE CAST('18982' AS VARCHAR) end))

SELECT CAST(1 AS NVARCHAR(1))+(CASE when LEN('18982')>8 then RIGHT(CAST('18982' AS VARCHAR), LEN('18982')-1) ELSE CAST('18982' AS VARCHAR) end)

EXEC dbo.ip_ExpToTSD '+VarToStr(<DocChID>)+', 0, 1

SELECT * FROM t_Rec

SELECT * FROM r_Users order by 3