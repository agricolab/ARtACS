% function Kernel = automatic(Signal,NumberPeriods,freq,Fs)    
function Kernel = automatic(Signal,NumberPeriods,Freq,Fs,symflag)    

if nargin < 5, symflag = 'symmetric'; end
%% up/downsample if necessary to allow integer periods
period  = Fs/Freq;
resample_flag = (period ~= int32(period));
if resample_flag
    trueFs      = Fs;       
    trueSig     = Signal;

    period      = ceil(period);
    Fs          = period*Freq;
    %upsample signal to match period with kernel
    Signal         = resample(trueSig,Fs,trueFs);        
end
%% cut into period length epochs and estimate autocorrelation
pincl       = floor(length(Signal)./period);
Signal      = Signal(1:pincl*period);

xc  = [];
for phase_idx = 1 : period-1
    xc = cat(1,xc,xcorr(Signal(phase_idx:period:end),'coeff'));
end
k       = (mean(xc.^2));

%% create weights based on estimated autocorrelation
idx     = (length(k)+1)/2;
k       = k(idx-ceil(NumberPeriods/2):idx-1);
k       = -(k./sum(k));
z       = zeros(1,(length(k))*period);
h       = [];
for h_idx = 1 : length(k)
    h = [h,k(h_idx),zeros(1,period-1)];
end         
h  = [z,1,fliplr(h)];
if strcmpi(symflag,'symmetric') 
    h = (h+fliplr(h))./2;
  
elseif strcmpi(symflag,'left')
    h = fliplr(h);
    
elseif strcmpi(symflag,'piecewise') || strcmpi(symflag,'causal') || strcmpi(symflag,'right')
    % do nothing
else
    error('KERN:AUTO','Symflag not adequately specified')
end

L                   = 2*ceil(NumberPeriods)*(period); 
while length(h) < L
    h = [0,h,0];
end
%% create Kernel

clear kernel          
Kernel.h                = h;
Kernel.Fs               = Fs;
Kernel.NumberPeriods    = NumberPeriods;
Kernel.Frequency        = Freq;
Kernel.Weighting        = 'auto';
Kernel.tau              = 'auto';
%artacs.kernel.response(Kernel,2)

end