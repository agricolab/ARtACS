% function kernel = create(NumberPeriods,freq,Fs,wfun)    
% wfun can be 
% 'ave' : average
% 'exp' : exponential
% 'linear' : linear

function kernel = create(NumberPeriods,freq,Fs,wfun)    
   
    % check arguments
    
    allowedfreqs = Fs./[1:Fs];
    allowedfreqs(allowedfreqs~=int32(allowedfreqs)) = [];
    if ~any(ismember(freq,allowedfreqs))
        warning('KERN:FREQ','Stimulation Frequency not an integer divisor of Sampling Frequency. Taking closest match!')
        [~,idx] = sort(abs(freq-allowedfreqs));
        freq    = allowedfreqs(idx(1));
    end       
    
    % prepare variables
    NumberPeriods   = ceil(NumberPeriods)+1;
    period          = Fs/freq; 
   
    % Create Kernel
    if nargin < 4
        warning('KERN:WFUN','No proper weighting function defined. Using a constant function ');
        wfun = 'linear';
    end
    if strcmpi(wfun,'linear')
         w                     = @(n,N)(2*(N-n+1))./(N*(N+1));
    elseif strcmpi(wfun,'exp')
        %w                      = @(n,N)exp(fliplr(n))./sum(exp(n));
        tau                     = 5;
        w                       = @(n,N)exp(fliplr(tau*n./N))./sum(exp(tau*n./N));
    elseif strcmpi(wfun,'ave')
        w                      = @(n,N)repmat(1/N,1,max(n));
    else
       warning('KERN:WFUN','No proper weighting function defined. Using a constant function ');
       w                      = @(n,N)repmat(1/N,1,max(n));
    end
    
    h                      = fliplr([1,-w(1:NumberPeriods-1,NumberPeriods-1)]);      
    h                      = h./max(abs(h));                    
    kernel                 = [];

    for h_idx = 1 : length(h)-1
        kernel = [kernel,h(h_idx),zeros(1,period-1)];
    end    
    z       = zeros(size(kernel));
    kernel  = [kernel,h(end)];   
    kernel  = [z,fliplr(kernel)];


    
    
end