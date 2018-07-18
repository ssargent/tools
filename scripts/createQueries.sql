
declare @table as sysname
set @table = 'my-table-name';

declare @columnList varchar(max)
declare @outputList varchar(max)
declare @paramList varchar(max)
declare @updateList varchar(max)

select @columnList = csv from (
select 
   distinct  
    stuff((
		select ', ' +  column_name from INFORMATION_SCHEMA.columns c1 
		where table_name = @table and c1.COLUMN_NAME = COLUMN_NAME
		order by c1.ORDINAL_POSITION
        for xml path('')
    ),1,1,'') as csv
from INFORMATION_SCHEMA.COLUMNS
where table_name = @table
group by ORDINAL_POSITION
) drv
 
select @outputList = csv from (
select
   distinct  
    stuff((
		select ', inserted.' +  column_name from INFORMATION_SCHEMA.columns c1 
		where table_name = @table and c1.COLUMN_NAME = COLUMN_NAME
		order by c1.ORDINAL_POSITION
        for xml path('')
    ),1,1,'') as csv
from INFORMATION_SCHEMA.COLUMNS
where table_name = @table
group by ORDINAL_POSITION
) drv

select @paramList = csv from (
select
   distinct  
    stuff((
		select ', @' +  column_name from INFORMATION_SCHEMA.columns c1 
		where table_name = @table and c1.COLUMN_NAME = COLUMN_NAME
		order by c1.ORDINAL_POSITION
        for xml path('')
    ),1,1,'') as csv
from INFORMATION_SCHEMA.COLUMNS
where table_name = @table
group by ORDINAL_POSITION
) drv

select @updateList = csv from (
select
   distinct  
    stuff((
		select ', ' + column_name + ' =  @' +  column_name from INFORMATION_SCHEMA.columns c1 
		where table_name = @table and c1.COLUMN_NAME = COLUMN_NAME
		order by c1.ORDINAL_POSITION
        for xml path('')
    ),1,1,'') as csv
from INFORMATION_SCHEMA.COLUMNS
where table_name = @table
group by ORDINAL_POSITION
) drv

print '--------------------------------------------------------------------------------------------------------------------------------------'
print ' INSERT '
print '--------------------------------------------------------------------------------------------------------------------------------------'
print 'insert into ' + @table + ' (' + @columnList + ')'
print 'output ' + @outputList + ' '
print 'values (' + @paramList + ');'

print '--------------------------------------------------------------------------------------------------------------------------------------'
print ' UPDATE '
print '--------------------------------------------------------------------------------------------------------------------------------------'
print 'update ' + @table + ' set ' + @updateList + ' '
print 'output ' + @outputList + ' '
print 'where Id = @Id '

select 'item.' + column_name + ',' from INFORMATION_SCHEMA.COLUMNS where table_name = @table;