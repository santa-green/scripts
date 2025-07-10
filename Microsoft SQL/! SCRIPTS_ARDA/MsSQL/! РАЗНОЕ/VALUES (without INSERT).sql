--https://modern-sql.com/use-case/select-without-from
select *
from (
VALUES ( CURRENT_TIMESTAMP     )
,      ( CURRENT_TIMESTAMP - 1 )
) t1 (c1)