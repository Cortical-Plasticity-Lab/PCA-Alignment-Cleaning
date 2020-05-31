function varargout = experiment(varargin)
%EXPERIMENT Main default parameters associated with experiment
%
%  param_struct = default.experiment();
%  default.experiment('param_name'); % Print to command window
%  param = default.experiment('param_name');
%  [v1,v2,...,vk] = default.experiment('v1_name','v2_name',...,'vk_name');
%
% Current <strong>experiment</strong> parameters
%
%  mask = [-1000  500]; % Allows jitter in timing
%  n_component = 4;     % Default number of reconstruction components
%  var_capt = 99;       % Default proportion of variance captured by PCs
%  n_factor = 6;        % Default number of `factoran` factors
%
%  all_num_channels  = [  16,  32,  64]; % Number of channels in data
%  all_num_trials    = 15:5:30;    % Number of trials
%  all_factors       = 1:4;        % Number of factors present 
%  all_sigmas_jitter = 10:10:100;  % Jitter in alignment timing
%  all_sigmas_rate   = [1, 5, 10]; % Random noise on factors
%
%  factor_offset = [0.75; 0.95; 0.80; 0.45]; % Offsets for factor transform
%  factor_scale = [10; 20; 5; 15]; % Scale coeffs for factor transform
%
%  smooth_order = 3;       % Order of Savitzky-golay smooth filter
%  smooth_framelen = 601;  % Frame length of Savitzky-golay smooth filter
%  smooth_weights = hamming(p.smooth_framelen).'; % Weights of SG filter
% 
%  corr_max_lag = 150; % For offset correlation: maximum lag offset
%  corr_period = 30;   % For offset correlation: lag sample period

p = struct;
% % Main experiment parameters go here % %
p.mask = [-1000  500]; % Allows jitter in timing
p.n_component = 4;     % Default number of reconstruction components
p.var_capt = 99;       % Default proportion of variance captured by PCs
p.n_factor = 6;        % Default number of `factoran` factors

% % Parameter "grid" to sweep % %
p.all_num_channels  = [  16,  32,  64]; % Number of channels in data
p.all_num_trials    = 15:5:30;    % Number of trials
p.all_factors       = 1:4;        % Number of factors present 
p.all_sigmas_jitter = 10:10:100;  % Jitter in alignment timing
p.all_sigmas_rate   = [1, 5, 10]; % Random noise on factors

% % For converting factors to rates % %
p.factor_offset = [0.75; 0.95; 0.80; 0.45];
p.factor_scale = [10; 20; 5; 15];

% % For smoothing simulated rates % %
p.smooth_order = 3;
p.smooth_framelen = 601;
p.smooth_weights = hamming(p.smooth_framelen).';

% % For estimating offsets % %
p.corr_max_lag = 150;
p.corr_period = 1;
p.sigma_regularizer = 50;

% % % Display defaults (if no input or output supplied) % % %
if (nargin == 0) && (nargout == 0)
   disp(p);
   return;
end

% % % Parse output % % %
if nargin < 1
   varargout = {p};   
else
   F = fieldnames(p);   
   if (nargout == 1) && (numel(varargin) > 1)
      varargout{1} = struct;
      for iV = 1:numel(varargin)
         idx = strcmpi(F,varargin{iV});
         if sum(idx)==1
            varargout{1}.(F{idx}) = p.(F{idx});
         end
      end
   elseif nargout > 0
      varargout = cell(1,nargout);
      for iV = 1:nargout
         idx = strcmpi(F,varargin{iV});
         if sum(idx)==1
            varargout{iV} = p.(F{idx});
         end
      end
   else
      for iV = 1:nargin
         idx = strcmpi(F,varargin{iV});
         if sum(idx) == 1
            fprintf('\n\t<strong>%s</strong>:',F{idx});
            disp(p.(F{idx}));
         end
      end
   end
end

end