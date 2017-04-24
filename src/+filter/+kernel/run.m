% function filt_sig = run(signal,kernel)
function filt_sig = run(signal,kernel)

   [signal,pick]       = filter.lib.addpad(signal,kernel);
   filt_sig            = (conv(signal,kernel,'same'));          
   filt_sig            = filter.lib.rempad(filt_sig,pick);
end