--SELECT * FROM usysversion
USE MASTER
GO
DECLARE @Cmd VARCHAR(500)
SET @Cmd = ''
SELECT @Cmd = @Cmd + 'Kill '+ STR(master.dbo.sysprocesses.spid) + CHAR(13)
FROM master.dbo.sysprocesses
	INNER JOIN master.dbo.sysdatabases
	ON master.dbo.sysprocesses.dbid = master.dbo.sysdatabases.dbid

WHERE master.dbo.sysdatabases.name LIKE 'CaringPeople'
Print @Cmd 	-- Print is just for dibugging purpose.
Exec(@Cmd)
GO
--backup database CaringPeople to disk = 'F:\MSSQL\SQL2005\CaringPeople\CaringPeople Scrubed As Of Feb 20 2011  4 16AM'
--CaringPeople Scrubed As Of Feb 15 2011  1 44AM
RESTORE DATABASE [CaringPeople]
FROM DISK = N'F:\MSSQL\SQL2005\CaringPeople\Caringpeople Scrubed As Of Mar  4 2011 11 52PM'
WITH FILE = 1,
MOVE N'CaringPeople' TO N'F:\MSSQL\SQL2005\CaringPeople\CaringPeople.mdf',  
MOVE N'CaringPeople_Log' TO N'F:\MSSQL\SQL2005\CaringPeople\CaringPeople_log.ldf',  
NOUNLOAD,  REPLACE,  STATS = 17
GO
USE CaringPeople
GO
EXEC spScrub 
GO
EXEC spRestoreLogins
GO
SELECT * FROM CaringPeople.dbo.usysversion ORDER BY VersionID DESC
--SELECT * FROM CaringPeople.dbo.usysSupportversion ORDER BY VersionID DESC

/*
Select * from tblCLient
SELECT * FROM CaringPeople.dbo.usyssupportversion Order by VersionID desc
SELECT * FROM CaringPeople.contact.usysversion Order by VersionID desc
Select * from contact.tblAddress where ForeignTableName ='tblClient'
Select * from contact.tblAddress where ForeignTableName ='tblpERSON' and ForeignKeyID IN (sELECT CLIENTid FROM tblClient)
Select * from contact.tblAddress where ForeignKeyID = 6

UPDATE aspnet_Membership
SET Password = '123'
,PasswordFormat = 0
WHERE     UserId = '6646a5bf-24da-46e2-8784-7b9fdc3dc6b1'
*/
go
/*
UPDATE aspnet_Membership
SET Password = '123'
,PasswordFormat = 0
WHERE     UserId = '6646a5bf-24da-46e2-8784-7b9fdc3dc6b1'
*/