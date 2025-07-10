--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--������ Import_Recadv_reg_use.ps1 ��������� ������ � ������� ����������� � ������: [s-ppc]ALEF_EDI_RECADV, [s-ppc]ALEF_EDI_RECADV_POS.
--� ���� ����� ���� ��������� ������� � 1 �� 2,3 (������ 4 ����������).
--rkv0 '2020-11-30 14:50' ��� ���� ��������� ����� ����� ������ ��� ������� (��� ��� ������� ����� �����������??). � ���� ��, �� ���� METRO � ��� ��� ����� DELIVEREDQUANTITY, �� ������� �� ����������� �������-�������.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

declare @in_id int
declare @in_date date
declare @ord_id varchar(100)
declare @invCnt int
declare @invCntOT int

declare cur cursor for
select REC_INV_ID 'in_id', REC_INV_DATE 'in_date', REC_ORD_ID 'ord_id',
(select SUM(REP_DELIVER_QTY) from dbo.ALEF_EDI_RECADV_POS where REC_INV_ID = REP_INV_ID and REC_INV_DATE = REP_INV_DATE) 'invCnt'
from dbo.ALEF_EDI_RECADV
where REC_STATUS = 1

open cur 
fetch next from cur into @in_id, @in_date, @ord_id, @invCnt

while @@FETCH_STATUS = 0
    begin
	    execute('select ? = (select SUM(Qty) from Elit.dbo.t_InvD d where i.ChID = d.ChID) from Elit.dbo.t_Inv i where TaxDocID = ? and OrderID = ? ;',@invCntOT OUTPUT,@in_id,@ord_id) at [s-sql-d4]
	
	    update dbo.ALEF_EDI_RECADV
	    set
	    REC_STATUS = case when @invCnt = @invCntOT then 2 else 3 end --������ = 1, ���� ���-�� ������������ ������� � RECADV ��������� � ����� ���������; 3 - ���� �� ���������.
	    where 1 = 1
        and @invCntOT is not null
	    and REC_INV_ID = @in_id
	    and REC_INV_DATE = @in_date;
	
	    fetch next from cur into @in_id, @in_date, @ord_id, @invCnt
    end;

close cur
deallocate cur

--test.
SELECT * FROM ALEF_EDI_RECADV WHERE REC_INV_ID = 16061 ORDER BY 2 DESC
SELECT * FROM ALEF_EDI_RECADV WHERE REC_STATUS = 4 ORDER BY REC_AUDIT_DATE DESC
SELECT DISTINCT(REC_STATUS) FROM ALEF_EDI_RECADV --ORDER BY 2 DESC


SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV m
JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS d ON m.REC_INV_ID = d.REP_INV_ID and m.REC_INV_DATE = d.REP_INV_DATE
WHERE m.REC_ORD_ID = '���00989421'

SELECT * FROM ALEF_EDI_RECADV WHERE REC_ORD_ID = '���00989421'
