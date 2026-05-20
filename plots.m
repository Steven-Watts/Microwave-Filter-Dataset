clearvars -except dataStack S11_UMAP S11_TSNE S11_PCA
close all
% Load in the data
if ~exist('dataStack','var')
    dataStack = Datastack("savedData/Final Topologies/", "keepLabels", true,"expandData",false,"calculateResonance",false,"splitData",false);
end

% Set Figure options (Comment out if unwanted)
% Set default plot options
set(0, 'defaultAxesFontName', 'Georgia');
set(0, 'DefaultAxesFontSize', 20);
set(0, 'DefaultTextFontSize', 25);
set(0, 'DefaultLegendFontSize', 15);
set(0, 'DefaultAxesTitleFontSizeMultiplier', 2);
set(0, 'DefaultAxesLabelFontSizeMultiplier', 1.2);
set(0, 'DefaultLineLineWidth', 2);

% Image save location and toggle
saveImages = true;
imageSaveLocation = 'Images\';

if isfile(imageSaveLocation) && saveImages
    mkdir(imageSaveLocation);
end

%%
labels = dataStack.labels;

% Display counts of each unique label in 'labels'
[uniqueLabels, ~, idx] = unique(labels);
counts = accumarray(idx, 1);
fprintf('Label counts:\n');
for k = 1:numel(uniqueLabels)
    fprintf('  %s: %d\n', string(uniqueLabels(k)), counts(k));
end

%% Generate Single Blank S-parameter plot
SP = sparameters('Paper0\emptyS_Parameter.s2p');
S11 = 20*log10(abs(squeeze(SP.Parameters(1,1,:))));
S12 = 20*log10(abs(squeeze(SP.Parameters(1,2,:))));
freq = SP.Frequencies;

fig = figure('Units', 'normalized','InnerPosition',[0,0,0.5,1],'Position',[0,0,1,1]);
hold on
plot(freq,S11,DisplayName='S_{11}',LineWidth=2)
plot(freq,S12,DisplayName='S_{12}',LineWidth=2)
legend("Location","southeast")
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
xline(4.04e9,DisplayName='Selected Frequency') % Frequency
%title('Scattering parameters for a filter without an imposed topology')

if saveImages
    exportgraphics(fig,[imageSaveLocation 'blankSP.png'])
    close(fig)
end
%% Single Topology Plots
topologyNames = {'X','Slash','Rotated Ellipse','H','Y'};

