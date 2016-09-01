USE [AES_DW]
GO

/****** Object:  View [dbo].[vw_LIDetails]    Script Date: 2016-09-01 4:19:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_LIDetails]
AS
SELECT        dbo.DimDate.Day_Date_D AS SampleDateKey, dbo.DimPlant.PlantName, dbo.DimPlant.PlantKey, dbo.DimUnit.UnitName, dbo.FactLeadingIndicators.UnitKey, dbo.DimPerformanceCategory.CategoryName, 
                         dbo.FactLeadingIndicators.CategoryKey, dbo.DimLeadingIndicator.LIName + ' (' + CONVERT(VARCHAR, dbo.DimPlant.PlantKey) + '.' + CONVERT(VARCHAR, dbo.DimUnit.UnitKey) + '.' + CONVERT(VARCHAR, 
                         dbo.DimPerformanceCategory.CategoryKey) + ')' AS LINameUnique, dbo.FactLeadingIndicators.LIKey, dbo.FactLeadingIndicators.Status, dbo.FactLeadingIndicators.Value, 
                         dbo.FactLeadingIndicators.PercentOfTarget, dbo.FactLeadingIndicators.LowerDeviation, dbo.FactLeadingIndicators.UpperDeviation, dbo.FactLeadingIndicators.TargetValueCalculation, 
                         dbo.FactLeadingIndicators.MinThresholdCalculation, dbo.FactLeadingIndicators.MaxThresholdCalculation, dbo.DimLeadingIndicator.CriticalityRanking, dbo.FactLeadingIndicators.SampleDateTime
FROM            dbo.DimUnit INNER JOIN
                         dbo.FactLeadingIndicators ON dbo.DimUnit.UnitKey = dbo.FactLeadingIndicators.UnitKey LEFT OUTER JOIN
                         dbo.DimPerformanceCategory ON dbo.FactLeadingIndicators.CategoryKey = dbo.DimPerformanceCategory.CategoryKey INNER JOIN
                         dbo.DimDate ON dbo.FactLeadingIndicators.SampleDateKey = dbo.DimDate.Date_Day_Key INNER JOIN
                         dbo.DimPlant ON dbo.DimUnit.PlantKey = dbo.DimPlant.PlantKey LEFT OUTER JOIN
                         dbo.DimLeadingIndicator ON dbo.FactLeadingIndicators.LIKey = dbo.DimLeadingIndicator.LIKey

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[29] 2[18] 3) )"
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
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DimUnit"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FactLeadingIndicators"
            Begin Extent = 
               Top = 203
               Left = 319
               Bottom = 494
               Right = 543
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DimPerformanceCategory"
            Begin Extent = 
               Top = 280
               Left = 44
               Bottom = 376
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DimDate"
            Begin Extent = 
               Top = 23
               Left = 692
               Bottom = 233
               Right = 970
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "DimPlant"
            Begin Extent = 
               Top = 14
               Left = 401
               Bottom = 144
               Right = 577
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DimLeadingIndicator"
            Begin Extent = 
               Top = 281
               Left = 701
               Bottom = 532
               Right = 1068
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 32
         Width = 284
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_LIDetails'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1755
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2760
         Alias = 1890
         Table = 1365
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_LIDetails'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_LIDetails'
GO


