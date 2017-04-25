% function filt_sig = run(signal,kernel)
function filt_sig = run(signal,kernel)

    [signal,pick]       = addpad(signal,kernel);
    filt_sig            = (conv(signal(:)',kernel,'same'));    
    filt_sig            = rempad(filt_sig,pick);
    
end

function [sig,pick] = addpad(sig,kernel)
    sig     = sig(:)';    
    L       = length(kernel)*4;    
    sig     = padarray(sig,[0,L],'circular');
    pick    = L+1:length(sig)-L;
end

function sig = rempad(sig,pick)
    sig     = sig(pick);
end