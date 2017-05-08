function d = distortion(setup)
    period  = ceil(setup.Fs/setup.tacsFreq);
    L       = ceil(period./4);
    d       = normrnd(0,1,1,period,1)*setup.tacsDistort;
    d       = conv(d,ones(L,1)./L,'same');
    d       = (repmat(d,1,ceil(setup.L*setup.tacsFreq)));
    d       = d(1:(setup.L*setup.Fs));
    
end