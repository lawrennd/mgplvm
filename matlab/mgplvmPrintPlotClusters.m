function mgplvmPrintPlotClusters(model, capName, experimentNo)

% MGPLVMPRINTPLOTCLUSTERS plots the cluster labels associated with the latent space.
% FORMAT
% DESC takes a model and plots the latent space with symbols based on the
% most likely cluster label.
% ARG model : the model for which the plot is to be prepared.
% 
% SEEALSO : lvmTwoDPlot, lvmScatterPlot
%
% COPYRIGHT : Raquel Urtasun, 2007

% MGPLVM
  
% latent space.
% lbls of the cluster
[kk lbls_s] = max(model.expectation.s');
lbls = zeros(size(model.expectation.s));
for i=1:size(model.expectation.s,2)
  % for each class
  lbls(find(lbls_s==i),i) = 1;
end

lvmScatterPlot(model, lbls);
fileName = ['dem' capName num2str(experimentNo) 'Cluster'];
print('-depsc', ['../tex/diagrams/' fileName])
print('-deps', ['../tex/diagrams/' fileName 'NoColour'])

% make smaller for PNG plot.
pos = get(gcf, 'paperposition')
origpos = pos;
pos(3) = pos(3)/2;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
fontsize = get(gca, 'fontsize');
set(gca, 'fontsize', fontsize/2);
lineWidth = get(gca, 'lineWidth');
set(gca, 'lineWidth', lineWidth*2);
print('-dpng', ['../html/' fileName])
set(gcf, 'paperposition', origpos);

figure
clf
ax = axes('position', [0.05 0.05 0.9 0.9]);
hold on
if ~isempty(lbls)
  lvmTwoDPlot(model.X, lbls, getSymbols(size(lbls, 2)));
else
  lvmTwoDPlot(model.X, lbls);
end
xLim = [min(model.X(:, 1)) max(model.X(:, 1))]*1.1;
yLim = [min(model.X(:, 2)) max(model.X(:, 2))]*1.1;
set(ax, 'xLim', xLim);
set(ax, 'yLim', yLim);

set(ax, 'fontname', 'arial');
set(ax, 'fontsize', 20);
print('-depsc', ['../tex/diagrams/' fileName 'NoGray'])
print('-deps', ['../tex/diagrams/' fileName 'NoGrayNoColour'])
