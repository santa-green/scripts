select DCardID ,SUM(SumBonus) , 'Днепр'from [s-marketa].elitv_dp.dbo.z_LogDiscRec 
where DCardID = '2220000026758' and LogDate between '20130801' and '20130901' group by DCardID
union 
select DCardID ,SUM(SumBonus) , 'Днепр'from [s-marketa].elitv_dp.dbo.z_LogDiscRec 
where DCardID = '2220000026765' and LogDate between '20130801' and '20130901' group by DCardID
union 
select DCardID ,SUM(SumBonus), 'Днепр' from [s-marketa].elitv_dp.dbo.z_LogDiscRec 
where DCardID = '2220000000345' and LogDate between '20130801' and '20130901' group by DCardID
union 
select DCardID ,SUM(SumBonus) , 'Днепр' from [s-marketa].elitv_dp.dbo.z_LogDiscRec 
where DCardID = '2220000024006' and LogDate between '20130801' and '20130901' group by DCardID
select DCardID ,SUM(SumBonus) , 'Киев'from [s-marketa2].elitv_kiev.dbo.z_LogDiscRec 
where DCardID = '2220000026758' and LogDate between '20130801' and '20130901' group by DCardID
union 
select DCardID ,SUM(SumBonus) , 'Киев'from [s-marketa2].elitv_kiev.dbo.z_LogDiscRec 
where DCardID = '2220000026765' and LogDate between '20130801' and '20130901' group by DCardID
union 
select DCardID ,SUM(SumBonus), 'Киев' from [s-marketa2].elitv_kiev.dbo.z_LogDiscRec 
where DCardID = '2220000000345' and LogDate between '20130801' and '20130901' group by DCardID
union 
select DCardID ,SUM(SumBonus) , 'Киев' from [s-marketa2].elitv_kiev.dbo.z_LogDiscRec 
where DCardID = '2220000024006' and LogDate between '20130801' and '20130901' group by DCardID