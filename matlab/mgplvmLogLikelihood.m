function ll = mgplvmLogLikelihood(model)
  
% MGPLVMLOGLIKELIHOOD Log likelihood of a mixtures of GP-LVM model.
% FORMAT
% DESC computes the model log likelihood.
% ARG model : the model for which the log likelihood is required.
% RETURN ll : the log likelihood of the model.
%
% SEEALSO : mgplvmCreate, modelLogLikelihood
%
% COPYRIGHT : Raquel Urtasun and Neil D. Lawrence, 2007

% MGPLVM
  
ll = 0;
for m = 1:model.M
  ind = find(model.activePoints(:, m));
  ll = ll + model.logdetC{m}*model.d;
  for i= 1:model.d
    ll = ll + model.y(ind, i)'*model.Cinv{m}*model.y(ind, i);
  end
end
ll = -ll *0.5;

% compute the term from the prior probs.
llc = 0;
for m = 1:model.M
  ind = find(model.activePoints(:, m));
  sm = model.expectation.s(ind, m);
  logam = sm.*log(model.pi(ind, m)) + .5*(sm-1)*log(model.beta) - 0.5*log(sm);
  llc = llc - model.d*sum(logam);
end
% Regularise the centres
llc = llc + .5*sum(sum(model.centres.*model.centres));
ll = ll - llc;


if isfield(model, 'dynamics') & ~isempty(model.dynamics)
  % A dynamics model is being used.
  ll = ll + modelLogLikelihood(model.dynamics);
elseif isfield(model, 'prior') &  ~isempty(model.prior)
  for i = 1:model.N
    ll = ll + priorLogProb(model.prior, model.X(i, :));
  end
end
