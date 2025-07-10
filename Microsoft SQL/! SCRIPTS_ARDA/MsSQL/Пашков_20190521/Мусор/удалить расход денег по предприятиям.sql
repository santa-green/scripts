SELECT * FROM c_CompExp
where DocDate = '2018-02-10'
and CodeID1 in (2032,30,50)
and CodeID3 in (6)
and OurID in (1,2,3,4,5,11)


SELECT SUM(SumAC) FROM c_CompExp
where DocDate = '2018-02-10'
and CodeID1 in (2032,30,50)
and CodeID3 in (6)
and OurID in (1,2,3,4,5,11)

BEGIN TRAN


delete c_CompExp
where DocDate = '2018-02-10'
and CodeID1 in (2032,30,50)
and CodeID3 in (6)
and OurID in (1,2,3,4,5,11)


ROLLBACK TRAN

--TRel3_Del_c_CompExp

--SELECT * FROM dbo.zf_GetOpenAges(GETDATE())