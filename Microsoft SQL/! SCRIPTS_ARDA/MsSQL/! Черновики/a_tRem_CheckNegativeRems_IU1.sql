USE [Elit_test]
GO
/****** Object:  Trigger [dbo].[a_tRem_CheckNegativeRems_IU]    Script Date: 13.07.2021 13:25:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[a_tRem_CheckNegativeRems_IU] ON [dbo].[t_Rem]
FOR INSERT, UPDATE
AS
BEGIN

  --для обхода при обрезке базы
  IF SUSER_SNAME() = 'const\pashkovv'  and getdate() < '20200605' RETURN
  --IF SUSER_SNAME() = 'corp\rumyantsev' RETURN


--moa0 '2019-09-25 18:10:04.826' Исключил 'eas1' и 'mvv14' по просьбе Евтищенко и согласовано с Бибик.

  SET NOCOUNT ON

  DECLARE @ProdID INT, @OurID INT, @StockID INT, @SecID INT, @PPID2 INT, @Qty int, @accQty int , @Qtys varchar(30), @accQtys varchar(30)

  IF IS_ROLEMEMBER('Учёт') = 0
    IF GETDATE() BETWEEN '20150831 13:00' AND '20150831 15:00'
		  IF EXISTS(SELECT * FROM deleted) OR EXISTS(SELECT * FROM inserted)
		  BEGIN
		    RAISERROR('ВНИМАНИЕ!!! Работа с документами заблокирована до 15:00! Действие отменено.', 18, 1)
		    ROLLBACK
		    RETURN
		  END

 	IF EXISTS(SELECT * FROM inserted i JOIN dbo.t_PInP tp ON tp.ProdID = i.ProdID AND tp.PPID = i.PPID
		WHERE i.PPID != 0
			AND EXISTS(SELECT * FROM dbo.t_PInP WHERE ProdID = tp.ProdID AND ParentPPID = tp.PPID AND PPID != 0))
			if SUSER_SNAME() not in('giv3','dmv2','cev','sev12','CORP\Cluster', 'sa' , 'kvi1','rss0')
		BEGIN
		  DECLARE @PID INT, @PPID INT
			SELECT TOP 1 @PID = i.ProdID, @PPID = tpp.PPID
			FROM inserted i JOIN dbo.t_PInP tp ON tp.ProdID = i.ProdID AND tp.PPID = i.PPID
			JOIN dbo.t_PInP tpp ON tpp.ProdID = tp.ProdID AND tpp.ParentPPID = tp.PPID
			WHERE i.PPID != 0 AND tpp.PPID != 0

			RAISERROR('ВНИМАНИЕ!!! Работа с указанной партией невозможна! Для товара %u используйте партию %u. Действие отменено.', 18, 1, @PID, @PPID)
			ROLLBACK
			RETURN
		END

  IF SUSER_SNAME() IN ('sa','kaa0'/*,'sev12'*/,'rss0','pvm0','const\pashkovv')
    RETURN

	--для Кельман отключение проверки pvm0 14.04.2017 9.14
	if SUSER_NAME () in ('kkm0') AND GETDATE() BETWEEN '20170901 16:30:00' AND '20170925 18:30:00' RETURN	
IF  SUSER_SNAME() IN ('gdn1') AND GETDATE() BETWEEN '20171013 13:30:00' AND '20171013 14:30:00' RETURN	
IF  SUSER_SNAME() IN ('dvv4') AND GETDATE() BETWEEN '20181109 14:00:00' AND '20181109 18:00:00' RETURN	

--moa0 '2019-09-25 18:10:04.826' Исключил 'eas1' и 'mvv14' по просьбе Евтищенко и согласовано с Бибик.
 IF SUSER_SNAME() NOT IN ('CORP\Cluster','gdn1','bag3',/*'eas1','mvv14',*/'kvn1','pvm0') -- временно добавил ,'dvv4'
  IF EXISTS(SELECT * FROM inserted WHERE (Qty-AccQty)<0 AND OurID NOT IN (21,23)) 
  BEGIN
    SELECT TOP 1 @ProdID = ProdID, @StockID = StockID, @OurID = OurID, @SecID = SecID ,@PPID2 = PPID,@Qtys=cast(Qty as varchar(30)), @accQtys=cast(AccQty as varchar(30)) FROM inserted WHERE (Qty-AccQty) < 0 AND OurID NOT IN (21,23)
    RAISERROR('[a_tRem_CheckNegativeRems_IU] ВНИМАНИЕ!!! Списание товара %u по: Фирма %u, Склад %u, Секция %u, Партия %u,  Количесво %s,  Резерв %s  в минус запрещено! Действие отменено.', 18, 1, @ProdID, @OurID, @StockID, @SecID,@PPID2,@Qtys,@accQtys)
    ROLLBACK
    RETURN
  END

  IF SUSER_SNAME() != 'CONST\Cluster'
		IF EXISTS(SELECT * FROM deleted WHERE StockID BETWEEN 800 AND 899 OR StockID BETWEEN 1400 AND 1599)
			OR EXISTS(SELECT * FROM inserted WHERE StockID BETWEEN 800 AND 899 OR StockID BETWEEN 1400 AND 1599)
		BEGIN
			RAISERROR('ВНИМАНИЕ!!! Работа с указанным складом запрещена! Действие отменено.', 18, 1)
			ROLLBACK
			RETURN
		END

  /*
  IF UPDATE(OurID) OR UPDATE(ProdID) OR UPDATE(PPID)
  BEGIN
    IF EXISTS(SELECT *
              FROM inserted i
              JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = i.ProdID AND pp.PPID = i.PPID
              WHERE pp.CompID = 201 AND i.OurID = 1)
    BEGIN
      RAISERROR('ВНИМАНИЕ!!! Невозможна работа с товаром Предприятия 201 от Фирмы 1! Действие отменено.', 18, 1)
      ROLLBACK
      RETURN
    END

    IF EXISTS(SELECT *
              FROM inserted i
              JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = i.ProdID AND pp.PPID = i.PPID
              WHERE pp.CompID != 201 AND i.OurID = 10)
    BEGIN
      RAISERROR('ВНИМАНИЕ!!! Невозможна работа с товаром Предприятия НЕ 201 от Фирмы 10! Действие отменено.', 18, 1)
      ROLLBACK
      RETURN
    
    END
  END*/
END

























GO
