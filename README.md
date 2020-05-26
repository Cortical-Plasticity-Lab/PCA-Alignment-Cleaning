# PCA-Alignment-Cleaning
Simulations and validations for simple PCA neurophysiological data alignment cleaning strategy.

## Overview ##

This repository contains a simple tool for "cleaning" misaligned neurophysiological time-series which are meant to be event-locked to a fixed behavioral event of interest. For example, a behavior of interest may be captured using a video camera with a framerate of 30 Hz, while the relevant timescale for spiking processes of interest is orders of magnitude faster (300 - 3000 Hz). The jitter introduced by misalignment even within a single frame (by comparison to the spike timescale) is a noise source for the physiological data of interest. Fortunately, we can correct for this noise source to remove jitter from recovered single-trial spike rate estimates by implementing a simple PCA noise rejection step that aims to reconstruct the correctly-aligned data **under following assumption:** _we can "discard" part of the data in a principled way, such that the reconstruction error contains the unwanted misalignment noise._ 

### Sub-objective ###

In order for this to be a useful utility for neurophysiological behavior analysis in preclinical studies, we would like to achieve the following:

_Identify a "robust" surface manifold that relates **the optimal retained data variance** based on a combination of known or estimable parameters such as:_

- [ ] Number of channels 
- [ ] Number of trials 
- [ ] Expected jitter standard deviation
- [ ] Expected non-neural noise variance
- [ ] Total number of "generative" factors present for spike rates

---

## Use ##

#### Where to Start? ####

There are pretty much just two steps to follow:

1. If not already cloned to the same folder containing this repository, add the following repository at that location (or modify `default.Repos()` local path to reflect its location; note that the local name on my PC is just `'Projects/Utilities'`, so if you clone using the default repo name (`'Matlab_Utilities'`) make sure to reflect that):
   https://github.com/m053m716/Matlab_Utilities
   * This should be the only major **dependency** the repository has, and it's not really that important other than for using the `save` functions in `main.mlx`.
2. Literally, just click through `main.mlx` in a Matlab release that supports the Matlab `Live Editor` (likely, `Matlab R2016a` and beyond). 

---

## Simulation Source Factors ##

The factors used for simulation of spike trains are derived from a reach-to-grasp experiment recorded from a rat reaching to retrieve a pellet, in alignment to the first video frame on which the rat closed its paw. 

### Original Factors ###

![](https://raw.githubusercontent.com/m053m716/PCA-Alignment-Cleaning/master/docs/Original_Factors.png)

_The original factors are scaled as coefficients between -1 and 1._

### Offset Factors ###

![](https://raw.githubusercontent.com/m053m716/PCA-Alignment-Cleaning/master/docs/Offset_Factors.png)

_Each factor offset is just to make them non-negative for all points, so that they can be scaled to physiologically plausible spike rate parameters._

### Scaled Factors ###

![](https://raw.githubusercontent.com/m053m716/PCA-Alignment-Cleaning/master/docs/Scaled_Factors.png)

_After the offset, factors are rescaled so that their units change to spikes/second. All subsequent simulations are weighted combinations of these four factors._

---

## Example Output ##

### Simulated Rate Trial Overlays ###

![](https://raw.githubusercontent.com/m053m716/PCA-Alignment-Cleaning/master/docs/Example_Original_Output.png)

Here is an example of fairly noisy data with jitter on the order of 20-ms (low-noise case) up to 120-ms (high-noise case) for a realistic number of trials (N = 25). Each semi-opaque trajectory represents an individual trial for that recording "channel," which is some weighted combination of the **[scaled factors](#Scaled-Factors)** Note that particularly in rehabilitation experiments, it is difficult to get a high number of trials for a variety of reasons, but particularly if the animal belongs to an injury group they may not be very motivated to perform hundreds of behavioral trials.

### Cleaned Rate Trial Overlays ###

![](https://raw.githubusercontent.com/m053m716/PCA-Alignment-Cleaning/master/docs/Example_Cleaned_Output.png)

Using the same **[simulated data](#simulated-rate-trial-overlays)**, we retain the top-3 (_top: low-noise_) or top-7 (_bottom: high-noise_) principal components and reconstruct the simulated spike rates. The number of principal components is set using a threshold based on the total percent of the variance explained by the retained principal components. **Part of the goal of this small project is to identify a "robust" surface manifold based on parameters such as the number of channels, number of trials, noise parameters, and total number of "generative" factors present for spike rates.**