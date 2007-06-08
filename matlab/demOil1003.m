% DEMOIL1003 Demonstrate mixtues of GP-LVM on oil100 data.

% MGPLVM

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
eIters = 10;
mIters = 50;
outerIters = 20;

display = 1;

% Set up model
options = mgplvmOptions;

% Back constraints by RBF kernel regression.
options.back = 'kbr';
options.backOptions = kbrOptions(Y);
% Set signal to noise ratio in back constraint ...
options.backOptions.kern = kernCreate(Y, {'rbf', 'white'});
options.backOptions.kern.comp{1}.variance = 0.95*0.9;
options.backOptions.kern.comp{2}.variance = 0.05*0.05;

options.numComps = 20;
options.beta = 10000/mean(var(Y));
options.kern = {'rbf', 'bias'};
latentDim = 2;
d = size(Y, 2);
outer_iters = 20;
inner_iters = 10;

display =1;
iters = 10;

model = mgplvmCreate(latentDim, d, Y, options);
model = mgplvmEMOptimise(model, display, outerIters, eIters, mIters);

capName = dataSetName;;
capName(1) = upper(capName(1));
save(['dem' capName num2str(experimentNo) '.mat'], 'model');
 
if exist('printDiagram') & printDiagram
   fgplvmPrintPlot(model, lbls, capName, experimentNo);
end
 
% Load the results and display dynamically.
fgplvmResultsDynamic(dataSetName, experimentNo, 'vector')

% compute the nearest neighbours errors in latent space.
errors = fgplvmNearestNeighbour(model, lbls);

disp(['Classification errors ',num2str(errors)]);


