USE Madeksho
GO
set nocount on;
--begin tran
	DECLARE @tempTable AS TABLE(tsql1 VARCHAR(500))
	
	IF OBJECT_ID('dbo.IDProvider', 'U') IS NOT NULL
		DROP TABLE dbo.IDProvider;

	CREATE TABLE IDProvider(TableName varchar(100), MaxID INT, TableSchema Varchar(50))

	INSERT INTO @tempTable
	SELECT 'INSERT INTO [dbo].[IDProvider] SELECT ''' + TABLE_NAME + ''', ISNULL(MAX(' + TABLE_NAME + 'ID),1), '''+TABLE_SCHEMA+''' from ' + TABLE_SCHEMA + '.' + TABLE_NAME + ' GO '   tsql1
	FROM 
	(
		SELECT tb.TABLE_SCHEMA, tb.TABLE_NAME 
		FROM INFORMATION_SCHEMA.TABLES  tb
			INNER JOIN INFORMATION_SCHEMA.COLUMNS  cl
				ON tb.TABLE_NAME = cl.TABLE_NAME 
					--AND COLUMN_NAME = SUBSTRING(tb.TABLE_NAME, 4,99) + 'ID'
		WHERE tb.TABLE_TYPE = 'base table'
			and (tb.TABLE_NAME not like 'usys%'
			and tb.TABLE_NAME not like 'aspnet%'
			and tb.TABLE_NAME not like 'IDPRO%'
			)
		GROUP BY tb.TABLE_SCHEMA, tb.TABLE_NAME
	) a

	--Select * from @tempTable

	DECLARE @A VARCHAR(MAX)
	SET @A = ''
	SELECT @A = @A  + CAST(tsql1 AS VARCHAR(MAX)) FROM @tempTable
	EXECUTE (@A)

	--Select * From IDProvider

	SELECT IDProvider.tableName, IDProvider.TableSchema, t.name Col, row_number() over(order by object_id) SrNo, MaxID
	INTO #Temp
	FROM sys.identity_columns t
		inner join INFORMATION_SCHEMA.TABLES tab on OBJECT_NAME(object_id) = tab.TABLE_NAME
		inner join IDProvider
			on tab.TABLE_NAME =  IDProvider.tableName
			AND tab.table_schema =  IDProvider.TableSchema
	--where tab.TABLE_TYPE = 'base table'

	Declare @Tab as Varchar(100), @Sch as Varchar(100)
		, @Val as INT
		, @iCnt as INT

	Select @iCnt = max(Srno) From #Temp 

	while(@iCnt>=0)
	begin
		Select @Tab = TableSchema + '.' +tableName
			, @Val = maxid
		From #Temp
		where SrNo = @iCnt

		DBCC CHECKIDENT (@Tab, RESEED,@Val);
		set @iCnt  = @iCnt - 1
	end


--rollback tran




--Select * from dbo.IDProvider

/*
begin tran

INSERT INTO ClientStatus(ClientStatusName, SystemControlled) VALUES('Awaiting Medical 2',1)

--DBCC CHECKIDENT(ClientStatus)

select * from ClientStatus
rollback tran

DBCC CHECKIDENT (ClientStatus, RESEED,9);
--exec sp_MSforeachtable @command1 = 'DBCC CHECKIDENT(''?'', RESEED, 0)'

select * from ClientStatus 
rollback tran

*/
set nocount off;