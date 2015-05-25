% DEMOIL100MGPLVM3 Demonstrate mixtues of GP-LVM on oil100 data.



% Fix seeds
clear;
close all;
randn('seed', 1e6);
rand('seed', 1e6);

dataSetName = 'oil100';
experimentNo = 3;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Optimisation iters
eIters = 20;
mIters = 20;
outerIters = 20;

display = 1;

% Set up model
options = mgplvmOptions;

% Back constraints by RBF kernel regression.
options.back = 'kbr';
options.backOptions = kbrOptions(Y);
options.optimiseInitBack = false;
% Set signal to noise ratio in back constraint ...
options.backOptions.kern = kernCreate(Y, {'rbf', 'white'});
options.backOptions.kern.comp{1}.variance = 0.95*0.95;
options.backOptions.kern.comp{2}.variance = 0.05*0.05;

options.numComps = 40; % Truncation for the DP.
options.beta = (1/(0.5*sqrt(mean(var(Y))))).^2;
options.kern = {'rbf', 'bias'};
latentDim = 2;
d = size(Y, 2);
outer_iters = 20;
inner_iters = 10;

display =1;
iters = 10;

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

