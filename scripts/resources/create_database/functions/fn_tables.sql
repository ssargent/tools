/*
###########################################################
-- Name: fn_tables.sql
-- Type: Function
-- Author: Someone
-- Purpose: Lists tables
###########################################################
*/
if(object_id('fn_tables') is not null)
	drop function fn_tables;
GO
create function fn_tables()
 returns @Tables table (tablename sysname)
as
begin
	insert into @Tables
		select table_name from INFORMATION_SCHEMA.TABLES
	return
end
GO
 