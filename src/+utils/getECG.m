function tru = getECG(filename)

curdir = pwd;
datafolder = [pwd,'\dev\data\ecg\'];
ftfolder ='C:\Users\Robert Bauer\Documents\Matlab\other_toolboxes\fieldtrip';
cd(ftfolder),system('git pull');
cd(curdir);
ft_defaults;


trange                      = 4000;

cfg                         = [];
cfg.trialfun                = 'ft_trialfun_general';
cfg.dataset                 = [datafolder,filename];
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