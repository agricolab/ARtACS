function setup =  generic()

clear setup
setup.NoiseLevel        = 0.2;

setup.erpMagnitude      = 2;
setup.eoFreq            = 10;
setup.eoModulation      = 1;
%setup.eoPhase           = 'random';
setup.eoPhase           = 0;

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = Inf;
setup.tacsDistort       = 0.1;
%setup.tacsPhase         = 'random';
setup.tacsPhase         = 0;


% level of impedance fluctutations -> tacs amplitude modulation
setup.tacsModulation    = [1,.5]; %variability, stiffness
% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;

end