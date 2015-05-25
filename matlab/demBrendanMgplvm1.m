% DEMBRENDANMGPLVM1 Model the face data with a 2-D RBF GPLVM.

% MGPLVM

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

display = 0;

dataSetName = 'brendan';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);
Y = Y(1:100, :);

eIters = 20;
mIters = 20;
outerIters = 20;

% Set up model
options = mgplvmOptions;

options.optimiseGating = false;

options.numComps = 5;
options.beta = (1/(0.5*sqrt(mean(var(Y))))).^2;
options.kern = {'translate', 'lin', 'bias'};
latentDim = 2;
d = size(Y, 2);

display =1;


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

