/*
--usr2, irg, caringenterprise, uscc
update dbo.aspnet_Membership SET Password = 'idbadmin123!@#'

--daniel, newengland, ssuzwp, SurgerySchedule

UPDATE tblPerson SET Password = 'idbadmin123!@#'

update dbo.aspnet_Membership SET Password = 'idbadmin123!@#'

update dbo.aspnet_Membership SET PasswordFormat = 1
where UserID = 'D2F87083-8DBA-4816-BBD3-DC2E48735C0C'

update dbo.aspnet_Membership SET Password = 'flatsatwick#1234'
where UserID = 'D2F87083-8DBA-4816-BBD3-DC2E48735C0C'

update dbo.aspnet_Membership SET PasswordFormat = 0

where UserID = 'D2F87083-8DBA-4816-BBD3-DC2E48735C0C'
*/

SELECT [ApplicationId]
      ,[UserId]
      ,[Password]
      ,[PasswordFormat]
      ,[PasswordSalt]
      /*,[MobilePIN]
      ,[Email]
      ,[LoweredEmail]
      ,[PasswordQuestion]
      ,[PasswordAnswer]
      ,[IsApproved]
      ,[IsLockedOut]
      ,[CreateDate]
      ,[LastLoginDate]
      ,[LastPasswordChangedDate]
      ,[LastLockoutDate]
      ,[FailedPasswordAttemptCount]
      ,[FailedPasswordAttemptWindowStart]
      ,[FailedPasswordAnswerAttemptCount]
      ,[FailedPasswordAnswerAttemptWindowStart]
      ,[Comment]*/
  FROM [dbo].[aspnet_Membership]
--Select * from password