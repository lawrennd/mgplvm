% DEMOIL100MGPLVM1 Demonstrate mixtues of DPPCA on oil100 data, with back-constraints

% MGPLVM

% Fix seeds
clear;
close all;
randn('seed', 1e6);
rand('seed', 1e6);

dataSetName = 'oil100';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Optimisation iters
iters = 1000;


display = 1;

% Set up model
options = mgplvmOptions;
%/~
%options.back = 'kbr';
%options.backOptions = kbrOptions(Y);
%options.optimiseInitBack = false;
%~/
options.numComps = 100;
options.beta = (1/(0.5*sqrt(mean(var(Y))))).^2;
options.kern = {'translate', 'lin', 'bias'};
options.scale = 0.1;
latentDim = 2;
d = size(Y, 2);

display =1;

model = mgplvmCreate(latentDim, d, Y, options);

model = mgplvmOptimise(model, display, iters);

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


