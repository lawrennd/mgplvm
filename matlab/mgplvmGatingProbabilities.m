function Xpi = mgplvmGatingProbabilities(model, X)

% MGPLVMGATINGPROBABILITIES Compute the gating probabilities for the
% mixture of GP-LVMs.
% FORMAT
% DESC computes the probabilities associated with the gating network for
% the mixture of GP-LVMs.
% ARG model : the model for which the gating probabilities need
% computing.
% ARG X : the input locations where the gating probabilities are to be
% computed.
%
% SEEALSO : mgplvmCreate
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007

% MGPLVM

if nargin < 2
  % Assume computation is for model.X
  X = model.X;
end
% WOrk out gating probabilities
lognumer = -0.5*dist2(X, model.centres);
lognumer = lognumer - repmat(max(lognumer, [], 2), 1, model.M);
numer = exp(lognumer);
denom = sum(numer, 2);
Xpi = numer./(repmat(denom, 1, model.M));
