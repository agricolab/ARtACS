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
%title('Distortion')
print(gcf,[printfolder,'distortion.png'],'-dpng')

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
set(gca,'YTICK',-5000:100:5000,'YLIM',[2750 3250],'YTICKLABEL',[])
xlabel('Phase in degree (°)')
l1 = legend([h1(1),h2],'Periods','Average','location','northoutside')
set(l1,'position',[0.85 .85 0 .125])
%title('Saturation')
print(gcf,[printfolder,'saturation.png'],'-dpng')

%%
close all

NumberPeriods   = 10;
tacsFreq        = 10;
Fs              = 1000;

filter.kernel.response(filter.kernel.create((NumberPeriods./2),tacsFreq,Fs,'sma'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'kernel_sma.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'ave'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'kernel_ave.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'linear'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'kernel_linear.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'exp'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'kernel_exp.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'gauss'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'kernel_gauss.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'cauchy'),Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])
print(gcf,[printfolder,'kernel_cauchy.png'],'-dpng')


%%%%

filter.kernel.response(filter.kernel.create((NumberPeriods./2),tacsFreq,Fs,'sma'),Fs,2,25)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'mag_sma.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'ave'),Fs,2,25)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'mag_ave.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'linear'),Fs,2,25)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'mag_linear.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'exp'),Fs,2,25)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'mag_exp.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'gauss'),Fs,2,25)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'mag_gauss.png'],'-dpng')

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'cauchy'),Fs,2,25)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
print(gcf,[printfolder,'mag_cauchy.png'],'-dpng')
%%
close all
for tau = 1:10
filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'gauss',tau),Fs,1)
set(gcf,'Position',[100 600 400 300],'paperpositionmode','auto')
set(gca,'ylim',[-.75 1.1])

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'gauss',tau),Fs,2,25)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')

end
%%
close all
for tau = 1: 10,
% filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'exp',tau),Fs,1)
% set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
% set(gca,'ylim',[-.75 1.1])

filter.kernel.response(filter.kernel.create(NumberPeriods,tacsFreq,Fs,'exp',tau),Fs,2,25)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
end
%%

filter.kernel.response(filter.kernel.create(1,tacsFreq,Fs,'ave'),Fs,2,25)

filter.kernel.response(filter.kernel.create(1,tacsFreq,Fs,'ave'),Fs,1)

%%
k = filter.kernel.create(NumberPeriods./2,10,Fs,'ave');
k = conv(k,fliplr(k),'same');
%k = (k+fliplr(k))./2;
filter.kernel.response(k,Fs,2,25)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
%print(gcf,[printfolder,'mag_exp.png'],'-dpng')

filter.kernel.response(k,Fs,1)
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
%print(gcf,[printfolder,'kernel_exp.png'],'-dpng')