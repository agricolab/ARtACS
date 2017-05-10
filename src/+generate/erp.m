function erp = erp(setup)
    z               = generate.onset(setup);
    erpduration     = 20;
    h               = gradient((flattopwin(fix(setup.Fs/erpduration))));
    h               = h./max(abs(h));
    erp             = setup.erpMagnitude*h';
    erp             = conv(z,erp,'same');
end
