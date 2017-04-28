function [signal,echt,truetacs] = recording(setup)    
    
    if nargin < 1
        setup = generate.generic();
    end
    if ~isstruct(setup)
        if strcmpi(setup,'generic')
        	setup = generate.generic();
        elseif strcmpi(setup,'random')
            setup = generate.random();
        else
            error('SIG:setup','Setup is not recognized');
        end
    end


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
    truetacs        = setup.tacsMagnitude*tacs;
    
    % perform distortion
    tacs            = tacs+generate.distortion(setup);

    % perform modulation
    tacs            = sm.*tacs;
    
    % superposition    
    noise           = generate.brown(setup);
    echt            = cat(1,erp,eo);    
    x               = tacs+noise+sum(echt);    
    
    % perform saturation
    if (setup.tacsSaturate*setup.tacsMagnitude) < (setup.tacsMagnitude-setup.tacsModulation(1)), warning('SIG:saturate','Saturation level will mask amplitude modulation'); end
    signal          = generate.saturation(x,setup);
    
 
end



