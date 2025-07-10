
--рейтинг отчетов анализатора
SELECT r.RepID, RepName,s1.kol 'всего запусков',s2.username,s2.kolur 'запусков пользователя' FROM v_Reps r
join (SELECT RepID,  COUNT(RepID) kol FROM at_z_AzRepsLog group by RepID) s1 on s1.RepID = r.RepID
join (
SELECT gr.RepID, gr.UserID, gr.kolur, (SELECT top 1 e.EmpName FROM r_Users u join r_Emps e on e.EmpID = u.EmpID where u.UserID = gr.UserID) username  FROM (
SELECT RepID, UserID, COUNT(RepID) kolur FROM at_z_AzRepsLog
group by RepID, UserID)gr
)s2 on s2.RepID = r.RepID
ORDER BY 3 desc,1,5desc

--SELECT * FROM at_z_AzRepsLog ORDER BY RunDate

--SELECT u.UserID, e.EmpName FROM r_Users u join r_Emps e on e.EmpID = u.EmpID and 

--SELECT RepID,  COUNT(RepID) kol FROM at_z_AzRepsLog group by RepID ORDER BY 2 desc