for topIdx = 1:length(topologyNames)
    topologyName = topologyNames{topIdx};

    fig = create_1x1_Plot(topologyName,DataHandler.createTopologyDistribution(topologyName).distribution);
    exportgraphics(fig,[imageSaveLocation 'Singles _No_Annotation\' topologyName '.png']);
    close(fig)
end

%% Multi-topology plots
topologyNames = {'X','Rotated X','Rotated Noisy X','Slash','Rotated Slash','Rotated Ellipse','H','Y'};
fig = createEntireGridPlot(topologyNames);
exportgraphics(fig,[imageSaveLocation 'TopologyCombined.png']);
close(fig)

%%
% PCA calculation
S11 = abs(squeeze(dataStack.sParams(1,1,:,:)));
if ~exist('S11_PCA','var')
    [coeff] = pca(S11',"NumComponents",3);

    % Project the training and validation data onto the PCA components
    S11_PCA = coeff' * S11;
end
%% PCA Plots
ttl = 'S-Parameter Visulization using PCA';
figCombined = plotReducedComponentCombined(S11_PCA, dataStack.labels, ttl);
figSplit = plotReducedComponentSplit(S11_PCA, dataStack.labels, ttl);
figHeatmap = plotReducedComponentSplitHeatMap(S11_PCA, dataStack.labels, ttl);
figCombinedX = plotReducedComponentCombinedXs(S11_PCA, dataStack.labels, ttl);

if saveImages
    exportgraphics(figCombined,fullfile(imageSaveLocation, 'PCA_Combined.png'))
    close(figCombined)
    exportgraphics(figSplit,fullfile(imageSaveLocation, 'PCA_Split.png'))
    close(figSplit)
    exportgraphics(figHeatmap,fullfile(imageSaveLocation, 'PCA_Split_Heatmap.png'))
    close(figHeatmap)
    exportgraphics(figCombinedX,fullfile(imageSaveLocation, 'PCA_Combined_X.png'))
    close(figCombinedX)
end

%% UMAP calculation
S11 = abs(squeeze(dataStack.sParams(1,1,:,:)));
if ~exist('S11_UMAP','var')
    S11_UMAP = run_umap(S11','verbose','text','n_components',3);
    S11_UMAP = S11_UMAP';
end

%% UMAP Plots
ttl = 'S-Parameter Visulization using UMAP';
figCombined = plotReducedComponentCombined(S11_UMAP, dataStack.labels, ttl);
figSplit = plotReducedComponentSplit(S11_UMAP, dataStack.labels, ttl);
figHeatmap = plotReducedComponentSplitHeatMap(S11_UMAP, dataStack.labels, ttl);
figCombinedX = plotReducedComponentCombinedXs(S11_UMAP, dataStack.labels, ttl);

if saveImages
    exportgraphics(figCombined,fullfile(imageSaveLocation, 'UMAP_Combined.png'))
    close(figCombined)
    exportgraphics(figSplit,fullfile(imageSaveLocation, 'UMAP_Split.png'))
    close(figSplit)
    exportgraphics(figHeatmap,fullfile(imageSaveLocation, 'UMAP_Split_Heatmap.png'))
    close(figHeatmap)
    exportgraphics(figCombinedX,fullfile(imageSaveLocation, 'UMAP_Combined_X.png'))
    close(figCombinedX)
end

%% TSNE calculation
S11 = abs(squeeze(dataStack.sParams(1,1,:,:)));
if ~exist('S11_TSNE','var')
    S11_TSNE = tsne(S11', "NumDimensions", 3);
    S11_TSNE = S11_TSNE';
end

%% TSNE Plots
ttl = 'S-Parameter Visulization using t-SNE';
figCombined = plotReducedComponentCombined(S11_TSNE, dataStack.labels, ttl);
figSplit = plotReducedComponentSplit(S11_TSNE, dataStack.labels, ttl);
figHeatmap = plotReducedComponentSplitHeatMap(S11_TSNE, dataStack.labels, ttl);
figCombinedX = plotReducedComponentCombinedXs(S11_TSNE, dataStack.labels, ttl);

if saveImages
    exportgraphics(figCombined,fullfile(imageSaveLocation, 'TSNE_Combined.png'))
    close(figCombined)
    exportgraphics(figSplit,fullfile(imageSaveLocation, 'TSNE_Split.png'))
    close(figSplit)
    exportgraphics(figHeatmap,fullfile(imageSaveLocation, 'TSNE_Split_Heatmap.png'))
    close(figHeatmap)
    exportgraphics(figCombinedX,fullfile(imageSaveLocation, 'TSNE_Combined_X.png'))
    close(figCombinedX)
end

%%
plotAllScatteringParameterPlots(dataStack, imageSaveLocation, saveImages)

%% Functions
function fig = create_1x1_Plot(topName,gridFcn)

scalars = 0.5;

fig = figure('Units', 'normalized','InnerPosition',[0 0 0.7 1], 'Position',[0,0,0.7,1]);

for sclr = 1:length(scalars)
    scalar = scalars(sclr);
    binaryGrid = gridFcn(scalar);
    imagesc(binaryGrid);
    colormap(parula(2))
    %%title({topName , " Topology Distribution ","Sample with Annotations"})
    axis equal tight
    axis off
end
end

function fig = createEntireGridPlot(topologyNames)
%%
scalars = [0 0.5 1];
fig = figure('Units', 'pixels','Position',[0,0,1,1] .* 1920 .* 0.75);
t = tiledlayout(fig,length(topologyNames),9,"TileSpacing","loose");

columnNames = {'i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'vii', 'ix'};

%%title(t,{topName + " Topology ","Distribution Samples"}, 'FontSize', 40, 'FontWeight', 'bold', 'fontname', 'Georgia');

for topNameIdx = 1:length(topologyNames)
    topologyDist = DataHandler.createTopologyDistribution(topologyNames{topNameIdx});
    for sclr = 1:length(scalars)

        scalar = scalars(sclr);
        binaryGrid = topologyDist.sample("sampler",scalar);
        nt = nexttile();
        imagesc(binaryGrid);
        colormap(parula(2))
        %xlabel(['(' char(96 + sclr) ')'])
        axis equal tight
        % remove axis ticks and box/lines while keeping the xlabel visible
        set(nt, 'XTick', [], 'YTick', [], 'Box', 'off', 'XColor', 'none', 'YColor', 'none')

        if sclr == 1
            ylabel(['(' char(96 + topNameIdx) ')'])
            yl = get(nt, 'YLabel');
            set(yl,"Color",'k')
        end

        if topNameIdx == 8
            xlabel(['(' columnNames{sclr} ')'])
            xl = get(nt, 'XLabel');
            set(xl,"Color",'k')
        end
    end
    for sclr = 1:2*length(scalars)

        binaryGrid = topologyDist.sample();
        nt = nexttile();
        imagesc(binaryGrid);
        colormap(parula(2))
        %xlabel(['(' char(99 + sclr) ')']);
        axis equal tight
        % remove axis ticks and box/lines while keeping the xlabel visible
        set(nt, 'XTick', [], 'YTick', [], 'Box', 'off', 'XColor', 'none', 'YColor', 'none')
        % ensure the xlabel is still shown by creating a text object below the axis
        % xl = get(nt, 'XLabel');
        % set(xl,"Color",'k')

        if topNameIdx == 8
            xlabel(['(' columnNames{sclr+3} ')'])
            xl = get(nt, 'XLabel');
            set(xl,"Color",'k')
        end

    end
end
end

function fig =  plotReducedComponentCombined(S11_Reduced, lbls, ttl)

fig = figure('Units', 'normalized','InnerPosition',[0,0,0.5,1],'Position',[0,0,0.75,1]);
t = tiledlayout(fig,2,2,"TileSpacing","tight");

%title(t,ttl, 'FontSize', 40, 'FontWeight', 'bold', 'fontname', 'Georgia');

% Compress
lbls(strcmp(lbls,"X")) = {'X, Rotated X, Rotated Noisy X'};
lbls(strcmp(lbls,"Rotated X")) = {'X, Rotated X, Rotated Noisy X'};
lbls(strcmp(lbls,"Rotated Noisy X")) = {'X, Rotated X, Rotated Noisy X'};
lbls(strcmp(lbls,"Slash")) = {'Slash, Rotated Slash'};
lbls(strcmp(lbls,"Rotated Slash")) = {'Slash, Rotated Slash'};
lbls(strcmp(lbls,"H")) = {'Rotated Ellipse, H, Y'};
lbls(strcmp(lbls,"Y")) = {'Rotated Ellipse, H, Y'};
lbls(strcmp(lbls,"Rotated Ellipse")) = {'Rotated Ellipse, H, Y'};

uniqlbls = unique(lbls);
uniqlbls = uniqlbls([3,2,1]);
%uniqlbls = uniqlbls([7,5,3,6,4,2,1,8]);

% clrs = hsv(8);
clrs = ['r';'g';'b'];
% mkrs = ["o","+","square","diamond","^","v",">","<"];
mkrs = [".",".","."];

szs = [75,75,75,75,75,75,75,75]*0.2;
trsprcy = 1; % 1 -> Opaque and 0 -> Invisible

% match axis limits so all axes have identical lengths without changing scale or center
% compute per-axis data ranges
x = S11_Reduced(1,:);
y = S11_Reduced(2,:);
z = S11_Reduced(3,:);
xr = [min(x), max(x)];
yr = [min(y), max(y)];
zr = [min(z), max(z)];
% centers
xc = mean(xr); yc = mean(yr); zc = mean(zr);
% half-ranges
hx = diff(xr)/2; hy = diff(yr)/2; hz = diff(zr)/2;
% target half-range is the maximum of the three to make lengths identical
H = max([hx, hy, hz]);
% new limits keeping centers the same
newXLim = [xc - H, xc + H];
newYLim = [yc - H, yc + H];
newZLim = [zc - H, zc + H];

% 1 2
nexttile(1)
for ii = 1:length(uniqlbls)
    indxs = strcmp(lbls, uniqlbls{ii});
    scatter3(S11_Reduced(1, indxs), S11_Reduced(2, indxs), S11_Reduced(3, indxs), szs(ii), [clrs(ii,:)], mkrs(ii),"MarkerEdgeAlpha",trsprcy,"DisplayName",uniqlbls{ii},"LineWidth",2)
    hold on
end
view([0 90])
xlim(newXLim)
ylim(newYLim)
zlim(newZLim)

xlabel('1^{st} Component')
ylabel('2^{nd} Component')
zlabel('3^{nd} Component')
grid off

% 1 3
nexttile(2)
for ii = 1:length(uniqlbls)
    indxs = strcmp(lbls, uniqlbls{ii});
    scatter3(S11_Reduced(1, indxs), S11_Reduced(2, indxs), S11_Reduced(3, indxs), szs(ii), [clrs(ii,:)], mkrs(ii),"MarkerEdgeAlpha",trsprcy,"DisplayName",uniqlbls{ii},"LineWidth",2)
    hold on
end
view([0 0])
xlim(newXLim)
ylim(newYLim)
zlim(newZLim)

xlabel('1^{st} Component')
ylabel('2^{nd} Component')
zlabel('3^{nd} Component')
grid off

% 2 3
nexttile(3)
for ii = 1:length(uniqlbls)
    indxs = strcmp(lbls, uniqlbls{ii});
    % plot small, transparent markers for the data
    scatter3(S11_Reduced(1, indxs), S11_Reduced(2, indxs), S11_Reduced(3, indxs), ...
        szs(ii), clrs(ii,:), mkrs(ii), "MarkerEdgeAlpha", trsprcy)
    hold on
end
view([-270 0])
xlim(newXLim)
ylim(newYLim)
zlim(newZLim)

xlabel('1^{st} Component')
ylabel('2^{nd} Component')
zlabel('3^{nd} Component')
grid off

% Create opaque, slightly larger dummy plot objects for the legend
legHandles = gobjects(length(uniqlbls),1);
for ii = 1:length(uniqlbls)
    % plot invisible NaN points with desired legend appearance
    legHandles(ii) = scatter3(nan, nan, nan, szs(ii)*10, clrs(ii,:), 'o', 'filled',...
        "MarkerEdgeAlpha", 1, "DisplayName", uniqlbls{ii});
end
legend(legHandles, "Position", [0.5 0.25 0.35, 0.2])


end

function fig =  plotReducedComponentSplit(S11_Reduced, lbls, ttl)

fig = figure('Units', 'normalized','InnerPosition',[0,0,0.5,1],'Position',[0,0,1,1]);
tl = tiledlayout(fig,2,4);
% axis equal
% axis padded

uniqlbls = unique(lbls);
uniqlbls = uniqlbls([7,5,3,6,4,2,1,8]);
clrs = ['b';'b';'b';'b';'b';'b';'b';'b'];
mkrs = [".",".",".",".",".",".",".","."];

szs = [75,75,75,75,75,75,75,75]*0.2;
trsprcy = 1;

k = boundary(S11_Reduced(1,:)',S11_Reduced(2,:)');

for ii = 1:length(uniqlbls)
    nt = nexttile(tl,ii);
    indxs = strcmp(lbls, uniqlbls{ii});
    scatter(nt,S11_Reduced(1, indxs),S11_Reduced(2, indxs), szs(ii), clrs(ii,:), mkrs(ii), "LineWidth",1,"MarkerEdgeAlpha",trsprcy)
    hold on
    plot(nt,S11_Reduced(1, k),S11_Reduced(2, k),'black','LineWidth',2);


    % decrease subtitle font size dynamically relative to default
    st = subtitle(uniqlbls{ii});
    defaultFS = get(st, 'FontSize');
    if isempty(defaultFS) || ~isnumeric(defaultFS)
        defaultFS = 10; % fallback if unavailable
    end
    set(st, 'FontSize', max(1, defaultFS * 0.6));
    set(st, 'FontName', 'Georgia');
    axis equal
    xlim(nt,[min(S11_Reduced(1, k)), max(S11_Reduced(1,k))])
    ylim(nt,[min(S11_Reduced(2, k)), max(S11_Reduced(2,k))])

    if ii == 5
        % place ylabel using annotation to span the left side between tiles
        ylab = ylabel('2^{nd} Principal Component', Interpreter='tex');
        set(ylab, 'Units', 'normalized');
        yPos = ylab.Position;
        set(ylab, 'Position', [yPos(1), yPos(2) + 0.8, 0]);
    end

    if ii == 6
        % place ylabel using annotation to span the left side between tiles
        xlab = xlabel('1^{st} Principal Component', Interpreter='tex');
        set(xlab, 'Units', 'normalized');
        xPos = xlab.Position;
        set(xlab, 'Position', [xPos(1) + 0.7, xPos(2), 0]);
    end

end
end

function fig =  plotReducedComponentSplitHeatMap(S11_Reduced, lbls, ttl)

fig = figure('Units', 'normalized','InnerPosition',[0,0,0.5,1],'Position',[0,0,1,1]);
t = tiledlayout(fig,2,4);

uniqlbls = unique(lbls);
uniqlbls = uniqlbls([7,5,3,6,4,2,1,8]);

k = boundary(S11_Reduced(1,:)',S11_Reduced(2,:)');


% Determine global color limits across all classes by computing the 2D histograms
numBins = [50,50];
xLimits = [min(S11_Reduced(1, k)), max(S11_Reduced(1,k))];
yLimits = [min(S11_Reduced(2, k)), max(S11_Reduced(2,k))];

% Precompute bin edges
xEdges = linspace(xLimits(1), xLimits(2), numBins(1)+1);
yEdges = linspace(yLimits(1), yLimits(2), numBins(2)+1);

globalCounts = zeros(numBins);
for ii = 1:length(uniqlbls)
    indxs = strcmp(lbls, uniqlbls{ii});
    % accumulate counts into global histogram
    counts = histcounts2(S11_Reduced(1,indxs), S11_Reduced(2,indxs), xEdges, yEdges);
    globalCounts = globalCounts + counts;
end

% Determine color limits using globalCounts; use log scale so set positive min>0
% Find nonzero min for better visualization
nonzeroVals = globalCounts(globalCounts>0);
if isempty(nonzeroVals)
    clims = [0, max(globalCounts(:))];
else
    clims = [min(nonzeroVals), max(globalCounts(:))];
end

try
    % This is not built into MATLAB
    cm = plasma();
catch
    cm = parula();
end

for ii = 1:length(uniqlbls)
    nexttile(t ,ii)
    indxs = strcmp(lbls, uniqlbls{ii});
    % Use histogram2 with the same edges so that all tiles share same binning
    histogram2(S11_Reduced(1,indxs), S11_Reduced(2,indxs), xEdges, yEdges, ...
        'DisplayStyle','tile', ...
        'ShowEmptyBins','on', ...
        'EdgeColor','none');

    colormap(cm);
    set(gca, 'ColorScale', 'log');
    % Apply the same color limits to all subplots
    clim(clims);
    axis equal
    hold on
    plot(S11_Reduced(1, k),S11_Reduced(2, k),'white','LineWidth',2);
    xlim(xLimits)
    ylim(yLimits)

    % decrease subtitle font size dynamically relative to default
    st = subtitle(uniqlbls{ii});
    defaultFS = get(st, 'FontSize');
    if isempty(defaultFS) || ~isnumeric(defaultFS)
        defaultFS = 10; % fallback if unavailable
    end
    set(st, 'FontSize', max(1, defaultFS * 0.6));

    if ii == 5
        % place ylabel using annotation to span the left side between tiles
        ylab = ylabel('2^{nd} Principal Component', Interpreter='tex');
        set(ylab, 'Units', 'normalized');
        yPos = ylab.Position;
        set(ylab, 'Position', [yPos(1), yPos(2) + 0.8, 0]);
    end

    if ii == 6
        % place ylabel using annotation to span the left side between tiles
        xlab = xlabel('1^{st} Principal Component', Interpreter='tex');
        set(xlab, 'Units', 'normalized');
        xPos = xlab.Position;
        set(xlab, 'Position', [xPos(1) + 0.7, xPos(2), 0]);
    end

    if ii == 8
        colorbar("eastoutside","Position",[0.95,0.12,0.015,0.8])
        
    end
end
end

function fig =  plotReducedComponentCombinedXs(S11_Reduced, lbls, ttl)

fig = figure('Units', 'normalized','InnerPosition',[0,0,0.5,1],'Position',[0,0,0.6,1]);
t = tiledlayout(fig,2,2,"TileSpacing","tight");

%title(t,ttl, 'FontSize', 40, 'FontWeight', 'bold', 'fontname', 'Georgia');
%subtitle(t,'For X Topology Distribution Variants', 'FontSize', 20);

uniqlbls = unique(lbls);
uniqlbls = uniqlbls([7,5,3]);
clrs = ['r';'g';'b'];
mkrs = [".",".","."];
szs = [75,75,75]*0.5;
trsprcy = 1;

% 1 2
nexttile(1)
for ii = 1:length(uniqlbls)
    indxs = strcmp(lbls, uniqlbls{ii});
    scatter3(S11_Reduced(1, indxs), S11_Reduced(2, indxs), S11_Reduced(3, indxs), szs(ii), clrs(ii,:),mkrs(ii),"MarkerEdgeAlpha",trsprcy,"DisplayName",uniqlbls{ii},"LineWidth",2)
    hold on
end
view([0 90])
axis equal
xlabel('1^{st} Component')
ylabel('2^{nd} Component')
zlabel('3^{nd} Component')

% match axis limits so all axes have identical lengths without changing scale or center
% compute per-axis data ranges
x = S11_Reduced(1,:);
y = S11_Reduced(2,:);
z = S11_Reduced(3,:);
xr = [min(x), max(x)];
yr = [min(y), max(y)];
zr = [min(z), max(z)];
% centers
xc = mean(xr); yc = mean(yr); zc = mean(zr);
% half-ranges
hx = diff(xr)/2; hy = diff(yr)/2; hz = diff(zr)/2;
% target half-range is the maximum of the three to make lengths identical
H = max([hx, hy, hz]);
% new limits keeping centers the same
newXLim = [xc - H, xc + H];
newYLim = [yc - H, yc + H];
newZLim = [zc - H, zc + H];

xlim(newXLim)
ylim(newYLim)
zlim(newZLim)

grid off

% 1 3
nexttile(2)
for ii = 1:length(uniqlbls)
    indxs = strcmp(lbls, uniqlbls{ii});
    scatter3(S11_Reduced(1, indxs), S11_Reduced(2, indxs), S11_Reduced(3, indxs), szs(ii), clrs(ii,:),mkrs(ii),"MarkerEdgeAlpha",trsprcy,"DisplayName",uniqlbls{ii},"LineWidth",4)
    hold on
end
view([0 0])
axis equal
xlabel('1^{st} Component')
ylabel('2^{nd} Component')
zlabel('3^{nd} Component')

% apply identical-size limits computed above
xlim(newXLim)
ylim(newYLim)
zlim(newZLim)

grid off

% 2 3
nexttile(3)
for ii = 1:length(uniqlbls)
    indxs = strcmp(lbls, uniqlbls{ii});
    scatter3(S11_Reduced(1, indxs), S11_Reduced(2, indxs), S11_Reduced(3, indxs), szs(ii), clrs(ii,:),mkrs(ii),"MarkerEdgeAlpha",trsprcy,"DisplayName",uniqlbls{ii},"LineWidth",8)
    hold on
end
view([-270 0])
axis equal
xlabel('1^{st} Component')
ylabel('2^{nd} Component')
zlabel('3^{nd} Component')

% apply identical-size limits computed above
xlim(newXLim)
ylim(newYLim)
zlim(newZLim)

grid off

% Create opaque, slightly larger dummy plot objects for the legend
legHandles = gobjects(length(uniqlbls),1);
for ii = 1:length(uniqlbls)
    % plot invisible NaN points with desired legend appearance
    legHandles(ii) = scatter3(nan, nan, nan, szs(ii)*10, clrs(ii,:), 'o', 'filled',...
        "MarkerEdgeAlpha", 1, "DisplayName", uniqlbls{ii});
end
legend(legHandles, "Position", [0.5 0.25 0.35, 0.2])
end

function plotAllScatteringParameterPlots(dataStack, imageSaveLocation, saveImages)

S11 = abs(squeeze(dataStack.sParams(1,1,:,:)));
freq = linspace(1,10,5001);
freq = freq(1:5:end);

transparency = 1;
lineWidth = 0.05;

uniqlbls = unique(dataStack.labels);
uniqlbls = uniqlbls([7,5,3,6,4,2,1,8]);
clrs = ['b';'b';'b';'b';'b';'b';'b';'b'];

% SP Split
fig = figure('Units', 'normalized','InnerPosition',[0,0,0.5,1],'Position',[0,0,1,1]);
t = tiledlayout(fig,4,2);

for ii = 1:length(uniqlbls)
    nexttile(t,ii)
    indxs = strcmp(dataStack.labels, uniqlbls{ii});
    plot(freq, mag2db(S11(1:5:end,indxs)),"Color", clrs(ii), "LineWidth",lineWidth)
    hold on

    % decrease subtitle font size dynamically relative to default
    st = subtitle(uniqlbls{ii});
    defaultFS = get(st, 'FontSize');
    if isempty(defaultFS) || ~isnumeric(defaultFS)
        defaultFS = 10; % fallback if unavailable
    end
    set(st, 'FontSize', max(1, defaultFS * 0.6));

    ylim([-75 0])
    xlim([1 10])

    if ii == 5
        % place ylabel using annotation to span the left side between tiles
        ylab = ylabel('|S_{11} (dB)|', Interpreter='tex');
        set(ylab, 'Units', 'normalized');
        yPos = ylab.Position;
        set(ylab, 'Position', [yPos(1), yPos(2) + 0.8, 0]);
    end

    if ii == 7
        % place ylabel using annotation to span the left side between tiles
        xlab = xlabel('Frequency (GHz)', Interpreter='tex');
        set(xlab, 'Units', 'normalized');
        xPos = xlab.Position;
        set(xlab, 'Position', [xPos(1) + 0.6, xPos(2), 0]);
    end

end

if saveImages
    exportgraphics(fig,fullfile(imageSaveLocation, 'SP Split.png'))
    close(fig)
end

end
