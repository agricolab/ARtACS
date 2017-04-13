function response(h,Fs)   
    [H,w]   = freqz(h,1,0:.5:100,Fs);
    
    N  = length(h);    
    figure
    set(gcf,'Position',[100 100 800 800],'paperpositionmode','auto')
    subplot(3,1,1)    
    stem([1:1:N],h)
    if N<2,
        xtick = N;
    else
        xtick = linspace(0,N-1,6);
    end
    set(gca,'YLim',[min(h)-1,max(h)+1],'XTICK',xtick,'XLIM',[0 N+1]);
    xlabel('Samples (n)')
    ylabel('Magnitude Response (a.u.)')
    
    subplot(3,1,2)
    plot(w,20*log10(abs(H)))
%    set(gca,'YLim',[-100 20],'XTick',[0:10:100]);
    xlabel('Frequency (Hz)')
    ylabel('Magnitude Response (dB)')
    grid on
    
    
    subplot(3,1,3)
    phiLag = ((angle(H))/(pi)*180);
  %  plot(w,(mod(phiLag,-360)))
    plot(w,(mod(phiLag,-360)))
  %  set(gca,'YLim',[-360 360],'XTick',[0:10:100],'YTICK',[-360:90:360],'XLIM',[0 100]);
    xlabel('Frequency (Hz)')
    ylabel('Phase Response (\phi°)')
    grid on
end