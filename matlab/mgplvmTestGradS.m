% MGPLVMTESTGRADS

model = mgplvmTest;
model = model{1};
[g, gS] = mgplvmLogLikeGradients(model);
if model.compLabelConstr
  sDiff = spalloc(model.N, model.M, nnz(model.expectation.s));
end
for m = 1:model.M
  activeInd = find(model.activePoints(:, m));
  for j = activeInd'
    origS = model.expectation.s(j,m);
    delt = max(origS*1e-6, 1e-15);
    model.expectation.s(j, m) = origS + delt;
    model.comp{m}.beta = model.beta*model.expectation.s(find(model.activePoints(:, m)), m);
    X_active = model.X(find(model.activePoints(:, m)), :);
    model.comp{m} = gpUpdateKernels(model.comp{m}, X_active);
    llPlus = mgplvmLogLikelihood(model);
    model.expectation.s(j, m) = origS - delt;
    model.comp{m}.beta = model.beta*model.expectation.s(find(model.activePoints(:, m)), m);
    X_active = model.X(find(model.activePoints(:, m)), :);
    model.comp{m} = gpUpdateKernels(model.comp{m}, X_active);
    llMinus = mgplvmLogLikelihood(model);
    model.expectation.s(j, m) = origS;
    sDiff(j, m) = (llPlus - llMinus)/(2*delt);
  end
end



  