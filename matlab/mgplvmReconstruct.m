function model = mgplvmReconstruct(comp, noise, mgplvmInfo, X, Y)

% MGPLVMRECONSTRUCT Reconstruct an MGPLVM from component parts.
% FORMAT
% DESC takes component parts of an MGPLVM model and reconstructs the
% MGPLVM model. The component parts are normally retrieved from a
% saved file.
% ARG comp : a component structure for the MGPLVM.
% ARG noise : a noise structure for the MGPLVM (currently ignored).
% ARG mgplvmInfo : the active set and the inactive set of the MGPLVM as
% well as the site parameters, stored in a structure.
% ARG X : the input training data for the MGPLVM.
% ARG y : the output target training data for the MGPLVM.
% RETURN model : an MGPLVM model structure that combines the component
% parts.
% 
% SEEALSO : mgplvmDeconstruct, mgplvmCreate, gpReconstruct
%
% COPYRIGHT : Neil D. Lawrence, 2009, 2013

% MGPLVM

  model = mgplvmInfo;
  model.y = Y;
  model.X = X;
  model.type = 'mgplvm';
  model.comp = comp;
  if ~isempty(noise)
    model.noise = noise;
  end
  
  params = mgplvmExtractParam(model);
  model = mgplvmExpandParam(model, params);

end
