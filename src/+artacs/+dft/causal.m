% function filt_sig = causal(sig,freq,Fs,NumberPeriods)    
function filt_sig = causal(sig,freq,Fs,NumberPeriods)        
    
    for freq_idx = 1 : length(freq)
        if freq_idx == 1
            filt_sig = runDFT(sig,freq(1),Fs,NumberPeriods);    
        else
            filt_sig = runDFT(filt_sig,freq(freq_idx),Fs,NumberPeriods);    
        end
    end
    
end

function [sig,pick] = addpad(sig,h)
    sig     = sig(:)';    
    L       = length(h)*4;    
    sig     = padarray(sig,[0,L],'circular');
    pick    = L+1:length(sig)-L;
end

function sig = rempad(sig,pick)
    sig     = sig(pick);
end

function filt_sig = runDFT(sig,freq,Fs,NumberPeriods)    
    period          = ceil(Fs/freq);
    window          = period*NumberPeriods;        
    time            = (0:window-1)/Fs;
    kernel          = (exp(1i*2*pi*freq*time));        
    inverse_kernel  = pinv(kernel);   
    
    w               = reshape(repmat(1:NumberPeriods,period,1),1,[]);
    w               = fliplr(w./mean(w));
    inverse_kernel  = inverse_kernel.*w';
    
    N               = size(inverse_kernel,1);
    inverse_kernel  = cat(1,zeros(N,1),inverse_kernel);
        
    [sig,pick]      = addpad(sig,inverse_kernel);
    
    ampl            = conv(sig,inverse_kernel,'same');        
    filt_sig        = sig-(2.*real(ampl));
    
    filt_sig        = rempad(filt_sig,pick);
end
