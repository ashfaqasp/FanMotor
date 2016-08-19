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

SELECT * 
FROM   (SELECT [plantname], 
               [unitname], 
               [categoryname], 
               [liname], 
               [year_key], 
               [quarter_number], 
               [month_name], 
               [status] 
        FROM   [AES_ASSET_DB_V3].[dbo].[view_factleading] 
        WHERE  status IS NOT NULL) AS SRC 
       PIVOT ( Count([status]) 
             FOR [status] IN ([G], 
                            [R], 
                            [Y]) ) AS piv; 


plantname	unitname	categoryname	liname	year_key	quarter_number	month_name	G	R	Y
Petersburg	Unit 1	Process Performance	1-1 A/H dP	2016	2	June	1	0	0

SELECT * FROM 
[AES_ASSET_DB_V3].[dbo].[view_factleading]
Where plantname = 'Petersburg' and UnitName= 'Unit 1' and LIName= '1-1 A/H dP'