% function kernel = create(NumberPeriods,freq,Fs,KernelType)    
function kernel = create(NumberPeriods,freq,Fs,KernelType)    
    

    if nargin < 4, KernelType = 'causal'; end
    NumberPeriods = ceil(NumberPeriods)+1;
  
    
    period = Fs/freq; 
    if strcmpi(KernelType,'symmetric')
        if ~mod(NumberPeriods,2)
            warning('KERN:SYM','Number of Periods not odd. Will use next odd integer period numbers to enforce symmetry!')     
            NumberPeriods = NumberPeriods + 1; 
        end
        
        h                          = -ones(1,NumberPeriods);    
        h(ceil(NumberPeriods/2))   = NumberPeriods - 1;    
        h                          = h./max(abs(h));                    
        kernel                     = [];
        for h_idx = 1 : length(h)-1
            kernel = [kernel,h(h_idx),zeros(1,period-1)];
        end      
        
        kernel = [kernel,h(end)];
    
    elseif strcmpi(KernelType,'causal')

        % h                          = -ones(1,NumberPeriods);    
        % h(end)                     = NumberPeriods - 1;   
        h                           = -(1:NumberPeriods);
        h(end)                      = -sum(h(1:end-1));         
        h                          = h./max(abs(h));                    
        kernel                     = [];
        
        for h_idx = 1 : length(h)-1
            kernel = [kernel,h(h_idx),zeros(1,period-1)];
        end    
        
        kernel  = [kernel,h(end)];
        kernel  = [zeros(size(kernel)),fliplr(kernel)];
        
    else
        error('KERN:TYPE','No correct kernel type specified');
    end
   
    
end