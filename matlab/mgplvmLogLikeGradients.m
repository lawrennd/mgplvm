function [g, gS] = mgplvmLogLikeGradients(model)
  
% MGPLVMLOGLIKEGRADIENTS Compute gradients for the MGPLVM model.
% FORMAT
% DESC computes the gradient of the model log likelihood with respect to
% the Xs and kernel parameters.
% ARG model : the model for which the gradients are required.
% RETURN g : the gradients of the model.
%
% SEEALSO : mgplvmCreate, mgplvmExpandParam, mgplvmExtractParam, modelLogLikeGradient 
%
% COPYRIGHT : Raquel Urtasun and Neil D. Lawrence, 2007, 2008

% MGPLVM
  
gX = zeros(size(model.X));
%/~
% gbeta = 0;
%~/
gbeta_old = 0;

if model.compLabelConstr
  gS = spalloc(model.N, model.M, nnz(model.expectation.s));
end

for m = 1:model.M
  activeInd = find(model.activePoints(:, m));
  sm = model.expectation.s(activeInd,m);
  numActive = length(activeInd);
  X_active = model.X(activeInd, :);
  [gParam{m}, gX_u, gX_active, gK] = gpLogLikeGradients(model.comp{m}, X_active);
  gX(activeInd, :) = gX(activeInd, :) + gX_active;
  
  if model.compLabelConstr
    % Get gradient with respect to expectations of s.
    gS(activeInd, m) = -gK.*(model.beta./(model.comp{m}.beta.*model.comp{m}.beta));
    gS(activeInd, m) = gS(activeInd, m) ...
        + log(model.pi(m)) ...
        + 0.5*model.d*(log(model.beta) ...
                       -log(2*pi) ...
                       - 1./sm) ...
        - log(sm) ...
        - 1;
  end
  %% Deal with construction of beta as expecatations multiplied by a scalar. %%
  if model.optimiseBeta
    gKbeta = - sm./(model.comp{m}.beta.*model.comp{m}.beta);
    %/~
    % trace(gKbeta*gK) is very inefficient, better is sum(sum(gKbeta.*gK));
    % gbeta = gbeta + trace(gKbeta * gK); 
    %       gbeta = gbeta + sum(sum(gKbeta.*gK));      
    %      gbeta_old = gbeta + trace(gKbeta * gK); 
    %~/
    gbeta_old = gbeta_old + sum(gK.*gKbeta); 
    
    % This is the term on beta from the log prefactors
    da = model.d*0.5*(sm-1)/model.beta;
    gbeta_old = gbeta_old + sum(da);
  end
%/~
    % if optimise the gating
%     if model.optimiseGating        
%         pim = model.pi(activeInd,m);
%         
%         % do only for the active ones, the other are zero, since multiply
%         % by <snm>
%         dpim_dX = zeros(model.N,model.q);
%         dpim_dX = repmat(model.gating.centres(m,:),model.N,1);
%         for kk =1:model.M
%             dpim_dX = dpim_dX - repmat(model.gating.centres(kk,:),model.N,1).*repmat(model.pi(:,kk),1,model.q);
%         end
%         gX = gX + model.d*(repmat(model.expectation.s(:,m),1,model.q).*dpim_dX);
%     end
%~/
end
%/~
% for m = 1:model.M
%   activeInd = find(model.activePoints(:, m));
%   numActive = length(activeInd);
%   X_active = model.X(activeInd, :);

%   %%% Prepare to Compute Gradients with respect to X %%%
%   gKX = kernGradX(model.comp{m}.kern, X_active, X_active);
%   gKX = gKX*2;
%   dgKX = kernDiagGradX(model.comp{m}.kern, X_active);
%   for i = 1:numActive
%     gKX(i, :, i) = dgKX(i, :);
%   end
  

  
%   %%% Gradients of Kernel Parameters %%%
%   gParam{m} = zeros(1, model.comp{m}.kern.nParams);
  
  
%   for k = 1:model.d
%     gX_active = zeros(numActive, model.q);
%     gK = localCovarianceGradients(model, model.y(activeInd, k), m);
    
%     %%% Compute Gradients with respect to X %%%
%     for i = 1:numActive
%       for j = 1:model.q
%         gX_active(i, j) = gX_active(i, j) + gKX(:, j, i)'*gK(:, i);
%       end
%     end
    
%     gX(activeInd, :) = gX(activeInd, :) + gX_active;
    
%     gParam{m} = gParam{m} + kernGradient(model.comp{m}.kern, X_active, gK);

