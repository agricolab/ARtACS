function static(codepath)

if any(regexp(computer,'WIN','once'))
    if isempty(regexp(codepath,'[A-Z]:\', 'once'))
        codepath = [pwd,filesep,codepath,filesep];
    end
end

DList = {};
DList = rdir(codepath,DList);

MList = {}; 
MList = collect(DList,MList);
listlint(MList)

PList = {};
FList = {};
[PList,FList]   = packlist(MList,PList,FList);

packcheck(FList,MList)
tboxcheck(PList)
end
%% recursive dir
function DList = rdir(codepath,DList)    
    D = dir([codepath,'.']);
    for d = 1 : length(D)
        if (D(d).isdir)
            if strcmpi(D(d).name,'..'),continue; end
            if strcmpi(D(d).name,'.'), DList = cat(1,DList,D(d).folder); continue; end
            DList = cat(1,DList,rdir([D(d).folder,filesep,D(d).name],DList));
        end
    end
    DList = unique(DList);
end
%% Collect files 
function MList = collect(DList,MList)
    for d_idx = 1 : length(DList)       

        L       = length(MList);
        M       = dir([DList{d_idx},filesep,'*.m']);
        MList   = cat(1,MList,cell(length(M),1));
        for m_idx = 1 : length(M)
            MList{m_idx+L} = [DList{d_idx},filesep,M(m_idx).name];
        end

    end
    MList = unique(MList);
end
%% linter
function listlint(MList)
x = evalc('mlint(MList)');
if isempty(x)
    disp('Linter did not complain');   
else
    clc
    disp(x)
end
end

%% Check Dependencies
function [PList,FList] = packlist(MList,PList,FList)

    for m_idx = 1 : length(MList)
        [fList,pList] = matlab.codetools.requiredFilesAndProducts(MList(m_idx));
        PList = [PList,pList.Name];
        FList = [FList,fList];
    end
    PList = unique(PList);
    FList = unique(FList)';
end

%% 
function tboxcheck(PList)
    PList = unique(PList);
    % Excluding built-in functions
    TList = {}; %Toolbox dependencies
    for p_idx = 1 : length(PList)
        a = regexp(PList(p_idx),('toolbox+.+local'));
        if isempty(a{1})
            TList = cat(1,TList,PList(p_idx));     
        end
    end
    TList = unique(TList);
    TList(ismember(TList,'MATLAB')) = [];
    disp(table(TList,'VariableNames',{'RequiredMatlabToolboxes'}))
end

%%
function packcheck(FList,MList)
    MList       = unique(MList);
    FList       = unique(FList);
    unused      = FList(~ismember(FList,MList));
    unpacked    = MList(~ismember(MList,FList));
    
    if ~isempty(unused)
        disp(table(unused,'VariableNames',{'Uncalled'}))
    else
        disp(table({'Nothing'},'VariableNames',{'Uncalled'}))
    end
    
    if ~isempty(unpacked)        
        disp(table(unpacked,'VariableNames',{'Unpackaged'}))
    else        
        disp(table({'Nothing'},'VariableNames',{'Unpackaged'}))
    end
    
    
    disp(table(MList,'VariableNames',{'Packaged'}))
end
