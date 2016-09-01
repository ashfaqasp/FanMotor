USE [AES_DW]
GO

/****** Object:  View [dbo].[vw_LIMonthlyStats]    Script Date: 2016-09-01 4:25:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_LIMonthlyStats]
AS
SELECT CONVERT(DATE, Dateadd(s, -1, Dateadd(mm, Datediff(m, 0, CONVERT(DATE, 
                                                CONVERT( 
                                                       VARCHAR(10), 
                                                                     [month_key]) + 
                                                '-1-' 
                                                   + 
                                                       CONVERT( 
                                                       VARCHAR(10), 
                                                                     [year_key]))) 
                                                + 1, 0))) AS MonthEndDate, 
       *, 
       MonthStatus = CASE 
                       WHEN ( r >= y 
                              AND r >= g ) THEN 'R' 
                       WHEN ( y >= g ) THEN 'Y' 
                       WHEN ( ( r = 0 ) 
                              AND ( y = 0 ) 
                              AND ( g = 0 ) ) THEN 'U' 
                       ELSE 'G' 
                     END 
FROM   (SELECT [plantname], 
               [plantkey], 
               [unitname], 
               [unitkey], 
               [categoryname], 
               [categorykey], 
               [linameUnique], 
               [likey], 
               criticalityranking, 
               DimDate.[year_key]   ,              
               DimDate.[month_key]  ,                
               [status] 
        FROM   [dbo].vw_lidetails AS LI
		INNER JOIN  dbo.DimDate ON 	LI.SampleDateKey = DimDate.Day_Date
		
		) AS SRC 
       PIVOT (Count([status]) 
             FOR [status] IN ([R], 
                              [Y], 
                              [G], 
                              [U])) AS piv; 


GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_LIMonthlyStats'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_LIMonthlyStats'
GO


