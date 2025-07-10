--IF EXISTS(SELECT NULL FROM at_t_IORes WHERE ChID = #Параметр_Код регистрации текущего документа# AND (CodeID1 BETWEEN 2000 AND 3000 OR CodeID1 IN(50)))
--  BEGIN
--    RAISERROR('Мастер копирования недоступен для заказов с данным значением поля "Признак 1". Действие отменено.', 18, 1)
--    RETURN
--  END

EXEC dbo.ap_Insert_at_t_IOResDD @ChID = 101382114
/*UPDATE dbo.at_t_IORes SET ReserveProds = 0 WHERE ChID = #Параметр_Код регистрации текущего документа#
EXEC dbo.ap_AU_attIOResCodeID4 @AChID = #Параметр_Код регистрации текущего документа#*/

DELETE at_t_IOResDD WHERE ChID = 101382114
SELECT * FROM  at_t_IOResDD WHERE ChID = 101382114
SELECT * FROM  at_t_IOResD WHERE ChID = 101382114
