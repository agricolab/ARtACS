% function run(signal,NumberPeriods,freq,Fs,wfun,symflag,tau)   
function filt_sig = run(signal,NumberPeriods,freq,Fs,wfun,symflag,tau)   

     period          = Fs/freq;         
     
    % check whether kernel frequency is possible for the given sampling rate
    resample_flag = (period ~= int32(period));
    if resample_flag
        trueFs      = Fs;       
        trueSig     = signal;
        
        period      = ceil(period);
        Fs          = period*freq;
        %upsample signal to match period with kernel
        signal      = resample(trueSig,Fs,trueFs);        
    end


    if nargin < 7
        kernel      = artacs.kernel.create(NumberPeriods,freq,Fs,wfun,symflag);
    else
        kernel      = artacs.kernel.create(NumberPeriods,freq,Fs,wfun,symflag,tau);
    end
    filt_sig    = artacs.kernel.runpredefined(signal,kernel,Fs);

    if resample_flag
        filt_sig     = resample(filt_sig,trueFs,Fs);        
    end

    
end