--SELECT TOP 1000 [plantname], 
--                [unitname], 
--                [categoryname], 
--                [liname], 
--                [year_key], 
--                [quarter_number], 
--                [month_name],
--				[Status]
--				--COUNT(status) 

--FROM   [AES_ASSET_DB_V3].[dbo].[view_factleading] 
--WHERE  status IS NOT NULL 


------------================ View LIMonthlyStats ==============================
SELECT *,
MaxStatus =
CASE
When (R>=Y and R>=G) then 'R'
When (Y>=G) then 'Y'
Else 'G'
END
FROM   (SELECT [plantname],
				[plantkey],
               [unitname], 
			   [unitkey],
			   [categoryname], 
               [categorykey], 
			    [liname],            
               [likey], 
			  
               [year_key] AS [Year],                     
               [quarter_number] AS [Quarter], 
               [month_name] AS [Month], 
               [status] 
        FROM   [dbo].vw_LeadingIndicators 
        WHERE  ([status] IS NOT NULL OR [status]!='#')) AS SRC 
       PIVOT ( Count([status]) 
             FOR [status] IN ([R], 
                            [Y], 
                            [G]) ) AS PIV;

------------================ END OF View LIMonthlyStats ==============================


------------================ View LIRollingLast30days ==============================
SELECT *,
MaxStatus =
CASE
When (R>=Y and R>=G) then 'R'
When (Y>=G) then 'Y'
Else 'G'
END
FROM   (SELECT [plantname], 
               [unitname], 
               [categorykey],
               [categoryname],			 
               [liname], 			      
               [status] 
        FROM   [dbo].vw_LeadingIndicators 
        WHERE  ([status] IS NOT NULL OR [status]!='#') 
		AND (DATEDIFF(DD,Day_date_d,GETDATE())<=90)
		) AS SRC 
       PIVOT ( Count([status]) 
             FOR [status] IN ([R], 
                            [Y], 
                            [G]) ) AS PIV;

------------================ END OF View LIRollingLast30days ==============================

SELECT CONVERT (DATE, Day_date_d),  DATEADD(DD, -180 ,Day_Date_D) AS ModDate
,
* FROM dimdate
WHERE  (Day_Date_D BETWEEN GETDATE() AND DATEADD(DD, -180 ,Day_Date_D))

SELECT * FROM dimdate
ORDER BY Day_Date_D DESC

Select DATEDIFF(DD, CONVERT(DATE,ISNULL(Day_date_d,GETDATE())), GETDATE()) ,* from vw_LeadingIndicators
WHERE Status is not null 
order by Day_Date_D DESC

CONVERT (DATE, Day_date_d) = CONVERT (DATE, @SampleDateKey)


SELECT * FROM vw_LIMonthlyStats


plantname	unitname	categoryname	liname	year_key	quarter_number	month_name	G	R	Y
Petersburg	Unit 1	Process Performance	1-1 A/H dP	2016	2	June	1	0	0

SELECT * FROM 
[AES_ASSET_DB_V3].[dbo].[view_factleading]
Where plantname = 'Petersburg' and UnitName= 'Unit 1' and LIName= '1-1 A/H dP'


--SELECT *,
--MaxStatus =
--CASE 
--WHEN (G > R AND G>Y) THEN 'G'
--WHEN (R>G AND R>Y) THEN 'R'
--WHEN (Y>G AND Y>R) THEN 'Y'
--WHEN (G=R) THEN 'R'
--WHEN (G=R) THEN 'R'
--WHEN (G=R) THEN 'R'
--ELSE 'R'
--FROM 


--================ NEW Rollong View =======================

 
SELECT *, 
InRed = CONVERT(VARCHAR(100),CAST((R*100.0 / (R+Y+G)) AS Decimal(12,2))) +'%',
InYellow  = CONVERT(VARCHAR(100),CAST((Y*100.0 / (R+Y+G)) AS Decimal(12,2))) +'%', 
InGreen = CONVERT(VARCHAR(100),CAST((G*100.0 / (R+Y+G)) AS Decimal(12,2))) +'%'
FROM   (SELECT [plantname], 
			   [plantkey],			
               [unitname], 
			   [unitkey],
               [categorykey],
               [categoryname],  
			   [likey],                                       
               [liname],                                               
               [status] 
        FROM   [dbo].vw_LeadingIndicators 
        WHERE  ([status] IS NOT NULL OR [status]!='#') 
                             AND (DATEDIFF(DD,Day_date_d,GETDATE())<=90)
                             ) AS SRC 
       PIVOT ( Count([status]) 
             FOR [status] IN ([R], 
                            [Y], 
                            [G]) ) AS PIV
							ORDER BY InRed desc
 
