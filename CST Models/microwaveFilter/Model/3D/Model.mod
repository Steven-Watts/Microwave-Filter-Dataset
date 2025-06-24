'# MWS Version: Version 2023.5 - Jun 08 2023 - ACIS 32.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 1 fmax = 10
'# created = '[VERSION]2024.5|33.0.1|20240614[/VERSION]


'@ new component: component1

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
With Component 
.New "component1"
End With

'@ define brick: component1:GroundPlane

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
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

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
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

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
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

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
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

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
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

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
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

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
With Solid
.Add "component1:C_1_1", "component1:FeedLine1"
End With

'@ boolean add shapes: component1:C_1_1, component1:FeedLine2

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
With Solid
.Add "component1:C_1_1", "component1:FeedLine2"
End With

'@ create Port: 1

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
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

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
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

'@ execute macro: iniFilter

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "conducting wall"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
     .WallConductivity "1000"
End With

Mesh.SetCreator "High Frequency"

With FDSolver
     .Reset
     .SetMethod "Tetrahedral", "Fast reduced order model"
     .OrderTet "Second"
     .OrderSrf "First"
     .Stimulation "All", "All"
     .ResetExcitationList
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .ModesOnly "False"
     .ConsiderPortLossesTet "True"
     .SetShieldAllPorts "True"
     .AccuracyHex "1e-6"
     .AccuracyTet "1e-5"
     .AccuracySrf "1e-3"
     .LimitIterations "False"
     .MaxIterations "0"
     .SetCalcBlockExcitationsInParallel "True", "True", ""
     .StoreAllResults "False"
     .StoreResultsInCache "False"
     .UseHelmholtzEquation "True"
     .LowFrequencyStabilization "True"
     .Type "Direct"
     .MeshAdaptionHex "False"
     .MeshAdaptionTet "True"
     .AcceleratedRestart "True"
     .FreqDistAdaptMode "Distributed"
     .NewIterativeSolver "True"
     .TDCompatibleMaterials "False"
     .ExtrudeOpenBC "False"
     .SetOpenBCTypeHex "Default"
     .SetOpenBCTypeTet "Default"
     .AddMonitorSamples "True"
     .CalcPowerLoss "True"
     .CalcPowerLossPerComponent "False"
     .StoreSolutionCoefficients "True"
     .UseDoublePrecision "False"
     .UseDoublePrecision_ML "True"
     .MixedOrderSrf "False"
     .MixedOrderTet "False"
     .PreconditionerAccuracyIntEq "0.15"
     .MLFMMAccuracy "Default"
     .MinMLFMMBoxSize "0.3"
     .UseCFIEForCPECIntEq "True"
     .UseEnhancedCFIE2 "True"
     .UseFastRCSSweepIntEq "false"
     .UseSensitivityAnalysis "False"
     .UseEnhancedNFSImprint "False"
     .UseFastDirectFFCalc "False"
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3"
     .SetNumberOfResultDataSamples "5001"
     .SetResultDataSamplingMode "Automatic"
     .SweepWeightEvanescent "1.0"
     .AccuracyROM "1e-4"
     .AddSampleInterval "", "", "1", "Automatic", "True"
     .AddSampleInterval "", "", "", "Automatic", "False"
     .SetUseFastResonantForSweepTet "True"
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "4"
End With
With MeshSettings
     .SetMeshType "Unstr"
     .Set "UseDC", "0"
End With
UseDistributedComputingForParameters "False"
MaxNumberOfDistributedComputingParameters "2"
UseDistributedComputingMemorySetting "False"
MinDistributedComputingMemoryLimit "0"
UseDistributedComputingSharedDirectory "False"
OnlyConsider0D1DResultsForDC "False"

With IESolver
     .Reset
     .UseFastFrequencySweep "True"
     .UseIEGroundPlane "False"
     .SetRealGroundMaterialName ""
     .CalcFarFieldInRealGround "False"
     .RealGroundModelType "Auto"
     .PreconditionerType "Auto"
     .ExtendThinWireModelByWireNubs "False"
     .ExtraPreconditioning "False"
End With

With IESolver
     .SetFMMFFCalcStopLevel "0"
     .SetFMMFFCalcNumInterpPoints "6"
     .UseFMMFarfieldCalc "True"
     .SetCFIEAlpha "0.500000"
     .LowFrequencyStabilization "False"
     .LowFrequencyStabilizationML "True"
     .Multilayer "False"
     .SetiMoMACC_I "0.0001"
     .SetiMoMACC_M "0.0001"
     .DeembedExternalPorts "True"
     .SetOpenBC_XY "True"
     .OldRCSSweepDefintion "False"
     .SetRCSOptimizationProperties "True", "100", "0.00001"
     .SetAccuracySetting "Custom"
     .CalculateSParaforFieldsources "True"
     .ModeTrackingCMA "True"
     .NumberOfModesCMA "3"
     .StartFrequencyCMA "-1.0"
     .SetAccuracySettingCMA "Default"
     .FrequencySamplesCMA "0"
     .SetMemSettingCMA "Auto"
     .CalculateModalWeightingCoefficientsCMA "True"
     .DetectThinDielectrics "True"
End With

Solver.FrequencyRange "1", "10"

ResetViewToStructure()

'@ define time domain solver parameters

'[VERSION]2023.5|32.0.1|20230608[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

