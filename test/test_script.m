matlabrc 
cd('C:\Users\Robert Bauer\OneDrive\Work\publish\wip\ARtACS\test\')
addpath('.\..\src')
%% Signal and Artifact Construction
clear setup
% event-related potential
setup.erpMagnitude      = 1;

% noise level
setup.NoiseLevel        = 0.2;

% event-related impedance modulation -> tacs amplitude modulation
% can also be understood as event-related power modulation
% setup.eoFreq            = 22.5;
setup.eoFreq            = 10;
setup.eoModulation      = 0;
setup.eoPhase           = 'random';
%setup.eoPhase           = 0;

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = Inf;
%setup.tacsSaturate      = .5;
setup.tacsPhase         = 'random';
%setup.tacsPhase         = 0;

% level of sinusoidal impedance fluctutations -> tacs amplitude modulation
setup.tacsModulation    = [1,1]; %magnitude, natural frequency of fluctuations

% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;
setup.Foi               = 0:45;
%% Artifact Removal

    setup.NumberPeriods     = 4;
    [t,e,z]                 = test.generate_signal(setup);
    [filtered,pxx]          = test.run(t,sum(e),setup,true);
%%
clc
close all
rep_num = 200; % we generate 200 trials
F       = [];
E       = [];
Z       = [];
setup.NumberPeriods = 17;
for rep = 1 : rep_num
    [t,e,z]                 = test.generate_signal(setup);
    [filtered,pxx]          = test.run(t,sum(e),setup,false);
    F                       = cat(3,F,filtered);
    E                       = cat(3,E,e);
end
%and estimate how good we recover the ERP based on bootstrap for n = 100 trials
test.performance(F,e(1,:),100) 