--IF EXISTS(SELECT NULL FROM at_t_IORes WHERE ChID = #��������_��� ����������� �������� ���������# AND (CodeID1 BETWEEN 2000 AND 3000 OR CodeID1 IN(50)))
--  BEGIN
--    RAISERROR('������ ����������� ���������� ��� ������� � ������ ��������� ���� "������� 1". �������� ��������.', 18, 1)
--    RETURN
--  END

EXEC dbo.ap_Insert_at_t_IOResDD @ChID = 101382114
/*UPDATE dbo.at_t_IORes SET ReserveProds = 0 WHERE ChID = #��������_��� ����������� �������� ���������#
EXEC dbo.ap_AU_attIOResCodeID4 @AChID = #��������_��� ����������� �������� ���������#*/

DELETE at_t_IOResDD WHERE ChID = 101382114
SELECT * FROM  at_t_IOResDD WHERE ChID = 101382114
SELECT * FROM  at_t_IOResD WHERE ChID = 101382114
