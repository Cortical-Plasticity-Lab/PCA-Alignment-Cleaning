function fig = plot_channel_offset_errors(err,trial,channel,Offset,offset,offset_trials)
%PLOT_CHANNEL_OFFSET_ERRORS Plot offset estimate errors by channel
%
% fig = data.example.plot_channel_offset_errors(err);
% fig = data.example.plot_channel_offset_errors(err,trial,channel);
% fig =
% data.example.plot_channel_offset_errors(__,Offset,offset,offset_trials);
%
% Inputs
%  err - nTrial x nChannel matrix of offset estimate errors (ms)
%  trial - (Optional) Indexing labels corresponding to `offset` rows
%  channel - (Optional) Indexing labels corresponding to `offset` columns
%  (Optional) : Offset -- True (groundtruth known) offset for each trial
%  (Optional) : offset -- offset matrix used to create `err`
%  (Optional) : offset_trials -- By-trial returned estimates from all
%                 channel correlations
%
% Output
%  fig - Figure handle
%
% See Also: data.process.estimate_channel_offset

if nargin < 2
   trial = 1:size(err,1);
else
   if size(err,1) ~= numel(trial)
      error(['Clean:' mfilename ':BadInputSize'],...
      ['\n\t->\t<strong>[DATA.EXAMPLE.PLOT_CHANNEL_OFFSET_ERRORS]:</strong> ' ...
       '`err` must have %g rows (same as # elements of `trial`)\n'],...
       numel(trial));
   end
end

if nargin < 3
   channel = 1:size(err,2);
else
   if size(err,2) ~= numel(channel)
      error(['Clean:' mfilename ':BadInputSize'],...
      ['\n\t->\t<strong>[DATA.EXAMPLE.PLOT_CHANNEL_OFFSET_ERRORS]:</strong> ' ...
       '`err` must have %g columns (same as # elements of `channel`)\n'],...
       numel(channel));
   end
end

err = sqrt(err.^2);

fig = figure(...
   'Name','Offset Error (By Channel & Trial)',...
   'Color','w',...
   'NumberTitle','off',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8]...
   );
if nargin > 3
   ax = subplot(2,2,[1,2]);
   set(ax,...
      'NextPlot','add',...
      'Color','none','XColor','k','YColor','none','TickDir','out',...
      'YTick',[],'XTick',channel,'FontName','Arial','LineWidth',1.5,...
      'CLim',[0 60]);
else
   ax = axes(fig,...
      'NextPlot','add',...
      'Color','none','XColor','k','YColor','k','TickDir','out',...
      'YTick',trial,'XTick',channel,'FontName','Arial','LineWidth',1.5);
end
imagesc(ax,channel,trial,err);
colormap(ax,'jet');
cbar = colorbar(ax);
cbar.Label.FontSize = 12;
cbar.Label.FontName = 'Arial';
cbar.Label.Color = 'k';
cbar.Label.String = 'RS Error';
cbar.Limits = [0 60];
xlim(ax,[0.5 channel(end)+0.5]);
xlabel('Channel','FontName','Arial','Color','k');
ylim(ax,[0 trial(end)+1]);
ylabel('Trial','FontName','Arial','Color','k');
title('Offset Error (By Channel & Trial)');

if nargin <= 3
   return;
end

RECON_PCS = 5:min(10,channel(end));

[coeff,score,~,~,explained,mu] = pca(offset');

ax = subplot(2,2,3);
ax.NextPlot = 'add';
ax.XColor = 'k';
ax.YColor = 'k';
ax.LineWidth = 1.5;
var_capt = cumsum(explained);
xlabel(ax,'PCs','FontName','Arial','Color','k');
ylabel(ax,'% Variance Explained','FontName','Arial','Color','k');
patch(ax,'XData',[0 0 channel(end)+1 channel(end)+1],...
   'YData',[0 var_capt(RECON_PCS(1)) var_capt(RECON_PCS(1)) 0],...
   'EdgeColor','none',...
   'FaceColor','r',...
   'FaceAlpha',0.33,...
   'DisplayName','Large Noise Component');
patch(ax,'XData',[RECON_PCS(1) RECON_PCS(1) RECON_PCS(end) RECON_PCS(end)],...
   'YData',[var_capt(RECON_PCS(1)) var_capt(RECON_PCS(end)) ...
            var_capt(RECON_PCS(end)) var_capt(RECON_PCS(1))],...
   'EdgeColor','none',...
   'FaceColor','y',...
   'FaceAlpha',0.5,...
   'DisplayName','Retained Components');
patch(ax,'XData',[0 0 channel(end)+1 channel(end)+1],...
   'YData',[var_capt(RECON_PCS(end)) 110 110 var_capt(RECON_PCS(end))],...
   'EdgeColor','none',...
   'FaceColor','k',...
   'FaceAlpha',0.15,...
   'DisplayName','Small Noise Component');
stem(1:numel(explained),var_capt,'Color','k','LineWidth',1.5,...
   'DisplayName','Channel Offset PCs');
line(ax,channel(RECON_PCS),var_capt(RECON_PCS),'LineStyle','none',...
   'Marker','o','MarkerFaceColor','b','MarkerEdgeColor','none',...
   'DisplayName','Reconstruction PCs');
ylim(ax,[0 105]);
xlim(ax,[0 channel(end)+1]);
legend(ax,'Location','southeast');

offset_recon = (score(:,RECON_PCS) * coeff(:,RECON_PCS)' + mu)';
err_recon = offset_recon - repmat(Offset,1,size(offset_recon,2));
ax = subplot(2,2,4);
ax.NextPlot = 'add';
ax.XColor = 'k';
ax.YColor = 'k';
ax.LineWidth = 1.5;
ax.YAxisLocation = 'right';
bar(ax,channel,[rms(err,1); rms(err_recon,1)]); 
legend(ax,{'Error','Error_{reconstructed}'},'Location','best');
line(ax,[0 channel(end)+1],ones(1,2).*rms(Offset-offset_trials),...
   'Color','k','LineWidth',2,'LineStyle',':',...
   'DisplayName','By-Trial Average');
xlabel(ax,'Channel','FontName','Arial','Color','k');
ylabel(ax,'RMS Error','FontName','Arial','Color','k');
title(ax,'Channel Average RMS Error','FontName','Arial','Color','k');

end