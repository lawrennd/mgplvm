function model = mgplvmCreate(q, d, Y, options)

% MGPLVMCREATE Create a MGPLVM model.
% FORMAT
% DESC creates a mixtures of GP-LVMs model.
% ARG q : dimensionality of latent space.
% ARG d : dimensionality of data space.
% ARG Y : the data to be modelled in design matrix format (as many
% rows as there are data points).
% ARG options : options structure as returned from
% MGPLVMOPTIONS. This structure determines the type of
% approximations to be used (if any).
% RETURN model : the GP-LVM model.
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007
%
% SEEALSO : modelCreate, mgplvmOptions

% MGPLVM

if size(Y, 2) ~= d
  error(['Input matrix Y does not have dimension ' num2str(d)]);
end

if isstr(options.initX)
  initFunc = str2func([options.initX 'Embed']);
  X = initFunc(Y, q);
else
  if size(options.initX, 1) == size(Y, 1) ...
        & size(options.initX, 2) == q
    X = options.initX;
  else
    error('options.initX not in recognisable form.');
  end
end
    
model.y = Y;
model.X = X;
model.type = 'mgplvm';
model.N = size(model.y, 1);
model.d = size(model.y, 2);
model.M = options.numComps;
model.q = q;
model.activeThreshold = options.activeThreshold;
model.optimiseCentres = options.optimiseCentres;
model.estepCentres = options.estepCentres;
model.optimiseBeta = options.optimiseBeta;
model.isGating = options.isGating;
model.isInfinite = options.isInfinite;
model.compLabelConstr = options.compLabelConstr;
if model.isGating & model.isInfinite;
  error('Infinite model cannot use a gating network.');
end
model.optimiser = options.optimiser;

if isstruct(options.kern) 
  for m = 1:model.M
    model.comp{m}.kern = options.kern;
  end
else
  for m=1:model.M
    model.comp{m}.kern = kernCreate(model.X, options.kern);
  end
end
for m=1:model.M
  model.comp{m}.approx = 'ftc';
  model.comp{m}.d = model.d;
  model.comp{m}.learnScales = false;
  model.comp{m}.isMissingData = false;
end
model.minActive = options.minActive;


if isfield(options, 'back') & ~isempty(options.back)
  if isstruct(options.back)
    model.back = options.back;
  else
    if ~isempty(options.back)
      model.back = modelCreate(options.back, model.d, model.q, options.backOptions);
    end
  end
  if options.optimiseInitBack
    % Match back model to initialisation.
    model.back = mappingOptimise(model.back, model.y, model.X);
  end
  % Now update latent positions with the back constraints output.
  model.X = modelOut(model.back, model.y);
else
  model.back = [];
end


ind = randperm(model.N);
ind = ind(1:model.M);
% Some heuristic clustering to initialise gating centres.
%centres = kmeans(randn(model.M, model.q), model.X, foptions);
centres = model.X(ind, :);

model = mgplvmComputeInitAssignment(model, centres, options);

%/~
% switch model.q 
%     case 1
%         figure
%         plot(1:model.N,model.X(:,1),'r.')
%         hold on
%         symbol = getSymbols(size(model.hard_s,2));
%         data = lvmTwoDPlot([[1:model.N]',model.X], model.hard_s, symbol);
%     case 2
%         figure
%         plot(model.X(:,1),model.X(:,2),'r.');
%         hold on
%         symbol = getSymbols(size(model.hard_s,2));
%         data = lvmTwoDPlot(model.X, model.hard_s, symbol);    
% end
%~/

ind2 = find(sum(model.hard_s));
model.hard_s = model.hard_s(:, ind2);
centres = centres(ind2, :);
%/~
%model.M = length(ind2);
%~/

% Throw back in 'lost' centres.
ind3 = [];
for m = length(ind2)+1:model.M
  ind3 = [ind3 ceil(rand(1)*size(model.X, 1))];
end
model.gating.centres = [centres; model.X(ind3, :)];
model.gating.precision = repmat(1/(options.scale*options.scale), 1, model.M);
% Recompute hard assignments.
model = mgplvmComputeInitAssignment(model,centres,options);

%/~
% model.expectation.s = zeros(model.N, model.M);
% piNum = zeros(model.N, model.M);
% for m = 1:model.M
%   ind = find(model.hard_s(:, m));
%   if length(ind)>0
%     model.compVar(m) = mean(var(model.X(ind, :)));
%   else
%     model.compVar(m) = .2;
%   end
%   %%%% fix the variances set the variance
%   model.compVar(m) = 1;
% %   plot([1:model.N]',repmat(centres(m,:),model.N));
% end
%~/
if model.isInfinite
  model.a0=options.a0;
  model.a1=options.a1;  
end

if model.isGating
  model.pi = mgplvmComputePi(model);
  model.expectation.s = sparse(model.pi);
else 
  model.pi = ones(1, model.M)/model.M;
  model.expectation.s = mgplvmComputeS(model, model.X);
end

model.activePoints = model.expectation.s>model.activeThreshold;
for m = 1:model.M
  % Make sure all clusters have at least minActive active points.
  if (sum(model.activePoints(:, m))<model.minActive) % ??? corrected by me
    [void, indMax] = sort(model.expectation.s(:, m), 1);
    model.activePoints(indMax(end:-1:end-model.minActive+1), m) = 1;
  end
end

model.beta = options.beta;
model.betaTransform =  optimiDefaultConstraint('positive');

params = mgplvmExtractParam(model);
model = mgplvmExpandParam(model, params);


