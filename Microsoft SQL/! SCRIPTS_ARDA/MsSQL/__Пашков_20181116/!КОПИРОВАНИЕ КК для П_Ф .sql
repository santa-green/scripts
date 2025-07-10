--����������� �� � ������������ �� 1 ��

BEGIN TRAN


DECLARE @Mchid int, @chid INT,
@NewStockid int = 1312, --����� ����� �������� 
@NewDocDate smalldatetime = '20170715', --����� ���� ��������
@OurID int = 12, --������ ����� �����
@NewOurID int = 12 --����� ����� �����
,@OutQty numeric(21,9) --����� �������� � ��
DECLARE @ChIDTable table(ChID int NULL) 
insert into @ChIDTable select ChID from it_Spec
	where DocID in (
--������� ������ ���������� ��	
600000014,600000015,600000016,600000017,600000018,600000019,600000020,600000021,600000022,600000023,600000024,600001694,600001695
)
--and OurID = @OurID

SELECT * FROM @ChIDTable

select @Mchid = MAX (chid)+1 from it_Spec
select @Mchid as Mchid

select * from it_Spec 
where OurID = @OurID and ChID in ( SELECT * FROM @ChIDTable)
	
DECLARE kalc CURSOR 
FOR
	select  chid from it_Spec 
	where OurID = @OurID and ChID in ( SELECT * FROM @ChIDTable)
OPEN kalc
FETCH NEXT FROM kalc INTO @chid 
 WHILE @@FETCH_STATUS = 0    		 
  BEGIN  
     EXEC ip_SpecCopy  @chid, @NewOurID, @NewDocDate, @NewStockid 
     FETCH NEXT FROM kalc INTO @chid 
  END
CLOSE kalc
DEALLOCATE kalc


select * from it_Spec where ChID >= @Mchid
select * from it_SpecParams where ChID >= @Mchid

update it_SpecParams
set StockID = @NewStockid , ProdDate = @NewDocDate
from it_SpecParams where ChID >= @Mchid

select * from it_SpecParams where ChID >= @Mchid

-- ���������� ������������ �� @OutQty (����� �������� � ��)
select '���������� ������������ �� @OutQty (����� �������� � ��)'

delete @ChIDTable
insert into @ChIDTable 
	select ChID from it_Spec where ChID >= @Mchid

SELECT * FROM @ChIDTable

DECLARE kalc CURSOR 
FOR
	select  chid from it_Spec 
	where OurID = @OurID and ChID in ( SELECT * FROM @ChIDTable)
OPEN kalc
FETCH NEXT FROM kalc INTO @chid 
 WHILE @@FETCH_STATUS = 0    		 
  BEGIN  
     
     SET @OutQty = (SELECT top 1 OutQty FROM it_Spec where OurID = @OurID and ChID = @chid )
          
     SELECT @chid chid 
     SELECT @OutQty OutQty
     --������ ������
	 SELECT * FROM it_SpecD where  ChID = @chid
	      
     update it_SpecD
     set Qty = Qty / @OutQty
     where  ChID = @chid
  
       update it_Spec
     set OutQty = 1
     where  ChID = @chid
 
        update it_SpecParams
     set LayQty = 1
     where  ChID = @chid
     
     --����� ������       
     SELECT * FROM it_SpecD where  ChID = @chid
     
     FETCH NEXT FROM kalc INTO @chid 
  END
CLOSE kalc
DEALLOCATE kalc



ROLLBACK TRAN
