SELECT * FROM it_TSD_doc_head

SELECT top 1 UserID FROM r_Users WITH(NOLOCK) WHERE UserName = 'kea20'
SELECT top 1 UserID FROM r_Users WITH(NOLOCK) WHERE UserName = 'paa18'

update it_TSD_doc_head
 set Id_user = 1847
 where sklad_in_id in (1252)