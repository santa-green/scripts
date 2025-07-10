SELECT * FROM D_Options where Comment like '%лог%'

SELECT * FROM D_Options where OptionID = 183
SELECT * FROM DS_Attributes where AttrID = 183


--ОТКЛЮЧИТЬ логирование работы с документами
--Вести лог действий тогпреда (маска): 0(+) – нет, 1 – логирование работы с документами, 2 - логирование GPS
EXEC [dbo].[DMT_Set_Option]
	@OptionID  = 183		--AttrID  		int,  			-- Код опции 
	,@Val      = 0		-- 		nvarchar(255),  -- текстовое значение опции
	,@Comment  = null	--		nvarchar(255),  -- описание опции
	,@Ident    = null	--		nvarchar(255),  -- идентификатор опции
	,@Valint   = 0		--		integer         -- целочисленное значение опции


--Включить логирование работы с документами
--Вести лог действий тогпреда (маска): 0(+) – нет, 1 – логирование работы с документами, 2 - логирование GPS
EXEC [dbo].[DMT_Set_Option]
	@OptionID  = 183		--AttrID  		int,  			-- Код опции 
	,@Val      = 1		-- 		nvarchar(255),  -- текстовое значение опции
	,@Comment  = null	--		nvarchar(255),  -- описание опции
	,@Ident    = null	--		nvarchar(255),  -- идентификатор опции
	,@Valint   = 1	







BEGIN TRAN
	
	SELECT * FROM D_Options where OptionID = 183
	SELECT * FROM DS_Attributes where AttrID = 183


	EXEC [dbo].[DMT_Set_Option]
		@OptionID  = 183		--AttrID  		int,  			-- Код опции 
		,@Val      = 0		-- 		nvarchar(255),  -- текстовое значение опции
		,@Comment  = null	--		nvarchar(255),  -- описание опции
		,@Ident    = null	--		nvarchar(255),  -- идентификатор опции
		,@Valint   = 0		--		integer         -- целочисленное значение опции

	SELECT * FROM D_Options where OptionID = 183
	SELECT * FROM DS_Attributes where AttrID = 183

ROLLBACK TRAN

/*

*/