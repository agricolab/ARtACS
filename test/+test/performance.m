function KX  = performance(filteredSig,trueSig,rep_num,pick_num,eoflag,fig_hdl)
    
    trueSig = sum(trueSig,1);
    if nargin <4, eoflag = false; end
    if eoflag, trueSig = abs(hilbert(sum(trueSig,1))); end
    
    filter_num  = size(filteredSig,1);    
    trl_num     = size(filteredSig,3);    
    if nargin < 3, rep_num      = min(100,trl_num); end
    if nargin < 4, pick_num      = min(100,trl_num); end
    
    % Perform Kernel Density Estimation
    KX = [];
    koi     = 0:0.01:1;        
    for fidx = 1 : filter_num
        r       = zeros(rep_num,1);
        if ~eoflag
            for rep = 1 : rep_num
                pick    = datasample(1:trl_num,pick_num);             
                mx      = squeeze(mean(filteredSig(fidx,:,pick),3))';
                r(rep)  = corr(mx,trueSig(:));
            end 
        elseif eoflag
            for rep = 1 : rep_num
                pick    = datasample(1:trl_num,pick_num);             
                mx      = squeeze(mean(abs(hilbert(filteredSig(fidx,:,pick))),3))';
                r(rep)  = corr(mx,trueSig(:));
            end           
        end
        kx = ksdensity(r,koi,'width',0.01);
        kx = kx./sum(kx);
        KX = cat(1,KX,kx);
    end
   
    % Plot Results
    if nargin < 6, fig_hdl = figure; end
    figure(fig_hdl)
    set(fig_hdl,'Position',[100 100 600 800],'paperpositionmode','auto')

    taxis       = 1:length(trueSig);      
    titletext = {'Raw','Average','Linear','Exponential','Gaussian'};
    %spot        = reshape(1:(2*5),2,5)';
    spot        = reshape(1:(1*5),1,5)';
    pick    = datasample(1:trl_num,pick_num);  
    for fidx = 1 : filter_num
        subplot(5,1,spot(fidx,1))
        hold on            
        plot(koi,KX(fidx,:))    
        title(titletext{fidx})
        set(gca,'ylim',[0 .25])
        xlabel('R�')
        ylabel('kde')

%         subplot(5,2,spot(fidx,2))
%         plot(trueSig,'color',[.8 .8 .8],'linewidth',3)            
%         hold on
%         if ~eoflag 
%             my = mean(filteredSig(fidx,:,pick),3);                    
%         elseif eoflag                 
%             my  = mean(abs(hilbert(filteredSig(fidx,:,pick))),3);
%             my  = my-min(my);
%         else
%             error('PERF:PlOT','I do not know whether you want to plot oscillations as amplitudes or wave');
%         end
%         plot(taxis,my)
%         grid on       
%         title(titletext{fidx})
%         ylim = ceil(max(abs(my)));
%         set(gca,'ylim',[-ylim ylim])
%         xlabel('Time')
%         ylabel('Amplitude')
    end
    
end
    