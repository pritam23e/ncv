clear all
close all
%initial conditions 
ti=0;
tf=3;
vi=5;
xi=0;

%step
n=100;
h=(tf-ti)/n;

%working equations
ddxt=@(tl,xl,vl) ((tl^3)-(5*vl)-(3*xl));
dxt=@(tl,xl,vl) vl;

t(1)=ti;
x(1)=xi;
v(1)=vi;

for i =1:n
  k1=h*ddxt(t(i),x(i),v(i));
  l1=h*dxt(t(i),x(i),v(i));
  k2=h*ddxt(t(i)+(h/2),x(i)+(l1/2),v(i)+(k1/2));
  l2=h*dxt(t(i)+(h/2),x(i)+(l1/2),v(i)+(k1/2));
  k3=h*ddxt(t(i)+(h/2),x(i)+(l2/2),v(i)+(k2/2));
  l3=h*dxt(t(i)+(h/2),x(i)+(l2/2),v(i)+(k2/2));
  k4=h*ddxt(t(i)+(h),x(i)+(l3),v(i)+(k3));
  l4=h*dxt(t(i)+(h),x(i)+(l3),v(i)+(k3));  
  
  v(i+1)=v(i)+(1/6)*(k1+(2*k2)+(2*k3)+k4);
  x(i+1)=x(i)+(1/6)*(l1+(2*l2)+(2*l3)+l4);
  
  t(i+1)=t(i)+h;
 
  

end
plot(t,x)
grid
