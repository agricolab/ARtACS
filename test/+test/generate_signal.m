function [t,e,z] = generate_signal(setup)
    commonPhase = deg2rad(randi(360));
    % initialize event
    z               = zeros(setup.Fs*setup.L,1)';
    z((end/2)+1)    = 1;

    % event-related potential 
    erp             = setup.erpMagnitude*(flattopwin(setup.Fs/10))';
    erp             = conv(z,erp,'same');
   
    % event-related modulation    
    em              = (conv(z, [zeros(1,setup.Fs/2),(hanning(setup.Fs/2))'],'same'));      
    
    if strcmpi(setup.eoPhase,'random')
        eoPhase = deg2rad(randi(360)); 
    elseif strcmpi(setup.eoPhase,'equal')        
        if ~strcmpi(setup.tacsPhase,'equal'), warning('SigPhase:eo','eoPhase equal, but tacsPhase not!') ; end
            eoPhase = commonPhase;
    else
        eoPhase = setup.eoPhase;
    end
    eo              = sin(setup.eoFreq*2*pi*[1/setup.Fs:1/setup.Fs:setup.L]+eoPhase);
    w               = (setup.eoModulation.*em);
    eo              = w.*eo;
    
    % create tacs       
    if strcmpi(setup.tacsPhase,'random')
        tacsPhase = deg2rad(randi(360)); 
    elseif strcmpi(setup.tacsPhase,'equal') 
        if ~strcmpi(setup.eoPhase,'equal'), warning('SigPhase:tacs','tacsPhase  Phase equal, but eoPhase not!'); end
        tacsPhase = commonPhase;
    else
        tacsPhase = setup.tacsPhase;
    end
    tacs            = sin(setup.tacsFreq*2*pi*[1/setup.Fs:1/setup.Fs:setup.L]+tacsPhase);             
    sm              = sin(setup.tacsModulation(2).*2*pi*[(1/setup.Fs/setup.L):(1/setup.Fs/setup.L):1]+deg2rad(randi(360)));       
    w               = setup.tacsMagnitude +  (setup.tacsModulation(1).*sm);
    
    tacs            = w.*tacs;
    
    % superposition    
    noize           = setup.NoiseLevel*brown(length(z));    
    e               = cat(1,erp,eo);    
    x               = tacs+noize+sum(e);    
    t               = saturate(x,setup.tacsSaturate);
end


function t = saturate(t,ThresholdinPercent)
    threshold   = ThresholdinPercent*max(abs(t));
    t(t>threshold) = threshold;t(t<-threshold) = -threshold;    
end
    

function brownNoise =  brown(L)
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
end
