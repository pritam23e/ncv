function ep= ENCRYPTER(strl)
    %string to array
    b= double(strl);
    wl=length(b);
    e=b;
    %key
    ln=500;
    Nk=randi([2,5]);
    kn = randi([1, ln], 1, Nk);
    %Message encryption 
    for i=1:Nk
        % Convert number to array of digits
        p=KEY(kn(i));
        keya= arrayfun(@str2double, num2str(p));       
        kl=length(keya);
        for i=1:kl
            for j=1:wl
                e(j)=e(j)+keya(i);
            end   
        end
    end
    %encrypt the key
    par=(kn+23)+5+02; 
    para=arrayfun(@str2double, num2str(par)); 
    g=length(para); 
    para=[para,g]; 
    para=para+34; 
    enck=char(para); 
    
    %convert the array back to character code  

    code= char(e); 
    code=strcat(code,enck); 
    ep= code;
end
