function eo = eventoscillation(setup)    
    z               = generate.onset(setup);
    duration        = 4*(setup.Fs/setup.tacsFreq);
    em              = (conv(z,hanning(duration)','same'));      
    if strcmpi(setup.eoPhase,'random')
        eoPhase = deg2rad(randi(360)); 
    else
        eoPhase = setup.eoPhase;
    end
    eo              = sin(setup.eoFreq*2*pi*[1/setup.Fs:1/setup.Fs:setup.L]+eoPhase);
    w               = (setup.eoModulation.*em);
    eo              = w.*eo;
end

