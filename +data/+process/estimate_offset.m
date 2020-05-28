function [offset,trial] = estimate_offset(T,trial,mu,lag,period)
%ESTIMATE_OFFSET Estimate individual trial alignment offsets
%
% offset = data.process.estimate_offset(T);
% offset = data.process.estimate_offset(T,trial);
% offset = data.process.estimate_offset(__,mu,lag,period);
% [offset,trial] = data.process.estimate_offset(...);
%
% Inputs
%  T - Data table where T.Properties.UserData.Type = 'channels'
%  trial - Trial index or indices (if not given, runs for all trials)
%  -- Following arguments not normally supplied by user --
%  mu - (Optional) Matrix where rows are channels and columns are samples
%           of each cross-trial channel average
%  lag - (Optional) Maximum lag (samples) for computing correlation
%  period - (Optional) Sampling period (samples) on correlation offset
%              function
%
% Output
%  offset - Trial alignment offset estimate (in samples)
%              note: T.Rate & mu should be at same sample rate
%  trial - Index of trial used; each element corresponds to an element of
%           `offset`, which is returned as a vector if multiple trials are
%           requested or if no trial input is given.

if nargin < 2
   trial = unique(T.Trial);
end

if nargin < 3
   G = findgroups(T(:,'iChannel'));
   mu = cell2mat(splitapply(@(rate){mean(rate,1)},T.Rate,G));
else
   if size(mu,1) ~= numel(unique(T.iChannel))
      error(['Clean:' mfilename ':BadInputSize'],...
         ['\n\t->\t<strong>[DATA.PROCESS.ESTIMATE_OFFSET]:</strong> ' ...
          '`mu` must have same # rows as unique T.iChannel elements (%g)'],...
          numel(unique(T.iChannel)));
   end
end

if nargin < 4
   [lag,period] = default.experiment('corr_max_lag','corr_period');
elseif nargin < 5
   period = default.experiment('corr_period');
end

% % Iterate on elements of `trial` indexing vector % %
if numel(trial) > 1
   offset = nan(size(trial));
   for iTrial = 1:numel(trial)
      offset(iTrial) = data.process.estimate_offset(T,trial(iTrial),mu,lag,period);
   end
   return;
end

% Reduce table subset to single trial
T = T(T.Trial==trial,:);
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

[~,iBest] = max(c);
% Return negative version to match sign convention of T.Offset
offset = -offset_vec(iBest);
end