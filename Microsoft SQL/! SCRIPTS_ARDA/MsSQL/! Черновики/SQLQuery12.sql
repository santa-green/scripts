  SELECT a.fID, a.fType, a.exid, b.CompID, a.fName, a.fShortName, b.CompShort, a.fAddress, b.[Address]  FROM DS_FACES a
  JOIN [S-SQL-D4].Elit.dbo.r_Comps b ON cast(a.exid as int) = b.CompID 
  where
  ISNUMERIC(exid) = 1
  and exid like '0%'
  and a.fName <> b.CompShort

  EXCEPT

SELECT a.fID, a.fType, a.exid, b.CompID, a.fName, a.fShortName, b.CompShort, a.fAddress, b.[Address]  FROM DS_FACES a
  JOIN [S-SQL-D4].Elit.dbo.r_Comps b ON 
  a.exid = ('000' + cast(b.CompID AS varchar (max))) 
  OR a.exid = ('00' + cast(b.CompID AS varchar (max)))
  OR a.exid = ('0' + cast(b.CompID AS varchar (max)))
  where a.fName <> b.CompShort 
  
  order by a.exid



  --SELECT exid, cast(exid as int), * FROM DS_FACES WHERE fID in (1094783, 1094784)
  --SELECT exid, * FROM DS_FACES WHERE ISNUMERIC(exid) = 1
  SELECT * FROM [s-sql-d4].[elit].dbo.r_comps WHERE compid like '%28000%'