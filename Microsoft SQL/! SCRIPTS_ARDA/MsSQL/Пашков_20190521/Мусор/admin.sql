
принят
//Выдает все базы данных на сервере
SELECT name FROM sys.databases
//Выдает все таблицы в Базе данных
SELECT * FROM sys.objects WHERE type in (N'U')

SELECT * FROM m1.sys.sysxsrvs

SELECT * FROM m1.sys.sysobjvalues


SELECT * FROM    sys.servers

SELECT * FROM m1.sys.sysobjvalues where valclass = 28

SELECT object_definition(OBJECT_ID('sys.credentials'))

SELECT    co.id AS credential_id,    co.name,    convert(nvarchar(4000), ov.value) as credential_identity,    co.created as create_date,    co.modified as modify_date,    n.name as target_type,    r.indepid AS target_id   FROM master.sys.sysclsobjs co   LEFT JOIN master.sys.sysobjvalues ov ON ov.valclass = 28 AND ov.objid = co.id AND ov.subobjid = 0 AND ov.valnum = 1   LEFT JOIN master.sys.syssingleobjrefs r ON r.depid = co.id AND r.class = co.intprop AND r.depsubid = 0    LEFT JOIN sys.syspalvalues n ON n.class = 'SRCL' AND n.value = co.intprop  -- WHERE co.class = 57   -- AND has_access('CR', 0) = 1  

select pwdencrypt('foo')

SELECT * FROM m1.sys.sysxsrvs s
	LEFT JOIN sys.sysobjvalues v ON v.valclass = 25 AND v.objid = s.id AND v.subobjid = 1 AND v.valnum = 0	-- SRV_DATASRC
	LEFT JOIN sys.sysobjvalues l ON l.valclass = 25 AND l.objid = s.id AND l.subobjid = 2 AND l.valnum = 0	-- SRV_LOCATION
	WHERE s.id = 0 OR has_access('SR', s.id) = 1