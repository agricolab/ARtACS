% creates a modulation vector based on the logic of the Ornstein–Uhlenbeck process
% function sm = oup_modulation(setup)
function sm = oup_modulation(setup)
    if setup.tacsModulation(1) == 0
        sm = ones(1,setup.L*setup.Fs)*setup.tacsMagnitude;
        return; 
    end

    DurationPeriods = (setup.L*setup.Fs)*(setup.tacsFreq./setup.Fs);    
    theta           = setup.tacsModulation(2);
    if abs(theta) > 1, warning('SIG:theta','Abs(theta) higher 1, bounding at 1.'); theta = 1; end
    
    % because the actual variance of the process is calculated as var_x = (sigma² / (1 - theta²), we need to
    % invert the desired variance to derive the desired standard deviance of the generative white noise process:    
    sigma           = sqrt((setup.tacsModulation(1).^2)*(1-(theta.^2)));
           
    E               = normrnd(0,sigma,1,DurationPeriods+1);
    X               = setup.tacsMagnitude+E(1);   
    for idx = 1 : length(E)-1
        X(idx+1) = setup.tacsMagnitude+(theta*(setup.tacsMagnitude-X(idx)))+E(idx+1);
    end                  
    % sprintf('The OU process has %.2f SD',std(X))
    sm              = interp1(0:DurationPeriods,X,[(setup.tacsFreq./setup.Fs):(setup.tacsFreq./setup.Fs):DurationPeriods]);
end