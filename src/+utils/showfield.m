% makes plots of potentials on head
% usage showfield(z,loc,scale, markersize,resolution, cbar) ;
%
% input:
%  z  values of field/potential to be shown.
%  loc   matrix containing 2D coordinates of channels in second and third column 
%  scale sets the scale of the color map. Either a 1x2 vector
%            corresponding to minimum and a maximum or just a number (say x) 
%            then the scale is from [-x x]. The default is 
%            {=[ -max(abs(z)) max(abs(z)) ]}
%  markersize is the size of the markers for the original channels
%  resolution sets the resolution, {100}
%  cbar=1 draws colorbar, otherwiseno colorbar is not shown. {1}
%   rewritten by R.Bauer & M.Vukelic for CIN AG NPT 22.06.2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function showfield(z,loc,scale,thr,markersize,resolution,interpolmode,cbar,hilite,tit,interpolwindow) 


if nargin <3, scale=[-max(max(abs(z))),max(max(abs(z)))]; end;
if nargin <4, thr   = 0; end;
if nargin <5, markersize = 24; end;
if nargin <6, resolution=100; end;
if nargin <7, interpolmode = 1; end;
if nargin <8, cbar=0; end;
if nargin <9 || any(hilite==0),   hi_idx = zeros(size(loc,1),1);else hi_idx = zeros(size(loc,1),1); hi_idx(hilite) = true; end
if nargin <10, tit= ''; end;
if nargin <11, interpolwindow = mean(sqrt(sum((loc).^2,2))); end; %average euclidean distance of sensors
if length(scale) == 1, scale = [min([scale, -scale]) max([scale, -scale])]; end



[~,m]=size(loc);
if m==2;
  x=loc(:,1);
  y=loc(:,2);
else
  x=loc(:,2);
  y=loc(:,3);
end

xlin = linspace(1.4*min(x),1.4*max(x),resolution);
ylin = linspace(1.4*min(y),1.4*max(y),resolution);
[X,Y] = meshgrid(xlin,ylin);

Z   = griddata(x,y,z,X,Y,'nearest');
HI  = griddata(x,y,hi_idx,X,Y,'nearest');
a   = fix(resolution*interpolwindow); a = a+mod(a,2);
if interpolmode == 1,
    %Z   = griddata(x,y,z,X,Y,'cubic');%
    Z = smooth2D(Z,repmat(a,1,2),2,'replicate');     
    %Z = smooth2D(Z,repmat(a,1,2),2,'none');   
end

% Take data within head

rmax=1.02*max(sqrt(x.^2+y.^2));
mask = (sqrt(X.^2+Y.^2) <= rmax);
Z(mask == 0) = NaN;
HI(mask == 0) = NaN;

% plot stuff
cla  
surface(X,Y,zeros(size(Z)),Z,'edgecolor','none');shading interp;
hold on
if any(any(abs(Z)>thr)),
    contour(X,Y,abs(Z)>thr,1,'color',[.1 .1 .1]+0,'linewidth',4);
end
if any(hi_idx),
    contour(X,Y,HI>0,1,'color',[1 0 0]+0,'linewidth',2,'linestyle','-');
end
hold off
%caxis([ - max(abs(z)) max(abs(z))]);
caxis(scale);
hold on;
plot(x,y,'.k','markersize',markersize);


%meanx=mean(loc(:,2)*.85+.45);
%meany=mean(loc(:,3)*.85+.45);
scalx=1;
drawhead(0,.0,rmax,scalx);
set(gca,'visible','off');

axis([-1.2*rmax 1.2*rmax -1.0*rmax 1.4*rmax]);
axis equal;
%axis([-1.4*rmax 1.4*rmax -1.0*rmax 1.4*rmax]);
if cbar==1
  h=colorbar;set(h,'fontweight','bold')
end


annotation('textbox','position',[0 0 1 1],'edgecolor','None','HorizontalAlignment','center','string',tit)

%plot(.985*rmax*sin((0:1000)/1000*2*pi), .985*rmax*cos((0:1000)/1000*2*pi),'linewidth',2,'color','k'); 
end 



function drawhead(x,y,size,scalx)

cirx=(x+scalx*size*cos((1:1000)*2*pi/1000) )';ciry=(y+size*sin((1:1000)*2*pi/1000))';

plot(cirx,ciry,'k','linewidth',1);
hold on;

ndiff=20;
plot( [x  cirx(250-ndiff) ],[y+1.1*size ciry(250-ndiff)],'k','linewidth',1);
plot( [x  cirx(250+ndiff) ],[y+1.1*size ciry(250+ndiff)],'k','linewidth',1);


end

% output = smooth2D(input,window,mode,padding)
% window should be specified as [dim1,dim2]
% mode 1: boxcar
% mode 2: gauss
% mode 3: parzen
% mode 4: hanning
% mode 7: gauss/exp
function output = smooth2D(input,window,mode,paddingy,paddingx)
    
    if nargin <3, mode = 1; end
    if nargin <4, paddingy = 'replicate'; end
    if nargin <5, paddingx = 'circular'; end
    if mode == 1, 
        filt = ones(window(1),1)*ones(window(2),1)';        
        filt = filt./numel(filt);
    elseif mode == 2, 
       filt =  gausswin(window(1))*gausswin(window(2))';
    elseif mode == 3, 
       filt =  parzenwin(window(1))*parzenwin(window(2))';
    elseif mode == 4,
       filt =  hanning(window(1))*hanning(window(2))';    
    elseif mode == 5,
       filt =  boxcar(window(1))*parzenwin(window(2))'./window(1);    
    elseif mode == 6,
       filt =  boxcar(window(1))*parzenwin(window(2))'./window(1);
    elseif mode ==7,
        filt =  gausswin(window(1))*exp(1:window(2));
    end
    filt    = filt./sum(sum(filt));
    if ~strcmp(paddingx,'none') || ~strcmp(paddingy,'none') ,
        %output  = convn(padarray(input,window./2,padding),filt,'same');
        %output  = output(1+(window(1)./2):end-window(1)/2,1+(window(2)./2):end-window(2)/2);
        filt    = filt./sum(sum(filt));
        tmp     = padarray(padarray(input,[0,window(2)./2],paddingx),[window(1)./2,0],paddingy);
        output  = convn(tmp,filt,'same');
        output  = output(1+(window(1)./2):end-window(1)/2,1+(window(2)./2):end-window(2)/2);
    else
        output  = convn(input,filt,'same');
    end
end
