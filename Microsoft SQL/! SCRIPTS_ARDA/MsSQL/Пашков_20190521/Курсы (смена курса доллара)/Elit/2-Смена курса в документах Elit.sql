--��������� ����� � ���������� ���� Elit

/*
1. ������ "������"						
��������	��������� ��� �������					��������
	����	�����	������ ���������	����, ��	������� 1	
--������ ������	01.09.2018-30.09.2018	1-5,10,11	2	29	40,41,42,80	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--������ ������	01.09.2018-30.09.2018	1-5,10,11	2	29	81,82,87,95,100,2004	�������� ����, ��� ��������� ��� ��������� � ���������� ���
--������� �� ����������	01.09.2018-30.09.2018	1-5,10,11	2	29	52-79,2004	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--��������� ���������	01.09.2018-30.09.2018	1-5,10,11	2	29	52-79	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--��������� ��������	01.09.2018-30.09.2018	1-5,10,11	2	29	24,30,36,50	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--��������� ��������	01.09.2018-30.09.2018	1-5,10,11	2	29	2004,2011,2012,2016,2022,2030,2031,2032,2038	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--��������� �������� � ����� �������	01.09.2018-30.09.2018	1-5,10,11	2	29	24,40,41,42,80,63,78,79,100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--��������� �������� � ����� �������	01.09.2018-30.09.2018	1-5,10,11	2	29	2004,2011,2026,2031	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--������������ ������	01.09.2018-30.09.2018	1-5,10,11	2	29	100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--���������������� ������	01.09.2018-30.09.2018	1-5,10,11	2	29	100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--����������� ������	01.09.2018-30.09.2018	1-5,10,11	2	29	40,41,42,80	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--����� ��������� ������������	01.09.2018-30.09.2018	1-5,10,11	2	29	50-79,2032,2012	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--����� ���������� ������	01.09.2018-30.09.2018	1-5,10,11	2	29	50-79,2032,2012	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
						
2. ������ "�������"						
��������	��������� ��� �������					��������
	����	�����	������ ���������	����, ��	������� 1	
--������ ����� �� ������������	01.09.2018-01.01.2070	1-5,11	2	29	���	����������� ����� ��, �� ����� ����� ��,��
--������ ����� �� ������������	01.09.2018-01.01.2070	1-5,11	2	29	���	����������� ����� ��, �� ����� ����� ��,��
*/


BEGIN TRAN


DECLARE @BDate SMALLDATETIME = '20190301' --���� ������ ����� �����
DECLARE @EDate SMALLDATETIME = '20190331' --���� ����� ����� �����
DECLARE @Old_KursMC numeric(21,9) = 29.00 -- ����� ���� �������
DECLARE @New_KursMC numeric(21,9) = 28.00 -- ����� ���� �������
DECLARE @CurrID_GRN INT = 2 --��� ���������� ������

--��������
	SELECT KursMC,* From t_Rec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Epp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Ret d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Inv d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Exp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Epp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_SRec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_SExp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Exc d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_IORec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM at_t_IORes d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM c_CompRec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM c_CompExp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (1,2,3,4,5,10,11) and d.CurrID = @CurrID_GRN


/*--���������� �� �����������
BEGIN TRAN

SELECT * FROM r_ProdMP where PLID in (8,9,11,14,15,16,18,19,25,26,29,32,49,55,66,76,82,83,84,86,94,95,97,98,99,100,101,102,106,124,130,139)

update r_ProdMP 
set PriceMC = PriceMC * @Old_KursMC/@New_KursMC
where PLID in (8,9,11,14,15,16,18,19,25,26,29,32,49,55,66,76,82,83,84,86,94,95,97,98,99,100,101,102,106,124,130,139)


SELECT * FROM r_ProdMP where PLID in (8,9,11,14,15,16,18,19,25,26,29,32,49,55,66,76,82,83,84,86,94,95,97,98,99,100,101,102,106,124,130,139)

ROLLBACK TRAN
*/
/*
/*###�������� ���� ������� 5 � ����������� ������� ��� ��� ��������###*/
	--BEGIN TRAN
	--SELECT ProdID, Extra5 FROM r_Prods where Extra5 <> 0 ORDER BY 1
	update r_Prods set Extra5 = Extra5 * @Old_KursMC / @New_KursMC where Extra5 <> 0 
	SELECT ProdID, Extra5 FROM r_Prods where Extra5 <> 0 ORDER BY 1
	--SELECT Extra5,* FROM r_Prods where ProdID between 10000 and 12999
	--a_rProds_CheckFieldsValues_IU
	--ROLLBACK TRAN
*/

--������ ������	01.09.2018-30.09.2018	1-5,10,11	2	29	40,41,42,80	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	--�������� ����, ��� ��������� ��� ���������
	Update d
	set d.KursMC =@New_KursMC
	From t_Rec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
		and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (40,41,42,80)
		
	SELECT * From t_Rec d 
	where DocDate Between @BDate and @EDate 
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (40,41,42,80)
	
