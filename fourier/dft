%Discreet Fourier Transform 
clear all
close all

ti=0;
tf=01;
N=500;
delt=(tf-ti)/N;

w0=2*pi/N;
w=linspace(w0,2*pi,N);
t=linspace(ti,delt*N,N);
ft=(sin(25*pi.*t));
fw=zeros(1,N);
fwo=0;

for n=1:N
  for k=1:N
    fwo=fwo+ft(k)*exp(-i*w0*n*k);
  end
  fw(n)=fwo;
  fwo=0; 
end

subplot(2,1,1)
plot(t,ft)
title("function ")

subplot(2,1,2)
plot(w,abs(fw))
title("fourier transform")

