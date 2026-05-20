clear

files = dir("savedData\Topologies to Solve\");
files = files(contains({files(:).name},".mat")); % Remove navigators

% Launch The connection
CSTIF = CSTInterface('CST Models/microwaveFilter.cst');

for fileIdx = 1:length(files)
    fileName = files(fileIdx).name;
    disp("Processing " + fileName);
    load("savedData\Topologies to Solve\" + fileName, "dataset");

    for topIdx = 1:length(dataset)
        if isempty(dataset(topIdx).solution)
            CSTIF.deleteResults();
            CSTIF.updateCSTGrid(dataset(topIdx).topology);
            dataset(topIdx).solution = CSTIF.solveCST();

            if mod(topIdx,10) == 0
                % Save the solutions every so often.
                save("savedData\Topologies to Solve\" + fileName, "dataset");
                disp("Progress: " + topIdx + "/" + length(dataset));
            end
        end
    end

    save("savedData\Topologies to Solve\" + fileName, "dataset");
    disp("Saving " + fileName);

end

%% Finally, you need to post process the results into the "savedData/Topologies"
% Open the function below for more information.
DataHandler.processNewTopologies();