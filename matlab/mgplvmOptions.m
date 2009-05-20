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

% Is it a Dirichelet process prior on mixtures? Default true.
options.isInfinite = true;
options.a0=1;
options.a1=5;

% How many components in the truncation (dirichlet process prior) or how
% many components in the mixture (gating networks and standard prior).
options.numComps = 100;

% How large should the posterior component label be for the component to be considered active.
options.activeThreshold = 0.001;

% Scale of the gaussian components in the mixtures over latent space.
options.scale = 0.1;

% Minimum number of active points for each component.
options.minActive = 5;

% Component Labels Constraint, are the posterior expectations of the
% component labels constrained to be two dimensional?
options.compLabelConstr = true;

% Gating networks were used in our earliest experiments. 
options.isGating = false;

% Set to true to optimise centres as part of the latent space optimisation.
options.optimiseCentres = true;

% Set to true to optimise centres in the 'e-step' portion.
options.estepCentres = true;

options.optimiseBeta = true;
options.optimiseInitBack = false;



% Should be one of 'hard' 'soft' 'supersoft' 
options.initClusters = 'soft'; 
