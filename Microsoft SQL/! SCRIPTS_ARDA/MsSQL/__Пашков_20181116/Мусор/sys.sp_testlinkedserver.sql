declare @srvr nvarchar(128), @retval int;
set @srvr = 'CP4_DP';
begin try
    exec @retval = sys.sp_testlinkedserver @srvr
end try
begin catch

    --set @retval = sign(@@error);
end catch;

select @retval

if @retval  is null 
   select 'null not connect'
 -- raiserror('Unable to connect to server. This operation will be tried later!', 16, 2 );