function varargout = smooth(varargin)
%SMOOTH Reorganize data table as new "smoothed by trial" table
%
%  Y = data.process.smooth(X);
%  [Y1,Y2,...,Yk] = data.process.smooth(X1,X2,...,Xk);
%  data.process.smooth(__,'order',ord,'framelen',len,'weights',w);
%
%  -- Inputs --
%  X : Table returned by `X = data.sim.rate(...);`
%     ---
%  (Optional) -- Set using 'name',value syntax
%     ---
%     order : Polynomial order for Savitzky-Golay filter applied to .Rate
%     framelen : Length of window frame for Savitzky-Golay filter
%     weights : Sample weightings throughout SG filter window. 
%
%  -- Output --
%  Y : Similar to `X`, except that elements of `Rate` variable are smoothed
%        using a Savitzky-Golay filter (function handle in
%        .Properties.UserData.SmoothFcn)

pars = struct;
[pars.order,pars.framelen,pars.weights] = default.experiment(...
         'smooth_order','smooth_framelen','smooth_weights');
iChar = find(cellfun(@ischar,varargin),1,'first');
if ~isempty(iChar)
   for iV = iChar:2:numel(varargin)
      pars.(lower(varargin{iV})) = varargin{iV+1};
   end
   varargout = cell(1,iChar-1);
else
   varargout = cell(size(varargin));
end

if numel(varargout) > 1
   for iV = 1:numel(varargout)
      varargout{iV} = data.process.smooth(varargin{iV},...
         'order',pars.order,...
         'framelen',pars.framelen,...
         'weights',pars.weights);
   end
   return;
end

X = varargin{1};
X.Rate = sgolayfilt(X.Rate,pars.order,pars.framelen,pars.weights,2);
X.Properties.UserData.SmoothFcn = ...
   @(Rate)sgolayfilt(Rate,pars.order,pars.framelen,pars.weights,2);
varargout{1} = X;

end

