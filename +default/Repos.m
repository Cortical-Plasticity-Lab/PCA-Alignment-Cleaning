function repos = Repos()
%REPOS List of repositories to add to path alongside analysis code
%
%  repos = default.Repos();
%     -> Path names are with reference to the main repo folder, which is
%         where you would be navigated to run the `main.mlx` live script.

repos = struct;
repos.MainUtilities = '..\Utilities';
% The source for this is located at:
%  -> https://github.com/m053m716/Matlab_Utilities
%     * Contains a bunch of ad hoc or miscellaneous code that is sometimes
%        useful in varying degrees; also has collections of code from other
%        MathWorks File Exchange authors that I've found useful over the
%        years, I've tried to give attribution there as possible! It was
%        just convenient for me to aggregate in one place.

end