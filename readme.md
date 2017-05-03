Repo contains source code for creating and filtering EEG data from _periodic, non-sinusoidal_ and _non-stationary_ tCS artifacts using causal and symmetric comb filters.

Includes source code for simulation of event-related potentials and oscillations and tACS artifacts with or without saturation.

### Use Case
|<img src="docs\img\eva\three_approaches_raw.png" width = "300">|<img src="docs\img\eva\three_approaches.png" width = "900">|
|:----:|:----:|
| _Exemplary generic signal_| _Exemplary filtering of a generic signal_|
###### Comb Filter
Filters the signal. Artifact can be _non-stationary_ and  _non-sinusoidal_, but is required to be _periodic_. Currently only works for frequencies which are integer divisibles of the sampling rate.
```matlab
% Add package to path
addpath('.\src\')

% Define a symmetric gaussian kernel
% over the last 10 periods
% filtering at a frequency of 10 Hz
% for a signal recorded at 1000 Hz
NumberPeriods   = 10;
freq            = 10; %in Hz, artifact frequency
Fs              = 1000; %Sampling Rate
wfun            = 'gauss';
% wfun can be 'ave', 'linear', 'exp' or 'gauss'
symflag         = 'symmetric';
% symflag  can be 'causal', 'symmetric'

% Run the kernel filter
filtered_signal = artacs.kernel.run(signal,freq,NumberPeriods,Fs,wfun,symflag)

% Alternatively, generate the kernel and run it on the signal
kernel          = artacs.kernel.symmetric(NumberPeriods,freq,Fs,wfun);
filtered_signal = artacs.kernel.runpredefined(signal,kernel,Fs)
```
###### Sinusoidal Filter
Filters the signal assuming a sinusoidal artifact and either _local_ or _complete_ stationarity. Works for any frequency.
```matlab
% based on adaptive local dft
filtered_signal = artacs.dft.local(signal,freq,Fs,NumberPeriods)
% based on fft/ifft using the complete trial duration
filtered_signal = artacs.dft.complete(signal,freq,Fs)
```
###### Signal Simulation
Generates simulated signals for filter evaluation.
```matlab
% you can create a random configuration
[signal,echt]  = generate.recording('random')

% or a generic one
[signal,echt]  = generate.recording('generic')

% or define your own setup parameters
[signal,echt]  = generate.recording(setup)
```
###### More information:
[On creating simulated signals](generate.md)

[On inspecting  kernels in time and frequency domain](response.md)

###### Task List
- [x] Create filter code
- [x] Comb Filter when Kernel and Signal Fs are not matched
- [x] Implement static code tests
- [ ] Allow filtering for non-integer divisible frequencies
- [ ] Translate all code to Python3


- [x] Write up rationale for weighted filters
- [x] Create signal simulation code
- [x] Evaluate on simulated signal
- [ ] Write up results of evaluation on simulated signals
- [ ] Evaluate on real data
- [ ] Write up results of evaluation on real data
---
