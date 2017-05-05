matlabrc 
ftfolder ='C:\Users\Robert Bauer\Documents\Matlab\other_toolboxes\fieldtrip';
cd(ftfolder),system('git pull');
cd('C:\Users\Robert Bauer\OneDrive\Work\publish\wip\ARtACS\')%
addpath(ftfolder);
ft_defaults;
addpath('.\src\')
printfolder = '.\docs\img\';
datafolder = '.\dev\data\ecg\';
%%
D = dir([datafolder,'*.vhdr']);
trange = 2000;

cfg                         = [];
cfg.trialfun                = 'ft_trialfun_general';
cfg.dataset                 = [datafolder,'clean.vhdr'];
%cfg.dataset                 = [datafolder,'clean_post.vhdr'];
cfg.trialdef.triallength    = Inf;
cfg                         = ft_definetrial(cfg);
data                        = ft_preprocessing(cfg);


cfg                         = [];
cfg.channel                 = data.label;
cfg.lpfilter                = 'yes';
cfg.lpfreq                  = 35;
data                        = ft_preprocessing(cfg,data);

ECG                         = data.trial{1};

HeartPeaks = mspeaks(1:length(ECG),ECG(1,:).^2,'oversegmentationfilter',500);
coi  = 3;
tru  = [];
for hp_idx = 1 : length(HeartPeaks)  
    toi = int32(HeartPeaks(hp_idx,1));
    toi = (toi-trange):(toi+trange);
    if min(toi)<0 || max(toi)>length(ECG), continue; end
    
  %  tmp = ECG(coi,toi)-mean(ECG(coi,toi));    
    
    % bipolar
    tmp = ECG(3,toi)-ECG(2,toi);
    tmp = detrend(tmp-mean(tmp));   

    tru = cat(1,tru,tmp);
end
close all
figure
plot(mean(-tru,1))
%
cfg                         = [];
cfg.trialfun                = 'ft_trialfun_general';
cfg.dataset                 = [datafolder,'10Hz.vhdr'];
%cfg.dataset                 = [datafolder,'10Hz3ma.vhdr'];
%cfg.dataset                 = [datafolder,'11Hz.vhdr'];
cfg.trialdef.triallength    = Inf;
cfg                         = ft_definetrial(cfg);
data                        = ft_preprocessing(cfg);

cfg                         = [];
cfg.channel                 = data.label;
cfg.lpfilter                = 'yes';
cfg.lpfreq                  = 35;
data                        = ft_preprocessing(cfg,data);

ECG                         = data.trial{1};

HeartPeaks = mspeaks(1:length(ECG),ECG(1,:).^2,'oversegmentationfilter',500);
trl     = [];
fltrd   = [];
amp     = [];
for hp_idx = 1 : length(HeartPeaks)
    toi = int32(HeartPeaks(hp_idx,1));
    toi = (toi-trange):(toi+trange);
    if min(toi)<0 || max(toi)>length(ECG), continue; end    
   % tmp = ECG(coi,toi)-mean(ECG(coi,toi));
    
    % bipolar
    tmp = ECG(3,toi)-ECG(2,toi);
    tmp = tmp-mean(tmp);   
        
    trl = cat(1,trl,tmp);            
end

close all
figure
hold on
plot(mean(-trl,1))
plot(mean(-tru,1))
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtering
%
filt_axis       = {'Causal Uniform','Causal Linear','Causal Exponential','Causal Gaussian','Symmetric Uniform','Symmetric Linear','Symmetric Exponential','Symmetric Gaussian','Adaptive DFT','Autoadaptive'};
filt_type       = {'ave','linear','exp','gauss','ave','linear','exp','gauss'};
sym_type        = {'causal','causal','causal','causal','symmetric','symmetric','symmetric','symmetric'};
%sym_type        = {'flipped','flipped','flipped','flipped','symflipped','symflipped','symflipped','symflipped'};
NumberPeriods   = 10;
tacsFreq        = 10;
Fs              = 1000;

%toi             = trange-250:trange+251;
%toi             = trange-49:trange+49;
toi             = trange-149:trange+149;
R               = [];
e               = mean(tru,1);
e               = e-mean(e);
F               = [];

H = [];
for trl_idx = 1 : size(trl,1)
    r = trl(trl_idx,:);
    for fidx = 1 : length(filt_type)   
        f               = artacs.kernel.run(r,NumberPeriods,tacsFreq,Fs,filt_type{fidx},sym_type{fidx});                
        recover         = corr(f(toi)',e(1,toi)');     % true signal -> erp
        R(fidx,trl_idx)   = recover;   
        F(fidx,trl_idx,:) = f;
    end
    f                   = artacs.dft.local(r,tacsFreq,Fs,NumberPeriods);                
    recover             = corr(f(toi)',e(1,toi)');    % true signal -> erp
    R(fidx+1,trl_idx)   = recover;
    F(fidx+1,trl_idx,:) = f;
    
    kernel              = artacs.kernel.autocorr(r,NumberPeriods,tacsFreq,Fs);
    H                   = cat(1,H,kernel.h);
    f                   = artacs.kernel.runpredefined(r,kernel);
    recover             = corr(f(toi)',e(1,toi)');    % true signal -> erp
    R(fidx+2,trl_idx)   = recover;
    F(fidx+2,trl_idx,:) = f;
end

%%
avefun = @(x,prm)median(x,prm);

koi = 0:0.01:1;
KxR = [];
KxA = [];
trl_num = size(F,2);
MR = [];
for fidx = 1 : size(R,1)
    kx = ksdensity(R(fidx,:).^2,koi,'width',0.05);
    kx = kx./max(kx);   
    kx(kx<0.001) =NaN;  
    KxR = cat(1,KxR,kx);        
    
    bootstat = [];
    smpl_num = 30;
    for bot_rep = 1 : 100
        bootstat = cat(2,bootstat,squeeze(avefun(F(fidx,datasample(1:trl_num,smpl_num),toi),2)));
    end
    r   = diag(corr(bootstat,repmat(e(1,toi),100,1)'));    
    MR = [MR,mean(r.^2)];
    kx  = ksdensity(r.^2,koi,'width',0.05);
    kx  = kx./max(kx);   
    kx(kx<0.001) =NaN;  
    KxA = cat(1,KxA,kx);       
end

%
close all
figure
set(gcf,'Position',[500 100 700 300],'paperpositionmode','auto')
for fidx = 1 : size(R,1)
    line(fidx+(.25*-KxR(fidx,:))-.2,koi,'color','k');
    line(fidx+(.25*+KxR(fidx,:))-.2,koi,'color','k');        
    m = mean(R(fidx,:).^2); 
    hs = line([fidx-.3,fidx-.1],[m,m],'color','b','linewidth',2);
    
    line(fidx+(.25*-KxA(fidx,:))+.2,koi,'color','k');
    line(fidx+(.25*+KxA(fidx,:))+.2,koi,'color','k');
    m  = corr(mean(tru(:,toi))',squeeze(avefun(F(fidx,:,toi),2))).^2;
    m = MR(fidx);
    ha = line([fidx+.1,fidx+.3],[m,m],'color','r','linewidth',2);
    
end
set(gca,'ylim',[0 1],'ytick',[0:0.2:1],'yticklabel',[0:.2:1])
set(gca,'xlim',[0.5 fidx+.5],'xtick',1:fidx,'xticklabel',filt_axis,'xaxislocation','bottom')
set(gca,'XTickLabelRotation',45)
lh = legend([hs,ha],'Single Trial',['Averaged n= ',num2str(smpl_num)]);
set(lh,'position',[0.15 .85 0 .130])
ylabel('Recovery (R²)')
grid on
print(gcf,[printfolder,'eva\recovery_ecg.png'],'-dpng')


figure
hold on
plot(mean(tru(:,toi),1))
plot(squeeze(avefun(F(:,:,toi),2))')

figure
hold on
plot(mean(tru(:,toi),1))
plot(squeeze(avefun(F(8,:,toi),2))')
legend('Without tacs','With Artifact Removed')


figure
hold on
plot(mean(tru(:,toi),1))
plot(squeeze(avefun(F(:,datasample(1:trl_num,smpl_num),toi),2))')

a_pwr   = mean(range(trl(:,toi),2));
s_pwr   = mean(range(tru(:,toi),2));
snr_dB  = 20*log(a_pwr/s_pwr)

a_pwr   = max(range(trl(:,toi),2));
s_pwr   = min(range(tru(:,toi),2));
snr_dB  = 20*log(a_pwr/s_pwr)

a_pwr   = min(range(trl(:,toi),2));
s_pwr   = max(range(tru(:,toi),2));
snr_dB  = 20*log(a_pwr/s_pwr)

%%
tit_set     = {'Symmetric Gaussian','Causal Uniform','Adaptive DFT'};
e               = mean(tru,1);
e               = e-mean(e);
clear f
f(1,:)      = squeeze(avefun(F(8,:,:),2))';
f(2,:)      = squeeze(avefun(F(1,:,:),2))';
f(3,:)      = squeeze(avefun(F(9,:,:),2))';

close all
figure
set(gcf,'Position',[100 100 400 300],'paperpositionmode','auto')
subplot(2,1,1)
hold on
h1 = plot(trl(1,:),'color',[.8 .8 .8],'linewidth',2);
h2 = plot(e,'r');
set(gca,'xlim',[1501,2501],'xtick',[1:250:4000],'xticklabel',[-2000:250:2000])
set(gca,'ylim',[-20000 20000],'ytick',[-20000,0,20000],'yticklabel',[-20,0,20])
ylabel('mV')
subplot(2,1,2)
hold on
h1 = plot(trl(1,:),'color',[.8 .8 .8],'linewidth',2);
h2 = plot(mean(tru,1),'r');
set(gca,'xlim',[1501,2501],'xtick',[1:250:4000],'xticklabel',[-2000:250:2000])
set(gca,'ylim',[-15 20],'ytick',[-1000:10:1000])
ylabel('µV')
xlabel('ms')
lh = legend([h1,h2],'Recording','True Signal');
set(lh,'position',[0.8 .85 .08 .08])
print(gcf,[printfolder,'eva\ecg_raw.png'],'-dpng')

figure
set(gcf,'Position',[100 100 1200 300],'paperpositionmode','auto')
for k=1:3
    subplot(1,3,k)
    hold on
    h2 = plot(e(1,:),'color',[.8 .8 .8],'linewidth',2);
    h1 = plot(f(k,:),'b','linewidth',1);      
    %set(gca,'xlim',[1921,2081],'xtick',[1:25:4000],'xticklabel',[-2000:25:2000])
	
    set(gca,'xlim',[1501,2501],'xtick',[1:250:4000],'xticklabel',[-2000:250:2000])
    set(gca,'ylim',[-15 20],'ytick',[-1000:10:1000])

    title(tit_set{k})
end
lh = legend([h2,h1],'True Signal','Recovered Signal');
set(lh,'position',[0.1 .8 .08 .08])
print(gcf,[printfolder,'eva\ecg_filtered.png'],'-dpng')
%

close all
figure
set(gcf,'Position',[100 100 800 600],'paperpositionmode','auto')
subplot(2,2,1)
hold on
h1 = plot(trl(1,:),'color',[.8 .8 .8],'linewidth',2);
h2 = plot(e,'r');
set(gca,'xlim',[1501,2501],'xtick',[1:250:4000],'xticklabel',[-2000:250:2000])
set(gca,'ylim',[-20000 20000],'ytick',[-20000,0,20000],'yticklabel',[-20,0,20])
ylabel('mV')
subplot(2,2,3)
hold on
h1 = plot(trl(1,:),'color',[.8 .8 .8],'linewidth',2);
h2 = plot(mean(tru,1),'r');
set(gca,'xlim',[1501,2501],'xtick',[1:250:4000],'xticklabel',[-2000:250:2000])
set(gca,'ylim',[-15 20],'ytick',[-1000:10:1000])
ylabel('µV')
lh = legend([h1,h2],'Artifacted Recording','True Signal');
set(lh,'position',[0.35 .85 .08 .08])

subplot(2,2,2)
hold on
h2 = plot(e(1,:),'color','r','linewidth',2);
h1 = plot(f(1,:),'b','linewidth',1);      
set(gca,'xlim',[1501,2501],'xtick',[1:250:4000],'xticklabel',[-2000:250:2000])
set(gca,'ylim',[-15 20],'ytick',[-1000:10:1000])
title(tit_set{1})

subplot(2,2,4)
hold on
h2 = plot(e(1,:),'color','r','linewidth',2);
h1 = plot(f(2,:),'b','linewidth',1);      
set(gca,'xlim',[1501,2501],'xtick',[1:250:4000],'xticklabel',[-2000:250:2000])
set(gca,'ylim',[-15 20],'ytick',[-1000:10:1000])
title(tit_set{2})
lh = legend([h1,h2],'Recovered Signal','True Signal');
set(lh,'position',[0.85 .85 .08 .08])


print(gcf,[printfolder,'eva\ecg_overview.png'],'-dpng')
%
%%
