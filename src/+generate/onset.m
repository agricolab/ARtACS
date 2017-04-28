function z = onset(setup)
    z               = zeros(setup.Fs*setup.L,1)';
    z((end/2)+1)    = 1;
end