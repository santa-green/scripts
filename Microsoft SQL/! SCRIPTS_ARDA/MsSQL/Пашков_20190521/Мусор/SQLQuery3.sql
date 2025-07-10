SELECT dbo.tf_GetDCardInfo(1011, 13012, '2220000000024', 1, 0)
SELECT dbo.tf_GetDCardInfo(1011, 13012, '2220000000079', 1, 0)

SELECT * FROM dbo.tf_DocDCards(1011, 13012, 0)

EXEC t_SaleFindDCard 'GMS Internal'

declare @p5 int
set @p5=NULL
declare @p6 varchar(8000)
set @p6=NULL
exec t_SaleDCardEnter 1011,13012,'380676355357',0,@p5 output,@p6 output
select @p5, @p6