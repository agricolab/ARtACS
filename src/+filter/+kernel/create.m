% function kernel = create(NumberPeriods,freq,Fs,wfun)    
% wfun can be 
% 'ave' : average
% 'linear' : linear
% 'exp' : exponential

function kernel = create(NumberPeriods,freq,Fs,wfun)    
      
    % prepare variables
    NumberPeriods   = ceil(NumberPeriods)+1;
    period          = Fs/freq;     
    
    % check whether kernel frequency is possible for the given sampling rate
    if period ~= int32(period)    
        error('KERN:FREQ','Stimulation Frequency not an integer divisor of Sampling Frequency!')
%         allowedfreqs    = Fs./[1:Fs];
%         allowedfreqs(allowedfreqs~=int32(allowedfreqs)) = [];    
%         [~,idx]         = sort(abs(freq-allowedfreqs));
%         nu_freq         = allowedfreqs(idx(1));    
    end    
       
    
    % generate weighting function
    if nargin < 4
        warning('KERN:WFUN','No weighting function defined. Using average');
        wfun = 'ave';
    end
    
    if strcmpi(wfun,'linear')
         w                     = @(n,N)(2*(N-n+1))./(N*(N+1));
    elseif strcmpi(wfun,'exp')        
        tau                     = 5;                    
        k                       = @(N)(1-exp(tau))./(1-exp(tau/N));
        w                       = @(n,N)exp((tau./N)*(N-n))./k(N);
    elseif strcmpi(wfun,'ave')
        w                       = @(n,N)repmat(1/N,1,max(n));
    else
       warning('KERN:WFUN','Weighting function unknown. Using average');
       w                        = @(n,N)repmat(1/N,1,max(n));
    end
    
    
    % construct kernel        
    h                      = fliplr(-w(1:NumberPeriods-1,NumberPeriods-1));                         
    z                      = zeros(1,(length(h))*period);
    
    kernel                 = [];
    for h_idx = 1 : length(h)
        kernel = [kernel,h(h_idx),zeros(1,period-1)];
    end         
        
    kernel  = [z,1,fliplr(kernel)];

end