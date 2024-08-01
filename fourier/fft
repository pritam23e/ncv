%Fast Fourier Transform

clear all
close all

delt=0.01;
N=16;
t=linspace(0,delt*N,N);
ft=cos(25*pi*t);
fw=zeros(1,N);
fwe=0;
fwo=0;
w0=2*pi/N;
w=linspace(w0,2*pi,N);
for n=1:N
  for k=1:(N/2-1)
      fwe=fwe+ft(2*k)*exp(-i*w0*2*n*k);
      fwo=fwo+ft(2*k+1)*exp(-i*w0*n*(2*k+1));      
  end
  fw(n)=fwe+fwo; 
  fwo=0;
  fwe=0;
end

subplot(2,1,1)
plot(t,ft)
title("function ")

subplot(2,1,2)
plot(w,abs(fw))
title("fast fourier transform")


