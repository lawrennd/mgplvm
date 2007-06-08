function [gX] = mgplvmGatingLogLikeGradient(model)

% MGPLVMCOMPUTEGATING Compute the gates of a MGPLVM model.
% FORMAT
% DESC returns the gradients with respect to X of the gating component of
% the likelihood.
% ARG model : the model for which the gradients care beinc computed.
% RETURN gX : the gradients of the gating terms with respect to X.
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007
%
% SEEALSO : modelCreate, mgplvmOptions

% MGPLVM

gX = zeros(model.N, model.q);
for m=1:model.M
  gX = gX + model.d*repmat(model.centres(m,:),model.N,1).*(repmat(model.expectation.s(:,m),1,model.q) - repmat(model.pi(:,m),1,model.q));   
end

