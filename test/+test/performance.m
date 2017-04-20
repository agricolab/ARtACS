function [k,a,r] = performance(filteredSig,trueSig,rep_num,plotflag)
    
    
        
    if size(trueSig,2) == size(filteredSig,3)
        eoflag = true;
    else
        eoflag = false;
    end
        
    trl_num     = size(filteredSig,3);
    if nargin < 3, rep_num     = min(100,trl_num); end
    filter_num  = size(filteredSig,1);    
        
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
                my      = squeeze(mean(abs(hilbert(trueSig(:,pick))),2));
                r(rep)  = corr(mx,my);
            end           
        end
        kx = ksdensity(r,koi,'width',0.01);
        kx = kx./sum(kx);
        KX = cat(1,KX,kx);

    end
   
    
    if nargin < 4 || logical(plotflag(1))
        figure 
        set(gcf,'Position',[100 100 1200 800],'paperpositionmode','auto')

        taxis       = 1:length(trueSig);
        %titletext   = {'Raw (One Trial)','Adaptive DFT','I-FFT','Causal SMA'};       
        titletext = {'Raw','Average','Linear','Exponential','Gaussian'};
        spot        = reshape(1:(2*5),2,5)';
        for fidx = 1 : filter_num
            subplot(5,2,spot(fidx,1))
            hold on            
            plot(koi,KX(fidx,:))    
            title(titletext{fidx})
            set(gca,'ylim',[0 .25])
            xlabel('R²')
            ylabel('kde')

            subplot(5,2,spot(fidx,2))
            if ~eoflag
                plot(trueSig,'color',[.8 .8 .8],'linewidth',3)            
                hold on
                if fidx == 1
                    plot(taxis,mean(filteredSig(1,:,1),3))
                else
                    plot(taxis,mean(filteredSig(fidx,:,:),3))
                end
            else
                plot(mean(abs(hilbert(trueSig)),2),'color',[.8 .8 .8],'linewidth',3)            
                hold on
                my  = mean(abs(hilbert(filteredSig(fidx,:,:))),3);
                my  = my-min(my);
                plot(taxis,my)
            end
            grid on       
            title(titletext{fidx})
            xlabel('Time')
            ylabel('Amplitude')
        end
    end
    
    
    
end
    