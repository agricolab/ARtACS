% function run(signal,freq,NumberPeriods,Fs,wfun,symflag,tau)   
function filt_sig = run(signal,freq,NumberPeriods,Fs,wfun,symflag,tau)   

    if nargin < 7
        kernel      = artacs.kernel.create(NumberPeriods,freq,Fs,wfun,symflag);
    else
        kernel      = artacs.kernel.create(NumberPeriods,freq,Fs,wfun,symflag,tau);
    end
    filt_sig    = artacs.kernel.runpredefined(signal,kernel,Fs);

end