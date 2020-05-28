function fig = plot_channel_overlay(channel,varargin)
%PLOT_CHANNEL_OVERLAY Plot individual "trial" trace overlays
%
%   fig = data.example.plot_channel_overlay(channel,varargin);
%   fig = data.example.plot_channel_overlay(channel,tag,varargin);
%
%   -- Inputs --
%   channel : Index of channel to match using `.iChannel` table var
%   tag : Title tag for plot (optional)
%   varargin : Any number of tables, e.g.
%   ```
%       % Here, X1, X2, X3 may be 3 different tables:
%       fig = data.example.plot_channel_overlay(2,X1,X2,X3);
%   ```
%
%   -- Output --
%   fig : Figure handle

% Hard-coded parameters %
o = 0.25; % offset == "width" of each patch
face_alpha = 0.15; % transparency --> 1 is opaque 0 is transparent
edge_alpha = 0.25;

if ischar(varargin{1})
    tag = sprintf('Channel-%02g Overlay: %s',channel,varargin{1});
    varargin(1) = []; % Remove this element from varargin array
else
    tag = sprintf('Channel-%02g Overlay',channel);
end

fig = figure(...
   'Name',tag,...
   'Color','w',...
   'NumberTitle','off',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8]...
   ); 
nTable = numel(varargin);
for iV = 1:nTable
    ax = subplot(nTable,1,iV);
    ax.NextPlot = 'add';
    
    v = varargin{iV}(varargin{iV}.iChannel==channel,:);
    u = v.Properties.UserData;
    mask = u.samples_mask;
    t_plot = u.t(mask);
    t = ([t_plot, fliplr(t_plot)]).'; % X
    F = [1:numel(t), 1];
    hg = hggroup(ax,'DisplayName',u.plot_params{4});
    for iTrial = 1:size(v,1)
        rate = ([v.Rate(iTrial,:)+o, fliplr(v.Rate(iTrial,:))-o]).';
        V = [t, rate];
        hp = patch(hg,'Faces',F,'Vertices',V,...
           'FaceColor',u.plot_params{2},...
           'FaceAlpha',face_alpha,...
           'EdgeColor',u.plot_params{2},...
           'EdgeAlpha',edge_alpha);
        hp.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end 
    hg.Annotation.LegendInformation.IconDisplayStyle = 'on';
    F = data.process.recover_factors(varargin{iV},channel);% Original trace
    mu = mean(v.Rate,1);% Average trace of simulated trials
    f = F(mask);% Truncate to same times as "trials"    
    
    % Add both traces to axes
    line(ax,t_plot,f,... 
        'Color','r','LineWidth',1.5,'LineStyle','-',...
        'DisplayName','Original');
    line(ax,t_plot,mu,... 
        'Color','b','LineWidth',1.5,'LineStyle',':',...
        'DisplayName','Average');
    legend(ax,'Location','best');
    xlabel(ax,'Time (ms)',...
       'FontName','Arial','Color','k');
    ylabel(ax,'IFR (spikes/Sec)',...
       'FontName','Arial','Color','k');
    ub = max(f)*1.25;
    y_lim = [-2 ub];
    ax.YTick = round(linspace(0,ub,3));
    ylim(ax,y_lim);
    title(sprintf('%s: %s',strrep(u.Descriptor,'_',' '),u.Tag),...
       'FontName','Arial','Color','k');
end
suptitle(tag);

end
