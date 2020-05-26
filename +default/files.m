function varargout = files(varargin)
%FILES Return default parameters associated with files
%
%  param_struct = default.files();
%  default.files('param_name'); % Print to command window
%  param = default.files('param_name');
%  [v1,v2,...,vk] = default.files('v1_name','v2_name',...,'vk_name');

p = struct;
% % Main file-name parameters go here % %
p.delimiter = '_';
p.fig_output_path = '../Figures/PCA-Alignment-Cleaning'; % Outside repo
p.data_output_path = '../Data/PCA-Alignment-Cleaning';   % Outside repo

% % Defaults for simulation input files % %
p.sim_source = 'input/SmoothedFactors';
p.sim_granularity = 'Fine';
p.sim_filetype = '.mat';

% % Defaults for figures % %
p.fig_ai_filetype = '.eps';

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
            fprintf('<strong>%s</strong>:',F{idx});
            disp(p.(F{idx}));
         end
      end
   end
end

end