function fig = plot_var_explained(Z,pct_thresh)
%PLOT_VAR_EXPLAINED Plots % explained variance by PCs of data table
%
%  fig = data.example.plot_var_explained(Z);
%  fig = data.example.plot_var_explained(Z,pct_thresh);
%
%  -- Inputs --
%  Z : Table generated by `Z = data.concat_trials(Y);`
%  pct_thresh (Optional) : Percent [0-100] scalar indicating threshold for
%                             variance explained by PCs to be indicated on
%                             figure graphic.
%
%  -- Output --
%  fig : Figure handle

if nargin < 2
   pct_thresh = default.experiment('var_capt');
end

[~,~,~,~,explained,~] = pca(Z.Rate.');
fig = figure(...
   'Name','Explained Variance Check',...
   'NumberTitle','off',...
   'Color','w'); 
ax = axes(fig,'NextPlot','add',...
   'FontName','Arial',...
   'XColor','k',...
   'YColor','k',...
   'LineWidth',1.5);
vec = 1:numel(explained); 
varcapt = cumsum(explained); 

stem(ax,vec,varcapt,'Color','k','LineWidth',1.5);
iThresh = varcapt>=pct_thresh;
scatter(ax,...
   vec(iThresh),...
   varcapt(iThresh),15,'filled');
ylim(ax,[0 100]);
xlim(ax,[0 numel(explained)+1]);
iFirst = find(iThresh,1,'first');
if vec(iFirst) == 1
   ax.XTick = [vec(iFirst),numel(explained)];
   ax.YTick = [0,varcapt(iFirst),100];
else
   ax.XTick = [1,vec(iFirst),numel(explained)];
   ax.YTick = [0,varcapt(1),varcapt(iFirst),100];
end

ylabel(ax,'% Explained','FontName','Arial','Color','k');
xlabel(ax,'PC #','FontName','Arial','Color','k');


end