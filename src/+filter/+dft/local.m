% function filt_sig = local(sig,freq,Fs,NumberPeriods)    
function filt_sig = local(sig,freq,Fs,NumberPeriods)    
              
    
    period          = Fs/freq;
    window          = period*NumberPeriods;        
    time            = (0:window-1)/Fs;
    kernel          = (exp(1i*2*pi*freq*time));        
    inverse_kernel  = pinv(kernel);   

    
    w               = reshape(repmat(1:NumberPeriods,period,1),1,[]);
    w               = fliplr(w./mean(w));
    inverse_kernel  = inverse_kernel.*w';
    
    N               = size(inverse_kernel,1);
    inverse_kernel  = cat(1,zeros(N,1),inverse_kernel);
        
    [sig,pick]      = filter.lib.addpad(sig,inverse_kernel);
    
    ampl            = conv(sig,inverse_kernel,'same');        
    filt_sig        = sig-(2.*real(ampl));
    
    filt_sig        = filter.lib.rempad(filt_sig,pick);
end
