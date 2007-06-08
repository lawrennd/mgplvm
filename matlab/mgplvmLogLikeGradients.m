function g = mgplvmLogLikeGradients(model)
  
% MGPLVMLOGLIKEGRADIENTS Compute gradients for the MGPLVM model.
% FORMAT
% DESC computes the gradient of the model log likelihood with respect to
% the Xs and kernel parameters.
% ARG model : the model for which the gradients are required.
% RETURN g : the gradients of the model.
%
% SEEALSO : mgplvmCreate, mgplvmExpandParam, mgplvmExtractParam, modelLogLikeGradient 
%
% COPYRIGHT : Raquel Urtasun and Neil D. Lawrence, 2007

% MGPLVM
  
gX = zeros(size(model.X));
% gbeta = 0;
gbeta_old = 0;


for m = 1:model.M
  activeInd = find(model.activePoints(:, m));
  numActive = length(activeInd);
  X_active = model.X(activeInd, :);

  %%% Prepare to Compute Gradients with respect to X %%%
  gKX = kernGradX(model.kern{m}, X_active, X_active);
  gKX = gKX*2;
  dgKX = kernDiagGradX(model.kern{m}, X_active);
  for i = 1:numActive
    gKX(i, :, i) = dgKX(i, :);
  end
  

  
  %%% Gradients of Kernel Parameters %%%
  gParam{m} = zeros(1, model.kern{m}.nParams);
  
  
  for k = 1:model.d
    gX_active = zeros(numActive, model.q);
    gK = localCovarianceGradients(model, model.y(activeInd, k), m);
    
    %%% Compute Gradients with respect to X %%%
    for i = 1:numActive
      for j = 1:model.q
        gX_active(i, j) = gX_active(i, j) + gKX(:, j, i)'*gK(:, i);
      end
    end
    
    gX(activeInd, :) = gX(activeInd, :) + gX_active;
    
    gParam{m} = gParam{m} + kernGradient(model.kern{m}, X_active, gK);

    %%% Compute Gradients with respect to beta %%%
    if model.optimiseBeta
      gKbeta = - model.Binv{m}*diag(model.expectation.s(find(model.activePoints(:, m)), m))*model.Binv{m};
      %/~
      % trace(gKbeta*gK) is very inefficient, better is sum(sum(gKbeta.*gK));
      % gbeta = gbeta + trace(gKbeta * gK); 
      %~/
%       gbeta = gbeta + sum(sum(gKbeta.*gK));
      
%      gbeta_old = gbeta + trace(gKbeta * gK); 
gbeta_old = gbeta_old + sum(sum(gKbeta.*gK));
    
    end
    
    
       
  end
  
  sm = model.expectation.s(activeInd,m);
    
  if model.optimiseBeta
      da = 0.5*(sm-1)/model.beta;
      gbeta_old = gbeta_old + model.d*sum(da);
  end
 
%/~
    % if optimise the gating
%     if model.optimiseGating        
%         pim = model.pi(activeInd,m);
%         
%         % do only for the active ones, the other are zero, since multiply
%         % by <snm>
%         dpim_dX = zeros(model.N,model.q);
%         dpim_dX = repmat(model.centres(m,:),model.N,1);
%         for kk =1:model.M
%             dpim_dX = dpim_dX - repmat(model.centres(kk,:),model.N,1).*repmat(model.pi(:,kk),1,model.q);
%         end
%         gX = gX + model.d*(repmat(model.expectation.s(:,m),1,model.q).*dpim_dX);
%     end
%~/
end


if model.optimiseGating 
  gX = gX + mgplvmGatingLogLikeGradient(model);
end

gDynParam = [];
% Check if Dynamics kernel is being used.
if isfield(model, 'dynamics') & ~isempty(model.dynamics)

  % Get the dynamics parameters
  gDynParam = modelLogLikeGradients(model.dynamics);
  
  % Include the dynamics latent gradients.
  gX = gX + modelLatentGradients(model.dynamics);

elseif isfield(model, 'prior') &  ~isempty(model.prior)
  gX = gX + priorGradient(model.prior, model.X); 
end

g_X_or_back = fgplvmBackConstraintGrad(model, gX);
g = g_X_or_back(:)';

if model.optimiseGating & model.optimiseGatingCentres
  gcentres = zeros(model.M,model.q);
  for m=1:model.M
    % compute the derivative of each center
    common_f = model.expectation.s(:,m)-model.pi(:,m);
    gcentres(m,:) = sum(model.X.*repmat(common_f,1,model.q))-model.centres(m,:)*sum(common_f);  
  end
  gcentres = model.d*gcentres-model.centres; % add the derivative of the normalization of the centres
  g = [g gcentres(:)'];
end

for m = 1:model.M
  g = [g gParam{m}];
end
% Concatanate existing parameter gradients.
g = [g gDynParam];

if model.optimiseBeta
%   for m = 1:model.M
%     % add the contribution from the correction terms
%     sm = model.expectation.s(activeInd,m);  
%     da = 0.5*(sm-1)/model.beta;
%     gbeta = gbeta + model.d*sum(da);
%   end
%   fhandle = str2func([model.betaTransform 'Transform']);
%   gbeta = gbeta*fhandle(model.beta, 'gradfact');
%   g = [g gbeta];

    fhandle = str2func([model.betaTransform 'Transform']);
    gbeta_old = gbeta_old*fhandle(model.beta, 'gradfact');
    g = [g gbeta_old];
end





function gK = localCovarianceGradients(model, y, m);

  

Cinvy = model.Cinv{m}*y;
gK = -model.Cinv{m} + Cinvy*Cinvy';
gK= gK*0.5;
  