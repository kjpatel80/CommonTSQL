USE [DemoCareNet]
go

ALTER TABLE dbo.tblPerson
ADD Status VARCHAR(20) 

go
ALTER TABLE dbo.tblPerson
ADD OfficeName VARCHAR(20)

go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSelectPersonBetweenBirthDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spSelectPersonBetweenBirthDates]
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[spSelectPersonBetweenBirthDates]
 
 @BirthDate1 SMALLDATETIME, 
 @BirthDate2 SMALLDATETIME 

AS

SELECT PersonID
      ,FirstName
      ,LastName
      ,MiddleName
      ,BirthDay BirthDate 
	  ,PersonType
      ,Active
	  ,Status	
	  ,OfficeName

FROM dbo.tblPerson
  
WHERE dbo.fncNextBirthday(BirthDay) between @BirthDate1 and @BirthDate2
ORDER BY PersonType, dbo.fncNextBirthday(BirthDay), lastname, FirstName 

--ORDER BY PersonType
--		,BirthDate  
--		,LastName		
--		,FirstName
--        ,MiddleName ASC
--		

--EXEC [spSelectPersonBetweenBirthDates] '01/01/2009','03/06/2009'
--EXEC [spSelectPersonBetweenBirthDates] '01/01/1995','01/01/1995'

go

Use [Master]
go