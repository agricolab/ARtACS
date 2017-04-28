function d = distortion(setup)
    period  = setup.Fs/setup.tacsFreq;
    d       = rand(1,period,1)*setup.tacsDistort;
    d       = (repmat(d,1,setup.L*setup.tacsFreq));
end