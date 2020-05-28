function Offset = getTrialOffsets(T)
%GETTRIALOFFSETS Returns trial offsets from table `Type == 'channels'`
%
% Offset = utils.getTrialOffsets(T);
%
% Inputs
%  T - Table with T.Properties.UserData.Type == 'channels';
%
% Output
%  Offset - nTrials x 1 vector of offsets unique to each trial (ms)

if ~strcmp(T.Properties.UserData.Type,'channels')
   error(['Clean:' mfilename ':BadTableType'],...
      ['\n\t->\t<strong>[UTILS.GETTRIALOFFSETS]:</strong> ' ...
       '`T.Properties.UserData.Type` must be ''channels''\n']);
end

G = findgroups(T(:,'Trial'));
Offset = splitapply(@(x)x(1),T.Offset,G);

end