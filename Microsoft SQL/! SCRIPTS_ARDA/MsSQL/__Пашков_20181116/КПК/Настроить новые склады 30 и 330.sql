--1 �������� �����
BEGIN TRAN

select * from dbo.DS_FACES where fType = 6 and fName like '%30%'

exec DMT_Set_StoreEx @ExId='30', @ActiveFlag=1, @Name='����� ���� 30', @ShortName='���� 30';
exec DMT_Set_StoreEx @ExId='330', @ActiveFlag=1, @Name='����� ���� 330', @ShortName='���� 330';

select * from dbo.DS_FACES where fType = 6 and fName like '%30%'

ROLLBACK TRAN


--2 ������ ����������� ������
SELECT * FROM [S-SQL-D4].elit.dbo.t_rem where OurID = 1 and StockID = 30
SELECT * FROM [S-SQL-D4].elit.dbo.t_rem where OurID = 1 and StockID = 330



use Alef_Elit

--���� REM ���������� �������� � ���
exec dbo.ALEF_IMPORT_REMAINS;


--���� ZAM ������ ������� �� ��� � ��
--��� S1
exec dbo.ALEF_EXPORT_ZAM;
--��� S2
exec [s-sql-d4].Elit.dbo.ap_ImportOrder @mode=1;


/*
IF EXISTS(SELECT NULL FROM at_t_IORes WHERE ChID = #��������_��� ����������� �������� ���������# AND (CodeID1 BETWEEN 2000 AND 3000 OR CodeID1 IN(50)))
  BEGIN
    RAISERROR('������ ����������� ���������� ��� ������� � ������ ��������� ���� "������� 1". �������� ��������.', 18, 1)
    RETURN
  END

EXEC dbo.ap_Insert_at_t_IOResDD @ChID = #��������_��� ����������� �������� ���������#
/*UPDATE dbo.at_t_IORes SET ReserveProds = 0 WHERE ChID = #��������_��� ����������� �������� ���������#
EXEC dbo.ap_AU_attIOResCodeID4 @AChID = #��������_��� ����������� �������� ���������#*/

*/