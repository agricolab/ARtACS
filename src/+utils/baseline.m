%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [output] = baseline(input,window)
% 
% 1 = difference relative to baseline +- magnitude
% 2 = percent relative to baseline +-%
% 3 = std relative to baseline +-
% 4 = ratio relative to baseline [0 Inf]
% written by Robert Bauer for CIN AG NPT 27.04.2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output] = baseline(input,baselinerange,mode)

if isempty(baselinerange), 
    %warning('No Baseline specified'); 
    output = input;
    return;
end
if any(size(input)==0); return; end;
if nargin <2, baselinerange = 1:size(input,2); end;
if nargin <3, mode = 1;  end;
if size(input,2) < max(baselinerange), input = input'; end
output = zeros(size(input));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mode ==1,
    output = input - repmat(nanmean(input(:,baselinerange),2),1,size(input,2));
elseif mode==2,
    bl = repmat(nanmean(input(:,baselinerange),2),1,size(input,2));
    output = (input - bl)./bl;
elseif mode==3,
    bl = repmat(nanmean(input(:,baselinerange),2),1,size(input,2));
    output = (input - bl)./bl;
    output = output./repmat(nanstd(output,1,2),1,size(input,2));
elseif mode==4,
    bl = repmat(nanmean(input(:,baselinerange),2),1,size(input,2));
    output = input./bl;    
elseif mode==5,
    output = input - repmat(nanmin(input(:,baselinerange),[],2),1,size(input,2));
end
end