--������ ������	01.09.2018-30.09.2018	1-5,10,11	2	29	81,82,87,95,100,2004	�������� ����, ��� ��������� ��� ��������� � ���������� ���
	--�������� ����, ��� ��������� ��� ���������
	Update d
	set d.KursMC =@New_KursMC
	From t_Rec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
		and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (81,82,87,95,100,2004)
		
	SELECT * From t_Rec d 
	where DocDate Between @BDate and @EDate 
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (81,82,87,95,100,2004)

	--� ���������� �������� ���
	--��������� ���� ������� �� � ������������� �� � ��������
	Update p
	Set p.PriceMC_IN = p.PriceAC_In/c.KursMC, --���� ������� ��
 		p.CostMC = p.CostAC/c.KursMC -- ������������� �� 
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate 
		and c.CurrID=@CurrID_GRN and r.Ourid in (1,2,3,4,5,10,11) and r.CodeID1 in (81,82,87,95,100,2004)

	Select p.*
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate 
		and c.CurrID=@CurrID_GRN and r.Ourid in (1,2,3,4,5,10,11) and r.CodeID1 in (81,82,87,95,100,2004)
	Order By ProdID,PPID


--������� �� ����������	01.09.2018-30.09.2018	1-5,10,11	2	29	52-79,2004	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC = @New_KursMC
	From t_Ret d 
	where DocDate Between @BDate and @EDate  and d.KursMC = @Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,2004)

	SELECT * From t_Rec d 
	where DocDate Between @BDate and @EDate  and d.KursMC = @Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,2004)

--��������� ���������	01.09.2018-30.09.2018	1-5,10,11	2	29	52-79	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC =@New_KursMC
	From t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79)
	
	SELECT * FROM t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79)

--��������� ��������	01.09.2018-30.09.2018	1-5,10,11	2	29	24,30,36,50	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC = @New_KursMC
	From t_Exp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (24,30,36,50)

	Select ed.*
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (24,30,36,50)

--��������� ��������	01.09.2018-30.09.2018	1-5,10,11	2	29	2004,2011,2012,2016,2022,2030,2031,2032,2038	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC = @New_KursMC
	From t_Exp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2012,2016,2022,2030,2031,2032,2038)

	Select ed.*
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2012,2016,2022,2030,2031,2032,2038)
	
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2012,2016,2022,2030,2031,2032,2038)

	Select ed.*
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2012,2016,2022,2030,2031,2032,2038)

--��������� �������� � ����� �������	01.09.2018-30.09.2018	1-5,10,11	2	29	24,40,41,42,80,63,78,79,100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (24,40,41,42,80,63,78,79,100)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (24,40,41,42,80,63,78,79,100)
	

--��������� �������� � ����� �������	01.09.2018-30.09.2018	1-5,10,11	2	29	2004,2011,2026,2031	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2026,2031)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2026,2031)
	
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2026,2031)

	Select ed.*
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2026,2031)


--������������ ������	01.09.2018-30.09.2018	1-5,10,11	2	29	100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC =@New_KursMC
	From t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (100)
	
	SELECT * FROM t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (100)

--���������������� ������	01.09.2018-30.09.2018	1-5,10,11	2	29	100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC =@New_KursMC
	From t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (100)
	
	SELECT * FROM t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (100)

--����������� ������	01.09.2018-30.09.2018	1-5,10,11	2	29	40,41,42,80	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC =@New_KursMC
	From t_Exc d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (40,41,42,80)
	
	SELECT * FROM t_Exc d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (40,41,42,80)

--����� ��������� ������������	01.09.2018-30.09.2018	1-5,10,11	2	29	50-79,2032,2012	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC =@New_KursMC
	From t_IORec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,2032,2012)
	
	SELECT * FROM t_IORec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,2032,2012)

--����� ���������� ������	01.09.2018-30.09.2018	1-5,10,11	2	29	50-79,2032,2012	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
	Update d
	set d.KursMC =@New_KursMC
	From at_t_IORes d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,2032,2012)
	
	SELECT * FROM at_t_IORes d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,2032,2012)

--������ ����� �� ������������	01.09.2018-01.01.2070	1-5,11	2	29	���	����������� ����� ��, �� ����� ����� ��,��
	Update d
	set d.KursMC =@New_KursMC
	From c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11)
	
	SELECT * FROM c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11)

--������ ����� �� ������������	01.09.2018-01.01.2070	1-5,11	2	29	���	����������� ����� ��, �� ����� ����� ��,��
	Update d
	set d.KursMC =@New_KursMC
	From c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (1,2,3,4,5,10,11)

	SELECT * FROM c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (1,2,3,4,5,10,11)


ROLLBACK TRAN




