
DECLARE @Drives table (Drive char(1), TotalSize bigint, AvailableSpace bigint)

/*
	exec sp_configure 'Ole Automation Procedures', 1; RECONFIGURE
*/
	declare @hr integer, @fso integer, @objDrive integer, @Drive char(1), @DriveInt int, 
		@DriveType int, @TotalSize bigint, @AvailableSpace bigint;

	exec @hr = sp_OACreate 'Scripting.FileSystemObject', @fso output;

	set @DriveInt = 67;

	while @DriveInt <= 90 begin
		set @Drive = CHAR(@DriveInt);
		set @TotalSize = null;
		set @AvailableSpace = null;

		exec @hr = sp_OAMethod @fso, 'GetDrive', @objDrive out, @Drive;
		if @hr = 0 begin
			exec @hr = sp_OAGetProperty @objDrive,'DriveType', @DriveType output;
			if @DriveType = 2 begin
				exec @hr = sp_OAGetProperty @objDrive, 'TotalSize', @TotalSize output;
				exec @hr = sp_OAGetProperty @objDrive, 'AvailableSpace', @AvailableSpace output;

				insert @Drives (Drive, TotalSize, AvailableSpace)
				values (@Drive, @TotalSize, @AvailableSpace);
			end;
		end;

		set @DriveInt = @DriveInt + 1;
	end;

	exec sp_OADestroy @objDrive;
	exec sp_OADestroy @fso;

SELECT * FROM @Drives

/*
CREATE function [dbo].[af_DrivesInfo] ()
returns @Drives table (Drive char(1), TotalSize bigint, AvailableSpace bigint)
as begin

	exec sp_configure 'Ole Automation Procedures', 1

	declare @hr integer, @fso integer, @objDrive integer, @Drive char(1), @DriveInt int, 
		@DriveType int, @TotalSize bigint, @AvailableSpace bigint;

	exec @hr = sp_OACreate 'Scripting.FileSystemObject', @fso output;

	set @DriveInt = 67;

	while @DriveInt <= 90 begin
		set @Drive = CHAR(@DriveInt);
		set @TotalSize = null;
		set @AvailableSpace = null;

		exec @hr = sp_OAMethod @fso, 'GetDrive', @objDrive out, @Drive;
		if @hr = 0 begin
			exec @hr = sp_OAGetProperty @objDrive,'DriveType', @DriveType output;
			if @DriveType = 2 begin
				exec @hr = sp_OAGetProperty @objDrive, 'TotalSize', @TotalSize output;
				exec @hr = sp_OAGetProperty @objDrive, 'AvailableSpace', @AvailableSpace output;

				insert @Drives (Drive, TotalSize, AvailableSpace)
				values (@Drive, @TotalSize, @AvailableSpace);
			end;
		end;

		set @DriveInt = @DriveInt + 1;
	end;

	exec sp_OADestroy @objDrive;
	exec sp_OADestroy @fso;

	return;
end;

*/

--SELECT * FROM   af_DrivesInfo()
--SELECT * FROM [dbo].[af_DrivesInfo]()