use EventPlanning;
Go
create Procedure newTable (@tablename varchar(50), @columnname varchar(50),  @columnname2 varchar(50), @datatype varchar(50),  @datatype2 varchar(50) )
as
  	BEGIN
	DECLARE @sqlQuery as varchar(MAX) 
	SET @sqlQuery = 'CREATE TABLE ' + @tableName + '(' + @columnname + '  ' + @datatype  + ' PRIMARY KEY ' + ',' + @columnname2 + '  ' + @datatype2 + ')';
    print(@sqlQuery)
    exec(@sqlQuery)
    end

	DECLARE @v INT
	SET @v = ( SELECT COUNT(*) FROM history )
	SET @v=@v+1

	INSERT INTO history (ProcedureName, version_column ,param1, param2, param3, param4, param5) VALUES ('AddTable', @v ,@tablename, @columnname, @datatype, @columnname2, @datatype2)
	update  Version set version_column = @v 

go

create Procedure newTable2 (@tablename varchar(50), @columnname varchar(50),  @columnname2 varchar(50), @datatype varchar(50),  @datatype2 varchar(50) )
as
  	BEGIN
	DECLARE @sqlQuery as varchar(MAX) 
	SET @sqlQuery = 'CREATE TABLE ' + @tableName + '(' + @columnname + '  ' + @datatype  + ' PRIMARY KEY ' + ',' + @columnname2 + '  ' + @datatype2 + ')';
    print(@sqlQuery)
    exec(@sqlQuery)
    end

--3.ROLLBACK TABLE
go

create Procedure DropTable (@tablename varchar(50))
as
  	BEGIN
	DECLARE @sqlQuery as varchar(MAX)
	SET @sqlQuery = 'DROP TABLE ' + @tableName ; 
    print(@sqlQuery)
    exec(@sqlQuery)
    end
go

go

alter PROCEDURE ModifyType (@tablename varchar(50), @columnName varchar(50), @datatype varchar(50))
 as 
			DECLARE @prev varchar(20)
	SET @prev = (SELECT DATA_TYPE 
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE 
		TABLE_NAME = @tablename AND 
		COLUMN_NAME = @columnName)


	declare @sqlQuery as varchar(max) 
	set @sqlQuery=' Alter table ' + @tablename + ' Alter column ' + @columnName + ' ' +@datatype;
	print(@sqlQuery) 
	exec(@sqlQuery)

	DECLARE @v INT
	SET @v = ( SELECT COUNT(*) FROM history )
	SET @v=@v+1

	INSERT INTO history (ProcedureName, version_column ,param1, param2, param3, param4) VALUES ('ModifyType', @v ,@tablename, @columnName, @datatype, @prev)
	update  Version set version_column = @v
 go

 --pt rollback
create PROCEDURE ModifyType2 (@tablename varchar(50), @columnName varchar(50), @datatype varchar(50))
 as 
	declare @sqlQuery as varchar(max) 
	set @sqlQuery=' Alter table ' + @tablename + ' Alter column ' + @columnName + ' ' +@datatype;
	print(@sqlQuery) 
	exec(@sqlQuery)

 go

 --pt history
 create PROCEDURE ModifyType3 (@tablename varchar(50), @columnName varchar(50), @datatype varchar(50))
 as 
	declare @sqlQuery as varchar(max) 
	set @sqlQuery=' Alter table ' + @tablename + ' Alter column ' + @columnName + ' ' +@datatype;
	print(@sqlQuery) 
	exec(@sqlQuery)

go

alter Procedure addConstraint (@tablename varchar(50), @columnname varchar(50), @default  varchar(50), @constraint varchar(50))
as
  	BEGIN
	DECLARE @sqlQuery as varchar(MAX)
	SET @sqlQuery = 'ALTER TABLE ' + @tableName + ' ADD CONSTRAINT ' + @constraint + ' DEFAULT ''' + @default + ''' FOR ' + @columnName
    print(@sqlQuery)
    exec(@sqlQuery)
    end

	DECLARE @v INT
	SET @v = ( SELECT COUNT(*) FROM history )
	SET @v=@v+1

	INSERT INTO history (ProcedureName, version_column ,param1, param2, param3,param4) VALUES ('AddConstraint', @v ,@tablename, @constraint, @default, @columnName)
	update  Version set version_column = @v
go

create Procedure addConstraint2 (@tablename varchar(50), @columnname varchar(50), @default  varchar(50), @constraint varchar(50))
as
  	BEGIN
	DECLARE @sqlQuery as varchar(MAX)
	SET @sqlQuery = 'ALTER TABLE ' + @tableName + ' ADD CONSTRAINT ' + @constraint + ' DEFAULT ''' + @default + ''' FOR ' + @columnName
    print(@sqlQuery)
    exec(@sqlQuery)
    end
go
--2. ROLLBACK CONSTRAINT
create Procedure DropConstraint (@tablename varchar(50), @constraint  varchar(50))
as
  	BEGIN
	DECLARE @sqlQuery as varchar(MAX)
	--SET @sqlQuery = 'ALTER TABLE ' + @tableName + ' ALTER COLUMN ' + @columnname + '  DROP DEFAULT ''' + @default ;
    set @sqlQuery=' Alter table ' + @tableName+ ' Drop constraint ' + @constraint
	print(@sqlQuery)
    exec(@sqlQuery)
    end
