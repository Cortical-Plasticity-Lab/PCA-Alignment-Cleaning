function save_figure(fname,fig,save_fig,save_png,save_vec)
%SAVE_FIGURE Save figure to default output location
%
%  data.io.save_figure(fname,fig);
%  e.g.
%  >> data.io.save_figure(fname,fig);
%
%  data.io.save_figure(fname,fig,save_fig,save_png,save_vec);
%  -> `save_` options are all logical flags, which each defaults to `true`
%  if left unspecified. If set `false`, then that type of figure is not
%  saved (corresponds to Matlab *.fig; *.png; and *.eps or comparable
%  vectorized graphics format, respectively). Can be configured in
%  `default.io.save_figure_opts`.
%  
%  Save as many input variables as you want, specifying the filename only.
%  -> Specifying relative filename path on fname (e.g. 'Rate/Factors.fig')
%     will automatically create the output folder in the location specified
%     by `default.files('fig_output_path');`
%
%     * Default: '../Figures/PCA-Alignment-Cleaning';
%     * Default image output type: '.eps' (encapsulated post-script)

if isempty(fname)
   disp('`<strong>fname</strong>` empty. Skipped.');
   return;
end

if nargin < 3
   save_fig = true;
end

if nargin < 4
   save_png = true;
end

if nargin < 5
   save_vec = true;
end

% % Grab file path info % %
[p,f,~] = fileparts(fname);
[def_path,def_type] = default.files('fig_output_path','fig_ai_filetype');

% Make output path if needed %
out_path = fullfile(def_path,p);
if exist(out_path,'dir')==0
   mkdir(out_path);
end

% Parse full filename of output file %
filename = fullfile(out_path,f); % Leave off extension

% % Save as 3 types: .fig, .png, and [default image output type] % %
utils.addHelperRepos(); % Make sure utilities are on path
sounds__.play('pop',0.8,-15); % Notify of start save
savetic = tic;
fprintf(1,'\n\t-><strong>Saving</strong> %s',f);
if save_fig
   fprintf(1,'.fig...');
   savefig(fig,[filename '.fig']); % Save output .fig file
   sounds__.play('pop',0.933,-25);
   fprintf(1,'\b\b\b\b\b\b\b');
end
if save_png
   fprintf(1,'\b\b\b\b\b\b\b.png...');
   saveas(fig,[filename '.png']); % Save output .png file
   sounds__.play('pop',1.066,-15);
   fprintf(1,'\b\b\b\b\b\b\b');
end
if save_vec
   fprintf(1,'%s...',def_type);
   gfx__.expAI(fig,[filename def_type]);
   sounds__.play('pop',1.2,-5);
   str = ['\b\b\b' repmat('\b',1,numel(def_type))];
   fprintf(1,'%s',str);
end
[out_path_full_str,size_str] = get_file_info(filename);
fprintf(1,' <strong>complete</strong> (%g sec -- %s)\n',...
   toc(savetic),size_str);
fprintf(1,...
   '\t\t->(<a href="matlab:winopen(''%s'');"><strong>%s</strong></a>)\n',...
   out_path_full_str,out_path);

   function [out_path_full_str,size_str] = get_file_info(filename)
      %GET_FILE_INFO Parses full (non-relative) file path & file size
      %
      % [out_path_full_str,size_str] = get_file_info(filename);
      %
      % Inputs
      %  filename - Char array of full filename
      %
      % Output
      %  out_path_full_str - Char array of full output file folder
      %  size_str - Char array of file size (KB, MB, or GB as appropriate)
      
      F = dir([filename '*']);
      if isempty(F)
         error(['Helper:' mfilename ':FileMissing'],...
            'No file named <strong>''%s''</strong>\n',filename);
      end
      out_path_full_str = F(1).folder;
      s = sum([F.bytes]);
      % Create "tiers" that get different post-scripts
      if s > 1e9
         size_str = sprintf('Total: %.2f <strong>GB</strong>',s*1e-9);
      elseif s > 1e6
         size_str = sprintf('Total: %.2f MB',s*1e-6);
      else
         size_str = sprintf('Total: %.2f KB',s*1e-3);
      end
   end
end