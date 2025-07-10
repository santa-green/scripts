CREATE TRIGGER  _t1_b_cExp
ON dbo.b_cExp
FOR UPDATE, DELETE
AS

BEGIN

SET NOCOUNT ON

if SYSTEM_USER not in
(
 'Vika'
)
  and exists (select notes from DELETED where Notes is not null)
begin 
  RAISERROR 30001 N'¬ы не имеете права измен€ть данный документ'
  ROLLBACK TRANSACTION
end

END