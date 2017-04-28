function setup =  random()

clear setup
setup.NoiseLevel        = sqrt(rand());

setup.erpMagnitude      = rand()*2;
setup.eoFreq            = 10;
setup.eoModulation      = rand()*2;
setup.eoPhase           = 'random';
%setup.eoPhase           = 0;

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = Inf;
setup.tacsDistort       = sqrt(rand());
setup.tacsPhase         = 'random';
%setup.tacsPhase         = 0;


% level of impedance fluctutations -> tacs amplitude modulation
setup.tacsModulation    = [rand()*2,rand()]; %variability, stiffness
% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;

end