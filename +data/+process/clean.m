function varargout = clean(varargin)
%CLEAN Apply PCA cleaning
%
%  C = data.process.clean(Z);
%  C = data.process.clean(Z,varCapt);
%  [C1,C2,...,Ck] = data.process.clean(Z1,Z2,...,Zk,varCapt);
%
%  -- Inputs --
%  Z : Table where rows are channels and trials have been concatenated
%        -> `Z = data.process.concat_trials(Y);`
%  varCapt : (Optional) Scalar; [0-100] % variance explained by # PCs
%
%  -- Output --
%  C : Table of "cleaned" spike rates, where individual rows are once again
%        split by trial and channel.

iComponent = cellfun(@isnumeric,varargin);
if ~any(iComponent)
   varCapt = default.experiment('var_capt');
else
   varCapt = varargin{iComponent};
   varargin(iComponent) = [];
end
if numel(varargin) > 1
   varargout = cell(1,numel(varargin));
   for iV = 1:numel(varargin)
      varargout{iV} = data.process.clean(varargin{iV},varCapt);
   end
   return;
end

Z = varargin{:};
u = Z.Properties.UserData;
iTrial = u.iTrial;
[coeff,score,~,~,explained,mu] = pca(Z.Rate.');
% [coeff,score,~,~,~,mu] = pca(Z.Rate.');
nComponents = find(cumsum(explained)>=varCapt,1,'first');
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
Correction = u.Correction;
u = rmfield(u,'Correction');
AlignMask = u.AlignMask;
u = rmfield(u,'AlignMask');
Original = u.Original;
u = rmfield(u,'Original');
C = table(Trial,iFactor,wFactor,oFactor,sFactor,iChannel,Offset,Rate,Original,AlignMask,Correction);
C.Properties.UserData = u;
C.Properties.UserData.Type = 'channels';
C = utils.addTag(C,'Concat-Cleaned');
C.Properties.UserData.plot_params{4} = ...
   sprintf('%s | %g PCs',C.Properties.UserData.plot_params{4},nComponents);
varargout = {C};

   function out = expand(in,nTrial)
      out = in.';
      out = repmat(out,nTrial,1);
      out = out(:);
   end

end