--disable TRIGGER dbo.base_gln_change_log_IUD ON r_CompValues
alter TRIGGER base_gln_change_log_IUD 
ON r_CompValues
AFTER INSERT, DELETE, UPDATE
AS
BEGIN

IF EXISTS (SELECT *
	FROM inserted WHERE VarName = 'BASE_GLN')
BEGIN
	INSERT INTO base_gln_change_log ( Compid, VarName, VarValue, Action_type )
	SELECT inserted.Compid
	,      inserted.VarName
	,      inserted.VarValue
	,      'I'
	FROM inserted
END;

IF EXISTS (SELECT *
	FROM deleted WHERE VarName = 'BASE_GLN')
BEGIN
	INSERT INTO base_gln_change_log ( Compid, VarName, VarValue, Action_type )
	SELECT deleted.Compid
	,      deleted.VarName
	,      deleted.VarValue
	,      'D'
	FROM deleted
END;
END;