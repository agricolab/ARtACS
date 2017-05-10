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
