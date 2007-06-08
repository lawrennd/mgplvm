function [params, names] = mgplvmExtractParam(model)

% MGPLVMEXTRACTPARAM Extract a parameter vector from a MGPLVM model.
% FORMAT
% DESC extracts a parameter vector from a given MGPLVM structure.
% ARG model : the model from which parameters are to be extracted.
% RETURN params : the parameter vector extracted from the model.
%
% DESC does the same as above, but also returns parameter names.
% ARG model : the model structure containing the information about
% the model.
% RETURN params : a vector of parameters from the model.
% RETURN names : cell array of parameter names.
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007
%
% SEEALSO : mgplvmCreate, mgplvmExpandParam, modelExtractParam

% MGPLVM

  
if nargout > 1
  returnNames = true;
else
  returnNames = false;
end  

if isfield(model, 'back') & ~isempty(model.back)
  if returnNames
    [backParams, backNames] = modelExtractParam(model.back);
    for i = 1:length(backNames)
      backNames{i} = ['Back constraint, ' backNames{i}];
    end
    names = {backNames{:}};
  else
    backParams = modelExtractParam(model.back);
  end
  params = backParams;
else
  params = model.X(:)';
  if returnNames
    for i = 1:size(model.X, 1)
      for j = 1:size(model.X, 2)
        Xnames{i, j} = ['X(' num2str(i) ', ' num2str(j) ')'];
      end
    end
    names = {Xnames{:}};
  end
end

if model.optimiseGating & model.optimiseGatingCentres
  params = [params model.centres(:)'];
end

for m = 1:model.M
  params = [params kernExtractParam(model.kern{m})];
end

% add the beta to the params to estimate
if model.optimiseBeta
  fhandle = str2func([model.betaTransform 'Transform']);
  betaParam = fhandle(model.beta, 'xtoa');
  params = [params betaParam];
  %     params = [params model.beta];
end


if returnNames
  counter = 0;
  if model.optimiseGating & model.optimiseGatingCentres
    for j = 1:model.q
      for i = 1:model.M
        counter = counter + 1;
        addnames{counter} = ['centre(' num2str(i) ', ' num2str(j) ')'];
      end
    end
  end  
  endVal = counter;  
  for m = 1:model.M
    startVal = endVal + 1;
    endVal = endVal + model.kern{m}.nParams;
    [void, addnames(startVal:endVal)] = kernExtractParam(model.kern{m});
  end
  if model.optimiseBeta
    addnames{endVal + 1} = 'beta';
  end
  names = {names{:} addnames{:}};
end

if isfield(model, 'dynamics') & ~isempty(model.dynamics)
  if returnNames
    [dynParams, dynNames] = modelExtractParam(model.dynamics);
    for i = 1:length(dynNames)
      dynNames{i} = ['Dynamics, ' dynNames{i}];
    end
    names = {names{:}, dynNames{:}};
  else
    dynParams = modelExtractParam(model.dynamics);
  end
  params = [params dynParams];
    
end
