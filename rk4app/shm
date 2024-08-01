%Simple Harmonic Oscillator:SHM, FORCED, DAMPED (RK4)

close all
clear all
%initial conditions 
ti=0;
tf=40;
vi=1;
xi=0;
k=1;
bd=0.5;
bf=0.5;
A=5; 
w=5;

%step
h=0.1;
n=(tf-ti)/h;

%working equations
%spring
ddxt=@(tl,xl,vl) -k*xl;
dxt=@(tl,xl,vl) vl;

%damping
ddxdat=@(tl,xl,vl) -k*xl-bd*vl;
dxdat=@(tl,xl,vl) vl;

%forced
ddxfdt=@(tl,xl,vl) -k*xl-bf*vl+(1*A*sin(w*tl));
dxfdt=@(tl,xl,vl) vl;


 
[x,t]=RK4(ti,xi,vi,ddxt,dxt,n,h);
[xda,tda]=RK4(ti,xi,vi,ddxdat,dxdat,n,h);
[xfd,tfd]=RK4(ti,xi,vi,ddxfdt,dxfdt,n,h);

plot(t,x)
hold on
plot(tda,xda)
hold on
plot(tfd,xfd)
legend("SHM","Damping","Forced vibration")
xlabel('x ');
ylabel('y ');
title('Simple Harmonic Oscillator (RK4)');
grid



