Repo contains source code for creating and filtering EEG data from _periodic, non-sinusoidal_ and _non-stationary_ tCS artifacts using causal and symmetric comb filters.

Includes source code for simulation of event-related potentials and oscillations and tACS artifacts with or without saturation.

### Use Case
###### Non-Sinusoidal Filter
```matlab
% Add package to path
addpath('.\src\')

% Define a Gauss-kernel
% over the last 10 periods
% filtering at a frequency of 10 Hz
% for a signal recorded at 1000 Hz
NumberPeriods   = 10;
freq            = 10; %Hz
Fs              = 1000;
wfun            = 'gauss';
% wfun can be
% 'ave'     : average
% 'linear'  : linear
% 'exp'     : exponential
% 'gauss'   : gaussian

% Create a causal  or a symmetric kernel
kernel          = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun);
kernel          = artacs.kernel.symmetric(NumberPeriods,freq,Fs,wfun);
% Note:
% Any kernel requires a Fs which is an integer multiple of its filter frequency.
% Symmetric kernels require even integers

% Define the Sampling Rate of your Recording:
Fs              = 1000;
% Note: If necessary, the signal will be up/down sampled to be in agreement with the kernel.

% Run the kernel filter
filtered_signal = artacs.kernel.run(signal,kernel,Fs)
```
###### More information:

[Inspect different kernels in time and frequency domain](response.md)

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

###### Sinusoidal Filter
I also implemented two DFT filter approaches. Both do not require a predefined kernel. They  also works directly for filter frequencies which are non-integer divisibles of Fs. But being based on DFT/FFT, they are supposed to "work" only on sinusoidal data.

```matlab
% based on adaptive local dft
filtered_signal = artacs.dft.local(signal,freq,Fs,NumberPeriods)
% based on fft/ifft using the complete trial duration
filtered_signal = artacs.dft.complete(signal,freq,Fs)
```
###### Signal Simulation
I also implemented the possibility to generate simulated signals for evaluation of the filters on realistic data.
```matlab
% you can create a random configuration
[signal,echt]  = generate.recording('random')

% or a generic one
[signal,echt]  = generate.recording('generic')

% or define your own setup parameters
[signal,echt]  = generate.recording(setup)
```
###### More information on how you can setup the simulated signal

[Creating simulated signals](generate.md)

|<img src="docs\img\eva\three_approaches_raw.png" width = "300">|<img src="docs\img\eva\three_approaches.png" width = "900">|
|:----:|:----:|
| _Exemplary generic signal_| _Exemplary filtering of a generic signal_|
