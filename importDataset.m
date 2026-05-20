clear

% Option 1: Use the built in Datastack class using saome helpful name value
% arguments:
dataStack = Datastack("savedData/Topologies/", "keepLabels", true,"expandData",false,"calculateResonance",false,"splitData",false);
%%
% Option 2: If you would perfer to just copy and paste the code:
clear
sourcePath = "savedData/Topologies/";
folderNames = dir(sourcePath);

% These will be loaded from all Mat files found in the source paths sub
% folders
topologies = [];
solutions = [];
labels = [];

for folderIdx = 1:length(folderNames)

    fileNames = dir(sourcePath + folderNames(folderIdx).name);
    fileNames = fileNames(contains({fileNames.name},'.mat'));
    fileNames= {fileNames.name};

    for fileIdx = 1:length(fileNames)
        load(sourcePath +  folderNames(folderIdx).name + "/" + fileNames{fileIdx},'dataset');

        sols = cat(3,dataset.solution);

        if fileIdx == 1 && folderIdx == 1
            topologies = cat(3,dataset.topology);
            solutions = cat(4,sols.S);
            labels = repmat({folderNames(folderIdx).name},[size(solutions,4),1]);
        else
            topologies = cat(3,topologies,cat(3,dataset.topology));
            solutions = cat(4,solutions,cat(4,sols.S));
            labels = [labels; repmat({folderNames(folderIdx).name},[size(dataset,2),1])];
        end
    end

end
