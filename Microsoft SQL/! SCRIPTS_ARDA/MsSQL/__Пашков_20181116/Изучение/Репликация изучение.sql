SELECT * FROM z_ReplicaPubs --Объекты репликации: Публикации
SELECT * FROM z_ReplicaTables --Объекты репликации: Публикации - Статьи
SELECT * FROM z_ReplicaFilters --Объекты репликации: Фильтры
SELECT * FROM z_ReplicaSubs --Объекты репликации: Подписки
SELECT * FROM z_ReplicaPCs --Объекты репликации: Подписки - Подписчики
SELECT * FROM z_ReplicaEvents --Объекты репликации: События
SELECT * FROM z_ReplicaOut --Объекты репликации: Исходящие
SELECT * FROM z_ReplicaIn --Объекты репликации: Входящие
SELECT * FROM z_ReplicaReplace --Объекты репликации: Замены
SELECT * FROM z_ReplicaConfigEvents --Объекты репликации: События конфигурации
SELECT * FROM z_ReplicaConfigOut --Объекты репликации: Исходящие конфигурации
SELECT * FROM z_ReplicaConfigSent --Объекты репликации: Отправленные конфигурации
SELECT * FROM z_ReplicaConfigIn --Объекты репликации: Входящие конфигурации
SELECT * FROM z_ReplicaFields --Объекты репликации: Поля


SELECT * FROM z_ReplicaPubs where ReplicaPubCode = 12 --Объекты репликации: Публикации
SELECT * FROM z_ReplicaTables  where ReplicaPubCode = 12--Объекты репликации: Публикации - Статьи
SELECT * FROM z_ReplicaFilters  where ReplicaPubCode = 12--Объекты репликации: Фильтры
SELECT * FROM z_ReplicaSubs  where ReplicaPubCode = 12--Объекты репликации: Подписки
SELECT * FROM z_ReplicaPCs where ReplicaSubCode in (15,16)--Объекты репликации: Подписки - Подписчики
SELECT * FROM z_ReplicaFields  where ReplicaPubCode = 12 --Объекты репликации: Поля
SELECT * FROM z_ReplicaReplace --Объекты репликации: Замены

SELECT * FROM z_ReplicaConfigEvents --Объекты репликации: События конфигурации
SELECT * FROM z_ReplicaConfigOut --Объекты репликации: Исходящие конфигурации
SELECT * FROM z_ReplicaConfigSent --Объекты репликации: Отправленные конфигурации
SELECT * FROM z_ReplicaConfigIn --Объекты репликации: Входящие конфигурации



SELECT * FROM z_ReplicaEvents   where ReplicaPubCode = 12--Объекты репликации: События
SELECT * FROM z_ReplicaOut where ReplicaSubCode in (15,16)--Объекты репликации: Исходящие
SELECT * FROM z_ReplicaIn --Объекты репликации: Входящие