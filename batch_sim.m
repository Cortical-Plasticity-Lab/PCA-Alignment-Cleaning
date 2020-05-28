%BATCH_SIM Check simulations over parameter-space grid for performance
%
%  This is the main code for simulation and metrics generated in paper.
%  For exploratory analysis & visualization, see `main.mlx`
%  For help, call the following from Command Window:
%  >> help contents
%  
%  See also: main.mlx

% Clear workspace
close all force; clear; clc;

% We should create a grid of the following parameters:
%  * Number of channels
%  * Number of trials
%  * Number of "generative" factors
%  * Alignment jitter (parameter: standard deviation of Gaussian)
%  * Spike noise (parameter: standard deviation of White Gaussian process)
[nChannel,nTrial,nFactor,sigma_jitter,sigma_rate] = ...
   default.experiment(... % Load from defaults file
      'all_num_channels','all_num_trials','all_factors',...
      'all_sigmas_jitter','all_sigmas_rate');
   
