function tacs = tacs(setup)
    if strcmpi(setup.tacsPhase,'random')
        tacsPhase = deg2rad(randi(360)); 
    else
        tacsPhase = setup.tacsPhase;
    end
    tacs            = sin(setup.tacsFreq*2*pi*[1/setup.Fs:1/setup.Fs:setup.L]+tacsPhase);   
end

