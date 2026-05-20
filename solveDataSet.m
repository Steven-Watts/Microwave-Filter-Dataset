clear

%% First solve the dataset, this will solve everything in the "savedData/Topologies To Solve" folder.
DataHandler.solveNewTopologies()

%% Finally, you need to post process the results into the "savedData/Topologies"
% Open the function below for more information.
DataHandler.processNewTopologies();