BEGIN TRAN;
INSERT INTO r_Emps (ChID, EmpID, EmpName, UAEmpName, EmpLastName, EmpFirstName, EmpParName, UAEmpLastName, UAEmpFirstName, UAEmpParName, EmpInitials, UAEmpInitials, TaxCode, EmpSex, BirthDay, File1, File2, File3, Education, FamilyStatus, BirthPlace, Phone, InPhone, Mobile, EMail, Percent1, Percent2, Percent3, Notes, MilStatus, MilFitness, MilRank, MilSpecialCalc, MilProfes, MilCalcGrp, MilCalcCat, MilStaff, MilRegOffice, MilNum, PassNo, PassSer, PassDate, PassDept, DisNum, PensNum, WorkBookNo, WorkBookSer, PerFileNo, InStopList, BarCode, ShiftPostID, IsCitizen, CertInsurSer, CertInsurNum)
VALUES (1,1,'Admin for const','Admin for const', '', '', '', '', '', '', '', '', '', 0, '1901-01-01 00:00:00', '', '', '', null, 1000, '', '', '', '', '', 0, 0, 0, '', 1000, 1000, '', '', '', '', '', '', '', '', '', '', '1901-01-01 00:00:00', '', '', '', '', '', '', 0, null, 0, 1, null, null)

SELECT * FROM r_Emps
ROLLBACK TRAN;