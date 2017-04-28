function sm = sinus_modulation(setup)
    sm              = sin(setup.tacsModulation(2).*2*pi*[(1/setup.Fs/setup.L):(1/setup.Fs/setup.L):1]+deg2rad(randi(360)));       
    sm              = setup.tacsMagnitude +  (setup.tacsModulation(1).*sm);
end
