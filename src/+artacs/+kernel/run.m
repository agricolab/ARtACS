% function run(signal,NumberPeriods,freq,Fs,symflag,wfun,tau,dirflag,delay)
function filt_sig = run(signal,NumberPeriods,freq,Fs,symflag,wfun,tau,dirflag,delay)

     period          = Fs/freq;         
     
    % check whether kernel frequency is possible for the given sampling rate
    resample_flag = (period ~= int32(period));
    if resample_flag
        trueFs      = Fs;       
        trueSig    = signal;
        
        period      = ceil(period);
        Fs          = period*freq;
        %upsample signal to match period with kernel
        signal      = resample(trueSig,Fs,trueFs);        
    end

    if nargin > 5
        if nargin > 6
            if nargin > 7
                if nargin > 8
                    kernel = artacs.kernel.create(NumberPeriods,freq,Fs,symflag,wfun,tau,dirflag,delay); 
                else
                    kernel = artacs.kernel.create(NumberPeriods,freq,Fs,symflag,wfun,tau,dirflag);
                end
            else
                kernel = artacs.kernel.create(NumberPeriods,freq,Fs,symflag,wfun,tau);                
            end
        else
            kernel = artacs.kernel.create(NumberPeriods,freq,Fs,symflag,wfun);
        end
    else
        kernel = artacs.kernel.create(NumberPeriods,freq,Fs,symflag); 
    end
    
    
    filt_sig    = artacs.kernel.runpredefined(signal,kernel,Fs);
    if strcmpi(symflag,'twopass')
        filt_sig    = fliplr(artacs.kernel.runpredefined(fliplr(signal),kernel,Fs));       
    end
    if resample_flag
        filt_sig     = resample(filt_sig,trueFs,Fs);        
        filt_sig     = filt_sig(1:length(trueSig));
    end

    
end