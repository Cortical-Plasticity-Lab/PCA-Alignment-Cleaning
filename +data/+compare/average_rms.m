function [err,channel] = average_rms(T,channel)
%AVERAGE_RMS Returns RMS difference between trials average & original
%
% err = data.compare.average_rms(T);
% [err,channel] = data.compare.average_rms(T,channel);
%
% Inputs
%  T - Data table where T.Properties.UserData.Type == 'channels'
%  channel - Channel index to return RMS error for. If not specified,
%              returns `err` as a vector for each channel.
%
% Output
%  err - RMS difference between cross-trial average for a single channel
%           and the original factor profile used to generate trial rates.
%           If multiple channels used, then this is a vector matching the
%           size of channel.
%  channel - Optional output that indicates channel index for corresponding
%              elements of `err` (for convenience).

if nargin < 2
   channel = unique(T.iChannel);
end

if numel(channel) > 1
   err = nan(size(channel));
   for iCh = 1:numel(channel)
      err(iCh) = data.compare.average_rms(T,channel(iCh));
   end
   return;
end

u = T.Properties.UserData;
mask = u.samples_mask;
F = data.process.recover_factors(T,channel);% Original trace
mu = mean(T.Rate(T.iChannel==channel,:),1);% Average trace of simulated trials
f = F(mask);% Truncate to same times as "trials"  
err = rms(f - mu);

end