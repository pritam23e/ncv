clear all
close all
s=input("Enter Your ENCRYPTED CODE =",'s');
decode=DECRYPTER(s); 
disp("YOUR SECRET Message is=");
fprintf('%s\n', "  ");
fprintf('%*s%s\n',10,'',decode);
