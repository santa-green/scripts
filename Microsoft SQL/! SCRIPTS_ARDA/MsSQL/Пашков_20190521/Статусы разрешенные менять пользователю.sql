--Статусы разрешенные менять пользователю
SELECT u.UserName, e.EmpName, StateCodeFrom со_статуса, StateCodeTo на_статус FROM r_StateRules sr 
join r_StateRuleUsers sru on sru.StateRuleCode = sr.StateRuleCode
join r_Users u on u.UserID = sru.UserCode
join r_Emps e on e.EmpID = u.EmpID
WHERE  u.UserName = 'zoa3'
ORDER BY 3,4

SELECT u.UserName, e.EmpName,  sdc.StateCode FROM r_StateDocsChange sdc
join r_Users u on u.UserID = sdc.UserCode
join r_Emps e on e.EmpID = u.EmpID
WHERE  u.UserName = 'zoa3'

--TRel2_Upd_t_Sale	
--zf_CanChangeDoc	


SELECT * FROM t_Sale

SELECT m.StateCode,* FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE m.DocDate = '20170901' and m.StockID = 1201
ORDER BY 1

SELECT * FROM r_StateRules


SELECT dbo.zf_CanChangeState(11035, i.ChID, d.StateCode, i.StateCode


  /* Разрешен ли переход между указанными статусами текущему пользователю */	
  IF (SELECT TOP 1 DenyUsers FROM r_StateRules WHERE StateRuleCode = @StateRuleCode) = 1
    BEGIN
      IF NOT EXISTS(SELECT TOP 1 1 FROM r_StateRuleUsers WHERE UserCode = dbo.zf_GetUserCode() AND StateRuleCode = @StateRuleCode) RETURN 0
    END
  ELSE
    BEGIN
      IF EXISTS(SELECT TOP 1 1 FROM r_StateRuleUsers WHERE UserCode = dbo.zf_GetUserCode() AND StateRuleCode = @StateRuleCode) RETURN 0
    END

SELECT * FROM r_StateRuleUsers WHERE UserCode = 1881
SELECT * FROM r_StateRuleUsers WHERE UserCode = 2020


SELECT StateRuleCode FROM r_StateRuleUsers WHERE UserCode = 1881

SELECT UserID FROM r_Users WITH(NOLOCK) WHERE UserName = 'kea20' -- 1881
SELECT UserID FROM r_Users WITH(NOLOCK) WHERE UserName = 'zoa3' -- 2020

 SELECT   StateRuleCode FROM r_StateRules WHERE StateCodeFrom = 22 AND StateCodeTo = 140
 
 
 
   IF (SELECT TOP 1 CanChangeDoc FROM r_States WHERE StateCode = 22) = 0
    BEGIN
      IF NOT EXISTS(SELECT TOP 1 1 FROM r_StateDocsChange WHERE UserCode = dbo.zf_GetUserCode() AND StateCode = @StateCode) RETURN 0
    END
  ELSE
    BEGIN
      IF EXISTS(SELECT TOP 1 1 FROM r_StateDocsChange WHERE UserCode = dbo.zf_GetUserCode() AND StateCode = @StateCode) RETURN 0
    END
    
SELECT TOP 1 1 FROM r_StateDocsChange WHERE UserCode = 2020 AND StateCode = 22
SELECT TOP 1 1 FROM r_StateDocsChange WHERE UserCode = 1881 AND StateCode = 22

SELECT * FROM r_StateDocsChange WHERE UserCode = 2020 AND StateCode = 22
SELECT * FROM r_StateDocsChange WHERE UserCode = 1881 AND StateCode = 22