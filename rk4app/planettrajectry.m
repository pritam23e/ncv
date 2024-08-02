%Trajectory of the planet (RK4)

clear all
close all

%initial values
years=1;
ti=0;
tf=years*1.039*31536000;
xi=1.5*10^11;
yi=0;
vxi=0; 
vyi=3*10^4; 
G=6.674*10^(-11);
M=1.989*10^30; 

%steps
h=3600;
n=(tf-ti)/h;

%working equations 
ddxvat=@(tl,xl,vl,yl) -G*M*xl/((xl^2+yl^2)^(3/2));
dxvat=@(tl,xl,vl,yl) vl;
ddyvat=@(tl,yl,vl,xl) -G*M*yl/((xl^2+yl^2)^(3/2));
dyvat=@(tl,yl,vl,xl) vl;

%arrays

tvac(1)=ti;
x_vac(1)=xi;
vx_vac(1)=vxi;
y_vac(1)=yi;
vy_vac(1)=vyi; 

for i =1:n
    k1=h*ddxvat(tvac(i),x_vac(i),vx_vac(i),y_vac(i));
    l1=h*dxvat(tvac(i),x_vac(i),vx_vac(i),y_vac(i));
    k2=h*ddxvat(tvac(i)+(h/2), x_vac(i)+(l1/2), vx_vac(i)+ (k1/2),y_vac(i)+(l1/2) );
    l2=h*dxvat(tvac(i)+(h/2),x_vac(i)+(l1/2), vx_vac(i)+ (k1/2),y_vac(i)+(l1/2) );
    k3=h*ddxvat(tvac(i)+(h/2), x_vac(i)+(l2/2), vx_vac(i)+ (k2/2), y_vac(i)+(l2/2));
    l3=h*dxvat(tvac(i)+(h/2), x_vac(i)+(l2/2), vx_vac(i)+ (k2/2), y_vac(i)+(l2/2));
    k4=h*ddxvat(tvac(i)+(h), x_vac(i)+(l3), vx_vac(i)+ (k3), y_vac(i)+(l3));
    l4=h*dxvat(tvac(i)+(h), x_vac(i)+(l3), vx_vac(i)+ (k3), y_vac(i)+(l3));  
    
    vx_vac(i+1)=vx_vac(i)+(1/6)*(k1+(2*k2)+(2*k3)+k4);
    x_vac(i+1)=x_vac(i)+(1/6)*(l1+(2*l2)+(2*l3)+l4);
    
    k1=h*ddyvat(tvac(i),y_vac(i),vy_vac(i), x_vac(i));
    l1=h*dyvat(tvac(i),y_vac(i),vy_vac(i), x_vac(i));
    k2=h*ddyvat(tvac(i)+(h/2), y_vac(i)+(l1/2), vy_vac(i)+ (k1/2), x_vac(i)+(l1/2) );
    l2=h*dyvat(tvac(i)+(h/2),y_vac(i)+(l1/2), vy_vac(i)+ (k1/2), x_vac(i)+(l1/2));
    k3=h*ddyvat(tvac(i)+(h/2), y_vac(i)+(l2/2), vy_vac(i)+ (k2/2), x_vac(i)+(l2/2));
    l3=h*dyvat(tvac(i)+(h/2), y_vac(i)+(l2/2), vy_vac(i)+ (k2/2), x_vac(i)+(l2/2) );
    k4=h*ddyvat(tvac(i)+(h), y_vac(i)+(l3), vy_vac(i)+ (k3), x_vac(i)+(l3));
    l4=h*dyvat(tvac(i)+(h), y_vac(i)+(l3), vy_vac(i)+ (k3), x_vac(i)+(l3));  
    
    
    vy_vac(i+1)=vy_vac(i)+(1/6)*(k1+(2*k2)+(2*k3)+k4);
    y_vac(i+1)=y_vac(i)+(1/6)*(l1+(2*l2)+(2*l3)+l4);
    tvac(i+1)=tvac(i)+h;     
end
plot(x_vac,y_vac)
grid
xlabel('x ');
ylabel('y ');
title('Trajectory of the planet (RK4)');
