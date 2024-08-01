clear all
close all

% Parameters
ti = 0;         % Initial time
x_0 = 0;       % Initial value of x (x)
x1_0 = 5;       % Initial value of x' (x1)
tf= 3;     % End time
N=10000;

% Initialize Function
ddx=@(xl,x1l,tl) tl^3 - 5*x1l - 3*xl;
[C,D]=EULER(ti,x_0,x1_0,tf,ddx,N);
plot(D,C)
C(N+1)

