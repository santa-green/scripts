ALTER PROCEDURE [dbo].[ap_OffCalcExpDebt] @CompIDs VARCHAR(MAX) = ''
AS
BEGIN
/*
��������� ���������� ����������� �� �������� ����������� ������������� (�����. - ������ ��������).
*/
	IF @CompIDs = ''
	BEGIN
		RETURN
	END;

	DECLARE @compid INT 
	DECLARE cur CURSOR FOR
	SELECT compid FROM av_at_r_CompOurTerms1
	WHERE CompID IN (SELECT AValue FROM dbo.zf_FilterToTable(@CompIDs))
	OPEN cur 
			FETCH NEXT FROM cur INTO @compid
		WHILE @@FETCH_STATUS=0
		BEGIN

			INSERT INTO TreegerOnOF
				SELECT @compid,GETDATE()

			FETCH NEXT FROM cur INTO @compid

		END
	   CLOSE cur
	 DEALLOCATE cur 

	UPDATE dbo.av_at_r_CompOurTerms1
		SET  CalcExpDebt = 0, CalcExpDebt2 = 0
		WHERE CompID IN (SELECT AValue FROM dbo.zf_FilterToTable(@CompIDs))

	UPDATE dbo.av_at_r_CompOurTerms11
		SET  CalcExpDebt = 0, CalcExpDebt2 = 0
		WHERE CompID IN (SELECT AValue FROM dbo.zf_FilterToTable(@CompIDs))

	UPDATE dbo.av_at_r_CompOurTerms3
		SET  CalcExpDebt = 0, CalcExpDebt2 = 0
		WHERE CompID IN (SELECT AValue FROM dbo.zf_FilterToTable(@CompIDs))

/*
--moa0 27-08-2019 10:59 ������� ������ �������� ����������� ������������� � ���������.

declare @compid int 
declare cur cursor for
select  compid  from av_at_r_CompOurTerms1
WHERE CompID IN (SELECT AValue FROM dbo.zf_FilterToTable(#��������_�����������:������#))
open cur 
fetch next from cur into @compid
while @@FETCH_STATUS=0
begin
  insert into TreegerOnOF
    select @compid,GETDATE()
   fetch next from cur into @compid
 end
   close cur
 deallocate cur 

 UPDATE  av_at_r_CompOurTerms1
SET  CalcExpDebt =0,CalcExpDebt2=0
WHERE CompID IN (SELECT AValue FROM dbo.zf_FilterToTable(#��������_�����������:������#))




 UPDATE  av_at_r_CompOurTerms11
SET  CalcExpDebt =0,CalcExpDebt2=0
WHERE CompID IN (SELECT AValue FROM dbo.zf_FilterToTable(#��������_�����������:������#))





 UPDATE  dbo.av_at_r_CompOurTerms3
SET  CalcExpDebt =0,CalcExpDebt2=0
WHERE CompID IN (SELECT AValue FROM dbo.zf_FilterToTable(#��������_�����������:������#))
*/
END;
