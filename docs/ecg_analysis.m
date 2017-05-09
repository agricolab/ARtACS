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
trange = 4000;
%% Load stim-free data
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
    
    % bipolar
    tmp = ECG(3,toi)-ECG(2,toi);
    tmp = detrend(tmp);
    tmp = tmp-mean(tmp);
    tru = cat(1,tru,tmp);
end
%% Run across the three stimulation data sets

dataset_names   = {'10Hz.vhdr','10Hz3ma.vhdr','11Hz.vhdr'};
dataset_freq    = [10,10,11];
close all
for dset_idx = 1 : length(dataset_names)
%
cfg                         = [];
cfg.trialfun                = 'ft_trialfun_general';
%cfg.dataset                 = [datafolder,'10Hz.vhdr'];
%cfg.dataset                 = [datafolder,'10Hz3ma.vhdr'];
%cfg.dataset                 = [datafolder,'11Hz.vhdr'];
cfg.dataset                 = [datafolder,dataset_names{dset_idx}];
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
clc
fprintf(1,'Finished\n')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtering
%
filt_axis       = {'Causal Uniform','Causal Linear','Causal Exponential','Causal Gaussian','Causal Automatic',...
                    'Symmetric Uniform','Symmetric Linear','Symmetric Exponential','Symmetric Gaussian','Symmetric Automatic',...
                    'Piecewise Uniform','Piecewise  Linear','Piecewise  Exponential','Piecewise Gaussian','Piecewise Automatic',...
                    'Adaptive DFT','Adaptive PCA','Stim-free Bootstrap'};
filt_type       = {'ave','linear','exp','gauss','automatic','ave','linear','exp','gauss','automatic','ave','linear','exp','gauss','automatic'};
sym_type        = {'causal','causal','causal','causal','causal','symmetric','symmetric','symmetric','symmetric','symmetric','piecewise','piecewise','piecewise','piecewise','piecewise'};
inc_type        = {'dec','dec','dec','dec','dec','inc','inc','inc','inc','inc','dec','dec','dec','dec','dec'};
%inc_type        = {'dec','dec','dec','dec','dec','inc','inc','inc','inc','inc','inc','inc','inc','inc','inc'};
Delay           = [0 0 0 0 0,5 5 5 5 5,0 0 0 0 0];
%Delay           = [0 0 0 0 0,0 0 0 0 0,5 5 5 5 5];
Latency         = trange+1;
NumberPeriods   = 10;
%tacsFreq        = 10;
%tacsFreq        = 11;
tacsFreq        = dataset_freq(dset_idx);
Fs              = 1000;

toi             = trange-250:trange+251;

R               = [];
e               = mean(tru,1);
e               = e-mean(e);
F               = [];

H = [];
for trl_idx = 1 : size(trl,1)
    r = trl(trl_idx,:);
    for fidx = 1 : length(filt_type)         
        f               = artacs.kernel.run(r,NumberPeriods,tacsFreq,Fs,sym_type{fidx},filt_type{fidx},'default',inc_type{fidx},Delay(fidx),Latency);          
        recover         = corr(f(toi)',e(1,toi)');     % true signal -> erp
        R(fidx,trl_idx)   = recover;   
        F(fidx,trl_idx,:) = utils.baseline(f,trange-500:trange-100,1);
        
    end
    freqharm            = [1:4]*tacsFreq;
    f                   = artacs.dft.local(r,freqharm,Fs,NumberPeriods);
    %f                   = artacs.dft.local(r,tacsFreq,Fs,NumberPeriods);                
          
    recover             = corr(f(toi)',e(1,toi)');    % true signal -> erp
    R(fidx+1,trl_idx)   = recover;
    F(fidx+1,trl_idx,:) = utils.baseline(f,trange-500:trange-100,1);
    
    f                   = artacs.template.stepwise(r,tacsFreq,Fs,'random');
    recover             = corr(f(toi)',e(1,toi)');    % true signal -> erp
    R(fidx+2,trl_idx)   = recover;
    F(fidx+2,trl_idx,:) = utils.baseline(f,trange-500:trange-100,1);
   
    f                   = tru(datasample(1:size(tru,1),1),:);
    recover             = corr(f(toi)',e(1,toi)');    % true signal -> erp
    R(fidx+3,trl_idx)   = recover;
    F(fidx+3,trl_idx,:) = utils.baseline(f,trange-500:trange-100,1);
end
%
if ismember(dset_idx,[1,2])
    Efun      = @(x,prm)nanmedian(x,prm);
else
    Efun      = @(x,prm)nanmean(x,prm);
end

