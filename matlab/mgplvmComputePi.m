function pim = mgplvmComputePi(model)
  
% MGPLVMCOMPUTEPI Compute the expectations of the component priors.
% FORMAT
% DESC computes the expectations of the component indicator matrix.
% ARG model : the model for which expectations are to be updated.
% RETURN pi : the expectations of the indicator matrix.
%
% SEEALSO : mgplvmCreate
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007
%

% MGPLVM
  
% Update expectations of pi.
if model.isInfinite
  % First compute expectations of v.
  sumS = sum(model.expectation.s);
  a0bar = model.a0 + sumS; % Posterior value for a_0.
  a1bar = model.a1 + cumsum(sumS); % Posterior value for a_1.
  model.v = a0bar./(a0bar+a1bar);
  tmp = cumprod(1-model.v);
  pim = model.v;
  pim(2:end) = pim(2:end).*tmp(1:end-1);
elseif model.isGating
  pim = mgplvmGatingProbabilities(model);
else
  pim = (sum(model.expectation.s, 1)+1)/(model.N+model.M);
end

