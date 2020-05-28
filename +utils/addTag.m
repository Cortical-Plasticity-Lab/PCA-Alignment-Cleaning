function T = addTag(T,tag)
%ADDTAG Add Tag UserData property or append to existing Tag
%
% T = utils.addTag(T,'tag');
%
% Inputs
%  T - Data table where T.Properties.UserData.Type == 'channels';
%  tag - Char array to append to "Tag" for tracking Table workflow
%
% Output
%  T - Same as input but with appended Tag property in UserData

if ~isstruct(T.Properties.UserData)
   T.Properties.UserData = struct;
end

if isfield(T.Properties.UserData,'Tag')
   T.Properties.UserData.Tag = ...
      [T.Properties.UserData.Tag ' > ' tag];
else
   T.Properties.UserData.Tag = tag;
end

end