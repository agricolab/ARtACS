%function response(h,Fs) 
function response(h,Fs,plot_flag)   
    [H,w]   = freqz(h,1,0:.01:100,Fs);
    
    N  = length(h);    
    
    
    if nargin < 3
        plot_flag = 2;
    end
    
    
    figure
    set(gcf,'Position',[100 100 800 800],'paperpositionmode','auto')
    
    subplot(plot_flag,1,1)   
    plotKernel(h,N)    
    
    if plot_flag > 1
        subplot(plot_flag,1,2)
        plotMag(w,H) 
    end
    
    if plot_flag > 2
        subplot(plot_flag,1,3)
        plotPhase(w,H)
    end
    
    
end

function plotKernel(h,N)    
    h(h==0) = NaN;
    stem([1:1:N],h,'color','k','linewidth',2)    
    if N < 2
        xtick = N;
    else
        xtick = linspace(0,N-1,11);
    end    
    set(gca,'YLim',[min(h)-.1,max(h)+.1],'XTICK',xtick,'XLIM',[0 N+1]);
    xlabel('Samples (n)')
    ylabel('Magnitude Response (a.u.)')
end
    
function plotMag(w,H)
    plot(w,20*log10(abs(H)),'color','k','linewidth',1)    
    xlabel('Frequency (Hz)')
    ylabel('Magnitude Response (dB)')
    grid on   
end

function plotPhase(w,H)
    phiLag = ((angle(H))/(pi)*180);  
    plot(w,(mod(phiLag,-360)),'color','k','linewidth',1)    
    xlabel('Frequency (Hz)')
    ylabel('Phase Response (\phi°)')
    grid on
end