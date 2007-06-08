function model = mgplvmEstep(model, display, iters)

% MGPLVMESTEP Run the variational E step for the MGPLVM model.
% FORMAT
% DESC computes the expectations required in the E step of the mixtures
% of GP-LVM model.
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
  [model.expectation.s, numer] = mgplvmComputeS(model);
  model.activePoints = model.expectation.s>model.activeThreshold;
  
  % Check if some components have disappeared.
  dimToKeep = find(sum(model.expectation.s, 1)>1e-3); 
  if length(dimToKeep)<model.M 
    model.M = length(dimToKeep);
    numer = numer(:, dimToKeep);
    model.expectation.s = numer./repmat(sum(numer, 2), 1, ...
                                        model.M); % renormalize to sum to 1
    model.kern = model.kern(dimToKeep);
    model.B = model.B(dimToKeep);
    model.Binv = model.Binv(dimToKeep);
    model.K = model.K(dimToKeep);
    model.centres = model.centres(dimToKeep,:);
    for m = 1:model.M
      model.kern{m}.centre = model.centres(m, :);
    end
    model.pi = model.pi(:,dimToKeep)./repmat(sum(model.pi, 2), 1, ...
                                             model.M);
  end
  
  % Force kernel updates.
  param = mgplvmExtractParam(model);
  model = mgplvmExpandParam(model, param);

  
  % Make sure all clusters have at least model.minActive active points.
  for m = 1:model.M
    if (sum(model.activePoints(:, m))<model.minActive)
      [void, indMax] = sort(model.expectation.s(:, m), 1);
      model.activePoints(indMax(end:-1:end-model.minActive+1), m) = 1;
    end
  end
  
  % Update expectations of F.
  [model.expectation.f, model.expectation.varf] = mgplvmComponentPosteriorMeanVar(model, model.X);
end
