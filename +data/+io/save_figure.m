function save_figure(fname,fig)
%SAVE_FIGURE Save figure to default output location
%
%  data.io.save_figure(fname,fig);
%  e.g.
%  >> data.io.save_figure(fname,fig);
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
savefig(fig,[filename '.fig']); % Save output .fig file
sounds__.play('pop',0.7,-25);
saveas(fig,[filename '.png']); % Save output .png file
sounds__.play('pop',0.85,-15);
gfx__.expAI(fig,[filename def_type]);
fprintf(1,'\n\t-><strong>%s</strong> saved successfully.\n',f);
fprintf(1,...
   '\t\t->(<a href="matlab:winopen(''%s'');"><strong>%s</strong></a>)\n',...
   out_path,out_path);
sounds__.play('pop',1.0,-5);
end