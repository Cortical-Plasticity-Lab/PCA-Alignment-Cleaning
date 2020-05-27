function varargout = clean_factors(varargin)
%CLEAN_FACTORS Apply `factoran` cleaning
%
%  C = data.process.clean_factors(Z,nFactor);
%  [C1,C2,...,Ck] = data.process.clean(Z1,Z2,...,Zk,nFactor);
%
%  -- Inputs --
%  Z : Table where rows are channels and trials have been concatenated
%        -> `Z = data.process.concat_trials(Y);`
%  nFactor : (Optional) Scalar; # of factor analysis factors
%
%  -- Output --
%  C : Table of "cleaned" spike rates, where individual rows are once again
%        split by trial and channel.

iComponent = cellfun(@isnumeric,varargin);
if ~any(iComponent)
   nFactor = default.experiment('n_factor');
else
   nFactor = varargin{iComponent};
   varargin(iComponent) = [];
end
if numel(varargin) > 1
   varargout = cell(1,numel(varargin));
   for iV = 1:numel(varargin)
      varargout{iV} = data.process.clean_factors(varargin{iV},nFactor);
   end
   return;
end

Z = varargin{:};
u = Z.Properties.UserData;
iTrial = u.iTrial;
% [coeff,score,~,~,explained,mu] = pca(Z.Rate.');
% [coeff,score,~,~,~,mu] = pca(Z.Rate.');

R = cov(Z_high.Rate.'); % Get covariance matrix
[lambda,psi,T,~,F] = factoran(R,nFactor,'xtype','cov');
Xr = data.process.reconstruct(score,coeff,mu,nComponents);

uCh = unique(Z.iChannel);
nCh = numel(uCh);

nTrial = max(max(iTrial));

iChannel = expand(Z.iChannel,nTrial);
iFactor = expand(Z.iFactor,nTrial);
wFactor = expand(Z.wFactor,nTrial);
oFactor = expand(Z.oFactor,nTrial);
sFactor = expand(Z.sFactor,nTrial);

Offset = cell2mat(Z.Offset);

nSample = numel(u.t_plot);
Rate = [];
for iCh = 1:nCh
   rate = reshape(Xr(iCh,:).',nSample,nTrial).';
   Rate = [Rate; rate]; %#ok<AGROW>
end

Trial = repmat((1:nTrial).',nCh,1);

C = table(Trial,iFactor,wFactor,oFactor,sFactor,iChannel,Offset,Rate);
C.Properties.UserData = u;
C.Properties.UserData.Type = 'channels';
C.Properties.UserData.plot_params{4} = ...
   sprintf('%s | %g PCs',C.Properties.UserData.plot_params{4},nComponents);
varargout = {C};

   function out = expand(in,nTrial)
      out = in.';
      out = repmat(out,nTrial,1);
      out = out(:);
   end

end