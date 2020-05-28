% PROCESS Package for processing, cleaning, & reconstructing data
% MATLAB Version 9.7 (R2019b Update 5) 27-May-2020
%
% Files
%  clean - Apply PCA cleaning
%  clean_factors - Apply 'factoran' cleaning
%  concat_trials - Concatenate trials along channels for smoothed dataset
%  correct_offset - Shifts mask vector by some offset
%  estimate_offset - Estimate individual trial alignment offsets
%  estimate_channel_offset - Estimate individual trial/channel misalignment
%  reconstruct - Reconstruct data from Scores, Coefficients, and Offsets
%  recover_factors - Recover original factor for a channel from data table X
%  smooth - Reorganize data table as new "smoothed by trial" table
%  transform_factors - Apply offset and scaling to factors for Poisson process
