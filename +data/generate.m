function X = generate(nChannels,nFactors,nTrials,sigma_jitter,sigma_noise)
%GENERATE Generate simulated dataset based on real data factors
%
%  X = data.generate(nChannels,... # "recording" channels in simulated data
%                    nFactors,...  # factors to sample from
%                    nTrials,...   # trials to simulate
%                    sigma_jitter,... jitter S.D. in trial alignment (ms)
%                    sigma_noise);  noise S.D. in spike rates (normed)
%  
%  -- Output --
%  X : Table of simulated data

% % Import default parameters % %
[source,granularity,filetype,delim] = default.files(...
   'sim_source','sim_granularity','sim_filetype','delimiter');

% % Load data % %
[factors,t] = data.load_factors(source,granularity,filetype,delim);
t_mask = default.experiment('mask');

N_jitter = makedist('Normal','mu',0,'sigma',sigma_jitter);
N_noise = makedist('Normal','mu',0,'sigma',sigma_noise);

x = generate.sim.rate(in.t,in.factors,t_mask,N_jitter,N_noise);


end