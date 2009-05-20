function f = mgplvmObjective(params, model)

% MGPLVMOBJECTIVE Wrapper function for mixtures of GP-LVM objective.
% FORMAT
% DESC provides a wrapper function for the GP-LVM, it
% takes the negative of the log likelihood, feeding the parameters
% correctly to the model.
% ARG params : the parameters of the GP-LVM model.
% ARG model : the model structure in which the parameters are to be
% placed.
% RETURN f : the negative of the log likelihood of the model.
% 
% SEEALSO : mgplvmCreate, mgplvmLogLikelihood, mgplvmExpandParam
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007

% MGPLVM

model = mgplvmExpandParam(model, params);
f = - mgplvmLogLikelihood(model);
