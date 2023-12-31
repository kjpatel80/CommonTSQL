set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROC [dbo].[spProductPriceSelectOnPriceScheduleIDForPriceSchedule]
@PriceScheduleID INT
AS
/*
Purpose			: Select ProductPrice based on PriceScheduleID.
Date Created	: 20090304
Author			: Mehul
Version			: 96.00

Ref. 			: IRG SRS VSS.doc, IRG Concept Model.vsd
Para. 			: 


Update History:
Date Modified	Author:	Version:	Reason
20090604		Avtar				Modified the No. coloumns being selected.
20090625		Avtar				Added DownloadSpeed and UploadSpeed
20090726		Avtar				Modified the Formula to calculate listprice, discountprice and shceduleprice
20090729		Avtar				Changed the formula to generate discountPrice and listprice as from now markupPercent will hold non divided by 100 value
20090803		Avtar				Added IsDelete Field
20090806		Avtar				Added PriceScheduleID Field to make both SP result structure same.
20090808		Avtar				Added Fields like ProductClass, SubClass, VendorTier and Description
20090808		Avtar				Added Calculation for PrecommisionMargin
PARAMETER NOTES:
*/
BEGIN

SELECT 

ProductPriceID, 
PriceScheduleID,
SchedulePrice, 
(dbo.vPart.BaseCost * (1 + (dbo.vProductClass.MarkupPercent ))) * (1 - (disc.DiscountPercentage )) DiscountPrice,
dbo.vPart.BaseCost * (1 + (dbo.vProductClass.MarkupPercent )) ListPrice,
CASE 
	WHEN ISNULL(dbo.vPart.BaseCost, 0) = 0 THEN 0
	ELSE ((((dbo.vPart.BaseCost * (1 + (dbo.vProductClass.MarkupPercent ))) * (1 - (disc.DiscountPercentage ))*100)-dbo.vPart.BaseCost)/ dbo.vPart.BaseCost) 
END PreCommissionMarginPercent,
dbo.vPart.PartID, 
dbo.vPart.IRGNumber, 
dbo.vVendor.vendor,
isnull(dbo.vNetwork.DownloadKBPS,0) DownLoadSpeed,
isnull(dbo.vNetwork.UploadKBPS,0) UpLoadSpeed,
0 IsDelete,
vPart.SubClassIDF,
vSubClass.ProductClassIDF,
vVendor.VendorTierIDF,
vPart.IRGDescription,
vNetwork.StaticIPQuantity,
vPart.BaseCost
--,dbo.vProductClassDiscount.DiscountPercentage 
FROM         vPriceSchedule INNER JOIN
                      vProductPrice ON vPriceSchedule.PriceScheduleID = vProductPrice.PriceScheduleIDF INNER JOIN
                      vPart ON vProductPrice.PartIDF = vPart.PartID INNER JOIN
                      vVendor ON vPart.VendorIDF = vVendor.VendorID INNER JOIN
                      vSubClass ON vPart.SubClassIDF = vSubClass.SubClassID INNER JOIN
                      vProductClass ON vSubClass.ProductClassIDF = vProductClass.ProductClassID INNER JOIN
                      vDiscountStructure ON vPriceSchedule.DiscountStructureIDF = vDiscountStructure.DiscountStructureID INNER JOIN
                      vProductClassDiscount AS disc ON vDiscountStructure.DiscountStructureID = disc.DiscountStructureIDF AND 
                      disc.ProductClassIDF = vProductClass.ProductClassID LEFT OUTER JOIN
                      vNetwork ON vPart.PartID = vNetwork.PartIDF
WHERE PriceScheduleID = @PriceScheduleID

END
/*

EXEC [dbo].[spProductPriceSelectOnPriceScheduleIDForPriceSchedule] @PriceScheduleID = 858

*/



