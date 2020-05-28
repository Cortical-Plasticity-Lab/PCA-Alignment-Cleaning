function [offset,trial,channel] = estimate_channel_offset(T,trial,channel,mu,lag,period)
%ESTIMATE_CHANNEL_OFFSET Estimate individual trial/channel misalignment
%
%  <strong>Note:</strong> 
%     Takes ~5 minutes to run for table with 8 channels and 70 trials, when 
%     evaluating all trial & channel combinations.
%
%  offset = data.process.estimate_channel_offset(T);
%  offset = data.process.estimate_channel_offset(T,trial,channel);
%  offset = data.process.estimate_channel_offset(__,mu,lag,period);
% [offset,trial,channel] = data.process.estimate_channel_offset(T,...);
%
% Inputs
%  T - Data table where T.Properties.UserData.Type = 'channels'
%  trial - Trial index or indices (if not given, runs for all trials)
%  channel - Channel index or indices (if not given, runs for all channels)
%  -- The following args not usually supplied by user --
%  mu - (Optional) Matrix where rows are channels and columns are samples
%           of each cross-trial channel average
%  lag - (Optional) Maximum lag (samples) for computing correlation
%  period - (Optional) Sampling period (samples) on correlation offset
%              function
%
% Output
%  offset - Trial alignment offset estimate (in samples)
%              note: T.Rate & mu should be at same sample rate
%  trial - Index of trial used; elements match rows of `offset`
%  channel - Index of channel used; elements match columns of `offset`

if nargin < 2
   trial = unique(T.Trial);
end

if nargin < 3
   channel = unique(T.iChannel);
end

if nargin < 4
   G = findgroups(T(:,'iChannel'));
   mu = cell2mat(splitapply(@(rate){mean(rate,1)},T.Rate,G));
else
   if size(mu,1) ~= numel(channel)
      mu = mu.'; % Just in case
      if size(mu,1) ~= numel(channel)
         error(['Clean:' mfilename ':BadInputSize'],...
            ['\n\t->\t<strong>[DATA.PROCESS.ESTIMATE_OFFSET]:</strong> ' ...
             '`mu` must have same # rows as unique T.iChannel elements (%g)'],...
             numel(unique(T.iChannel)));
      end
   end
end

if nargin < 5
   [lag,period] = default.experiment('corr_max_lag','corr_period');
elseif nargin < 6
   period = default.experiment('corr_period');
end

if numel(trial) > 1
   offset = nan(numel(trial),numel(channel));
   trialTic = tic;
   for iTrial = 1:numel(trial)
      fprintf(1,'\t->\t<strong>%s::Trial-%03g</strong>...',...
         T.Properties.UserData.Descriptor,iTrial);
      offset(iTrial,:) = data.process.estimate_channel_offset(T,...
         trial(iTrial),channel,mu,lag,period);
      fprintf(1,'complete (%g seconds)\n',toc(trialTic));
   end
   return;
end

if numel(channel) > 1
   offset = nan(1,numel(channel));
   for iChannel = 1:numel(channel)
      offset(1,iChannel) = data.process.estimate_channel_offset(T,...
         trial,channel(iChannel),mu(iChannel,:),lag,period);
   end
   return;
end

% Reduce table subset to single trial
T = T((T.Trial==trial) & (T.iChannel==channel),:);
a = ((T.Rate - mean(T.Rate,2))./std(T.Rate,[],2)).';
b = ((mu - mean(mu,2))./std(mu,[],2)).';

k = size(a,1); % Total number of samples
idx = 1:k; % Get initial indexing vector
utils.addHelperRepos(); % Ensures `math` package on path

% % First, do "Coarse" estimate % %
orig_vec = (lag+1):(k-lag); % Indices of "fixed" comparator
n = numel(orig_vec); % Number of samples per window
ov = n - period; % Each window overlaps this much
B = b(orig_vec,:); % "Original" for comparison
I = math__.chunkVector2Matrix(idx,n,ov);
offset_vec = I(1,:) - orig_vec(1); % Offset for each "column"

% Pare down total number of comparisons
iKeep = abs(offset_vec) <= lag; % Find correct subset of offsets
offset_vec = offset_vec(1,iKeep);  % Reduce to correct subset of offsets
I = I(:,iKeep); % Reduce to correct subset of indexing matrix
nOffset = numel(offset_vec);

c = zeros(1,nOffset);
for iOffset = 1:nOffset
   A = a(I(:,iOffset),:);
   C = cov(A,B);
   c(iOffset) = C(1,2);
end

[~,iCoarse] = max(c);
offset = -offset_vec(iCoarse);

end