SELECT Id_doc, Doc_number, Doc_date,
 case Doc_type when 0 then '������' when 1 then '������' when 2 then '��������������' end as Doc_type,
  Id_contragent, Doc_state,
  case Id_user  when 1881 then '��������' when 1847 then '���������' else str(Id_user) end as Id_user ,
  sklad_in_id, sklad_out_id
  FROM it_TSD_doc_head
  order by Id_user
  
  
  SELECT Id_doc, Id_good, Count_doc, Count_real FROM it_TSD_doc_details
  
  z_AppPrints
  
  z_Apps
  
  z_ToolDocs
  
  
  
  
  
  
  