go

alter Procedure addColumn (@tablename varchar(50), @columnname varchar(50), @datatype varchar(50) )
as
  	BEGIN
	DECLARE @sqlQuery as varchar(MAX) 
	SET @sqlQuery = 'ALTER TABLE ' + @tableName + ' ADD ' + @columnname + ' ' + @datatype ;
    print(@sqlQuery)
    exec(@sqlQuery)
    end

	DECLARE @v INT
	SET @v = ( SELECT COUNT(*) FROM history )
	SET @v=@v+1
	INSERT INTO history (ProcedureName, version_column ,param1, param2, param3) VALUES ('AddColumn', @v ,@tablename, @columnName, @datatype)
		update  Version set version_column = @v 
go

alter Procedure addColumn2 (@tablename varchar(50), @columnname varchar(50), @datatype varchar(50) )
as
  	BEGIN
	DECLARE @sqlQuery as varchar(MAX) 
	SET @sqlQuery = 'ALTER TABLE ' + @tableName + ' ADD ' + @columnname + ' ' + @datatype ;
    print(@sqlQuery)
    exec(@sqlQuery)
    end

go

create Procedure DropColumn (@tablename varchar(50), @columnname varchar(50) )
as
  	BEGIN
	DECLARE @sqlQuery as varchar(MAX) 
	SET @sqlQuery = 'ALTER TABLE ' + @tableName + ' DROP COLUMN ' + @columnname ;
    print(@sqlQuery)
    exec(@sqlQuery)
    end
go

create Procedure FkConstraint @tablename1 varchar(50), @columnname1 varchar(50),@tablename2 varchar(50), @columnname2 varchar(50)
    as
    begin
    declare @sqlQuery as varchar(1000)
    set @sqlQuery=' Alter table ' + @tablename1+ ' Add Constraint '+ 'FK'+@tablename1+@tablename2 + ' Foreign key '+ '( '+ @columnname1 + ') '+ ' References '+ @tablename2+ '( '+@columnname2+ ')'
    print(@sqlQuery)
    exec(@sqlQuery)
    end

	DECLARE @v INT
	SET @v = ( SELECT COUNT(*) FROM history )
	SET @v=@v+1
	INSERT INTO history (ProcedureName, version_column ,param1, param2, param3, param4) VALUES ('FkConstraint', @v ,@tablename1, @columnname1, @columnname2, @tablename2)
	update  Version set version_column = @v 
go

create Procedure FkConstraint2 @tablename1 varchar(50), @columnname1 varchar(50),@tablename2 varchar(50), @columnname2 varchar(50)
    as
    begin
    declare @sqlQuery as varchar(1000)
    set @sqlQuery=' Alter table ' + @tablename1+ ' Add Constraint '+ 'FK'+@tablename1+@tablename2 + ' Foreign key '+ '( '+ @columnname1 + ') '+ ' References '+ @tablename2+ '( '+@columnname2+ ')'
    print(@sqlQuery)
    exec(@sqlQuery)
    end
go

create Procedure DropFkConstraint @tablename1 varchar(50),@tablename2 varchar(50)
as
    begin
    declare @sqlQuery as varchar(1000)
    set @sqlQuery=' Alter table ' + @tablename1+ ' Drop Constraint '+ 'FK'+@tablename1 + @tablename2
    print(@sqlQuery)
    exec(@sqlQuery)
    end
go

