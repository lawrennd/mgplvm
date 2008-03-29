function modelRet = mgplvmTest

% MGPLVMTEST Test the gradients of the MGPLVM model.
% FORMAT
% DESC runs some tests on the GP-LVM code in the MGPLVM toolbox to
% test that it is working.
% RETURN model : a cell array of models used for testing.
%
% SEEALSO : modelTest
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007


% MGPLVM

q = 2;
d = 3;
N = 10;
Nseq = 4;
M = 3;
k = 5;
kernType = {'rbf', 'lin', 'rbfard', 'mlp', 'mlpard', 'white'};
kernType = {'rbf', 'white'};
kernType = {'rbf', 'bias'};
backType = 'mlp';
%dynType = 'gp';
dynType = 'gpTime';
learn = true; % dont' test learning of dynamics.
learn = false;
diff = false; % Use diffs for generating dynamics.
seq(1) = 5;
seq(2) = 10;
learnScales = true; % test learning of output scales.

Yorig = randn(N, d);
indMissing = find(rand(N, d)>0.7);
%indMissing = [9 19 29];
counter = 0;
for infinite = [true ]
  for back = [false ]
    Y = Yorig;
    for dyn = [false]
      options = mgplvmOptions;
      options.scale = .01;
      options.initClusters = 'hard';
      options.numComps = M;
      options.optimiseGating = false;
      options.isInfinite = infinite;
      options.kern = kernType;
      optionsDyn = gpOptions('ftc');
      optionsDyn.isSpherical = true;
      optionsDyn.isMissingData = false;
      
      if back & dyn
      disp(['Back constrained, ' ...
            'with dynamics'])
      elseif dyn
        disp(['With dynamics.'])
      elseif back
        disp(['Back constrained.'])
      end
      if back
        options.back = backType;
        options.backOptions = feval([backType 'Options']);
        options.optimiseInitBack = 0;
      end
      model = mgplvmCreate(q, d, Y, options);
      if dyn
        switch dynType 
         case 'gp'
          model = modelAddDynamics(model, 'gp', optionsDyn, ...
                                   diff, learn, seq);
         case 'gpTime'
          t = [1:size(Y, 1)]';
          model = modelAddDynamics(model, 'gpTime', optionsDyn, ...
                                   t, diff, learn, seq);
         otherwise
          model = modelAddDynamics(model, dynType);
          
        end
        
      end
      
      
      initParams = mgplvmExtractParam(model);
      % this creates some nasty parameters.
      initParams = randn(size(initParams));%./(100*randn(size(initParams)));
      
      % This forces kernel computation.
      model = mgplvmExpandParam(model, initParams);
      argin = {};
      if dyn
        if strcmp(dynType, 'gpTime')
          argin = {(2:Nseq)'};
        end        
      end
      fprintf('Check learning gradients\n');
      modelDisplay(model);
      modelGradientCheck(model);
      counter = counter + 1;
      modelRet{counter} = model;
    end
  end
end