classdef Datastack
    %DATASTACK Summary of this class goes here
    %   Detailed explanation goes here

    properties
        trainingTop
        trainingSP
        trainingResonators

        testingTop
        testingSP
        testingResonators

        sParams
        topologies
        resonators
        labels
    end

    methods
        function ds = Datastack(sourcePath,args)

            arguments
                sourcePath {mustBeFolder}
                args.splitData {mustBeNumericOrLogical} = true
                args.validationSelectionType {mustBeMember(args.validationSelectionType,["FN","random","CN"])} = "FN"
                args.expandData{mustBeNumericOrLogical} = true;
                args.calculateResonance{mustBeNumericOrLogical} = true;
                args.keepLabels{mustBeNumericOrLogical} = false;
                args.topologyDistributions {mustBeMember(args.topologyDistributions, {'X','Rotated Noisy X','Rotated X','Slash','Rotated Ellipse','Rotated Slash','H','Y', 'Outliers'})} = ...
                    {'X','Rotated Noisy X','Rotated X','Slash','Rotated Ellipse','Rotated Slash','H','Y'};
            end

            TOP = [];
            SP = [];

            folderNames = dir(sourcePath);
            folderNames = folderNames(ismember({folderNames.name},args.topologyDistributions));

            for folderIdx = 1:length(folderNames)

                fileNames = dir(sourcePath + folderNames(folderIdx).name);
                fileNames = fileNames(contains({fileNames.name},'.mat'));
                fileNames= {fileNames.name};
                
                for fileIdx = 1:length(fileNames)
                    load(sourcePath +  folderNames(folderIdx).name + "/" + fileNames{fileIdx},'dataset');
    
                    sols = cat(3,dataset.solution);
    
                    if fileIdx == 1 && folderIdx == 1
                        TOP = cat(3,dataset.topology);
                        SP = cat(4,sols.S);
                        LABELS = repmat({folderNames(folderIdx).name},[size(SP,4),1]);
                    else
                        TOP = cat(3,TOP,cat(3,dataset.topology));
                        try 
                            SP = cat(4,SP,cat(4,sols.S));
                        catch e
                            e
                        end
                        LABELS = [LABELS; repmat({folderNames(folderIdx).name},[size(dataset,2),1])];
                    end
                end

            end

            if args.expandData
                [ds.sParams,ds.topologies] = Datastack.expandData(SP,TOP);
            else
                ds.sParams = SP;
                ds.topologies = TOP;
            end

            if args.calculateResonance
                ds.resonators = ds.calculateResonances();
            end

            if args.keepLabels
                ds.labels = LABELS;
            end

            if args.splitData
                [ds.trainingSP, ds.trainingTop, ds.testingSP, ds.testingTop, ds.trainingResonators, ds.testingResonators] = splitDataStack(ds,"validationSelectionType",args.validationSelectionType);
            end
            
        end

        function [trainingSP, trainingTop, testingSP, testingTop, trainingResonators, testingResonators] = splitDataStack(ds,args)

            arguments
                ds
                args.validationSelectionType = "FN"
            end

            if args.validationSelectionType == "FN"
                shuffleIdx = flip(Datastack.sortVectorsByMinSimilarity(squeeze(ds.sParams(1,1,:,:))));
            elseif args.validationSelectionType == "random"
                shuffleIdx = randperm(size(ds.sParams,4));
            elseif args.validationSelectionType == "CN"
                shuffleIdx = (Datastack.sortVectorsByMinSimilarity(squeeze(ds.sParams(1,1,:,:))));
            end

            SP = ds.sParams(:,:,:,shuffleIdx);
            TOP = double(reshape(ds.topologies(:,:,shuffleIdx),32,32,1,[]));

            trainingIdx = 1:floor(size(SP,4)*0.9);
            trainingSP = SP(:,:,:,trainingIdx);
            trainingTop = TOP(:,:,:,trainingIdx);

            testingIdx = (trainingIdx(end) + 1):size(SP,4);
            testingSP = SP(:,:,:,testingIdx);
            testingTop = TOP(:,:,:,testingIdx);

            if ~isempty(ds.resonators)
                trainingResonators = ds.resonators(trainingIdx);
                testingResonators = ds.resonators(testingIdx);
            else
                trainingResonators = [];
                testingResonators = [];
            end

        end

        function fig = plot(ds)
            S11 = abs(squeeze(ds.sParams(1,1,:,:)));
            [coeff] = pca(S11',"NumComponents",2);

            S11_train_PCA = abs(squeeze(ds.trainingSP(1,1,:,:)));
            S11_val_PCA = abs(squeeze(ds.testingSP(1,1,:,:)));

            % Project the training and validation data onto the PCA components
            S11_train_PCA = coeff' * S11_train_PCA;
            S11_val_PCA = coeff' * S11_val_PCA;

            % Create a scatter plot of the PCA results
            fig = figure;
            scatter(S11_train_PCA(1,:), S11_train_PCA(2,:), 'b', 'filled');
            hold on;
            scatter(S11_val_PCA(1,:), S11_val_PCA(2,:), 'r', 'filled');
            legend('Training Data', 'Validation Data');
            xlabel('PCA Component 1');
            ylabel('PCA Component 2');
            title('PCA of Training and Validation Data');

        end

        function [nearestResponse, nearestTopology, similarity] = findNearestNeighbour(ds,targetTopology)
            [similarity, similarityIdx] = min(sum(abs(ds.topologies - targetTopology),[1,2]));
            similarity = 1 - similarity;
            nearestResponse = ds.sParams(:,:,:,similarityIdx);
            nearestTopology = ds.topologies(:,:,similarityIdx);

        end

        function resonators = calculateResonances(ds)
           loss = squeeze(1 - abs(ds.sParams(1,1,:,:)).^2 - abs(ds.sParams(1,2,:,:)).^2);
           resonators = sum(loss > db2mag(-3),1) > 0;
        end
    
    end


    methods(Static)

        function sortedIndices = sortVectorsByMinSimilarity(vectors)
            % vectors: A matrix where each column is a vector (can contain complex numbers)
            %vectors = vectors';
            % Normalize the vectors (since cosine similarity depends on the angle)
            normalizedVectors = vectors ./ vecnorm(vectors, 2, 1);

            % Compute the similarity matrix (cosine similarity)
            similarityMatrix = normalizedVectors' * normalizedVectors;

            % Set diagonal to -Inf to ignore self-similarity
            n = size(similarityMatrix, 1);
            similarityMatrix(1:n+1:end) = -Inf;

            % Find the minimum similarity for each vector
            minSimilarities = min(abs(similarityMatrix), [], 2);

            % Sort the vectors based on their minimum similarity
            [~, sortedIndices] = sort(minSimilarities, 'ascend');
        end

        function [SP_Expanded, TOP_Expanded] = expandData(SP, TOP)

            % Get the number of 32x32 matrices
            n = size(TOP, 3);

            % Initialize the output array
            transposedArray = zeros(size(TOP));
            augmentedSP = zeros(size(SP));

            % Transpose each 32x32 matrix
            for ii = 1:n
                transposedArray(:, :, ii) = TOP(:, :, ii).';
                augmentedSP(1, 1, :, ii) = SP(2,2,:,ii);
                augmentedSP(1, 2, :, ii) = SP(2,1,:,ii);
                augmentedSP(2, 1, :, ii) = SP(1,2,:,ii);
                augmentedSP(2, 2, :, ii) = SP(1,1,:,ii);

            end

            SP_Expanded = cat(4,SP,augmentedSP);
            TOP_Expanded = cat(3,TOP,transposedArray);

        end

    end
end
