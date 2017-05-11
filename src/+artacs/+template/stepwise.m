% PeriodResolution sets the resolution of seed periods to prevent corner artifacts in Percent.
% Defaults to five 'randomly' selected periods
% PeriodResolution = 'random';
% PeriodResolution = 10 -> 10 percent steps from 1 to period length
% PeriodResolution = 1 -> 1 percent steps from 1 to period length
function FilteredSignal = stepwise(Signal,Freq,Fs,PeriodResolution)    
%% up/downsample if necessary to allow integer periods
period          = Fs/Freq;
resample_flag   = (period ~= int32(period));
trueL           = length(Signal);
trueFs          = Fs;          

if resample_flag %upsample signal to make period length an integer
    period      = ceil(period);
    Fs          = period*Freq;
    Signal      = resample(Signal,Fs,trueFs);        
end
InitSignal  = Signal;

% Select Period Starting Seeds
if nargin < 4, PeriodResolution = 'random'; end
if strcmpi(PeriodResolution,'default') 
    %PeriodResolution = 100;
    PeriodResolution = 'random';
end

if strcmpi(PeriodResolution,'random')
    P           = period:-1:1;
    rng('shuffle');
    P           = datasample(P,5);
    
elseif isnumeric(PeriodResolution)
    if PeriodResolution > 100, PeriodResolution  = 100; end
    PeriodResolution = ceil(PeriodResolution*period/100);
    P           = period:-1:1;
    P           = P(fix(1:PeriodResolution:end));
    if isempty(P), P = 1; end

end


F           =  [];
for PeriodShift = P

Signal              = InitSignal(PeriodShift:end-PeriodShift+1);
% remove components until artifact power is as low as neighbouring frequencies
ArtifactPower       = calcpower(Signal,Freq,Fs);
BlockSignal         = signal2period(Signal,period);

IterNum     = 0;
while ArtifactPower > 1
    IterNum     = IterNum + 1;
    BlockSignal         = removetemplate(BlockSignal);
    ReconstructedSignal = period2signal(BlockSignal);
    ArtifactPower       = calcpower(ReconstructedSignal,Freq,Fs);
end

% reshape, append and detrend
FilteredSignal = period2signal(BlockSignal);
FilteredSignal = [NaN(1,PeriodShift-1),FilteredSignal,NaN(1,PeriodShift-1)];
while length(FilteredSignal) < length(InitSignal)
    FilteredSignal = cat(2,FilteredSignal,NaN);
end
F              = cat(1,F,FilteredSignal);
end
FilteredSignal = nanmean(F,1);
FilteredSignal = interp1(find(~isnan(FilteredSignal)),FilteredSignal(~isnan(FilteredSignal)),1:length(FilteredSignal),'linear','extrap');

if resample_flag
    FilteredSignal = resample(FilteredSignal,trueFs,Fs);
end
FilteredSignal = FilteredSignal(1:trueL);


end


%%
% remove first component of artifact modulation across periods
function BlockSignal = removetemplate(BlockSignal)
    [c,s]               = pca(BlockSignal);
    RemoveSignal        = c(:,1)*s(:,1)';
    BlockSignal         = BlockSignal-RemoveSignal';    
end


% cut into period length epochs and estimate autocorrelatio
function [BlockSignal] = signal2period(Signal,period)

pincl       = floor(length(Signal)./period);
tmp_sig     = Signal(1:pincl*period);
BlockSignal = [];
for phase_idx = 1 : period
    BlockSignal = cat(1,BlockSignal,tmp_sig(phase_idx:period:end));   
end
end

% cut into period length epochs and estimate autocorrelation
function ReconstructedSignal = period2signal(BlockSignal)
    ReconstructedSignal         = reshape(BlockSignal,1,[]);
end

function ArtifactPower = calcpower(Signal,Freq,Fs)
    L               = length(Signal);
    artifact_idx    = round(Freq/Fs*L) + 1;
    physio_idx1     = round((Freq-2)/Fs*L) + 1;
    physio_idx2     = round((Freq+2)/Fs*L) + 1;
    ffx             = fft(Signal);
    ArtifactPower   = abs(ffx(artifact_idx))./median(abs(ffx(physio_idx1:physio_idx2)));    
end