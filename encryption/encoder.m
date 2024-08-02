clear all
close all
s=input("Enter Your SECRET MESSAGE=",'s');
ecode=ENCRYPTER(s); 
disp("Encrypted Code=");
fprintf('%s\n', "  ");
fprintf('%*s%s\n',10,'',ecode);
