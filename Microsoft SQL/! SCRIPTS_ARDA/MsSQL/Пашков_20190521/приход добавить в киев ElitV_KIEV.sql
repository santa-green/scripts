--приход добавить в киев
use ElitV_KIEV

SELECT * FROM [s-sql-d4].elitr.dbo.t_Rec where docid = 100001777

begin tran

DECLARE @ChID int = 100009166

SELECT * FROM [s-sql-d4].elitr.dbo.t_Rec where ChID = @ChID

SELECT * FROM [s-sql-d4].elitr.dbo.t_RecD where ChID = @ChID

SELECT * FROM dbo.t_Rec where ChID = @ChID

SELECT * FROM dbo.t_RecD where ChID = @ChID


insert t_PInP
SELECT p.* FROM [s-sql-d4].elitr.dbo.t_RecD d 
JOIN [s-sql-d4].elitr.dbo.t_PInP p ON d.ProdID = p.ProdID and d.PPID = p.PPID
where d.ChID = @ChID
Except -- дубликаты партий не добавлять
SELECT p.* FROM [s-sql-d4].elitr.dbo.t_RecD d 
JOIN [s-sql-d4].elitr.dbo.t_PInP p ON d.ProdID = p.ProdID and d.PPID = p.PPID
JOIN  t_PInP ON t_PInP.ProdID = p.ProdID and t_PInP.PPID = p.PPID
where d.ChID = @ChID


insert t_Rec
SELECT * FROM [s-sql-d4].elitr.dbo.t_Rec where ChID = @ChID

insert t_RecD
SELECT * FROM [s-sql-d4].elitr.dbo.t_RecD where ChID = @ChID


SELECT * FROM [s-sql-d4].elitr.dbo.t_Rec where ChID = @ChID

SELECT * FROM [s-sql-d4].elitr.dbo.t_RecD where ChID = @ChID

SELECT * FROM dbo.t_Rec where ChID = @ChID

SELECT * FROM dbo.t_RecD where ChID = @ChID

rollback tran

