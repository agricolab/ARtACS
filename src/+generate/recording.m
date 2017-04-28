function [t,e] = recording(setup)    
    % event-related potential 
    erp             = generate.erp(setup);
   
    % event-related oscillation        
    eo              = generate.eventoscillation(setup);

    % modulation modelled as sinusoidal process
    %sm              = generate.sinus_modulation(setup);

    % modulation modelled as Ornstein-Uhlenbeck process    
    sm              = generate.oup_modulation(setup);
    
    % create tacs       
    tacs            = generate.tacs(setup);
    
    % perform modulation
    tacs            = sm.*tacs;
    
    % superposition    
    noise           = generate.brown(setup);
    e               = cat(1,erp,eo);    
    x               = tacs+noise+sum(e);    
    
    if (setup.tacsSaturate*setup.tacsMagnitude) < (setup.tacsMagnitude-setup.tacsModulation(1)), warning('SIG:saturate','Saturation level will mask amplitude modulation'); end
    t               = generate.saturation(x,setup);
end



