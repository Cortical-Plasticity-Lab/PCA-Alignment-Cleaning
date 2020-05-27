function x = rate(t,t_lim,factors,combo,N,t_shift,plot_params)
%RATE Simulates individual "channel" spike rate using factor & noise
%
%  x = data.sim.rate(t,t_lim,factors,combo,N,t_shift);
%  x = data.sim.rate(__,plot_params);
%
%  -- Inputs --
%  t        :  Times of each sample in `factor`
%  t_lim    :  Lower and upper bounds on times to keep as sampled
%  factors  :  Underlying "factors" generating observed spike rate
%  combo    :  Struct with factor combo information in fields
%  N        : Struct with fields containing Normal pdf for noise sources.
%                 * 'jitter' and 
%                 * 'rate' 
%  t_shift  : Jitter for the number of trials to replicate this process
%  -- (Optional) --
%  plot_params : Cell array of 'Name', value pairs for modifying `lines`
%                    associated with this set of simulations.
%
%  -- Output --
%  x        :  Simulated rates for a given channel over `nTrials`
%                 Dimensions will be: 
%                 [nTrials x nTimesteps]
%                 * nTimesteps ~ Number of samples bounded by 
%                    t_bounds(1) <= t < t_bounds(2)

if nargin < 7
   plot_params = {};
end

if numel(combo) > 1
   % Iterate on each struct element in `combo` which contains different
   % `factor` groupings and weightings etc.
   x = table.empty();
   for ii = 1:numel(combo)
      x = [x; ...
         data.sim.rate(t,t_lim,factors,combo(ii),N,t_shift,plot_params)]; %#ok<AGROW>
   end
   return;
end

nTrials = numel(t_shift);

% Get the total number of masked samples that should be present
samples_mask = (t >= t_lim(1)) & (t < t_lim(2));

% Get total number of samples in mask and original for replicates
nSamples_mask = sum(samples_mask);
nSamples_orig = size(factors,2);

% Expand matrix for original times, which will be added to
t_orig = repmat(t',1,nTrials);

% Induce time-shift due to "misalignment" of data to actual time
t_align = t_orig + t_shift;

% Retrieve equal number of samples for each "trial" after misalignment
times_mask = (t_align >= t_lim(1)) & (t_align < t_lim(2)); 
% Make sure it is equal for each trial:
iInvalid = sum(times_mask,1)~=nSamples_mask;
while any(iInvalid) 
   t_shift(iInvalid) = random(N.jitter,[1,sum(iInvalid)]);
   t_align(:,iInvalid) = t_orig(:,iInvalid) + t_shift(iInvalid);
   times_mask = (t_align >= t_lim(1)) & (t_align < t_lim(2)); 
   iInvalid = sum(times_mask,1)~=nSamples_mask;
end
t_apparent = reshape(t_orig(times_mask),nSamples_mask,nTrials).';
Offset = t_apparent(:,1) - t_lim(1);

% Get the factor vector to be used for this trial
[w,o,s,i_factor,i_channel] = combo_2_vars(combo);
f = data.transform_factors(factors(i_factor,:),w,o,s).';

% Compute the Poisson rate for each trial
wg_process_noise = random(N.rate,[nSamples_orig,nTrials]);
rate = poissrnd(repmat(f,1,nTrials)) + wg_process_noise;
 
% Only retain the misaligned segment of each Poisson rate series
Rate = reshape(rate(times_mask),nSamples_mask,nTrials).';

% Create a table to organize all the data.
Trial = (1:nTrials).';
iFactor = repmat({i_factor},nTrials,1); 
wFactor = repmat({w},nTrials,1);
oFactor = repmat({o},nTrials,1);
sFactor = repmat({s},nTrials,1);
iChannel = repmat(i_channel,nTrials,1); 

x = table(Trial,iFactor,wFactor,oFactor,sFactor,iChannel,Offset,Rate);
x.Properties.Description = 'Simulated Rates';
x.Properties.UserData.Type = 'channels';
x.Properties.UserData.factors = factors;
x.Properties.UserData.t = t;
x.Properties.UserData.t_bounds = t_lim;
x.Properties.UserData.samples_mask = samples_mask;
x.Properties.UserData.t_plot = t(samples_mask);
x.Properties.UserData.plot_params = plot_params;
x.Properties.VariableUnits = ...
   {'Index','Index','Weight Coeff','Offset Coeff','Scaling Coeff',...
    'Index','ms','Spikes/Sec'};

   function [w,o,s,i_factor,i_channel] = combo_2_vars(combo)
      %COMBO_2_VARS  Return fields of `combo` input as variables
      %
      %  [w,o,s,i_factor,i_channel] = combo_2_vars(combo);
      
      w = combo.w;
      o = combo.offset;
      s = combo.scaling;
      i_factor = combo.indices;
      i_channel = combo.channel;
   end

end