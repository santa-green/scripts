USE Alef_Elit
GO
--select a.* from Table1 a where a.ID not in(select b.ID from Table2 b where b.ID=a.ID)

SELECT iidText AS 'Kod', iShortName AS 'Nazvanie'
	FROM DS_ITEMS
	WHERE iidText in   ('1209','4165','26133','26136','26168','26213','29875','33453','33455','34464','34797','34798','','','','','','')

