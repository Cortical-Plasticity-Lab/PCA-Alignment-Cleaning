function Xr = reconstruct(Score,Coeff,Mu,nComponents)
%RECONSTRUCT  Reconstruct data from Scores, Coefficients, and Offsets
%
%  Xr = data.process.reconstruct(Score,Coeff,Mu);
%     -> Default `nComponents` is size(Score,1);
%  
%  Xr = data.process.reconstruct(Score,Coeff,Mu,nComponents);
%     -> Uses the top nComponents PCs in reconstruction.

if nargin < 4
   nComponents = default.experiment('n_component');
end
S = Score(:,1:nComponents);
coeff = Coeff(:,1:nComponents)';
Xr = (S*coeff + Mu).';
end
