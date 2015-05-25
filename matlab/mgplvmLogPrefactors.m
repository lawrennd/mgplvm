function logc = mgplvmLogPrefactors(model)

% MGPLVMLOGPREFACTOS Compute log of prefactor terms.
% FORMAT
% DESC computes the prefactor terms in the log likelihood. 
% ARG model : the model for which log likelihood is required.
% RETURN logc : the log of the prefactor terms.
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2008
%
% SEEALSO : mgplvmLogLikelihood, mgplvmCreate
  
% MGPLVM
logc = 0;
for m=1:model.M
  ind = find(model.activePoints(:, m));
  sm = model.expectation.s(ind, m);
  % This comes from log c_nm
  if model.isGating
    logam = sm.*log(model.pi(ind, m));
  else
    logam = sm.*log(model.pi(m));
  end
  logam = logam + model.d*0.5*(1-sm)*log(2*pi) + model.d*0.5*(sm-1)*log(model.beta) - model.d*0.5*log(sm);
  logc = logc + sum(logam);
end
logc = logc - sum(sum(xlogy(model.expectation.s)));
