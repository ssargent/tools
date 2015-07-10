/*
###########################################################
-- Name: v_tables.sql
-- Type: view
-- Author: Someone
-- Purpose: Lists tables
###########################################################
*/
if(object_id('v_tables') is not null)
	drop view v_tables;
GO
create view v_tables
as
	select table_name from INFORMATION_SCHEMA.tables
GO
 