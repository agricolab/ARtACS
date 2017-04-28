function brownNoise =  brown(setup)
    z           = generate.onset(setup);
    L           = length(z);    
    trueL       = L;
    L           = L+mod(L,2);
    rng('shuffle');
    whiteFxx    = fft(normrnd(0,1,1,L));
    % generating brown noise from the white noise
    Step        = 1./L;      
    tmp         = exp(-10.*[Step:Step:0.5]);
    tmp         = [tmp,fliplr(tmp)];
    tmp         = (tmp./mean(tmp));
    brownFxx    = whiteFxx.*tmp;
    brownNoise  = real(ifft(brownFxx));
    brownNoise  = brownNoise(1:trueL);
    brownNoise  = brownNoise*setup.NoiseLevel;
end