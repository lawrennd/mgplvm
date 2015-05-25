% DEMSTICKMGPLVM2 Model the stick man using an RBF kernel and dynamics.

% MGPLVM

close all;
clear;

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';
experimentNo = 2;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

eIters = 20;
mIters = 20;
outerIters = 20;

% Set up model
options = mgplvmOptions;

options.optimiseGating = false;

options.numComps = 5;
options.beta = (1/(0.5*sqrt(mean(var(Y))))).^2;
options.kern = {'rbf', 'bias'};
latentDim = 2;
d = size(Y, 2);

display = 1;


model = mgplvmCreate(latentDim, d, Y, options);


% Add dynamics model.
options = gpOptions('ftc');
options.kern = kernCreate(model.X, {'rbf', 'white'});
options.kern.comp{1}.inverseWidth = 0.2;
% This gives signal to noise of 0.1:1e-3 or 100:1.
options.kern.comp{1}.variance = 0.1^2;
options.kern.comp{2}.variance = 1e-3^2;
diff = 0;
learn = 0;
model = modelAddDynamics(model, 'gp', options);


model = mgplvmEMOptimise(model, display, outerIters, eIters, mIters);


% Save the results.
mgplvmWriteResult(model, dataSetName, experimentNo);

if exist('printDiagram') & printDiagram
  fgplvmPrintPlot(model, lbls, capName, experimentNo);
end

% load connectivity matrix
[void, connect] = mocapLoadTextData('run1');
% Load the results and display dynamically.
lvmResultsDynamic('mgplvm', dataSetName, experimentNo, 'stick', connect)
figure(1)
plotseries_old(model.X,[1],'b');


figure
mgplvmPlotClusters(model);




