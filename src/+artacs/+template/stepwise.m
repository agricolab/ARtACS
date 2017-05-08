function filt_sig = stepwise(Signal,Freq,Fs)    
%% up/downsample if necessary to allow integer periods
period  = Fs/Freq;
resample_flag = (period ~= int32(period));
trueSig     = Signal;
trueFs      = Fs;          
if resample_flag
    period      = ceil(period);
    Fs          = period*Freq;
    %upsample signal to match period with kernel
    Signal         = resample(trueSig,Fs,trueFs);        
end
%% cut into period length epochs and estimate autocorrelation
pincl       = floor(length(Signal)./period);
tmp_sig     = Signal(1:pincl*period);
SS = [];
for phase_idx = 1 : period
    SS = cat(1,SS,tmp_sig(phase_idx:period:end));   
end
%% remove from signal
[c,s]           = pca(SS);
filt_sig        = SS;
artifact_idx    = round(Freq/Fs*length(tmp_sig)) + 1;
%physio_idx      = round(1:45/Fs*length(tmp_sig)) + 1;
physio_idx1      = round((Freq-2)/Fs*length(tmp_sig)) + 1;
physio_idx2      = round((Freq+2)/Fs*length(tmp_sig)) + 1;
ffx             = fft(reshape(filt_sig,1,[]));
ArtifactPower   = abs(ffx(artifact_idx))./median(abs(ffx(physio_idx1:physio_idx2)));

% remove components until artifact power is as low as neighbouring frequencies
comp_idx = 0;
while ArtifactPower > 1
    
    comp_idx        = comp_idx + 1;
	removeSignal    = c(:,comp_idx)*s(:,comp_idx)';
    filt_sig        = filt_sig-removeSignal';
    
    ffx             = fft(reshape(filt_sig,1,[]));
    ArtifactPower   = abs(ffx(artifact_idx))./median(abs(ffx(physio_idx1:physio_idx2)));
end

%% 
filt_sig  = reshape(filt_sig,1,[]);

while length(filt_sig) < length(Signal)
    filt_sig = cat(2,filt_sig,0);
end

if resample_flag
    filt_sig = resample(filt_sig,trueFs,Fs);
end

filt_sig = filt_sig(1:length(trueSig));

filt_sig =detrend(filt_sig);
end
