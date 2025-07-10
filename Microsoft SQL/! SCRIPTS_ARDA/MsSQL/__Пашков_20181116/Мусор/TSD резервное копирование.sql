SELECT Id_doc, Doc_number, Doc_date, Doc_type, Id_contragent, Doc_state, Id_user, sklad_in_id, sklad_out_id FROM it_TSD_doc_head

SELECT * FROM it_TSD_doc_details


SELECT * FROM it_TSD_doc_head_1

SELECT * FROM it_TSD_doc_details_1

/* резервное копирование
delete it_TSD_doc_head_1
delete it_TSD_doc_details_1

INSERT it_TSD_doc_head_1
  SELECT * FROM it_TSD_doc_head

INSERT it_TSD_doc_details_1
  SELECT * FROM it_TSD_doc_details
*/

SELECT top 1 UserID FROM r_Users WITH(NOLOCK) WHERE UserName = 'kea20' --1881
SELECT top 1 UserID FROM r_Users WITH(NOLOCK) WHERE UserName = 'paa18' --1847

--update it_TSD_doc_head
-- set Id_user = 1847
-- where sklad_in_id in (1252)

SELECT * FROM it_TSD_doc_head_1
except
SELECT * FROM it_TSD_doc_head


SELECT * FROM it_TSD_doc_details_1
except
SELECT * FROM it_TSD_doc_details

SELECT SUSER_SNAME() SUSERSNAME

dbo.ip_ImpFromTSD_Oll_T_rec 0

ip_ImpToRecFromTerm

SELECT COUNT(DISTINCT id_doc) as Doc_count FROM it_TSD_doc_details WHERE id_doc IN (SELECT id_doc FROM it_TSD_doc_head WHERE doc_type=1)

 dbo.ip_ImpFromTSD 1


