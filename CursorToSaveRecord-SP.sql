USE [AES_ASSET_DB_V2] 

GO 

/****** Object:  StoredProcedure  [sp_ImportData]    Script Date: 2016-07-12 11:09:47 AM ******/ 
SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

-- Batch submitted through debugger: SQLQuery1.sql|7|0|C:\Users\ADMINI~1.TBL\AppData\Local\Temp\2\~vsC2DD.sql
-- ============================================= 
-- Author:           Ashfaq 
-- Create date:  
-- Description:       
-- ============================================= 
ALTER PROCEDURE  [SP_IMPORTDATA] 
AS 
  BEGIN 
      DECLARE @C1 NVARCHAR(500); 
      DECLARE @C2 NVARCHAR(500); 
      DECLARE @C3 NVARCHAR(500); 
      DECLARE @C4 NVARCHAR(500); 
      DECLARE @C5 NVARCHAR(500); 
      DECLARE @C6 NVARCHAR(500); 
      DECLARE @C7 NVARCHAR(500); 
      DECLARE @C8 NVARCHAR(500); 
      DECLARE @C9 NVARCHAR(500); 
      DECLARE @C10 NVARCHAR(500); 
      DECLARE @C11 NVARCHAR(500); 
      DECLARE @C12 NVARCHAR(4000); 
      DECLARE @C13 NVARCHAR(500); 
      DECLARE @C14 NVARCHAR(500); 
      DECLARE @C15 NVARCHAR(500); 
      DECLARE @C16 NVARCHAR(500); 
      DECLARE @ParentAssetKeyValue NVARCHAR(500); 
      DECLARE @ParentAssetKey NVARCHAR(500); 
      DECLARE @AssetIDValue NVARCHAR(500); 
      DECLARE @UnitNameValue NVARCHAR(500); 
      DECLARE @ParentAssetNameValue NVARCHAR(500); 
      DECLARE @SerialNo NVARCHAR(50); 
      DECLARE @AssetAcquiredDate NVARCHAR(50); 
      DECLARE @AssetAcquiredDateKey NVARCHAR(50); 
      DECLARE @EstimatedLife NVARCHAR(10); 
      DECLARE @AssetNameValue NVARCHAR(500); 
      DECLARE @UnitIDValue NVARCHAR(500); 
      DECLARE @ParentAssetTypeValue NVARCHAR(500); 
      DECLARE @AssetSubTypeValue NVARCHAR(500); 
      DECLARE @ParentAssetTypeKey NVARCHAR(500); 
      DECLARE @AssetTypeKey NVARCHAR(500); 
      DECLARE @DateKeyValue NVARCHAR(100); 
      DECLARE @AHIMinValue NVARCHAR(100); -- = Should be float 
      DECLARE @ProcedureKeyTemp NVARCHAR(500); 
      DECLARE @ConditionIndicatorName NVARCHAR(500); 
      DECLARE @ProcedureName NVARCHAR(100); 
      DECLARE @FailureModeName NVARCHAR(100); 
      DECLARE @AssetKey NVARCHAR(500); 
      DECLARE @ProcedureKey NVARCHAR(500); 
      DECLARE @ConditionIndicatorKey NVARCHAR(500); 
      DECLARE @FailureModeKey NVARCHAR(500); 
      DECLARE @DateKey NVARCHAR(500); 
      DECLARE @ImpactWeightage NVARCHAR(500); 
      DECLARE @TestResult NVARCHAR(500); 
      DECLARE @NormalizedCF NVARCHAR(500); 
      DECLARE @HealthAlert NVARCHAR(500); 
      DECLARE @Notes NVARCHAR(500); 
      DECLARE @ParentAssetKeyT NVARCHAR(500); 
      DECLARE @PlantNameValue NVARCHAR(500); 
      DECLARE @AllParamAreFound BIT=0; 
      DECLARE @DEBUG TINYINT = 0; 
      DECLARE @InsertEnable BIT = 0; 
      DECLARE @DataRow BIT = 0; 
      DECLARE @DataRowEnd BIT = 0; 
      -- = TO INSERT INTO DBO.DIMPLANT TABLE [FOREIGN KEY FROM DBO.DIMORGANIZATOIN & DBO.DIMLOCATION]
      DECLARE @OrganizationKey INT; 
      DECLARE @LocationKey INT; 
      DECLARE @PlantKey INT; 
      DECLARE @UnitKey INT; 
      -- = EXCEL COLUMN VARIABLES FOR DBO.FACTASSETINDICATORS 
      DECLARE @AssetHealthIndex NVARCHAR(500); 
      DECLARE @DataAvailability NVARCHAR(500); 
      DECLARE @ProjectedRemainingLife NVARCHAR(500); 
      DECLARE @PotentialUsefulLifeLostPercentage NVARCHAR(500); 
      DECLARE @PotentialUsefulLifeLost NVARCHAR(500); 
      DECLARE @SetOverAllAsset BIT=0; 
      DECLARE @IsDeleteTestResult BIT = 1 
      DECLARE @IsDeleteAssetIndicators BIT = 1 
      DECLARE @ERRORMSG VARCHAR(500); 
      DECLARE @ERRORFOUND BIT=0; 

      -- = NOTE: TEMPORARY QUERIES TO INSERT INTO DBO.DIMPLANT, COULD NOT FIND ANY DATA IN EXCEL RELATED TO @ORGANIZATIONKEY AND @LOCATIONKEY
      SET @OrganizationKey = (SELECT TOP 1 Organizationkey 
                              FROM   DBO.DimOrganization); 
      SET @LocationKey = (SELECT TOP 1 Locationkey 
                          FROM   DBO.DimLocation); 

     
      -- = END OF VARIABLES  
      BEGIN TRAN ASSET; 

      DECLARE VENDOR_CURSOR CURSOR FOR 
        SELECT [C1],[C2],[C3],[C4],[C5],[C6],[C7],[C8],[C9],[C10],[C11],[C12],[C13],[C14],[C15],[C16] 
        FROM   STG_AHI 
        ORDER  BY Assetkey 

      OPEN VENDOR_CURSOR 

      FETCH NEXT FROM VENDOR_CURSOR INTO @C1, @C2, @C3, @C4, @C5, @C6, @C7, @C8, @C9, @C10, @C11, @C12, @C13, @C14, @C15, @C16

      WHILE @@FETCH_STATUS = 0 
        BEGIN 

			  -- = =================================================== START COMPARING EXCEL COLUMN FOR VALUE  =============================================================
			BEGIN
				IF ( Rtrim(Ltrim(@C1)) = 'Plant Name' ) 
				BEGIN 
					SET @PlantNameValue = @C2; 
				END 

				IF ( Rtrim(Ltrim(@C1)) = 'Date of Record:' ) 
				BEGIN 
					SET @DateKeyValue= @C2; 
					SET @AHIMinValue= @C11; 
				END 

				IF ( Rtrim(Ltrim(@C1)) = 'Parent Asset ID' ) 
				BEGIN 
					SET @ParentAssetKeyValue= @C2; 
				END 

				IF ( Rtrim(Ltrim(@C1)) = 'Asset ID' ) 
				BEGIN 
					SET @AssetIDValue= @C2; 
				END 

				IF ( Rtrim(Ltrim(@C3)) = 'Unit Name' ) 
				BEGIN 
					SET @UnitNameValue = @C4; 
				END 

				IF ( Rtrim(Ltrim(@C3)) = 'Asset Name' ) 
				BEGIN 
					SET @AssetNameValue = @C4; 
				END 

				IF ( Rtrim(Ltrim(@C3)) = 'Parent Asset Name' ) 
				BEGIN 
					SET @ParentAssetNameValue= @C4; 
				END 

				IF ( Rtrim(Ltrim(@C5)) = 'Unit ID' ) 
				BEGIN 
					SET @UnitIDValue = @C6; 
				END 

				IF ( Rtrim(Ltrim(@C5)) = 'Serial No.' ) 
				BEGIN 
					SET @SerialNo = @C6; 
				END 

				IF ( Rtrim(Ltrim(@C5)) = 'Parent Asset Type' ) 
				BEGIN 
					SET @ParentAssetTypeValue = @C6; 
				END 

				IF ( Rtrim(Ltrim(@C7)) = 'Asset Acquired' ) 
				BEGIN 
					SET @AssetAcquiredDate = @C8; 
				END 

				IF ( Rtrim(Ltrim(@C7)) = 'Asset Sub Type' ) 
				BEGIN 
					SET @AssetSubTypeValue = @C8; 
				END 

				IF( Rtrim(Ltrim(@C7)) = 'Data Availability (Confidence Factor)' ) 
				BEGIN 
					SET @PotentialUsefulLifeLostPercentage = @C10; 

					IF @PotentialUsefulLifeLostPercentage = 'Info Reqd.' 
					SET @PotentialUsefulLifeLostPercentage = NULL 
				END 

				IF( Rtrim(Ltrim(@C7)) = 'Projected Remaining Useful Life' ) 
				BEGIN 
					SET @PotentialUsefulLifeLost = @C10; 

					IF @PotentialUsefulLifeLost = 'Info Reqd.' 
					SET @PotentialUsefulLifeLost = NULL 
				END 

				IF ( Rtrim(Ltrim(@C9)) = 'Estimated Life (yrs)' ) 
				BEGIN 
					SET @EstimatedLife = @C10; 
				END 

				IF( @C10 = 'Individual CI Health Monitor' ) 
				BEGIN 
					IF ( ( @C13 IS NULL 
							OR @C13 = '' ) 
						OR ( @C14 IS NULL 
								OR @C14 = '' 
								OR @C14 = '0' ) ) 
					BEGIN 
						SET @AssetHealthIndex=NULL; 
					END 
					ELSE 
					BEGIN 
						SET @AssetHealthIndex = ( ( ( CONVERT(FLOAT, @C13) ) / CONVERT(FLOAT, @C14) ) * 100 );
					END 

					IF ( ( @C16 IS NULL 
							OR @C16 = '' ) 
						OR ( @C15 IS NULL 
								OR @C15 = '' 
								OR @C15 = 0 ) ) 
					BEGIN 
						SET @DataAvailability=NULL; 
					END 
					ELSE 
					BEGIN 
						SET @DataAvailability = ( ( CONVERT(FLOAT, @C16) / CONVERT(FLOAT, @C15) ) * 100 );
					END 
				END 

				IF( @C1 = 'Estimated Useful Life Remaining' ) 
				BEGIN 
					SET @ProjectedRemainingLife = @C3; 
				END 
				--SELECT @C13, @C14, @C15, @C16 
			END
            -- = =================================================== END OF COMPARING EXCEL COLUMN FOR VALUE  =============================================================



           
            -- = IF DATE OF RECORD: FOUND AND ONE OF THE PARAM VALUE IS MISSING BREAK THE EXECUTION AND RAISEERROR
            IF( @C1 = 'Date of Record:' ) 
              BEGIN 
                
                  SET @DateKey = (SELECT TOP 1 Date_day_key 
                                  FROM   DimDate 
                                  WHERE  CONVERT(DATE, Day_date_d) = CONVERT(DATE, @DateKeyValue));
                  SET @AssetAcquiredDateKey = (SELECT TOP 1 Date_day_key 
                                               FROM   DimDate 
                                               WHERE  CONVERT(DATE, Day_date_d) = CONVERT(DATE, @AssetAcquiredDate));

                
				IF ( @DEBUG = 3 ) 
                SELECT @PlantNameValue AS '@PlantNameValue',@ParentAssetKeyValue AS '@ParentAssetKeyValue',@AssetIDValue AS '@AssetIDValue',@UnitNameValue AS '@UnitNameValue',
                                            @ParentAssetNameValue AS '@ParentAssetNameValue'
                                            ,@AssetNameValue AS '@AssetNameValue',@UnitIDValue AS '@UnitIDValue',@ParentAssetTypeValue AS '@ParentAssetTypeValue',
                        @AssetSubTypeValue AS '@AssetSubTypeValue',  @DateKeyValue AS 'Setting up DimDate',@DateKey AS '@DateKey',@AssetAcquiredDateKey AS '@AssetAcquiredDateKey', 'Mandatory Field Checking' AS 'Mandatory'


                  -- = IF PARAM VALUE IS MISSING RASIE ERROR, OTHERIWSE SET @ALLPARAMAREFOUND=1, ERRORLOG
                  IF ( @PlantNameValue IS NULL 
                        OR @PlantNameValue = '' ) 
                    BEGIN 
                        SET @ERRORFOUND=1; 
                        SET @ERRORMSG= 'PlantName is either null or empty, check datasheet';

                        BREAK; 
                    END 

                  IF ( @AssetIDValue IS NULL 
                        OR @AssetIDValue = '' ) 
                    BEGIN 
                        SET @ERRORFOUND=1; 
                        SET @ERRORMSG= 'AssetID is either null or empty, check datasheet'; 

                        BREAK; 
                    END 

                  IF ( @UnitNameValue IS NULL 
                        OR @UnitNameValue = '' ) 
                    BEGIN 
                        SET @ERRORFOUND=1; 
                        SET @ERRORMSG= 'UnitName is either null or empty, check datasheet'; 

                        BREAK; 
                    END 

                  IF ( @AssetNameValue IS NULL 
                        OR @AssetNameValue = '' ) 
                    BEGIN 
                        SET @ERRORFOUND=1; 
                        SET @ERRORMSG= 'AssetName is either null or empty, check datasheet';

                        BREAK; 
                    END 

                  IF ( @UnitIDValue IS NULL 
                        OR @UnitIDValue = '' ) 
                    BEGIN 
                        SET @ERRORFOUND=1; 
                        SET @ERRORMSG= 'UnitID is either null or empty, check datasheet'; 

                        BREAK; 
                    END 

                  IF ( @DateKeyValue IS NULL 
                        OR @DateKeyValue = '' ) 
                    BEGIN 
                        SET @ERRORFOUND=1; 
                        SET @ERRORMSG= 'DateKey is either null or empty, check datasheet'; 

                        BREAK; 
                    END 

                  IF ( @DateKey IS NULL 
                        OR @DateKey = '' ) 
                    BEGIN 
                        SET @ERRORFOUND=1; 
                        SET @ERRORMSG= 'DateKey is either null or empty, check datasheet'; 

                        BREAK; 
                    END 

                  IF ( @AssetAcquiredDateKey IS NULL 
                        OR @AssetAcquiredDateKey = '' ) 
                    BEGIN 
                        SET @ERRORFOUND=1; 
                        SET @ERRORMSG= 'AssetAcquiredDate is either null or empty, check datasheet';

                        BREAK; 
                    END 

				  IF ( @AssetSubTypeValue IS NULL 
                        OR @AssetSubTypeValue = '' ) 
                    BEGIN 
                        SET @ERRORFOUND=1; 
                        SET @ERRORMSG= 'AssetType is either null or empty, check datasheet';

                        BREAK; 
                    END 
                  ELSE 
                    BEGIN 
                        -- = INSERT INTO DBO.DIMPLANT TABLE 
                        IF ( @DEBUG = 1 ) 
                          SELECT 'Inserting INTO DimPlant' 

                        BEGIN 
                            IF EXISTS (SELECT TOP 1 Plantkey 
                                       FROM   DimPlant 
                                       WHERE  Plantname = @PlantNameValue) 
                              BEGIN 

							  --UPDATE DimPlant 
         --                              SET [Plantname]= @PlantNameValue,
									--    [Organizationkey] = @OrganizationKey,
									--    [Locationkey] = @LocationKey
									-- WHERE  Plantname = @PlantNameValue


                                  SET @PlantKey = (SELECT TOP 1 Plantkey 
                                                   FROM   DimPlant 
                                                   WHERE  Plantname = @PlantNameValue); 
                              END 
                            ELSE 
                              BEGIN 
                                  IF ( @DEBUG = 1 ) 
                                    SELECT 'INSERT INTO DimPlant Table' 

                                  INSERT INTO  [DimPlant] 
                                              ([Plantname],[Organizationkey],[Locationkey]) 
                                  VALUES      (@PlantNameValue,@OrganizationKey,@LocationKey)

                                  SET @PlantKey= Scope_identity(); 

								    IF( @@ERROR <> 0 ) 
                                          BEGIN 
                                              SET @ERRORFOUND=1; 
                                              SET @ERRORMSG = ERROR_MESSAGE(); 

                                              BREAK; 
                                          END 
                              END 
                        END 

                        -- = INSERT INTO DBO.DIMUNIT TALE 
                        IF ( @DEBUG = 1 ) 
                          SELECT 'Inserting INTO DimUnit' 

                        BEGIN 
                            IF EXISTS (SELECT TOP 1 Unitkey 
                                       FROM   DimUnit 
                                       WHERE  Unitname = @UnitNameValue) 
                              BEGIN 
									--UPDATE DimUnit 
         --                              SET [Unitname]= @UnitNameValue,
									--    [Unitid] = @UnitIDValue,
									--    [PlantKey] = @PlantKey
									-- WHERE  Unitname = @UnitNameValue

                                  SET @UnitKey = (SELECT TOP 1 Unitkey 
                                                  FROM   DimUnit 
                                                  WHERE  Unitname = @UnitNameValue); 
                              END 
                            ELSE 
                              BEGIN 
                                  IF ( @DEBUG = 1 ) 
                                    SELECT 'INSERT INTO DimUnit Table' 

                                  INSERT INTO  [DimUnit] 
                                              ([Unitname],[Unitid],[Plantkey]) 
                                  VALUES      (@UnitNameValue,@UnitIDValue,@PlantKey) 

                                  SET @UnitKey= Scope_identity(); 

								    IF( @@ERROR <> 0 ) 
                                          BEGIN 
                                              SET @ERRORFOUND=1; 
                                              SET @ERRORMSG = ERROR_MESSAGE(); 

                                              BREAK; 
                                          END 
                              END 
                        END 

                        -- = INSERT INTO DBO.DIMASSETTYPE TALE 
                        IF( @ParentAssetTypeValue IS NOT NULL 
                            AND @ParentAssetTypeValue != '' ) 
                          BEGIN 
                              IF EXISTS (SELECT TOP 1 Assettypekey 
                                         FROM   DimAssetType 
                                         WHERE  Assettypename = @ParentAssetTypeValue) 
                                BEGIN 
									--UPDATE DimAssetType 
         --                              SET Assettypename= @ParentAssetTypeValue
									--WHERE  Assettypename = @ParentAssetTypeValue

                                    SET @ParentAssetTypeKey = (SELECT TOP 1 Assettypekey 
                                                               FROM   DimAssetType 
                                                               WHERE  Assettypename = @ParentAssetTypeValue);
                                END 
                              ELSE 
                                BEGIN 
                                    INSERT INTO  DimAssetType 
                                                (Assettypename,Parentassettypekey) 
                                    VALUES      (@ParentAssetTypeValue,NULL) 

                                    SET @ParentAssetTypeKey= Scope_identity(); 

									  IF( @@ERROR <> 0 ) 
                                          BEGIN 
                                              SET @ERRORFOUND=1; 
                                              SET @ERRORMSG = ERROR_MESSAGE(); 

                                              BREAK; 
                                          END 
                                END 
                          END 

                        -- = ENABLE IT LATER 
						IF (@DEBUG=1) SELECT 'Inserting INTO DimAssetType'
						IF( @AssetSubTypeValue IS NOT NULL 
                            AND @AssetSubTypeValue != '' )            
						BEGIN  
							   IF EXISTS ( SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= @AssetSubTypeValue)
							   BEGIN 
										-- = NOTE: Should I consider @ParentAssetTypeKey in Where condition?
										--UPDATE DimAssetType 
										--   SET Assettypename= @AssetSubTypeValue,
										--   ParentAssetTypeKey = @ParentAssetTypeKey
										--WHERE  Assettypename = @AssetSubTypeValue
									 SET @AssetTypeKey = (SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= @AssetSubTypeValue);
							   END  
								ELSE 
							   BEGIN  
									 INSERT INTO  DimAssetType (AssetTypeName,ParentAssetTypeKey)                            
									 VALUES (@AssetSubTypeValue,@ParentAssetTypeKey) 
                                  
									 SET @AssetTypeKey= SCOPE_IDENTITY(); 

									   IF( @@ERROR <> 0 ) 
                                          BEGIN 
                                              SET @ERRORFOUND=1; 
                                              SET @ERRORMSG = ERROR_MESSAGE(); 

                                              BREAK; 
                                          END 
							   END 
						END
                        -- = NOTE: NEED DISCUSSION 
                        --IF( @AssetTypeKey IS NULL ) 
                        --  SET @AssetTypeKey=1; 

                        IF @ParentAssetKeyValue IS NOT NULL 
                           AND @ParentAssetKeyValue != '' 
                          BEGIN 
                              IF EXISTS (SELECT TOP 1 Assetkey 
                                         FROM   DimAsset 
                                         WHERE  Assetid = @ParentAssetKeyValue) 
                                BEGIN 
								   UPDATE  [DimAsset]
								   SET 
									   [UnitKey] = @UnitKey
									  ,[AssetTypeKey] = @AssetTypeKey
									  ,[AssetName] = @ParentAssetNameValue
									  ,[AssetID] = @ParentAssetKeyValue 
									  ,[AssetDescription] = @ParentAssetNameValue
									  ,[SerialNo] = @SerialNo
									  ,[AssetAcquiredDate] = @AssetAcquiredDate
									  ,[AssetAcquiredDateKey] = @AssetAcquiredDateKey
									  ,[EstimatedLife] = @EstimatedLife
								  WHERE  Assetid = @ParentAssetKeyValue
                                    SET @ParentAssetKey = (SELECT TOP 1 Assetkey 
                                                           FROM   DimAsset 
                                                           WHERE  Assetid = @ParentAssetKeyValue);
                                END 
                              ELSE 
                                BEGIN 
                                    IF ( @DEBUG = 1 ) 
                                      SELECT 'INSERT INTO DimAsset Parent' 

                                    BEGIN 
                                        INSERT INTO [DimAsset] 
                                                    ([Parentassetkey],[Unitkey],[Assettypekey],[Assetid],[Assetname],[Assetdescription],[Serialno],[Assetacquireddate],[Assetacquireddatekey], 
                                                     [Estimatedlife]) 
                                        VALUES     ( NULL,@UnitKey,@AssetTypeKey,@ParentAssetKeyValue,@ParentAssetNameValue,@ParentAssetNameValue,@SerialNo,@AssetAcquiredDate,@AssetAcquiredDateKey,
                                                     @EstimatedLife) 

                                        SET @ParentAssetKey= Scope_identity(); 

                                        IF( @@ERROR <> 0 ) 
                                          BEGIN 
                                              SET @ERRORFOUND=1; 
                                              SET @ERRORMSG = ERROR_MESSAGE(); 

                                              BREAK; 
                                          END 
                                    END 
                                END 
                          END 

                        IF ( @DEBUG = 1 ) 
                          SELECT 'Inserting INTO DimAsset' 

                        BEGIN 
                            IF EXISTS (SELECT TOP 1 Assetkey 
                                       FROM   DimAsset 
                                       WHERE  Assetid = @AssetIDValue) 
                              BEGIN 

							     UPDATE  [DimAsset]
								   SET [ParentAssetKey] = @ParentAssetKey
									  ,[UnitKey] = @UnitKey
									  ,[AssetTypeKey] = @AssetTypeKey
									  ,[AssetName] = @AssetNameValue
									  ,[AssetID] = @AssetIDValue
									  ,[AssetDescription] = @AssetNameValue
									  ,[SerialNo] = @SerialNo
									  ,[AssetAcquiredDate] = @AssetAcquiredDate
									  ,[AssetAcquiredDateKey] = @AssetAcquiredDateKey
									  ,[EstimatedLife] = @EstimatedLife
								  WHERE  Assetid = @AssetIDValue


                                  SET @AssetKey = (SELECT TOP 1 Assetkey 
                                                   FROM   DimAsset 
                                                   WHERE  Assetid = @AssetIDValue); 
                              END 
                            ELSE 
                              BEGIN 
                                  IF ( @DEBUG = 1 ) 
                                    SELECT 'INSERT INTO DimAsset Table' 

                                  -- = TODO : ADD INFO IN DIMUNIT 
                                  -- = INSERT DATA TO TABLE 
                                  -- = TODO: INERT DATA WHEN TABLE IS EMPTY  
                                  --IF (@InsertEnable=1) 
                                  INSERT INTO  [DimAsset] 
                                              ([Parentassetkey],[Unitkey],[Assettypekey],[Assetid],[Assetname],[Assetdescription],[Serialno],[Assetacquireddate],[Assetacquireddatekey],[Estimatedlife]) 
                                  VALUES     ( @ParentAssetKey,@UnitKey,@AssetTypeKey,@AssetIDValue,@AssetNameValue,@AssetNameValue,@SerialNo,@AssetAcquiredDate,@AssetAcquiredDateKey,@EstimatedLife)

                                  SET @AssetKey= Scope_identity(); 

                                  IF( @@ERROR <> 0 ) 
                                    BEGIN 
                                        SET @ERRORFOUND=1; 
                                        SET @ERRORMSG = ERROR_MESSAGE(); 

                                        BREAK; 
                                    END 
                              -- = TODO: INERT DATA WHEN TABLE IS NOT EMPTY 
                              END 
                        END 

                        --SELECT @AssetKey AS 'AssetKey', @AssetIDValue 'Inserting INTO DimAsset' 
                        SET @AllParamAreFound =1; 
                    END 

			      -- = END OF IF PARAM VALUE IS MISSING RASIE ERROR, OTHERIWSE SET @ALLPARAMAREFOUND=1, ERRORLOG
              END 

            
			
			-- = ====================== LOOPING THROUGH MAIN DATA BLOCK  ===========================================
            IF( @AllParamAreFound = 1 ) 
              AND ( @C2 IS NOT NULL 
                    AND @C2 != '' ) 
              AND ( Len(@C4) < 3 ) 
              --AND (@C1!='Technology or Procedure')  
              --AND (@C1!='Re-name or assign Technology or Procedure categories') AND (@DataRow=1) 
              -- 
              BEGIN -- = ALL PARAM VALUE IS PRESENT, NOW WE CAN ADD THOSE TO DIFFERENT TABLE 
                  IF ( @C1 IS NOT NULL ) 
                    SET @ProcedureName = @C1 

                  --ELSE SET @ProcedureName=@ProcedureName 


                  -- = ********************* SET ALL FK TABLES ********************** 
                  BEGIN 
                      IF ( @DEBUG = 1 ) 
                        SELECT 'Inserting INTO DimProcedure' 

                      BEGIN 
                          IF EXISTS (SELECT TOP 1 Procedurekey 
                                     FROM   DimProcedure 
                                     WHERE  Procedurename = @ProcedureName) 
                            BEGIN 

								UPDATE DimProcedure 
                                       SET Procedurename= @ProcedureName
                                 WHERE  Procedurename = @ProcedureName

                                SET @ProcedureKey = (SELECT TOP 1 Procedurekey 
                                                     FROM   DimProcedure 
                                                     WHERE  Procedurename = @ProcedureName); 
                            END 
                          ELSE 
                            BEGIN 
                                

                                INSERT INTO  [DimProcedure] 
                                            ([Procedurename]) 
                                VALUES      ( @ProcedureName ) 

                                SET @ProcedureKey= Scope_identity(); 
								  IF( @@ERROR <> 0 ) 
                                          BEGIN 
                                              SET @ERRORFOUND=1; 
                                              SET @ERRORMSG = ERROR_MESSAGE(); 

                                              BREAK; 
                                          END 
                            END 
                      END 

                      IF ( @DEBUG = 1 ) 
                        SELECT 'Inserting/Updating INTO DimConditionIndicator' 

                      BEGIN 
                          IF EXISTS (SELECT TOP 1 Conditionindicatorkey 
                                     FROM   DimConditionIndicator 
                                     WHERE  Conditionindicatorname = @C2) 
                            BEGIN 

							 UPDATE  DimConditionIndicator 
                                       SET Conditionindicatorname= @C2
                                 WHERE  Conditionindicatorname = @C2
                                SET @ConditionIndicatorKey = (SELECT TOP 1 Conditionindicatorkey
                                                              FROM   DimConditionIndicator 
                                                              WHERE  Conditionindicatorname = @C2);
                            END 
                          ELSE 
                            BEGIN 
                                IF ( @DEBUG = 1 ) 
                                  SELECT 'INSERT INTO DimConditionIndicator Table' 

                                INSERT INTO  [DimConditionIndicator] 
                                            ([Conditionindicatorname]) 
                                VALUES      ( @C2 ) -- is @C2 supposed to be inserted as [ConditionIndicatorName]? 

                                SET @ConditionIndicatorKey= Scope_identity(); 
								  IF( @@ERROR <> 0 ) 
                                          BEGIN 
                                              SET @ERRORFOUND=1; 
                                              SET @ERRORMSG = ERROR_MESSAGE(); 

                                              BREAK; 
                                          END 
                            --SET @ConditionIndicatorKey=-1; 
                            END 
                      END 

                      IF ( @DEBUG = 1 ) 
                        SELECT 'Inserting INTO DimFailureMode' 

                      BEGIN 
                          IF EXISTS (SELECT TOP 1 Failuremodekey 
                                     FROM   DimFailureMode 
                                     WHERE  Failuremodename = @C3) 
                            BEGIN 
								 UPDATE  [DimFailureMode] 
                                       SET [Failuremodename]= @C3
                                 WHERE  Failuremodename = @C3 
                                SET @FailureModeKey = (SELECT TOP 1 Failuremodekey 
                                                       FROM   DimFailureMode 
                                                       WHERE  Failuremodename = @C3); 
                            END 
                          ELSE 
                            BEGIN 
                                IF ( @DEBUG = 1 ) 
                                  SELECT 'INSERT INTO DimFailureMode Table' 

                                INSERT INTO  [DimFailureMode] 
                                            ([Failuremodename]) 
                                VALUES      ( @C3 ) 

                                SET @FailureModeKey= Scope_identity(); 
								  IF( @@ERROR <> 0 ) 
                                          BEGIN 
                                              SET @ERRORFOUND=1; 
                                              SET @ERRORMSG = ERROR_MESSAGE(); 

                                              BREAK; 
                                          END 
                            END 
                      END 
                  END 

                  -- = ***************** END OF SET ALL FK TABLES ************************ 



                  IF ( @DEBUG = 1 ) 
                    BEGIN 
                        SELECT @ProcedureKey AS 'ProcedureKey',@C1 AS 'C1',@ConditionIndicatorKey AS '@ConditionIndicatorKey',@C2 AS 'C2',@C3 AS 'FailureModeKey',@DateKey AS 'DateKey',@C4 AS
                               ImpactWeightage 
                               , 
                               @C5 
                               AS 
                               TestResult,@C6 AS 
                               NormalizedCF,@C7,@C8,@C10 AS HealthAlert,@C12 AS Notes, @AssetSubTypeValue AS  '@AssetSubTypeValue'
                    END 

                  IF @IsDeleteTestResult = 1 
                    BEGIN 
                        IF EXISTS(SELECT 1 
                                  FROM   FactTestResult 
                                  WHERE  Assetkey = @AssetKey 
                                         AND Datekey = @DateKey) 
                          BEGIN 
                              DELETE FROM FactTestResult 
                              WHERE  Assetkey = @AssetKey 
                                     AND Datekey = @DateKey 
                          END 

                        SET @IsDeleteTestResult = 0 
                    END 

					IF( @C4 = '-' ) 
						SET @C4=NULL; 

					IF( @C5 = '-' ) 
						SET @C5=NULL; 

					IF( @C6 = '-' ) 
						SET @C6=NULL; 

					IF( @C10 = '-' ) 
						SET @C10=NULL;
						  
						  -- = NOTE: IF YOU TURN THIS ON IT ONLY CREATES 1 RECORD, BECAUSE ASSETKEY AND DATEKEY ARE SAME FOR ONE UPLOADED EXCEL FILE 

                  /*IF EXISTS (SELECT 1 
                             FROM   FactTestResult 
                             WHERE  Assetkey = @AssetKey 
                                    AND Datekey = @DateKey) 
                    BEGIN 
                        IF ( @DEBUG = 1 ) 
                          SELECT 'Update [FactTestResult] Table' 
						
                        UPDATE  [FactTestResult] 
                        SET    [Assetkey] = @AssetKey,[Procedurekey] = @ProcedureKey,[Conditionindicatorkey] = @ConditionIndicatorKey,[Failuremodekey] = @FailureModeKey,[Datekey] = @DateKey, 
                               [Impactweightage] = @C4, 
                               [Testresult] = @C5,[Normalizedcf] = @C6,[Healthalert] = @C10,[Notes] = @C12 
                        WHERE  Assetkey = @AssetKey 
                               AND Datekey = @DateKey 
                    END 
                  ELSE */
                    BEGIN                        

                        INSERT INTO  [FactTestResult] 
                                    ([Assetkey],[Procedurekey],[Conditionindicatorkey],[Failuremodekey],[Datekey],[Impactweightage],[Testresult],[Normalizedcf],[Healthalert],[Notes]) 
                        VALUES      (@AssetKey,@ProcedureKey,@ConditionIndicatorKey,@FailureModeKey,@DateKey,@C4,@C5,@C6,@C10,@C12)

                        IF( @@ERROR <> 0 ) 
                          BEGIN 
                              SET @ERRORFOUND=1; 
                              SET @ERRORMSG = ERROR_MESSAGE(); 

                              BREAK; 
                          END 
                    END 
              -- = END OF INSERT DATE INTO [FactTestResult]TABLE  
              END 

            
			
			-- = INSERT INTO FACTASSETINDICATORS START 
            IF( @C1 = 'Estimated Useful Life Remaining' ) 
				AND (@AllParamAreFound=1)
              BEGIN 
                 
                  BEGIN --( 
                      IF ( @DEBUG = 1 ) 
                        SELECT @AssetHealthIndex AS '@AssetHealthIndex',@DataAvailability AS '@DataAvailability',@ProjectedRemainingLife AS '@ProjectedRemainingLife',
                                                 @PotentialUsefulLifeLostPercentage AS '@PotentialUsefulLifeLostPercentage',@PotentialUsefulLifeLost AS '@PotentialUsefulLifeLost',
                               @AHIMinValue AS '@AHIMinValue' 

                      IF @IsDeleteAssetIndicators = 1 
                        BEGIN 
                            IF EXISTS(SELECT 1 
                                      FROM   FactAssetIndicators 
                                      WHERE  Assetkey = @AssetKey 
                                             AND Datekey = @DateKey) 
                              BEGIN 
                                  DELETE FROM FactAssetIndicators 
                                  WHERE  Assetkey = @AssetKey 
                                         AND Datekey = @DateKey 
                              END 

                            SET @IsDeleteAssetIndicators = 0 
                        END 

                      IF EXISTS (SELECT 1 
                                 FROM   FactAssetIndicators 
                                 WHERE  Assetkey = @AssetKey 
                                        AND Datekey = @DateKey) 
                        BEGIN 
                            IF ( @DEBUG = 1 ) 
                              SELECT 'Update [FactAssetIndicators] Table' 

                            UPDATE  [FactAssetIndicators] 
                            SET    [Assetkey] = @AssetKey,[Datekey] = @DateKey,[Assethealthindex] = @AssetHealthIndex,[Dataavailability] = @DataAvailability, 
                                   [Projectedremaininglife] = @ProjectedRemainingLife, 
                                   [Potentialusefullifelostpercentage] = @PotentialUsefulLifeLostPercentage,[Potentialusefullifelost] = @PotentialUsefulLifeLost,[Ahiminvalue] = @AHIMinValue 
                            WHERE  Assetkey = @AssetKey 
                                   AND Datekey = @DateKey 
                        END 
                      ELSE 
                        BEGIN 
                            INSERT INTO  [FactAssetIndicators] 
                                        ([Assetkey],[Datekey],[Assethealthindex],[Dataavailability],[Projectedremaininglife],[Potentialusefullifelostpercentage],[Potentialusefullifelost],Ahiminvalue) 
                            VALUES      (@AssetKey,@DateKey,@AssetHealthIndex,@DataAvailability,@ProjectedRemainingLife,@PotentialUsefulLifeLostPercentage,@PotentialUsefulLifeLost,@AHIMinValue)

                            IF( @@ERROR <> 0 ) 
                              BEGIN 
                                  SET @ERRORFOUND=1; 
                                  SET @ERRORMSG = ERROR_MESSAGE(); 

                                  BREAK; 
                              END 
                        END 
                  END --) 

                  BREAK; 
              END 

            
			
			-- = GET THE NEXT ROW.   
            FETCH NEXT FROM VENDOR_CURSOR INTO @C1, @C2, @C3, @C4, @C5, @C6, @C7, @C8, @C9, @C10, @C11, @C12, @C13, @C14, @C15, @C16
        END 

      CLOSE VENDOR_CURSOR; 
      DEALLOCATE VENDOR_CURSOR; 

	  
	  
	  
	  -- = LOG THE ERROR AND ROLLBACK THE TRANSACTION, IF NO ERROR COMMIT TRANSCATION
      IF ( ( @ERRORFOUND = 1 ) 
            OR ( @@ERROR <> 0 ) ) 
        BEGIN 
            RAISERROR (@ERRORMSG,16,1 ); 
            ROLLBACK TRAN ASSET; 
        END 
      ELSE 
        COMMIT TRAN ASSET; 
  END 