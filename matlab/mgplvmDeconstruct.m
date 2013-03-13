function [comp, noise, mgplvmInfo, X] = mgplvmDeconstruct(model)

% MGPLVMDECONSTRUCT break MGPLVM in pieces for saving.
% FORMAT
% DESC takes an MGPLVM model structure and breaks it into component
% parts for saving. 
% ARG model : the model that needs to be saved.
% RETURN comp : the components of the MGPLVM model.
% RETURN noise : the noise component of the MGPLVM model.
% RETURN mgplvmInfo : a structure containing the other information
% from the MGPLVM: what the active set is, what the inactive set is
% and what the site parameters are.
%
% SEEALSO : mgplvmReconstruct, gpDeconstruct
%
% COPYRIGHT : Neil D. Lawrence, 2009, 2013

% MGPLVM

  comp = model.comp;

  removeCompFields = {'S', 'X', 'y', 'm', 'diagK', 'K_uu', 'invK_uu', 'logDetK_uu', ...
                  'alpha', 'K_uf', 'sqrtK_uu', 'K', 'sqrtK_uu', 'innerProducts', ...
                  'A', 'Ainv', 'logDetA', 'L', 'diagD', 'detDiff', 'Dinv', ...
                  'logDetD', 'V', 'Am', 'Lm', 'invLmV', 'scaledM', 'bet'};
  for i = 1:length(removeCompFields)
    for j = 1:length(comp)
      if isfield(comp{j}, removeCompFields{i})
        comp{j} = rmfield(comp{j}, removeCompFields{i});
      end
    end
  end

  
  if isfield(model, 'noise')
    noise = model.noise;
  else
    noise = [];
  end
  mgplvmInfo = model;
  removeFields = {'D', 'noise', 'comp', 'expectations'};
  
  for i = 1:length(removeFields)
    if isfield(mgplvmInfo, removeFields{i})
      mgplvmInfo = rmfield(mgplvmInfo, removeFields{i});
    end
  end
  X = model.X;
end
