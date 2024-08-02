clear all
close all

%initial conditions 
ti=0;
tf=3;
vi=5;
xi=0;
n=100;
h=(tf-ti)/n;

%working equations
ddxt=@(tl,xl,vl) ((tl^3)-(5*vl)-(3*xl));
dxt=@(tl,xl,vl) vl;

[X,T]=RK4(ti,xi,vi,ddxt,dxt,n,h);
plot(T,X)
