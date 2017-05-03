matlabrc 
cd('C:\Users\Robert Bauer\OneDrive\Work\publish\wip\ARtACS\')%
%cd('C:\Users\rober\OneDrive\Work\publish\wip\ARtACS\')
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
%% Exemplary simulated signal
%%
setup           = generate.generic();  
[r,e,t]         = generate.recording(setup);

clear f
np = 10;
f(1,:)       = artacs.kernel.run(r,artacs.kernel.symmetric(np,10,1000,'exp'));
f(2,:)       = artacs.kernel.run(r,artacs.kernel.causal(np,10,1000,'ave'));
%f(3,:)       = artacs.dft.local(r,10,1000,np);
f(3,:)       = artacs.dft.complete(r,10,1000);

tit_set = {'Symmetric Gaussian','Causal Uniform','DFT'};
close all
figure
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
hold on
h1 = plot(t,'color',[.8 .8 .8],'linewidth',2);
h2 = plot(r,'k');
h3 = plot(e(1,:),'r');
set(gca,'xlim',[1501,2501],'xtick',[1:250:4000],'xticklabel',[-2000:250:2000])
set(gca,'ylim',[-22 22])
lh = legend([h1,h2,h3],'Applied tACS','Recording','True Signal');
set(lh,'position',[0.15 .85 .08 .08])
print(gcf,[printfolder,'div\three_approaches_raw.png'],'-dpng')

figure
set(gcf,'Position',[100 100 1200 300],'paperpositionmode','auto')
for k=1:3
    subplot(1,3,k)
    hold on
    h2 = plot(e(1,:),'color',[.8 .8 .8],'linewidth',2);
    h1 = plot(f(k,:),'b','linewidth',1);      
    set(gca,'xlim',[1901,2101],'xtick',[1:25:4000],'xticklabel',[-2000:25:2000])
    set(gca,'ylim',[-4 4])

    title(tit_set{k})
end
lh = legend([h2,h1],'True Signal','Recovered Signal');
set(lh,'position',[0.1 .8 .08 .08])
print(gcf,[printfolder,'div\three_approaches.png'],'-dpng')
%%
for rep = 1 :  rep_num   
    [r,e,t]         = generate.recording('generic');
    
end




