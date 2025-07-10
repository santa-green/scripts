USE Elit

SELECT m.ChID 
	  ,a.EmpID AS '���'
      ,a.EmpName AS '���������'
	  ,m.StockID AS '�����'
	  ,m.CompID AS '��-���'
	  ,rc.CompName AS '��� ��-���' 
	  ,CAST(m.DocDate AS DATE) AS '����'
	  ,m.StateCode AS '������'
FROM at_t_IORes m WITH(NOLOCK)
JOIN r_Emps a WITH(NOLOCK) ON a.EmpID = m.EmpID
JOIN r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID
  WHERE (m.DocDate > GETDATE() OR m.DocDate = (SELECT CAST(GETDATE() AS DATE) ) )
    AND m.StateCode = 203
ORDER BY 1


/*
DECLARE @ChID INT = 101491177

UPDATE m
  SET m.StateCode = 120
  FROM at_t_IORes m
	WHERE m.ChID = @ChID

SELECT m.ChID 
	  ,a.EmpID AS '���'
      ,a.EmpName AS '���������'
	  ,m.StockID AS '�����'
	  ,m.CompID AS '��-���'
	  ,rc.CompName AS '��� ��-���' 
	  ,CAST(m.DocDate AS DATE) AS '����'
	  ,m.StateCode AS '������'
FROM at_t_IORes m WITH(NOLOCK)
JOIN r_Emps a WITH(NOLOCK) ON a.EmpID = m.EmpID
JOIN r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID
WHERE m.ChID = @ChID
*/