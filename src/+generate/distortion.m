function d = distortion(setup)
    period  = setup.Fs/setup.tacsFreq;
    L       = fix(period)./4;
    d       = normrnd(0,1,1,period,1)*setup.tacsDistort;
    d       = conv(d,ones(L,1)./L,'same');
    d       = (repmat(d,1,setup.L*setup.tacsFreq));
end