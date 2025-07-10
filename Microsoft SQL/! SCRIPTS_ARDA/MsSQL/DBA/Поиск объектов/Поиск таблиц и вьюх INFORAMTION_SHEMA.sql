SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME like '%COMP%'
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME like '%ALEF_EDI_EMPS%'
SELECT * FROM sys.objects WHERE [name] like 'alef_edi%' ORDER BY modify_date DESC
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME like 'alef_edi%'
SELECT * FROM [s-sql-d4].[elit].sys.triggers where [name] like '%a_tInv_CheckFieldValues_IU%'
SELECT * FROM [s-sql-d4].[elit].sys.objects
SELECT distinct([type]) FROM sys.objects --WHERE [name] like 'alef_edi%'

/*
sys.objects
Contains a row for each user-defined, schema-scoped object that is created within a database, including natively compiled scalar user-defined function.
modify_date (datetime): Date the object was last modified by using an ALTER statement. If the object is a table or a view, modify_date also changes when an index on the table or view is created or altered.
*/

select * from dbo.sysobjects where parent_obj  = 329768232 ORDER BY xtype DESC
SELECT * FROM [s-sql-d4].[elit].sys.triggers where [name] like '%a_tInv_CheckFieldValues_IU%'

--Найти текст триггера (там и таблицу).
SELECT * FROM syscomments WHERE [text] like '%a_tInv_CheckFieldValues_IU%'

--Найти все триггера в таблице.
SELECT 
 t.name AS TableName,
 tr.name AS TriggerName  
FROM sys.triggers tr
INNER JOIN sys.tables t ON t.object_id = tr.parent_id
WHERE 
t.name in ('t_inv');

--все триггеры во всех таблицах и во всех представлениях.
 ;WITH
        TableTrigger
        AS
        (
            Select 
                Object_Kind = 'Table',
                Sys.Tables.Name As TableOrView_Name , 
                Sys.Tables.Object_Id As Table_Object_Id ,
                Sys.Triggers.Name As Trigger_Name, 
                Sys.Triggers.Object_Id As Trigger_Object_Id 
            From Sys.Tables 
            INNER Join Sys.Triggers On ( Sys.Triggers.Parent_id = Sys.Tables.Object_Id )
            Where ( Sys.Tables.Is_MS_Shipped = 0 )
        ),
        ViewTrigger
        AS
        (
            Select 
                Object_Kind = 'View',
                Sys.Views.Name As TableOrView_Name , 
                Sys.Views.Object_Id As TableOrView_Object_Id ,
                Sys.Triggers.Name As Trigger_Name, 
                Sys.Triggers.Object_Id As Trigger_Object_Id 
            From Sys.Views 
            INNER Join Sys.Triggers On ( Sys.Triggers.Parent_id = Sys.Views.Object_Id )
            Where ( Sys.Views.Is_MS_Shipped = 0 )
        ),
        AllObject
        AS
        (
            SELECT * FROM TableTrigger

            Union ALL

            SELECT * FROM ViewTrigger
        )


    Select 
        * 
    From AllObject WHERE Trigger_Name like '%a_tInv_CheckFieldValues_IU%'
    Order By Object_Kind, Table_Object_Id 