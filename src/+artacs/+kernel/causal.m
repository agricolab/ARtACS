% function Kernel = create(NumberPeriods,freq,Fs,wfun,tau,incflag,delay)    
% wfun can be 
% 'ave' : average
% 'linear' : linear
% 'exp' : exponential
% 'gauss' : gaussian
% 'cauchy' : cauchy 

function Kernel = causal(NumberPeriods,freq,Fs,wfun,tau,incflag,delay)    
      
    
    % prepare variables    
    NumberPeriods   = ceil(NumberPeriods)+1;
    period          = Fs/freq;     
    
    % check whether kernel frequency is possible for the given sampling rate
    if period ~= int32(period)    
        error('KERN:FREQ','Stimulation Frequency not an integer divisor of Sampling Frequency!')
    end    
           
    % generate weighting function
    if nargin < 4
        warning('KERN:WFUN','No weighting function defined. Using uniform');
        wfun = 'uniform';
    end
    
    if strcmpi(wfun,'linear')
        tau                     = NaN;
        k                       = @(N)(N*(N+1))/2;        
        w                       = @(n,N)(N-n+1)./k(N);            
    elseif strcmpi(wfun,'exp')        
        if nargin < 5 || strcmpi(tau,'default'), tau = 4;  end
        f                       = @(n,N)exp(tau-(tau*n/N));        
        w                       = @(n,N)f(n,N)./sum(f(1:N,N));
    elseif strcmpi(wfun,'gauss')
        if nargin < 5 || strcmpi(tau,'default'), tau = 3;  end
        f                       = @(n,N)(sqrt(tau/(2*pi))*exp((-(tau^2)*((n./N).^2))./2));
        w                       = @(n,N)f(n,N)./sum(f(1:N,N));
    elseif strcmpi(wfun,'cauchy')        
        if nargin < 5 || strcmpi(tau,'default'), tau = 1;  end        
        f                       = @(n,N)(1/pi)*(tau./((tau^2)-((N-n)./N)));
        w                       = @(n,N)f(n,N)./sum(f(1:N,N));
    elseif strcmpi(wfun,'ave') || strcmpi(wfun,'uniform') 
        tau                     = NaN;
        w                       = @(n,N)repmat(1/N,1,max(n));
    else
       warning('KERN:WFUN','Weighting function unknown. Using average');
       tau                      = NaN;
       w                        = @(n,N)repmat(1/N,1,max(n));
    end    
    
    % construct kernel        
    weights                 = -w(1:NumberPeriods-1,NumberPeriods-1);
    if nargin < 6, incflag = 'dec'; end
    if strcmpi(incflag,'dec')
        
    elseif strcmpi(incflag,'inc')
        weights = fliplr(weights);
    end        
    
    if nargin < 7, delay = 0; end
    weights                 = [zeros(1,delay),weights];
    h                       = fliplr(weights);                         
    z                       = zeros(1,(length(h))*period);
    
    kernel                 = [];
    for h_idx = 1 : length(h)
        kernel = [kernel,h(h_idx),zeros(1,period-1)];
    end         
        
    kernel  = [z,1,fliplr(kernel)];

    Kernel.h                = kernel;
    Kernel.Fs               = Fs;
    Kernel.NumberPeriods    = NumberPeriods;
    Kernel.Frequency        = freq;
    Kernel.Weighting        = wfun;
    Kernel.tau              = tau;
end