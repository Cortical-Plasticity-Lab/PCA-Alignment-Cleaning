function varargout = correct_offset(varargin)
%CORRECT_OFFSET Shifts mask vector by some offset
%
% C = data.process.correct_offset(T,offset);
%
% Inputs
%  T - `T.Properties.UserData.Type=='channels'` table with uncorrected Rate
%  offset - Vector of offsets (samples), where a positive value slides the
%           "apparent" mask backward in time (e.g. to the left) and a
%           negative value does the opposite. Another way to think about it
%           is the positive value represents that the mask is shifted
%           forward in time relative to what should have been sampled.
%           Should have 1 value for every value of the table `T`.
%
% Output
%  C - Version of `T` with offset-corrected Rate and AlignMask variables.

iNumeric = cellfun(@isnumeric,varargin);
if ~any(iNumeric)
   varargout = cell(size(varargin));
   for iV = 1:numel(varargin)
      offset = data.process.estimate_channel_offset(varargin{iV});
      varargout{iV} = data.process.correct_offset(varargin{iV},offset(:));
   end
   return;
else
   offset = varargin{iNumeric};
   varargin(iNumeric) = [];
end

if numel(varargin) > 1
   varargout = cell(size(varargin));
   for iV = 1:numel(varargin)
      varargout{iV} = data.process.correct_offset(varargin{iV},offset);
   end
   return;
end

T = varargin{:};
nRow = size(T,1);
nSample = size(T.AlignMask,2);

A = mat2cell(T.AlignMask,ones(1,nRow),nSample);
maskStart = cellfun(@(C)find(C,1,'first'),A);
maskEnd = cellfun(@(C)find(C,1,'last'),A);
vec = arrayfun(@(a1,a2)a1:a2,maskStart,maskEnd,'UniformOutput',false);
new_vec = arrayfun(@(indices,shift,lb,ub)do_correction(...
   indices{:},shift,-(nSample-lb),ub-1),...
   vec,offset,maskEnd,maskStart,...
   'UniformOutput',false);
full_vec = 1:nSample; % Create reference vector
AlignMask = cellfun(@(x)ismember(full_vec,x),new_vec,'UniformOutput',false);
Rate = mat2cell(T.Original,ones(1,nRow),nSample);
Rate = cellfun(@(C1,C2)C1(C2),Rate,AlignMask,'UniformOutput',false);
C = T;
C.AlignMask = cell2mat(AlignMask);
C.Rate = cell2mat(Rate);
C.Correction = C.Correction + offset;
varargout = {utils.addTag(C,'Offset-Corrected')};

   function shifted_indices = do_correction(indices,shift,lb,ub)
      %DO_CORRECTION Helper function to apply correction to cell array
      %
      % shifted_indices = do_correction(indices,shift,lb,ub);
      %
      % Inputs
      %  indices - Array element from cell passed as vector of indices
      %              (numeric vector)
      %  shift - Array element containing (numeric scalar)
      %  lb - Lower bound on values allowed for shift
      %        -> Shift "right" requires negative value
      %        -> (nSamples - maskEnd) is the "most-negative" it could be
      %  ub - Upper bound on values allowed for shift (shift should be no
      %           larger than the starting index of mask vector - 1)
      
      safe_shift = max(min(shift,ub),lb);
      shifted_indices = indices - safe_shift;
   end
end