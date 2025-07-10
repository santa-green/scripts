-- Отключенные триггера
SELECT
  o1.name AS TableName,
  o2.name AS TriggerName,
  CASE OBJECTPROPERTY(o2.id, 'ExecIsTriggerDisabled')
    WHEN 0 THEN 'ENABLED'
    WHEN 1 THEN 'DISABLED'
  END
as status_triggera
FROM
  sysobjects o1
  INNER JOIN sysobjects o2 ON
  o1.id = o2.parent_obj
WHERE
  o2.xtype = 'TR'
  and  OBJECTPROPERTY(o2.id, 'ExecIsTriggerDisabled') = 1 --условие отключенного триггера