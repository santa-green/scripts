SELECT * FROM D_Options where Comment like '%���%'

SELECT * FROM D_Options where OptionID = 183
SELECT * FROM DS_Attributes where AttrID = 183


--��������� ����������� ������ � �����������
--����� ��� �������� �������� (�����): 0(+) � ���, 1 � ����������� ������ � �����������, 2 - ����������� GPS
EXEC [dbo].[DMT_Set_Option]
	@OptionID  = 183		--AttrID  		int,  			-- ��� ����� 
	,@Val      = 0		-- 		nvarchar(255),  -- ��������� �������� �����
	,@Comment  = null	--		nvarchar(255),  -- �������� �����
	,@Ident    = null	--		nvarchar(255),  -- ������������� �����
	,@Valint   = 0		--		integer         -- ������������� �������� �����


--�������� ����������� ������ � �����������
--����� ��� �������� �������� (�����): 0(+) � ���, 1 � ����������� ������ � �����������, 2 - ����������� GPS
EXEC [dbo].[DMT_Set_Option]
	@OptionID  = 183		--AttrID  		int,  			-- ��� ����� 
	,@Val      = 1		-- 		nvarchar(255),  -- ��������� �������� �����
	,@Comment  = null	--		nvarchar(255),  -- �������� �����
	,@Ident    = null	--		nvarchar(255),  -- ������������� �����
	,@Valint   = 1	







BEGIN TRAN
	
	SELECT * FROM D_Options where OptionID = 183
	SELECT * FROM DS_Attributes where AttrID = 183


	EXEC [dbo].[DMT_Set_Option]
		@OptionID  = 183		--AttrID  		int,  			-- ��� ����� 
		,@Val      = 0		-- 		nvarchar(255),  -- ��������� �������� �����
		,@Comment  = null	--		nvarchar(255),  -- �������� �����
		,@Ident    = null	--		nvarchar(255),  -- ������������� �����
		,@Valint   = 0		--		integer         -- ������������� �������� �����

	SELECT * FROM D_Options where OptionID = 183
	SELECT * FROM DS_Attributes where AttrID = 183

ROLLBACK TRAN

/*

*/