|<img src="docs\img\eva\three_approaches_raw.png" width = "400"></th>|
|:----:|
| _Exemplary generic signal_|

###### Signal Simulation
I implemented the possibility to generate simulated signals for evaluation of the filters on realistic data.
```matlab
% you can create a random configuration
[signal,echt]  = generate.recording('random')

% or a generic one
[signal,echt]  = generate.recording('generic')
```
You can also adapt or define directly your own setup parameters:
```matlab
clear setup
% magnitude of the event-related potential
setup.erpMagnitude      = 1;

% noise level
setup.NoiseLevel        = 0.2;

% event-related oscillation
setup.eoFreq            = 10;
setup.eoModulation      = 1;
%setup.eoPhase           = 'random';
setup.eoPhase           = 0;

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = 1; %saturation level in percent
setup.tacsDistort       = 0.2; %periodic signal distortion
%setup.tacsDistort       = 0; %no distortion
setup.tacsPhase         = 'random';
%setup.tacsPhase         = 0;

% set level of random fluctuation of the artifcat amplitude, implemented as a Ornstein–Uhlenbeck, i.e. AR (1), process
setup.tacsModulation    = [1,.5]; %variability, stiffness
% setup.tacsModulation    = [0,1]; %no variability, perfect stiffness -> stationary signal

% signal recording parameters
setup.Fs                = 1000; %in Hz
setup.L                 = 4; %Duration of trial in seconds

[signal,echt,tacs]  = generate.recording(setup)
% signal is the signal as it were recorded
% echt is a matrix with 2 rows, storin the erp and the event-induced oscillations
% tacs is a vector of the stationary artifact
```
Consider that when tacsPhase and eoPhase as well tacsFreq and eoFreq are identical, they are phase and frequency-matched. Their superposition can be interpreted as event-related exogenous impedance modulation but also as entrainment of an endogenous event-related oscillation. Whether this is an artifact or a signal is a matter of perspective.
