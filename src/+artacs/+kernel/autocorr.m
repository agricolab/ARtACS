function Kernel = autocorr(sig,NumberPeriods,freq,Fs)    


period  = Fs/freq;
pincl   = floor(length(sig)./period);
sig     = sig(1:pincl*period);
k       = xcorr(mean(reshape(sig,period,[]),1),'coeff');

idx     = (length(k)+1)/2;
k       = k(idx-ceil(NumberPeriods/2):idx-1);
k       = -(k./sum(k));
z       = zeros(1,(length(k))*period);
h       = [];
for h_idx = 1 : length(k)
    h = [h,k(h_idx),zeros(1,period-1)];
end         
h  = [z,1,fliplr(h)];
h = (h+fliplr(h))./2;
L                   = 2*ceil(NumberPeriods)*(period); 
while length(h) < L
    h = [0,h,0];
end
    
clear kernel          
Kernel.h = h;
Kernel.Fs               = Fs;
Kernel.NumberPeriods    = NumberPeriods;
Kernel.Frequency        = freq;
Kernel.Weighting        = 'autocorr';
Kernel.tau              = 'autocorr';
%artacs.kernel.response(Kernel,2)

end