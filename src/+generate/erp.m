function erp = erp(setup)
    z               = generate.onset(setup);
    erp             = setup.erpMagnitude*(flattopwin(setup.Fs/10))';
    erp             = conv(z,erp,'same');
end
