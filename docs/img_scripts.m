matlabrc 
cd('C:\Users\Robert Bauer\OneDrive\Work\publish\wip\ARtACS\')
addpath('.\src\')
printfolder = '.\docs\img\';
%%
filepath = '.\dev\data\median\';
% load([filepath,'SEP_10Hz_saturated.mat']);%

load([filepath,'SEP_10Hz.mat']);

close all
figure
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')

tmp = trials(2,:);
tmp = reshape(tmp(247:end-254),500,[]);
tmp = tmp-mean(mean(tmp));

xaxis = rad2deg(2*pi*[0.002:0.002:1]);
pick  = 1:300;
hold on
h1 = plot(xaxis(pick),tmp(pick,:),'color',[.5 .5 .5],'linewidth',1);
h2 = plot(xaxis(pick),mean(tmp(pick,:),2),'color','r','linewidth',2);
set(gca,'XTICK',0:15:360,'XLIM',[60 120])
set(gca,'YTICK',-5000:100:5000,'YLIM',[2750 3300],'YTICKLABEL',[])
xlabel('Phase in degree (°)')
ylabel('Amplitude in a.u.')
l1 = legend([h1(1),h2],'Periods','Average','location','northoutside');
set(l1,'position',[0.15 .85 0 .130])
%title('Distortion')
print(gcf,[printfolder,'intro/distortion.png'],'-dpng')

figure
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
tmp = trials(1,:);
tmp = reshape(tmp(379:end-122),500,[]);
tmp = tmp-mean(mean(tmp));

xaxis = rad2deg(2*pi*[0.002:0.002:1]);
hold on
h1 = plot(xaxis(pick),tmp(pick,:),'color',[.5 .5 .5],'linewidth',1);
h2 = plot(xaxis(pick),mean(tmp(pick,:),2),'color','r','linewidth',2);
set(gca,'XTICK',0:15:360,'XLIM',[60 120])
set(gca,'YTICK',-5000:100:5000,'YLIM',[2750 3300],'YTICKLABEL',[])
xlabel('Phase in degree (°)')
l1 = legend([h1(1),h2],'Periods','Average','location','northoutside');
set(l1,'position',[0.85 .85 0 .130])
%title('Saturation')
print(gcf,[printfolder,'intro/saturation.png'],'-dpng')

%% Frequency Response of Examples
close all

NumberPeriods   = 10;
tacsFreq        = 10;
Fs              = 1000;

artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'ave'),1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'causal/kernel_ave.png'],'-dpng')

artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'linear'),1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'causal/kernel_linear.png'],'-dpng')

artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'exp'),1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'causal/kernel_exp.png'],'-dpng')

artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'gauss'),1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'causal/kernel_gauss.png'],'-dpng')
% --------------------

artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'ave'),2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'causal/mag_ave.png'],'-dpng')

artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'linear'),2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'causal/mag_linear.png'],'-dpng')

artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'exp'),2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'causal/mag_exp.png'],'-dpng')

artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'gauss'),2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'causal/mag_gauss.png'],'-dpng')

%%

artacs.kernel.response(artacs.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'ave'),1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'sym/kernel_ave.png'],'-dpng')

artacs.kernel.response(artacs.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'linear'),1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'sym/kernel_linear.png'],'-dpng')

artacs.kernel.response(artacs.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'exp'),1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'sym/kernel_exp.png'],'-dpng')

artacs.kernel.response(artacs.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'gauss'),1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'sym/kernel_gauss.png'],'-dpng')

% --------------------

artacs.kernel.response(artacs.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'ave'),2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'sym/mag_ave.png'],'-dpng')

artacs.kernel.response(artacs.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'linear'),2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'sym/mag_linear.png'],'-dpng')

artacs.kernel.response(artacs.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'exp'),2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'sym/mag_exp.png'],'-dpng')

artacs.kernel.response(artacs.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'gauss'),2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'sym/mag_gauss.png'],'-dpng')

%% Kernel Tuning
tau     = [0,5,100,1000];

close all

for tau_idx = 1 : length(tau)
    figure
    hold on
    set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
    artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'exp',tau(tau_idx)),1,[],gcf)    
    set(gca,'ylim',[-1.1 1.1])
    %set(get(gca,'children'),'Markerfacecolor',cmap{tau_idx});    
    print(gcf,[printfolder,'tau/kernel_exp_',num2str(tau(tau_idx)),'.png'],'-dpng')
    
    figure
    hold on
    set(gcf,'Position',[100 500 400 300],'paperpositionmode','auto')
    artacs.kernel.response(artacs.kernel.causal(NumberPeriods,tacsFreq,Fs,'exp',tau(tau_idx)),2,30,gcf)    
   % set(get(gca,'children'),'Color',cmap{tau_idx});    
    print(gcf,[printfolder,'tau/mag_exp_',num2str(tau(tau_idx)),'.png'],'-dpng')
