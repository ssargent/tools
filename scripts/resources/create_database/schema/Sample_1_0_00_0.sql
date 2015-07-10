set nocount on

declare @currentVersion nvarchar(128)
declare @schemaName nvarchar(64)
declare @installPatch int

set @schemaName = 'PROJECTNAME_SCHEMA'

select @currentVersion = VersionIdentifier
from SchemaVersion 
where SchemaName = @schemaName and IsCurrentVersion	= 1

exec @installPatch = usp_dba_Schema @Update=@schemaName, @Version='0.0.0.0', @With='1.0.0.0'
if(@installPatch = 1)
begin
	begin try
		begin transaction 
		
-- Write your create script here...		
		/*	create table RecipeBox_Steps (
				ID uniqueidentifier not null rowguidcol default(newsequentialid()),
				Instructions nvarchar(max) not null,
				Ordinal int not null,
				RecipeID uniqueidentifier not null,
				CreatedDate datetime not null,
				CreatedBy nvarchar(32) not null,
				ModifiedDate datetime not null,
				ModifiedBy nvarchar(32) not null,
				IsDeleted bit not null default(0),
				constraint PK_Steps_ID primary key (ID),
				constraint FK_Steps_Recipes foreign key (RecipeID) references RecipeBox_Recipes (ID)
			);
		*/
			exec usp_dba_SetCurrentSchema @schemaName, '1.0.0.0'
		commit transaction
	end try
	begin catch
		rollback transaction
	
		exec usp_RethrowError
	end catch
end
 
 set nocount off
 
 GO

 