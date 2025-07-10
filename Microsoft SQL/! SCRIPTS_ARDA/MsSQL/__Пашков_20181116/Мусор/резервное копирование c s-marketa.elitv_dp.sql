USE ElitV_DP_Test_Rkiper

/* резервное копирование c [s-marketa].elitv_dp
delete it_TSD_doc_head_1
delete it_TSD_doc_details_1

INSERT it_TSD_doc_head_1
  SELECT * FROM [s-marketa].elitv_dp.dbo.it_TSD_doc_head

INSERT it_TSD_doc_details_1
  SELECT * FROM [s-marketa].elitv_dp.dbo.it_TSD_doc_details
*/


