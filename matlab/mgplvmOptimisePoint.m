function x = mgplvmOptimisePoint(model, x, y, display, iters)

% MGPLVMOPTIMISEPOINT Optimise the postion of a latent point.
% FORMAT
% DESC optimises the location of a single point in latent space
% given an initialisation and an observed data point. Note that it
% ignores any dynamics present in the model.
% ARG model : the model for which the point will be optimised.
% ARG x : the initialisation of the point in the latent space.
% ARG y : the observed data point for which the latent point is to
% be optimised.
% ARG display : whether or not to display the iterations of the
% optimisation (default: true)
% ARG iters : maximum number of iterations for the optimisation
% (default 2000).
% RETURN x : the optimised location in the latent space.
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006, 2016
%
% SEEALSO : mgplvmCreate, fgplvmOptimisePoint, mgplvmPointObjective, mgplvmPointGradient

% MGPLVM

if nargin < 5
  iters = 2000;
  if nargin < 4
    display = true;
  end
end

options = optOptions;
if display
  options(1) = 1;
  options(9) = 1;
end
options(14) = iters;


if isfield(model, 'optimiser')
  optim = str2func(model.optimiser);
else
  optim = str2func('scg');
end


if strcmp(func2str(optim), 'optimiMinimize')
  % Carl Rasmussen's minimize function 
  x = optim('mgplvmPointObjectiveGradient', x, options, model, y);
else
  % NETLAB style optimization.
  x = optim('mgplvmPointObjective', x,  options, ...
            'mgplvmPointGradient', model, y);
end
