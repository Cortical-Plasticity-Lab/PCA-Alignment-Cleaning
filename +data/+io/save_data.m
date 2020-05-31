function save_data(fname,varargin)
%SAVE_DATA Save data to default output location
%
%  data.io.save_data(fname,varargin);
%  e.g.
%  >> data.io.save_data(fname,X_low,X_high,Y_low,Y_high,Z_low,Z_high,...);
%  
%  Save as many input variables as you want, specifying the filename only.
%  -> Specifying relative filename path on fname (e.g. 'Rate/Dataset.mat')
%     will automatically create the output folder in the location specified
%     by `default.files('data_output_path');`
%
%     * Default: '../Data/PCA-Alignment-Cleaning';

if isempty(fname)
   disp('`<strong>fname</strong>` empty. Skipped.');
   return;
end

% % Grab file path info % %
[p,f,~] = fileparts(fname);
def_path = default.files('data_output_path');

% Make output path if needed %
out_path = fullfile(def_path,p);
if exist(out_path,'dir')==0
   mkdir(out_path);
end

% Parse full filename of output file %
filename = fullfile(out_path,[f '.mat']); % Force .mat extension

% % Aggregate inputs into "out" struct % %
out = struct;
for iV = 1:numel(varargin)
   out.(inputname(iV+1)) = varargin{iV};
end

% % Save using '-struct' syntax % %
utils.addHelperRepos();
savetic = tic;
sounds__.play('pop',0.8,-15); % Notify of start save
fprintf(1,'\n\t->Saving <strong>%s</strong>...',f);
save(filename,'-struct','out');
[out_path_full_str,size_str] = get_file_info(filename);
fprintf(1,'<strong>complete</strong> (%g sec -- %s)\n',...
   toc(savetic),size_str);
fprintf(1,...
   '\t\t->(<a href="matlab:winopen(''%s'');"><strong>%s</strong></a>)\n',...
   out_path_full_str,out_path);
sounds__.play('pop',1.2,-15); % Notify of successful save

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
      
      if exist(filename,'file')==0
         error(['Helper:' mfilename ':FileMissing'],...
            'No file named <strong>''%s''</strong>\n',filename);
      end
      F = dir(filename);
      out_path_full_str = F.folder;
      s = F.bytes;
      % Create "tiers" that get different post-scripts
      if s > 1e9
         size_str = sprintf('%.2f <strong>GB</strong>',s*1e-9);
      elseif s > 1e6
         size_str = sprintf('%.2f MB',s*1e-6);
      else
         size_str = sprintf('%.2f KB',s*1e-3);
      end
   end

end