function model = mgplvmEMOptimise(model, display, outerIters, eIters, mIters)
  
% MGPLVMEMOPTIMISE Optimise the mixture model using the EM algorithm.
% FORMAT
% DESC optimises the given mixture of GP-LVM model using a KL corrected
% EM algorithm.
% ARG model : the model to be optimised.
% ARG display : whether or not to display the results (default 1).
% ARG outerIters : maximum number of EM steps (default 40).
% ARG eIters : number of iterations in the E step (default 10).
% ARG mIters : number of iterations in the M step (default 100).
% RETURN model : the optimised model.
%
% SEEALSO : mgplvmOptimise, mgplvmCreate, mgplvmEstep
%
% COPYRIGHT ; Neil D. Lawrence and Raquel Urtasun, 2007

% MGPLVM


if nargin < 5
  mIters = 100;
  if nargin < 4
    eIters = 10;
    if nargin < 3
      outerIters = 40;
      if nargin < 2
        display = 1;
      end
    end
  end
end

for outer = 1:outerIters
  disp(['Outer iteration ... ',num2str(outer)]);
  model = mgplvmEstep(model, display, eIters);  
  model = mgplvmOptimise(model, display, mIters); 
end
