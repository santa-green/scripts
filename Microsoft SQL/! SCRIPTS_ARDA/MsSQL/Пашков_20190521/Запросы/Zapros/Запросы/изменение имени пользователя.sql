select * from r_Emps  where EmpID in (10205  , 10278 )

insert _name
select * from r_Emps where EmpID = 10278 
select * from _name

delete r_Emps where EmpID = 10278  

update r_Emps 
set EmpName = n.EmpName ,
	UAEmpName = n.UAEmpName ,
	EmpLastName = n.EmpLastName ,
	EmpFirstName = n.EmpFirstName ,
	EmpParName = n.EmpParName,
UAEmpLastName =n.UAEmpLastName,
UAEmpFirstName =n.UAEmpFirstName,
UAEmpParName = n.UAEmpParName,
EmpInitials =n.EmpInitials,
UAEmpInitials =n.UAEmpInitials,
TaxCode= n.TaxCode,
EmpSex =n.EmpSex,
BirthDay =n.BirthDay,
File1 = n.File1,
File2 = n.File2 ,
File3 = n.File3,
Education = n.Education,
FamilyStatus = n.FamilyStatus,
BirthPlace = n.BirthPlace,
Phone = n.Phone,
InPhone = n.InPhone,
Mobile = n.Mobile,
EMail = n.EMail,
Percent1 = n.Percent1,
Percent2 = n.Percent2,
Percent3 = n.Percent3,
Notes = n.Notes,
MilStatus =n.MilStatus,
MilFitness = n.MilFitness,
MilRank = n.MilRank,
MilSpecialCalc = n.MilSpecialCalc,
MilProfes =n.MilProfes,
MilCalcGrp =n.MilCalcGrp,
MilCalcCat =n.MilCalcCat,
MilStaff = n.MilStaff,
MilRegOffice = n.MilRegOffice,
MilNum = n.MilNum,
PassNo = n.PassNo,
PassSer = n.PassSer,
PassDate = n.PassDate,
PassDept = n.PassDept,
DisNum = n.DisNum,
PensNum = n.PensNum,
WorkBookNo = n.WorkBookNo,
WorkBookSer =n.WorkBookSer,
PerFileNo =n.PerFileNo,
InStopList =n.InStopList,
BarCode =n.BarCode,
ShiftPostID =n.ShiftPostID,
IsCitizen =n.IsCitizen 
from _name n 
where r_Emps.EmpID = 10205   


truncate table _name