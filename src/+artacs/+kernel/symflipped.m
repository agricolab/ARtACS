function Kernel = symflipped(NumberPeriods,freq,Fs,wfun,tau)    
                 
    L                   = 2*ceil(NumberPeriods)*(Fs/freq);    
    NumberPeriods   	= (NumberPeriods./2);
    
    if nargin > 3
        if nargin > 4
            Kernel = artacs.kernel.flipped(NumberPeriods,freq,Fs,wfun,tau);
        else
            Kernel = artacs.kernel.flipped(NumberPeriods,freq,Fs,wfun);
        end
    else
        Kernel = artacs.kernel.flipped(NumberPeriods,freq,Fs);
        
    end
    kernel = Kernel.h;
    kernel = (kernel+fliplr(kernel))./2;
    
    while length(kernel) < L
        kernel = [0,kernel,0];
    end
    
    Kernel.h     = kernel;
end
