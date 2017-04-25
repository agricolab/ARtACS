matlabrc 
cd('C:\Users\Robert Bauer\OneDrive\Work\publish\wip\ARtACS\test\')
addpath('.\..\src')
%% Evaluate on Simulated Signals
% Signal and Artifact Construction
clear setup
% event-related potential
setup.erpMagnitude      = 1;

% noise level
setup.NoiseLevel        = 0.2;

% event-related impedance modulation -> tacs amplitude modulation
% can also be understood as event-related power modulation
setup.eoFreq            = 10;
%setup.eoFreq            = 15.6;
setup.eoModulation      = 1;
%setup.eoPhase           = 'random';
setup.eoPhase           = 0;

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = Inf;
%setup.tacsSaturate      = .5;
setup.tacsPhase         = 'random';
%setup.tacsPhase         = 0;

% level of impedance fluctutations -> tacs amplitude modulation
setup.tacsModulation    = [1,.9]; %variability, stiffness

% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;
setup.Foi               = 0:45;

setup.NumberPeriods     = 40;
%%


rep_num = 200; % we generate 200 trials
F       = [];
E       = [];
Z       = [];
for rep = 1 : rep_num
     [t,e]                 = test.generate_signal(setup); 
     filtered = t;     
     for fidx = 2 : length(filt_type)+1
         k                   = filter.kernel.causal(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1});       
         filtered(fidx,:)    = filter.kernel.run(t,k);       
     end
    F                       = cat(3,F,filtered);
    E                       = cat(3,E,e);
end
%and estimate how good we recover the ERP based on bootstrap for n = 100 trials
clc
close all
test.performance(F,e,100,200,0,2) 

toi = 1751:2750;
test.performance(F(:,toi,:),e(:,toi),100,10,0,2) 

%% Artifact Removal
% Signal and Artifact Construction
clear setup
% event-related potential
setup.erpMagnitude      = 0;

% noise level
setup.NoiseLevel        = 0;
setup.eoFreq            = 10;
setup.eoModulation      = 1;
setup.eoPhase           = 0;

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = Inf;
setup.tacsPhase         = 'random';
setup.tacsModulation    = [1,.5]; %variability, stiffness

% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;
setup.Foi               = 0:45;
setup.NumberPeriods     = 3;

close all
[t,e]               = test.generate_signal(setup);
plot(t), hold on, plot(abs(hilbert(t)),'r')
%%
close all
filt_type           = {'ave','linear','exp','gauss'};
filt_title           = {'Uniform','Linear','Exponential','Gaussian'};


for np = [1,3,5]
figure
set(gcf,'Position',[100 100 600 500],'paperpositionmode','auto')
for fidx = 1 : length(filt_type)
    subplot(4,1,fidx)
    k   = filter.kernel.symmetric(np,setup.tacsFreq,setup.Fs,filt_type{fidx});    
    plot(real(filter.kernel.run(sum(e,1),k)))
    set(gca,'xlim',[1750,2750])
    hold on
    plot(sum(e,1),'r')
    title(filt_title{fidx})    
end
h = legend('Filtered','Raw');
set(h,'position',[0.1 .85 .08 .08])
end