end


%%
close all
NumberPeriods = [1,10,50];
for N = 1 : length(NumberPeriods)
    figure
    hold on
    set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
    artacs.kernel.response(artacs.kernel.causal(NumberPeriods(N),tacsFreq,Fs,'exp'),1,[],gcf)    
    set(gca,'ylim',[-1.1 1.1])
    %set(get(gca,'children'),'Markerfacecolor',cmap{tau_idx});    
    print(gcf,[printfolder,'np/kernel_exp_',num2str(NumberPeriods(N)),'.png'],'-dpng')
    
    figure
    hold on
    set(gcf,'Position',[100 500 400 300],'paperpositionmode','auto')
    artacs.kernel.response(artacs.kernel.causal(NumberPeriods(N),tacsFreq,Fs,'exp'),2,30,gcf)    
   % set(get(gca,'children'),'Color',cmap{tau_idx});    
    print(gcf,[printfolder,'np/mag_exp_',num2str(NumberPeriods(N)),'.png'],'-dpng')
           
end
%% Evaluate on Simulated Signals
% Signal and Artifact Construction
setup       = generate.generic();

filt_type = {'ave','linear','exp','gauss'};
rep_num = 200; % we generate 200 trials
F       = [];
E       = [];
Z       = [];
for rep = 1 : rep_num    
     [t,e]                 = generate.recording(setup); 
     filtered = t;     
     for fidx = 2 : length(filt_type)+1
        kernel                                  = artacs.kernel.causal(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1});       
        filtered(fidx,:)                        = artacs.kernel.run(t,kernel,500);     
        kernel                                  = artacs.kernel.symmetric(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1});         
        filtered(fidx+length(filt_type),:)      = artacs.kernel.run(t,kernel,500);       
     end
    F                       = cat(3,F,filtered);
    E                       = cat(3,E,e);
end
%and estimate how good we recover the ERP based on bootstrap
clc
close all

if setup.erpMagnitude  ~= 0
    hdl = figure;
    toi = (((setup.L/2)-1).*setup.Fs)+(751:1750);
    test.performance(F(1:5,toi,:),e(1,toi),500,10,0,hdl)
    test.performance(F([1,6:end],toi,:),e(1,toi),500,10,0,hdl)
    annotation('textbox','string','ERP','position',[0 0 0 1])
end

if setup.eoModulation  ~= 0
    hdl = figure;
    toi = (((setup.L/2)-1).*setup.Fs)+(751:1750);
    test.performance(F(1:5,toi,:),e(2,toi),500,10,1,hdl) 
    test.performance(F([1,6:end],toi,:),e(2,toi),500,10,1,hdl) 
    annotation('textbox','string','Oscillation','position',[0 0 0 1])   
end

%%
KX_erp  = [];
KX_eo   = [];
cnt = 0;
for np = [2,4,6,8,10,12,14,16]
    setup.NumberPeriods     = np;
    cnt = cnt+1;
    rep_num = 200; % we generate 200 trials
    F       = [];
    E       = [];
    Z       = [];
    for rep = 1 : rep_num    
         [t,e]                 = generate.recording(setup); 
         filtered = t;     
         for fidx = 2 : length(filt_type)+1
            k                                       = artacs.kernel.causal(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1});       
            filtered(fidx,:)                        = artacs.kernel.run(t,k);     
            k                                       = artacs.kernel.symmetric(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1});       
            filtered(fidx+length(filt_type),:)      = artacs.kernel.run(t,k);                   
         end
         filtered(end+1,:)      = artacs.dft.local(t,setup.tacsFreq,setup.Fs,setup.NumberPeriods);  
        F                       = cat(3,F,filtered);
        E                       = cat(3,E,e);
    end
    clc
    close all
    
    if setup.erpMagnitude  ~= 0
        hdl = figure;
        toi = (((setup.L/2)-1).*setup.Fs)+(751:1750);
        kx1 = test.performance(F(1:5,toi,:),e(1,toi),500,10,0,hdl);
        kx2 = test.performance(F([1,6:end],toi,:),e(1,toi),500,10,0,hdl);
        annotation('textbox','string','ERP','position',[0 0 0 1])
        KX_erp(:,:,cnt) = cat(1,kx1,kx2);
    end
    
    
    if setup.eoModulation  ~= 0
        hdl = figure;
        toi = (((setup.L/2)-1).*setup.Fs)+(751:1750);
        kx1 = test.performance(F(1:5,toi,:),e(2,toi),500,10,1,hdl);
        kx2 = test.performance(F([1,6:end-1],toi,:),e(2,toi),500,10,1,hdl);
        kx3 = test.performance(F([end],toi,:),e(2,toi),500,10,1);
        annotation('textbox','string','Oscillation','position',[0 0 0 1])   
        KX_eo(:,:,cnt) = cat(1,kx1,kx2);
    end
    
