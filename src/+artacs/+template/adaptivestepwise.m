% function FilteredSignal = stepwise(Signal,Freq,Fs,PeriodResolution)    
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

%upsample signal to make period length an integer
if resample_flag 
    period      = ceil(period);
    Fs          = period*Freq;
    Signal      = resample(Signal,Fs,trueFs);        
end
InitSignal  = Signal;
Indices     = freqIndices(InitSignal,Freq,Fs);
  
% Select Period Starting Seeds
if nargin < 4, PeriodResolution = 'random'; end
if strcmpi(PeriodResolution,'default') 
    PeriodResolution = 'random';
end

if strcmpi(PeriodResolution,'random')
    P           = period:-1:1;
    rng('shuffle');
    P           = datasample(P,min(5,floor(length(P/2))),'Replace',false);
    
elseif isnumeric(PeriodResolution)
    if PeriodResolution > 100, PeriodResolution  = 100; end
    PeriodResolution = ceil(PeriodResolution*period/100);
    P           = period:-1:1;
    P           = P(fix(1:PeriodResolution:end));
    if isempty(P), P = 1; end
    
end

F           =  [];
for PeriodShift = P
    % initialize the signal based on a random (or resolution-determined) seed
    Signal              = InitSignal(PeriodShift:end-PeriodShift+1);
    
    % remove components until artifact power is at least as low as in neighbouring frequencies  
    ArtifactPower       = calcpower(Signal,Fs,Indices);
    BlockSignal         = signal2period(Signal,period);
    
    while ArtifactPower > 1       
        BlockSignal         = removetemplate(BlockSignal);
        ReconstructedSignal = period2signal(BlockSignal);
        ArtifactPower       = calcpower(ReconstructedSignal,Fs,Indices);
        
    end

    % reshape,append 
    FilteredSignal = period2signal(BlockSignal);
    FilteredSignal = [NaN(1,PeriodShift-1),FilteredSignal,NaN(1,PeriodShift-1)];
    while length(FilteredSignal) < length(InitSignal)
        FilteredSignal = cat(2,FilteredSignal,NaN);
    end
    F              = cat(1,F,FilteredSignal);
    
end
% Average the parallel seeds, and interpolate any NaNs induced by seeding 
FilteredSignal = nanmean(F,1);
FilteredSignal = interp1(find(~isnan(FilteredSignal)),FilteredSignal(~isnan(FilteredSignal)),1:length(FilteredSignal),'linear','extrap');

% Upsample if necessary 
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

function ArtifactPower = calcpower(Signal,Fs,Indices)
    L               = length(Signal);    
    ffx             = fft(Signal);
    pow             = (movsum(2*abs(ffx),ceil(L./(Fs/2))));    
    ArtifactPower   = pow(Indices(2))./mean(pow(Indices([1,end])));
end

function Indices = freqIndices(Signal,Freq,Fs)
    
    L               = length(Signal);    
    ffx             = fft(Signal);
    pow             = (movsum(2*abs(ffx),ceil(L./(Fs/2))));
    artifact_idx    = round(Freq/Fs*L) + 1;
    step = 1;
    slope = -Inf;
    pre_val         = pow(artifact_idx);
    while slope < 2 * std(diff(pow))
        tmp     = median(pow(artifact_idx-step:artifact_idx+step));
        slope   = pre_val-tmp;
        pre_val = tmp;
        step    = step+1;
    end
    physio_idx1     = artifact_idx+(step*2);
    physio_idx2     = artifact_idx-(step*2);
    Indices         = [physio_idx1,artifact_idx,physio_idx2];
end