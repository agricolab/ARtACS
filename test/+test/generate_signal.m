function [t,e] = generate_signal(setup)
    commonPhase     = deg2rad(randi(360));
    
    % event-related potential 
    erp             = create_erp(setup);
   
    % event-related oscillation        
    eo              = create_eo(setup);

    % modulation modelled as sinusoidal process
    sm              = generate_FQ(setup);

    % modulation modelled as Ornstein-Uhlenbeck process    
    sm              = generate_OU(setup);
    
    % create tacs       
    tacs            = create_TACS(setup);
    % perform modulation
    tacs            = sm.*tacs;
    
    % superposition    
    noise           = brown(setup);
    e               = cat(1,erp,eo);    
    x               = tacs+noise+sum(e);    
    
    if (setup.tacsSaturate*setup.tacsMagnitude) < (setup.tacsMagnitude-setup.tacsModulation(1)), warning('SIG:saturate','Saturation level will mask amplitude modulation'); end
    t               = saturate(x,setup);
end

function z = initialize(setup)
    z               = zeros(setup.Fs*setup.L,1)';
    z((end/2)+1)    = 1;
end

function t = saturate(t,setup)    
    if (setup.tacsSaturate*setup.tacsMagnitude) < (setup.tacsMagnitude-setup.tacsModulation(1)), warning('SIG:saturate','Saturation level will mask amplitude modulation'); end
    threshold       = setup.tacsSaturate*max(abs(t));
    t(t>threshold)	= threshold;t(t<-threshold) = -threshold;    
end
    

function brownNoise =  brown(setup)
    z           = initialize(setup);
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

function sm = generate_FQ(setup)
    sm              = sin(setup.tacsModulation(2).*2*pi*[(1/setup.Fs/setup.L):(1/setup.Fs/setup.L):1]+deg2rad(randi(360)));       
    sm              = setup.tacsMagnitude +  (setup.tacsModulation(1).*sm);
end

function sm = generate_OU(setup)
    DurationPeriods = (setup.L*setup.Fs)*(setup.tacsFreq./setup.Fs);
    %theta           = (setup.tacsFreq./setup.Fs).*setup.tacsModulation(2);
    theta           = setup.tacsModulation(2);
    if abs(theta) >= 1, error('SIG:theta','Abs(theta) higher or equal to 1. use values closer to zero.'); end
    
    % because the actual variance of the process is a function of (sigma² / (2 * theta), we need to
    % invert the desired variance to derive the desired standard deviance of the generative white noise process:
    sigma           = sqrt((2*theta)./setup.tacsModulation(1)^2);    
    E               = normrnd(0,sigma,1,DurationPeriods+1);
    X               = setup.tacsMagnitude+E(1);   
    for idx = 1 : length(E)-1
        X(idx+1) = X(idx)+theta*(setup.tacsMagnitude-X(idx))+E(idx+1);
    end                  
    sm              = interp1(0:DurationPeriods,X,[(setup.tacsFreq./setup.Fs):(setup.tacsFreq./setup.Fs):DurationPeriods]);
end
       
function tacs = create_TACS(setup)
    if strcmpi(setup.tacsPhase,'random')
        tacsPhase = deg2rad(randi(360)); 
    else
        tacsPhase = setup.tacsPhase;
    end
    tacs            = sin(setup.tacsFreq*2*pi*[1/setup.Fs:1/setup.Fs:setup.L]+tacsPhase);   
end

function erp = create_erp(setup)
    z               = initialize(setup);
    erp             = setup.erpMagnitude*(flattopwin(setup.Fs/10))';
    erp             = conv(z,erp,'same');
end

function eo = create_eo(setup)    
    z               = initialize(setup);
    em              = (conv(z, [zeros(1,setup.Fs/2),(hanning(setup.Fs/2))'],'same'));      
    if strcmpi(setup.eoPhase,'random')
        eoPhase = deg2rad(randi(360)); 
    else
        eoPhase = setup.eoPhase;
    end
    eo              = sin(setup.eoFreq*2*pi*[1/setup.Fs:1/setup.Fs:setup.L]+eoPhase);
    w               = (setup.eoModulation.*em);
    eo              = w.*eo;
end