function ERP = mcs2vec(filename,setup)
stg_Fs          = 1*10^6;
dec_factor      = stg_Fs/setup.Fs;


%fclose('all');
fid =  fopen(filename,'rt');
%[filename,permission,machinefmt,encodingOut] = fopen(fid)
%% read Stimulation Signal from file
parse_flag  = false;
StimSig     = [];
linecount   = 0;
frewind(fid)
while ~feof(fid)
    linecount = linecount+1;
    fgetl(fid);  
end
L           = linecount;
linecount   = 0;
frewind(fid)
while ~feof(fid)
    tline       = fgetl(fid);
    linecount   = linecount+1;
    if parse_flag
        delim   = regexp(tline,'\s');
        value   = str2num(tline(1:delim-1));
        time    = str2num(tline(delim+1:end));
        dec_time = (time./dec_factor);
        for t = 1:dec_time, StimSig = [StimSig,value]; end
    end    
    if ~parse_flag, parse_flag = strcmpi(tline,'value	time'); end
    if linecount == (L-1), parse_flag = false; end
end
%% resample Stimulation Signal
% ERP = StimSig;
% stg_Fs          = 1*10^6;
% dec_factor      = stg_Fs/setup.Fs;
% down_StimSig    = (StimSig(1:dec_factor:end));
% 
% 
 time_vec        = setup.toi(1):(1/setup.Fs):setup.toi(2)-(1/setup.Fs);
 [~,trig_time]   = sort(abs(time_vec));
 trig_time       = trig_time(1);
 L               = length(time_vec);
 ERP             = zeros(L,1);
 %ERP(trig_time:trig_time+length(down_StimSig)-1) = down_StimSig;
 ERP(trig_time:trig_time+length(StimSig)-1) = StimSig;