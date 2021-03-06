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
	  DECLARE @C17 NVARCHAR(500); 
      DECLARE @C18 NVARCHAR(500);
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
      DECLARE @DEBUG TINYINT =3; 
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
        SELECT [C1],[C2],[C3],[C4],[C5],[C6],[C7],[C8],[C9],[C10],[C11],[C12],[C13],[C14],[C15],[C16],[C17],[C18]
        FROM   STG_AHI 
        ORDER  BY Assetkey 

      OPEN VENDOR_CURSOR 

      FETCH NEXT FROM VENDOR_CURSOR INTO @C1, @C2, @C3, @C4, @C5, @C6, @C7, @C8, @C9, @C10, @C11, @C12, @C13, @C14, @C15, @C16,@C17,@C18

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
					SET @AHIMinValue= @C13; -- = TEST 
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

				IF ( Rtrim(Ltrim(@C5)) = 'Parent Asset Type' ) 
				BEGIN 
					SET @ParentAssetTypeValue = @C6; 
				END 

				IF ( Rtrim(Ltrim(@C7)) = 'Serial No.' ) 
				BEGIN 
					SET @SerialNo = @C8; 
				END 

				IF ( Rtrim(Ltrim(@C7)) = 'Asset Sub Type' ) 
				BEGIN 
					SET @AssetSubTypeValue = @C8; 
				END 				

				IF ( Rtrim(Ltrim(@C9)) = 'Asset Acquired' ) 
				BEGIN 
					SET @AssetAcquiredDate = @C10; 
				END 
				

				IF( Rtrim(Ltrim(@C9)) = 'Data Availability (Confidence Factor)' ) 
				BEGIN 
					SET @PotentialUsefulLifeLostPercentage = @C12; 

					IF @PotentialUsefulLifeLostPercentage = 'Info Reqd.' 
					SET @PotentialUsefulLifeLostPercentage = NULL 
				END 

				IF( Rtrim(Ltrim(@C9)) = 'Projected Remaining Useful Life' ) 
				BEGIN 
					SET @PotentialUsefulLifeLost = @C12; 

					IF @PotentialUsefulLifeLost = 'Info Reqd.' 
					SET @PotentialUsefulLifeLost = NULL 
				END 

				IF ( Rtrim(Ltrim(@C11)) = 'Estimated Life (yrs)' ) 
				BEGIN 
					SET @EstimatedLife = @C12; 
				END 

				IF( @C12 = 'Individual CI Health Monitor' ) 
				BEGIN 
					IF ( ( @C15 IS NULL 
							OR @C15 = '' ) 
						OR ( @C16 IS NULL 
								OR @C16 = '' 
								OR @C16 = '0' ) ) 
					BEGIN 
						SET @AssetHealthIndex=NULL; 
					END 
					ELSE 
					BEGIN 
						SET @AssetHealthIndex = ( ( ( CONVERT(FLOAT, @C15) ) / CONVERT(FLOAT, @C16) ) * 100 );
					END 

					IF ( ( @C18 IS NULL 
							OR @C18 = '' ) 
						OR ( @C17 IS NULL 
								OR @C17 = '' 
								OR @C17 = 0 ) ) 
					BEGIN 
						SET @DataAvailability=NULL; 
					END 
					ELSE 
					BEGIN 
						SET @DataAvailability = ( ( CONVERT(FLOAT, @C18) / CONVERT(FLOAT, @C17) ) * 100 );
					END 
				END 

				IF( @C1 = 'Estimated Useful Life Remaining' ) 
				BEGIN 
					SET @ProjectedRemainingLife = @C3; 
				END 
				--SELECT @C13, @C14, @C15, @C16 
			END
            -- = =================================================== END OF COMPARING EXCEL COLUMN FOR VALUE  =============================================================



           
            -- = IF DATE OF RECORD: FOUND AND ONE OF THE MANDATORY VALUE/FIELD IS MISSING BREAK THE EXECUTION AND RAISEERROR
            IF( @C1 = 'Date of Record:' ) 
            BEGIN 
					-- = CHECKING MANDATORY FIELDS VALUE, IF SOME OF THE FIELDS ARE MISSING BREAK THE EXECUTION
					BEGIN
					SET @DateKey = (SELECT TOP 1 Date_day_key 
									FROM   DimDate 
									WHERE  CONVERT(DATE, Day_date_d) = CONVERT(DATE, @DateKeyValue));
					SET @AssetAcquiredDateKey = (SELECT TOP 1 Date_day_key 
												FROM   DimDate 
												WHERE  CONVERT(DATE, Day_date_d) = CONVERT(DATE, @AssetAcquiredDate));


					-- = IF PARAM VALUE IS MISSING RAISE ERROR, OTHERIWSE SET @ALLPARAMAREFOUND=1
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
			
					END

					IF ( @DEBUG = 3 ) 
					SELECT @PlantNameValue AS '@PlantNameValue',@ParentAssetKeyValue AS '@ParentAssetKeyValue',@AssetIDValue AS '@AssetIDValue',@UnitNameValue AS '@UnitNameValue',
											@ParentAssetNameValue AS '@ParentAssetNameValue'
											,@AssetNameValue AS '@AssetNameValue',@UnitIDValue AS '@UnitIDValue',@ParentAssetTypeValue AS '@ParentAssetTypeValue',
						@AssetSubTypeValue AS '@AssetSubTypeValue',  @DateKeyValue AS 'Setting up DimDate',@DateKey AS '@DateKey',@AssetAcquiredDateKey AS '@AssetAcquiredDateKey', 'Mandatory Field Checking' AS 'Mandatory'




                  --ELSE 
					-- = IF ALL MANDATORY FIELD VALUE IS PRESENT FOLLOWING BLOCK WILL INSERT/SELECT FK VALUES
                    BEGIN 
                        -- = INSERT INTO DBO.DIMPLANT TABLE 
                        IF ( @DEBUG = 1 ) 
                          SELECT 'Inserting INTO DimPlant' 

                        BEGIN 
                            IF EXISTS (SELECT TOP 1 Plantkey 
                                       FROM   DimPlant 
                                       WHERE  Plantname = @PlantNameValue) 
                              BEGIN 

								 -- = NO UPDATE NEEDED


                                  SET @PlantKey = (SELECT TOP 1 Plantkey 
                                                   FROM   DimPlant 
                                                   WHERE  Plantname = @PlantNameValue); 
                              END 
                            ELSE 
                              BEGIN 
                                  IF ( @DEBUG = 1 ) 
                                    SELECT 'INSERT INTO DimPlant Table' 

									
									BEGIN TRY
	
										INSERT INTO  [DimPlant] 
												([Plantname],[Organizationkey],[Locationkey]) 
										VALUES      (@PlantNameValue,NULL,NULL)

										SET @PlantKey= Scope_identity(); 	

									END TRY
									BEGIN CATCH
										SET @ERRORFOUND=1; 
										SET @ERRORMSG = ERROR_MESSAGE(); 
									BREAK; 							
									END CATCH
									

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
									-- = NO UPDATE NEEDED

                                  SET @UnitKey = (SELECT TOP 1 Unitkey 
                                                  FROM   DimUnit 
                                                  WHERE  Unitname = @UnitNameValue); 
                              END 
                            ELSE 
                              BEGIN 
                                  IF ( @DEBUG = 1 ) 
                                    SELECT 'INSERT INTO DimUnit Table' 

									BEGIN TRY
	
										INSERT INTO  [DimUnit] 
													([Unitname],[Unitid],[Plantkey]) 
										VALUES      (@UnitNameValue,@UnitIDValue,@PlantKey) 

										SET @UnitKey= Scope_identity(); 

									END TRY
									BEGIN CATCH
										SET @ERRORFOUND=1; 
										SET @ERRORMSG = ERROR_MESSAGE(); 
										BREAK; 							
									END CATCH


                              END 
                        END 

                        -- = INSERT INTO DBO.DIMASSETTYPE TABLE 
                        IF( @ParentAssetTypeValue IS NOT NULL 
                            AND @ParentAssetTypeValue != '' ) 
                         BEGIN 
                              IF EXISTS (SELECT TOP 1 Assettypekey 
                                         FROM   DimAssetType 
                                         WHERE  Assettypename = @ParentAssetTypeValue) 
                                BEGIN 								

                                    SET @ParentAssetTypeKey = (SELECT TOP 1 Assettypekey 
                                                               FROM   DimAssetType 
                                                               WHERE  Assettypename = @ParentAssetTypeValue);
                                END 
                              ELSE 
                                BEGIN 
									BEGIN TRY
	
										INSERT INTO  DimAssetType 
													(Assettypename,Parentassettypekey) 
										VALUES      (@ParentAssetTypeValue,NULL) 
										SET @ParentAssetTypeKey= Scope_identity(); 

									END TRY
									BEGIN CATCH
										SET @ERRORFOUND=1; 
										SET @ERRORMSG = ERROR_MESSAGE(); 
										BREAK; 							
									END CATCH


                                END 
                          END 

                        
						IF (@DEBUG=1) SELECT 'Inserting INTO DimAssetType'

						IF( @AssetSubTypeValue IS NOT NULL 
                            AND @AssetSubTypeValue != '' )            
						BEGIN  
							   IF EXISTS ( SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= @AssetSubTypeValue)
							   BEGIN 										
									 SET @AssetTypeKey = (SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= @AssetSubTypeValue);
							   END  
								ELSE 
							   BEGIN  
									BEGIN TRY
										INSERT INTO  DimAssetType (AssetTypeName,ParentAssetTypeKey)                            
										VALUES (@AssetSubTypeValue,@ParentAssetTypeKey) 
                                  
										SET @AssetTypeKey= SCOPE_IDENTITY(); 

									END TRY
									BEGIN CATCH
									SET @ERRORFOUND=1; 
									SET @ERRORMSG = ERROR_MESSAGE(); 
									BREAK; 							
									END CATCH									
							   END 
						END
						ELSE
						BEGIN 
							   IF EXISTS ( SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= 'unspecified')
							   BEGIN 										
									 SET @AssetTypeKey = (SELECT TOP 1 AssetTypeKey FROM DimAssetType WHERE AssetTypeName= 'unspecified');
							   END  
								ELSE 
								BEGIN

									BEGIN TRY
	
									 INSERT INTO  DimAssetType (AssetTypeName,ParentAssetTypeKey)                            
									 VALUES ('unspecified',@ParentAssetTypeKey) 
									 SET @AssetTypeKey= SCOPE_IDENTITY(); 

									END TRY
									BEGIN CATCH
										SET @ERRORFOUND=1; 
										SET @ERRORMSG = ERROR_MESSAGE(); 
										BREAK; 							
									END CATCH

								END
						END


						IF (@DEBUG=1) SELECT 'Inserting INTO [DimAsset] INSERT/UPDATE'

                        IF @ParentAssetKeyValue IS NOT NULL 
                           AND @ParentAssetKeyValue != '' 
                          BEGIN 
                              IF EXISTS (SELECT TOP 1 Assetkey 
                                         FROM   DimAsset 
                                         WHERE  Assetid = @ParentAssetKeyValue) 
                                BEGIN 
									BEGIN TRY
	
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

									END TRY
									BEGIN CATCH
									SET @ERRORFOUND=1; 
									SET @ERRORMSG = ERROR_MESSAGE(); 
									BREAK; 							
									END CATCH


                                END 
                              ELSE 
                                BEGIN 
                                    IF ( @DEBUG = 1 ) 
                                      SELECT 'INSERT INTO DimAsset Parent'
									  
									BEGIN TRY
										 INSERT INTO [DimAsset] 
														([Parentassetkey],[Unitkey],[Assettypekey],[Assetid],[Assetname],[Assetdescription],[Serialno],[Assetacquireddate],[Assetacquireddatekey], 
														 [Estimatedlife]) 
											VALUES     ( NULL,@UnitKey,@AssetTypeKey,@ParentAssetKeyValue,@ParentAssetNameValue,@ParentAssetNameValue,@SerialNo,@AssetAcquiredDate,@AssetAcquiredDateKey,
														 @EstimatedLife) 
									
										 SET @ParentAssetKey= Scope_identity(); 
									END TRY
									BEGIN CATCH
										SET @ERRORFOUND=1; 
                                        SET @ERRORMSG = ERROR_MESSAGE(); 
										BREAK; 							
									END CATCH 


                                END 
                          END 



                        IF ( @DEBUG = 1 ) 
                          SELECT 'Inserting INTO DimAsset' 

                        BEGIN 
                            IF EXISTS (SELECT TOP 1 Assetkey 
                                       FROM   DimAsset 
                                       WHERE  Assetid = @AssetIDValue) 
                              BEGIN 

									BEGIN TRY
	
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


									END TRY
									BEGIN CATCH
										SET @ERRORFOUND=1; 
										SET @ERRORMSG = ERROR_MESSAGE(); 
										BREAK; 							
									END CATCH



                              END 
                            ELSE 
                              BEGIN 
                                  IF ( @DEBUG = 1 ) 
                                    SELECT 'INSERT INTO DimAsset Table' 

									BEGIN TRY
										 INSERT INTO  [DimAsset] 
                                              ([Parentassetkey],[Unitkey],[Assettypekey],[Assetid],[Assetname],[Assetdescription],[Serialno],[Assetacquireddate],[Assetacquireddatekey],[Estimatedlife]) 
										VALUES     ( @ParentAssetKey,@UnitKey,@AssetTypeKey,@AssetIDValue,@AssetNameValue,@AssetNameValue,@SerialNo,@AssetAcquiredDate,@AssetAcquiredDateKey,@EstimatedLife)
									
										SET @AssetKey= Scope_identity(); 
									END TRY
									BEGIN CATCH
										SET @ERRORFOUND=1; 
                                        SET @ERRORMSG = ERROR_MESSAGE(); 
										BREAK; 							
									END CATCH 

									

                              -- = TODO: INERT DATA WHEN TABLE IS NOT EMPTY 
                              END 
                        END 
                        
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

			  -- = ALL PARAM VALUE IS PRESENT, NOW WE CAN ADD THOSE TO DIFFERENT TABLE
            BEGIN  
                  IF ( @C1 IS NOT NULL ) 
                    SET @ProcedureName = @C1 

                  --ELSE SET @ProcedureName=@ProcedureName 


                  -- = ********************* SET FK TABLES ********************** 
                  BEGIN 
                      IF ( @DEBUG = 1 ) 
                        SELECT 'Inserting INTO DimProcedure' 

                      BEGIN 
                          IF EXISTS (SELECT TOP 1 Procedurekey 
                                     FROM   DimProcedure 
                                     WHERE  Procedurename = @ProcedureName) 
                            BEGIN 

								--UPDATE DimProcedure 
        --                               SET Procedurename= @ProcedureName
        --                         WHERE  Procedurename = @ProcedureName

                                SET @ProcedureKey = (SELECT TOP 1 Procedurekey 
                                                     FROM   DimProcedure 
                                                     WHERE  Procedurename = @ProcedureName); 
                            END 
                          ELSE 
                            BEGIN 

								BEGIN TRY
	
									INSERT INTO  [DimProcedure] 
												([Procedurename]) 
									VALUES      ( @ProcedureName ) 

									SET @ProcedureKey= Scope_identity();

								END TRY
								BEGIN CATCH
									SET @ERRORFOUND=1; 
									SET @ERRORMSG = ERROR_MESSAGE(); 
									BREAK; 							
								END CATCH
                             
                            END 
                      END 

                      IF ( @DEBUG = 1 ) 
                        SELECT 'Inserting/Updating INTO DimConditionIndicator' 

                      BEGIN 
                          IF EXISTS (SELECT TOP 1 Conditionindicatorkey 
                                     FROM   DimConditionIndicator 
                                     WHERE  Conditionindicatorname = @C2) 
                            BEGIN 

								--UPDATE  DimConditionIndicator 
								--SET Conditionindicatorname= @C2
								--WHERE  Conditionindicatorname = @C2
                                SET @ConditionIndicatorKey = (SELECT TOP 1 Conditionindicatorkey
                                                              FROM   DimConditionIndicator 
                                                              WHERE  Conditionindicatorname = @C2);
                            END 
                          ELSE 
                            BEGIN 
                                IF ( @DEBUG = 1 ) 
                                  SELECT 'INSERT INTO DimConditionIndicator Table' 
								  
									BEGIN TRY
										INSERT INTO  [DimConditionIndicator] 
                                            ([Conditionindicatorname]) 
										VALUES      ( @C2 ) 
										SET @ConditionIndicatorKey= Scope_identity(); 

									END TRY
									BEGIN CATCH
										SET @ERRORFOUND=1; 
                                        SET @ERRORMSG = ERROR_MESSAGE(); 
										BREAK; 							
									END CATCH 
                           
                            END 
                      END 

                      IF ( @DEBUG = 1 ) 
                        SELECT 'Inserting INTO DimFailureMode' 

                      BEGIN 
                          IF EXISTS (SELECT TOP 1 Failuremodekey 
                                     FROM   DimFailureMode 
                                     WHERE  Failuremodename = @C3) 
                            BEGIN 
							
                                SET @FailureModeKey = (SELECT TOP 1 Failuremodekey 
                                                       FROM   DimFailureMode 
                                                       WHERE  Failuremodename = @C3); 
                            END 
                          ELSE 
                            BEGIN 
                                IF ( @DEBUG = 1 ) 
                                  SELECT 'INSERT INTO DimFailureMode Table'
								  
									BEGIN TRY
										  INSERT INTO  [DimFailureMode] 
														([Failuremodename]) 
											VALUES      ( @C3 ) 
											SET @FailureModeKey= Scope_identity(); 

									END TRY
									BEGIN CATCH
										SET @ERRORFOUND=1; 
                                        SET @ERRORMSG = ERROR_MESSAGE(); 
										BREAK; 							
									END CATCH 

                              
								
                            END 
                      END 
                  END 

                  -- = ***************** END OF SET FK TABLES ************************ 



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
						SET @C12=NULL;
						  
					 -- = ***************** INSERTING INTO [FactTestResult] ************************                                        

					BEGIN TRY
							INSERT INTO  [FactTestResult] 
										([Assetkey],[Procedurekey],[Conditionindicatorkey],[Failuremodekey],[Datekey],[Impactweightage],[Testresult],[Normalizedcf],[Healthalert],[Notes]) 
							VALUES      (@AssetKey,@ProcedureKey,@ConditionIndicatorKey,@FailureModeKey,@DateKey,@C4,@C5,@C6,@C12,@C13)

					END TRY
					BEGIN CATCH
						SET @ERRORFOUND=1; 
						SET @ERRORMSG = ERROR_MESSAGE(); 
						BREAK; 
					END CATCH

					-- = END OF INSERT RECORD INTO [FactTestResult]TABLE  
              END 

            
			
			-- = INSERT INTO FACTASSETINDICATORS START 
            IF( @C1 = 'Estimated Useful Life Remaining' ) 
				AND (@AllParamAreFound=1)
              BEGIN 
                      IF ( @DEBUG = 3 ) 
                        SELECT @AssetHealthIndex AS '@AssetHealthIndex',@DataAvailability AS '@DataAvailability',@ProjectedRemainingLife AS '@ProjectedRemainingLife',
                                                 @PotentialUsefulLifeLostPercentage AS '@PotentialUsefulLifeLostPercentage',@PotentialUsefulLifeLost AS '@PotentialUsefulLifeLost',
                               @AHIMinValue AS '@AHIMinValue' 

					  -- = NO UPDATE REQUIRED, IF MATCHING RECORD FOUND FOR (Assetkey AND DateKey) DELETE BEFORE INSERTING NEW ROW
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

						
						-- = FOLLOWING CODE INSERT INTO [FactAssetIndicators], RAISE ERROR IF INSERT FAILS                     

						BEGIN TRY
							INSERT INTO  [FactAssetIndicators] 
							([Assetkey],[Datekey],[Assethealthindex],[Dataavailability],[Projectedremaininglife],[Potentialusefullifelostpercentage],[Potentialusefullifelost],Ahiminvalue) 
							VALUES      (@AssetKey,@DateKey,@AssetHealthIndex,@DataAvailability,@ProjectedRemainingLife,@PotentialUsefulLifeLostPercentage,@PotentialUsefulLifeLost,@AHIMinValue)

						END TRY
						BEGIN CATCH
							SET @ERRORFOUND=1; 
							SET @ERRORMSG = ERROR_MESSAGE(); 
							BREAK; 
						END CATCH
				  
						  -- = THIS WILL INSERT ONLY ONE ROW IN FactAssetIndicators AND THEN BREAK
						  BREAK; 
              END 

            
			
			-- = GET THE NEXT ROW.   
            FETCH NEXT FROM VENDOR_CURSOR INTO @C1, @C2, @C3, @C4, @C5, @C6, @C7, @C8, @C9, @C10, @C11, @C12, @C13, @C14, @C15, @C16,@C17,@C18
        END 

      CLOSE VENDOR_CURSOR; 
      DEALLOCATE VENDOR_CURSOR; 

	  
	  
	  
	  -- = LOG THE ERROR AND ROLLBACK THE TRANSACTION, IF NO ERROR COMMIT TRANSCATION
      IF ( ( @ERRORFOUND = 1 ) 
            OR ( @@ERROR <> 0 ) ) 
        BEGIN 
			IF (@DEBUG=3) SELECT 'Error Block'								
            RAISERROR (@ERRORMSG,16,1 ); 
            ROLLBACK TRAN ASSET; 
        END 
      ELSE 
        COMMIT TRAN ASSET; 
  END 