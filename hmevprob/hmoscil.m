% SHM OSCILLATOR
clear all
close all
% Initialize Function
ddy=@(xl,yl,y1l,El) (0.5*xl^2)*yl-El*yl;

% Parameters
xi = -pi;         % Initial time
y_0 = 0;       % Initial value of x (x)
y1_0 = 1;       % Initial slope x' (x1)
y_f=0;          %Final value of x
xf= pi;     % End time
N=1000;    %Number of iterations for Euler

%Eigen value conditions
dn=0.1;
Ei=0;
Ef=6;
Eo=Ei:dn:Ef;
k=length(Eo);
%Eigen value finder
[E,Ev]=bisectHM(k,Eo,xi,y_0,y1_0,xf,ddy,N);
E
Ne=length(E)
%Plotter
for i=1:Ne
    [Y,X]=Rk4HM(xi,xf,y_0,y1_0,ddy,N,E(i));
    shift=5;
    if i>1
        Y=Y+i*shift;
    end
    plot(X,Y)
    hold on
    % Shade the area between the curve and the new x-axis (y=10)
    if i==1
        patch([X, fliplr(X)], [shift*0*ones(size(X)), fliplr(Y)], [0, 0, 1], 'FaceAlpha', 0.1);
    else
        patch([X, fliplr(X)], [shift*i*ones(size(X)), fliplr(Y)], [0, 0, 1], 'FaceAlpha', 0.1);                
    end
    legends{i}=(strcat(num2str(i-1),'th excited state','   E=',num2str(E(i))));             
end
Z=X.^2;
Z=Z.*(Ne-1);
plot(X,Z,'LineWidth', 2)
legend([legends,{ 'curve'}],'Location', 'best')
grid
xlabel('x ');
ylabel('y ');
title('Solution of potential well');
xlim([-4 4])

