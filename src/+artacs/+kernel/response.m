%function response(h,Fs) 
function response(Kernel,plot_flag,foi,fig_hdl)   
    if nargin < 3, foi = 100; end
    if nargin < 2, plot_flag = 1; end
    
    if length(foi) == 1
        [H,w]   = freqz(Kernel.h,1,0:.01:foi,Kernel.Fs);
    elseif length(foi) == 2
        [H,w]   = freqz(Kernel.h,1,linspace(foi(1),foi(2),100),Kernel.Fs);
    else
        [H,w]   = freqz(Kernel.h,1,foi,Kernel.Fs);
    end
    
    N       = length(Kernel.h);           

    % plot 
    if nargin < 4
        figure
        set(gcf,'Position',[100 100 800 800],'paperpositionmode','auto')    
    else
        figure(fig_hdl)
    end
    
    if plot_flag == 1        
        plotKernel(Kernel.h,N)
    end
            
    if plot_flag == 2        
        plotMag(w,H) 
    end
   
    if plot_flag == 3        
        plotPhase(w,H)
    end
        
end

function plotKernel(h,N)    
    h(h==0) = NaN;
    stem([1:1:N],h,'color','k','linewidth',1)    
    if N < 2
        xtick = N;
    else
        xtick = linspace(0,N-1,11);
    end    
    set(gca,'YLim',[min(h)-.1,max(h)+.1],'XTICK',xtick,'XLIM',[0 N+1],'XTICKLABEL',xtick-mean(xtick));
    xlabel('Samples (n)')
    ylabel('Magnitude Response (a.u.)')
end
    
function plotMag(w,H)
    plot(w,20*log10(abs(H)),'color','k','linewidth',1)    
    set(gca,'YLIM',[-30 10])
    xlabel('Frequency (Hz)')
    ylabel('Magnitude Response (dB)')
    grid on   
end

function plotPhase(w,H)
    phiLag = ((angle(H))/(pi)*180);  
    plot(w,(mod(phiLag,-360)),'color','k','linewidth',1)    
    xlabel('Frequency (Hz)')
    ylabel('Phase Response (\phi�)')
    grid on
end