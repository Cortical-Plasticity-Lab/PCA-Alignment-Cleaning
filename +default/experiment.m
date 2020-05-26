function varargout = experiment(varargin)
%EXPERIMENT Main default parameters associated with experiment
%
%  param_struct = default.experiment();
%  default.experiment('param_name'); % Print to command window
%  param = default.experiment('param_name');
%  [v1,v2,...,vk] = default.experiment('v1_name','v2_name',...,'vk_name');

p = struct;
% % Main experiment parameters go here % %
p.mask = [-1000  500]; % Allows jitter in timing
% p.n_component = 4;     % Default number of reconstruction components
p.var_capt = 99;

% % Parameter "grid" to sweep % %
p.all_sigmas_jitter = [  10,  30,  60]; % Jitter in alignment timing
p.all_sigmas_noise  = [0.01, 0.1, 0.5]; % Random noise on factors
p.all_factors       = [   2,   3,   4]; % Number of factors present 
p.all_num_channels  = [  16,  32,  64]; % Number of channels in data
p.all_num_trials    = [  20,  50, 100]; % Number of trials

% % For converting factors to rates % %
p.factor_offset = [0.75; 0.95; 0.80; 0.45];
p.factor_scale = [10; 20; 5; 15];

% % For smoothing simulated rates % %
p.smooth_order = 3;
p.smooth_framelen = 601;
p.smooth_weights = hamming(p.smooth_framelen).';

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