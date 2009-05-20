function model = mgplvmEstep(model, display, iters)

% MGPLVMESTEP Run the variational E step for the MGPLVM model.
% FORMAT
% DESC computes the expectations required in the E step of the mixtures
% of GP-LVM model. Strictly speaking it isn't a pure E step as some of
% the parameters are also maximised here.
% ARG model : the model for which the E step is required.
% ARG display : the display level during optimisation (default 1).
% ARG iters : the number of iterations to perform within the E-step
% (default 10).
%
% SEEALSO : mgplvmOptimise, mgplvmEMOptimise, mgplvmCreate
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007

% MGPLVM

[model.expectation.f, model.expectation.varf] = mgplvmComponentPosteriorMeanVar(model, model.X);


if nargin < 3
  iters = 10;
  if nargin < 2
    display = 1;
  end
end

for iter = 1:iters
  if display
    fprintf('Estep iteration %d\n', iter)
  end
  
  % Update S.
  model = mgplvmUpdateS(model);
  %/~
  % Check if some components have disappeared.
%   dimToKeep = find(sum(model.expectation.s, 1)>1e-3); 
%   if length(dimToKeep)<model.M 
%     model.M = length(dimToKeep);
%     numer = numer(:, dimToKeep);
%     model.expectation.s = sparse(numer./repmat(sum(numer, 2), 1, ...
%                                         model.M)); % renormalize to sum to 1
%     model.comp = model.comp(dimToKeep);
%     %
%     %     model.B = model.B(dimToKeep);
%     %     model.Binv = model.Binv(dimToKeep);
%     %     model.K = model.K(dimToKeep);
%     %
%     model.gating.centres = model.gating.centres(dimToKeep,:);
%     for m = 1:model.M
%       model.comp{m}.kern.centre = model.gating.centres(m, :);
%     end
%     model.pi = model.pi(:,dimToKeep)./repmat(sum(model.pi, 2), 1, ...
%                                              model.M);
%   end
  %~/
  if ~model.optimiseCentres & model.estepCentres
    for m=1:model.M
      if sum(model.expectation.s(:, m))<=model.minActive*model.activeThreshold
        %/~
        % Throw unused centres back in randomly.
        %        model.gating.centres(m, :) = randn(1, model.q);
        %~/
        % Throw unused centres back on random latent position.
        model.gating.centres(m, :) = model.X(ceil(rand(1)*model.N), :);
        
      else
        model.gating.centres(m, :) =  full(sum(repmat(model.expectation.s(:, ...
                                                          m), 1, ...
                                                      model.q).*model.X)/sum(model.expectation.s(:, m)));
      end
    end
  end
  
  % Force kernel updates.
  param = mgplvmExtractParam(model);
  model = mgplvmExpandParam(model, param);
  
  
  
  % Update expectations of F.
  [model.expectation.f, model.expectation.varf] = mgplvmComponentPosteriorMeanVar(model, model.X);
end
