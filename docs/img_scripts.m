matlabrc 
cd('C:\Users\Robert Bauer\OneDrive\Work\publish\wip\ARtACS\test\')
addpath('.\..\src')
printfolder = '..\docs\img\';
%%
filepath = 'data\median\';
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
h1 = plot(xaxis(pick),tmp(pick,:),'color',[.5 .5 .5],'linewidth',1)
h2 = plot(xaxis(pick),mean(tmp(pick,:),2),'color','r','linewidth',2)
set(gca,'XTICK',0:15:360,'XLIM',[60 120])
set(gca,'YTICK',-5000:100:5000,'YLIM',[2750 3300],'YTICKLABEL',[])
xlabel('Phase in degree (°)')
ylabel('Amplitude in a.u.')
l1 = legend([h1(1),h2],'Periods','Average','location','northoutside')
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
h1 = plot(xaxis(pick),tmp(pick,:),'color',[.5 .5 .5],'linewidth',1)
h2 = plot(xaxis(pick),mean(tmp(pick,:),2),'color','r','linewidth',2)
set(gca,'XTICK',0:15:360,'XLIM',[60 120])
set(gca,'YTICK',-5000:100:5000,'YLIM',[2750 3300],'YTICKLABEL',[])
xlabel('Phase in degree (°)')
l1 = legend([h1(1),h2],'Periods','Average','location','northoutside')
set(l1,'position',[0.85 .85 0 .130])
%title('Saturation')
print(gcf,[printfolder,'intro/saturation.png'],'-dpng')

%% Frequency Response of Examples
close all

NumberPeriods   = 10;
tacsFreq        = 10;
Fs              = 1000;

filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'ave'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'causal/kernel_ave.png'],'-dpng')

filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'linear'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'causal/kernel_linear.png'],'-dpng')

filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'exp'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'causal/kernel_exp.png'],'-dpng')

filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'gauss'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'causal/kernel_gauss.png'],'-dpng')
% --------------------

filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'ave'),Fs,2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'causal/mag_ave.png'],'-dpng')

filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'linear'),Fs,2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'causal/mag_linear.png'],'-dpng')

filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'exp'),Fs,2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'causal/mag_exp.png'],'-dpng')

filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'gauss'),Fs,2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'causal/mag_gauss.png'],'-dpng')

%%

filter.kernel.response(filter.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'ave'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'sym/kernel_ave.png'],'-dpng')

filter.kernel.response(filter.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'linear'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'sym/kernel_linear.png'],'-dpng')

filter.kernel.response(filter.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'exp'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'sym/kernel_exp.png'],'-dpng')

filter.kernel.response(filter.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'gauss'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'sym/kernel_gauss.png'],'-dpng')

% --------------------

filter.kernel.response(filter.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'ave'),Fs,2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'sym/mag_ave.png'],'-dpng')

filter.kernel.response(filter.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'linear'),Fs,2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'sym/mag_linear.png'],'-dpng')

filter.kernel.response(filter.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'exp'),Fs,2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'sym/mag_exp.png'],'-dpng')

filter.kernel.response(filter.kernel.symmetric(NumberPeriods,tacsFreq,Fs,'gauss'),Fs,2,30)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'sym/mag_gauss.png'],'-dpng')

%% Kernel Tuning
tau     = [0,5,100,1000]

close all

for tau_idx = 1 : length(tau)
    figure
    hold on
    set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
    filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'exp',tau(tau_idx)),Fs,1,[],gcf)    
    set(gca,'ylim',[-1.1 1.1])
    %set(get(gca,'children'),'Markerfacecolor',cmap{tau_idx});    
    print(gcf,[printfolder,'tau/kernel_exp_',num2str(tau(tau_idx)),'.png'],'-dpng')
    
    figure
    hold on
    set(gcf,'Position',[100 500 400 300],'paperpositionmode','auto')
    filter.kernel.response(filter.kernel.causal(NumberPeriods,tacsFreq,Fs,'exp',tau(tau_idx)),Fs,2,30,gcf)    
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
    filter.kernel.response(filter.kernel.causal(NumberPeriods(N),tacsFreq,Fs,'exp'),Fs,1,[],gcf)    
    set(gca,'ylim',[-1.1 1.1])
    %set(get(gca,'children'),'Markerfacecolor',cmap{tau_idx});    
    print(gcf,[printfolder,'np/kernel_exp_',num2str(NumberPeriods(N)),'.png'],'-dpng')
    
    figure
    hold on
    set(gcf,'Position',[100 500 400 300],'paperpositionmode','auto')
    filter.kernel.response(filter.kernel.causal(NumberPeriods(N),tacsFreq,Fs,'exp'),Fs,2,30,gcf)    
   % set(get(gca,'children'),'Color',cmap{tau_idx});    
    print(gcf,[printfolder,'np/mag_exp_',num2str(NumberPeriods(N)),'.png'],'-dpng')
           
