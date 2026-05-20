classdef DataHandler
    properties
        topologyType = "X"
    end

    methods
        % Constructor
        function dh = DataHandler(topologyType)
            arguments
                topologyType {mustBeMember(topologyType, {'X','Rotated Noisy X','Rotated X','Slash','Rotated Ellipse','Rotated Slash','H','Y'})} = 'H';
            end

            dh.topologyType = topologyType;
        end

        function expandDataSet(dh, numberOfSimulations, numberOfSimulationsPerFile)
            arguments
                dh
                numberOfSimulations {mustBePositive} = 500;
                numberOfSimulationsPerFile {mustBePositive} = 500;
            end

            topDistribution = dh.createTopologyDistribution(dh.topologyType);

            % Load previous responses
            existingDataset = dh.loadDataset(dh.topologyType);

            % Create the dataset
            dataset = struct([]);
            fileName = "temp_" + string(dh.topologyType) + "_" + string(datetime('now','TimeZone','local','Format','d_MMM_y_HH_mm_ss'));
            disp("Creating: " + fullfile("savedData/Topologies to Solve/",fileName));

            saturated = false;

            for ii = 1:numberOfSimulations
                isNew = false;
                nTrials = 0;
                while ~isNew && ~saturated
                    topology = topDistribution.sample();
                    isNew = dh.checkNewTopology(dataset, topology) && ...
                        dh.checkNewTopology(existingDataset, topology);
                    nTrials = nTrials+1;
                    if nTrials > 10000
                        saturated = true;
                        disp("Saturated topology: " + dh.topologyType);
                        break;
                    end
                end

                if ~saturated
                    dataset(ii).topology = topology;
                    dataset(ii).solution = [];
                else
                    break;
                end
            end
            dataSet2Save = dataset;

            for ii = 1:ceil(length(dataset)/numberOfSimulationsPerFile)
                saveEndIdx = min(length(dataset),numberOfSimulationsPerFile);
                dataset = dataSet2Save(1:saveEndIdx);
                dataSet2Save = dataSet2Save((saveEndIdx + 1): end);
                save(fullfile("savedData/Topologies to Solve/",fileName + "_" + ii),"dataset");
                disp("Saved: " + fullfile("savedData/Topologies to Solve/",fileName, "_" + ii));
            end

        end

        function splitDatasetByOutliers(dh)

            dataset = dh.loadDataset(dh.topologyType);

            % Get S11
            sols = cat(3,dataset.solution);
            SP = cat(4,sols.S);
            S11 = squeeze(abs(SP(1,1,:,:)))';
            [reduction, ~, ~, ~] = run_umap(S11,'verbose','text','n_components',2,'metric','cosine');

            epsilon = 0.5;
            MinPts = 10;

            % Perform clustering
            idx = dbscan(reduction, epsilon, MinPts);

            figure
            gscatter(reduction(:,1),reduction(:,2),idx);

            f = uifigure();
            selection = uiconfirm(f,"Are you happy with the scan?",'');

            switch selection
                case 'OK'
                    datasetOutliers = dataset(idx>1);
                    dataset = dataset(idx<=1);

                case 'Cancel'
                    return
            end

            dh.deleteDataset('Outliers')
            dh.saveDataset(datasetOutliers,'Outliers')
            dh.deleteDataset(dh.topologyType)
            dh.saveDataset(dataset,dh.topologyType)

        end
    
        function removeDuplicatesBetweenDistributions(dh)

            combinations2Check = {...
                'Rotated X','X';...
                'Rotated Noisy X','X';...
                'Rotated Noisy X','Rotated X';...
                'Slash','X';...
                'Rotated Slash','X';...
                'Rotated Slash','Slash';...
                'Rotated Slash','Rotated X';...
                };

            primaryTD = '';
            secondaryTD = '';

            for ii = 1: length(combinations2Check)

                if ~strcmp(secondaryTD, combinations2Check{ii,1})
                    secondaryTD = combinations2Check{ii,1};
                    secondaryDs = dh.loadDataset(secondaryTD);
                end

                if ~strcmp(primaryTD, combinations2Check{ii,2})
                    primaryTD = combinations2Check{ii,2};
                    primaryDs = dh.loadDataset(primaryTD);
                end
    
                [secondaryDs, duplicatesFound] = dh.removeDuplicatesBetweenDataSets(primaryDs,secondaryDs);
    
                if duplicatesFound > 0
                    dh.deleteDataset(secondaryTD)
                    dh.saveDataset(secondaryDs,secondaryTD)
                end
            end

        end
    end

    methods(Static)

        function processNewTopologies()

            allFiles = dir("savedData\Topologies to Solve\");

            % Look at which files need to be processed
            for fileIdx = 1:length(allFiles)
                if contains(allFiles(fileIdx).name,".mat")
                    fileName = allFiles(fileIdx).name;
                    disp("Processing: " + fileName);

                    topDistName = DataHandler.processFileName(fileName);
                    disp("Looking at topology distribution: " + topDistName)

                    if ~isfolder("savedData\Topologies\" + topDistName)
                        disp('Folder does not exist. Creating Folder...')
                        mkdir("savedData\Topologies\" + topDistName)
                    end

                    % Load processed files
                    dataset = DataHandler.loadDataset(topDistName);

                    % Add file to process
                    dataset = DataHandler.appendDataset(dataset,fileName);

                    % Remove duplicates
                    dataset = DataHandler.removeDuplicates(dataset);

                    % Generate Image Names
                    dataset = DataHandler.generateImageNames(dataset, topDistName);

                    % Delete old data
                    DataHandler.deleteDataset(topDistName);

                    % Save new data
                    DataHandler.saveDataset(dataset, topDistName);

                end
            end

        end

        function topologyDistribution = processFileName(fileName)

            fileParts = split(fileName,'_');
            topologyDistribution = {};
            nameFound = false;
            partIdx = 2;

            while ~nameFound

                if fileParts{partIdx} ==  "temp"
                    partIdx = partIdx + 1;
                elseif ~isnan(str2double(fileParts{partIdx}))
                    nameFound = true;
                else
                    topologyDistribution{end+1} = fileParts{partIdx};
                    partIdx = partIdx + 1;
                end

            end
            topologyDistribution = join(topologyDistribution," ");
            topologyDistribution = topologyDistribution{1};

        end

        function dataset = loadDataset(topologyDistribution)
            dataset = [];
            allFiles = dir("savedData\Topologies\" + topologyDistribution + "\");

            for fileIdx = 1:length(allFiles)
                if contains(allFiles(fileIdx).name,".mat")
                    fileName = allFiles(fileIdx).name;
                    loadData = load("savedData\Topologies\" + topologyDistribution + "\" + fileName,"dataset");
                    dataset = horzcat(dataset, loadData.dataset);

                end
            end

        end

        function dataset = appendDataset(dataset,processFileName)

            loadData = load("savedData\Topologies to Solve\" + processFileName);

            for insertIdx = 1:length(loadData.dataset)
                dataset(end+1).imageName = "";
                dataset(end).topology = loadData.dataset(insertIdx).topology;

                if ~isempty(loadData.dataset(insertIdx).solution)
                    solution = rmfield(loadData.dataset(insertIdx).solution,"Info");
                    dataset(end).solution = solution;
                end
            end

        end

        function dataset = removeDuplicates(dataset)

            topoStrings = cellfun(@(x) mat2str(x), {dataset(:).topology}, 'UniformOutput', false);

            % 2. Find the unique indices based on these strings
            %    'stable' preserves the original order and keeps the first occurrence.
            [~, idx] = unique(topoStrings, 'stable');

            % 3. Filter your table using these indices
            dataset = dataset(idx);

        end

        function dataset = generateImageNames(dataset, topDistName)
            for ii = 1:length(dataset)
                dataset(ii).imageName = ii + "_" + string(topDistName) + ".png";
            end
        end

        function deleteDataset(topDistName)

            allFiles = dir("savedData\Topologies\" + string(topDistName));
            % Delete old files in the specified directory
            for fileIdx = 1:length(allFiles)
                if contains(allFiles(fileIdx).name, ".mat")
                    delete("savedData\Topologies\" + string(topDistName) + "\" + allFiles(fileIdx).name);
                end
            end

        end

        function saveDataset(dataset2save,topologyDistribution, args)
            arguments
            dataset2save
            topologyDistribution
            args.numberOfSimsPerFile = 500;
            end

            for saveIdx = 1:ceil(length(dataset2save)/args.numberOfSimsPerFile)
                dataset = dataset2save((1 + args.numberOfSimsPerFile * (saveIdx - 1)):min(args.numberOfSimsPerFile + args.numberOfSimsPerFile * (saveIdx - 1), length(dataset2save)));
                save("savedData\Topologies\" + string(topologyDistribution) + "\" + ...
                    saveIdx + "_" + string(topologyDistribution) + "_" + min(args.numberOfSimsPerFile, length(dataset2save) - args.numberOfSimsPerFile * (saveIdx - 1)),...
                    "dataset");
            end
        end

        function solveDataSet(args)
            arguments
                args.CstFilePath = 'CST Models\microwaveFilter.cst';
            end

            files = dir("savedData\Topologies to Solve\");
            files = files(3:end);

            CSTIF = CSTInterface(args.CstFilePath);

            for fileIdx = 1:length(files)
                fileName = files(fileIdx).name;
                disp("Processing " + fileName);
                load("savedData\Topologies to Solve\" + fileName, "dataset");

                for topIdx = 1:length(dataset)
                    if isempty(dataset(topIdx).solution)
                        tic
                        CSTIF.deleteResults();
                        CSTIF.updateCSTGrid(dataset(topIdx).topology);
                        dataset(topIdx).solution = CSTIF.solveCST();
                        toc
                    end
                end
            end

        end

        function [secondaryDs, duplicatesFound] = removeDuplicatesBetweenDataSets(primaryDs, secondaryDs)
        
            topoStringsP = cellfun(@(x) mat2str(x), {primaryDs(:).topology}, 'UniformOutput', false);
            topoStringsS = cellfun(@(x) mat2str(x), {secondaryDs(:).topology}, 'UniformOutput', false);

            % 2. Find the unique indices based on these strings
            %    'stable' preserves the original order and keeps the first occurrence.
            % [~, idx] = unique(topoStrings, 'stable');
            idx = ismember(topoStringsS, topoStringsP);

            % 3. Filter your table using these indices
            secondaryDs = secondaryDs(~idx);
            duplicatesFound = (sum(idx));
        
        end

        function isNew = checkNewTopology(dataSet, newTopology)
            % CHECKNEWTOPOLOGY Returns true if newTopology is NOT in dataSet.topology
            %
            % Inputs:
            %   dataSet      - Table containing a 'topology' column (cell array)
            %   newTopology  - The array to check against the dataset

            % 1. Compare the new topology against every entry in the column
            %    isequal handles different sizes and values automatically.
            if ~isempty(dataSet)
                isMatch = cellfun(@(x) isequal(x, newTopology), {dataSet.topology});

                % 2. If 'any' match is found, it is NOT new.
                %    We want true if it is new, so we negate the result.
                isNew = ~any(isMatch);
            else
                isNew = true;
            end
        end

        function topDistribution = createTopologyDistribution(topologyType)
            isNoise = false;

            switch topologyType

                case 'X'
                    fowardSlash  = @(scalar) TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices([0.5,0.5],scalar(1) * 0.7 +0.3 , scalar(1) *0.25 + 0.05 ,45));
                    backSlash    = @(scalar) TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices([0.5,0.5],scalar(1) * 0.7 +0.3 , scalar(1) *0.25 + 0.05 ,45 +90));
                    topologyDistributionFcn = @(x) backSlash(x(1)) & fowardSlash(x(1));

                case  'Rotated Noisy X'
                    fowardSlash  = @(scalar) TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices([0.5,0.5],scalar(1) * 0.7 +0.3 , scalar(1) *0.25 + 0.05 ,scalar(1) * 90));
                    backSlash    = @(scalar) TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices([0.5,0.5],scalar(1) * 0.7 +0.3 , scalar(1) *0.25 + 0.05 ,scalar(1) * 90 +90));
                    topologyDistributionFcn = @(x) double(backSlash(x) & fowardSlash(x));
                    isNoise = true;

                case 'Rotated X'
                    fowardSlash  = @(scalar) TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices([0.5,0.5],scalar(1) * 0.7 +0.3 , scalar(1) *0.25 + 0.05 ,scalar(1) * 90));
                    backSlash    = @(scalar) TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices([0.5,0.5],scalar(1) * 0.7 +0.3 , scalar(1) *0.25 + 0.05 ,scalar(1) * 90 +90));
                    topologyDistributionFcn = @(x) double(backSlash(x) & fowardSlash(x));

                case 'Slash'
                    topologyDistributionFcn  = @(scalar) TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices([0.5,0.5],scalar(1) * 0.7 +0.3 , scalar(1) *0.25 + 0.05 ,45));

                case 'Rotated Ellipse'
                    topologyDistributionFcn  = @(scalar) TopologyDistribution.discretizeGrid(TopologyDistribution.oval_vertices([0.5,0.5],scalar(1) *0.95 + 0.05,scalar(1) *0.95 + 0.05, scalar(1) .*45 ,100));

                case 'Rotated Slash'
                    topologyDistributionFcn  = @(scalar) TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices([0.5,0.5],scalar(1) * 0.7 +0.3 , scalar(1) *0.25 + 0.05 ,scalar(1) * 90));

                case 'H'
                    topologyDistributionFcn  = @(scalar) DataHandler.H_Grid(scalar);

                case 'Y'
                    topologyDistributionFcn  = @(scalar) DataHandler.Y_Grid(scalar);
            end

            topDistribution = TopologyDistribution(topologyDistributionFcn,"noise",isNoise);
        end

        function binaryGrid = H_Grid(scalar)

            leg1_length = scalar(1) * 0.85 + 0.1;
            leg2_length = scalar(1) * 0.85 + 0.1;
            leg3_length = scalar(1) * 0.5 + 0.1;

            leg1_width = scalar(1) * 0.25 + 0.1;
            leg2_width = scalar(1) * 0.25 + 0.1;
            leg3_width = scalar(1) * 0.25 + 0.1;

            leg1_cent = [0.5 + leg3_length/2 0.5];
            leg2_cent = [0.5 - leg3_length/2 0.5];
            leg3_cent = [0.5 0.5];

            leg1  = TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices(leg1_cent, leg1_length, leg1_width,90));
            leg2  = TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices(leg2_cent, leg2_length, leg2_width,90));
            leg3  = TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices(leg3_cent, leg3_length, leg3_width,0));

            binaryGrid = leg1 & leg2 & leg3;
        end

        function binaryGrid = Y_Grid(scalar)

            leg1_length = scalar(1) * 0.35 + 0.1;
            leg2_length = scalar(1) * 0.35 + 0.1;
            leg3_length = scalar(1) * 0.35 + 0.1;

            leg1_width = scalar(1) * 0.25 + 0.1;
            leg2_width = scalar(1) * 0.25 + 0.1;
            leg3_width = scalar(1) * 0.25 + 0.1;

            leg1_cent = [0.5 + leg1_length/2 0.5];
            leg2_cent = [0.5 0.5 + leg2_length/2];
            leg3_cent = [0.5 - leg3_length/2 0.5 - leg3_length/2];

            leg1  = TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices(leg1_cent, leg1_length, leg1_width,0));
            leg2  = TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices(leg2_cent, leg2_length, leg2_width,90));
            leg3  = TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices(leg3_cent, leg3_length, leg3_width,45));

            binaryGrid = ~imfill(~(leg1 & leg2 & leg3 & TopologyDistribution.discretizeGrid(TopologyDistribution.rectangle_vertices([0.5 0.5], 0.15, 0.15,0))),"holes");
        end

    end
end