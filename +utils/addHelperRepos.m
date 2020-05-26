function addHelperRepos(paths)
% ADDHELPERREPOS  Adds all fields of paths to Matlab search path
%
%  utils.addHelperRepos();
%  -> References `default.Repos.m`, as `paths = default.Repos();`
%
%  utils.addHelperRepos(paths);
%
%  -- Inputs --
%  paths : Struct, where each field is a repository name (e.g. a
%           dependency) and the actual value of that field is the **local**
%           path to the folder.
%
%  -- Output --
%  Adds everything in `paths` struct to the Matlab search path; if this is
%  called redundantly does not re-add it to the path.

if nargin < 1
   paths = default.Repos();
end

f = fieldnames(paths);
for iF = 1:numel(f)
   pathname = fullfile(paths.(f{iF}));
   if ~contains(path,pathname)
      addpath(genpath(pathname));
   end
   % Added this part for convenience with defs.Repos mismatch between lab
   % workstation and home desktop path setup
   if ~contains(path,pathname)
      p = strsplit(pathname,filesep);
      pathname = strjoin(p(2:end),filesep);
      if ~contains(path,pathname)
         addpath(genpath(pathname));
      end
   end
end

end