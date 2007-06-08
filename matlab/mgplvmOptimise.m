function model = mgplvmOptimise(model, display, iters);

% MGPLVMOPTIMISE Optimise the mixtures of GP-LVM.
% FORMAT
% DESC takes a given GP-LVM model structure and optimises with
% respect to kernel parameters and latent positions and gating centres. 
% ARG model : the model to be optimised.
% ARG display : flag dictating whether or not to display
% optimisation progress (set to greater than zero) (default value 1). 
% ARG iters : number of iterations to run the optimiser
% for (default value 2000).
% RETURN model : the optimised model.
%
% SEEALSO : mgplvmCreate, mgplvmLogLikelihood,
% mgplvmLogLikeGradients, mgplvmObjective, mgplvmGradient
% 
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007

% MGPLVM

if nargin < 3
  iters = 2000;
  if nargin < 2
    display = 1;
  end
end


params = mgplvmExtractParam(model);

options = optOptions;
if display
  options(1) = 1;
  if length(params) <= 100
    options(9) = 1;
  end
end
options(14) = iters;

if isfield(model, 'optimiser')
  optim = str2func(model.optimiser);
else
  optim = str2func('scg');
end

if strcmp(func2str(optim), 'optimiMinimize')
  % Carl Rasmussen's minimize function 
  params = optim('mgplvmObjectiveGradient', params, options, model);
else
  % NETLAB style optimization.
  params = optim('mgplvmObjective', params,  options, ...
                 'mgplvmGradient', model);
end

model = mgplvmExpandParam(model, params);
