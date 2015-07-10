set nocount on
if(OBJECT_ID('SchemaVersion') is null)
begin
	create table SchemaVersion 
	(
		SchemaID int not null identity(1,1),
		SchemaName nvarchar(64) not null,
		VersionIdentifier nvarchar(128) not null,
		InstalledDate datetime not null default(getutcdate()),
		IsCurrentVersion bit not null default(0),
		constraint PK_SchemaVersion_SchemaID primary key (SchemaID)
	)
	
	insert into SchemaVersion (SchemaName, VersionIdentifier, InstalledDate, IsCurrentVersion) values ('PROJECTNAME_SCHEMA','0.0.0.0',GETUTCDATE(), 1)
end
else
begin
	insert into SchemaVersion (SchemaName, VersionIdentifier, InstalledDate, IsCurrentVersion) values ('PROJECTNAME_SCHEMA','0.0.0.0',GETUTCDATE(), 1)
end
GO
if(OBJECT_ID('usp_dba_SetCurrentSchema') is not null)
	drop procedure usp_dba_SetCurrentSchema
GO
create procedure usp_dba_SetCurrentSchema(@schemaName nvarchar(64), @newVersionNumber nvarchar(128))
as
begin
	update SchemaVersion Set IsCurrentVersion = 0
	insert into SchemaVersion (SchemaName, VersionIdentifier, InstalledDate, IsCurrentVersion)
	values (@schemaName, @newVersionNumber, GETUTCDATE(), 1)
	
end
GO
if(OBJECT_ID('usp_dba_Schema') is not null)
	drop procedure usp_dba_Schema
GO
create procedure usp_dba_Schema(@Update nvarchar(64), @Version nvarchar(128), @With nvarchar(128))
as
begin
	if(not exists(select 1 from SchemaVersion where SchemaName = @Update and VersionIdentifier = @Version))
	begin
		print 'Schema change '+ @With + ' for ' + @Update + ' is missing required prequisite ' + @Version
		return 0
	end
	
	if(exists(select 1 from SchemaVersion where SchemaName = @Update AND VersionIdentifier = @With))
	begin
		declare @installDate datetime
		
		select @installDate = InstalledDate
		from SchemaVersion where SchemaName = @Update and VersionIdentifier = @With
		
		print 'Schema change '+ @With + ' for ' + @Update + ' was installed on ' + convert(nvarchar(24), @installDate)
		return 0
	end
	
	if (exists(select 1 from SchemaVersion where SchemaName = @Update and VersionIdentifier = @Version) AND
		not exists(select 1 from SchemaVersion where SchemaName = @Update AND VersionIdentifier = @With)) 
	begin
		print 'Schema change '+ @With + ' for ' + @Update + ' is being applied'	
		return 1
	end
	
	
end
GO
if(OBJECT_ID('usp_RethrowError') is not null)
	drop procedure usp_RethrowError
GO
CREATE PROCEDURE [dbo].[usp_RethrowError]
AS -- Return if there is no error information to retrieve.
BEGIN
IF ERROR_NUMBER() IS NULL 
  RETURN ;

DECLARE @ErrorMessage NVARCHAR(4000),
  @ErrorNumber INT,
  @ErrorSeverity INT,
  @ErrorState INT,
  @ErrorLine INT,
  @ErrorProcedure NVARCHAR(200) ;

    -- Assign variables to error-handling functions that 
    -- capture information for RAISERROR.
SELECT  @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(),
        @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-') ;

    -- Building the message string that will contain original
    -- error information.
SELECT  @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' +
        'Message: ' + ERROR_MESSAGE() ;

    -- Raise an error: msg_str parameter of RAISERROR will contain
    -- the original error information.
RAISERROR (@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, -- parameter: original error number.
  @ErrorSeverity, -- parameter: original error severity.
  @ErrorState, -- parameter: original error state.
  @ErrorProcedure, -- parameter: original error procedure name.
  @ErrorLine-- parameter: original error line number.
        ) ;
END
GO

 set nocount off
 GO