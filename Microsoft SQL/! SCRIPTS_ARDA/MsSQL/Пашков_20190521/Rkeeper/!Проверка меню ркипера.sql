USE ElitR

	EXECUTE AS LOGIN = 'pvm0' -- ��� ������� OPENROWSET('Microsoft.ACE.OLEDB.12.0'
	GO
	--REVERT

IF 1=1
BEGIN
	--��������� ���� ������� �� ������� menu_R_keeper.xlsx
	IF OBJECT_ID (N'tempdb..#Menu', N'U') IS NOT NULL DROP TABLE #Menu
	SELECT * 
	 INTO #Menu	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\R_keeper\menu_R_keeper.xlsx' , 'select * from [����1$]') as ex
	WHERE  ������ = '��������'

	--��������� ������ ���� ������� �� ������� menu_R_keeper.xlsx
	IF OBJECT_ID (N'tempdb..#Menu_old', N'U') IS NOT NULL DROP TABLE #Menu_old
	SELECT * 
	 INTO #Menu_old	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\R_keeper\menu_R_keeper_old.xlsx' , 'select * from [����1$]') as ex
	WHERE  ������ = '��������'

--������ ������� ���������� � �������� ����
SELECT * FROM (
	SELECT * FROM #Menu_old
	except 
	SELECT * FROM #Menu
) ex
union all
SELECT * FROM (
	SELECT * FROM #Menu
	except
	SELECT * FROM #Menu_old
) ex2
ORDER BY 1

	--��������� ���� �� ����
	IF OBJECT_ID (N'tempdb..#Baze', N'U') IS NOT NULL DROP TABLE #Baze
	SELECT * 
	 INTO #Baze	
	--SELECT * 
	FROM (
			SELECT [������� ���], ��������, ProdID ,ProdName,baze_��������, [baze_�������� ������], [baze_������ ��������],[���� �� �������], 
			str_��������, [str_�������� ������], [str_������� ��������],[str_������ ��������], menu_��������, [menu_�������� ������], [menu_������� ��������],[menu_������ ��������],
			[��-���������#��������] p71, [��-���������#��������] �2_76,  [��-���������#������ ��������] �1_77 ,[������],[��������� ������]
			--, ISNULL((SELECT top 1 20 FROM r_Prods p WHERE p.ProdID = baze.ProdID and p.PGrID2 = 40014),0) [baze_���]
			, ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = baze.ProdID),0) [baze_�����]
			--������������, ISNULL((SELECT top 1 20 FROM r_Prods p WHERE p.ProdID = baze.ProdID and p.PGrID2 = 40014),0) + ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = baze.ProdID),0) [baze_�����]
			,Norma5, Norma4
			FROM (
				SELECT [������� ���], [��������],[���� �� �������], 
				[��������] 'str_��������',[�������� ������] 'str_�������� ������',[������� ��������] 'str_������� ��������',[������ ��������] 'str_������ ��������', 
				case when ISNUMERIC(REPLACE (REPLACE ([��������],',','.'),'�','')) = 1 then CAST(REPLACE (REPLACE ([��������],',','.'),'�','') AS NUMERIC(21,9)) else 0 end 'menu_��������',
				case when ISNUMERIC(REPLACE (REPLACE ([�������� ������],',','.'),'�','')) = 1 then CAST(REPLACE (REPLACE ([�������� ������],',','.'),'�','') AS NUMERIC(21,9)) else 0 end 'menu_�������� ������',
				case when ISNUMERIC(REPLACE (REPLACE ([������� ��������],',','.'),'�','')) = 1 then CAST(REPLACE (REPLACE ([������� ��������],',','.'),'�','') AS NUMERIC(21,9)) else 0 end 'menu_������� ��������',
				case when ISNUMERIC(REPLACE (REPLACE ([������ ��������],',','.'),'�','')) = 1 then CAST(REPLACE (REPLACE ([������ ��������],',','.'),'�','') AS NUMERIC(21,9)) else 0 end 'menu_������ ��������'
				--[�������� ������], case when ISNUMERIC([�������� ������]) = 1 then CAST(REPLACE ([�������� ������],',','.') AS NUMERIC(21,9)) else 0 end '�������� ������',
				--[������ ��������], case when ISNUMERIC([������ ��������]) = 1 then CAST(REPLACE ([������ ��������],',','.') AS NUMERIC(21,9)) else 0 end '������ ��������'
				,case when [��-���������#��������] like '%�������%' then 1 else 0 end '��-���������#��������'
				,case when [��-���������#��������] like '%�������%' then 1 else 0 end '��-���������#��������'
				,case when [��-���������#������ ��������] like '%�������%' then 1 else 0 end '��-���������#������ ��������'
				,[������],[��������� ������]
				FROM #Menu) menu
			FULL JOIN  (SELECT p.ProdID, p.ProdName 
						, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 71 and  mp.InUse = 1) 'baze_��������'
						, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 76 and  mp.InUse = 1) 'baze_�������� ������'
						, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 77 and  mp.InUse = 1) 'baze_������ ��������'
						,Norma5, Norma4
						FROM r_Prods p where p.ProdID in (SELECT ProdID FROM r_ProdMP mp where mp.PLID in (71,76,77) and  mp.InUse = 1)
						) baze on baze.ProdID = menu.[������� ���] 
		) s1
