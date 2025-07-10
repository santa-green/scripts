select  * 
from r_DCards
where Discount = 0 and InUse = 0
--and ChID between 100004301 and  100005300
order by ChID 


/*

SELECT * 
into _NewcalcB
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0;IMEX=1; Database=D:\Болоньез.xlsx' ,'select * from [Лист5$]')

*/

