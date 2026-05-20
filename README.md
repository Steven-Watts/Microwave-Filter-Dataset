# Microwave-Filter-Dataset
This database is published to aid a user to access, expand and visualize  an accompanying dataset. Once the dataset is downloaded, the *Topologies* folder in the dataset must be moved to *savedData/Topologies* folder. Before running any script, please run the startup.m script to add all relevant functions to path and warn the user about potentially missing files. 

## Accessing the Dataset
This dataset can be accessed in MATLAB in two ways, both of which can be seen in *importDataset.m*. Method one uses a custom class to import the data, with a variety of name value arguments as import settings. Method 2 provides the simplest implementation, which can be used/copied and pasted for stand alone projects.

## Expanding the Dataset
### Requirements
This dataset is created by simulated a microstrip filter using [CST Studio Suite](https://www.3ds.com/products/simulia/cst-studio-suite). A variety of [MATLAB](https://www.mathworks.com/products/matlab.html) scripts and classes are used to create, manage and simulate new topologies. To easily interact with CST, the [TCST Interface](https://www.mathworks.com/matlabcentral/fileexchange/72228-tcstinterface-cst-studio-suite-to-matlab-interface) MATLAB file exchange must be downloaded and extracted to "TCST Interface/". Additionally, a variety of CST VBA macros are called from MATLAB, upon opening */CST Models/microwaveFilter.cst*, the auxiliary files will be automatically generated. The macros are duplicated in */CST Models/Macros*, however this is only used to track changes, not to be used in CST. 

### Generating new Topologies
To generate new topologies using the defined topology distributions, open the *expandDataset.m*, change the settings to fit your needs and run the script. The topologies generated using this script will be unique within their topology distribution.

### Simulating new Topologies
After generating new topologies, open the *solveDataset.m* and run the script. This script will scan through the new generated topologies and solve each one using CST. Finally, in the same script, you will see *DataHandler.processNewTopologies();* which performs all the post processing steps to extract the new simulations into the *savedData/Topologies* folder, opening this script reveals the following code snippet:
```MATLAB
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
```

## Optional Requirements to Visualize the Dataset
The *plots.m* MATLAB script can be used to access and visualize all the data found in the *savedData/Topologies*. To use the UMAP functionality, download the [UMAP library](https://www.mathworks.com/matlabcentral/fileexchange/71902-uniform-manifold-approximation-and-projection-umap) from the MATLAB file exchange and unzip it's contents to */UMAP/*.

## CST Troubleshooting
When opening the CST file, if any errors occur, please try and run the *iniFilter* macro, this should reset and re-initialize the project, after which you can run *updateGrid* macor so make sure the *.dxf* file updates the patch correctly.

## Python Support
A Python script is provided to access the dataset for users who do not have access to MATLAB, found in *Python/pythonImportExample*. No other functionality is supported.