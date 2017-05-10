function erp = data2trials(data,toi,bl)
    raw             = squeeze(cat(3,data.trial{:}));

    % estimate raw erp
    toiA            = find(data.time{1}>=toi(1),1);
    toiB            = find(data.time{1}>=toi(2),1)-1;    
    erp             = raw(toiA:toiB,:);
    
    %estimate baseline    
    blA            = find(data.time{1}>=bl(1),1);
    blB            = find(data.time{1}>=bl(2),1)-1;    
    blm            = (repmat(mean(raw(blA:blB,:),1),size(erp,1),1));
    
    % perform baseline correction
    erp             = erp-blm;
end
