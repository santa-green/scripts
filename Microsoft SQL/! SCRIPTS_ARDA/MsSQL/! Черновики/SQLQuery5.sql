
--�������� ����� �������

--��������� ��������� � ��������� �������
IF  (CONVERT (time, GETDATE()) > '09:00:00' AND CONVERT (time, GETDATE()) < '17:00:00') AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- � �� �� ��
	OR  (CONVERT (time, GETDATE()) > '17:00:00' AND CONVERT (time, GETDATE()) < '18:00:00') AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- � �� �� �� select 1
BEGIN

exec [dbo].[ap_EDI_SendToEmail_New_GLN]

END



USE Alef_Elit
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*�������� ����� GLN �������*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--��������� ��������� � ��������� �������
IF  (
    (CONVERT (time, GETDATE()) > '09:00:00' AND CONVERT (time, GETDATE()) < '17:00:00')
    AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- � �� �� ��
    )
	OR
    (
    (CONVERT(time, GETDATE()) > '17:00:00' AND CONVERT (time, GETDATE()) < '18:00:00') 
    AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- � �� �� �� select 1
    )

BEGIN
    EXEC [dbo].[ap_EDI_SendToEmail_New_GLN]
END;