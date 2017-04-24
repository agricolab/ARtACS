function kernel = symmetric(NumberPeriods,freq,Fs,wfun,tau)    
                 
    L                   = 2*ceil(NumberPeriods)*(Fs/freq);    
    NumberPeriods   	= (NumberPeriods./2);
    
    if nargin > 3
        if nargin > 4
            kernel = filter.kernel.causal(NumberPeriods,freq,Fs,wfun,tau);
        else
            kernel = filter.kernel.causal(NumberPeriods,freq,Fs,wfun);
        end
    else
        kernel = filter.kernel.causal(NumberPeriods,freq,Fs);
    end
    kernel = (kernel+fliplr(kernel))./2;
    
    while length(kernel) < L,
        kernel = [0,kernel,0];
    end
end
