function fileName = mgplvmWriteResult(model, dataSet, number)

% MGPLVMWRITERESULT Write a MGPLVM result.
% FORMAT
% DESC writess an MGPLVM result.
% ARG model : the model to write.
% ARG dataSet : the name of the data set to write.
% ARG number : the number of the MGPLVM run to write.
% RETURN fileName : the file name used to write.
%
% SEEALSO : fgplvmLoadResult
%
% COPYRIGHT : Neil D. Lawrence, 2009, 2011
  
% MGPLVM

dataSet(1) = upper(dataSet(1));
type = model.type;
type(1) = upper(type(1));
fileName = ['dem' dataSet type num2str(number)];

[comp, noise, mgplvmInfo, X] = mgplvmDeconstruct(model);

save(fileName, 'comp', 'noise', 'mgplvmInfo', 'X');