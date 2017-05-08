% function filt_sig = runpredefined(signal,kernel,Fs)
function filt_sig = runpredefined(signal,kernel,Fs)
    
    if nargin < 3, Fs = kernel.Fs; end    
    % Resample  to bring kernel and signal in alignment
    if (Fs ~= kernel.Fs), signal = resample(signal,Fs,kernel.Fs); end
    
    [signal,pick]       = addpad(signal,kernel);
    filt_sig            = (conv(signal(:)',kernel.h,'same'));    
    filt_sig            = rempad(filt_sig,pick);
    
    % Resample to recover original signal Fs 
    if (Fs ~= kernel.Fs), filt_sig = resample(filt_sig,kernel.Fs,Fs); end
    
end

function [sig,pick] = addpad(sig,kernel)
    period      = kernel.Fs/kernel.Frequency;
    sig         = sig(:)';    
    
    % leftpadding
    pincl       = floor(length(sig)./period);    
    tacs        = mean(reshape(sig(1:pincl*period),period,[]),2)';
    leftpad     = repmat(tacs,1,kernel.NumberPeriods*2);    
    
    % rightpadding
    pincl       = floor(length(sig)./period);    
    tmp         = fliplr(sig);
    tacs        = fliplr(mean(reshape(tmp(1:pincl*period),period,[]),2)');
    rightpad     = repmat(tacs,1,kernel.NumberPeriods*2);    
    sig         = cat(2,leftpad,sig,rightpad);    
    pick        = (length(leftpad)+1) : (length(sig)-length(rightpad));
end

function sig = rempad(sig,pick)
    sig     = sig(pick);
end