--procedure back&forth Versions
alter PROCEDURE VersionNummer(@Nummer int)
AS
BEGIN

	DECLARE @v INT
	SET @v = ( SELECT version_column FROM Version) 
	
	DECLARE @namepr varchar(20)
	DECLARE @param1 varchar(20)
	DECLARE @param2 varchar(20)
	DECLARE @param3 varchar(20)
	DECLARE @param4 varchar(20)
	DECLARE @param5 varchar(20)
	DECLARE @current_versiune int

	if(@Nummer<@v)
	BEGIN

	update  Version set version_column = @Nummer 
	
	WHILE(@v>@Nummer)
	BEGIN
		Select @current_versiune=history.version_column, 
		@namepr=history.ProcedureName, @param1=history.param1, 
		@param2=history.param2, @param3=history.param3, @param4=history.param4,
		@param5=history.param5 from history where version_column=@v --versiunea curenta
	
		if(@namepr='addColumn')
		BEGIN
			exec DropColumn @param1, @param2;
		END
		else
		if(@namepr='addTable')
		BEGIN
			exec DropTable @param1;
		END
		else
		if(@namepr='ModifyType')
		BEGIN
			exec ModifyType3 @param1, @param2, @param4;
			
		END
		if(@namepr='FkConstraint')
		BEGIN
			exec DropFkConstraint @param1, @param4;
		END
		if(@namepr='addConstraint')
		BEGIN
			exec DropConstraint @param1, @param2;
		END
	
		SET @v=@v-1
		
	END

END
ELSE
	BEGIN

			update  Version set version_column = @Nummer
	SET @v=@v+1

		 print(@v)

	
	WHILE(@v<=@Nummer)
	BEGIN
		Select @current_versiune=history.version_column, 
		@namepr=history.ProcedureName, @param1=history.param1, 
		@param2=history.param2, @param3=history.param3, @param4=history.param4,
		@param5=history.param5 from history where version_column=@v --versiunea curenta
	
		if(@namepr='addColumn')
		BEGIN
			exec addColumn2 @param1, @param2, @param3;
			print 'AddColumn'
		END
		else
		if(@namepr='addTable')
		BEGIN
			exec newTable2 @param1, @param2, @param4, @param3, @param5;
			print 'addtable'
		END
		else
		if(@namepr='ModifyType')
		BEGIN
			exec ModifyType2 @param1, @param2, @param3;
			print 'modifytype'
			
		END
		if(@namepr='FkConstraint')
		BEGIN
			exec FkConstraint2 @param1, @param2, @param4, @param3;
			print 'fkconstraint'
		END
		if(@namepr='addConstraint')
		BEGIN
			exec addConstraint2 @param1, @param4, @param3, @param2;
			print 'addconstraint'
		END
		
		SET @v=@v+1
	
	END
		
	END

END 
GO

--EXEC teil1
exec ModifyType @tablename='Ex5', @columnName='column3', @datatype='int';
exec ModifyType @tablename='Product', @columnName='Price', @datatype='float';

exec addConstraint @tablename='Ex5', @columnname='column2', @default='''jj''', @constraint='df_column3';
exec addConstraint @tablename='Ex5', @columnname='column2', @default='10', @constraint='df_column3';
exec DropConstraint  @tablename='Ex5', @constraint='df_column3';

exec newTable @tablename='Table1', @columnname='column1', @columnname2='column2', @datatype='int', @datatype2='int';
exec newTable @tablename='Table2', @columnname='column1', @columnname2='column2', @datatype='int', @datatype2='varchar(50)';
exec DropTable @tablename='Tabel1';
exec DropTable @tablename='Tabel2';
exec DropTable @tablename='Ex5';

exec addColumn @tablename='Ex5', @columnname='column3',  @datatype ='float';
exec DropColumn @tablename='Tabel1', @columnname='column3';

exec FkConstraint @tablename1='Ex5', @columnname1='column2',  @tablename2='Tabel1', @columnname2='column1';
exec DropFkConstraint @tablename1='Ex5', @tablename2='Tabel1';

CREATE TABLE history(ProcedureName  varchar(20) NOT NULL, version_column int, param1 varchar(20), param2 varchar(20), param3 varchar(20), param4 varchar(20),param5 varchar(20), param6 varchar(20)) 
CREATE TABLE Version(version_column  int )
insert into Version(version_column) values(0)

DROP table history
DROP table Version
DROP TABLE table1

select * from Version;
select* from history

CREATE TABLE Table2(column1 int, PRIMARY KEY (column1))
DROP TABLE Table2

exec newTable @tablename='Table1', @columnname='column1', @columnname2='column2', @datatype='int', @datatype2='int';
exec addColumn @tablename='Table1', @columnname='column3',  @datatype ='int';
exec addColumn @tablename='Table1', @columnname='column4',  @datatype ='varchar(20)';
exec FkConstraint @tablename1='Table1', @columnname1='column3',  @tablename2='Table2', @columnname2='column1';
exec ModifyType @tablename='Table1', @columnName='column2', @datatype='float';
exec addConstraint @tablename='Table1', @columnname='column4', @default='abc', @constraint='df_column3';

exec VersionNummer 6 