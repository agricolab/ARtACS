matlabrc 
cd('C:\Users\Robert Bauer\OneDrive\Work\publish\wip\ARtACS\test\')
addpath('.\..\src')
%% Signal and Artifact Construction
clear setup
% event-related potential
setup.erpMagnitude      = 0;

% noise level
setup.NoiseLevel        = 0.2;

% event-related impedance modulation -> tacs amplitude modulation
% can also be understood as event-related power modulation
setup.eoFreq            = 10;
setup.eoFreq            = 15.6;
setup.eoModulation      = 1;
%setup.eoPhase           = 'random';
setup.eoPhase           = 0;

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = Inf;
%setup.tacsSaturate      = .5;
%setup.tacsPhase         = 'random';
setup.tacsPhase         = 0;

% level of sinusoidal impedance fluctutations -> tacs amplitude modulation
setup.tacsModulation    = [2,1]; %magnitude, natural frequency of fluctuations

% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;
setup.Foi               = 0:45;

setup.NumberPeriods = 3;
%% Artifact Removal
close all
filt_type = {'ave','linear','exp'};     
[t,e,z]                 = test.generate_signal(setup);
for fidx = 1 : length(filt_type)
    figure
    set(gcf,'Position',[100 100 1200 500],'paperpositionmode','auto')
    k   = filter.kernel.create(setup.NumberPeriods./2,setup.tacsFreq,setup.Fs,filt_type{fidx});    
    plot(real(filter.kernel.shapeless(sum(e,1),k)))
    hold on
    plot(sum(e,1),'r')
end

%%

rep_num = 200; % we generate 200 trials
F       = [];
E       = [];
Z       = [];
for rep = 1 : rep_num
    [t,e,z]                 = test.generate_signal(setup);
 
     filt_type = {'ave','linear','exp'};
     filtered = t;     
     for fidx = 2 : length(filt_type)+1
         k                   = (filter.kernel.create(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1}));       
         filtered(fidx,:)    = (filter.kernel.shapeless(t,k));       
     end
    F                       = cat(3,F,filtered);
    E                       = cat(3,E,e);
end
%and estimate how good we recover the ERP based on bootstrap for n = 100 trials
clc
close all
test.performance(F,e,9,0,2) 
test.performance(F,e,9,1,2) 