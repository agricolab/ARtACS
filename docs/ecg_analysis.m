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
    
    tmp = ECG(coi,toi)-mean(ECG(coi,toi));    
    tru = cat(1,tru,tmp);
end
close all
figure
plot(mean(-tru,1))
%
cfg                         = [];
cfg.trialfun                = 'ft_trialfun_general';
cfg.dataset                 = [datafolder,'10Hz.vhdr'];
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
for hp_idx = 1 : length(HeartPeaks)
    toi = int32(HeartPeaks(hp_idx,1));
    toi = (toi-trange):(toi+trange);
    if min(toi)<0 || max(toi)>length(ECG), continue; end    
    tmp = ECG(coi,toi)-mean(ECG(coi,toi));
    trl = cat(1,trl,tmp);            
end
close all
figure
hold on
plot(mean(-trl,1))
plot(mean(-tru,1))
%

% Filtering
%
filt_axis       = {'Causal Uniform','Causal Linear','Causal Exponential','Causal Gaussian','Symmetric Uniform','Symmetric Linear','Symmetric Exponential','Symmetric Gaussian','Adaptive DFT','Efferent Copy'};
filt_type       = {'ave','linear','exp','gauss','ave','linear','exp','gauss'};
% sym_type        = {'causal','causal','causal','causal','symmetric','symmetric','symmetric','symmetric'};
sym_type        = {'flipped','flipped','flipped','flipped','symflipped','symflipped','symflipped','symflipped'};
NumberPeriods   = 16;
tacsFreq        = 10;
Fs              = 1000;
toi             = trange-250:trange+251;
%toi             = trange-49:trange+49;
R               = [];
e               = mean(-tru,1);
F               = [];
for trl_idx = 1 : size(trl,1)
    r = trl(trl_idx,:);
    for fidx = 1 : length(filt_type)   
        f               = artacs.kernel.run(r,NumberPeriods,tacsFreq,Fs,filt_type{fidx},sym_type{fidx},5);                
        recover         = corr(f(toi)',e(1,toi)');     % true signal -> erp
        R(fidx,trl_idx)   = recover;   
        F(fidx,trl_idx,:) = f;
    end
    f                   = artacs.dft.local(r,tacsFreq,Fs,NumberPeriods);            
    recover             = corr(f(toi)',e(1,toi)');    % true signal -> erp
    R(fidx+1,trl_idx)   = recover;
    F(fidx+1,trl_idx,:) = f;
end    
    
koi = 0:0.01:1;
KxR = [];
for fidx = 1 : size(R,1)
    kx = ksdensity(R(fidx,:).^2,koi,'width',0.05);
    kx = kx./max(kx);   
    kx(kx<0.001) =NaN;  
    KxR = cat(1,KxR,kx);        
end
%
close all
figure
set(gcf,'Position',[500 100 700 300],'paperpositionmode','auto')
for fidx = 1 : size(R,1)
    line(fidx+(.25*-KxR(fidx,:)),koi,'color','k');
    line(fidx+(.25*+KxR(fidx,:)),koi,'color','k');
    m = mean(R(fidx,:).^2); 
    line([fidx-.1,fidx+.1],[m,m],'color','b','linewidth',2)         
    m = mean(koi(KxR(fidx,:)>0.95));         
    line([fidx-.1,fidx+.1],[m,m],'color','r','linewidth',2)
end
set(gca,'ylim',[0 1],'ytick',[0:0.2:1],'yticklabel',[0:.2:1])
set(gca,'xlim',[0.5 fidx+.5],'xtick',1:fidx,'xticklabel',filt_axis,'xaxislocation','bottom')
set(gca,'XTickLabelRotation',45)
ylabel('Recovery (R²)')
grid on


figure
hold on
%plot(mean(trl(:,toi),1))
plot(mean(tru(:,toi),1))
plot(squeeze(mean(F(:,:,toi),2))')

%
%%
