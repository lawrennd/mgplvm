function [gX, gcentres, gDynParam] = mgplvmLatentPriorLogLikeGradients(model, gX)

% MGPLVMLATENTPRIORLOGLIKEGRADIENTS Compute gradients of prior in latent space.
% FORMAT
% DESC computes the gradients with respect to the log likelihood of the
% prior in the latent space.
% ARG model : the model for which log likelihood is required.
% ARG gX : Pre-existing latent gradients with respect to X.
% RETURN gX : Updated latent gradients with respect to X.
% RETURN gcentres : Latent gradients with respect to centres.
% RETURN gDynParam : Latent gradients with respect to dynamics parameters.
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007
%
% SEEALSO : mgplvmLatentPriorLogLikelihood, mgplvmLogLikeGradients, mgplvmCreate
  
% MGPLVM

 
if model.isGating 
  gX = gX + mgplvmGatingLogLikeGradient(model);
elseif ~model.compLabelConstr
  for m=1:model.M
    ind = find(model.activePoints(:, m));
    gX(ind, :) = gX(ind, :) ...
        - repmat(model.expectation.s(ind, m), 1, model.q) ...
        .*(model.X(ind, :) ...
           - repmat(model.gating.centres(m, :), length(ind), 1))/model.gating.scale;
  end
end

gDynParam = [];
gcentres = [];


if model.optimiseCentres
  gcentres = zeros(model.M,model.q);
  % compute the derivative of each center
  if model.isGating
    for m=1:model.M
      common_f = model.expectation.s(:,m)-model.pi(:,m);
      gcentres(m,:) = sum(model.X.*repmat(common_f,1,model.q))-model.gating.centres(m,:)*sum(common_f);  
    end      
    %gcentres = model.d*gcentres;
  elseif ~model.compLabelConstr
    for m = 1:model.M
      ind = find(model.activePoints(:, m));
      gcentres(m, :) = sum(repmat(model.expectation.s(ind, m), ...
                                  1, model.q).*(model.X(ind, :) - ...
                                                repmat(model.gating ...
                                                       .centres(m, :), ...
                                                       length(ind), 1)), ...
                           1)/model.gating.scale;
    end
  end
  gcentres = gcentres-model.gating.centres; % add the derivative of the normalization of the centres
end

% Check if Dynamics kernel is being used.
if isfield(model, 'dynamics') & ~isempty(model.dynamics)
  
  % Get the dynamics parameters
  gDynParam = modelLogLikeGradients(model.dynamics);
  
  % Include the dynamic's latent gradients.
  gX = gX + modelLatentGradients(model.dynamics);
  
elseif isfield(model, 'prior') &  ~isempty(model.prior)
  gX = gX + priorGradient(model.prior, model.X); 
end
