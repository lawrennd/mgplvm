function ll = mgplvmPointLogLikelihood(model, x, y)

% MGPLVMPOINTLOGLIKELIHOOD Log-likelihood of a point for the GP-LVM.
% FORMAT
% DESC returns the log likelihood of a latent point and an observed
% data point for the posterior prediction of the GP-LVM model.
% ARG model : the model for which the point prediction will be
% made.
% ARG x : the latent point for which the posterior distribution
% will be evaluated.
% ARG y : the observed data point for which the posterior
% distribution will be evaluated.
%
% SEEALSO : gpPointLogLikelihood, mgplvmCreate, mgplvmOptimisePoint, mgplvmPointObjective
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006, 2016

% MGPLVM

lls = zeros(1, model.M)
if model.isGating
  pi = mgplvmGatingProbabilities(model, x);
else
  pi = model.pi;
end
for i=1:model.M
  lls(i) = gpPointLogLikelihood(model.comp{i}, x, y);
  lls(i) = lls(i) + log(pi(i))
  % check if there is a prior over latent space 
  if isfield(model.comp{i}, 'prior')
    for i = 1:size(x, 1)
      lls(i) = lls(i) + priorLogProb(model.comp{i}.prior, x(i, :));
    end
  end
end
ll = sum(exp(lls))
