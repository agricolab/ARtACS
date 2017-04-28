function setup =  generic()

clear setup
setup.NoiseLevel        = 0.1;

setup.erpMagnitude      = 0;
setup.eoFreq            = 10;
setup.eoModulation      = 2;
%setup.eoPhase           = 'random';
setup.eoPhase           = 90;

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = Inf;
setup.tacsDistort       = 0.2;
setup.tacsPhase         = 'random';
setup.tacsPhase         = 0;

% level of impedance fluctutations -> tacs amplitude modulation
setup.tacsModulation    = [.5,.5]; %variability, stiffness
% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;

end