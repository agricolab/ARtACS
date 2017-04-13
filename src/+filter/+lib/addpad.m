function [sig,pick] = addpad(sig,kernel)
    sig     = sig(:)';    
    L       = length(kernel);    
    sig     = padarray(sig,[0,L],'circular');
    pick    = L+1:length(sig)-L;