

SELECT * 
into #Vkod
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0;IMEX=1; Database=D:\коды.xlsx' ,'select * from [Лист1$]')

delete r_ProdEC where ProdID in (select prodid from #Vkod)

insert into r_ProdEC
from #Vkod



