% DEMOILMGPLVM2 Demonstrate mixtues of DPPCA on oil data, with back-constraints

% MGPLVM

% Fix seeds
clear;
close all;
randn('seed', 1e6);
rand('seed', 1e6);

dataSetName = 'oil';
experimentNo = 2;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

mIters = 1000;


display = 1;

% Set up model
options = mgplvmOptions;

options.back = 'mlp';
options.backOptions = mlpOptions;
options.numComps = 50;
options.beta = (1/(0.5*sqrt(mean(var(Y))))).^2;
options.kern = {'translate', 'lin', 'bias'};
options.activeThreshold= 0.01;
options.scale = .0625;
latentDim = 2;
d = size(Y, 2);

display = 1;
iters = 10;

model = mgplvmCreate(latentDim, d, Y, options);
model = mgplvmOptimise(model, display, mIters);

mgplvmWriteResult(model, dataSetName, experimentNo);
 
if exist('printDiagram') & printDiagram
   lvmPrintPlot(model, lbls, capName, experimentNo);
end
 
% Load the results and display dynamically.
lvmResultsDynamic('mgplvm', dataSetName, experimentNo, 'vector')

% compute the nearest neighbours errors in latent space.
errors = lvmNearestNeighbour(model, lbls);

disp(['Classification errors ',num2str(errors)]);

mgplvmPlotClusters(model);


