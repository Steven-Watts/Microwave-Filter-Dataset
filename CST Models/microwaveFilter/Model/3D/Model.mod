'# MWS Version: Version 2024.5 - Jun 14 2024 - ACIS 33.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0.0 fmax = 0.0
'# created = '[VERSION]2024.5|33.0.1|20240614[/VERSION]


'@ new component: component1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Component 
.New "component1"
End With

'@ define brick: component1:GroundPlane

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
.Reset
.Name "GroundPlane"
.Component "component1"
.Material "PEC"
.Xrange "-sizeSubX/2", "sizeSubX/2"
.Yrange "-sizeSubY/2", "sizeSubY/2"
.Zrange "-thickSub/2", "-thickSub/2 - thickGroundPlane"
.Create
End With

'@ define material: substrate

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Material 
.Reset 
.Name "substrate"
.FrqType "all"
.Type "Normal"
.Epsilon "4.3"
.Mu "1"
.Colour "1", "1", "0.501961"
.Create
End With

'@ define brick: component1:Substr

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
.Reset
.Name "Substr"
.Component "component1"
.Material "substrate"
.Xrange "-sizeSubX/2", "sizeSubX/2"
.Yrange "-sizeSubY/2", "sizeSubY/2"
.Zrange "-thickSub/2", "thickSub/2"
.Create
End With

'@ define brick: component1:FeedLine1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
.Reset
.Name "FeedLine1"
.Component "component1"
.Material "PEC"
.Xrange "-feedLineWidth/2", "feedLineWidth/2"
.Yrange "sizeSubY/2", "(numCellY*sizeCellsY)/2"
.Zrange "thickSub/2", "thickSub/2 + thickCells"
.Create
End With

'@ define brick: component1:FeedLine2

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
.Reset
.Name "FeedLine2"
.Component "component1"
.Material "PEC"
.Xrange "sizeSubX/2", "(numCellX*sizeCellsX)/2"
.Yrange "-feedLineWidth/2", "feedLineWidth/2"
.Zrange "thickSub/2", "thickSub/2 + thickCells"
.Create
End With

'@ define brick: component1:C_1_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
.Reset
.Name "C_1_1"
.Component "component1"
.Material "PEC"
.Xrange "-8", "-8 + cell_1_1 * sizeCellsY"
.Yrange "-8", "-8 + cell_1_1 * sizeCellsY"
.Zrange "thickSub/2", "thickSub/2 + thickCells"
.Create
End With

'@ boolean add shapes: component1:C_1_1, component1:FeedLine1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Solid
.Add "component1:C_1_1", "component1:FeedLine1"
End With

'@ boolean add shapes: component1:C_1_1, component1:FeedLine2

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Solid
.Add "component1:C_1_1", "component1:FeedLine2"
End With

'@ create Port: 1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickFaceFromId "component1:C_1_1", "6"
With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0", "0"
  .YrangeAdd "1.6*6.8", "1.6*6.8"
  .ZrangeAdd "1.6", "1.6*6.8"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ create Port: 2

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickFaceFromId "component1:C_1_1", "11"
With Port
  .Reset
  .PortNumber "2"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "1.6*6.8", "1.6*6.8"
  .YrangeAdd "0", "0"
  .ZrangeAdd "1.6", "1.6*6.8"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ delete brick: component1:C_1_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Delete "component1:C_1_1"

'@ define brick: component1:FeedLine1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
.Reset
.Name "FeedLine1"
.Component "component1"
.Material "PEC"
.Xrange "-feedLineWidth/2", "feedLineWidth/2"
.Yrange "sizeSubY/2", "(numCellY*sizeCellsY)/2"
.Zrange "thickSub/2", "thickSub/2 + thickCells"
.Create
End With

'@ define brick: component1:FeedLine2

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
.Reset
.Name "FeedLine2"
.Component "component1"
.Material "PEC"
.Xrange "sizeSubX/2", "(numCellX*sizeCellsX)/2"
.Yrange "-feedLineWidth/2", "feedLineWidth/2"
.Zrange "thickSub/2", "thickSub/2 + thickCells"
.Create
End With

'@ define brick: component1:C_1_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
.Reset
.Name "C_1_1"
.Component "component1"
.Material "PEC"
.Xrange "-8", "-8 + cell_1_1 * sizeCellsY"
.Yrange "-8", "-8 + cell_1_1 * sizeCellsY"
.Zrange "thickSub/2", "thickSub/2 + thickCells"
.Create
End With

'@ boolean add shapes: component1:C_1_1, component1:FeedLine1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Solid
.Add "component1:C_1_1", "component1:FeedLine1"
End With

'@ boolean add shapes: component1:C_1_1, component1:FeedLine2

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Solid
.Add "component1:C_1_1", "component1:FeedLine2"
End With

'@ Add DXF

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With DXF
     .Reset
     .FileName "./trial.dxf"
     .AddAllShapes "True"
     .PreserveHoles "True"
     .CloseShapes "True"
     .AsCurves "False"
     .HealSelfIntersections "False"
     .Id "5"
     .SetSimplifyActive "True"
     .SetSimplifyAngle "5.0"
     .SetSimplifyRadiusTol "5.0"
     .SetSimplifyEdgeLength "0.0"
     .ScaleToUnit "False"
     .ImportFileUnits "m"
     .UseModelTolerance "False"
     .ModelTolerance "0.0001"
     .ConsiderPolylineStartAndEndWidth "True"
     .Version "11.3"
     .DiscardElevationsReadFromDXFFile "True"
     .AddLayer "substrate", "PEC", "thickSub/2", "thickGroundPlane", "0"
     .Read
End With
Solid.Subtract "component1:C_1_1", "substrate:import_1"
Component.Delete "substrate"

'@ execute macro: updateGrid

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
DeleteResults()

