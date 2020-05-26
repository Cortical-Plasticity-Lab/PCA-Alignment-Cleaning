function [f,channel] = recover_factors(X,channel)
%RECOVER_FACTORS Recover original factor for a channel from data table X
%
%  f = data.recover_factors(X,channel);
%
%  -- Inputs --
%  X : Data table of UserData.type == 'channels' with simulated rates
%  channel : Index of channel to recover factor for
%
%  -- Output --
%  f : Recovered original factor used for inhomogeneous Poisson rate
%      generation.
%  channel : (Optional) Channels corresponding to rows of `f`; if multiple
%              channels were specified, then this gives the channels that
%              correspond to rows of returned factors.

if nargin < 1
   channel = unique(X.Channel);
end

if numel(channel) > 1
   f = nan(numel(channel),size(X.Properties.UserData.t,2));
   for iCh = 1:numel(channel)
      f(iCh,:) = data.recover_factors(X,channel(iCh));
   end
   return;
end

u = X.Properties.UserData;
v = X(X.iChannel==channel,:);
f = data.transform_factors(...
      u.factors(v.iFactor{1},:),...
      v.wFactor{1},...
      v.oFactor{1},...
      v.sFactor{1});
end