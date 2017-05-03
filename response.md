### Assess the response of the kernel
```matlab
% add package to path
addpath('.\src\')
% generate a kernel
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
% Any kernel requires a Fs as  integer multiple of
% its filter frequency.
% Symmetric kernels require even integers
% wfun can be
% 'ave'     : average
% 'linear'  : linear
% 'exp'     : exponential
% 'gauss'   : gaussian


% Assess the kernel in the time domain with
artacs.kernel.response(kernel,1)

% Assess the magnitude response with
foi = 1:30;         %frequencies of interest
foi = [1,30];       %frequency of interest band boundaries
foi = 30;           %upper frequency of interest
artacs.kernel.response(kernel,2,foi)
```
## Time Response

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
<th><center>Uniform / SMA</center></th>
<th><center>Linear</center></th>
<th><center>Exponential</center></th>
<th><center>Gaussian</center></th>
</tr>
</table>

## Frequency Response

#### Causal
<table>
<tr>
<th><img src="docs\img\causal\mag_ave.png" width = "400"></th>
<th><img src="docs\img\causal\mag_linear.png" width = "400"></th>
<th><img src="docs\img\causal\mag_exp.png" width = "400"></th>
<th><img src="docs\img\causal\mag_gauss.png" width = "400"></th>
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
<th><img src="docs\img\sym\mag_ave.png" width = "400"></th>
<th><img src="docs\img\sym\mag_linear.png" width = "400"></th>
<th><img src="docs\img\sym\mag_exp.png" width = "400"></th>
<th><img src="docs\img\sym\mag_gauss.png" width = "400"></th>
</tr>
<tr>
<th><center>Uniform / SMA</center></th>
<th><center>Linear</center></th>
<th><center>Exponential</center></th>
<th><center>Gaussian</center></th>
</tr>
</table>