END

/*
SELECT * FROM #Baze WHERE ProdID in (607286)
SELECT * FROM #Baze WHERE ProdName like '%���%'
*/

IF EXISTS(SELECT TOP 1 1 FROM #Baze WHERE [������� ���] is null) 
BEGIN
	SELECT '������ ������� ����� ���� � �������' '��������'
	SELECT * FROM #Baze WHERE [������� ���] is null ORDER BY ProdName
END
--SELECT distinct ProdID, PLID,(SELECT ProdName FROM r_Prods p where p.ProdID = mp.ProdID) ProdName FROM ElitR.dbo.r_ProdMP mp
--where PLID in (71,76,77) and InUse = 1 and Notes not in (SELECT [������� ���] FROM #Menu)
--ORDER BY 3,2

IF EXISTS(SELECT TOP 1 1 FROM #Baze WHERE (ProdID IS NULL  and (p71 + �2_76 + �1_77) > 0 )) 
BEGIN
	SELECT '������ ������� �� ������ ���� � �������' '��������'
	SELECT * FROM #Baze WHERE (ProdID IS NULL  and (p71 + �2_76 + �1_77) > 0 )
END

IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE
	(CASE WHEN baze_�������� IS NULL THEN 0 ELSE 1 END) <>  p71 --�������� ������ � ������� �� ����� ��������� � ����
	OR 
	(CASE WHEN [baze_�������� ������] IS NULL THEN 0 ELSE 1 END) <>  �2_76 --�������� ������ � ������� �� ����� ��������� � ����
	OR 
	(CASE WHEN [baze_������ ��������] IS NULL THEN 0 ELSE 1 END) <>  �1_77 --�������� ������ � ������� �� ����� ��������� � ����
) 
BEGIN
	SELECT '�������� ���������� �������� �����' '��������'
	SELECT * FROM #Baze WHERE
	(CASE WHEN baze_�������� IS NULL THEN 0 ELSE 1 END) <>  p71 --�������� ������ � ������� �� ����� ��������� � ����
	OR 
	(CASE WHEN [baze_�������� ������] IS NULL THEN 0 ELSE 1 END) <>  �2_76 --�������� ������ � ������� �� ����� ��������� � ����
	OR 
	(CASE WHEN [baze_������ ��������] IS NULL THEN 0 ELSE 1 END) <>  �1_77 --�������� ������ � ������� �� ����� ��������� � ����

	--(CASE WHEN baze_�������� IS NULL THEN 0 ELSE 1 END) <>  p71 --�������� ������ � ������� �� ����� ��������� � ����
	--and p71 = 1
	--OR 
	--(CASE WHEN [baze_�������� ������] IS NULL THEN 0 ELSE 1 END) <>  �2_76 --�������� ������ � ������� �� ����� ��������� � ����
	--and �2_76 = 1
	--OR 
	--(CASE WHEN [baze_������ ��������] IS NULL THEN 0 ELSE 1 END) <>  �1_77 --�������� ������ � ������� �� ����� ��������� � ����
	--and �1_77 = 1
END

IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE 
	(menu_�������� <> baze_�������� and p71 = 1 )
	OR 
	([menu_�������� ������] <> [baze_�������� ������] and [menu_�������� ������] <> 0 and �2_76 = 1 )
	OR
	([menu_������� ��������] <> [baze_�������� ������] and [menu_������� ��������] <> 0 and �2_76 = 1 )
	OR 
	([menu_������ ��������] <> [baze_������ ��������] and �1_77 = 1 )
) 
BEGIN
	SELECT '�������� ���' '��������'
	SELECT * FROM #Baze WHERE 
	--(
	(menu_�������� <> baze_�������� and p71 = 1 )
	OR 
	([menu_�������� ������] <> [baze_�������� ������] and [menu_�������� ������] <> 0 and �2_76 = 1 )
	OR
	([menu_������� ��������] <> [baze_�������� ������] and [menu_������� ��������] <> 0 and �2_76 = 1 )
	OR 
	([menu_������ ��������] <> [baze_������ ��������] and �1_77 = 1 )
	--)
	--and [������� ���] in (607511,607516,607784,607977,607525,607980,605490,607023,607979,607853,607972,607809,607993,606388,606385,606386,606387,605675,605169,605172,605173,605174,606132,605176,605162,605163,606336,606769,607678,800362,801307,800360,607651,607650,607653,607652,608025,608026,608027,608028,608029,608019,608020,608021,608022,608023,608024,608030,608013,608014,608015,608016,608017,608018)
END


IF EXISTS(
	SELECT TOP 1 1
	FROM #Baze WHERE [menu_�������� ������] <> [menu_������� ��������] and [baze_�������� ������] is not null
	and [menu_�������� ������] <> 0 and [menu_������� ��������] <> 0
	and [baze_�������� ������]=[menu_�������� ������]
) 
BEGIN
	SELECT '�������� ��� ������ �� 76 ������ ��������' '��������'
	SELECT [������� ���], ��������, ProdID, ProdName, [baze_�������� ������], [���� �� �������], [str_�������� ������], [str_������� ��������],  [menu_�������� ������], [menu_������� ��������], �2_76, ������, [��������� ������], baze_�����, Norma5, Norma4 
	FROM #Baze WHERE [menu_�������� ������] <> [menu_������� ��������] and [baze_�������� ������] is not null
	and [menu_�������� ������] <> 0 and [menu_������� ��������] <> 0
	and [baze_�������� ������]=[menu_�������� ������]
END


IF EXISTS(
	SELECT TOP 1 1 FROM (
	SELECT [������� ���], ��������, [���� �� �������], [��������� ������], ProdID, ProdName, baze_��������, [baze_�������� ������], [baze_������ ��������] 
	,ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = #baze.ProdID),0) baze_�����
	,Norma5
	, case  Norma5 when 0 then '��� - ��� 0' when 1 then '�� ��� - ��� 20' else null end �����5
	,Norma4
	, case  Norma4 when 1 then '�� - ��� 0' when 2 then '��� - ��� 20' else null end �����4
	, case  Norma5 when 1 then 20 else 
		case  Norma4 when 2 then 20  else 0 end
		end + ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = #baze.ProdID),0) baze_�����
	FROM #Baze) s1
	WHERE  baze_����� <>  (case when [��������� ������] = '4 ��� + �����' then 25  when [��������� ������] = '3 ��� 20' then 20 when [��������� ������] = '1 ��� 0' then 0 else null end )
	and ProdID  IS NOT NULL
	and ProdID not in (800890,607045,607044,607046,603101,602688,803096,606044,605917,607025,607640,607029)
) 
BEGIN
	SELECT '�������� ������' '��������'
	SELECT [������� ���], ��������, [���� �� �������], [��������� ������], baze_�����, Norma5, �����5, Norma4, �����4, baze_����� FROM (
	SELECT [������� ���], ��������, [���� �� �������], [��������� ������], ProdID, ProdName, baze_��������, [baze_�������� ������], [baze_������ ��������] 
	,ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = #baze.ProdID),0) baze_�����
	,Norma5
	, case  Norma5 when 0 then '��� - ��� 0' when 1 then '�� ��� - ��� 20' else null end �����5
	,Norma4
	, case  Norma4 when 1 then '�� - ��� 0' when 2 then '��� - ��� 20' else null end �����4
	, case  Norma5 when 1 then 20 else 
		case  Norma4 when 2 then 20  else 0 end
		end + ISNULL((SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5) FROM r_Prods p2 where p2.ProdID = #baze.ProdID),0) baze_�����
	FROM #Baze) s1
	WHERE  baze_����� <>  (case when [��������� ������] = '4 ��� + �����' then 25  when [��������� ������] = '3 ��� 20' then 20 when [��������� ������] = '1 ��� 0' then 0 else null end )
	and ProdID  IS NOT NULL
	and ProdID not in (800890,607045,607044,607046,603101,602688,803096,606044,605917,607025,607640,607029)
	ORDER BY [��������� ������],baze_�����,[���� �� �������],��������
END


IF EXISTS(
	SELECT TOP 1 1 FROM #Menu WHERE [��������] like '%�%' --���� �������� � ������ 200�, ����.
) 
BEGIN
	SELECT '�������� �� ���������� �����' '��������'
	SELECT * FROM #Menu WHERE [��������] like '%�%' --���� �������� � ������ 200�, ����.
END


IF EXISTS(
SELECT TOP 1 1 FROM #Baze WHERE len([��������] ) < 9
) 
BEGIN
	SELECT '�������� �������� �������' '��������'
	SELECT * FROM #Baze WHERE len([��������] ) < 9
END


IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE cast(REPLACE([��������],'#','') as varchar(9)) <> cast(ProdName as varchar(9))
) 
BEGIN
	SELECT '������ �������� ������� ������ 9 ����' '��������'
	SELECT * FROM #Baze WHERE cast(REPLACE([��������],'#','') as varchar(9)) <> cast(ProdName as varchar(9))
END


IF EXISTS(
	SELECT TOP 1 1 FROM #Baze WHERE cast([��������] as varchar(40)) <> cast(ProdName as varchar(40))
) 
BEGIN
	SELECT '������ �������� �������' '��������'
	SELECT * FROM #Baze WHERE cast([��������] as varchar(40)) <> cast(ProdName as varchar(40))
END










--���������� ���� ������� �� ������� menu_R_keeper.xlsx � ������ � ����
--SELECT * FROM #Baze
--WHERE 1=1
--AND
--[������� ���] in (608061)
--ProdID in (605630)
--ProdID IS NULL ORDER BY 2
--(ProdID IS NULL  and (p71 + �2_76 + �1_77) > 0 )--������ ������� �� ������ ���� � �������

--(p71 + �2_76 + �1_77) = 0

--[������� ���] in (SELECT ProdID FROM r_Prods where ProdName like '%����%')
--ProdID in (SELECT ProdID FROM r_Prods where ProdName like '%����%')

/*�������� ���*/
--menu_�������� <> baze_��������  
--OR 
--([menu_�������� ������] <> [baze_�������� ������])
--OR 
--[menu_������ ��������] <> [baze_������ ��������]

/*�������� ������*/
--baze_����� <> (case when [��������� ������] = '4 ��� + �����' then 25  when [��������� ������] = '3 ��� 20' then 20 when [��������� ������] = '1 ��� 0' then 0 else null end )
--and ProdID  IS NOT NULL

--cast([��������] as varchar(40)) <> cast(ProdName as varchar(40))
--and  
--[��������] like '%�%' --���� �������� � ������ 200�, ����.

--/*�������� ���������� �������� �����*/
--(CASE WHEN baze_�������� IS NULL THEN 0 ELSE 1 END) <>  p71 --�������� ������ � ������� �� ����� ��������� � ����
--OR 
--(CASE WHEN [baze_�������� ������] IS NULL THEN 0 ELSE 1 END) <>  �2_76 --�������� ������ � ������� �� ����� ��������� � ����
--OR 
--(CASE WHEN [baze_������ ��������] IS NULL THEN 0 ELSE 1 END) <>  �1_77 --�������� ������ � ������� �� ����� ��������� � ����


--(CASE WHEN baze_�������� IS NULL THEN 0 ELSE 1 END) <>  p71 --�������� ������ � ������� �� ����� ��������� � ����
--and p71 = 1
--OR 
--(CASE WHEN [baze_�������� ������] IS NULL THEN 0 ELSE 1 END) <>  �2_76 --�������� ������ � ������� �� ����� ��������� � ����
--and �2_76 = 1
--OR 
--(CASE WHEN [baze_������ ��������] IS NULL THEN 0 ELSE 1 END) <>  �1_77 --�������� ������ � ������� �� ����� ��������� � ����
--and �1_77 = 1

--ORDER BY [���� �� �������],2

/*
--SELECT ProdID, PLID, PriceMC, (SELECT ProdName FROM r_Prods p where p.ProdID = mp.ProdID) ProdName FROM r_ProdMP mp where mp.PLID = 71 and  mp.InUse = 1
--SELECT ProdID, PLID, PriceMC, (SELECT ProdName FROM r_Prods p where p.ProdID = mp.ProdID) ProdName FROM r_ProdMP mp where mp.PLID = 71 and  mp.InUse = 1
SELECT ProdID, PLID, PriceMC, DepID, (SELECT ProdName FROM r_Prods p where p.ProdID = mp.ProdID) ProdName FROM r_ProdMP mp where mp.PLID = 76 and  mp.InUse = 1
ORDER BY DepID desc

SELECT ProdName,* FROM r_Prods where ProdName like '%����%'

SELECT * FROM r_Prods where ProdID in (601792)
SELECT * FROM r_Prodmp where ProdID in (601792) and PLID = 76 and InUse = 1

--���� � ����
SELECT p.ProdID, p.ProdName 
, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 71 and  mp.InUse = 1) 'baze_��������'
, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 76 and  mp.InUse = 1) 'baze_�������� ������'
, (SELECT mp.PriceMC FROM r_ProdMP mp where mp.ProdID = p.ProdID and mp.PLID = 77 and  mp.InUse = 1) 'baze_������ ��������'
FROM r_Prods p where p.ProdID in (SELECT ProdID FROM r_ProdMP mp where mp.PLID in (71,76,77) and  mp.InUse = 1)
ORDER BY p.ProdID


--SELECT * FROM #Menu where �������� like '%����%'
--ORDER BY 1



--select case when ISNUMERIC('0,1') = 1 then CAST(REPLACE ('3�924,00',',','.') AS NUMERIC(21,9)) else 0 end '��������'
--select case when ISNUMERIC(REPLACE (REPLACE ('3�924,00',',','.'),'�','')) = 1 then 1 else 0 end '��������'
--select case when ISNUMERIC(REPLACE ('3�924','�','')) = 1 then 1 else 0 end '��������'

SELECT * FROM r_PLs where PLID in (71,76,77)
SELECT * FROM r_stocks where PLID in (71,76,77)
SELECT * FROM r_Prods where ProdName like '%�����%'

and prodid not in (607673,607951,607668,607950,607672,607675,607671,607674,607676,607670,607954,607952)

--select cast('������ ����� ���� �������� ���� 2011 ����� 0,75�' as varchar(40))


SELECT (SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p2.PGrID5),p2.PGrID5 FROM r_Prods p2 where p2.ProdID in (803252)
SELECT * FROM at_r_ProdG5 p5 where p5.PGrID5 = 165

SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = 165

SELECT * FROM #Menu




SELECT p.ProdID , p.Prodname
,p.PGrID5
,(SELECT top 1 PGrName5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p.PGrID5) ���������5
,(SELECT top 1 IsExcise * 5 FROM at_r_ProdG5 p5 where p5.PGrID5 = p.PGrID5) ����� 
,p.PGrID2 
,(SELECT top 1 PGrName2 FROM r_ProdG2 p2 where p2.PGrID2 = p.PGrID2) ���������2
,(SELECT top 1 case when p2.PGrID2 in (40014)then 20 else 0 end FROM r_ProdG2 p2 where p2.PGrID2 = p.PGrID2) ���
,(SELECT top 1 [��������� ������]  FROM #Menu m where m.[������� ���] = p.ProdID) [��������� ������]
,p.Norma5
, case  p.Norma5 when 0 then '��� - ��� 0' when 1 then '�� ��� - ��� 20' else null end �����5
,p.Norma4
, case  p.Norma4 when 1 then '�� - ��� 0' when 2 then '��� - ��� 20' else null end �����4
--,(SELECT top 1 PGrName2 FROM r_ProdG2 n5 where n5.Norma5 = p.Norma5) 
FROM r_Prods p where p.ProdID in (605917,607025,607640,607029,803252,800360,801306,803017,803018,605382,800362,801307,803251,800355,803250,607652,607653,607650,607651,607490,607491,607920,607919,607752,607753,607986,607987,607985)


SELECT d.* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE d.ProdID = 800360
and m.DocDate > '2018-05-01'
ORDER BY 1

SELECT distinct [������ ������] FROM #Menu
SELECT *  FROM #Menu where [������ ������] = '31 ��������' and [��-���������#��������] != '��������'
SELECT *  FROM #Menu where [������ ������] is null
SELECT *  FROM #Menu where [������� ���] in (607598,607600,607606,607607,607610,607611,607613,607617,607621,607622,607623,607624,607626,607628,608032,608033,608034,608035,608036,608037,608038,608039,608040,608041,608042,608043,608044,608045,608046,608047,608048,608049,608050,608051,608052,608110,607645,607810,607811,608084,608085,608086,608087,608088,607994)
*/

