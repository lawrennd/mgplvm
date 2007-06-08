function [mu, varsigma, var_f, mean_F] = mgplvmPosteriorMeanVar(model, X);

% MGPLVMPOSTERIORMEANVAR Mean and variances of the posterior at points given by X.
% FORMAT
% DESC returns the posterior mean and variance for a given set of
% points for the mixtures of GP-LVM model.
% ARG model : the model for which the posterior will be computed.
% ARG x : the input positions for which the posterior will be
% computed.
% RETURN mu : the mean of the posterior distribution.
% RETURN sigma : the variances of the posterior distributions.
%
% SEEALSO : gpPosteriorMeanVar, mgplvmCreate
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007

% MGPLVM
  
Xpi = mgplvmGatingProbabilities(model, X);
[mean_F, var_F, secMo_F] = mgplvmComponentPosteriorMeanVar(model, X);

% Work out means and variances
mu = zeros(size(X, 1), model.d);
secMo = zeros(size(X, 1), model.d);
for m = 1:model.M
  mu = mu + mean_F{m}.*repmat(Xpi(:, m), 1, model.d);
  secMo = secMo + secMo_F{m}.*repmat(Xpi(:, m), 1, model.d);
end

varsigma = secMo - mu.*mu;
