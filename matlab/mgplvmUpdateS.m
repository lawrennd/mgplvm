function model = mgplvmUpdateS(model)
  
% MGPLVMUPDATES Update the S values and associated activepoints.
% FORMAT
% DESC updates the values of S and changes the number of active points.
% ARG model : the model to be updated.
% RETURN model : the updated model.
%
% SEEALSO : mgplvmComputeS, mgplvmCreate
%
% COPYRIGHT : Neil D. Lawrence, 2008
  
% MGPLVM
  
[model.expectation.s, numer] = mgplvmComputeS(model);
model.activePoints = model.expectation.s>model.activeThreshold;

% Make sure all clusters have at least model.minActive active points.
for m = 1:model.M
  if (sum(model.activePoints(:, m))<model.minActive)
    [void, indMax] = sort(model.expectation.s(:, m), 1);
    model.activePoints(indMax(end:-1:end-model.minActive+1), m) = 1;
    sind = find(model.activePoints(:, m));
    % Make sure effective betas aren't too small (it leads to numerical instability.)
    model.expectation.s(sind, m) = max(eps/model.beta, model.expectation.s(sind,m));
  end
end
