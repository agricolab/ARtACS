function dynamic(how_flag)

filt_types          = {'uniform','linear','exp','gauss','automatic','ave'};
sym_types           = {'causal','symmetric','piecewise','left','right'};
inc_types           = {'dec','inc'};
Delay               = [0,1,5];
NumberPeriods       = [0,1,2,4,9];
tacsFreq            = [7, 10, 22];
Fs                  = [1000,2048,256];
Tau                 = {1,4,100,'default'};

%% random tests

if strcmpi(how_flag,'random')   
    fprintf(1,'[')
    for rep = 1 : 100
        setup           = generate.generic();
        setup.tacsFreq  = tacsFreq(datasample(1:length(tacsFreq),1));
        setup.Fs        = Fs(datasample(1:length(Fs),1));
        Signal          = generate.recording(setup);

        np              = NumberPeriods(datasample(1:length(NumberPeriods),1));
        st              = sym_types{datasample(1:length(sym_types),1)};
        ft              = filt_types{datasample(1:length(filt_types),1)};
        it              = inc_types{datasample(1:length(inc_types),1)};
        dl              = Delay(datasample(1:length(Delay),1));
        lt              = ceil(length(Signal)./2);
        ta              = Tau{datasample(1:length(Tau),1)};

        f1              = artacs.kernel.run(Signal,np,setup.tacsFreq,setup.Fs,st,ft,ta,it,dl,lt);     
        f2              = artacs.template.stepwise(Signal,setup.tacsFreq,setup.Fs);     
        f3              = artacs.dft.causal(Signal,setup.tacsFreq,setup.Fs,np);     
        f4              = artacs.dft.complete(Signal,setup.tacsFreq,setup.Fs);     
        
        %plot(f)
        fprintf(1,'.')
    end
    fprintf(1,']\n')
    fprintf(1,'Filtered %2.0f randomly selected generic signal without runtime error\n',rep)
    fprintf(1,'Using random kernels, stepwise template, adaptive dft and inverse fft\n')
end
%% full test ~ 2 hours
if strcmpi(how_flag,'full')
    fprintf(1,'Test will run roughly 1-2 hours')
    L = length(filt_types)*length(sym_types)*length(inc_types)*length(Delay)*length(NumberPeriods)*length(tacsFreq)*length(Fs)*length(Tau);
    cnt  = 0;
    %(L * 0.05)/3600
    for ft_idx = 1 : length(filt_types)
        for st_idx = 1 : length(sym_types)
            for it_idx = 1 : length(inc_types)
                for dl_idx = 1: length(Delay)
                    for np_idx = 1 : length(NumberPeriods)
                        for tf_idx = 1 : length(tacsFreq)
                            for fs_idx = 1 : length(Fs)
                                for ta_idx = 1 : length(Tau)                           
                                    % generate a signal                                    
                                    setup           = generate.generic();
                                    setup.tacsFreq  = tacsFreq(tf_idx);
                                    setup.Fs        = Fs(fs_idx);
                                    Signal          = generate.recording(setup);


                                    % define characteristics signal
                                    np              = NumberPeriods(np_idx);
                                    st              = sym_types{st_idx};
                                    ft              = filt_types{ft_idx};
                                    it              = inc_types{it_idx};
                                    dl              = Delay(dl_idx);                                
                                    lt              = ceil(length(Signal)./2);
                                    ta              = Tau{ta_idx};

                                    % run

                                    f1               = artacs.kernel.run(Signal,np,setup.tacsFreq,setup.Fs,st,ft,ta,it,dl,lt);     
                                    f2               = artacs.template.stepwise(Signal,setup.tacsFreq,setup.Fs);     
                                    f3               = artacs.dft.causal(Signal,setup.tacsFreq,setup.Fs,np);     
                                    f4               = artacs.dft.complete(Signal,setup.tacsFreq,setup.Fs);       
                                    cnt = cnt+1;
                                    fprintf(1,'%2.0f of %2.0f\n',cnt,L)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    fprintf(1,'Ran without error')
end