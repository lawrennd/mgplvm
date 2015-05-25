% DEMVOWELS90MGPLVM1 Demonstrate mixtues of DPPCA on vowels90 data, with back-constraints

% MGPLVM

% Fix seeds
clear;
close all;
randn('seed', 1e6);
rand('seed', 1e6);

dataSetName = 'vowels90';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Optimisation iters
eIters = 20;
mIters = 20;
outerIters = 20;


display = 1;

% Set up model
options = mgplvmOptions;

options.back = 'mlp';
options.backOptions = mlpOptions;
options.optimiseInitBack = false;

options.numComps = 10;
options.beta = (1/(0.5*sqrt(mean(var(Y))))).^2;
options.kern = {'translate', 'lin', 'bias'};
latentDim = 2;
d = size(Y, 2);

display =1;

model = mgplvmCreate(latentDim, d, Y, options);

model = mgplvmEMOptimise(model, display, outerIters, eIters, mIters);

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

