function [N,R] = noise(varargin)
%NOISE Create struct of Zero-Mean White Gaussian Noise distributions
%
%  [N,R] = data.sim.noise(varargin);
%  e.g.
%  >> [N,R] = data.sim.noise('D1',sd_jit1,sd_rate1,'D2',sd_jit2,sd_rate2);
%     * Result: struct e.g. N.Low.jitter ~ N(0,sd_jit1); % etc.
%
%  -- Inputs --
%  varargin : Repeated list as:
%  * arg1 : Fieldname (tag of distribution type)
%  * arg2 : Standard deviation of jitter noise for this distribution
%  * arg3 : Standard deviation of rate noise for this distribution
%
%  -- Output --
%  N : Noise struct with pdf objects for sub-fields of tagged "labeled"
%        main fields.
%  R : Distribution for adding in regularization noise

N = struct;
for iV = 1:3:numel(varargin)
   N.(varargin{iV}) = struct;
   N.(varargin{iV}).jitter = makedist(...
      'Normal','mu',0,...
      'sigma',varargin{iV+1});
   N.(varargin{iV}).rate = makedist(...
      'Normal','mu',0,...
      'sigma',varargin{iV+2});
      
end
R = makedist('Normal',...
   'mu',0,...
   'sigma',default.experiment('sigma_regularizer'));
end

