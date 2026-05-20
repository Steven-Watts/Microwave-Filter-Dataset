% Add paths
addpath("savedData")
addpath("CST Models")

% Check if TCST file exists
if isfolder("TCSTInterface")
    addpath("TCSTInterface\")
    addpath("TCSTInterface\Functions\")
else
    warning(['Could not find TCSTInterface folder in base path. ' ...
        'This is not required but not all functionality will be present.' ...
        'Please download and extract file contents to "/TCSTInterface/" from: ' ...
        'https://www.mathworks.com/matlabcentral/fileexchange/72228-tcstinterface-cst-studio-suite-to-matlab-interface'])
end

% Check if UMAP file exists
if isfolder("UMAP")
    addpath("UMAP\umap\")
else
    warning(['Could not find UMAP folder in base path. ' ...
        'This is not required but not all functionality will be present.' ...
        'Please download and extract file contents to "/UMAP/" from: ' ...
        'https://www.mathworks.com/matlabcentral/fileexchange/71902-uniform-manifold-approximation-and-projection-umap'])
end

if isfolder("Colormaps\Colormaps (5)\Colormaps\")
    addpath("Colormaps\Colormaps (5)\Colormaps\")
end



