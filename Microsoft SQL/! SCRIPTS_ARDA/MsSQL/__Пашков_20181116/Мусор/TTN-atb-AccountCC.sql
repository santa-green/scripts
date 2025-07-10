SELECT MIN(ChID) ChID, CAST(Notes + ' - ' + dbo.af_GetFiltered(AccountCC) AS VARCHAR(250)) AS AccountCC, MAX(CAST(DefaultAccount AS TINYINT))
FROM dbo.r_OursCC WITH(NOLOCK)
WHERE ISNULL(Notes, '') <> '' AND OurID = 1
AND (BankID IN (305749, 307123, 351005) OR OurID != 1)
GROUP BY Notes + ' - ' + dbo.af_GetFiltered(AccountCC)
ORDER BY 3 DESC, 2 ASC