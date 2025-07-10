--1 добавить склад
BEGIN TRAN

select * from dbo.DS_FACES where fType = 6 and fName like '%30%'

exec DMT_Set_StoreEx @ExId='30', @ActiveFlag=1, @Name='Склад Киев 30', @ShortName='Киев 30';
exec DMT_Set_StoreEx @ExId='330', @ActiveFlag=1, @Name='Склад Киев 330', @ShortName='Киев 330';

select * from dbo.DS_FACES where fType = 6 and fName like '%30%'

ROLLBACK TRAN


--2 делаем перемещение товара
SELECT * FROM [S-SQL-D4].elit.dbo.t_rem where OurID = 1 and StockID = 30
SELECT * FROM [S-SQL-D4].elit.dbo.t_rem where OurID = 1 and StockID = 330



use Alef_Elit

--джоб REM Обновление остатков в КПК
exec dbo.ALEF_IMPORT_REMAINS;


--джоб ZAM Импорт заказов из КПК в ОТ
--шаг S1
exec dbo.ALEF_EXPORT_ZAM;
--шаг S2
exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=1;


/*
IF EXISTS(SELECT NULL FROM at_t_IORes WHERE ChID = #Параметр_Код регистрации текущего документа# AND (CodeID1 BETWEEN 2000 AND 3000 OR CodeID1 IN(50)))
  BEGIN
    RAISERROR('Мастер копирования недоступен для заказов с данным значением поля "Признак 1". Действие отменено.', 18, 1)
    RETURN
  END

EXEC dbo.ap_Insert_at_t_IOResDD @ChID = #Параметр_Код регистрации текущего документа#
/*UPDATE dbo.at_t_IORes SET ReserveProds = 0 WHERE ChID = #Параметр_Код регистрации текущего документа#
EXEC dbo.ap_AU_attIOResCodeID4 @AChID = #Параметр_Код регистрации текущего документа#*/

*/