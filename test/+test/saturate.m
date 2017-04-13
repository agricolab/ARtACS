function t = saturate(t,ThresholdinPercent)
    threshold   = ThresholdinPercent*max(abs(t));
    t(t>threshold) = threshold;t(t<-threshold) = -threshold;    
end
    