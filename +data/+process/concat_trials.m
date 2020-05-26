function varargout = concat_trials(varargin)
%CONCAT_TRIALS Concatenate trials along channels for smoothed dataset
%
%  Z = data.process.concat_trials(Y);
%  [Z1,Z2,...,Zk] = data.process.concat_trials(Y1,Y2,...,Yk);
%
%  -- Inputs --
%  Y : Data table from `Y = data.process.smooth(X);`
%
%  -- Output --
%  Z : Data table where each row is a different channel with all trials

if numel(varargin) > 1
   varargout = cell(1,numel(varargin));
   for iV = 1:numel(varargin)
      varargout{iV} = data.process.concat_trials(varargin{iV});
   end
   return;
end
Y = varargin{:};
[G,Z] = findgroups(Y(:,'iChannel'));
Z.iFactor = splitapply(@(f)f(1),Y.iFactor,G);
Z.wFactor = splitapply(@(f)f(1),Y.wFactor,G);
Z.oFactor = splitapply(@(f)f(1),Y.oFactor,G);
Z.sFactor = splitapply(@(f)f(1),Y.sFactor,G);
Z.Offset = splitapply(@(offset){offset},Y.Offset,G);
[Rate,iTrial] = splitapply(@(r,idx)rate_concat(r,idx),Y.Rate,Y.Trial,G);
Z.Rate = cell2mat(Rate);
Z.Properties.Description = 'Table of trials concatenated by channel';
Z.Properties.UserData = Y.Properties.UserData;
Z.Properties.UserData.Type = 'trials';
Z.Properties.UserData.iTrial = cell2mat(iTrial);
varargout = {Z};

   function [data_out,iTrial] = rate_concat(data_in,iTrial)
      %RATE_CONCAT  Concatenate rate trials
      %
      %  [data_out,iTrial] = rate_concat(data_in,iTrial);
      
      iTrial = repmat(iTrial.',size(data_in,2),1);
      iTrial = iTrial(:);
      iTrial = {iTrial.'};
      
      X = data_in.'; % Flip input matrix so that time is rows
      X = X(:);         % This concatenates in the correct dimension
      data_out = {X.'}; % Flip it back so it is a row (and return as cell)
   end

end