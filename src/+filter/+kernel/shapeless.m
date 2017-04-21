% function filt_sig = shapeless(sig,kernel)
function filt_sig = shapeless(sig,kernel)

   [sig,pick]          = filter.lib.addpad(sig,kernel);
   filt_sig            = (conv(sig,kernel,'same'));          
   filt_sig            = filter.lib.rempad(filt_sig,pick);
end