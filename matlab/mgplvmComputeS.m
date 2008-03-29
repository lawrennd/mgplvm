function [s, numer] = mgplvmComputeS(model, X)
  
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

if ~model.compLabelConstr
  % Update expectations of S.
  if nargin>1
    % If an X is provided ignore model and compute on that!! A bit strange.
    lognumer = zeros(size(X, 1), model.M);
    for m=1:model.M
      x = X-repmat(model.gating.centres(m, :), size(X, 1), 1);
      x2 = sum(x.*x, 2);
      % Log of numerator of s.
      lognumer(:, m) = log(model.pi(m)) - .5*x2; 
    end
  else
    lognumer = zeros(model.N, model.M);
    for m = 1:model.M
      y = (model.y - model.expectation.f{m});
      y2 = y.*y + repmat(model.expectation.varf{m}, 1, model.d);
      if model.isGating
        % Log of numerator of s.
        lognumer(:, m) = log(model.pi(:, m)) + (-.5*model.beta*sum(y2, 2));
      else
        % For infinite model need prior over X (replaces gating network).
        x = model.X-repmat(model.gating.centres(m, :), model.N, 1);
        x2 = sum(x.*x, 2);
        % Log of numerator of s.
        lognumer(:, m) = log(model.pi(m)) ...
            + (-.5*model.beta*sum(y2, 2)) ...
            - .5*x2; % term from prior over latent points.
      end
    end
  end
  % subtract maximum value from log numerator to keep numerically stable.
  numer = exp(lognumer - repmat(max(lognumer, [], 2), 1, model.M)); 
  % normalize to obtain the expectations.
  s = sparse(numer./repmat(sum(numer, 2), 1, model.M)); 
else
  if nargin>1
    [s, numer] = mgplvmGatingProbabilities(model, X);
  else
    [s, numer] = mgplvmGatingProbabilities(model);
  end
  s = sparse(s);
end