end








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
setup.tacsFreq          = 20;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = Inf;
%setup.tacsSaturate      = .5;
setup.tacsDistort       = 0.1;
setup.tacsPhase         = 'random';
%setup.tacsPhase         = 0;

% level of impedance fluctutations -> tacs amplitude modulation
setup.tacsModulation    = [1,.5]; %variability, stiffness

% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;
setup.Foi               = 0:45;

setup.NumberPeriods     = 40;
%%
%% Artifact Removal 
% Not noisy
% Signal and Artifact Construction
clear setup
% event-related potential
setup.erpMagnitude      = 0;

% noise level
setup.NoiseLevel        = 0;
setup.eoFreq            = 10;
setup.eoModulation      = 1;
setup.eoPhase           = 'random';

% tacs parameters
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 10;
setup.tacsDistort       = 0.1;
setup.tacsSaturate      = Inf;
setup.tacsPhase         = 0;
setup.tacsModulation    = [1,.85]; %variability, stiffness

% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;
setup.Foi               = 0:45;
setup.NumberPeriods     = 10;

close all
[t,e]               = generate.recording(setup);
plot(t), hold on, plot(abs(hilbert(sum(e))),'r')
%%
close all
filt_type           = {'ave','linear','exp','gauss'};
filt_title           = {'Uniform','Linear','Exponential','Gaussian'};

for np = [1,5,10]
figure
set(gcf,'Position',[100 100 600 500],'paperpositionmode','auto')
spot        = reshape(1:(2*4),2,4)';
for fidx = 1 : length(filt_type)
    subplot(4,2,spot(fidx,1))
    k   = artacs.kernel.causal(np,setup.tacsFreq,setup.Fs,filt_type{fidx});    
    plot(artacs.kernel.run(sum(e,1),k,1001))
    set(gca,'xlim',[1501,3000])
    hold on
    plot(sum(e,1),'r')
    title(filt_title{fidx}) 
    
    subplot(4,2,spot(fidx,2))
    k   = artacs.kernel.symmetric(np,setup.tacsFreq,setup.Fs,filt_type{fidx});    
    plot(artacs.kernel.run(sum(e,1),k,1001))
    set(gca,'xlim',[1501,3000])
    hold on
    plot(sum(e,1),'r')
    title(filt_title{fidx}) 
    
end
h = legend('Filtered','Raw');
set(h,'position',[0.1 .85 .08 .08])
end



%%
[r,e,t] = generate.recording('generic');
clear f
np = 10;
f(1,:)       = artacs.kernel.run(r,artacs.kernel.causal(np,10,1000,'exp'));
f(2,:)       = artacs.kernel.run(r,artacs.kernel.symmetric(np,10,1000,'ave'));
f(3,:)       = artacs.dft.local(r,10,1000,np);

tit_set = {'Causal Gaussian','Symmetric Uniform','Adaptive DFT'};
close all
figure
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
hold on
h1 = plot(sum(e,1),'r');
h2 = plot(t,'color',[.8 .8 .8],'linewidth',2);
h3 = plot(r,'k');
set(gca,'xlim',[1501,3001],'xtick',[1:250:4000],'xticklabel',[-2250:250:2000])
h = legend([h1,h2(1),h3],'True Signal','Applied tACS','Recording','Recovered Signal');
set(h,'position',[0.15 .75 .08 .08])
print(gcf,[printfolder,'div\three_approaches_raw.png'],'-dpng')

figure
set(gcf,'Position',[100 100 1200 300],'paperpositionmode','auto')
for k=1:3
    subplot(1,3,k)
    hold on
    plot(f(k,:),'b','linewidth',1)    
    set(gca,'xlim',[1501,3001],'xtick',[1:250:4000],'xticklabel',[-2250:250:2000])
    title(tit_set{k})
end
print(gcf,[printfolder,'div\three_approaches.png'],'-dpng')
%%








