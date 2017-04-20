% function kernel = create(NumberPeriods,freq,Fs)    
function kernel = create(NumberPeriods,freq,Fs)    
   
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
   % w                      = @(n,N)(2*(N-n+1))./(N*(N+1));
   % h                      = fliplr([1,-w(1:NumberPeriods-1,NumberPeriods-1)]);
   % lower implementation is numerically more stable.
    h                      = -(1:NumberPeriods);
    h(end)                 = -sum(h(1:end-1));         
    h                      = h./max(abs(h));                    
    kernel                 = [];

    for h_idx = 1 : length(h)-1
        kernel = [kernel,h(h_idx),zeros(1,period-1)];
    end    
    z       = zeros(size(kernel));
    kernel  = [kernel,h(end)];   
    kernel  = [z,fliplr(kernel)];


    
    
end