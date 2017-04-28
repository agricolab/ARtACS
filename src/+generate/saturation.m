function t = saturation(t,setup)    
    if (setup.tacsSaturate*setup.tacsMagnitude) < (setup.tacsMagnitude-setup.tacsModulation(1)), warning('SIG:saturate','Saturation level will mask amplitude modulation'); end
    threshold       = setup.tacsSaturate*max(abs(t));
    t(t>threshold)	= threshold;t(t<-threshold) = -threshold;    
end
    