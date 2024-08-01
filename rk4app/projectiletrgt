close all
clear all

    
%Define target parameters
target_width = 1; % width of the target rectangle
target_height = 1; % height of the target rectangle
target_center_x = 20; % x-coordinate of the center of the target
target_center_y = 0; % y-coordinate of the center of the target


%initial values
w=5;%wind
fprintf("the velocity of wind is=%d\n",w);
ti=0;
xi=0;
yi=0;%initial height
fprintf("the height of projection is=%d\n",yi);
g=9.8;
  
%steps
   
n=10000;
h=0.001;

    
% Plot target rectangle
rectangle('Position', [target_center_x - target_width/2, target_center_y - target_height/2, target_width, target_height], 'EdgeColor', 'r', 'FaceColor', 'r');
hold on
angle=input("Give angle of projection");
theta=deg2rad(angle);%angle of projection
u=input("Give velocity of projection");%initial speed
b=1.5;%drag

%for airdrag+wind
ddxwit=@(tl,xl,vl) 0;
dxwit=@(tl,xl,vl) u*cos(theta);
ddywit=@(tl,xl,vl) -g-b-w;
dywit=@(tl,xl,vl) vl;
    
%arrays for airdrag+wind
    
vxi=u*cos(theta);
vyi=u*sin(theta);
%%AIR RESISTANCE++WIND

[x_wi,twi]=RK4(ti,xi,vxi,ddxwit,dxwit,n,h);
[y_wi,twi]=RK4(ti,yi,vyi,ddywit,dywit,n,h);

NNIndex= y_wi > 0;

% Filter the non-negative values from xvac
x_wi = x_wi(NNIndex);
y_wi = y_wi(NNIndex);
twi = twi(NNIndex);
 


%target calculator
% Plot target rectangle
rectangle('Position', [target_center_x - target_width/2, target_center_y - target_height/2, target_width, target_height], 'EdgeColor', 'r', 'FaceColor', 'r');
hold on
nch=length(y_wi);
ych=y_wi(nch); 
xch=target_center_x-x_wi(nch);
if abs(xch)<= (target_width/2) && ych<=(target_height/2)               
    disp("Target hit!!!!")  
else  
    fprintf("target missed by=%d\n",round(xch))     
end
  
plot(x_wi,y_wi)
grid
xlabel('x ');
ylabel('y ');
title('trajectory of projectile (RK4)');
