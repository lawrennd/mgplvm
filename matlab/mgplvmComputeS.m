function [s, numer] = mgplvmComputeS(model)
  
% MGPLVMCOMPUTES Compute the expectation of the indicator matrix.
% FORMAT
% DESC computes the expectations of the component indicator matrix.
% ARG model : the model for which expectations are to be updated.
% RETURN s : the expectations of the indicator matrix.
% RETURN numer : the numerator from the computation of the expectation.
%
% SEEALSO : mgplvmCreate
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007
%

% MGPLVM
  
% Update expectations of S.
lognumer = zeros(model.N, model.M);
for m = 1:model.M
  y = (model.y - model.expectation.f{m});
  y2 = y.*y + repmat(model.expectation.varf{m}, 1, model.d);
  % Log of numerator of s.
  lognumer(:, m) = log(model.pi(:, m)) + (-.5*model.beta*sum(y2, 2));
end
% subtract maximum value from log numerator to keep numerically stable.
numer = exp(lognumer - repmat(max(lognumer, [], 2), 1, model.M)); 
% normalize to obtain the expectations.
s = numer./repmat(sum(numer, 2), 1, model.M); 

