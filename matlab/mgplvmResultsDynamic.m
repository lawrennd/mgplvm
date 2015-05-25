function mgplvmResultsDynamic(dataSet, number, dataType, varargin)

% MGPLVMRESULTSDYNAMIC Load a results file and visualise them.

% MGPLVM
  
[model, lbls] = mgplvmLoadResult(dataSet, number);

% Visualise the results
switch size(model.X, 2) 
 case 2
  lvmVisualise(model, lbls, [dataType 'Visualise'], [dataType 'Modify'], ...
                 varargin{:});
  
 otherwise 
  error('No visualisation code for data of this latent dimension.');
end