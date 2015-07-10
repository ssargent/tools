/*
###########################################################
-- Name: usp_tables.sql
-- Type: Stored Procedure
-- Author: Someone
-- Purpose: Lists tables
###########################################################
*/
if(object_id('usp_tables') is not null)
	drop procedure usp_tables
GO
create procedure usp_tables
as 
begin
	select table_name from INFORMATION_SCHEMA.TABLES
end
GO
 