% function filt_sig = complete(sig,freq,Fs)    
function filt_sig = complete(sig,freq,Fs)        
    
    N               = length(sig);
    fft_idx         = (((freq/(Fs/N))));
    fft_idx         = unique([floor(fft_idx),ceil(fft_idx)]);
    fft_idx         = [fft_idx+1,(N)-fft_idx+1];
    fxx             = fft(sig);
    fxx(fft_idx)    = 0;    
    filt_sig        = ifft(fxx);
        
end