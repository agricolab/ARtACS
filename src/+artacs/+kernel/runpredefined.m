% function filt_sig = runpredefined(signal,kernel,Fs)
function filt_sig = runpredefined(signal,kernel,Fs)

    if nargin < 3, Fs = kernel.Fs; end    
    % Resample  to bring kernel and signal in alignment
    if (Fs ~= kernel.Fs), signal = resample(signal,Fs,kernel.Fs); end
    
    [signal,pick]       = addpad(signal,kernel.h);
    filt_sig            = (conv(signal(:)',kernel.h,'same'));    
    filt_sig            = rempad(filt_sig,pick);
    
    % Resample to recover original signal Fs 
    if (Fs ~= kernel.Fs), filt_sig = resample(filt_sig,kernel.Fs,Fs); end
    
end

function [sig,pick] = addpad(sig,h)
    sig     = sig(:)';    
    L       = length(h)*4;    
    sig     = padarray(sig,[0,L],'replicate');
    pick    = L+1:length(sig)-L;
end

function sig = rempad(sig,pick)
    sig     = sig(pick);
end