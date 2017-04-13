matlabrc 
cd('C:\Users\Robert Bauer\OneDrive\Work\publish\wip\ARtACS\test\')
addpath('.\..\src')
%% Artifact Construction
clear setup
cphase                  = deg2rad(randi(360));

setup.erpMagnitude      = 0;
setup.eoModulation      = 1;
setup.eoFreq            = 10;
%setup.eoPhase           = deg2rad(randi(360));
setup.eoPhase           = cphase;
setup.tacsModulation    = 1;
setup.tacsMagnitude     = 20;
%setup.tacsPhase         = deg2rad(randi(360));
setup.tacsPhase         = cphase;
setup.tacsFreq          = 10.01;

setup.NoiseLevel        = .1;
setup.Fs                = 1000;
setup.L                 = 4;

w                       = 1+4.5*sin(0.1*2*pi*[1/setup.Fs :1/setup.Fs :setup.L]);
[t,e,z]                 = test.makeSignal(setup);
t                       = test.saturate(t,Inf);
t                       = test.saturate(t,.9);

setup.tacsFreq          = 10;
%% Artifact Removal
clc
close all
for np = 2
    


setup.NumberPeriods   = np;


figure 
set(gcf,'Position',[100 100 1200 800],'paperpositionmode','auto')

filtered = cat(1,...
    t,...
    filter.dft.local(t,setup.tacsFreq,setup.Fs,setup.NumberPeriods),...
    filter.dft.complete(t,setup.tacsFreq,setup.Fs),...    
    filter.kernel.shapeless(t,filter.kernel.create(setup.NumberPeriods,setup.tacsFreq,setup.Fs))...
    );


foi = 0:45;
do_pwelch = @(xvar)10*log10(pwelch(xvar,setup.Fs,setup.Fs/2,foi,setup.Fs));
pxx = cat(1,...
    do_pwelch(filtered(1,:)),...
    do_pwelch(filtered(2,:)),...
    do_pwelch(filtered(3,:)),...    
    do_pwelch(filtered(4,:))...
    );

pylim = [nanmin(reshape(real(pxx),1,[])),nanmax(reshape(real(pxx),1,[]))];
titletext = {'Raw','Local DFT','IFFT','Shapeless'};
ylim = 1.5*max([setup.eoModulation,setup.erpMagnitude]);
spot = reshape(1:(2*5),2,5)';
for fidx = 1 : size(filtered,1)
    subplot(4,2,spot(fidx,1))
    hold on
    plot(e,'color',[.8 .8 .8],'linewidth',3)
    plot(filtered(fidx,:))    
    title(titletext{fidx})
    if fidx < 2
        set(gca,'ylim',[-max(abs(t)), max(abs(t))])
    else
        set(gca,'ylim',[-ylim, ylim])
    end

    
    subplot(4,2,spot(fidx,2))
    plot(foi,real(pxx(fidx,:)))
    grid on
    set(gca,'ylim',[pylim])
    title(titletext{fidx})
end


end