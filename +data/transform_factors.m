function factors = transform_factors(factors,w,o,s)
%TRANSFORM_FACTORS Apply offset and scaling to factors for Poisson process
%
%  factors = data.transform_factors(factors,w,o,s);
%
%  -- Inputs --
%  factors : Matrix where rows are normalized factors and columns = samples
%  w : (Optional) Weight coefficients. If only this is specified, `factors`
%                    returned will be [1 x nSamples] instead of [4 x
%                    nSamples].
%
%  -- Output --
%  factors : Shifted/scaled factors that will work as physiologically
%              plausible lambda for inhomogeneous Poisson process.

% Ensure correct orientation of weighting coefficients/scalar coefficients
w = reshape(w,numel(w),1);
o = reshape(o,numel(o),1);
s = reshape(s,numel(s),1);

o = sum(o .* w);
s = sum(s .* w);

factors = sum(factors .* w,1) + o; % Recombine factors
if min(factors) < 0 % Make sure that it is non-negative
   factors = factors - min(factors);
end
factors = factors .* s;

end