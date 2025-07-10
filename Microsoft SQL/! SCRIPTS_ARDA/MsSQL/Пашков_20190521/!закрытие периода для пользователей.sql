--закрытие переиода для пользователей

begin tran

USE ElitR

--первый день текущего месяца
DECLARE @BDate SMALLDATETIME = DATEADD(month,DATEDIFF(month,0,GETDATE()),0)
SELECT @BDate

DECLARE @UserNameTable table(UserName varchar(250) NULL) 
insert into @UserNameTable select UserName from r_Users
	where UserName in (
--Исключить следующих пользователей

'rnu', -- Ровнягина Наталия Юрьевна
'bos', -- Бильдина Ольга Станиславовна
'const\pashkovv', -- Пашков Владимир Николаевич
'gdn1', -- Ганцев Денис Николаевич
'giv3', -- Кельман (Голубенко) Ирина Викторовна
'GMSSync', -- System Administrator для синхронизации
'ioa', -- Исаева Ольга Александровна
'kkm0', -- Коробченко Кирилл Михайлович 
'kvn1', -- Кушнарёва Виктория Николаевна
'pvm0', -- Пашков Владимир Николаевич
'sa', -- System Administrator самый главный
'sao' -- Шевченко Анна Олеговна

)

SELECT * FROM r_Users where UserName not in ( SELECT * FROM @UserNameTable) ORDER BY UseOpenAge

update r_Users 
set BDate = @BDate, UseOpenAge = 1
where UserName  not in ( SELECT * FROM @UserNameTable)

SELECT * FROM r_Users where UserName  not in ( SELECT * FROM @UserNameTable) ORDER BY UserName


rollback tran



