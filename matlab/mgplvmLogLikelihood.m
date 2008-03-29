function ll = mgplvmLogLikelihood(model)
  
% MGPLVMLOGLIKELIHOOD Log likelihood of a mixtures of GP-LVM model.
% FORMAT
% DESC computes the model log likelihood.
% ARG model : the model for which the log likelihood is required.
% RETURN ll : the log likelihood of the model.
%
% SEEALSO : mgplvmCreate, modelLogLikelihood
%
% COPYRIGHT : Raquel Urtasun and Neil D. Lawrence, 2007, 2008

% MGPLVM
  
ll = 0;
for m=1:model.M
  ll = ll + gpLogLikelihood(model.comp{m});
end

%/~
% % compute the term from the component prior probs.
% llc = 0;
% for m = 1:model.M
%   ind = find(model.activePoints(:, m));
%   sm = model.expectation.s(ind, m);
%   logam = sm.*log(model.pi(ind, m)) + .5*(sm-1)*log(model.beta) - 0.5*log(sm);
%   llc = llc + model.d*sum(logam);
% end
% ll = ll + llc;
%~/
ll = ll + mgplvmLogPrefactors(model);
ll = ll + mgplvmLatentPriorLogLikelihood(model);
