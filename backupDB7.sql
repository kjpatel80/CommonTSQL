BACKUP DATABASE [CaringPeople] TO
DISK = N'C:\CaringPeople.BAK' --physical pah
WITH DESCRIPTION = N'CaringPeople-Full Database Backup', --description
NOFORMAT, NOINIT, NAME = N'CaringPeople.BAK', --backup name
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

/*
BACKUP DATABASE [Enterprise] TO  DISK = 'c:\Enterprise_20100517.bak'
BACKUP DATABASE [Enterprisehelp] TO  DISK = 'c:\Enterprisehelp_20100517.bak'
BACKUP DATABASE [EnterpriseCRM] TO  DISK = 'c:\EnterpriseCRM_20100517.bak'
*/


--Chicago.BAK



SELECT * FROM CaringPeople.dbo.usysVersion order by versionID desc
SELECT * FROM CaringPeople.dbo.usysSupportVersion order by versionID desc



Restore database CaringPeople FROM 
disk = 'c:\Temp\CaringPeople.BAK' with noRecovery , Replace
, move 'Caringpeople' To 'D:\Database\STANDARD2005\CaringPeople.mdf'
, move 'Caringpeople_Log' To 'L:\Log\STANDARD2005\CaringPeople_Log.ldf'
Restore database CaringPeople With recovery

--EXEC CaringPeople.dbo.spRestoreLogins
SELECT * FROM CaringPeople.dbo.usysVersion


alter table tblaidecaringoffice
alter column CaringOfficeIDF int


SELECT * FROM CaringPeople.dbo.usysVersion order by versionID desc
SELECT * FROM CaringPeople.dbo.usysSupportVersion order by versionID desc

tblEmployeecredential

use sam
go
--If we match aides on SSN, emp_no, and off_code, how many cases do we have where the names are different?
select --char(39) + ssn + char(39) + ','

socialsecuritynumber, ssn,
sam_emp_no,
sam_off_code,
firstName +' ' + lastName as [CPA_Name] , first_name + ' ' + last_name SAM_Name,
BirthDay CPABirthDay,
birth_date SAMBirthDay,
datecreated,
maxvisitDate
, aideid

from CaringPeople..tblAide
inner join CaringPeople.dbo.tblAideCaringOffice aco on AideID = aideidf
inner join CaringPeople..tblCaringoffice co on caringofficeid= caringofficeidF
inner join CaringPeople.contact.tblPerson on personid = aideid
inner join employee on
ssn = socialsecuritynumber
and sam_emp_no = emp_no
and sam_off_code = off_Code
--where lastName = 'Dorneval' or last_name = 'Dorneval'
left join
(
select emp_no, off_code, max(care_date) maxvisitDate
from visit
group by emp_no, off_code
) v on v.emp_no = employee.emp_no
and v.off_code = employee.Off_code
where lastname <> last_name
--and datecreated < '2010-11-22 07:30:00'
and V.emp_No is not null
order by maxvisitdate


--select count(*)
--from CaringPeople.contact.tblperson
--where datecreated between '11/22/2010' and '11/23/2010'
--
--
--select * from employee where last_name = 'thomas' and first_name = 'gina'
--select * from employee where last_name = 'Oakes' and first_name = 'Javon'
--
--select * from office




Select * from dbo.tblAideCaringoffice where AideiDF = 39761
Select * from dbo.tblAide where AideiD in ( 39761,39762,39763,45696)
Select * from contact.tblPerson where PersonID in ( 39761,39762,39763,45696)
Select * from dbo.tblAideCaringoffice where sam_emp_no = 'A00819'
Select * from sam.dbo.employee where emp_no = 'A00819'