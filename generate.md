###### Signal Simulation
I implemented the possibility to generate simulated signals for evaluation of the filters on realistic data.
```matlab
% you can create a random configuration
[signal,echt]  = generate.recording('random')

% or a generic one
[signal,echt]  = generate.recording('generic')
```

|<img src="docs\img\eva\three_approaches_raw.png" width = "400"></th>|
|:----:|
| _Exemplary generic signal_|

Or define your own setup parameters
```matlab
clear setup
% event-related potential
setup.erpMagnitude      = 1;

% noise level
setup.NoiseLevel        = 0.2;

% event-related oscillation
setup.eoFreq            = 10;
%setup.eoFreq            = 15.6;
setup.eoModulation      = 1;
%setup.eoPhase           = 'random';
setup.eoPhase           = 0;

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = 1; %no saturation
%setup.tacsSaturate      = .5; %in percent of tacsMagnitude
setup.tacsDistort       = 0.1; %periodic signal distortion
%setup.tacsDistort       = 0.1; %no distortion
setup.tacsPhase         = 'random';
%setup.tacsPhase         = 0;

% level of impedance fluctutations -> tacs amplitude modulation
% implemented as a Ornstein–Uhlenbeck or AR (1) process
setup.tacsModulation    = [1,.5]; %variability, stiffness
setup.tacsModulation    = [0,1]; %no variability, perfect stiffness -> stationary signal

% signal recording parameters
setup.Fs                = 1000; %in Hz
setup.L                 = 4; %Duration of trial in seconds

[signal,echt,tacs]  = generate.recording(setup)
```
Consider that when tacsPhase and eoPhase as well tacsFreq and eoFreq are identical, they are phase and frequency-matched. Their superposition can be interpreted as event-related exogenous impedance modulation but also as entrainment of an endogenous event-related oscillation. Whether this is an artifact or a signal is a matter of perspective.
