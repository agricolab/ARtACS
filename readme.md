Repo contains source code for creating and filtering EEG data from _periodic, non-sinusoidal_ and _non-stationary_ tCS artifacts using ___causal or symmetric weighted comb filters___.

Includes also code for _adaptive DFT_ and for simulation of event-related potentials during tACS.

#### Use Case
|<img src="docs\img\eva\three_approaches_raw.png" width = "300">|<img src="docs\img\eva\three_approaches.png" width = "900">|
|:----:|:----:|
| _Exemplary generic signal_| _Exemplary filtering of a generic signal_|

#### Comb Filter
Filters the signal. Artifact can be _non-stationary_ and  _non-sinusoidal_, but is required to be _periodic_. Comb filters natively supports frequencies which are integer divisibles of the sampling frequency. Filter other frequenices with artacs.kernel.run, which automatically  resamples the signal before and after filtering.

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

% Simulate a signal for filter evaluation.
signal          = generate.recording('generic')

% Run the kernel filter
filtered_signal = artacs.kernel.run(signal,freq,NumberPeriods,Fs,wfun,symflag)

% Alternatively, generate the kernel and run it on the signal
kernel          = artacs.kernel.symmetric(NumberPeriods,freq,Fs,wfun);
filtered_signal = artacs.kernel.runpredefined(signal,kernel,Fs)
```
#### Sinusoidal Filter
Filters the signal. Assumes a sinusoidal artifact which exhibits either _local_ or _complete_ stationarity. Works natively for any frequency.
```matlab
% based on adaptive local dft
filtered_signal = artacs.dft.local(signal,freq,Fs,NumberPeriods)
% based on fft/ifft using the complete trial duration
filtered_signal = artacs.dft.complete(signal,freq,Fs)
```
#### Performance
<img src="docs\img\eva\recovery_erp.png" width = "1000">

###### More information:
[On creating simulated signals](generate.md)

[On inspecting  kernels in time and frequency domain](response.md)

###### Task List
- [x] Create filter code
- [x] Comb Filter when Kernel and Signal Fs are not matched
- [x] Implement static code tests
- [x] Allow filtering for non-integer divisible frequencies
- [ ] Translate the code to Python3


- [x] Write up rationale for weighted filters
- [x] Create signal simulation code
- [x] Evaluate on simulated signal
- [x] Write up results of evaluation on simulated signals
- [ ] Evaluate on real data
- [ ] Write up results of evaluation on real data
---
