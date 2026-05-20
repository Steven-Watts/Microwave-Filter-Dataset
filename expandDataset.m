clear

% 1. First choose from the following topology distributions:
% 'X','Rotated Noisy X','Rotated X','Slash','Rotated Ellipse','Rotated Slash','H','Y'
DH = DataHandler("X");

% 2. Then instantiate the data handler
numberOfSimulations = 1; % Any Number of topologies
numberOfSimulationsPerFile = 1; % Typically 500 to keep within .mat save size
DH.expandDataSet(numberOfSimulations,numberOfSimulationsPerFile);

% 3. Now you will have temporary unique topologies in:
% "/savedData/Topologies to Simualte".
% Next step is to simulate the dataset using solveDataSet.m