end
%% Evaluate on Simulated Signals
% Signal and Artifact Construction
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
%setup.tacsSaturate      = .5;
%setup.tacsPhase         = 'random';
setup.tacsPhase         = 0;

% level of impedance fluctutations -> tacs amplitude modulation
setup.tacsModulation    = [1,.5]; %variability, stiffness
% signal recording parameters
setup.Fs                = 1000;
setup.L                 = 4;
setup.Foi               = 0:45;
%filter parameters
setup.NumberPeriods     = 10;

rep_num = 200; % we generate 200 trials
F       = [];
E       = [];
Z       = [];
for rep = 1 : rep_num    
     [t,e]                 = test.generate_signal(setup); 
     filtered = t;     
     for fidx = 2 : length(filt_type)+1
        k                                       = filter.kernel.causal(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1});       
        filtered(fidx,:)                        = filter.kernel.run(t,k);     
        k                                       = filter.kernel.symmetric(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1});       
        filtered(fidx+length(filt_type),:)      = filter.kernel.run(t,k);       
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
%for np = [2,4,8,16,32,64]
for np = [2,4,6,8,10,12,14,16]
    setup.NumberPeriods     = np;
    cnt = cnt+1;
    rep_num = 200; % we generate 200 trials
    F       = [];
    E       = [];
    Z       = [];
    for rep = 1 : rep_num    
         [t,e]                 = test.generate_signal(setup); 
         filtered = t;     
         for fidx = 2 : length(filt_type)+1
            k                                       = filter.kernel.causal(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1});       
            filtered(fidx,:)                        = filter.kernel.run(t,k);     
            k                                       = filter.kernel.symmetric(setup.NumberPeriods,setup.tacsFreq,setup.Fs,filt_type{fidx-1});       
            filtered(fidx+length(filt_type),:)      = filter.kernel.run(t,k);       
         end
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
    end
    KX_erp(:,:,cnt) = cat(1,kx1,kx2);
    
    if setup.eoModulation  ~= 0
        hdl = figure;
        toi = (((setup.L/2)-1).*setup.Fs)+(751:1750);
        kx1 = test.performance(F(1:5,toi,:),e(2,toi),500,10,1,hdl);
        kx2 = test.performance(F([1,6:end],toi,:),e(2,toi),500,10,1,hdl);
        annotation('textbox','string','Oscillation','position',[0 0 0 1])   
    end
    KX_eo(:,:,cnt) = cat(1,kx1,kx2);
end
























%%
figure
set(gcf,'Position',[100 100 600 800],'paperpositionmode','auto')
    filter_num  = size(F,1);    
    trl_num     = size(F,3);    
    pick_num    = min(10);
    rep_num     = 500
    taxis       = 1:length(t);      
    titletext = {'Raw','Average','Linear','Exponential','Gaussian'};
    %spot        = reshape(1:(2*5),2,5)';
    spot        = reshape(1:(1*5),1,5)';
    pick    = datasample(1:trl_num,pick_num);  
    for fidx = 1 : filter_num
        subplot(5,1,spot(fidx,1))
        plot(sum(e,1),'color',[.8 .8 .8],'linewidth',3)            
        hold on     
        my  = mean(abs(hilbert(F(fidx,:,pick))),3);
        my  = my-min(my);    
        plot(taxis,my)
        grid on       
        title(titletext{fidx})
        ylim = ceil(max(abs(my)));
        set(gca,'ylim',[-ylim ylim])
        xlabel('Time')
        ylabel('Amplitude')

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
setup.tacsFreq          = 10;
setup.tacsMagnitude     = 20;
setup.tacsSaturate      = Inf;
%setup.tacsSaturate      = .5;
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

%%

% Artifact Removal
close all
filt_type = {'ave','linear','exp','gauss'}
[t,e,z]                 = test.generate_signal(setup);

for np = [1,3,5]
    
% figure
% set(gcf,'Position',[100 100 1200 500],'paperpositionmode','auto')
% for fidx = 1 : length(filt_type)
%     subplot(4,1,fidx)
%     k   = filter.kernel.causal(np,setup.tacsFreq,setup.Fs,filt_type{fidx});    
%     plot(real(filter.kernel.run(sum(e,1),k)))
%     set(gca,'xlim',[2000,4000])
%     hold on
%     plot(sum(e,1),'r')
% end

figure
set(gcf,'Position',[100 100 1200 500],'paperpositionmode','auto')
for fidx = 1 : length(filt_type)
    subplot(4,1,fidx)
    k   = filter.kernel.symmetric(np,setup.tacsFreq,setup.Fs,filt_type{fidx});    
    plot(real(filter.kernel.run(sum(e,1),k)))
    set(gca,'xlim',[2000,4000])
    hold on
    plot(sum(e,1),'r')
end
end

















