'# MWS Version: Version 2023.5 - Jun 08 2023 - ACIS 32.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0.75 fmax = 1.25


'@ use template: Antenna (in Free Space, waveguide)

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
' Template for Antenna in Free Space
' ==================================
' (CSTxMWSxONLY)
' draw the bounding box
Plot.DrawBox True
' set units to mm, ghz
With Units 
     .Geometry "mm" 
     .Frequency "ghz" 
     .Time "ns" 
End With 
' set background material to vacuum
With Background 
     .Type "Normal" 
     .Epsilon "1.0" 
     .Mue "1.0" 
     .XminSpace "0.0" 
     .XmaxSpace "0.0" 
     .YminSpace "0.0" 
     .YmaxSpace "0.0" 
     .ZminSpace "0.0" 
     .ZmaxSpace "0.0" 
End With 
' set boundary conditions to open
With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "none" 
     .Ysymmetry "none" 
     .Zsymmetry "none" 
End With

'@ define layer: PEC

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
With Layer 
     .Reset 
     .Name "PEC" 
     .Type "Pec" 
     .Colour "0.752941", "0.752941", "0.752941" 
     .Wireframe "False" 
     .Transparency "0" 
     .Create 
End With

'@ define cylinder: PEC:Driven Element

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
With Cylinder 
     .Reset 
     .Name "Driven Element" 
     .Layer "PEC" 
     .OuterRadius "r" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "-DipLen/2", "DipLen/2" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Create 
End With

'@ define brick: PEC:solid1

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "PEC" 
     .Material "PEC" 
     .Xrange "-2*r", "2*r" 
     .Yrange "-2*r", "2*r" 
     .Zrange "-d/2", "d/2" 
     .Create
End With

'@ boolean subtract shapes: PEC:Driven Element, PEC:solid1

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
Solid.Subtract "PEC:Driven Element", "PEC:solid1"

'@ define automesh state

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
Mesh.Automesh "True"

'@ define frequency range

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
Solver.FrequencyRange "25", "35"

'@ define boundaries

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "magnetic" 
     .Ysymmetry "magnetic" 
     .Zsymmetry "electric" 
End With

'@ pick center point

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
Pick.PickCenterpointFromId "PEC:Driven Element", "2"

'@ pick center point

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
Pick.PickCenterpointFromId "PEC:Driven Element", "1"

'@ define discrete port: 1

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter" 
     .Label "p1" 
     .Impedance "65" 
     .VoltagePortImpedance "0.0" 
     .Voltage "1.0" 
     .Current "1.0" 
     .SetP1 "True", "0", "0", "-d/2" 
     .SetP2 "True", "0", "0", "d/2" 
     .InvertDirection "False" 
     .LocalCoordinates "False" 
     .Monitor "True" 
     .Radius "0.0" 
     .Wire "" 
     .Position "" 
     .Create 
End With

'@ set mesh properties (Hexahedral)

'[VERSION]2014.0|23.0.0|20130901[/VERSION]
With Mesh 
     .MeshType "PBA" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "30" 
     .Set "StepsPerWaveFar", "30" 
     .Set "WavelengthRefinementSameAsNear", "1" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "30" 
     .Set "StepsPerBoxFar", "1" 
     .Set "MaxStepNear", "0" 
     .Set "MaxStepFar", "0" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     .Set "UseMaxStepAbsolute", "0" 
     .Set "GeometryRefinementSameAsNear", "0" 
     'MIN CELL 
     .Set "UseRatioLimitGeometry", "1" 
     .Set "RatioLimitGeometry", "10" 
     .Set "MinStepGeometryX", "0" 
     .Set "MinStepGeometryY", "0" 
     .Set "MinStepGeometryZ", "0" 
     .Set "UseSameMinStepGeometryXYZ", "1" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "FaceRefinementOn", "0" 
     .Set "FaceRefinementPolicy", "2" 
     .Set "FaceRefinementRatio", "2" 
     .Set "FaceRefinementStep", "0" 
     .Set "FaceRefinementNSteps", "2" 
     .Set "EllipseRefinementOn", "0" 
     .Set "EllipseRefinementPolicy", "2" 
     .Set "EllipseRefinementRatio", "2" 
     .Set "EllipseRefinementStep", "0" 
     .Set "EllipseRefinementNSteps", "2" 
     .Set "FaceRefinementBufferLines", "3" 
     .Set "EdgeRefinementOn", "1" 
     .Set "EdgeRefinementPolicy", "1" 
     .Set "EdgeRefinementRatio", "6" 
     .Set "EdgeRefinementStep", "0" 
     .Set "EdgeRefinementBufferLines", "3" 
     .Set "RefineEdgeMaterialGlobal", "0" 
     .Set "RefineAxialEdgeGlobal", "0" 
     .Set "BufferLinesNear", "3" 
     .Set "UseDielectrics", "1" 
     .Set "EquilibrateOn", "0" 
     .Set "Equilibrate", "1.5" 
     .Set "IgnoreThinPanelMaterial", "0" 
     .Set "RefineEdgesAtBoundary", "0" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "SnapToAxialEdges", "1"
     .Set "SnapToPlanes", "1"
     .Set "SnapToSpheres", "1"
     .Set "SnapToEllipses", "1"
     .Set "SnapToCylinders", "1"
     .Set "SnapToCylinderCenters", "1"
     .Set "SnapToEllipseCenters", "1"
