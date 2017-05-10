%function filt_sig = run(Signal,NumberPeriods,Freq,Fs,symflag,wfun,tau,dirflag,Delay,Latency)
function filt_sig = run(Signal,NumberPeriods,Freq,Fs,symflag,wfun,tau,dirflag,Delay,Latency)

    if NumberPeriods == 0; filt_sig = Signal; return; end
    if nargin < 5, symflag = 'symmetric'; end
    if nargin < 6, wfun = 'automatic'; end
    if nargin < 7, tau = 'default'; end
    if nargin < 8, dirflag = 'default'; end
    if nargin < 9, Delay = 0; end  
    if nargin < 10, Latency = ceil(length(Signal)./2); end  
    
 
    % check whether kernel Frequency is possible for the given sampling rate
    period          = Fs/Freq;         
    resample_flag = (period ~= int32(period));
    if resample_flag
        trueFs      = Fs;       
        trueSig     = Signal;
        period      = ceil(period);
        Fs          = period*Freq;
        %upsample signal to match period with kernel
        Signal      = resample(trueSig,Fs,trueFs);        
    end
    
    % distribute flow according to symflag
        
    if strcmpi(symflag,'twopass')
        kernel      = artacs.kernel.create(NumberPeriods,Freq,Fs,'causal',wfun,tau,dirflag,Delay);        
        filt_sig    = artacs.kernel.runpredefined(Signal,kernel,Fs);       
        filt_sig    = fliplr(artacs.kernel.runpredefined(fliplr(filt_sig),kernel,Fs));       
        
    %%%%%%%%%%
    elseif strcmpi(symflag,'piecewise')
        
        if strcmpi(wfun,'automatic')
            kernel  = artacs.kernel.automatic(Signal,NumberPeriods,Freq,Fs,'piecewise');
            f1      = artacs.kernel.runpredefined(Signal,kernel,Fs);
            kernel.h = fliplr(kernel.h);
            f2      = artacs.kernel.runpredefined(Signal,kernel,Fs);
        else        
            f1          = artacs.kernel.run(Signal,NumberPeriods,Freq,Fs,'left',wfun,tau,dirflag,Delay);                                     
            f2          = artacs.kernel.run(Signal,NumberPeriods,Freq,Fs,'right',wfun,tau,dirflag,Delay);   
        end
        limits      = floor(period/4);        
        woi         = [1:limits];
        toi         = Latency-floor(mean(woi))+woi;
        w           = woi./mean(woi);
        a           = fliplr(w).*f1(toi);
        b           = w.*f2(toi);
        filt_sig    = [f1(1:toi(1)-1),(a+b)./2,f2(toi(end)+1:end)];
        
    %%%%%%%%%%
    elseif strcmpi(symflag,'symmetric')
        
        if strcmpi(wfun,'automatic')
            kernel      = artacs.kernel.automatic(Signal,NumberPeriods,Freq,Fs,'symmetric');            
        else
            kernel      = artacs.kernel.create(NumberPeriods,Freq,Fs,'symmetric',wfun,tau,dirflag,Delay);
        end
        filt_sig    = artacs.kernel.runpredefined(Signal,kernel,Fs);     
        
    %%%%%%%%%%
    elseif strcmpi(symflag,'causal') ||  strcmpi(symflag,'left')
        
        if strcmpi(wfun,'automatic')            
            kernel      = artacs.kernel.automatic(Signal,NumberPeriods,Freq,Fs,'causal');
        else
            kernel = artacs.kernel.causal(NumberPeriods,Freq,Fs,wfun,tau,dirflag,Delay);
        end
        filt_sig    = artacs.kernel.runpredefined(Signal,kernel,Fs);       

    %%%%%%%%%%
    elseif strcmpi(symflag,'right')   
        
        if strcmpi(wfun,'automatic')
            kernel      = artacs.kernel.automatic(Signal,NumberPeriods,Freq,Fs,'right');
        else
            kernel      = artacs.kernel.causal(NumberPeriods,Freq,Fs,wfun,tau,dirflag,Delay);
        end
        kernel.h    = fliplr(kernel.h);
        filt_sig    = artacs.kernel.runpredefined(Signal,kernel,Fs);              
    
    %%%%%%%%%%
    else
        kernel      = artacs.kernel.create(NumberPeriods,Freq,Fs,symflag,wfun,tau,dirflag,Delay);
        filt_sig    = artacs.kernel.runpredefined(Signal,kernel,Fs);       
        
    end
    
    % resample if signal had to be resampled
    if resample_flag
        filt_sig     = resample(filt_sig,trueFs,Fs);        
        filt_sig     = filt_sig(1:length(trueSig));
    end

    
end