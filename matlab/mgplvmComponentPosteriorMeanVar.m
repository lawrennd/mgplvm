function [mu, varsigma, secondMoment] = mgplvmComponentPosteriorMeanVar(model, X)
  
% MGPLVMCOMPONENTPOSTERIORMEANVAR Mean and variance under each component of the mixture model.
% FORMAT
% DESC computes the means and variances of each component of the mixture
% model.
% ARG model : the model for which the means and variances are to be
% computed.
% ARG X : the inputs for which the means and variances are to be
% computed.
% RETURN mu : the mean for each component (as a cell array).
% RETURN varsigma : the variance for each component (as a cell array).
%
% SEEALSO : mgplvmPosteriorMeanVar, mgplvmEstep
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007

% MGPLVM
  
% Work out component means and variances.
for m = 1:model.M
  X_active = model.X(find(model.activePoints(:, m)), :);
  Y_active = model.y(find(model.activePoints(:, m)), :);
  model.K{m} = kernCompute(model.kern{m}, X_active);
  diagK = kernDiagCompute(model.kern{m}, X);
  KX_star = kernCompute(model.kern{m}, X_active, X);
  model.B{m} = diag(model.beta*model.expectation.s(find(model.activePoints(:, m)), m));
  model.Binv{m} = diag(1./diag(model.B{m}));  
  Kinvk = pdinv(model.K{m} + model.Binv{m})*KX_star;
  mu{m} = Kinvk'*Y_active;

  if nargout > 1
    varsigma{m} = diagK - sum(KX_star.*Kinvk, 1)';
    if nargout > 2
      secondMoment{m} = repmat(varsigma{m}, 1, model.d) ...
          + mu{m}.*mu{m};
    end
  end
end
