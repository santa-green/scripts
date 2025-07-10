DECLARE @Table VARCHAR(256) = 't_SaleD',
		@Curr_head INT = 2,
		@Info INT = 1 -- @Info = 0 Без информации о типе полей
					  -- @Info = 1 С информацией о типах полей
IF @Info = 1
BEGIN
SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @Table
END		

DECLARE @col VARCHAR(50)
		,@pos INT
		,@max INT = (SELECT MAX(ORDINAL_POSITION) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @Table)
		,@res VARCHAR(MAX) = ''

DECLARE True_SSMSBoost CURSOR FOR
SELECT DISTINCT ORDINAL_POSITION, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @Table
ORDER BY ORDINAL_POSITION
    
    OPEN True_SSMSBoost
    FETCH NEXT FROM True_SSMSBoost INTO @pos,@col
    WHILE @@FETCH_STATUS = 0
    BEGIN
      IF @max != @pos
      SET @res = @res + @col + ', '  
      ELSE
      SET @res = @res + @col 	   
      
      FETCH NEXT FROM True_SSMSBoost INTO @pos,@col
    END
    CLOSE True_SSMSBoost
    DEALLOCATE True_SSMSBoost  
    
SELECT @res All_Headers

IF @Curr_head != 0
BEGIN
SELECT COLUMN_NAME Curr_head
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @Table AND ORDINAL_POSITION = @Curr_head
END