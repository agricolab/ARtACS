function [x,e,z] = makeSignal(setup)
    % initialize eventa
    z               = zeros(setup.Fs*setup.L,1)';
    z((end/2)+1)    = 1;

    % event-related potential 
    erp             = setup.erpMagnitude*(flattopwin(setup.Fs/10))';
    erp             = conv(z,erp,'same');
   
    % event-related modulation    
    em              = (conv(z, [zeros(1,setup.Fs/2),(hanning(setup.Fs/2))'],'same'));  
    eo              = sin(setup.eoFreq*2*pi*[1/setup.Fs:1/setup.Fs:setup.L]+setup.eoPhase);
    w               = (setup.eoModulation.*em);
    eo              = w.*eo;
    
    % create tacs       
    tacs            = sin(setup.tacsFreq*2*pi*[1/setup.Fs:1/setup.Fs:setup.L]+setup.tacsPhase);             
    sm              = sin(2*pi*[(1/setup.Fs/setup.L):(1/setup.Fs/setup.L):1]+deg2rad(randi(360)));       
    w               = setup.tacsMagnitude +  (setup.tacsModulation.*sm);
    tacs            = w.*tacs;
    
    % superposition    
    noize           = setup.NoiseLevel*utils.noise.brown(length(z));    
    e               = erp+eo;    
    x               = tacs+noize+e;
    
end