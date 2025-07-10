--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--������ Import_Recadv_reg_use.ps1 ��������� ������ � ������� ����������� � ������: [s-ppc]ALEF_EDI_RECADV, [s-ppc]ALEF_EDI_RECADV_POS.
--� ���� ����� ���� ��������� ������� � 1 �� 2,3 (������ 4 ����������).
--rkv0 '2020-11-30 14:50' ��� ���� ��������� ����� ����� ������ ��� ������� (��� ��� ������� ����� �����������??). � ���� ��, �� ���� METRO � ��� ��� ����� DELIVEREDQUANTITY, �� ������� �� ����������� �������-�������.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] rkv0 '2020-12-07 13:26' ������� ���� �������� ����������� �� ������ RECADV ��� ���� ������. ����� ��������� RECADV ����� ���������� �������� CONTRL (����� Invoice-Matching).


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
	    execute('select ? = (select SUM(Qty) from Elit.dbo.t_InvD d where i.ChID = d.ChID) from Elit.dbo.t_Inv i where TaxDocID = ? and OrderID = ? ;'
        , @invCntOT OUTPUT
        , @in_id
        , @ord_id)
        at [s-sql-d4]
	
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

-- [ADDED] rkv0 '2020-12-07 13:26' ������� ���� �������� ����������� �� ������ RECADV ��� ���� ������. ����� ��������� RECADV ����� ���������� �������� CONTRL (����� Invoice-Matching).
exec [s-sql-d4].[elit].[dbo].[ap_SendEmailEDI] @doctype = 5001
