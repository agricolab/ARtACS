% function Kernel = create(NumberPeriods,freq,Fs,wfun,symflag,tau)    
% wfun can be 
% 'ave' : average
% 'linear' : linear
% 'exp' : exponential
% 'gauss' : gaussian
% 'cauchy' : cauchy 
% symflag can be
% causal: causal filter
% symmetric : symmetric filter


function Kernel = create(NumberPeriods,freq,Fs,wfun,symflag,tau)    
    
    if strcmpi(symflag,'causal')
        if nargin < 6
            Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun);
        else
            Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun,tau);
        end
    elseif strcmpi(symflag,'symmetric')
        if nargin < 6
            Kernel = artacs.kernel.symmetric(NumberPeriods,freq,Fs,wfun);
        else
            Kernel = artacs.kernel.symmetric(NumberPeriods,freq,Fs,wfun,tau);
        end
    end
    
end