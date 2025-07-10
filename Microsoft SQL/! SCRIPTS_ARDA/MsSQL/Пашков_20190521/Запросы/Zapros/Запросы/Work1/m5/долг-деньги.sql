select IDENTITY (INT,1,1) ChID,1 as OurID,CompID, ' ' as CompAccountCC,
	980 as CurrID ,sum (sumCC_wt) as SumAC, 1 as KursMC,1 as KursCC, 0 as CodeID1, 0 as CodeID2,0 as CodeID3,0 as CodeID4,0 as CodeID5, 0 as GOperID, 0 as GTranID,' ' as Notes
into _b_ziNc
from otdata_74.dbo.v_00340_sa
where otdata_74.dbo.v_00340_sa.GMSSourceGroup like 'Долг'
group by CompID ,otdata_74.dbo.v_00340_sa.compname
order by otdata_74.dbo.v_00340_sa.compname

insert into otdata.dbo.b_ziNc
select *
 from otdatam5.dbo._b_ziNc
--drop table _b_ziNc
--truncate table 	otdata.dbo.b_ziNc