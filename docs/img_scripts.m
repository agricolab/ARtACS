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
set(gcf,'Position',[100 100 800 300],'paperpositionmode','auto')
subplot(1,2,1)

tmp = trials(2,:);
tmp = reshape(tmp(247:end-254),500,[]);
tmp = tmp-mean(mean(tmp));

xaxis = rad2deg(2*pi*[0.002:0.002:1]);
pick  = 1:250;
hold on
h1 = plot(xaxis(pick),tmp(pick,:),'color',[.5 .5 .5],'linewidth',1)
h2 = plot(xaxis(pick),mean(tmp(pick,:),2),'color','r','linewidth',2)
set(gca,'XTICK',0:15:360,'XLIM',[60 120])
set(gca,'YTICK',-5000:100:5000,'YLIM',[2750 3250],'YTICKLABEL',[])
xlabel('Phase in degree (°)')
ylabel('Amplitude in a.u.')
l1 = legend([h1(1),h2],'Periods','Average','location','northoutside')
set(l1,'position',[0.15 .85 0 .125])
title('Distortion')

subplot(1,2,2)

tmp = trials(1,:);
tmp = reshape(tmp(379:end-122),500,[]);
tmp = tmp-mean(mean(tmp));

xaxis = rad2deg(2*pi*[0.002:0.002:1]);
hold on
h1 = plot(xaxis(pick),tmp(pick,:),'color',[.5 .5 .5],'linewidth',1)
h2 = plot(xaxis(pick),mean(tmp(pick,:),2),'color','r','linewidth',2)
set(gca,'XTICK',0:15:360,'XLIM',[60 120])
set(gca,'YTICK',-5000:100:5000,'YLIM',[2750 3250],'YTICKLABEL',[])
xlabel('Phase in degree (°)')
title('Saturation')
print(gcf,[printfolder,'non_sinusoidality.png'],'-dpng')

%%
close all

NumberPeriods   = 11;
tacsFreq        = 10;
Fs              = 1000;
kernel = filter.kernel.create(NumberPeriods,tacsFreq,Fs);
filter.kernel.response(kernel,Fs,2)
set(gcf,'Position',[100 100 1200 500],'paperpositionmode','auto')
print(gcf,[printfolder,'shapeless_11_10.png'],'-dpng')

NumberPeriods   = 2;
tacsFreq        = 10;
Fs              = 1000;
kernel = filter.kernel.create(NumberPeriods,tacsFreq,Fs);
filter.kernel.response(kernel,Fs,2)
set(gcf,'Position',[100 100 1200 500],'paperpositionmode','auto')
print(gcf,[printfolder,'shapeless_2_10.png'],'-dpng')
% 
% NumberPeriods   = 3;
% tacsFreq        = 25;
% Fs              = 1000;
% kernel = filter.kernel.create(NumberPeriods,tacsFreq,Fs);
% filter.kernel.response(kernel,Fs)
% set(gcf,'Position',[100 100 1200 500],'paperpositionmode','auto')
% print(gcf,[printfolder,'shapeless_3_25.png'],'-dpng')
