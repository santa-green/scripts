BEGIN TRAN
--�������� ����� ��������� � ElitDistr �� Elit
IF EXISTS ( SELECT top 1 1 FROM Elit.dbo.at_r_Drivers where DriverID not in (SELECT DriverID FROM at_r_Drivers) ) INSERT at_r_Drivers SELECT * FROM Elit.dbo.at_r_Drivers where DriverID not in (SELECT DriverID FROM at_r_Drivers)



ROLLBACK TRAN





