function Kernel = symmetric(NumberPeriods,freq,Fs,wfun,tau,dirflag,Delay)
                 
    if nargin < 4, wfun = 'ave'; end
    if nargin < 5, tau = 'default'; end
    if nargin < 6, dirflag = 'dec'; end
    if nargin < 7, Delay = 0; end


    L                   = 2*ceil(NumberPeriods)*(Fs/freq);    
    NumberPeriods   	= (NumberPeriods./2);
    
    Kernel      = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun,tau,dirflag,Delay);    
    h           = (Kernel.h+fliplr(Kernel.h))./2;
    
    while length(h) < L
        h = [0,h,0];
    end
    
    Kernel.h     = h;
end
