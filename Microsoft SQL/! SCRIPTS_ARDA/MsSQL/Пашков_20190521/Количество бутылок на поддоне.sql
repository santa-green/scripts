	--������� ���������� ��
	IF OBJECT_ID (N'tempdb..#ProdsPalet', N'U') IS NOT NULL DROP TABLE #ProdsPalet
	CREATE TABLE #ProdsPalet (Num INT IDENTITY(1,1) NOT NULL ,ProdID INT null, TaxDocDate varchar(250) null, QtyInPalet INT NULL, WidthPalet NUMERIC(21,9))
		
	INSERT #ProdsPalet
	--="union all select "&C4&",'"&�����(D4;"����-��-��")&"',"&H4&","&L4&""
select           30766,'������ Trino ������ 0,5*21 14,8% Design 2013',504,800
union all select 30767,'������ Trino ������ 1*12 14,8% Design 2013',384,800
union all select 28246,'���� �������. ���������� ������ �����, ����������� 0,75*12',480,1000
union all select 28245,'���� �������. ���������� ������ �������, ����������� 0,75*12 ',480,1000
union all select 30497,'����� ���� ��������� 40% 0,5*12',768,1000
union all select 4165,'����� ���� ��������� 40% 0,7*12',840,1000
union all select 4167,'����� ���� ��������� 40% 1,0*12',480,1000
union all select 26135,'����� ���� ����� ��������� ����� 40% New Design Original 0,5*12',1140,1000
union all select 26136,'����� ���� ����� ��������� ����� 40% New Design Original 0,7*12',768,1000
union all select 26137,'����� ���� ����� ��������� ����� 40% New Design Original 0,7*12 � �������',768,1000
union all select 26133,'����� ���� ����� ��������� ����� 40% New Design Original 1,0*12',576,1000
union all select 26139,'����� ���� ����� ��������� ����� 40% New Design Original 1,0*12 � �������',576,1000
union all select 3127,'���� ����� ����������� 1,5*6',504,800
union all select 26168,'���� ����� ����������� 0,75*12 � ������ New',780,1000
union all select 26213,'���� ����� ����������� 0,33*20 � ������ New',1540,1000
union all select 30843,'���� ����� ����������� ����� 0,75*6 New Design',1080,1000
union all select 31878,'���� ����� ����������� 0,33*24 Prestige',3120,1000
union all select 31879,'���� ����� ����������� 0,5*24 Prestige',2016,1000
union all select 31880,'���� ����� ����������� 1,0*12 Prestige',1008,1000
union all select 32143,'����� ������ 40% 0,7*12',600,800
union all select 32142,'����� ������ 40% 0,5*15',825,800
union all select 32144,'����� ������ 40% 1,0*12',336,800

	SELECT * FROM #ProdsPalet
