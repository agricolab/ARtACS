function [filtered,pxx] = run(t,e,setup,plotflag)


%     filtered = cat(1,...
%         t,...
%         filter.dft.local(t,setup.tacsFreq,setup.Fs,setup.NumberPeriods),...
%         filter.dft.complete(t,setup.tacsFreq,setup.Fs),...    
%         filter.kernel.shapeless(t,filter.kernel.create(setup.NumberPeriods,setup.tacsFreq,setup.Fs))...
%         );

    filtered = cat(1,...
        t,...
        filter.kernel.shapeless(t,filter.kernel.create(setup.NumberPeriods,setup.tacsFreq,setup.Fs,'linear')),...
        filter.kernel.shapeless(t,filter.kernel.create(setup.NumberPeriods,setup.tacsFreq,setup.Fs,'exp')),...    
        filter.kernel.shapeless(t,filter.kernel.create(setup.NumberPeriods,setup.tacsFreq,setup.Fs,'ave'))...
        );

    
    do_pwelch = @(xvar)10*log10(pwelch(xvar,setup.Fs,setup.Fs/2,setup.Foi,setup.Fs));
    pxx = cat(1,...
        do_pwelch(filtered(1,:)),...
        do_pwelch(filtered(2,:)),...
        do_pwelch(filtered(3,:)),...    
        do_pwelch(filtered(4,:))...
        );

    
    if nargin < 4 || logical(plotflag(1))
        figure 
        set(gcf,'Position',[100 100 1200 800],'paperpositionmode','auto')
    
        pylim = [nanmin(reshape(real(pxx),1,[])),nanmax(reshape(real(pxx),1,[]))];
        %titletext = {'Raw','Local DFT','IFFT','Shapeless'};
        titletext = {'Raw','Linear','Exponential','Average'};
        ylim = 1.5*max([setup.eoModulation,setup.erpMagnitude]);
        spot = reshape(1:(2*5),2,5)';
        for fidx = 1 : size(filtered,1)
            subplot(4,2,spot(fidx,1))
            hold on
            plot(e,'color',[.8 .8 .8],'linewidth',3)
            plot(filtered(fidx,:))    
            title(titletext{fidx})
            if fidx < 2
                set(gca,'ylim',[-max(abs(t)), max(abs(t))])
            else
                set(gca,'ylim',[-ylim, ylim])
            end


            subplot(4,2,spot(fidx,2))
            plot(setup.Foi,real(pxx(fidx,:)))
            grid on
            set(gca,'ylim',[pylim])
            title(titletext{fidx})
        end
    end
    
end
