matlabrc 
ftfolder ='C:\Users\Robert Bauer\Documents\Matlab\other_toolboxes\fieldtrip';
cd(ftfolder),system('git pull');
cd('C:\Users\Robert Bauer\OneDrive\Work\publish\wip\ARtACS\')%
addpath(ftfolder);
ft_defaults;
addpath('.\src\')
printfolder = '.\docs\img\';
datafolder = '.\dev\data\median\';
%%
load([datafolder,'SEP.mat'],'trials')
tru = trials;
load([datafolder,'SEP_10Hz.mat'],'trials')
trl = trials;
toi             = 2451:2550;
%
close all
figure
hold on
plot(mean(trl(:,toi),1))
plot(mean(tru(:,toi),1))
%
% Filtering
%
filt_axis       = {'Causal Uniform','Causal Linear','Causal Exponential','Causal Gaussian','Symmetric Uniform','Symmetric Linear','Symmetric Exponential','Symmetric Gaussian','Adaptive DFT','Efferent Copy'};
filt_type       = {'ave','linear','exp','gauss','ave','linear','exp','gauss'};
%sym_type        = {'causal','causal','causal','causal','symmetric','symmetric','symmetric','symmetric'};
%NumberPeriods   = 4;
sym_type        = {'flipped','flipped','flipped','flipped','symflipped','symflipped','symflipped','symflipped'};
NumberPeriods   = 4;
tacsFreq        = 10;
Fs              = 5000;

R               = [];
for tru_idx = 1 : size(tru,1)
    tru(tru_idx,:)  = tru(tru_idx,:)-mean(tru(tru_idx,:));
end
e = mean(tru);
F = [];
for trl_idx = 1 : size(trl,1)
    r = trl(trl_idx,:);
    r = r-mean(r);
    for fidx = 1 : length(filt_type)   
        f                   = artacs.kernel.run(r,NumberPeriods,tacsFreq,Fs,filt_type{fidx},sym_type{fidx});        
        recover             = corr(f(toi)',e(1,toi)');     % true signal -> erp
        R(fidx,trl_idx)     = recover;   
        
        F(fidx,trl_idx,:)   = f;
    end
    f                   = artacs.dft.local(r,tacsFreq,Fs,NumberPeriods);            
    recover             = corr(f(toi)',e(1,toi)');    % true signal -> erp
    
    R(fidx+1,trl_idx)   = recover;
    F(fidx+1,trl_idx,:) = f;
end    
    
koi = 0:0.01:1;
KxR = [];
for fidx = 1 : size(R,1)
    kx = ksdensity(R(fidx,:).^2,koi,'width',0.05);
    kx = kx./max(kx);   
    kx(kx<0.001) =NaN;  
    KxR = cat(1,KxR,kx);        
end
%
close all
figure
set(gcf,'Position',[500 100 700 300],'paperpositionmode','auto')
for fidx = 1 : size(R,1)
    line(fidx+(.25*-KxR(fidx,:)),koi,'color','k');
    line(fidx+(.25*+KxR(fidx,:)),koi,'color','k');
    m = mean(R(fidx,:).^2); 
    line([fidx-.1,fidx+.1],[m,m],'color','b','linewidth',2)         
    m = mean(koi(KxR(fidx,:)>0.95));         
    line([fidx-.1,fidx+.1],[m,m],'color','r','linewidth',2)
end
set(gca,'ylim',[0 1],'ytick',[0:0.2:1],'yticklabel',[0:.2:1])
set(gca,'xlim',[0.5 fidx+.5],'xtick',1:fidx,'xticklabel',filt_axis,'xaxislocation','bottom')
set(gca,'XTickLabelRotation',45)
ylabel('Recovery (R²)')
grid on

figure
hold on
%plot(mean(trl(:,toi),1))
plot(mean(tru(:,toi),1))
plot(squeeze(mean(F(:,:,toi),2))')

%
%%
