%Trajectory of projectile (RK4)

clear all
close all

%initial values
ti=0;
xi=0;
yi=0;
g=9.8;
theta=pi/4;%angle of projection
u=10;%initial speed
%Components
vxi=u*cos(theta);
vyi=u*sin(theta);

b=1.5;%drag
w=5;%wind

%steps
n=100000;
h=0.001;

%working equations 
%for vaccum 
ddxvat=@(tl,xl,vl) 0;
dxvat=@(tl,xl,vl) u*cos(theta);
ddyvat=@(tl,xl,vl) -g;
dyvat=@(tl,xl,vl) vl;

%for air drag
ddxdrt=@(tl,xl,vl) 0;
dxdrt=@(tl,xl,vl) u*cos(theta);
ddydrt=@(tl,xl,vl) -g-b;
dydrt=@(tl,xl,vl) vl;

%for airdrag+wind
ddxwit=@(tl,xl,vl) 0;
dxwit=@(tl,xl,vl) u*cos(theta);
ddywit=@(tl,xl,vl) -g-b-w;
dywit=@(tl,xl,vl) vl;




%%VACCUM
[x_vac,tv]=RK4(ti,xi,vxi,ddxvat,dxvat,n,h);
[y_vac,tv]=RK4(ti,yi,vyi,ddyvat,dyvat,n,h);

NNIndex= y_vac > 0;

% Filter the non-negative values from xvac
x_vac = x_vac(NNIndex);
y_vac = y_vac(NNIndex);
tv= tv(NNIndex);

%%AIR RESISTANCE 

[x_drg,tdrg]=RK4(ti,xi,vxi,ddxdrt,dxdrt,n,h);
[y_drg,tdrg]=RK4(ti,yi,vyi,ddydrt,dydrt,n,h);

NNIndex= y_drg > 0;

% Filter the non-negative values from xvac
x_drg = x_drg(NNIndex);
y_drg = y_drg(NNIndex);
tdrg= tdrg(NNIndex);



%%AIR RESISTANCE++WIND

[x_wi,twi]=RK4(ti,xi,vxi,ddxwit,dxwit,n,h);
[y_wi,twi]=RK4(ti,yi,vyi,ddywit,dywit,n,h);

NNIndex= y_wi > 0;

% Filter the non-negative values from xvac
x_wi = x_wi(NNIndex);
y_wi = y_wi(NNIndex);
twi = twi(NNIndex);



plot(x_vac,y_vac)
hold on
plot(x_drg,y_drg)
hold on
plot(x_wi,y_wi)
hold on

grid
legend("vaccum","air resistance","wind")
xlabel('x ');
ylabel('y ');
title('Trajectory of projectile (RK4)');




