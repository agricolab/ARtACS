function erp = erp(setup)
    z               = generate.onset(setup);
    h               = gradient((flattopwin(setup.Fs/20)));
    h               = h./max(abs(h));
    erp             = setup.erpMagnitude*h';
    erp             = conv(z,erp,'same');
end
