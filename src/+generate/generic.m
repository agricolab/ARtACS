function setup =  generic()

clear setup
setup.NoiseLevel        = 0.5;

setup.erpMagnitude      = 2; % sum of eoModulation and tacsModulation(1)
setup.eoFreq            = 10; 
setup.eoModulation      = 2;
setup.eoPhase           = 'random';

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20000;
setup.tacsSaturate      = Inf;
setup.tacsDistort       = 0.001;
setup.tacsPhase         = 'random';

% level of random fluctuation of the artifcat amplitude.
% implemented as a Ornstein–Uhlenbeck, i.e. AR (1), process
setup.tacsModulation    = [2,.5]; %variability, stiffness

% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 8;

end