function [factors,t,mask] = load_factors(src,gran,type,delim)
%LOAD_FACTORS  Load factor dataset and scale
%
%  [factors,t,mask] = data.io.load_factors(src,gran,type,delim);
%
%  -- Inputs --
%  src   : `defaults.files('sim_source');`
%  gran  : `defaults.files('sim_granularity');`
%  type  : `defaults.files('sim_filetype');
%  delim : `defaults.files('delimiter');
%
%  -- Output --
%  [factors,t] : Scaled factors for generating rate, and matching times for
%                 each column of factors matrix (rows are factors).
%  mask        : (Optional) Mask vector for "aligned" region of interest
%                          (in terms of vector of relative event-aligned
%                          times to keep).

if nargin < 4
   delim = default.files('delimiter');
end

if nargin < 3
   type = default.files('sim_filetype');
end

if nargin < 2
   gran = default.files('sim_granularity');
end

if nargin < 1
   src = default.files('sim_source');
end

in = load([src delim gran type],'factors','t');
t = in.t;
factors = in.factors;
if nargout > 2
   mask = default.experiment('mask');
end

end
