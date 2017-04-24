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

   


%%




































