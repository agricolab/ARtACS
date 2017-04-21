function performance(filteredSig,trueSig,rep_num,eoflag,plotflag)
    
    trueSig = sum(trueSig,1);
    if nargin <4, eoflag = false; end
    if eoflag, trueSig = abs(hilbert(sum(trueSig,1))); end
    
    filter_num  = size(filteredSig,1);    
    trl_num     = size(filteredSig,3);    
    if nargin < 3, rep_num     = min(100,trl_num); end
        
    
    % Perform Kernel Density Estimation
    KX = [];
    koi     = 0:0.01:1;        
    for fidx = 1 : filter_num
        r       = zeros(rep_num,1);
        if ~eoflag
            for rep = 1 : rep_num
                pick    = datasample(1:trl_num,rep_num);             
                mx      = squeeze(mean(filteredSig(fidx,:,pick),3))';
                r(rep)  = corr(mx,trueSig(:));
            end 
        elseif eoflag
            for rep = 1 : rep_num
                pick    = datasample(1:trl_num,rep_num);             
                mx      = squeeze(mean(abs(hilbert(filteredSig(fidx,:,pick))),3))';
                r(rep)  = corr(mx,trueSig(:));
            end           
        end
        kx = ksdensity(r,koi,'width',0.01);
        kx = kx./sum(kx);
        KX = cat(1,KX,kx);
    end
   
    % Plot Results
    if nargin < 4 || logical(plotflag(1))
        figure 
        set(gcf,'Position',[100 100 1200 800],'paperpositionmode','auto')

        taxis       = 1:length(trueSig);      
        titletext = {'Raw','Average','Linear','Exponential'};
        spot        = reshape(1:(2*4),2,4)';
        for fidx = 1 : filter_num
            subplot(4,2,spot(fidx,1))
            hold on            
            plot(koi,KX(fidx,:))    
            title(titletext{fidx})
            set(gca,'ylim',[0 .25])
            xlabel('R²')
            ylabel('kde')

            subplot(4,2,spot(fidx,2))
            plot(trueSig,'color',[.8 .8 .8],'linewidth',3)            
            hold on
            if ~eoflag
                my = mean(filteredSig(fidx,:,1:rep_num),3);                    
            elseif eoflag
                my  = mean(abs(hilbert(filteredSig(fidx,:,1:rep_num))),3);
                my  = my-min(my);
            else
                error('PERF:PlOT','I do not know whether you want to plot oscillations as amplitudes or wave');
            end
            plot(taxis,my)
            grid on       
            title(titletext{fidx})
            xlabel('Time')
            ylabel('Amplitude')
        end
    end
    
    
    
end
    