figure
set(gcf,'Position',[100 100 1200 1000],'paperpositionmode','auto')
%ci = cat(1,quantile(squeeze(F(end,:,toi)),0.95),quantile(squeeze(F(end,:,toi)),0.05));
[h,p,ci] = ttest(squeeze(F(end,:,toi)));
for fidx = 1:size(F,1)    
    subplot(4,5,fidx)
    hold on
        
    h3 = patch([1:length(ci),length(ci):-1:1],[ci(1,:),fliplr(ci(2,:))],ones(1,length(ci)*2),'facecolor',[0.8500 0.3250 0.0980],'facealpha',0.25,'edgecolor',[0.8500 0.3250 0.0980],'edgealpha',0.1);                
    h1 = plot(Efun(squeeze(F(end,:,toi)),1),'linewidth',1,'color',[0.8500 0.3250 0.0980]);
    if fidx ~= 18        
        %h1 = plot(Efun(tru(:,toi),1),'linewidth',2,'color',[0.8500 0.3250 0.0980]);
        h2 = plot(squeeze(Efun(F(fidx,:,toi),2))','linewidth',2,'color',[0 0.4470  0.7410]);
    end
    set(gca,'xlim',[1 length(toi)],'xtick',[1:100:4000],'xticklabel',[(-length(toi)/2+1):100:length(toi)/2])
    set(gca,'ylim',[-20 20],'ytick',[-1000:10:1000])
    title(filt_axis{fidx})   
end
h = legend([h1,h2],'Stim-free Comparison','Artifact Removed');
set(h,'position',[0.7 .15 .08 .08])
printname = dataset_names{dset_idx}(1:regexp(dataset_names{dset_idx},'.vhdr')-1);
print(gcf,[printfolder,'eva\ecg_TD_',printname,'.png'],'-dpng')

%
foi = 1:0.1:45;
PXX = [];
for fidx = 1:size(F,1)
    for tidx = 1: size(F,2)
        pxx = 20*log10(pwelch(squeeze(F(fidx,tidx,toi)),500,125,foi,1000));
        PXX(fidx,tidx,:) = pxx;
    end
end

[h,p,ci] = ttest(squeeze(PXX(end,:,:)));
ci = cat(1,quantile(squeeze(PXX(end,:,:)),0.95),quantile(squeeze(PXX(end,:,:)),0.05));
figure
set(gcf,'Position',[100 100 1200 1000],'paperpositionmode','auto')
for fidx = 1:size(F,1)
    subplot(4,5,fidx)
    hold on
                   
    h3 = patch([foi,fliplr(foi)],[ci(1,:),fliplr(ci(2,:))],ones(1,length(ci)*2),'facecolor',[0.8500 0.3250 0.0980],'facealpha',0.25,'edgecolor',[0.8500 0.3250 0.0980],'edgealpha',0.1);                
    h1 = plot(foi,Efun(squeeze(PXX(end,:,:)),1),'linewidth',1,'color',[0.8500 0.3250 0.0980]);
      
    if fidx ~= 18                
        [~,~,ci2] = ttest(squeeze(PXX(fidx,:,:)));
        ci2 = cat(1,quantile(squeeze(PXX(fidx,:,:)),0.95),quantile(squeeze(PXX(fidx,:,:)),0.05));
        pxx = Efun(squeeze(PXX(fidx,:,:)),1);        
        h4 = patch([foi,fliplr(foi)],[ci2(1,:),fliplr(ci2(2,:))],ones(1,length(ci2)*2),'facecolor',[0 0.4470  0.7410],'facealpha',0.25,'edgecolor',[0 0.4470  0.7410],'edgealpha',0.1);                
        h2  = plot(foi,pxx,'linewidth',2,'color',[0 0.4470  0.7410]);
    end
    set(gca,'ylim',[-100 50],'ytick',[-100:25:50])
    set(gca,'xlim',[foi(1)-1,foi(end)],'xtick',[0,foi(91:100:end)])
    title(filt_axis{fidx})   
end
h = legend([h1,h2],'Stim-free Comparison','Artifact Removed');
set(h,'position',[0.7 .15 .08 .08])
printname = dataset_names{dset_idx}(1:regexp(dataset_names{dset_idx},'.vhdr')-1);
print(gcf,[printfolder,'eva\ecg_Pxx_',printname,'.png'],'-dpng')







end
%% Finish with 11 Hz, save some figures
%%
%Efun      = @(x,prm)median(x,prm);
Efun      = @(x,prm)mean(x,prm);
close all
figure
set(gcf,'Position',[100 100 800 700],'paperpositionmode','auto')
count = 0;
for fidx = [4,6,14,10,16,17]
    count = count+1;
    subplot(3,2,count)
    hold on
    
    [h,p,ci] = ttest(squeeze(F(end,:,toi)));                
    h3 = patch([1:length(ci),length(ci):-1:1],[ci(1,:),fliplr(ci(2,:))],ones(1,length(ci)*2),'facecolor',[0.8500 0.3250 0.0980],'facealpha',0.25,'edgecolor',[0.8500 0.3250 0.0980],'edgealpha',0.1);                
    h1 = plot(mean(ci),'linewidth',1,'color',[0.8500 0.3250 0.0980]);
    if fidx ~= 18        
        %h1 = plot(Efun(tru(:,toi),1),'linewidth',2,'color',[0.8500 0.3250 0.0980]);
        h2 = plot(squeeze(Efun(F(fidx,:,toi),2))','linewidth',2,'color',[0 0.4470  0.7410]);
    end
    set(gca,'xlim',[1 length(toi)],'xtick',[1:50:4000],'xticklabel',[(-length(toi)/2+1):50:length(toi)/2])
    set(gca,'ylim',[-20 20],'ytick',[-1000:10:1000])
    title(filt_axis{fidx})   
end
h = legend([h1,h2],'Stim-free Comparison','Artifact Removed');
set(h,'position',[0.08 .84 .08 .08])
print(gcf,[printfolder,'eva\ecg_performance.png'],'-dpng')
%%
clc
smpl_num    = 100;
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
    for bot_rep = 1 : 200
        bootstat = cat(2,bootstat,squeeze(Efun(F(fidx,datasample(1:trl_num,smpl_num),toi),2)));
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
set(gcf,'Position',[500 100 900 300],'paperpositionmode','auto')
for fidx = 1 : size(R,1)
    line(fidx+(.25*-KxR(fidx,:))-.2,koi,'color','k');
    line(fidx+(.25*+KxR(fidx,:))-.2,koi,'color','k');        
    m = mean(R(fidx,:).^2); 
    hs = line([fidx-.3,fidx-.1],[m,m],'color','b','linewidth',2);
    
    line(fidx+(.25*-KxA(fidx,:))+.2,koi,'color','k');
    line(fidx+(.25*+KxA(fidx,:))+.2,koi,'color','k');
    m  = corr(mean(tru(:,toi))',squeeze(Efun(F(fidx,:,toi),2))).^2;
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

a_pwr   = mean(range(trl(:,toi),2));
s_pwr   = mean(range(tru(:,toi),2));
snr_dB  = 20*log(a_pwr/s_pwr)

a_pwr   = max(range(trl(:,toi),2));
s_pwr   = min(range(tru(:,toi),2));
snr_dB  = 20*log(a_pwr/s_pwr);

a_pwr   = min(range(trl(:,toi),2));
s_pwr   = max(range(tru(:,toi),2));
snr_dB  = 20*log(a_pwr/s_pwr);

%%
tit_set     = {'Symmetric Gaussian','Causal Uniform','Adaptive DFT'};
e               = mean(tru,1);
e               = e-mean(e);
clear f
f(1,:)      = squeeze(Efun(F(8,:,:),2))';
f(2,:)      = squeeze(Efun(F(1,:,:),2))';
f(3,:)      = squeeze(Efun(F(9,:,:),2))';

close all
figure
set(gcf,'Position',[100 100 500 400],'paperpositionmode','auto')
subplot(2,1,1)
hold on
h1 = plot(trl(1,toi),'color',[.8 .8 .8],'linewidth',2);
h2 = plot(e(toi),'r');
set(gca,'xlim',[1 length(toi)],'xtick',[1:50:4000],'xticklabel',[(-length(toi)/2+1):50:length(toi)/2])
set(gca,'ylim',[-20000 20000],'ytick',[-20000,-10000,0,10000,20000],'yticklabel',[-20,10,0,10,20])
ylabel('mV')
subplot(2,1,2)
hold on
h1 = plot(trl(1,toi),'color',[.8 .8 .8],'linewidth',2);
h2 = plot(e(toi),'r');
set(gca,'xlim',[1 length(toi)],'xtick',[1:50:4000],'xticklabel',[(-length(toi)/2+1):50:length(toi)/2])
set(gca,'ylim',[-20 20],'ytick',[-1000:10:1000])
ylabel('µV')
xlabel('ms')
lh = legend([h1,h2],'Artifacted Recording','Stim-free Comparison');
set(lh,'position',[0.8 .85 .08 .08])
print(gcf,[printfolder,'eva\ecg_raw.png'],'-dpng')
%
%%
