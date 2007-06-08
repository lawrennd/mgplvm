function [] = mgplvmPlotClusters(model)

% MGPLVMPLOTCLUSTERS plots the cluster labels associated with the latent space.
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

switch model.q 
 case 1
  figure
  plot(1:model.N,model.X(:,1),'r.')
  hold on
  symbol = getSymbols(size(lbls,2));
  data = lvmTwoDPlot([[1:model.N]',model.X], lbls, symbol);
 case 2
  figure
  plot(model.X(:,1),model.X(:,2),'r.');
  hold on
  %/~
  % %         symbol = getSymbols(size(model.hard_s,2));
  %~/
  symbol = getSymbols(size(lbls,2));
  data = lvmTwoDPlot(model.X, lbls, symbol); 
  %/~
  %         plot(model.centres(:,1),model.centres(:,2),'ko');
  %         
  %         for j=1:size(model.kern,2)
  %             if (isfield(model.kern{j},'centre'))
  %                 value = model.centres(j,:)-model.kern{j}.centre;
  %                 plot(value(:,1),value(:,2),'k*');
  %                 plot(model.kern{j}.centre(:,1),model.kern{j}.centre(:,2),'ks');
  %             end
  %         end
        %~/
 case 3
  figure
  plot3(model.X(:,1),model.X(:,2),model.X(:,3),'bo')
  hold on
  symbol = getSymbols(size(lbls,2));
  data = lvmThreeDPlot(model.X, lbls, symbol);
end
