--Скопировать новый столики с ElitR в [s-marketa].ElitV_DP

USE ELITR

BEGIN TRAN

INSERT [s-marketa].ElitV_DP.dbo.r_DeskG
	SELECT * FROM r_DeskG where DeskGCode not in (SELECT DeskGCode FROM [s-marketa].ElitV_DP.dbo.r_DeskG)


INSERT  [s-marketa].ElitV_DP.dbo.r_Desks
	SELECT * FROM r_Desks where DeskCode not in (SELECT DeskCode FROM [s-marketa].ElitV_DP.dbo.r_Desks)


ROLLBACK TRAN

