--Нарастающие итоги в запросах SQL Server
/*
CREATE TABLE [dbo].[BankAccount](
    [TransactionID] [int] IDENTITY(1,1) NOT NULL,
     [TransactionDateTime] [datetime] NOT NULL CONSTRAINT [DF_BankAccount_TransactionDateTime] DEFAULT(getdate()),
     [Amount] [money] NOT NULL CONSTRAINT [DF_BankAccount_Amount] DEFAULT((0)),
     [TransactionType] [char](1)COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
     [AccountNumber] [varchar](50)COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
CONSTRAINT [PK_BankAccount] PRIMARY KEY CLUSTERED
(
     [TransactionID] ASC
)WITH (PAD_INDEX =OFF, IGNORE_DUP_KEY =OFF) ON [PRIMARY]
) ON [PRIMARY]


insert into [dbo].[BankAccount] ([TransactionDateTime], [Amount],  [TransactionType])
SELECT  '2006-11-03 02:33:42.340', 10000.00,  'a' union all
SELECT  '2006-11-03 02:34:50.467 ',   -500.00,  'a' union all
SELECT  '2006-11-03 02:35:04.857 ',    250.00,  'a' union all
SELECT  '2006-11-03 02:42:19.763 ',   -124.25,  'a'


SELECT 
[TransactionID] ,
 [TransactionDateTime],
 [Amount], 
 [TransactionType],
 [AccountNumber]
 FROM [dbo].[BankAccount]
 

SELECT transactionid, transactiondatetime, amount,(SELECT SUM(amount) FROM dbo.bankaccount as D1 WHERE D1.transactiondatetime <= D0.transactiondatetime) AS balance
FROM dbo.bankaccount AS D0

drop table [dbo].[BankAccount]

*/

DECLARE @in  table (date datetime, prodid int, qty numeric(10,2), price numeric(10,2))
DECLARE @out table (date datetime, prodid int, qty numeric(10,2), price numeric(10,2))

insert into @in
			select '2017-12-01', 1, 10, 12.5 
union all	select '2017-12-02', 2, 30, 16.5
union all	select '2017-12-03', 1, 40, 14.5
union all	select '2017-12-02', 3, 20, 12.5
union all	select '2017-12-01', 1, 50, 10
union all	select '2017-12-01', 1, 60, 15

insert into @out
			select '2017-12-01', 1, 10, 12.5 
union all	select '2017-12-02', 1, 20, 16.5
union all	select '2017-12-07', 3, 35, 14.5
union all	select '2017-12-06', 1, 20, 12.5
union all	select '2017-12-08', 2, 70, 13.5
union all	select '2017-12-04', 1, 30, 15.5

SELECT * FROM @in
SELECT * FROM @out

SELECT date,types type,prodid, sum, summary FROM (
	SELECT date,type,prodid, sum(sum) sum, sum(tsum) tsum, case when type = 1 then 'in' else 'out' end as types
	,( SELECT SUM(tsum) FROM (
								SELECT date,prodid,type, sum(sum) sum, sum(tsum) tsum
								FROM (
										SELECT *, qty * price as sum, 1 as type, qty * price as tsum FROM @in
										union all
										SELECT *, qty * price as sum, 2 as type, -qty * price as tsum FROM @out
									 )s1 
								GROUP BY date,prodid,type
							 )gr 
						WHERE gr.date < s2.date or (gr.date = s2.date and gr.type < s2.type) or (gr.date = s2.date and gr.type = s2.type and gr.prodid <= s2.prodid) ) summary
	FROM (
			SELECT *, qty * price as sum, 1 as type, qty * price as tsum FROM @in
			union all
			SELECT *, qty * price as sum, 2 as type, -qty * price as tsum FROM @out
		 )s2	
	GROUP BY date,prodid,type
												 )v
ORDER BY date,type,prodid



/*
--SELECT date,types type,prodid, sum, summary 
--FROM (
	SELECT date,type,prodid, (qty * price) sum, (qty * price*case when type=2 then -1 else 1 end) tsum, case when type = 1 then 'in' else 'out' end as types
		   ,( 
			 SELECT SUM(qty * price*case when type=2 then -1 else 1 end) FROM ( SELECT *, 1 as type FROM @in union all SELECT *, 2 as type FROM @out )gr 
			 WHERE gr.date < s2.date or (gr.date = s2.date and gr.type < s2.type) or (gr.date = s2.date and gr.type = s2.type and gr.prodid <= s2.prodid) 
			) summary
	FROM (SELECT *, 1 as type FROM @in union all SELECT *, 2 as type FROM @out)s2	
--	GROUP BY date,prodid,type
--	 )v
ORDER BY date,type,prodid
*/

SELECT date,types type,prodid, sum, summary 
FROM (
	SELECT date,type,prodid, sum(qty * price) sum, sum(qty * price*case when type=2 then -1 else 1 end) tsum, case when type = 1 then 'in' else 'out' end as types
		   ,( 
			 SELECT SUM(qty * price*case when type=2 then -1 else 1 end) FROM ( SELECT *, 1 as type FROM @in union all SELECT *, 2 as type FROM @out )gr 
			 WHERE gr.date < s2.date or (gr.date = s2.date and gr.type < s2.type) or (gr.date = s2.date and gr.type = s2.type and gr.prodid <= s2.prodid) 
			) summary
	FROM (SELECT *, 1 as type FROM @in union all SELECT *, 2 as type FROM @out)s2	
	GROUP BY date,prodid,type
	 )v
ORDER BY date,type,prodid