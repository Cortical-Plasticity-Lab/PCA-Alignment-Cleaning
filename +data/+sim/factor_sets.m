function factor_combinations = factor_sets(nChannels,K,n,o,s)
%FACTOR_SETS Returns `nChannels` struct array of factor indices & weights
%
%  factor_combinations = data.sim.factor_sets(nChannels);
%  factor_combinations = data.sim.factor_sets(__,K,n);
%
%  -- Inputs --
%  nChannels    :  Total number of channels of combinations to create
%  K :  (Optional) Maximum # factors on any given channel 
%                       --> (if unspecified == 4)
%  n : (Optional) Highest possible factor index (total # factors)
%                       --> (if unspecified == 4)
%  o : (Optional) Offsets corresponding to each factor
%  s : (Optional) Scalar coefficient for each factor
%
%  -- Output --
%  factor_combinations : Struct array of dimension [nChannels x 1] with
%                          fields:
%                    * 'indices'  : Index or indices of factors to use
%                    * 'w'        : Weights for each factor (matches
%                                      'indices' elements)

if nargin < 4
   [o,s] = default.experiment('factor_offset','factor_scale');
elseif nargin < 5
   s = default.experiment('factor_scale');
end

if nargin < 3
   n = 4;
end

if nargin < 2
   K = 4;
end
utils.addHelperRepos(); % Add this in at start of simulations
factor_combinations = struct(...
   'indices',cell(nChannels,1),...
   'w',cell(nChannels,1),...
   'offset',cell(nChannels,1),...
   'scaling',cell(nChannels,1),...
   'channel',cell(nChannels,1)...
   );

for iChannel = 1:nChannels
   k = randi(K,1);
   iThis = randperm(n,k);
   factor_combinations(iChannel).indices = iThis;
   factor_combinations(iChannel).w = softmax(rand(k,1)).';
   factor_combinations(iChannel).offset = o(iThis);
   factor_combinations(iChannel).scaling = s(iThis);
   factor_combinations(iChannel).channel = iChannel;
end

end