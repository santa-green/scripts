/*
1. Для того чтобы добавить IBAN в базу Elit нужно изменить длину нескольких
полей в дизайнере баз данных: AccountCC, CompAccountCC, AccountAC, CompAccountAC.
2. Изменить размер полей в самом Бизнесе через Дизайнер.
*/
DECLARE @table_name VARCHAR(200), @SQL_query NVARCHAR(MAX)
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS m
JOIN z_Tables zt ON m.TABLE_NAME = zt.TableName
WHERE TABLE_NAME NOT LIKE 'av%' AND TABLE_NAME NOT LIKE 'vc%' 
  --AND COLUMN_NAME like '%IBANCode%'
  AND (COLUMN_NAME like '%AccountCC%'
   OR COLUMN_NAME like '%CompAccountCC%'
   OR COLUMN_NAME like '%AccountAC%'
   OR COLUMN_NAME like '%CompAccountAC%')
  AND TABLE_NAME NOT IN ('r_OursAC'
						--Список исключений (вьюхи, буффер и т.д.)
						,'c_CompRecBuffer', 'p_EWris', 'p_EWrisE')
  --AND TABLE_NAME IN ('r_CompsAC','r_CompsCC','r_OursCC','t_MonRec')

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @table_name
WHILE @@FETCH_STATUS = 0	 
BEGIN
		SELECT @SQL_query = REPLACE(m.definition,'CREATE TRIGGER [dbo].[a_rOursAC_IBAN_check_IU] ON [dbo].[r_OursAC]','ALTER TRIGGER [dbo].[a_' + REPLACE(@table_name,'_','') + '_IBAN_check_IU] ON [dbo].[' + @table_name + ']')
		FROM sys.sql_modules m
		INNER JOIN sys.objects o
		ON m.object_id = o.object_id
		WHERE o.name = 'a_rOursAC_IBAN_check_IU'

		--SELECT @SQL_query

	    EXEC sp_executesql @SQL_query
	FETCH NEXT FROM CURSOR1 INTO @table_name
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

--CREATE TRIGGER [dbo].[a_rOursAC_IBAN_check_IU] ON [dbo].[r_OursAC]
/*
p_EWris
at_c_CompExpImport
p_EWris
b_zInBA
BEGIN TRAN;

DECLARE @ChID INT
/*DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT ChID FROM r_OursAC

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ChID
WHILE @@FETCH_STATUS = 0	 
BEGIN
	
	UPDATE r_OursAC SET AccountAC = dbo.af_IBAN_CreateUA(BankID, AccountAC) WHERE dbo.af_IBAN_CreateUA(BankID, AccountAC) IS NOT NULL AND AccountAC NOT LIKE 'UA%' AND ChID = @ChID
		
	FETCH NEXT FROM CURSOR1 INTO @ChID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1*/


DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT ChID FROM r_OursCC

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ChID
WHILE @@FETCH_STATUS = 0	 
BEGIN
	
	UPDATE r_OursCC SET AccountCC = dbo.af_IBAN_CreateUA(BankID, AccountCC) WHERE dbo.af_IBAN_CreateUA(BankID, AccountCC) IS NOT NULL AND AccountCC NOT LIKE 'UA%' AND ChID = @ChID
		
	FETCH NEXT FROM CURSOR1 INTO @ChID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1
--UPDATE c_CompExp SET AccountAC = dbo.af_IBAN_CreateUA( (SELECT TOP 1 BankID FROM r_OursCC m WHERE m.AccountCC = AccountAC), AccountAC) WHERE dbo.af_IBAN_CreateUA((SELECT TOP 1 BankID FROM r_OursCC m WHERE m.AccountCC = AccountAC), AccountAC) IS NOT NULL
--UPDATE r_OursCC SET AccountCC = dbo.af_IBAN_CreateUA(BankID, AccountCC) WHERE dbo.af_IBAN_CreateUA(BankID, AccountCC) IS NOT NULL

SELECT * FROM r_OursCC
WHERE LEN(AccountCC) < 29
ROLLBACK TRAN;

*/
/*
UPDATE r_CompsCC SET CompAccountCC = dbo.af_IBAN_CreateUA(BankID, CompAccountCC) WHERE dbo.af_IBAN_CreateUA(BankID, CompAccountCC) IS NOT NULL AND CompAccountCC NOT LIKE 'UA%'

SELECT * FROM r_GAccs


SELECT * FROM z_Tables ORDER BY 3;

SELECT * FROM r_OursAC
SELECT * FROM b_BankExpCC
SELECT * FROM b_BankPayCC
SELECT * FROM p_EWrisE
SELECT * FROM b_zInBC
SELECT * FROM b_BankRecCC
SELECT * FROM p_EWri
SELECT * FROM p_EWris
SELECT * FROM r_CompsCC
SELECT * FROM b_zInC

exec sp_indexes_rowset 'b_BankPayCC'
exec sp_helpindex 'b_BankPayCC'


begin tran

ALTER TABLE b_BankPayCC ALTER COLUMN CompAccountCC varchar(42) NOT NULL


update z_FieldsRep set DataType = 1, SQLType = 167 where FieldName = 'CompAccountCC'


update z_Fields set DataSize = c.Length, DBDefault = '' from z_Fields f, syscolumns c where f.FieldName = 'CompAccountCC' and c.name = f.FieldName and f.TableCode = 14010001 AND c.id = object_id('b_BankPayCC')

update v_Fields set DataType = 1 where fieldname = 'CompAccountCC'
update v_UFields set DataType = 1 where fieldname = 'CompAccountCC'
commit


r_OursCC
b_BankExpCC
b_BankPayCC
p_EWrisE
b_zInBC
b_BankRecCC
p_EWri
p_EWris
r_CompsCC
b_BankRecCC
b_zInC
b_BankPayCC
b_BankExpCC

DECLARE @iban varchar(34)
DECLARE @num INT = 10

WHILE (@num <= 99)
BEGIN
set @iban = 'UA003057490000002600030539301'

    IF @num >= 10
    BEGIN
		SET @iban = REPLACE(@iban,'UA00',(SELECT 'UA' + CAST(@num AS VARCHAR(2)) ))
    END;
	ELSE
	BEGIN
		SET @iban = REPLACE(@iban,'UA00',(SELECT 'UA0' + CAST(@num AS VARCHAR(1)) ))
	END;
	
	
	SET @iban = REPLACE(SUBSTRING(@iban + SUBSTRING(@iban,0,5),5,100),'UA','3010')
    
	IF (SELECT cast(@iban as numeric(34,0)) % 97) = 1
	BEGIN
		SELECT @iban
	END;
		
	
	set @num = @num + 1
END;


SELECT      3808050000000026007440111301055 % 97
SELECT 98 - 3808050000000026007440111301000 % 97

SELECT LEFT('1234567890',2)

SELECT *, dbo.af_IBAN_CreateUA(BankID, AccountCC) FROM r_OursCC
WHERE dbo.af_IBAN_CreateUA(BankID, AccountCC) IS NOT NULL



SELECT * FROM c_CompExp a, deleted d WHERE a.AccountAC = d.AccountAC AND a.OurID = d.OurID
TRel2_Upd_r_OursAC

COLUMNS_UPDATED
[a_atzContracts_CheckValues_IU]
*/