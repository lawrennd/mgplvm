function [model] = mgplvmInitGPLVM(Y,lbls,iters,display,options)


% mgplvmInitGPLVM Init the mixture with a GPLVM
%
%	Description:
%	

%	Copyright (c) 2007 Raquel Urtasun
% 	mgplvmInitGPLVM.m version 1.1

if nargin<4
    display = 0;
end


% Set up model
% options = fgplvmOptions('fitc');
options = fgplvmOptions('ftc');
options.optimiser = 'scg';
latentDim = 2;
d = size(Y, 2);

model = fgplvmCreate(latentDim, d, Y, options);

% Optimise the model.
display = 1;

model = fgplvmOptimise(model, display, iters);

% Save the results.
% capName = dataSetName;;
% capName(1) = upper(capName(1));
% save(['dem' capName num2str(experimentNo) '.mat'], 'model');

if (display)
    if exist('printDiagram') & printDiagram
      fgplvmPrintPlot(model, lbls, options.capName, options.experimentNo);
    end

    % compute the nearest neighbours errors in latent space.
    errors = fgplvmNearestNeighbour(model, lbls);
    errors

    % Load the results and display dynamically.
%     fgplvmResultsDynamic(dataSetName, experimentNo, 'vector')
end


