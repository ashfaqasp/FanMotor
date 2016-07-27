USE [AES_ASSET_DB]
GO
/****** Object:  StoredProcedure [dbo].[sp_ImportData]    Script Date: 7/20/2016 11:54:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery1.sql|7|0|C:\Users\ADMINI~1.TBL\AppData\Local\Temp\2\~vsC2DD.sql
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[sp_ImportData] 
	
AS
BEGIN

DECLARE @C1 nvarchar(500);
DECLARE @C2 nvarchar(500);
DECLARE @C3 nvarchar(500);
DECLARE @C4 nvarchar(500);
DECLARE @C5 nvarchar(500);
DECLARE @C6 nvarchar(500);
DECLARE @C7 nvarchar(500);
DECLARE @C8 nvarchar(500);
DECLARE @C9 nvarchar(500);
DECLARE @C10 nvarchar(500);
DECLARE @C11 nvarchar(500);
DECLARE @C12 nvarchar(4000);
DECLARE @C13 nvarchar(500);
DECLARE @C14 nvarchar(500);
DECLARE @C15 nvarchar(500);
DECLARE @C16 nvarchar(500);

DECLARE @ParentAssetKeyValue nvarchar(500);
DECLARE @ParentAssetKey nvarchar(500);
DECLARE @AssetIDValue nvarchar(500);
DECLARE @UnitNameValue nvarchar(500);
DECLARE @ParentAssetNameValue nvarchar(500);
DECLARE @AssetNameValue nvarchar(500);
DECLARE @UnitIDValue nvarchar(500);
DECLARE @ParentAssetTypeValue nvarchar(500);
DECLARE @AssetSubTypeValue nvarchar(500);
DECLARE @ParentAssetTypeKey nvarchar(500);
DECLARE @AssetTypeKey nvarchar(500);
DECLARE @DateKeyValue nvarchar(100);
DECLARE @AHIMinValue nvarchar(100); -- = Should be float
DECLARE @ProcedureKeyTemp nvarchar(500); 
DECLARE @ConditionIndicatorName nvarchar(500);
DECLARE @ProcedureName nvarchar(100);
DECLARE @FailureModeName nvarchar(100);




DECLARE @AssetKey nvarchar(500);
DECLARE @ProcedureKey nvarchar(500);
DECLARE @ConditionIndicatorKey nvarchar(500);
DECLARE @FailureModeKey nvarchar(500);
DECLARE @DateKey nvarchar(500) ;
DECLARE @ImpactWeightage nvarchar(500);
DECLARE @TestResult nvarchar(500);
DECLARE @NormalizedCF nvarchar(500);
DECLARE @HealthAlert nvarchar(500);
DECLARE @Notes nvarchar(500);

DECLARE @ParentAssetKeyT nvarchar(500);
DECLARE @PlantNameValue nvarchar(500);

DECLARE @AllParamAreFound bit=0;
DECLARE @DEBUG tinyint = 3; 

DECLARE @InsertEnable bit = 0; 
DECLARE @DataRow bit = 0; 
DECLARE @DataRowEnd bit = 0; 


-- = To insert into dbo.DimPlant table [foreign key from dbo.DimOrganizatoin & dbo.DimLocation]
DECLARE @OrganizationKey int;
DECLARE @LocationKey int;
DECLARE @PlantKey int;
DECLARE @UnitKey int;

-- = Excel column variables for dbo.FactAssetIndicators
DECLARE @AssetHealthIndex nvarchar(500);
DECLARE @DataAvailability nvarchar(500);
DECLARE @ProjectedRemainingLife nvarchar(500);
DECLARE @PotentialUsefulLifeLostPercentage nvarchar(500);
DECLARE @PotentialUsefulLifeLost nvarchar(500);
DECLARE @SetOverAllAsset bit=0;

DECLARE @IsDeleteTestResult bit = 1
DECLARE @IsDeleteAssetIndicators bit = 1

-- = Temporary queries to insert into dbo.DimPlant, could not find any data in excel related to @OrganizationKey and @LocationKey
SET @OrganizationKey = (SELECT TOP 1 OrganizationKey FROM dbo.DimOrganization);
SET @LocationKey = (SELECT TOP 1 LocationKey FROM dbo.DimLocation);
--new addition ends

-- End Of Variables 
 
  
DECLARE vendor_cursor CURSOR FOR   

SELECT [C1],[C2],[C3],[C4],[C5],[C6],
	   [C7],[C8],[C9],[C10],[C11],[C12],
	   [C13],[C14],[C15],[C16]
	   FROM STG_AHI ORDER BY AssetKey
  
OPEN vendor_cursor  
  
FETCH NEXT FROM vendor_cursor   
INTO @C1, @C2, @C3, @C4, @C5, @C6,
	 @C7,@C8,@C9,@C10,@C11, @C12,
	 @C13,@C14,@C15,@C16
  
WHILE @@FETCH_STATUS = 0  
	BEGIN  
    
		IF (RTRIM(LTRIM(@C1)) = 'Plant Name')
		BEGIN 
			SET @PlantNameValue = @C2;
		END

		IF (RTRIM(LTRIM(@C3)) = 'Unit Name')
		BEGIN 
			SET @UnitNameValue = @C4;
		END

		IF (RTRIM(LTRIM(@C5)) = 'Unit ID')
		BEGIN 
			SET @UnitIDValue = @C6;
		END
		
		IF (RTRIM(LTRIM(@C1))='Parent Asset ID')
		BEGIN 
			SET @ParentAssetKeyValue= @C2;
		END

		IF (RTRIM(LTRIM(@C3)) ='Parent Asset Name')
		BEGIN 
			SET @ParentAssetNameValue= @C4;
		END

		IF (RTRIM(LTRIM(@C5)) = 'Parent Asset Type')
		BEGIN 
			SET @ParentAssetTypeValue = @C6;
		END

		IF (RTRIM(LTRIM(@C7)) = 'Asset Sub Type')
		BEGIN 
			SET @AssetSubTypeValue = @C8;
		END

		IF (RTRIM(LTRIM(@C1))='Asset ID')
		BEGIN 
			SET @AssetIDValue= @C2;
		END

		IF (RTRIM(LTRIM(@C3)) = 'Asset Name')
		BEGIN 
			SET @AssetNameValue = @C4;
		END

		IF (RTRIM(LTRIM(@C1)) ='Date of Record:')
		BEGIN 
			SET @DateKeyValue= @C2;
			SET @AHIMinValue= @C11;	
		END



	IF(@C7='Data Availability (Confidence Factor)')
	BEGIN
		
		SET @PotentialUsefulLifeLostPercentage = @C10;
		If @PotentialUsefulLifeLostPercentage = 'Info Reqd.'
			SET @PotentialUsefulLifeLostPercentage = NULL
	END
	IF(@C7='Projected Remaining Useful Life')
	BEGIN
		
		SET @PotentialUsefulLifeLost = @C10;
		If @PotentialUsefulLifeLost = 'Info Reqd.'
			SET @PotentialUsefulLifeLost = NULL
	END

	
	IF(@C10='Individual CI Health Monitor') 
	BEGIN
		IF ((@C13 IS NULL OR @C13='') OR (@C14 IS NULL OR @C14='' OR @C14='0'))
		BEGIN
			SET @AssetHealthIndex=NULL;
		END
		ELSE
		BEGIN
			SET @AssetHealthIndex = (((CONVERT(FLOAT,@C13)) / CONVERT(FLOAT,@C14))*100); 
		END

		IF ((@C16 IS NULL OR @C16='') OR (@C15 IS NULL OR @C15='' OR @C15=0))
		BEGIN
			SET @DataAvailability=NULL;
		END
		ELSE
		BEGIN
			
			SET @DataAvailability = (( CONVERT(FLOAT,@C16) / CONVERT(FLOAT,@C15))*100);
		END
		 
	 
	
		
		
		--SELECT @C13, @C14, @C15, @C16
	END
	IF(@C1='Estimated Useful Life Remaining') 
	BEGIN
		SET @ProjectedRemainingLife = @C3;
	END


	IF (@DEBUG=1) SELECT 'IF Notes found and one of the PARAM value is missing break the excution and RaiseError'
	-- = IF Notes found and one of the PARAM value is missing break the excution and RaiseError
	IF(@C1='Date of Record:')
	BEGIN 
		IF (@DEBUG=1) SELECT @PlantNameValue AS '@PlantNameValue', @ParentAssetKeyValue AS '@ParentAssetKeyValue', @AssetIDValue AS '@AssetIDValue', @UnitNameValue AS '@UnitNameValue', 
		@ParentAssetNameValue AS '@ParentAssetNameValue', @AssetNameValue AS '@AssetNameValue', @UnitIDValue AS '@UnitIDValue', @ParentAssetTypeValue AS '@ParentAssetTypeValue', @AssetSubTypeValue AS '@AssetSubTypeValue'
		

			
		SET @DateKey = (SELECT TOP 1 Date_Day_Key FROM DimDate  WHERE CONVERT(DATE,Day_Date_D)= CONVERT(DATE,@DateKeyValue));
		IF (@DEBUG=1) SELECT @DateKeyValue AS 'Setting up DimDate' , 	@DateKey AS '@DateKey'


		-- = IF PARAM value is missing Rasie Error, otheriwse Set @AllParamAreFound
		IF ((@PlantNameValue IS NULL OR @PlantNameValue='' ) OR 
			 (@AssetIDValue IS NULL OR @AssetIDValue='' ) OR 
			 (@UnitNameValue IS NULL OR @UnitNameValue='' ) OR 
			 (@AssetNameValue IS NULL OR @AssetNameValue='' ) OR 
			 (@UnitIDValue IS NULL OR @UnitIDValue='' ) OR 
			 (@DateKeyValue IS NULL OR @DateKeyValue='' ) OR 
			 (@DateKey IS NULL OR @DateKey='' ) OR 
			 (@ParentAssetTypeValue IS NULL OR @ParentAssetTypeValue='' ))
		 --OR (@AssetSubTypeValue IS NULL OR @AssetSubTypeValue='' )) 
		 --(@ParentAssetKeyValue IS NULL OR @ParentAssetKeyValue='' ) 
		 --(@ParentAssetNameValue IS NULL OR @ParentAssetNameValue='' )
	 
	 BEGIN
		 RAISERROR ('Custom Error: Some Parameter value is NULL OR Empty',16, 1 );  
		 BREAK;
	 END
	 ELSE
	 BEGIN

		-- INSERT into dbo.DimPlant table
		IF (@DEBUG=1) SELECT 'Inserting INTO DimPlant' 
		BEGIN 
			 IF EXISTS ( SELECT TOP 1 PlantKey FROM DimPlant WHERE PlantName= @PlantNameValue)
			 BEGIN
				SET @PlantKey = (SELECT TOP 1 PlantKey FROM DimPlant WHERE PlantName= @PlantNameValue);
			 END 
			 ELSE
			 BEGIN 
				IF (@DEBUG=1)  SELECT 'INSERT INTO DimPlant Table'
				
				INSERT INTO [dbo].[DimPlant]
				   ([PlantName]
				   ,[OrganizationKey]
				   ,[LocationKey])
				VALUES
				   (@PlantNameValue
				   ,@OrganizationKey
				   ,@LocationKey)
				
				SET @PlantKey= SCOPE_IDENTITY();
			 END
		END
		
		-- Insert into dbo.DimUnit tale
		IF (@DEBUG=1) SELECT 'Inserting INTO DimUnit' 
		BEGIN 
			 IF EXISTS ( SELECT TOP 1 UnitKey FROM DimUnit WHERE UnitName= @UnitNameValue)
			 BEGIN
				SET @UnitKey = (SELECT TOP 1 UnitKey FROM DimUnit WHERE UnitName= @UnitNameValue);
			 END 
			 ELSE
			 BEGIN 
				IF (@DEBUG=1)  SELECT 'INSERT INTO DimUnit Table'
				
				INSERT INTO [dbo].[DimUnit]
				   ([UnitName]
				   ,[UnitID]
				   ,[PlantKey])
				VALUES
				   (@UnitNameValue
				   ,@UnitIDValue
				   ,@PlantKey)
				
				SET @UnitKey= SCOPE_IDENTITY();
			 END
		END


		-- Insert into dbo.DimAssetType tale
		IF( @ParentAssetTypeValue IS NOT NULL AND @ParentAssetTypeValue != '')
		BEGIN 
			IF EXISTS ( SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= @ParentAssetTypeValue)
			BEGIN
				SET @ParentAssetTypeKey = (SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= @ParentAssetTypeValue);
				END 
				ELSE
				BEGIN 
					INSERT INTO [dbo].DimAssetType (AssetTypeName,ParentAssetTypeKey)				   
					VALUES (@ParentAssetTypeValue,NULL)
				
					SET @ParentAssetTypeKey= SCOPE_IDENTITY();
			END
		END
		
		
		-- enable it later
		/*IF (@DEBUG=1) SELECT 'Inserting INTO DimAssetType' 		
		BEGIN 
			 IF EXISTS ( SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= @AssetSubTypeValue)
			 BEGIN
				SET @AssetTypeKey = (SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= @AssetSubTypeValue);
			 END 
			 ELSE
			 BEGIN 
				INSERT INTO [dbo].DimAssetType (AssetTypeName,ParentAssetTypeKey)				   
				VALUES (@AssetSubTypeValue,@ParentAssetTypeKey)
				
				SET @AssetTypeKey= SCOPE_IDENTITY();
			 END
		END*/


		  IF @ParentAssetKeyValue IS NOT NULL AND @ParentAssetKeyValue != ''
		  BEGIN
			IF EXISTS ( SELECT TOP 1 AssetKey FROM DimAsset WHERE AssetId= @ParentAssetKeyValue)
			 BEGIN
				SET @ParentAssetKey = (SELECT TOP 1 AssetKey FROM DimAsset WHERE AssetId= @ParentAssetKeyValue);
			 END 
			 ELSE
			 BEGIN 
				IF (@DEBUG=1)  SELECT 'INSERT INTO DimAsset Parent'				
				BEGIN
					INSERT INTO [dbo].[DimAsset]
				   ([ParentAssetKey],[UnitKey],[AssetTypeKey],[AssetId],[AssetName]
				   ,[AssetDescription],[SerialNo],[AssetAcquiredDate],[AssetAcquiredDateKey],[EstimatedLife])
					 VALUES( NULL, @UnitKey , @AssetTypeKey , @ParentAssetKeyValue, @ParentAssetNameValue
							,@ParentAssetNameValue, @ParentAssetKeyValue, GETDATE(),1,10)
					SET @ParentAssetKey=  SCOPE_IDENTITY();
				END
				
			 END
			 
		  END
			 
		

		
		IF (@DEBUG=1) SELECT 'Inserting INTO DimAsset' 
		BEGIN 
			 IF EXISTS ( SELECT TOP 1 AssetKey FROM DimAsset WHERE AssetId= @AssetIDValue)
			 BEGIN
				SET @AssetKey = (SELECT TOP 1 AssetKey FROM DimAsset WHERE AssetId= @AssetIDValue);
			 END 
			 ELSE
			 BEGIN 
				IF (@DEBUG=1)  SELECT 'INSERT INTO DimAsset Table'
				-- = TODO : Add Info in DIMUnit
				-- = INSERT DATA TO TABLE
				-- = TODO: Inert Data When Table is Empty 

				--IF (@InsertEnable=1)
				
					INSERT INTO [dbo].[DimAsset]
				   ([ParentAssetKey],[UnitKey],[AssetTypeKey],[AssetId],[AssetName]
				   ,[AssetDescription],[SerialNo],[AssetAcquiredDate],[AssetAcquiredDateKey],[EstimatedLife])
					 VALUES( @ParentAssetKey, @UnitKey , @AssetTypeKey, @AssetIDValue, @AssetNameValue
							,@AssetNameValue, @AssetNameValue, GETDATE(),1,1)
					SET @AssetKey=  SCOPE_IDENTITY();
				
				-- = TODO: Inert Data When Table is NOT Empty
			 END
		END
		--SELECT @AssetKey AS 'AssetKey', @AssetIDValue 'Inserting INTO DimAsset'
	
		SET @AllParamAreFound =1; 
		
	 END
	END


	-- ====================== Looping through Main Data Block  ===========================================

	IF( @AllParamAreFound = 1) AND (@C2 IS NOT NULL AND @C2!='') 
	AND (LEN(@C4)<3)
	--AND (@C1!='Technology or Procedure') 
	--AND (@C1!='Re-name or assign Technology or Procedure categories') AND (@DataRow=1)
	--
	BEGIN -- = All Param value is present, Now we can add those to different table 

		IF (@C1 IS NOT NULL) SET @ProcedureName = @C1 
		--ELSE SET @ProcedureName=@ProcedureName




	-- = ********************* SET ALL FK TABLES **********************

		BEGIN 

			IF (@DEBUG=1) SELECT 'Inserting INTO DimProcedure' 
			BEGIN 
			 IF EXISTS ( SELECT TOP 1 ProcedureKey FROM DimProcedure WHERE ProcedureName= @ProcedureName)
			 BEGIN
				SET @ProcedureKey = (SELECT TOP 1 ProcedureKey FROM DimProcedure WHERE ProcedureName= @ProcedureName);
			 END 
			 ELSE
			 BEGIN 
				IF (@DEBUG=1)  SELECT 'INSERT INTO DimProcedure Table'
				
				INSERT INTO [dbo].[DimProcedure] ([ProcedureName])
				VALUES ( @ProcedureName )
				SET @ProcedureKey= SCOPE_IDENTITY();
			 END
		END


			IF (@DEBUG=1) SELECT 'Inserting INTO DimConditionIndicator' 
			BEGIN 
			 IF EXISTS ( SELECT TOP 1 ConditionIndicatorKey FROM DimConditionIndicator WHERE ConditionIndicatorName= @C2)
			 BEGIN
				SET @ConditionIndicatorKey = ( SELECT TOP 1 ConditionIndicatorKey FROM DimConditionIndicator WHERE ConditionIndicatorName= @C2);
			 END 
			 ELSE
			 BEGIN 
				IF (@DEBUG=1)  SELECT 'INSERT INTO DimConditionIndicator Table'
				
				INSERT INTO [dbo].[DimConditionIndicator] ([ConditionIndicatorName])
				VALUES ( @C2 ) -- is @C2 supposed to be inserted as [ConditionIndicatorName]?
				SET @ConditionIndicatorKey= SCOPE_IDENTITY();
				
				--SET @ConditionIndicatorKey=-1;
			 END
		END


		
			IF (@DEBUG=1) SELECT 'Inserting INTO DimFailureMode' 
			BEGIN 
			 IF EXISTS ( SELECT TOP 1 FailureModeKey FROM DimFailureMode WHERE FailureModeName= @C3)
			 BEGIN
				SET @FailureModeKey = (SELECT TOP 1 FailureModeKey FROM DimFailureMode WHERE FailureModeName= @C3);
			 END 
			 ELSE
			 BEGIN 
				IF (@DEBUG=1)  SELECT 'INSERT INTO DimFailureMode Table'
				INSERT INTO [dbo].[DimFailureMode] ([FailureModeName])
				VALUES ( @C3 ) 
				SET @FailureModeKey= SCOPE_IDENTITY();
			 END
		END

	
		END 



	-- = ***************** END OF SET ALL FK TABLES ************************


	IF (@DEBUG=2) 
	BEGIN	
		SELECT  @ProcedureKey AS 'ProcedureKey',@C1 AS 'C1', @ConditionIndicatorKey AS '@ConditionIndicatorKey',@C2 AS 'C2', @C3 AS 'FailureModeKey', @DateKey AS 'DateKey', @C4 AS ImpactWeightage, @C5 AS TestResult, @C6 AS NormalizedCF, @C7, @C8,  @C10 AS HealthAlert, @C12 AS Notes
	END


	IF @IsDeleteTestResult = 1 
	BEGIN
		IF EXISTS(SELECT 1 FROM FactTestResult WHERE AssetKey = @AssetKey AND DateKey = @DateKey)
		BEGIN
			DELETE FROM FactTestResult WHERE AssetKey = @AssetKey AND DateKey = @DateKey
		END
		SET @IsDeleteTestResult = 0
	END
	
	
	
				IF(@C4='-') SET @C4=NULL;
				IF(@C5='-') SET @C5=NULL;
				IF(@C6='-') SET @C6=NULL;
				IF(@C10='-') SET @C10=NULL;

				 
				 INSERT INTO [dbo].[FactTestResult]
						   ([AssetKey]
						   ,[ProcedureKey]
						   ,[ConditionIndicatorKey]
						   ,[FailureModeKey]
						   ,[DateKey]
						   ,[ImpactWeightage]
						   ,[TestResult]
						   ,[NormalizedCF]
						   ,[HealthAlert]
						   ,[Notes])
					 VALUES
						   (@AssetKey
						   ,@ProcedureKey
						   ,@ConditionIndicatorKey
						   ,@FailureModeKey           
						   ,@DateKey
						   ,@C4
						   ,@C5          
						   ,@C6
						   ,@C10
						   ,@C12)
						  


		--	 END
		--END





	 --= END OF INSERT DATE INTO [FactTestResult]TABLE 


	
 END

 -- = INSERT INTO FactAssetIndicators START
 --= TODO: UPDATE Data into FactAssetIndicators
 -- = while insertiong data,  there is an issue of varchar-float conversion for the last 5 columns in the table below, have implemented TRY/Catch

	--IF(@C8='Overall Asset Health Index') SET @SetOverAllAsset=1;

	--IF(@SetOverAllAsset=1)
   

	-- = END OF Loop 
	IF(@C1='Estimated Useful Life Remaining')
	BEGIN 	 
		--RAISERROR ('EOF Encounter',16, 1 );  
		-- = Enter Row in [FactAssetIndicators] Table	

		BEGIN --(
				IF (@DEBUG=3) SELECT @AssetHealthIndex AS '@AssetHealthIndex', @DataAvailability AS '@DataAvailability', @ProjectedRemainingLife AS '@ProjectedRemainingLife', 
				@PotentialUsefulLifeLostPercentage AS '@PotentialUsefulLifeLostPercentage', @PotentialUsefulLifeLost AS '@PotentialUsefulLifeLost', @AHIMinValue as '@AHIMinValue'
				  

				IF @IsDeleteAssetIndicators = 1 
				BEGIN
					IF EXISTS(SELECT 1 FROM FactAssetIndicators WHERE AssetKey = @AssetKey AND DateKey = @DateKey)
					BEGIN
						DELETE FROM FactAssetIndicators WHERE AssetKey = @AssetKey AND DateKey = @DateKey
					END
					SET @IsDeleteAssetIndicators = 0
				END

					INSERT INTO [dbo].[FactAssetIndicators]
							   ([AssetKey]
							   ,[DateKey]
							   ,[AssetHealthIndex]
							   ,[DataAvailability]
							   ,[ProjectedRemainingLife]
							   ,[PotentialUsefulLifeLostPercentage]
							   ,[PotentialUsefulLifeLost]
							   ,AHIMinValue)
						 VALUES
							   (@AssetKey
							   ,@DateKey
							   ,@AssetHealthIndex
							   ,@DataAvailability    
							   ,@ProjectedRemainingLife
							   ,@PotentialUsefulLifeLostPercentage
							   ,@PotentialUsefulLifeLost
							   ,@AHIMinValue)

		
				END --)
		BREAK;	 
	END

	
    -- Get the next ROW.  
FETCH NEXT FROM vendor_cursor   
INTO @C1, @C2, @C3, @C4, @C5, @C6,
	 @C7,@C8,@C9,@C10,@C11, @C12,
	 @C13,@C14,@C15,@C16
  
END
CLOSE vendor_cursor;  
DEALLOCATE vendor_cursor;
   




END
