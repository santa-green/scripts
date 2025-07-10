declare @i int , @crid int
set @i= 30
set @crid = 151
CREATE TABLE [dbo].[#_zRep](
	[DocDate] [smalldatetime] NOT NULL,
	[Z_rep] [numeric](38, 9) NULL,
	[TSumCC_wt] [numeric](38, 9) NULL,
	[Bok] [numeric](38, 9) NULL,
	[Vozvrat] [numeric](38, 9) NULL
)

while @i > 0
begin
insert #_zRep
select DocDate ,SUM (SumCC_wt) as Z_rep ,(select SUM (TSumCC_wt)  from t_Sale where  CRID = @crid and DocDate = dbo.zf_GetDate (GETDATE ()-@i) group by DocDate )as TSumCC_wt ,
 (ISNULL (SUM (SumCC_wt),0)-(select SUM (TSumCC_wt)  from t_Sale where  CRID = @crid and DocDate = dbo.zf_GetDate (GETDATE ()-@i) group by DocDate )
 +(select ISNULL (SUM (TSumCC_wt),0)from t_CRRet where  CRID = @crid and DocDate = dbo.zf_GetDate (GETDATE ()-@i)) ) as Bok ,
 (select ISNULL (SUM (TSumCC_wt),0)from t_CRRet where  CRID = @crid and DocDate = dbo.zf_GetDate (GETDATE ()-@i)) as Vozvrat
  from t_zRep where CRID = @crid and DocDate = dbo.zf_GetDate (GETDATE ()-@i) group by DocDate

set @i = @i-1
end 

select * from #_zRep  order by DocDate
drop table #_zRep



