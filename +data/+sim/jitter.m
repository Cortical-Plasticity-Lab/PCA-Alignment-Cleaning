function offset = jitter(N,nTrials)
%JITTER Simulate jitter for nTrials
%
%  offset = data.sim.jitter(N,nTrials);
%
%  -- Inputs --
%  N : Random Gaussian distribution with zero-mean
%        -> If given as a struct, output is returned as similar struct
%  nTrials : Number of trials to include
%
%  -- Output --
%  offset : 1 x nTrials vector of offsets

if isstruct(N)
   f = fieldnames(N);
   offset = struct;
   for iF = 1:numel(f)
      offset.(f{iF}) = random(N.(f{iF}).jitter,[1,nTrials]);
   end
else
   offset = random(N,[1,nTrials]); 
end
end