% function Kernel =  create(NumberPeriods,freq,Fs,symflag,wfun,tau,dirflag,delay)
% wfun can be 
% 'ave' : average
% 'linear' : linear
% 'exp' : exponential
% 'gauss' : gaussian
% 'cauchy' : cauchy 
% dirflag can be
% causal: causal filter
% symmetric : symmetric filter


function Kernel = create(NumberPeriods,freq,Fs,symflag,wfun,tau,dirflag,delay)
    
if nargin < 5, wfun = 'ave'; end
if nargin < 6, tau = 'default'; end
if nargin < 7, dirflag = 'dec'; end
if nargin < 8, delay = 0; end

if strcmpi(symflag,'causal') ||  strcmpi(symflag,'left') || strcmpi(symflag,'twopass')
    Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun,tau,dirflag,delay);
elseif strcmpi(symflag,'right')   
    Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun,tau,dirflag,delay);
    Kernel.h = fliplr(Kernel.h);
elseif strcmpi(symflag,'symmetric')
    Kernel = artacs.kernel.symmetric(NumberPeriods,freq,Fs,wfun,tau,dirflag,delay);
end

end

