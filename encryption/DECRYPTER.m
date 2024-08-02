function dp= DECRYPTER(strl)
    c= double(strl); 
    cl=length(c);
    %key decryption 
    kl=c(cl);
    c = c(1:end-1);
    kl=kl-34;
    keyd=c(end-(kl-1):end);
    c = c(1:end-kl);
    ktd=keyd;
    for i=1:kl
        if ktd(i)==32
            keyd(i)=-1;
        else
            keyd(i)=keyd(i)-34;
        end
    end
    numStr = arrayfun(@(x) num2str(x), keyd, 'UniformOutput', false);      
    concatenatedStr = strjoin(numStr,'' ); 
    delimiter = {'-1-1-1','-1-1'};
    stringArray = strsplit(concatenatedStr, delimiter); 
    numericArray = str2double(stringArray); 
    
    keyn=((numericArray-02)-5)-23;
    d=c;
    dl=length(d);
    Nk=length(keyn);
    %Code Decryption 
    for l=1:Nk
        p=KEY(keyn(l));
        % Convert number to array of digits
        keyad= arrayfun(@str2double, num2str(p));
        kld=length(keyad);
        for i=1:kld
            for j=1:dl
                d(j)=d(j)-keyad(i);
            end  
        end
    end
    decode= char(d);
    dp=decode;
end

    
