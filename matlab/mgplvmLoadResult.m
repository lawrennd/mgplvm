function [model, lbls] = mgplvmLoadResult(dataSet, number)

% MGPLVMLOADRESULT Load a previously saved result.
% FORMAT
% DESC loads a previously saved FGPLVM result.
% ARG dataSet : the name of the data set to load.
% ARG number : the number of the FGPLVM run to load.
% RETURN model : the saved model.
% RETURN lbls : labels of the data set (for visualisation purposes).
%
% SEEALSO : fgplvmLoadResult
%
% COPYRIGHT : Neil D. Lawrence, 2003, 2004, 2005, 2006, 2008, 2013
  
% MGPLVM

[Y, lbls] = lvmLoadData(dataSet);

dataSet(1) = upper(dataSet(1));
load(['dem' dataSet 'Mgplvm' num2str(number)])
model = mgplvmReconstruct(comp, noise, mgplvmInfo, X, Y);