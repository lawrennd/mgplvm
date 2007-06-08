function model = mgplvmExpandParam(model, params)

% MGPLVMEXPANDPARAM Expand a parameter vector into a MGPLVM model.
% FORMAT
% DESC takes an MGPLVM structure and a vector of parameters, and
% fills the structure with the given parameters. Also performs any
% necessary precomputation for likelihood and gradient
% computations, so can be computationally intensive to call.
% ARG model : the MGPLVM structure to put the parameters in.
% ARG params : parameter vector containing the parameters to put in
% the MGPLVM structure.
% 
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007
% 
% SEEALSO : mgplvmCreate, mgplvmExtractParam, modelExpandParam

% MGPLVM

%  model.activePoints = expectation.s>1e-4;

startVal = 1;

if isfield(model, 'back') & ~isempty(model.back)
  endVal = model.back.numParams;
  model.back = modelExpandParam(model.back, params(startVal:endVal));
  model.X = modelOut(model.back, model.y);
else
  endVal = model.N*model.q;
  model.X = reshape(params(startVal:endVal), model.N, model.q);
end


if model.optimiseGating & model.optimiseGatingCentres
  if model.optimiseGatingCentres
    startVal = endVal + 1;
    endVal = endVal + model.M*model.q;
    model.centres = reshape(params(startVal:endVal), model.M, model.q);
  end
  model.pi = mgplvmGatingProbabilities(model);
end


if model.optimiseBeta
  % if optimise the beta parameter
  fhandle = str2func([model.betaTransform 'Transform']);
  model.beta = fhandle(params(end), 'atox');
end

for m = 1:model.M
  X_active = model.X(find(model.activePoints(:, m)), :);
  startVal = endVal + 1;
  endVal = endVal + model.kern{m}.nParams;
  model.kern{m} = kernExpandParam(model.kern{m}, params(startVal: ...
                                                    endVal));
  model.K{m} = kernCompute(model.kern{m}, X_active);
  model.B{m} = diag(model.beta*model.expectation.s(find(model.activePoints(:, m)), m));
  model.Binv{m} = diag(1./diag(model.B{m}));
  model.C{m} = model.K{m} + model.Binv{m};
  [model.logdetC{m}, U] = logdet(model.C{m});
  model.Cinv{m} = pdinv(model.C{m}, U);
end

% Give parameters to dynamics if they are there.
if isfield(model, 'dynamics') & ~isempty(model.dynamics)
  startVal = endVal + 1;
  endVal = length(params);

  % Fill the dynamics model with current latent values.
  model.dynamics = modelSetLatentValues(model.dynamics, model.X);

  % Update the dynamics model with parameters (thereby forcing recompute).
  model.dynamics = modelExpandParam(model.dynamics, params(startVal:endVal));
end


