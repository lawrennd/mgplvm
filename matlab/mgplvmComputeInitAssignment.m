function [model] = mgplvmComputeInitAssignment(model,centres,options)

% MGPLVMCOMPUTEINITASSIGNMENT Compute an inital assignment for the mixtures.
% FORMAT
% DESC computes an initial assignment for the data points to the
% clusters. The type of assignment can have a fairly signifcant effect on
% results, so a few sensible options are provided.
% ARG model : the model for which the assignments are to be computed.
% ARG centres : the locations of the gating centres.
% ARG options : the options type (should have a filed 'initClusters'
% which should be set to 'hard' for a strong inital assignment, 'soft'
% for a softer assignment and 'supersoft' for a very weak assignment
% (uniform).
%
% SEEALSO : mgplvmCreate, mgplvmOptions
% 
% COPYRIGHT : Raquel Urtasun, 2007
%
  
% MGPLVM

  
[void, ind] = min(dist2(model.X, centres), [], 2);
model.hard_s = zeros(size(model.X, 1), model.M);
switch options.initClusters
case 'hard'
    for i = 1: size(model.X, 1)
      model.hard_s(i, ind(i)) = 1;
    end
case 'soft'
    model.hard_s = repmat(max(dist2(model.X, centres)),model.N,1)-dist2(model.X, centres);
    model.hard_s = (repmat(sum(model.hard_s, 2), 1, model.M));
case 'supersoft'
    model.hard_s = ones(size(model.X, 1), model.M)/model.N;
end