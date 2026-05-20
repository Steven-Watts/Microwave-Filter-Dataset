clear

% Settings
numberOfSimulations = 1; % Any Number of topologies
numberOfSimulationsPerFile = 1; % Typically 500 to keep within .mat save size

topologyDistribution = "Rotated X"; % Select from: 
% X, Rotated Noisy X, Rotated X, Slash, Rotated Ellipse, Rotated Slash, H, Y

% 1. First set up the data handler
DH = DataHandler(topologyDistribution);

% 2. Then expand the dataset
DH.expandDataSet(numberOfSimulations,numberOfSimulationsPerFile);

% 3. Now you will have temporary unique topologies in:
% "/savedData/Topologies to Simualte".
% Next step is to simulate the dataset using solveDataSet.m
