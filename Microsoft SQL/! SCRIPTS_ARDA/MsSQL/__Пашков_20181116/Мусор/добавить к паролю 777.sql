/*
BEGIN TRAN

--добавить к паролю 777
SELECT * FROM r_Opers where OperName not in ('181','201','222','301','302','401','501','502')

update r_Opers
set OperLockPwd = OperLockPwd + '777'
FROM r_Opers where OperName not in ('181','201','222','301','302','401','501','502')

SELECT * FROM r_Opers where OperName not in ('181','201','222','301','302','401','501','502')

ROLLBACK TRAN
*/

BEGIN TRAN

--убрать с пароля 777
SELECT * FROM r_Opers where OperName not in ('181','201','222','301','302','401','501','502')

update r_Opers
set OperLockPwd = SUBSTRING (OperLockPwd, 1, LEN(OperLockPwd)-3)
FROM r_Opers where OperName not in ('181','201','222','301','302','401','501','502')

SELECT * FROM r_Opers where OperName not in ('181','201','222','301','302','401','501','502')

ROLLBACK TRAN


