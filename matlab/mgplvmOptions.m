function options = mgplvmOptions;

% MGPLVMOPTIONS Return default options for mixtures of GP-LVM.
% FORMAT
% DESC returns the default options in a structure for a MGPLVM model.
% RETURN options : structure containing the default options for the
% given approximation type.
%
% SEEALSO : mgplvmCreate
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007

% MGPLVM



options.kern = {'rbf', 'bias', 'white'};
options.beta = 1e3;

% switch optimiser to the OPTIMI specified default.
options.optimiser = optimiDefaultOptimiser;

% How to initialise X.
options.initX = 'ppca';
options.numComps = 10;
options.activeThreshold = 0.001;
options.minActive = 1;

options.optimiseGating = true;
options.optimiseGatingCentres = true;
options.optimiseBeta = true;

options.optimiseInitBack = false;

% Should be one of 'hard' 'soft' 'supersoft' 
options.initClusters = 'soft'; 
