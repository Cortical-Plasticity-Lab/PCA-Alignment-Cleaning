function [fig,oData] = plot_offset_estimate_errors(Y,C)
%PLOT_OFFSET_ESTIMATE_ERRORS Plot offset estimate errors by trial
%
% [fig,oData] = data.example.plot_offset_estimate_errors(Y,C);
%
% Inputs
%  Y - Table of smoothed rate estimates (Type == 'channels')
%  C - Table of corrected rate estimates (Type == 'channels')
%
% Output
%  fig - Figure handle
%  oData - Data struct with offset data

G = findgroups(Y(:,'Trial'));
AllOffset = Y.Offset;
Offset = splitapply(@(x)x(1),AllOffset,G);
[offset_dirty,trial] = data.process.estimate_offset(Y);
offset_clean = data.process.estimate_offset(C);
all_offset_clean = repmat(offset_clean,1,numel(unique(C.iChannel)));
all_offset_clean = all_offset_clean(:);
mu_correction = splitapply(@(x)mean(x),C.Correction,G);
edgeVec = 0:3:90;
err_dirty = sqrt((Offset-offset_dirty).^2);
[nDirty,edgeDirty] = histcounts(err_dirty,edgeVec);
err_clean = sqrt((AllOffset-(all_offset_clean+C.Correction)).^2);
[nClean,edgeClean] = histcounts(err_clean,edgeVec);
x_limits = [min(edgeDirty(1),edgeClean(1)) max(edgeDirty(end),edgeClean(end))];
fig = figure(...
   'Name','Estimated Offsets',...
   'Color','w',...
   'NumberTitle','off',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8]);
subplot(2,2,[1,2]);
bar(trial,[Offset,offset_dirty,(offset_clean+mu_correction)]);
xlabel('Trial Index',...
   'FontName','Arial','Color','k');
ylabel('Offset Estimate (ms)',...
   'FontName','Arial','Color','k');
legend({'Truth','Raw Estimate','Clean Estimate'},'Location','best');

% Create distribution of "dirty" errors
ax_dirty = subplot(2,2,3);
bar(ax_dirty,edgeDirty(1:(end-1))+mode(diff(edgeDirty)/2),nDirty,1,...
   'EdgeColor','none','FaceColor','r');
xlim(ax_dirty,x_limits);
xlabel(ax_dirty,'Time (ms)',...
   'FontName','Arial','Color','k');
ylabel(ax_dirty,'Number of Trials',...
   'FontName','Arial','Color','k');
title(ax_dirty,'Distribution of Uncorrected Offset sqrt(Error^2)',...
   'FontName','Arial','Color','k');
set(ax_dirty,'XTick',...
   sort([round(linspace(x_limits(1),x_limits(end),3)), mean(err_dirty)]));
y_limits = ax_dirty.YLim;

% Create distribution of "cleaned" errors
ax_clean = subplot(2,2,4);
bar(ax_clean,edgeClean(1:(end-1))+mode(diff(edgeClean)/2),nClean,...
   'EdgeColor','none','FaceColor','b');
xlim(ax_clean,x_limits);
xlabel(ax_clean,'Time (ms)',...
   'FontName','Arial','Color','k');
ylabel(ax_clean,'Number of Trials',...
   'FontName','Arial','Color','k');
title(ax_clean,'Distribution of Corrected Offset sqrt(Error^2)',...
   'FontName','Arial','Color','k');
set(ax_clean,...
   'XTick',sort([round(linspace(x_limits(1),x_limits(end),3)), mean(err_clean)]));
suptitle('Offset Estimation After Cleaning');
y_limits = [min(ax_clean.YLim(1),y_limits(1)), ...
   max(ax_clean.YLim(2),y_limits(2))];
ax_clean.YLim = y_limits;
ax_dirty.YLim = y_limits;

line(ax_clean,...
   ones(1,2).*mean(err_clean),y_limits,...
   'Color','k','LineStyle','-','LineWidth',2.5,...
   'DisplayName','Average Error','MarkerIndices',1,'Marker','v');
line(ax_dirty,...
   ones(1,2).*mean(err_dirty),y_limits,...
   'Color','k','LineStyle','-','LineWidth',2.5,...
   'DisplayName','Average Error','MarkerIndices',1,'Marker','v');
if nargout > 1
   oData = struct(...
      'Original',Offset,...
      'Smoothed',offset_dirty,...
      'Cleaned',offset_clean...
      );
end

end