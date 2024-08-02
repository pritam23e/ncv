clear all
close all
r=3.5;
xi=0.9;
N=100;
x(1)=xi;
t=linspace(1,N,N);

for i= 1:N-1
    x(i+1)=r*x(i)*(1-x(i));
end
plot(t,x)