End With 
With Discretizer 
     .MeshType "PBA" 
     .PBAType "Fast PBA" 
     .AutomaticPBAType "True" 
     .FPBAAccuracyEnhancement "enable"
     .ConnectivityCheck "False"
     .ConvertGeometryDataAfterMeshing "True" 
     .UsePecEdgeModel "True" 
     .GapDetection "False" 
     .FPBAGapTolerance "1e-3" 
     .SetMaxParallelMesherThreads "Hex", "8"
     .SetParallelMesherMode "Hex", "Maximum"
     .PointAccEnhancement "0" 
     .UseSplitComponents "True" 
     .EnableSubgridding "False" 
     .PBAFillLimit "99" 
     .AlwaysExcludePec "False" 
End With

'@ define pml specials

'[VERSION]2010.0|18.0.3|20090230[/VERSION]
With Boundary
     .SetPMLType "ConvPML" 
     .Layer "4" 
     .Reflection "0.0001" 
     .Progression "parabolic" 
     .MinimumLinesDistance "5" 
     .MinimumDistancePerWavelength "8" 
     .ActivePMLFactor "1.0" 
     .FrequencyForMinimumDistance "30" 
     .MinimumDistanceAtCenterFrequency "True" 
     .SetConvPMLKMax "5.0" 
     .SetConvPMLExponentM "3" 
End With

'@ set units in materials

'[VERSION]2010.3|20.0.0|20100412[/VERSION]
Material.SetUnitInMaterial "PEC", "GHz", "mm"

'@ define time domain solver parameters

'[VERSION]2012.0|22.0.0|20111004[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-60"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set mesh properties

'[VERSION]2013.0|23.0.0|20130115[/VERSION]
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "CellsPerWavelengthPolicy", "cellsperwavelength" 
     .Set "CurvatureOrderPolicy", "off" 
     .SetMeshType "Plane" 
     .Set "CurvatureOrderPolicy", "off" 
End With

'@ change solver type

'[VERSION]2013.0|23.0.0|20130115[/VERSION]
ChangeSolverType "HF Time Domain"

'@ define pml specials

'[VERSION]2014.0|23.0.0|20130901[/VERSION]
With Boundary
     .ReflectionLevel "0.0001" 
     .MinimumDistanceType "Fraction" 
     .MinimumDistancePerWavelengthNewMeshEngine "4" 
     .MinimumDistanceReferenceFrequencyType "CenterNMonitors" 
     .FrequencyForMinimumDistance "27.18" 
     .SetAbsoluteDistance "0.0" 
End With

'@ set pba mesh type

'[VERSION]2014.0|23.0.0|20130901[/VERSION]
Mesh.MeshType "PBA"

'@ set mesh properties (for backward compatibility)

'[VERSION]2017.0|26.0.1|20161226[/VERSION]
With MeshSettings 
    .SetMeshType "Hex"
    .Set "PlaneMergeVersion", 0
End With

'@ set parametersweep options

'[VERSION]2017.5|26.0.1|20170804[/VERSION]
With ParameterSweep
    .SetSimulationType "Transient" 
End With

'@ add parsweep sequence: Sequence 1

'[VERSION]2017.5|26.0.1|20170804[/VERSION]
With ParameterSweep
     .AddSequence "Sequence 1" 
End With

'@ add parsweep parameter: Sequence 1:lambda

'[VERSION]2017.5|26.0.1|20170804[/VERSION]
With ParameterSweep
     .AddParameter_Linear "Sequence 1", "lambda", "9", "11", "3" 
End With

'@ define frequency range

'[VERSION]2017.5|26.0.1|20170804[/VERSION]
Solver.FrequencyRange "0.75", "1.25"

'@ define farfield monitor: farfield (broadband)

'[VERSION]2017.5|26.0.1|20170804[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (broadband)" 
     .Domain "Time" 
     .Accuracy "1e-3" 
     .FrequencySamples "3" 
     .FieldType "Farfield" 
     .Frequency "1" 
     .TransientFarfield "True" 
     .ExportFarfieldSource "False" 
     .Create 
End With

'@ define farfield monitor: farfield (f=0.8)

'[VERSION]2019.2|28.0.2|20181205[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=0.8)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "0.8" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Free" 
     .SetSubvolume "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "True" 
     .SetSubvolumeOffsetType "Absolute" 
     .Create 
End With

'@ define farfield monitor: farfield (f=1.2)

'[VERSION]2019.2|28.0.2|20181205[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=1.2)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "1.2" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-1.0106999999999999", "1.0106999999999999", "-1.0106999999999999", "1.0106999999999999", "-69", "69" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "True" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .Create 
End With

'@ farfield plot options

'[VERSION]2019.3|28.0.2|20190118[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "0" 
     .Phi "0" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "False" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "1" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Epattern" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .StoreSettings
End With 

