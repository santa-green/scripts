SELECT FileDesc
FROM z_AppPrints WITH(NOLOCK)
WHERE FileDesc LIKE '��%'
AND AppCode = 21000

SELECT * FROM z_AppPrints