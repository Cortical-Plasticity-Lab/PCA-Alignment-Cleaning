function fig = plot_sim_avg(varargin)
%PLOT_SIM_AVG  Plot simulated rate averages
%
%   fig = data.example.plot_sim_avg(varargin);
%
%   Example:
%   fig = data.example.plot_sim_avg(X_low,X_med,X_high);

% % Hard-coded graphics objects parameters % %
orig_line_params = {'Color','r','LineWidth',1.5,'DisplayName','original'};
axes_params = {'NextPlot','add','XColor','k','YColor','k','FontName','Arial'};
font_params = {'Color','k','FontName','Arial'};

% Parse the channel indices to use %
all_channels = [];
for iV = 1:numel(varargin)
    cur_channels = unique(varargin{iV}.iChannel);
    all_channels = union(all_channels, reshape(cur_channels,1,numel(cur_channels)));
end
all_channels(isnan(all_channels)) = [];
all_channels = reshape(all_channels,1,numel(all_channels));

% Iterate on each channel
fig = figure(...
   'Name','Average Factors by Channel',...
   'Color','w',...
   'NumberTitle','off',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8]); 
nRow = floor(sqrt(max(all_channels)));
nCol = ceil(max(all_channels)/nRow);
y_lim = [inf, -inf];
ax = gobjects(size(all_channels));
for iChannel = all_channels
    thisLabel = sprintf('Channel-%g Comparison',iChannel);
    ax(iChannel) = subplot(nRow,nCol,iChannel);
    set(ax(iChannel),axes_params{:});
    if iChannel == max(all_channels)
        legend(ax(iChannel),'Location','best');
    end
    title(ax(iChannel),thisLabel,font_params{:}); 
    if iChannel > (nCol * (nRow-1))
        xlabel(ax(iChannel),'Time (ms)',font_params{:}); 
    end
    if rem(iChannel,nCol)==1
        ylabel(ax(iChannel),'IFR (spikes/sec)',font_params{:});
    end
    for iV = 1:numel(varargin)
        idx = varargin{iV}.iChannel == iChannel;
        if sum(idx)==0
            continue;
        end
        v = varargin{iV}(idx,:); % Current data matrix
        u = v.Properties.UserData;  % Current data matrix UserData property
        plot(ax(iChannel),u.t_plot,mean(v.Rate,1),u.plot_params{:});
    end
    % Add "Original" line to plot as well.
    f = data.process.recover_factors(varargin{iV},iChannel);
    plot(ax(iChannel),u.t_plot,f(u.samples_mask),orig_line_params{:});
    y_lim = [min(y_lim(1),ax(iChannel).YLim(1)), max(y_lim(2),ax(iChannel).YLim(2))];
end

for iChannel = all_channels
   ax(iChannel).YLim = y_lim;
end

end