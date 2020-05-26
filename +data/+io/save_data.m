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
save(filename,'-struct','out');
fprintf(1,'\n\t-><strong>%s</strong> saved successfully.\n',f);
fprintf(1,...
   '\t\t->(<a href="matlab:winopen(''%s'');"><strong>%s</strong></a>)\n',...
   out_path,out_path);
sounds__.play('pop',1.2,-15); % Notify of successful save

end