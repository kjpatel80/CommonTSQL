USE [MRS]
GO
/****** Object:  StoredProcedure [dbo].[spTransactionInsert]    Script Date: 09/24/2010 12:02:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spTransactionInsert]
(
	@TransactionList	XML
	, @CheckNumber		VARCHAR(25)
	, @RequestorID		INT
	, @SignInID			INT
)
AS
/*
Purpose			: User in receive payment usecase, insert record in tblTransaction on save click in receive payment
Date Created	: 20100521
Author			: Kalpesh
Version			: 38.00

Ref.    		:     
Para.    		:     
DeliverableID	: 2468
    

Update History:    
Date Modified		Author		Version	 		DeliverableID	ReasON    

*/
BEGIN
SET NOCOUNT ON;

	--DECLARE @TransactionList		XML
	DECLARE @iTransactions			INT	
	DECLARE @TransactionListDate	DATETIME
	DECLARE @Amount					DECIMAL(9,2)
	DECLARE @Notes					VARCHAR(250)
	DECLARE @TransactionListTypeIDF	TINYINT
	DECLARE @RequestID				INT
		
	EXEC sp_xml_preparedocument @iTransactions OUTPUT, @TransactionList
	IF @@ERROR <> 0 
	BEGIN
		EXEC sp_xml_removedocument @iTransactions
		RAISERROR('Problem in Search. ',16,1)
		RETURN 
	END  

	DECLARE @Transactions TABLE 
	(
		TransactionDate		DATETIME
		,Amount				DECIMAL(9,2)
		,Notes				VARCHAR(250)
		,TransactionTypeIDF	TINYINT
		,RequestID			INT		
	)	

	INSERT @Transactions(TransactionDate, Amount, Notes, TransactionTypeIDF, RequestID)
	SELECT DeliverableXML.TransactionDate
		, DeliverableXML.Amount
		, DeliverableXML.Notes
		, DeliverableXML.TransactionTypeIDF
		, DeliverableXML.RequestID		
	FROM OPENXML (@iTransactions, '/NewDataSet/tblTransaction', 2) 
	WITH (
		TransactionDate			DATETIME
		, Amount				DECIMAL(9,2)
		, Notes					VARCHAR(250)
		, TransactionTypeIDF	TINYINT
		, RequestID			INT		
		) DeliverableXML  

	SELECT * FROM @Transactions
BEGIN TRY
BEGIN TRAN

	--Find open deposit batch, if not exist open new batch
	DECLARE @DepositBatchID AS INT
	SET @DepositBatchID = 0 

	SELECT @DepositBatchID = ISNULL(MAX(DepositBatchID) , 0)
	FROM vDepositBatch
	WHERE DateCompleted IS NULL

	IF @DepositBatchID = 0 
	BEGIN
		--Open new batch
		INSERT INTO vDepositBatch( SignInIDF, DateCreated)
		SELECT @SignInID, GETDATE()

		SET @DepositBatchID = SCOPE_IDENTITY()
		--SELECT @DepositBatchID
	END

	--Insert payment
	INSERT INTO vPayment(SignInIDF, CheckNumber, RequestorIDF, DepositBatchIDF)
	SELECT @SignInID, @CheckNumber, @RequestorID, @DepositBatchID

	DECLARE @PaymentID AS INT
	SET @PaymentID = SCOPE_IDENTITY()

	--Insert transcation

		INSERT INTO tblTransaction
		(
			SignInIDF
			, TransactionDate
			, Amount
			, Notes
			, TransactionTypeIDF
			--, LateFeePercent
			, RequestIDF
			, PaymentIDF
		)
		SELECT 
			@SignInID					--SignInIDF		
			, TransactionDate			--TransactionDate	
			, Amount
			, Notes						--Notes
			, TransactionTypeIDF			--Late Fee	Payment SELECT * FROM usysTransactionType
			--,DefaultLateFeePercent		--LateFeePercent
			, RequestID					--RequestIDF
			, @PaymentID
		FROM @Transactions

COMMIT TRAN
END TRY

BEGIN CATCH
	if error_number()<> 0 RAISERROR('Error on data saving',16,1)	
	ROLLBACK TRAN
END CATCH


/*
	exec spTransactionInsert	@TransactionList
		=
		'<NewDataSet>
		<tblTransaction>
		<TransactionDate>2010-05-20</TransactionDate>
		<Amount>10</Amount>
		<Notes></Notes>
		<TransactionTypeIDF>1</TransactionTypeIDF>
		<RequestID>41331</RequestID>
		</tblTransaction>
		<tblTransaction>
		<TransactionDate>2010-05-20</TransactionDate>
		<Amount>20</Amount>
		<Notes></Notes>
		<TransactionTypeIDF>3</TransactionTypeIDF>
		<RequestID>41331</RequestID>
		</tblTransaction>		
		
		</NewDataSet>', @SignInID = 17
		, @CheckNumber  = '170017'
		, @RequestorID = 17
		
		'<NewDataSet>
		<tblTransaction>
		<TransactionDate>2010-05-20</TransactionDate>
		<Amount>10</Amount>
		<TransactionTypeIDF>1</TransactionTypeIDF>
		<RequestIDF>41331</RequestIDF>
		</tblTransaction>
		<tblTransaction>
		<TransactionDate>2010-05-20</TransactionDate>
		<Amount>100</Amount>
		<TransactionTypeIDF>1</TransactionTypeIDF>
		<RequestID>42952</RequestID>
		</tblTransaction></NewDataSet>'
*/
SET NOCOUNT OFF;
END
