%function Kernel = create(NumberPeriods,freq,Fs,symflag,wfun,tau,dirflag,Delay)%
function Kernel = create(NumberPeriods,freq,Fs,symflag,wfun,tau,dirflag,Delay)
    
if nargin < 5, wfun = 'ave'; end
if nargin < 6, tau = 'default'; end
if nargin < 7, dirflag = 'dec'; end
if nargin < 8, Delay = 0; end


if strcmpi(symflag,'causal') ||  strcmpi(symflag,'left') || strcmpi(symflag,'twopass')
    Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun,tau,dirflag,Delay);
    
elseif strcmpi(symflag,'right')   
    Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun,tau,dirflag,Delay);    
    Kernel.h = fliplr(Kernel.h);
    
elseif strcmpi(symflag,'symmetric')   
    Kernel = artacs.kernel.symmetric(NumberPeriods,freq,Fs,wfun,tau,dirflag,Delay);
    
end

end

