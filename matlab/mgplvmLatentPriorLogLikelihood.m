function ll = mgplvmLatentPriorLogLikelihood(model)

% MGPLVMLATENTPRIORLOGLIKELIHOOD Compute likelihood of prior in latent space.
% FORMAT
% DESC computes the log likelihood of the prior in the latent space.
% ARG model : the model for which log likelihood is required.
% RETURN ll : the log likelihood of the latent points under the prior.
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007, 2008
%
% SEEALSO : mgplvmLogLikelihood, mgplvmCreate
  
% MGPLVM

% Regularisation of the centres
if model.optimiseCentres
  % Centres are regularised.
  ll = -.5*sum(sum(model.gating.centres.*model.gating.centres));
else
  ll = 0;
end
if ~model.isGating & ~model.compLabelConstr
  % Assumption is you now have joint prior over X and need to compute it.
  for m = 1:model.M
    ind = find(model.activePoints(:, m));
    sm = model.expectation.s(ind, m);
    x2 = model.X(ind, :)- repmat(model.gating.centres(m, :), ...
                                 length(ind), 1);
    x2 = x2.*x2;
    ll = ll -.5/model.gating.scale*sum(sum(repmat(model.expectation.s(ind, m), 1, model.q).*x2));
  end
end  

if isfield(model, 'dynamics') & ~isempty(model.dynamics)
  % A dynamics model is being used.
  ll = ll + modelLogLikelihood(model.dynamics);
elseif isfield(model, 'prior') &  ~isempty(model.prior)
  for i = 1:model.N
    ll = ll + priorLogProb(model.prior, model.X(i, :));
  end
end

