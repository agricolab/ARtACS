Repo contains source code for creating and filtering EEG data from _periodic, non-sinusoidal_ and _non-stationary_ tCS artifacts using causal and symmetric comb filters.

Includes source code for simulation of event-related potentials and oscillations and tACS artifacts.
> wrong syntax


### Usage / Creation
```matlab
% add package to path
addpath('.\..\src')

% Define kernel parameters

NumberPeriods   = 10; %should be Integer
tacsFreq        = 10; %Hz
Fs              = 1000;
wfun            = 'ave';
% wfun can be
% 'ave'     : average
% 'linear'  : linear
% 'exp'     : exponential
% 'gauss'   : gaussian

% create a causal kernel
% note that kernels creation requires integers;
% function will correct wrong type to closest integers by rounding up.

kernel          = filter.kernel.causal(NumberPeriods,tacsFreq,Fs,wfun);

% create a symmetric kernel
% note that symetric kernels require even integers;
% the function will correct wrong type and uneven integers
% to closest match by rounding up

kernel          = filter.kernel.symmetric(NumberPeriods,tacsFreq,Fs,wfun);


% plot the kernel with
filter.kernel.response(kernel,Fs,1)

% assess the magnitude response with
foi = 1:30;         %frequencies of interest
foi = [1,30];       %frequency of interest band boundaries
foi = 30;           %upper frequency of interest
filter.kernel.response(kernel,Fs,2,foi)

```
#### Causal
<table>
<tr>
<th><img src="docs\img\causal\kernel_ave.png" width = "400"></th>
<th><img src="docs\img\causal\kernel_linear.png" width = "400"></th>
<th><img src="docs\img\causal\kernel_exp.png" width = "400"></th>
<th><img src="docs\img\causal\kernel_gauss.png" width = "400"></th>
</tr>
<tr>
<th><center>Uniform / Average</center></th>
<th><center>Linear</center></th>
<th><center>Exponential</center></th>
<th><center>Gaussian</center></th>
</tr>
</table>

#### Symmetric

<table>
<tr>
<th><img src="docs\img\sym\kernel_ave.png" width = "400"></th>
<th><img src="docs\img\sym\kernel_linear.png" width = "400"></th>
<th><img src="docs\img\sym\kernel_exp.png" width = "400"></th>
<th><img src="docs\img\sym\kernel_gauss.png" width = "400"></th>
</tr>
<tr>
<th><center>Uniform / Average</center></th>
<th><center>Linear</center></th>
<th><center>Exponential</center></th>
<th><center>Gaussian</center></th>
</tr>
</table>

### Usage / Filtering
```matlab


% perform filtering
% function pads signal with zeros to improve filter performance
% signal should be a vector
% kernel should be constructed by filter.kernel.causal or filter.kernel.symmetric
filter.kernel.run(signal,kernel)

```