%     %%% Compute Gradients with respect to beta %%%
%     if model.optimiseBeta
%       gKbeta = - model.expectation.s(find(model.activePoints(:, m)), m)'./(model.comp{m}.beta.*model.comp{m}.beta);
%       %
%       % trace(gKbeta*gK) is very inefficient, better is sum(sum(gKbeta.*gK));
%       % gbeta = gbeta + trace(gKbeta * gK); 
%       %       gbeta = gbeta + sum(sum(gKbeta.*gK));      
%       %      gbeta_old = gbeta + trace(gKbeta * gK); 
%       %
%       gbeta_old = gbeta_old + sum(diag(gK)'.*gKbeta); 
    
%     end
    
    
       
%   end
  
%   sm = model.expectation.s(activeInd,m);
    
%   if model.optimiseBeta
%       da = 0.5*(sm-1)/model.beta;
%       gbeta_old = gbeta_old + model.d*sum(da);
%   end
 
%
    % if optimise the gating
%     if model.optimiseGating        
%         pim = model.pi(activeInd,m);
%         
%         % do only for the active ones, the other are zero, since multiply
%         % by <snm>
%         dpim_dX = zeros(model.N,model.q);
%         dpim_dX = repmat(model.gating.centres(m,:),model.N,1);
%         for kk =1:model.M
%             dpim_dX = dpim_dX - repmat(model.gating.centres(kk,:),model.N,1).*repmat(model.pi(:,kk),1,model.q);
%         end
%         gX = gX + model.d*(repmat(model.expectation.s(:,m),1,model.q).*dpim_dX);
%     end
%
% end
%~/
%[gX, gcentres] = mgplvmLogPrefactorGradients(model, gX);
[gX, gcentres, gDynParam] = mgplvmLatentPriorLogLikeGradients(model, gX);

expXhat = zeros(model.N, model.q);
if model.compLabelConstr
  halfD = 0.5*model.d;
  for m = 1:model.M
    activeInd = find(model.activePoints(:, m));
    sm = model.expectation.s(activeInd,m);
    numActive = length(activeInd);
    Xhat{m} = model.X(activeInd, :);
    Xhat{m} = Xhat{m} - repmat(model.gating.centres(m, :), numActive, 1); 
    expXhat(activeInd, :) = expXhat(activeInd, :) ...
        + Xhat{m}.*repmat(sm, 1, model.q);
  end
  for m = 1:model.M
    activeInd = find(model.activePoints(:, m));
    notActiveInd = find(~model.activePoints(:, m));
    numActive = length(activeInd);
    numNotActive = length(notActiveInd);
    sm = model.expectation.s(activeInd, m);
    gX(activeInd, :) = gX(activeInd, :) ...
        - model.gating.precision(m)*repmat(sm.*gS(activeInd, m), 1, model.q) ...
        .*(Xhat{m}-expXhat(activeInd, :));
    % Deal with terms for which <s> is zero.
%     xNotActiveHat = model.X(notActiveInd, :)...
%         -repmat(model.gating.centres(m, :), numNotActive, 1);
%      gX(notActiveInd, :) = gX(notActiveInd, :) ...
%          - model.gating.precision(m)*(halfD)*(xNotActiveHat...
%                         -expXhat(notActiveInd, :));
    if model.optimiseCentres
      % Deal with centres
      gcentres(m, :) = gcentres(m, :) + model.gating.precision(m)*sum(Xhat{m}...
                                            .*repmat(gS(activeInd, m)...
                                                     .*sm...
                                                     .*(1-sm), ...
                                                     1, model.q), ...
                                            1);
 %     gcentres(m, :) = gcentres(m, :) ...
%         - model.gating.precision(m)*halfD*sum(xNotActiveHat, 1);
      for l=1:model.M
        if m~=l
          sl = model.expectation.s(activeInd, l);
          Xhatl = model.X(activeInd, :);
          Xhatl = Xhatl - repmat(model.gating.centres(l, :), numActive, 1); 
          gcentres(l, :) = gcentres(l, :) - model.gating.precision(l)*sum(Xhatl...
                                                .*repmat(gS(activeInd, m)...
                                                         .*sm...
                                                         .*sl, ...
                                                         1, model.q), ...
                                                1);
%          gcentres(l, :) = gcentres(l, :) ...
%              + model.gating.precision(l)*halfD ...
%              *sum(xNotActiveHat...
%                   .*repmat(model.expectation.s(notActiveInd,l), ...
%                            1, model.q),...
%                   1);
        end
      end
    end      
  end
end


% Add in back constraints if they exist.
g_X_or_back = fgplvmBackConstraintGrad(model, gX);
g = g_X_or_back(:)';

g = [g gcentres(:)'];

for m = 1:model.M
  g = [g gParam{m}];
end

% Concatanate any dynamics parameter gradients.
g = [g gDynParam];

% Add in the beta gradient.
if model.optimiseBeta
%/~  
%   for m = 1:model.M
%     % add the contribution from the correction terms
%     sm = model.expectation.s(activeInd,m);  
%     da = 0.5*(sm-1)/model.beta;
%     gbeta = gbeta + model.d*sum(da);
%   end
%   fhandle = str2func([model.betaTransform 'Transform']);
%   gbeta = gbeta*fhandle(model.beta, 'gradfact');
%   g = [g gbeta];
%~/
    fhandle = str2func([model.betaTransform 'Transform']);
    gbeta_old = gbeta_old*fhandle(model.beta, 'gradfact');
    g = [g gbeta_old];
end



%/~
% function gK = localCovarianceGradients(model, y, m);

% Kinvy = model.comp{m}.invK_uu*y;
% gK = -model.comp{m}.invK_uu + Kinvy*Kinvy';
% gK= gK*0.5;
%~/ 